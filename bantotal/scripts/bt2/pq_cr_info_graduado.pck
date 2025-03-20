create or replace package pq_cr_info_graduado is

  -- Author  : IGS_RCASTRO
  -- Created : 21/09/2023 12:25:06
  -- Purpose : 

  Procedure sp_validar_graduado(instancia    number,
                                TipoDoc      number,
                                Nrodocumento varchar2,
                                PC_CODSBS    varchar2,
                                Ubuser       varchar2,
                                ProgramaOrig varchar2,
                                MsgRpta      out varchar2);

  Procedure sp_grabar_logs(p_AQPC817inst    number,
                           p_AQPC817tdoc    number,
                           p_AQPC817ndoc    varchar2,
                           p_AQPC817csbs    varchar2,
                           p_AQPC817user    varchar2,
                           p_AQPC817prgmori varchar2,
                           p_AQPC817grad    varchar2,
                           p_AQPC817NMESRCC number);

end pq_cr_info_graduado;
/

create or replace package body pq_cr_info_graduado is

  Procedure sp_validar_graduado(instancia    number,
                                TipoDoc      number,
                                Nrodocumento varchar2,
                                PC_CODSBS    varchar2,
                                Ubuser       varchar2,
                                ProgramaOrig varchar2,
                                MsgRpta      out varchar2) is
    LN_RPTA    varchar2(50);
    FECNUM_RCC NUMBER(9);
    FEC_RCC    DATE;
    CountReg   number(7);
    AuxFecha   DATE;
    xMESES     number(6);
    xMesRang   number(6);
  
    xNroDoc  varchar2(12);
    xTipoDoc number(4);
    xPais    number(4);
    lc_tiper VARCHAR2(1);
  
  BEGIN
    BEGIN
      SELECT TPNRO
        INTO FECNUM_RCC
        FROM FST098
       WHERE PGCOD = 1
         AND TPCOD = 7647
         AND TPCORR = 12;
    EXCEPTION
      WHEN OTHERS THEN
        FECNUM_RCC := NULL;
    END;
  
    --guia 
    BEGIN
      SELECT TP1NRO1
        INTO xMesRang
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 72
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        xMesRang := 0;
    END;
  
    xMesRang := NVL(xMesRang, 0);
  
    BEGIN
      SELECT TP1NRO1
        INTO xMESES
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 72
         AND TP1CORR2 = 1
         AND TP1CORR3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        xMESES := 0;
    END;
  
    xMESES := NVL(xMESES, 0);
  
    FEC_RCC  := TO_DATE(FECNUM_RCC, 'dd/mm/yyyy');
    AuxFecha := ADD_MONTHS(FEC_RCC, -xMesRang);
  
    lc_tiper := '';
    CountReg := 0;
    IF PC_CODSBS IS NOT NULL THEN
      BEGIN
        SELECT COUNT(DISTINCT CC.D_FECPRE)
          INTO CountReg
          FROM CLDRCCI CC
         WHERE CC.D_FECPRE <= FEC_RCC
           AND CC.D_FECPRE > AuxFecha
           AND CC.C_CODSBS = PC_CODSBS;
      EXCEPTION
        WHEN OTHERS THEN
          CountReg := 0;
      END;
      xTipoDoc := TipoDoc;
      XNRODOC  := Nrodocumento;
    ELSE
      CASE
        WHEN instancia > 0 THEN
          BEGIN
            SELECT W.SNG001PAIS, W.SNG001TDOC, W.SNG001NDOC
              INTO xPais, xTipoDoc, xNroDoc
              FROM SNG001 W
             WHERE W.SNG001INST = instancia;
          EXCEPTION
            WHEN OTHERS THEN
              xPais    := 0;
              xTipoDoc := 0;
              xNroDoc  := '';
          END;
        
          begin
            select a.petipo
              into lc_tiper
              from fsd001 a
             where a.pepais = xPais
               and a.petdoc = xTipoDoc
               and a.pendoc = xNroDoc;
          exception
            when OTHERS then
              lc_tiper := null;
          end;
        
        WHEN Nrodocumento is not null THEN
          BEGIN
            select a.petipo
              into lc_tiper
              from fsd001 a
             where a.petipo = TipoDoc
               AND --
                   a.pendoc = Nrodocumento;
          EXCEPTION
            WHEN OTHERS THEN
              lc_tiper := '';
          END;
          xTipoDoc := TipoDoc;
          XNRODOC  := Nrodocumento;
      END CASE;
    
      CASE
        WHEN LC_TIPER = 'F' THEN
          BEGIN
            SELECT COUNT(DISTINCT CC.D_FECPRE)
              INTO COUNTREG
              FROM CLDRCCI CC
             WHERE CC.D_FECPRE <= FEC_RCC
               AND CC.D_FECPRE > AUXFECHA
                  --AND C_TDOCID = XTIPODOC
               AND C_DOCIDE = TRIM(XNRODOC)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              COUNTREG := 0;
          END;
        WHEN LC_TIPER = 'J' THEN
          BEGIN
            SELECT COUNT(DISTINCT CC.D_FECPRE)
              INTO COUNTREG
              FROM CLDRCCI CC
             WHERE CC.D_FECPRE <= FEC_RCC
               AND CC.D_FECPRE > AUXFECHA
                  --AND C_TDOCTR = XTIPODOC
               AND C_DOCTRI = TRIM(XNRODOC)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              COUNTREG := 0;
          END;
        ELSE
          NULL;
      END CASE;
    END IF;
  
    CountReg := NVL(CountReg, 0);
    CASE
      WHEN CountReg > xMESES THEN
        LN_RPTA := 'GRADUADO';
      ELSE
        LN_RPTA := 'NO GRADUADO';
    END CASE;
  
    MsgRpta := LN_RPTA;
  
    if instancia > 0 then
      update aqpc817 a
         set a.aqpc817est = 'I'
       where a.aqpc817inst = instancia
         and a.aqpc817est = 'H';
      commit;
    elsif nrodocumento is not null then
      update aqpc817 a
         set a.aqpc817est = 'I'
       where a.aqpc817tdoc = TipoDoc
         and a.aqpc817ndoc = Nrodocumento
         and a.aqpc817est = 'H';
      commit;
    else
      if PC_CODSBS is not null then
        update aqpc817 a
           set a.aqpc817est = 'I'
         where a.AQPC817CSBS = PC_CODSBS
           and a.aqpc817est = 'H';
        commit;
      end if;
    end if;
  
    begin
      pq_cr_info_graduado.sp_grabar_logs(instancia,
                                         xTipoDoc,
                                         XNRODOC,
                                         PC_CODSBS,
                                         ubuser,
                                         ProgramaOrig,
                                         MsgRpta,
                                         CountReg);
    exception
      when others then
        null;
    end;
  
  END;

  Procedure sp_grabar_logs(p_AQPC817inst    number,
                           p_AQPC817tdoc    number,
                           p_AQPC817ndoc    varchar2,
                           p_AQPC817csbs    varchar2,
                           p_AQPC817user    varchar2,
                           p_AQPC817prgmori varchar2,
                           p_AQPC817grad    varchar2,
                           p_AQPC817NMESRCC number) IS
    ln_corr number(12);
  
  BEGIN
    BEGIN
      select max(a.AQPC817corr)
        into ln_corr
        from AQPC817 a
       where a.aqpc817tdoc = p_AQPC817tdoc
         and a.aqpc817ndoc = p_AQPC817ndoc;
    exception
      when others then
        ln_corr := 0;
    END;
    ln_corr := nvl(ln_corr, 0);
  
    BEGIN
      INSERT INTO AQPC817
        (AQPC817corr,
         AQPC817inst,
         AQPC817tdoc,
         AQPC817ndoc,
         AQPC817csbs,
         AQPC817user,
         AQPC817fec,
         AQPC817hora,
         AQPC817prgmori,
         AQPC817grad,
         AQPC817est,
         AQPC817NMESRCC)
      VALUES
        (ln_corr + 1,
         p_AQPC817inst,
         p_AQPC817tdoc,
         p_AQPC817ndoc,
         p_AQPC817csbs,
         p_AQPC817user,
         to_date(sysdate, 'dd/MM/rrrr'),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         p_AQPC817prgmori,
         p_AQPC817grad,
         'H',
         p_AQPC817NMESRCC);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

end pq_cr_info_graduado;
/

