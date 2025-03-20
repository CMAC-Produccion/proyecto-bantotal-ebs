create or replace package PQ_CR_CENTRAL_RIESGOS is

  -- Author  : SMARQUEZ
  -- Created : 21/06/2016 16:58:30
  -- Purpose : NUEVA CENTRAL DE RIESGOS
  -- Public type declarations
  -- Created : 21/04/2021 16:58:30
  -- Purpose : Adición de Conteo de reprogramaciones CENTRAL DE RIESGOS
  -------------------------------------------------------------
  PROCEDURE SP_DENEGADOS(P_PAIS   IN NUMBER,
                         P_TIPDOC IN NUMBER,
                         P_NUMDOC IN VARCHAR2);
  -------------------------------------------------------------
  PROCEDURE SP_SOBREENDEUDAMIENTO(P_PAIS       IN NUMBER,
                                  P_TIPDOC     IN NUMBER,
                                  P_NUMDOC     IN VARCHAR2,
                                  P_SOBREENDEU OUT VARCHAR2,
                                  P_DIRECTA    OUT NUMBER,
                                  P_POTENCIAL  OUT NUMBER,
                                  P_TOTAL      OUT NUMBER,
                                  P_RESULTADO  OUT NUMBER,
                                  P_NUMENTIDAD OUT NUMBER,
                                  p_existe     OUT NUMBER);
  -------------------------------------------------------------
  PROCEDURE SP_INS_JAQZ567(P_CODSBS IN VARCHAR2, P_FECHA IN DATE);
  -------------------------------------------------------------
  PROCEDURE SP_CONTEO(P_CODSBS IN VARCHAR2,
                      P_TOTAL  OUT NUMBER,
                      P_SCFI   OUT NUMBER);
  -------------------------------------------------------------                      
  PROCEDURE SP_CODIGO(P_NUMDOC IN VARCHAR2, P_CODSBS OUT VARCHAR2);
  -------------------------------------------------------------
  Procedure sp_cr_get_codsbs(pn_tipdoc in number,
                             pc_numdoc in char,
                             pv_codsbs out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_deuda_repro(pn_instance in numeric, pv_rpta out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_deuda_repro2(pn_instance in numeric,
                               pv_rpta     out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_consultaSF(pn_instance in numeric, pv_rpta out number);

end PQ_CR_CENTRAL_RIESGOS;
/

create or replace package body PQ_CR_CENTRAL_RIESGOS is
  -------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_DENEGADOS(P_PAIS   IN NUMBER,
                         P_TIPDOC IN NUMBER,
                         P_NUMDOC IN VARCHAR2) IS
    CURSOR DATOS IS
      SELECT S1.SNG001PAIS,
             S1.SNG001TDOC,
             S1.SNG001NDOC,
             S1.SNG001Inst,
             S1.SNG001cta,
             S2.SNGM01TipM,
             S2.SNGM02MotC,
             S2.SNGM10Come,
             S2.SNGM10User,
             S2.SNGM10Date,
             S2.SNGM10Inst,
             (SELECT F1.SCNOM
                FROM FST046 F4, FST001 F1
               where F4.Pgcod = 1
                 AND F4.Ubuser = S2.sngm10user
                 AND F1.Pgcod = 1
                 AND F1.Sucurs = F4.UBSUC) SUCURSAL,
             (SELECT XWfOperacion
                FROM XWF700
               Where XWFPRCINS = S2.SNGM10Inst
                 and xwfcar3 = '1') OPERACION,
             (SELECT SNGM02Desc
                FROM SNGM02
               Where SNGM01TipM = S2.SNGM01TipM
                 AND SNGM02MotC = S2.SNGM02MotC) DESCRIPCION,
             S2.SNGM10DATE FECHA
        FROM Sng001 S1, Sngm10 S2, FST198 S3
       where S1.SNG001PAIS = P_PAIS
         AND S1.SNG001TDOC = P_TIPDOC
         AND S1.SNG001NDoc = RPAD(P_NUMDOC, 12, ' ')
         AND S2.SNGM10Inst = S1.SNG001INST
         AND S3.Tp1cod = 1
         AND S3.Tp1cod1 = 10849
         AND S3.Tp1corr1 = 12
         AND S3.Tp1corr3 = S2.SNGM01TipM
         AND S3.Tp1nro1 = S2.SNGM02MotC;
  BEGIN
    FOR DAT IN DATOS LOOP
    
      BEGIN
        INSERT INTO JAQY684
          (jaqy684pais,
           jaqy684tdoc,
           jaqy684ndoc,
           jaqy684inst,
           jaqy684tipc,
           jaqy684motc,
           jaqy684com,
           jaqy684user,
           jaqy684suc,
           jaqy684cta,
           jaqy684ope,
           jaqy684desc,
           jaqy684fec)
        VALUES
          (DAT.SNG001PAIS,
           DAT.SNG001TDOC,
           DAT.SNG001NDOC,
           DAT.SNG001INST,
           DAT.SNGM01TIPM,
           DAT.SNGM02MOTC,
           DAT.SNGM10COME,
           DAT.SNGM10USER,
           DAT.SUCURSAL,
           DAT.SNG001CTA,
           DAT.OPERACION,
           DAT.DESCRIPCION,
           DAT.SNGM10DATE);
        COMMIT;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          NULL;
      END;
    END LOOP;
  END SP_DENEGADOS;
  -------------------------------------------------------------------------------------------------------------
   PROCEDURE SP_SOBREENDEUDAMIENTO(P_PAIS       IN NUMBER,
                                  P_TIPDOC     IN NUMBER,
                                  P_NUMDOC     IN VARCHAR2,
                                  P_SOBREENDEU OUT VARCHAR2,
                                  P_DIRECTA    OUT NUMBER,
                                  P_POTENCIAL  OUT NUMBER,
                                  P_TOTAL      OUT NUMBER,
                                  P_RESULTADO  OUT NUMBER,
                                  P_NUMENTIDAD OUT NUMBER,
                                  p_existe     out number) IS
  
    ddirecta  number(17, 2) := 0;
    potencial number(17, 2) := 0;
    lineacre  number(17, 2) := 0;
    impdeuda  number(17, 2) := 0;
    entidades number(10) := 0;
    segmentop number(2) := 0;
    resneto   number(17, 2) := 0;
    cuotaca   number(17, 2) := 0;
    cuotasf   number(17, 2) := 0;
    ingresot  number(17, 2) := 0;
  
  Begin
    Begin
      select decode(jaqy490sob,
                    1,
                    'Cliente expuesto a Riesgo de Sobre endeudamiento',
                    2,
                    'Cliente potencialmente expuesto a riesgo de sobre-endeudamiento',
                    'Cliente no Expuesto a Riesgo de sobre endeudamiento'),
             nvl(jaqy490seg,0),
             nvl(jaqy490rne,0),
             nvl(jaqy490cca,0),
             nvl(jaqy490csf,0),
             nvl(jaqy490tin,0)
        into P_SOBREENDEU, segmentop, resneto, cuotaca, cuotasf, ingresot
        from JAQY490S
       where jaqy490pai = P_PAIS
         and jaqy490tdo = P_TIPDOC
         and jaqy490ndo = rpad(P_NUMDOC, 12, ' ')
         and jaqy490fec = (select max(jaqy490fec) from JAQY490S);
      if P_TIPDOC = 21 then
      
        Begin
          select nvl(jaqy490std,0),
                 nvl(jaqy490cpo,0),
                 nvl(jaqy490lcn,0),
                 nvl(jaqy490dco,0),
                 nvl(jaqy490nen,0)
            into ddirecta, potencial, lineacre, impdeuda, entidades
            from JAQY490
           where jaqy490ndi = P_NUMDOC
             and jaqy490fec = (select max(jaqy490fec) from JAQY490)
             and jaqy490per = 1
             and jaqy490tdi = 1;
          --               and rownum = 1;
        
          P_TOTAL      := ddirecta + lineacre + impdeuda;
          P_DIRECTA    := ddirecta;
          P_POTENCIAl  := potencial; --*100;
          P_NUMENTIDAD := entidades;
        
        Exception
          when too_many_rows then
            select nvl(jaqy490std,0),
                   nvl(jaqy490cpo,0),
                   nvl(jaqy490lcn,0),
                   nvl(jaqy490dco,0),
                   nvl(jaqy490nen,0)
              into ddirecta, potencial, lineacre, impdeuda, entidades
              from JAQY490
             where jaqy490ndi = P_NUMDOC
               and jaqy490fec = (select max(jaqy490fec) from JAQY490)
               and jaqy490per = 1
               and jaqy490tdi = 1
               and jaqy490sbs = (select max(jaqy490sbs)
                                   from JAQY490
                                  where jaqy490ndi = P_NUMDOC);
          
            P_TOTAL      := ddirecta + lineacre + impdeuda;
            P_DIRECTA    := ddirecta;
            P_POTENCIAl  := potencial; --*100;
            P_NUMENTIDAD := entidades;
          when no_data_found then
            Begin
              select nvl(jaqy490std,0),
                     nvl(jaqy490cpo,0),
                     nvl(jaqy490lcn,0),
                     nvl(jaqy490dco,0),
                     nvl(jaqy490nen,0)
                into ddirecta, potencial, lineacre, impdeuda, entidades
                from JAQY490
               where jaqy490ndi = P_NUMDOC
                 and jaqy490fec = (select max(jaqy490fec) from JAQY490);
            exception
              when no_data_found then
                P_TOTAL      := 0;
                P_DIRECTA    := 0;
                P_POTENCIAl  := 0;
                P_NUMENTIDAD := 0;
            End;
        end;
        if segmentop = 1 then
          if (resneto + cuotasf + potencial) > 0 then
            P_RESULTADO := (cuotaca + cuotasf + potencial) /
                           (resneto + cuotasf + potencial); ---*100;
          else
            P_RESULTADO := 0;
          end if;
        elsif segmentop = 2 then
          if (ingresot + cuotasf + potencial) > 0 then
            P_RESULTADO := (cuotaca + cuotasf + potencial) /
                           (ingresot + cuotasf + potencial); ---*100;
          else
            P_RESULTADO := 0; --(cuotaca + cuotasf +potencial);
          end if;
        end if;
      else
        Begin
          select nvl(jaqy490std, 0),
                 nvl(jaqy490cpo, 0),
                 nvl(jaqy490lcn, 0),
                 nvl(jaqy490dco, 0),
                 nvl(jaqy490nen, 0)
            into ddirecta, potencial, lineacre, impdeuda, entidades
            from JAQY490
           where jaqy490ndt = P_NUMDOC
             and jaqy490fec = (select max(jaqy490fec) from JAQY490)
             and jaqy490tdi = 2;
          P_TOTAL      := ddirecta + lineacre + impdeuda;
          P_DIRECTA    := ddirecta;
          P_POTENCIAl  := potencial; --- *100;
          P_NUMENTIDAD := entidades;
          if segmentop = 1 then
            if (resneto + cuotasf + potencial) > 0 then
              P_RESULTADO := (cuotaca + cuotasf + potencial) /
                             (resneto + cuotasf + potencial); ---*100;
            else
              P_RESULTADO := 0;
            end if;
          elsif segmentop = 2 then
            --  P_RESULTADO := (cuotaca + cuotasf +potencial)/(ingresot + cuotasf + potencial);---*100;
            if (ingresot + cuotasf + potencial) > 0 then
              P_RESULTADO := (cuotaca + cuotasf + potencial) /
                             (ingresot + cuotasf + potencial); ---*100;
            else
              P_RESULTADO := 0; -- (cuotaca + cuotasf +potencial);
            end if;
          end if;
        Exception
          when no_data_found then
            P_TOTAL      := 0;
            P_DIRECTA    := 0;
            P_POTENCIAl  := 0;
            P_NUMENTIDAD := 0;
        end;
      end if;
      p_existe := 1;
    Exception
      when no_data_found then
        p_existe := 0;
        Begin
          SELECT DECODE(jaql157sob,
                        'S',
                        'Cliente Expuesto a Riesgo de sobre endeudamiento',
                        'Cliente no Expuesto a Riesgo de sobre endeudamiento'),
                 nvl(jaql157rat,0), -- //-  Ratio cuota /resultado neto
                 nvl(jaql157dts,0), -- //-  Deuda Directa
                 nvl(jaql157exr,0) -- //-  Cuota Potencial
            into P_SOBREENDEU, P_RESULTADO, P_DIRECTA, P_POTENCIAL
            FROM Jaql157
           Where jaql157pai = P_PAIS
             AND jaql157tdo = P_TIPDOC
             AND jaql157ndo = rpad(P_NUMDOC, 12, ' ')
             AND jaql157fch = (select max(jaql157fch)
                                 from jaql157
                                Where jaql157pai = P_PAIS
                                  AND jaql157tdo = P_TIPDOC
                                  AND jaql157ndo = P_NUMDOC);
          P_TOTAL      := 0;
          P_NUMENTIDAD := 0;
        exception
          when no_data_found then
            P_SOBREENDEU := 'Cliente no Expuesto a Riesgo de sobre endeudamiento';
        end;
    end;
  END SP_SOBREENDEUDAMIENTO;
  -----------------------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_INS_JAQZ567(P_CODSBS IN VARCHAR2, P_FECHA IN DATE) IS
  
    cursor consolidado is
      select c_cretip,
             (select NVL(tp1desc, 'Sin Descripcion')
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10832
                 and tp1corr1 = 6
                 and tp1corr2 = to_number(c_cretip)
                 and tp1corr3 = 0) tipocre,
             c_calvig,
             c_cuenta,
             (to_number(c_cuenta) / 10) cta_cont,
             (select pcnomr
                from fsd014
               where rubro = (to_number(c_cuenta) / 10)) rubro,
             n_diaatr,
             n_salcap,
             c_codemp,
             (select Tp1desc
                FROM fst198
               where Tp1cod = 1
                 AND Tp1cod1 = 10849
                 AND Tp1corr1 = 10
                 AND Tp1nro1 = c_codemp) empresa, --05072018 SMA
             c_codsbs,
             d_fecpre,
             (select NVL(tp1desc, 'Sin Calificacion')
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10832
                 and tp1corr1 = 5
                 and tp1corr2 = to_number(c_calvig)) calif
        from cldrccs
       where d_fecpre = P_FECHA --'28/02/2018'
         and c_codsbs = P_CODSBS
       order by d_fecpre, c_codsbs, empresa;
  bEGIN
    delete jaqz567 WHERE jaqz567csbs = TRIM(P_CODSBS); --0507/2018 SMA
    commit;
    FOR reg in consolidado loop
      Begin
        insert into jaqz567
          (jaqz567cod,
           jaqz567csbs,
           jaqz567emp,
           jaqz567dese,
           jaqz567tipo,
           jaqz567ctac,
           jaqz567desc,
           jaqz567atr,
           jaqz567sald,
           jaqz567cali)
        values
          (SEQ_JAQZ567.NEXTVAL,
           P_CODSBS,
           reg.c_codemp,
           reg.empresa,
           reg.tipocre,
           reg.cta_cont,
           reg.rubro,
           reg.n_diaatr,
           reg.n_salcap,
           reg.calif);
      
      exception
        when dup_val_on_index then
          null;
      END;
    end LOOP;
    commit;
  END SP_INS_JAQZ567;
  ---------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_CONTEO(P_CODSBS IN VARCHAR2,
                      P_TOTAL  OUT NUMBER,
                      P_SCFI   OUT NUMBER) IS
    fecha date;
  
  BEGIN
    select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                   substr(tpnro, 5, 4),
                   'dd/mm/yyyy')
      into fecha
      from FST098
     Where Pgcod = 1
       and Tpcod = 7647
       and Tpcorr = 12;
  
    select Nvl(count(distinct c.c_codemp), 0)
      INTO P_TOTAL
      from cldrccs c
     where c.d_fecpre = FECHA
       and c.c_codsbs = P_CODSBS
       and c.c_cuenta like '81_937%'
       and c.c_codemp <> '00104';
  
    select nvl(count(distinct c.c_codemp), 0)
      INTO P_SCFI
      from cldrccs c
     where c.d_fecpre = FECHA
       and c.c_codsbs = P_CODSBS
       and c.c_cuenta like '81_937%'
       and c.c_codemp <> '00104'
       AND C.C_CODEMP IN (SELECT LPAD(TP1NRO1, 5, '0')
                            FROM FST198
                           WHERE TP1COD = 1
                             AND TP1COD1 = 10884
                             AND TP1CORR1 = 52);
  
  END SP_CONTEO;
  ---------------------------------------------------------------------------------------------------------------  
  PROCEDURE SP_CODIGO(P_NUMDOC IN VARCHAR2, P_CODSBS OUT VARCHAR2) IS
  BEGIN
    select c_codsbs
      INTO P_CODSBS
      from (select c_codsbs
              from cldrcci
             where c_tdocid = '1'
               and c_docide = P_NUMDOC
             order by d_fecpre desc)
     where rownum = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_CODSBS := 0;
    
  END SP_CODIGO;
  -------------------------------------------------------------------------------------------------------------------
  Procedure sp_cr_get_codsbs(pn_tipdoc in number,
                             pc_numdoc in char,
                             pv_codsbs out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_get_codsbs
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/08/2021
    -- Autor de Creación          : RMONTESR
    -- Uso                        : RESOLUTOR POLITICA ACUERDO COMITE RIESGOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecrcc      date;
    ln_TipoDni     number(2);
    ln_TipoRuc     number(2);
    ln_TipoCex     number(2);
    lc_C_TDOCID    char(1);
    lc_docide      varchar(12);
    ln_TipCedIdent number;
  
  begin
  
    ln_TipoDni     := 21;
    ln_TipoRuc     := 9;
    ln_TipoCex     := 2;
    ln_TipCedIdent := 10;
  
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then null;
    end;
  
    if pn_tipdoc = ln_TipoDni or pn_tipdoc <> ln_TipoRuc then
      If pn_tipdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If pn_tipdoc = ln_tipocex or pn_tipdoc = ln_TipCedIdent then
        lc_C_TDOCID := '2';
      End If;
      
      If pn_tipdoc <> ln_tipodni And pn_tipdoc <> ln_tiporuc and
           lc_C_TDOCID is null then
        if pn_tipdoc > 9 then
             lc_C_TDOCID := 'X';-- no se tiene mapeado en cldrcci el tipo de documento
        else
             lc_C_TDOCID := to_char(pn_tipdoc);
        end if;
      End If;
      
      lc_docide := trim(pc_numdoc);
    
      begin
        select a.C_CODSBS
          into pv_codsbs
          from CLDRCCI a
         Where C_TDOCID = lc_C_TDOCID
           and C_DOCIDE = lc_docide
           and D_FECPRE = ld_fecrcc
           and rownum = 1;
      exception
        when no_data_found then
          pv_codsbs := null;
      end;
    
    Else
      If pn_tipdoc = ln_tiporuc then
      
        begin
          select a.C_CODSBS
            into pv_codsbs
            from CLDRCCI a
           Where C_DOCTRI = lc_docide
             and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            pv_codsbs := null;
        end;
      End If;
    
    end if;
  
  end sp_cr_get_codsbs;
  -----------------------------------------------------------------------------------------------------
  procedure sp_cr_deuda_repro(pn_instance in numeric, pv_rpta out varchar2) is
    ln_pais       number;
    ln_tdoc       number;
    lc_ndoc       char(12);
    ld_fecha      date;
    lv_codsbs     varchar2(12);
    ln_saldo1     number;
    ln_saldo2     number;
    ln_diferencia number;
    ln_porcentaje number;
  begin
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 a
       where a.sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
    begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fecha
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
    begin
      SELECT tp1imp1
        into ln_porcentaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10884
         AND TP1CORR1 = 53;
    exception
      when no_data_found then
        ln_porcentaje := 0;
    end;
    pq_cr_central_riesgos.sp_cr_get_codsbs(ln_tdoc, lc_ndoc, lv_codsbs);
    begin
      for i in 1 .. 5 loop
        begin
          select sum(a.n_Salcap)
            into ln_saldo1
            from CLDRCCS a
           Where C_CODSBS = lv_codsbs
             and D_FECPRE = add_months(ld_fecha, -i + 1)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp <> '00104';
        exception
          when no_data_found then
            ln_saldo1 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo2
            from CLDRCCS a
           Where C_CODSBS = lv_codsbs
             and D_FECPRE = add_months(ld_fecha, -i)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp <> '00104';
        exception
          when no_data_found then
            ln_saldo2 := 0;
        end;
        if ln_saldo1 is null then
          ln_saldo1 := 0;
        end if;
        if ln_saldo2 is null then
          ln_saldo2 := 0;
        end if;
        if ln_saldo1 > 0 then
          ln_diferencia := (ln_saldo1 - ln_saldo2) * 100 / ln_saldo1;
        else
          ln_diferencia := -100;
        end if;
        if ln_saldo1 > 0 and ln_saldo2 = 0 then
          ln_diferencia := 0;
          ln_porcentaje := -1;
        end if;
        if ln_diferencia < ln_porcentaje * -1 then
          pv_rpta := 'N';
        else
          pv_rpta := 'S';
        end if;
        if i = 1 and ln_saldo1 = 0 then
          pv_rpta := 'Z';
        end if;
      
        EXIT WHEN ln_diferencia < ln_porcentaje * -1;
      end loop;
    exception when others then null;
    end;
  
  end sp_cr_deuda_repro;
  -----------------------------------------------------------------------------------------------------
  procedure sp_cr_deuda_repro2(pn_instance in numeric,
                               pv_rpta     out varchar2) is
    ln_pais       number;
    ln_tdoc       number;
    lc_ndoc       char(12);
    ld_fecha      date;
    lv_codsbs     varchar2(12);
    ln_saldo1     number;
    ln_saldo2     number;
    ln_diferencia number;
    ln_porcentaje number;
  begin
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 a
       where a.sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
    begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fecha
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
    begin
      SELECT tp1imp1
        into ln_porcentaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10884
         AND TP1CORR1 = 53;
    exception
      when no_data_found then
        ln_porcentaje := 0;
    end;
    pq_cr_central_riesgos.sp_cr_get_codsbs(ln_tdoc, lc_ndoc, lv_codsbs);
    begin
      for i in 1 .. 6 loop
        begin
          select sum(a.n_Salcap)
            into ln_saldo1
            from CLDRCCS a
           Where C_CODSBS = lv_codsbs
             and D_FECPRE = add_months(ld_fecha, -i + 1)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp <> '00104';
        exception
          when no_data_found then
            ln_saldo1 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo2
            from CLDRCCS a
           Where C_CODSBS = lv_codsbs
             and D_FECPRE = add_months(ld_fecha, -i)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp <> '00104';
        exception
          when no_data_found then
            ln_saldo2 := 0;
        end;
        if ln_saldo1 is null then
          ln_saldo1 := 0;
        end if;
        if ln_saldo2 is null then
          ln_saldo2 := 0;
        end if;
        if ln_saldo2 > 0 then
          ln_diferencia := (ln_saldo1 - ln_saldo2) * 100 / ln_saldo2;
        else
          if ln_saldo1 > 0 then
            ln_diferencia := 100;
          else
            ln_diferencia := 0;
          end if;
        end if;
      
        if ln_diferencia < ln_porcentaje * -1 then
          pv_rpta := 'N';
        else
          pv_rpta := 'S';
        end if;
      
        if i = 1 and ln_saldo1 = 0 then
          pv_rpta := 'N';
        end if;
        if ln_saldo1 = 0 then
          pv_rpta := 'N';
        end if;
        EXIT WHEN pv_rpta = 'N';
      end loop;
    exception when others then null;
    end;
  
  end sp_cr_deuda_repro2;
  
  -----------------------------------------------------------
  -----------------------------------------------------------------------------------------------------
  procedure sp_cr_consultaSF(pn_instance in numeric, pv_rpta out number) is
    ln_pais      number;
    ln_tdoc      number;
    lc_ndoc      char(12);
    ld_fecha     date;
    ld_fecha_sol date;
    ld_fecha_lim date;
    ln_count1    number;
    ln_count2    number;
  
  begin
    ln_count1 := 0;
    ln_count2 := 0;
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc, a.sng001fin
        into ln_pais, ln_tdoc, lc_ndoc, ld_fecha_sol
        from sng001 a
       where a.sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
    begin
      select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select ld_fecha - 30 into ld_fecha_lim from dual;
    exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_count1
        from JAQL549 a
       inner join jaql546 b
          on a.jaql546serial = b.jaql546serial
       where b.jaql546nudoc = rpad(lc_ndoc, 12)
         and a.jaql549fecha >= ld_fecha_lim
            
         and a.jaql546serial =
             (select max(m.jaql546serial)
                from JAQL549 m
               inner join jaql546 n
                  on m.jaql546serial = n.jaql546serial
               where n.jaql546nudoc = rpad(lc_ndoc, 12))
         and a.jaql549ticta in ('TDC', 'CRE', 'CAC', 'CAS', 'HIP', 'CCL')
         and a.jaql549entid <> 'CMAC AREQUIPA';
    
    exception
      when others then
        ln_count1 := 0;
    end;
    begin
      select count(*)
        into ln_count2
        from (select c.jaqz239entid as entidad
                from JAQz239 c
               inner join jaqz236 d
                  on c.jaqz239serial = d.jaqz236serial
               where d.jaqz236nudoc = lc_ndoc
                 and c.jaqz239fecha >= ld_fecha_lim
                 and c.jaqz239serial =
                     (select max(m.jaqz239serial)
                        from JAQz239 m
                       inner join jaqz236 n
                          on m.jaqz239serial = n.jaqz236serial
                       where n.jaqz236nudoc = lc_ndoc)) g
       where g.entidad <>
             'CAJA MUNICIPAL DE AHORRO Y CREDITO DE AREQUIPA S.A. - CAJA AREQUIPA'
         and (upper(g.entidad) like '%CAJA RURAL%' or
             upper(g.entidad) like '%CAJA MUNI%' or
             upper(g.entidad) like '%BANCO%' or
             upper(g.entidad) like '%C.A.C%' or
             upper(g.entidad) like '%CMAC%' or
             upper(g.entidad) like '%COOP.%' or
             upper(g.entidad) like '%COOP %' or
             upper(g.entidad) like '%COOPERATIVA%' or
             upper(g.entidad) like '%COOPAC%' or
             upper(g.entidad) like '%COOPCOTUR%' or
             upper(g.entidad) like '%INTICOOP%' or
             upper(g.entidad) like '%CREDI%' or
             upper(g.entidad) like '%FINANCIERA%');
    exception
      when others then
        ln_count2 := 0;
    end;
    if ln_count1 > ln_count2 then
      pv_rpta := ln_count1;
    else
      pv_rpta := ln_count2;
    end if;
  end sp_cr_consultaSF;
end PQ_CR_CENTRAL_RIESGOS;
/

