create or replace package PQ_REPORT_LOTES is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.04.13
  -- Autor de Creación          : Edward Fuentes
  -- Uso                        : Genera el reporte de remate de lotes
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 02.09.2024
  -- Autor de Modificación      : Clinton Alarcon Apaza
  -- Descripción de Modificación: Se agrego ROWNUM = 1 a subconsultas del procedimiento almacenado SP_Rep_CarteraDet para evitar error 
  --                              por duplicidad de filas )
  -- Fecha de Modificación      : 2025.12.22
  -- Autor de la Modificación   : JALVAROH 
  -- Descripción de Modificación: Se agregan filtros ROW_NUMBER para evitar duplicidad de registros en el reporte de adjudicados.
  -- *****************************************************************
  -----------------------------------------------------------------------

  --************************************************************************************
  procedure SP_Rep_CarteraDet(p_Analis  in VARCHAR2,
                              RESULTADO IN OUT NUMBER);

  --************************************************************************************
  procedure SP_Rep_Adjudicados(p_CodRem  in NUMBER,
                               p_Analis  in VARCHAR2,
                               RESULTADO IN OUT NUMBER);

  --************************************************************************************    
  procedure SP_Rep_Adjudicados_0(p_CodRem  in NUMBER,
                                 p_Analis  in VARCHAR2,
                                 RESULTADO IN OUT NUMBER);

  --************************************************************************************
  Function FN_Deuda_Total(pn_emp_1  in number,
                          pn_mod_1  in number,
                          pn_suc_1  in number,
                          pn_mda_1  in number,
                          pn_pap_1  in number,
                          pn_cta_1  in number,
                          pn_ope_1  in number,
                          pn_sbo_1  in number,
                          pn_top_1  in number,
                          pd_fecpro in date) return number;

  --************************************************************************************
  Function FN_Interes_Moratorio(pn_emp_1  in number,
                                pn_mod_1  in number,
                                pn_suc_1  in number,
                                pn_mda_1  in number,
                                pn_pap_1  in number,
                                pn_cta_1  in number,
                                pn_ope_1  in number,
                                pn_sbo_1  in number,
                                pn_top_1  in number,
                                pd_fecpro in date) return number;

  --************************************************************************************
  Function FN_Interes_Compensatorio(pn_emp_1  in number,
                                    pn_mod_1  in number,
                                    pn_suc_1  in number,
                                    pn_mda_1  in number,
                                    pn_pap_1  in number,
                                    pn_cta_1  in number,
                                    pn_ope_1  in number,
                                    pn_sbo_1  in number,
                                    pn_top_1  in number,
                                    pd_fecpro in date) return number;

end PQ_REPORT_LOTES;
/
create or replace package body PQ_REPORT_LOTES is

  procedure SP_Rep_CarteraDet(p_Analis  in VARCHAR2,
                              RESULTADO IN OUT NUMBER) is
    fecha   date;
    my_errm VARCHAR2(32000);
  begin
  
    SELECT TRUNC(SYSDATE) INTO fecha FROM DUAL;
  
    delete from AQPB605 where AQPB605USUR = p_Analis;
    COMMIT;
  
    RESULTADO := 0;
  
    Begin
      insert into AQPB605
        (AQPB605REG,
         AQPB605AGE,
         AQPB605TDOC,
         AQPB605NDOC,
         AQPB605FECN,
         AQPB605SEX,
         AQPB605INGM,
         AQPB605NCLI,
         AQPB605DPT,
         AQPB605PRO,
         AQPB605DIS,
         AQPB605DIR,
         AQPB605TEL,
         AQPB605COR,
         AQPB605CEL,
         AQPB605ANAD,
         AQPB605FECD,
         AQPB605MNTD,
         AQPB605VTAS,
         AQPB605NROR,
         AQPB605SLDC,
         AQPB605DEUT,
         AQPB605SLDJ,
         AQPB605DIAA,
         AQPB605SJUD,
         AQPB605SVEN,
         AQPB605MOD,
         AQPB605DESM,
         AQPB605TOPE,
         AQPB605DESO,
         AQPB605DESS,
         AQPB605MND,
         AQPB605PAP,
         AQPB605CTA,
         AQPB605OPE,
         AQPB605SOPE,
         AQPB605LOTE,
         AQPB605DESL,
         AQPB60514K,
         AQPB60518K,
         AQPB60521K,
         AQPB605SORF,
         AQPB605FECV,
         AQPB605PGCODC,
         AQPB605MODC,
         AQPB605SUCC,
         AQPB605MDAC,
         AQPB605PAPC,
         AQPB605CTAC,
         AQPB605OPERC,
         AQPB605SBOPC,
         AQPB605TOPEC,
         AQPB605USUR,
         AQPB605FECR)
        SELECT /*+all_rows*/
         (SELECT upper(T.REGNOM)
            FROM FST811 S
            JOIN FST810 T
              ON T.REGCOD = S.REGCOD
             AND T.REGCOD < 100
           WHERE S.PGCOD = 1
             AND S.REGCOD < 100
             AND S.OFICOD = A.PP175SUC) "REGION",
         B.SCNOM AGENCIA,
         K.PETDOC "TIPO DOC",
         K.PENDOC "NRO DOC",
         P.PFFNAC "FEC. NACIMINETO",
         P.PFCANT SEXO,
         (SELECT R.PEXING
            FROM FSE101 R
           WHERE K.PEPAIS = R.PEPAIS
             AND K.PETDOC = R.PETDOC
             AND K.PENDOC = R.PENDOC
             AND ROWNUM = 1) Ing_Men, --*****
         M.PENOM "NOMBRE CLIENTE",
         (SELECT H.DEPNOM
            FROM SNGC13 C13, FST068 H
           WHERE C13.SNGC13PAIS = K.PEPAIS
             AND C13.SNGC13TDOC = K.PETDOC
             AND C13.SNGC13NDOC = K.PENDOC
             AND C13.SNGC13EST = 'H'
             AND ROWNUM = 1
             AND C13.DOCOD = 1 --(SELECT MAX(XX.DOCOD) FROM SNGC13 XX WHERE XX.SNGC13PAIS = K.PEPAIS AND XX.SNGC13TDOC = K.PETDOC AND XX.SNGC13NDOC = K.PENDOC AND XX.SNGC13EST = 'H')
             AND H.PAIS = C13.SNGC13PAIS
             AND H.DEPCOD = C13.SNGC13DPTO) "DEPARTAMENTO DOM.",
         (SELECT I.LOCNOM
            FROM SNGC13 C13, FST068 H, FST070 I
           WHERE C13.SNGC13PAIS = K.PEPAIS
             AND C13.SNGC13TDOC = K.PETDOC
             AND C13.SNGC13NDOC = K.PENDOC
             AND C13.SNGC13EST = 'H'
             AND ROWNUM = 1
             AND C13.DOCOD = 1 --(SELECT MAX(XX.DOCOD) FROM SNGC13 XX WHERE XX.SNGC13PAIS = K.PEPAIS AND XX.SNGC13TDOC = K.PETDOC AND XX.SNGC13NDOC = K.PENDOC AND XX.SNGC13EST = 'H')
             AND H.PAIS = C13.SNGC13PAIS
             AND H.DEPCOD = C13.SNGC13DPTO
             AND I.PAIS = C13.SNGC13PAIS
             AND I.DEPCOD = H.DEPCOD
             AND I.LOCCOD = C13.SNGC13PROV) "PROVINICIA DOM.",
         (SELECT J.FST071DSC
            FROM SNGC13 C13, FST068 H, FST071 J
           WHERE C13.SNGC13PAIS = K.PEPAIS
             AND C13.SNGC13TDOC = K.PETDOC
             AND C13.SNGC13NDOC = K.PENDOC
             AND C13.SNGC13EST = 'H'
             AND ROWNUM = 1
             AND C13.DOCOD = 1 --(SELECT MAX(XX.DOCOD) FROM SNGC13 XX WHERE XX.SNGC13PAIS = K.PEPAIS AND XX.SNGC13TDOC = K.PETDOC AND XX.SNGC13NDOC = K.PENDOC AND XX.SNGC13EST = 'H')
             AND H.PAIS = C13.SNGC13PAIS
             AND H.DEPCOD = C13.SNGC13DPTO
             AND J.FST071PAI = C13.SNGC13PAIS
             AND J.FST071DPT = H.DEPCOD
             AND J.FST071COL = C13.SNGC13UGEO) "DISTRITO DOM.",
         (SELECT C13.SNGC13DIR
            FROM SNGC13 C13
           WHERE C13.SNGC13PAIS = K.PEPAIS
             AND C13.SNGC13TDOC = K.PETDOC
             AND C13.SNGC13NDOC = K.PENDOC
             AND C13.SNGC13EST = 'H'
             AND ROWNUM = 1
             AND C13.DOCOD = 1 --(SELECT MAX(XX.DOCOD) FROM SNGC13 XX WHERE XX.SNGC13PAIS = K.PEPAIS AND XX.SNGC13TDOC = K.PETDOC AND XX.SNGC13NDOC = K.PENDOC AND XX.SNGC13EST = 'H')
          ) "DIRECCION DOM",
         (SELECT LISTAGG(TRIM(TL.DOTELFP), ', ') WITHIN GROUP(ORDER BY TL.DOTELFP)
            FROM FSR005 TL
           WHERE TL.PEPAIS = K.PEPAIS
             AND TL.PETDOC = K.PETDOC
             AND TL.PENDOC = K.PENDOC
             AND TL.DOCOD = 1) "TELEFONO",
         (SELECT REPLACE(Q.PEXTXT, '\', ', ')
            FROM FSX001 Q
           WHERE K.PEPAIS = Q.PEPAIS
             AND K.PETDOC = Q.PETDOC
             AND K.PENDOC = Q.PENDOC
             AND ROWNUM = 1) "CORREOS",
         (SELECT LISTAGG(TRIM(TL.DOTELFP), ', ') WITHIN GROUP(ORDER BY TL.DOTELFP)
            FROM FSR005 TL
           WHERE TL.PEPAIS = K.PEPAIS
             AND TL.PETDOC = K.PETDOC
             AND TL.PENDOC = K.PENDOC
             AND TL.DOCOD = 2) "CELULAR",
         (select max(substr(p178.pp178dtext, 1, 10))
            from fpp178 p178
           where p178.pp174cod = A.PP174COD
             and p178.pp177codd = 7) "ANALISTA DESEMBOLSO",
         (SELECT E.AOFVAL
            FROM FSD010 E
           WHERE A.PP175PGCOD = E.PGCOD
             AND A.PP175MOD = E.AOMOD
             AND A.PP175SUC = E.AOSUC
             AND A.PP175MDA = E.AOMDA
             AND A.PP175PAP = E.AOPAP
             AND A.PP175CTA = E.AOCTA
             AND A.PP175OPER = E.AOOPER
             AND E.AOSBOP = 0
             AND ROWNUM = 1) "FECHA DESEMBOLSO",
         (SELECT E.AOIMP
            FROM FSD010 E
           WHERE A.PP175PGCOD = E.PGCOD
             AND A.PP175MOD = E.AOMOD
             AND A.PP175SUC = E.AOSUC
             AND A.PP175MDA = E.AOMDA
             AND A.PP175PAP = E.AOPAP
             AND A.PP175CTA = E.AOCTA
             AND A.PP175OPER = E.AOOPER
             AND E.AOSBOP = 0
             AND ROWNUM = 1) "MONTO DESEMBOLSO",
         (SELECT D.PP178DSAL
            FROM FPP178 D
           WHERE A.PP174COD = D.PP174COD
             AND D.PP177CODD = 10
             AND ROWNUM = 1) "VALOS TASACION",
         (SELECT COUNT(*) FROM FPP175 C WHERE C.PP174COD = A.PP174COD) "NRO. RENOVACIONES",
         ABS(AA.SCSDO) "SALDO CAPITAL",
         fn_Obt_Deu_Tot(A.PP175PGCOD,
                        A.PP175MOD,
                        A.PP175SUC,
                        A.PP175MDA,
                        A.PP175PAP,
                        A.PP175CTA,
                        A.PP175OPER,
                        A.PP175SBOP,
                        A.PP175TOPE,
                        trunc(sysdate)) "DEUDA TOTAL",
         (SELECT DECODE(U.BCMDA, 0, U.BCSDMO, U.BCSDMO)
            FROM FSH012 U
           WHERE U.BCEMP = A.PP175PGCOD
             AND U.BCMOD = A.PP175MOD
             AND U.BCSUC = A.PP175SUC
             AND U.BCMDA = A.PP175MDA
             AND U.BCPAP = A.PP175PAP
             AND U.BCCTA = A.PP175CTA
             AND U.BCOPER = A.PP175OPER
             AND U.BCSBOP = A.PP175SBOP
             AND U.BCTOP = A.PP175TOPE
             AND U.BCFECH = TRUNC(SYSDATE - 1)
             AND ROWNUM = 1) "Sal. Cap. + Judiciales",
         (SELECT CASE
                   WHEN ROUND((TRUNC(SYSDATE) - AA.SCFVTO)) > 0 THEN
                    ROUND((TRUNC(SYSDATE) - AA.SCFVTO))
                   ELSE
                    0
                 END
            FROM DUAL) "DIAS DE ATRASO",
         /*
         fn_dias_atraso( TRUNC(SYSDATE),
                         A.PP175PGCOD,
                         A.PP175MOD, 
                         A.PP175SUC, 
                         A.PP175MDA, 
                         A.PP175PAP, 
                         A.PP175CTA, 
                         A.PP175OPER, 
                         A.PP175SBOP, 
                         A.PP175TOPE,
                         0,
                         AA.SCFVTO) "DIAS DE ATRASO",
          */
         (SELECT AB.SCSDO
            FROM FSD011 AB
           WHERE AB.SCGRU = 1416
             AND AB.PGCOD = A.PP175PGCOD
             AND AB.SCMOD = A.PP175MOD
             AND AB.SCSUC = A.PP175SUC
             AND AB.SCMDA = A.PP175MDA
             AND AB.SCPAP = A.PP175PAP
             AND AB.SCCTA = A.PP175CTA
             AND AB.SCOPER = A.PP175OPER
             AND AB.SCSBOP = A.PP175SBOP
             AND AB.SCTOPE = A.PP175TOPE
             AND ROWNUM = 1) "SALDO SOLO JUDICIAL",
         (SELECT AB.SCSDO
            FROM FSD011 AB
           WHERE AB.SCGRU = 1415
             AND AB.PGCOD = A.PP175PGCOD
             AND AB.SCMOD = A.PP175MOD
             AND AB.SCSUC = A.PP175SUC
             AND AB.SCMDA = A.PP175MDA
             AND AB.SCPAP = A.PP175PAP
             AND AB.SCCTA = A.PP175CTA
             AND AB.SCOPER = A.PP175OPER
             AND AB.SCSBOP = A.PP175SBOP
             AND AB.SCTOPE = A.PP175TOPE
             AND ROWNUM = 1) "SALDO SOLO VENCIDO",
         A.PP175MOD MODULO,
         T.MDNOM "DESCRIPCION MODULO",
         A.PP175TOPE OPERACIÓN,
         L.TONOM "DESCRIPCION OPERACION",
         A.PP175SUC SUCURSAL,
         A.PP175MDA MONEDA,
         A.PP175PAP PAPEL,
         A.PP175CTA CUENTA,
         A.PP175OPER OPERACION,
         A.PP175SBOP SUBOPERACION,
         --'CALIFICACION RCC ACTUAL',
         A.PP174COD LOTE,
         (SELECT O.PP178DCOM
            FROM FPP178 O
           WHERE O.PP174COD = A.PP174COD
             AND O.PP177CODD = 19
             AND ROWNUM = 1) "DESCRIPCION LOTE",
         (select pp181cant
            from fpp181
           where pp174cod = A.pp174cod
             and pp170cbien = 1
             and pp171tbien = 1
             AND ROWNUM = 1) "14k",
         (select pp181cant
            from fpp181
           where pp174cod = A.pp174cod
             and pp170cbien = 1
             and pp171tbien = 2
             AND ROWNUM = 1) "18k",
         (select pp181cant
            from fpp181
           where pp174cod = A.pp174cod
             and pp170cbien = 1
             and pp171tbien = 3
             AND ROWNUM = 1) "21K",
         (SELECT bnj096sor
            FROM BNJ096 V
           WHERE V.bnj096mda = A.PP175MDA
             and V.bnj096pap = A.PP175PAP
             and V.bnj096cta = A.PP175CTA
             and V.bnj096ope = A.PP175OPER
             and V.bnj096mod = A.PP175MOD
             AND V.bnj096sub = A.PP175SBOP
             AND ROWNUM = 1) "Nro. Credito SORFY",
         (SELECT N.AOFVTO
            FROM FSD010 N
           WHERE A.PP175PGCOD = N.PGCOD
             AND A.PP175MOD = N.AOMOD
             AND A.PP175SUC = N.AOSUC
             AND A.PP175MDA = N.AOMDA
             AND A.PP175PAP = N.AOPAP
             AND A.PP175CTA = N.AOCTA
             AND A.PP175OPER = N.AOOPER
             AND A.PP175SBOP = N.AOSBOP
             AND A.PP175TOPE = N.AOTOPE) "FECHA VENCIMIENTO",
         A.PP175PGCOD,
         A.PP175MOD,
         A.PP175SUC,
         A.PP175MDA,
         A.PP175PAP,
         A.PP175CTA,
         A.PP175OPER,
         A.PP175SBOP,
         A.PP175TOPE,
         p_Analis,
         fecha
          FROM FPP175 A --tabla de creditos
          JOIN FSD011 AA
            ON A.PP175PGCOD = AA.PGCOD
           AND A.PP175MOD = AA.SCMOD
           AND A.PP175SUC = AA.SCSUC --creditos vigentes
           AND A.PP175MDA = AA.SCMDA
           AND A.PP175PAP = AA.SCPAP
           AND A.PP175CTA = AA.SCCTA
           AND A.PP175OPER = AA.SCOPER
           AND A.PP175SBOP = AA.SCSBOP
           AND A.PP175TOPE = AA.SCTOPE
          LEFT JOIN FSR008 K
            ON A.PP175PGCOD = K.PGCOD
           AND A.PP175CTA = K.CTNRO
           AND K.CTTFIR = 'T' -- CUENTAS DEL CLIENTE
          LEFT JOIN FST003 T
            ON A.PP175MOD = T.MODULO -- DESCRIPCION DE MODULOS
          LEFT JOIN FST004 L
            ON A.PP175MOD = L.MODULO
           AND A.PP175TOPE = L.TOTOPE -- DESCRIPCION TIO DE OPERACION
          LEFT JOIN FSD001 M
            ON M.PEPAIS = K.PEPAIS
           AND M.PETDOC = K.PETDOC
           AND M.PENDOC = K.PENDOC -- NOMBRE PERSONA
          LEFT JOIN FST001 B
            ON A.PP175SUC = B.SUCURS
           AND A.PP175PGCOD = B.PGCOD -- sucursal
          LEFT JOIN FSD002 P
            ON K.PEPAIS = P.PFPAIS
           AND K.PETDOC = P.PFTDOC
           AND K.PENDOC = P.PFNDOC -- FECHA NACIMIENTO Y SEXO
         WHERE A.PP175TCO = 'S'
           AND AA.SCSDO <= 0;
      --AND rownum <= 20;
      --AND A.PP175CTA = 43070 AND A.PP175OPER = 119938;
      --AND A.PP174COD = 93572; --AND A.PP174COD = 98606 --CREDITO VIGENTE ESTADO S
      --order by A.PP174COD
    
      COMMIT;
    
      RESULTADO := 1;
    exception
      when others then
        RESULTADO := -1;
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
  end SP_Rep_CarteraDet;

  --************************************************************************************
  procedure SP_Rep_Adjudicados(p_CodRem  in NUMBER,
                               p_Analis  in VARCHAR2,
                               RESULTADO IN OUT NUMBER)
  -- ***************************************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2021.04.13
    -- Autor de Creación          : Edward Fuentes
    -- Uso                        : Genera el reporte de remate de lotes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Fecha de Modificación      : 2022.10.07
    -- Autor de la Modificación   : RCASTRO 
    -- Descripción de Modificación: Se agrega validación si es tipo de remate por mora o custodia
    -- Fecha de Modificación      : 2025.12.05
    -- Autor de la Modificación   : JALVAROH 
    -- Descripción de Modificación: Se agregan filtros ROW_NUMBER para evitar duplicidad de registros.
    -- ******************************************************************************************
   is
    fecha   DATE;
    err_num NUMBER;
    err_msg VARCHAR2(255);
  begin
  
    SELECT TRUNC(SYSDATE) INTO fecha FROM DUAL;
  
    delete from AQPB604
     where AQPB604USUR = p_Analis
       and AQPB604CREM = p_CodRem;
    COMMIT;
  
    RESULTADO := 0;
  
    Begin
    
      insert into AQPB604
        (AQPB604CSUC,
         AQPB604SUCU,
         AQPB604LOTE,
         AQPB604DEUD,
         AQPB604DLOT,
         AQPB604FADJ,
         AQPB604CREM,
         AQPB604FREM,
         AQPB604FVEN,
         AQPB604TDOC,
         AQPB604NDOC,
         AQPB604MADJ,
         AQPB604MLET,
         AQPB604CAPI,
         AQPB604INTE,
         AQPB604CUEN,
         AQPB604OPER,
         AQPB60414k,
         AQPB60418k,
         AQPB60421K,
         AQPB604ELOT,
         AQPB604FDES,
         AQPB604FDEV,
         AQPB604COMP,
         AQPB604DNI,
         AQPB604USUR,
         AQPB604FECR,
         AQPB604TIPREM)
        select /*+all_rows*/
         t01.sucurs CODSUC,
         t01.scnom Sucursal,
         lt.Pp174cod LOTE,
         d01.penom DEUDOR,
         trim((select p178.pp178dcom
                from fpp178 p178
               where p178.pp174cod = p175.pp174cod
                 and p178.pp177codd = 19)) DESCRIPCION,
         (case
           when z442.qz442aux1 in (1, 99) or
                (select count(*)
                   from fpp183
                  where pp174cod = z442.pp174cod
                    and pp183fec >= fecRem.Qz441dfec
                    and pp182cod = 10
                    and pp183con = 'S') > 0 then
            (select p183.pp183fec
               from fpp183 p183
              where p183.pp174cod = z442.pp174cod
                and p183.pp182cod = 10
                and p183.pp183con = 'S')
           else
            null
         end) "FECHA ADJ",
         z442.qz440codre "CODIGO REMATE",
         fecRem.Qz441dfec FECHA_REMATE,
         trunc(comp.qz445ufec) FECHA_VENDIDO,
         'DNI/LE' TIPDOC,
         d01.pendoc NUMDOC,
         (case
           when z442.qz442aux1 in (1, 99) or
                (select count(*)
                   from fpp183
                  where pp174cod = z442.pp174cod
                    and pp183fec >= fecRem.Qz441dfec
                    and pp182cod = 10
                    and pp183con = 'S') > 0 then
            (select h016.hcimp6
               from fpp183 p183
               join fsh016 h016
                 on h016.pgcod = p183.pp183pgcod
                and h016.hcmod = p183.pp183mod
                and h016.hsucor = p183.pp183suc
                and h016.htran = p183.pp183tran
                and h016.hnrel = p183.pp183nrel
                and h016.hfcon = p183.pp183fcon
                and h016.hcord = 10
              where p183.pp174cod = z442.pp174cod
                and p183.pp182cod = 10
                and p183.pp183con = 'S')
           else
            null
         end) MTOADJ,
         UPPER(fn_letras((case
                           when z442.qz442aux1 in (1, 99) or
                                (select count(*)
                                   from fpp183
                                  where pp174cod = z442.pp174cod
                                    and pp183fec >= fecRem.Qz441dfec
                                    and pp182cod = 10
                                    and pp183con = 'S') > 0 then
                            (select h016.hcimp6
                               from fpp183 p183
                               join fsh016 h016
                                 on h016.pgcod = p183.pp183pgcod
                                and h016.hcmod = p183.pp183mod
                                and h016.hsucor = p183.pp183suc
                                and h016.htran = p183.pp183tran
                                and h016.hnrel = p183.pp183nrel
                                and h016.hfcon = p183.pp183fcon
                                and h016.hcord = 10
                              where p183.pp174cod = z442.pp174cod
                                and p183.pp182cod = 10
                                and p183.pp183con = 'S')
                           else
                            null
                         end))) LETRAS,
         (select h016.hcimp1
            from fpp183 p183
            join fsh016 h016
              on h016.pgcod = p183.pp183pgcod
             and h016.hcmod = p183.pp183mod
             and h016.hsucor = p183.pp183suc
             and h016.htran = p183.pp183tran
             and h016.hnrel = p183.pp183nrel
             and h016.hfcon = p183.pp183fcon
             and h016.hcord = 10
           where p183.pp174cod = z442.pp174cod
             and p183.pp182cod = 10
             and p183.pp183con = 'S') CAPITAL,
         nvl((select h016.hcimp2 + h016.hcimp3 + h016.hcimp4 + h016.hcimp5
               from fpp183 p183
               join fsh016 h016
                 on h016.pgcod = p183.pp183pgcod
                and h016.hcmod = p183.pp183mod
                and h016.hsucor = p183.pp183suc
                and h016.htran = p183.pp183tran
                and h016.hnrel = p183.pp183nrel
                and h016.hfcon = p183.pp183fcon
                and h016.hcord = 10
              where p183.pp174cod = z442.pp174cod
                and p183.pp182cod = 10
                and p183.pp183con = 'S'),
             0) IntOtr,
         p175.pp175cta CUENTA,
         p175.pp175oper OPERACION,
         (select pp181cant
            from fpp181
           where pp174cod = p74.pp174cod
             and pp170cbien = 1
             and pp171tbien = 1) "14k",
         (select pp181cant
            from fpp181
           where pp174cod = p74.pp174cod
             and pp170cbien = 1
             and pp171tbien = 2) "18k",
         (select pp181cant
            from fpp181
           where pp174cod = p74.pp174cod
             and pp170cbien = 1
             and pp171tbien = 3) "21K",
         (case
           when trim(es.pp182desc) = 'Devuelto' and trim(comp.qz445cmp) = '' then
            'Comprado'
           else
            trim(es.pp182desc)
         end) "Estado del Lote",
         (case
           when z442.qz442aux1 in (1, 99) or
                (select count(*)
                   from fpp183
                  where pp174cod = z442.pp174cod
                    and pp183fec >= fecRem.Qz441dfec
                    and pp182cod = 10
                    and pp183con = 'S') > 0 then
            (select p183.pp183fec
               from fpp183 p183
              where p183.pp174cod = z442.pp174cod
                and p183.pp182cod = 12
                and p183.pp183con = 'S')
           else
            null
         end) "FECHA DESMONTAJE",
         
         (case
           when z442.qz442aux1 in (1, 99) or
                (select count(*)
                   from fpp183
                  where pp174cod = z442.pp174cod
                    and pp183fec >= fecRem.Qz441dfec
                    and pp182cod = 10
                    and pp183con = 'S') > 0 then
            (select p183.pp183fec
               from fpp183 p183
              where p183.pp174cod = z442.pp174cod
                and p183.pp182cod = 11
                and p183.pp183con = 'S')
           else
            null
         end) "FECHA DEVOLUCION",
         comp.qz445cmp Comprador,
         datCom.Qz444pnd DNI,
         p_Analis,
         fecha,
         (case
           when z442.QZ442AUX7 = 1 then
            'MORA'
           when z442.QZ442AUX7 = 2 then
            'CUSTODIA'
           else
            null
         end) "TIPO DE REMATE"
          from jaqz440 z440
          left join jaqz442 z442
            on z440.qz440codre = z442.qz440codre
        
        -- [MEJORA ANTI-DUPLICIDAD] CAMBIO 1: Filtramos FPP175 para traer solo 1 saldo vigente por Lote
          left join (select x.*,
                            ROW_NUMBER() OVER(PARTITION BY x.pp174cod ORDER BY x.pp175mod DESC, x.pp175oper DESC) as rn_unico
                       from fpp175 x
                      where x.pp175tco = 'S') p175
            on p175.pp174cod = z442.pp174cod
           and p175.rn_unico = 1
        
          left join jaqz441 fecRem
            on z442.qz440codre = fecrem.qz440codre
           and fecrem.pp177codd = 1 --fecha de remate 
          left join fsr008 r08
            on r08.pgcod = p175.pp175pgcod
           and r08.ctnro = p175.pp175cta
           and r08.ttcod = 1
           and r08.cttfir = 'T'
          left join fsd001 d01
            on d01.pepais = r08.pepais
           and d01.petdoc = r08.petdoc --descripcion persona
           and d01.pendoc = r08.pendoc
          left join fst001 t01
            on t01.pgcod = p175.pp175pgcod
           and t01.sucurs = p175.pp175suc --sucursal                           
          left join fst005 t05
            on t05.moneda = p175.pp175mda --moneda
          left join fsh016 h16
            on h16.pgcod = p175.pp175tpgc
           and h16.hcmod = p175.pp175tmod
           and h16.hsucor = p175.pp175tsuc
           and h16.htran = p175.pp175ttran
           and h16.hnrel = p175.pp175tnrel
           and h16.hfcon = p175.pp175tfco
           and h16.hcord = p175.pp175tord
          left join bnj096 b96
            on b96.bnj096suc = p175.pp175suc
           and b96.bnj096mda = p175.pp175mda
           and b96.bnj096pap = p175.pp175pap
           and b96.bnj096cta = p175.pp175cta
           and b96.bnj096ope = p175.pp175oper
           and b96.bnj096sub = p175.pp175sbop
           and b96.bnj096mod = p175.pp175mod
           and b96.bnj096top = p175.pp175tope
        -- Se mantiene la logica de LT, pero al estar P175 ya filtrado, esto no generará duplicados adicionales
          left join (select distinct PP175PGCOD,
                                     PP175MOD,
                                     PP175SUC,
                                     PP175MDA,
                                     PP175PAP,
                                     PP175CTA,
                                     PP175OPER,
                                     PP175SBOP,
                                     PP175TOPE,
                                     Pp174cod
                       from Fpp175
                      where pp175tco = 'S') lt
            on lt.PP175PGCOD = p175.pp175pgcod
           and lt.PP175MOD = p175.pp175mod
           and lt.PP175SUC = p175.pp175suc
           and lt.PP175MDA = p175.pp175mda
           and lt.PP175PAP = p175.pp175pap
           and lt.PP175CTA = p175.pp175cta
           and lt.PP175OPER = p175.pp175oper
           and lt.PP175TOPE = p175.pp175tope
          left join fpp174 p74
            on p74.pp173cod = lt.PP175PGCOD
           and p74.pp174cod = lt.Pp174cod
          left join (select nd.*
                       from fpp183 nd
                      where nd.pp183cod =
                            (select max(pp183cod)
                               from fpp183 y
                              where y.pp174cod = nd.pp174cod)) est
            on est.PP174COD = lt.Pp174cod
          left join fpp182 es
            on es.pp182cod = est.pp182cod
        
        -- [MEJORA ANTI-DUPLICIDAD] CAMBIO 2: Filtramos JAQZ445 para traer solo el último registro de comprador por Lote
          left join (select c.*,
                            ROW_NUMBER() OVER(PARTITION BY c.pp174cod ORDER BY c.qz445ufec DESC) as rn_comp
                       from jaqz445 c) comp
            on lt.Pp174cod = comp.pp174cod
           and comp.rn_comp = 1
        
          left join jaqz444 datCom
            on comp.qz440codre = datcom.qz440codre
           and comp.qz444cdcmp = datcom.qz444cdcmp
         where z440.qz440codre = p_CodRem;
      COMMIT;
    
      RESULTADO := 1;
    exception
      when no_data_found then
        RESULTADO := 0;
        err_num   := SQLCODE;
        err_msg   := SQLERRM;
        DBMS_OUTPUT.put_line('Error:' || TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(err_msg);
      when others then
        RESULTADO := -1;
        err_num   := SQLCODE;
        err_msg   := SQLERRM;
        DBMS_OUTPUT.put_line('Error:' || TO_CHAR(err_num));
        DBMS_OUTPUT.put_line(err_msg);
    end;
  
  end SP_Rep_Adjudicados;

  --************************************************************************************
  procedure SP_Rep_Adjudicados_0(p_CodRem  in NUMBER,
                                 p_Analis  in VARCHAR2,
                                 RESULTADO IN OUT NUMBER) is
    cursor lst_lotes(CodRem Number) is
      select distinct lt.Pp174cod LOTE,
                      z442.qz440codre,
                      h16.hcimp1 CAPITAL,
                      h16.hcimp6 - h16.hcimp1 IntOtr,
                      p175.pp175cta CUENTA,
                      p175.pp175oper OPERACION,
                      ------------------------------------
                      p175.pp175pgcod,
                      p175.pp175suc,
                      p175.pp174cod,
                      z442.qz442aux1,
                      est.pp182cod
        from jaqz440 z440
        left join jaqz442 z442
          on z440.qz440codre = z442.qz440codre
        left join fpp175 p175
          on p175.pp174cod = z442.pp174cod
         and p175.pp175tco = 'S' --vigente 
        left join fsh016 h16
          on h16.pgcod = p175.pp175tpgc
         and h16.hcmod = p175.pp175tmod -- solo aca es el left quitar el left en pase a produccion
         and h16.hsucor = p175.pp175tsuc
         and h16.htran = p175.pp175ttran
         and h16.hnrel = p175.pp175tnrel
         and h16.hfcon = p175.pp175tfco
         and h16.hcord = p175.pp175tord
        left join bnj096 b96
          on b96.bnj096suc = p175.pp175suc
         and b96.bnj096mda = p175.pp175mda --????????
         and b96.bnj096pap = p175.pp175pap
         and b96.bnj096cta = p175.pp175cta
         and b96.bnj096ope = p175.pp175oper
         and b96.bnj096sub = p175.pp175sbop
         and b96.bnj096mod = p175.pp175mod
         and b96.bnj096top = p175.pp175tope
        left join (select distinct PP175PGCOD,
                                   PP175MOD,
                                   PP175SUC,
                                   PP175MDA,
                                   PP175PAP,
                                   PP175CTA --lote????????
                                  ,
                                   PP175OPER,
                                   PP175SBOP,
                                   PP175TOPE,
                                   Pp174cod
                     from Fpp175
                    where pp175tco = 'S') lt
          on lt.PP175PGCOD = p175.pp175pgcod
         and lt.PP175MOD = p175.pp175mod
         and lt.PP175SUC = p175.pp175suc
         and lt.PP175MDA = p175.pp175mda
         and lt.PP175PAP = p175.pp175pap
         and lt.PP175CTA = p175.pp175cta
         and lt.PP175OPER = p175.pp175oper
         and lt.PP175TOPE = p175.pp175tope
        left join fpp174 p74
          on p74.pp173cod = lt.PP175PGCOD
         and p74.pp174cod = lt.Pp174cod --lote  ???
        left join (select nd.*
                     from fpp183 nd
                    where nd.pp183cod =
                          (select max(pp183cod)
                             from fpp183 y
                            where y.pp174cod = nd.pp174cod)) est
          on est.PP174COD = lt.Pp174cod
       where z440.qz440codre = CodRem; -- and lt.Pp174cod = 94308;
  
    fecha DATE;
  
    --err_num NUMBER;
    --err_msg VARCHAR2(255);
    ------------------------------
    sucurs fst001.sucurs%type;
    scnom  fst001.scnom%type;
  
    penom     fsd001.penom%type;
    pendoc    fsd001.pendoc%type;
    pp178dcom fpp178.pp178dcom%type;
  
    FecAdj fpp183.pp183fec%type;
  
    FecRem jaqz441.Qz441dfec%type;
  
    FecVen   date;
    qz445cmp jaqz445.qz445cmp%type;
    Qz444pnd jaqz444.Qz444pnd%type;
  
    MntAdj fsh016.hcimp6%type;
  
    k14 fpp181.pp181cant %type;
    k18 fpp181.pp181cant %type;
    k21 fpp181.pp181cant %type;
  
    EstLot varchar2(500);
  
    FecDesmon fpp183.pp183fec%type;
    FecDevolu fpp183.pp183fec%type;
  
    cont1 number;
    cont2 number;
    cont3 number;
    cont4 number;
  
  begin
  
    SELECT TRUNC(SYSDATE) INTO fecha FROM DUAL;
  
    delete from AQPB604
     where AQPB604USUR = p_Analis
       and AQPB604CREM = p_CodRem;
    COMMIT;
  
    RESULTADO := 0;
  
    for i in lst_lotes(p_CodRem) loop
      --suscursal
      BEGIN
        select t01.sucurs, t01.scnom
          into sucurs, scnom
          from fst001 t01
         where t01.pgcod = i.pp175pgcod
           and t01.sucurs = i.pp175suc;
      EXCEPTION
        WHEN others THEN
          sucurs := '';
          scnom  := '';
      END;
    
      --deudor
      BEGIN
        select d01.penom DEUDOR, d01.pendoc NUMDOC
          into penom, pendoc
          from fsr008 r08
          left join fsd001 d01
            on d01.pepais = r08.pepais
           and d01.petdoc = r08.petdoc
           and d01.pendoc = r08.pendoc --descripcion persona
         where r08.pgcod = i.pp175pgcod
           and r08.ctnro = i.CUENTA
           and r08.ttcod = 1
           and r08.cttfir = 'T';
      EXCEPTION
        WHEN too_many_rows THEN
          select d01.penom DEUDOR, d01.pendoc NUMDOC
            into penom, pendoc
            from fsr008 r08
           inner join fsd001 d01
              on d01.pepais = r08.pepais
             and d01.petdoc = r08.petdoc
             and d01.pendoc = r08.pendoc --descripcion persona
           where r08.pgcod = i.pp175pgcod
             and r08.ctnro = i.CUENTA
             and r08.ttcod = 1
             and r08.cttfir = 'T'
             and ROWNUM = 1;
        WHEN others THEN
          penom := '';
      END;
    
      --DESCRIPCION
      BEGIN
        select p178.pp178dcom
          into pp178dcom
          from fpp178 p178
         where p178.pp174cod = i.pp174cod
           and p178.pp177codd = 19;
      EXCEPTION
        WHEN others THEN
          pp178dcom := '';
      END;
    
      --fecha remate
      BEGIN
        select fecRem.Qz441dfec FECHA_REMATE
          into FecRem
          from jaqz441 fecRem
         where fecrem.qz440codre = i.qz440codre
           and fecrem.pp177codd = 1;
      EXCEPTION
        WHEN others THEN
          FecRem := null;
      END;
    
      select count(*)
        into cont1
        from fpp183
       where pp174cod = i.pp174cod
         and pp183fec >= FecRem
         and pp182cod = 10
         and pp183con = 'S';
      --fecha adjudicacion
      BEGIN
        if i.qz442aux1 = 1 or i.qz442aux1 = 99 or cont1 > 0 then
        
          select p183.pp183fec
            into FecAdj
            from fpp183 p183
           where p183.pp174cod = i.pp174cod
             and p183.pp182cod = 10
             and p183.pp183con = 'S';
        else
          FecAdj := null;
        end if;
      EXCEPTION
        WHEN others THEN
          FecAdj := null;
      END;
    
      --datos comprador
      BEGIN
        select trunc(comp.qz445ufec) FECHA_VENDIDO,
               comp.qz445cmp Comprador,
               datCom.Qz444pnd DNI
          into FecVen, qz445cmp, Qz444pnd
          from jaqz445 comp
          left join jaqz444 datCom
            on comp.qz440codre = datcom.qz440codre
           and comp.qz444cdcmp = datcom.qz444cdcmp
         where comp.pp174cod = i.LOTE;
      EXCEPTION
        WHEN others THEN
          FecVen   := '';
          qz445cmp := '';
          Qz444pnd := '';
      END;
    
      select count(*)
        into cont2
        from fpp183
       where pp174cod = i.pp174cod
         and pp183fec >= fecRem
         and pp182cod = 10
         and pp183con = 'S';
      --monto adjudicado
      BEGIN
        if i.qz442aux1 = 1 or i.qz442aux1 = 99 or cont2 > 0 then
        
          select h016.hcimp6
            into MntAdj
            from fpp183 p183
            join fsh016 h016
              on h016.pgcod = p183.pp183pgcod
             and h016.hcmod = p183.pp183mod
             and h016.hsucor = p183.pp183suc
             and h016.htran = p183.pp183tran
             and h016.hnrel = p183.pp183nrel
             and h016.hfcon = p183.pp183fcon
             and h016.hcord = 10
           where p183.pp174cod = i.pp174cod
             and p183.pp182cod = 10
             and p183.pp183con = 'S';
        else
          MntAdj := '';
        end if;
      EXCEPTION
        WHEN others THEN
          MntAdj := '';
      END;
    
      --monto letras
      --UPPER(fn_letras()) LETRAS,
    
      --14 - 18 - 21 k
      BEGIN
        select pp181cant
          into k14
          from fpp181
         where pp174cod = i.pp174cod
           and pp170cbien = 1
           and pp171tbien = 1;
      
        select pp181cant
          into k18
          from fpp181
         where pp174cod = i.pp174cod
           and pp170cbien = 1
           and pp171tbien = 2;
      
        select pp181cant
          into k21
          from fpp181
         where pp174cod = i.pp174cod
           and pp170cbien = 1
           and pp171tbien = 3;
      EXCEPTION
        WHEN others THEN
          k14 := '';
          k18 := '';
          k21 := '';
      END;
    
      --Estado del Lote
      BEGIN
        select trim(es.pp182desc)
          into EstLot
          from fpp182 es
         where es.pp182cod = i.pp182cod;
      EXCEPTION
        WHEN others THEN
          EstLot := '';
      END;
    
      select count(*)
        into cont3
        from fpp183
       where pp174cod = i.pp174cod
         and pp183fec >= fecRem
         and pp182cod = 10
         and pp183con = 'S';
      --FECHA DESMONTAJE
      BEGIN
        if i.qz442aux1 = 1 or i.qz442aux1 = 99 or cont3 > 0 then
        
          select p183.pp183fec
            into FecDesmon
            from fpp183 p183
           where p183.pp174cod = i.pp174cod
             and p183.pp182cod = 12
             and p183.pp183con = 'S';
        else
          FecDesmon := null;
        end if;
      EXCEPTION
        WHEN others THEN
          FecDesmon := null;
      END;
    
      select count(*)
        into cont4
        from fpp183
       where pp174cod = i.pp174cod
         and pp183fec >= fecRem
         and pp182cod = 10
         and pp183con = 'S';
      --FECHA DEVOLUCION
      BEGIN
        if i.qz442aux1 = 1 or i.qz442aux1 = 99 or cont4 > 0 then
        
          select p183.pp183fec
            into FecDevolu
            from fpp183 p183
           where p183.pp174cod = i.pp174cod
             and p183.pp182cod = 11
             and p183.pp183con = 'S';
        else
          FecDevolu := null;
        end if;
      EXCEPTION
        WHEN others THEN
          FecDevolu := null;
      END;
    
      --INSERT
      BEGIN
        insert into AQPB604
          (AQPB604CSUC,
           AQPB604SUCU,
           AQPB604LOTE,
           AQPB604DEUD,
           AQPB604DLOT,
           AQPB604FADJ,
           AQPB604CREM,
           AQPB604FREM,
           AQPB604FVEN,
           AQPB604TDOC,
           AQPB604NDOC,
           AQPB604MADJ,
           AQPB604MLET,
           AQPB604CAPI,
           AQPB604INTE,
           AQPB604CUEN,
           AQPB604OPER,
           AQPB60414k,
           AQPB60418k,
           AQPB60421K,
           AQPB604ELOT,
           AQPB604FDES,
           AQPB604FDEV,
           AQPB604COMP,
           AQPB604DNI,
           AQPB604USUR,
           AQPB604FECR)
        values
          (sucurs,
           scnom,
           i.LOTE,
           penom,
           pp178dcom,
           FecAdj,
           i.qz440codre,
           FecRem,
           FecVen,
           'DNI/LE',
           pendoc,
           MntAdj,
           UPPER(fn_letras(MntAdj)),
           i.CAPITAL,
           i.IntOtr,
           i.CUENTA,
           i.OPERACION,
           k14,
           k18,
           k21,
           EstLot,
           FecDesmon,
           FecDevolu,
           qz445cmp,
           Qz444pnd,
           p_Analis,
           fecha);
      
        commit;
      EXCEPTION
        WHEN others THEN
          null;
      END;
    
    end loop;
  
  end SP_Rep_Adjudicados_0;

  --************************************************************************************
  Function FN_Deuda_Total(pn_emp_1  in number,
                          pn_mod_1  in number,
                          pn_suc_1  in number,
                          pn_mda_1  in number,
                          pn_pap_1  in number,
                          pn_cta_1  in number,
                          pn_ope_1  in number,
                          pn_sbo_1  in number,
                          pn_top_1  in number,
                          pd_fecpro in date) return number is
    ln_mto      number(17, 2);
    ln_morTotal number(17, 2);
    ln_comTotal number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
  
    pn_emp number(3);
    pn_mod number(3);
    pn_suc number(3);
    pn_mda number(4);
    pn_pap number(3);
    pn_cta number(9);
    pn_ope number(9);
    pn_sbo number(3);
    pn_top number(3);
    pd_fec date;
    pn_cap number(17, 2);
    pn_int number(17, 2);
  
  begin
    begin
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag,
             a.ppcap,
             a.ppint --, pd_fecpro
        into pn_emp,
             pn_mod,
             pn_suc,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top,
             pd_fec,
             pn_cap,
             pn_int
        from fsd601 a
       where a.pgcod = pn_emp_1
         and a.ppmod = pn_mod_1
         and a.ppsuc = pn_suc_1
         and a.ppmda = pn_mda_1
         and a.pppap = pn_pap_1
         and a.ppcta = pn_cta_1
         and a.ppoper = pn_ope_1
         and a.ppsbop = pn_sbo_1
         and a.pptope = pn_top_1
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;
    exception
      when others then
        null;
    end;
  
    ln_capTotal := nvl(pn_cap, 0);
    ln_intTotal := nvl(pn_int, 0);
  
    --interes compensatorio                    
    ln_comTotal := FN_Interes_Compensatorio(pn_emp_1,
                                            pn_mod_1,
                                            pn_suc_1,
                                            pn_mda_1,
                                            pn_pap_1,
                                            pn_cta_1,
                                            pn_ope_1,
                                            pn_sbo_1,
                                            pn_top_1,
                                            pd_fecpro);
  
    --interes moratorio 
    ln_morTotal := FN_Interes_Moratorio(pn_emp_1,
                                        pn_mod_1,
                                        pn_suc_1,
                                        pn_mda_1,
                                        pn_pap_1,
                                        pn_cta_1,
                                        pn_ope_1,
                                        pn_sbo_1,
                                        pn_top_1,
                                        pd_fecpro);
  
    ln_mto := nvl(ln_morTotal, 0) + nvl(ln_capTotal, 0) +
              nvl(ln_intTotal, 0) -- + nvl(ln_comTotal,0) PREGUNTAR SI SUMAMOS EL COMPENSATORIO
     ;
    return ln_mto;
  end FN_Deuda_Total;

  --************************************************************************************
  Function FN_Interes_Moratorio(pn_emp_1  in number,
                                pn_mod_1  in number,
                                pn_suc_1  in number,
                                pn_mda_1  in number,
                                pn_pap_1  in number,
                                pn_cta_1  in number,
                                pn_ope_1  in number,
                                pn_sbo_1  in number,
                                pn_top_1  in number,
                                pd_fecpro in date) return number is
    ln_morTotal Number(17, 2);
    ln_mor      number(17, 2);
    ln_tasmor   number(10, 5);
    ln_dia      number(5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
    ln_morA     number(17, 2);
  
    pn_emp number(3);
    pn_mod number(3);
    pn_suc number(3);
    pn_mda number(4);
    pn_pap number(3);
    pn_cta number(9);
    pn_ope number(9);
    pn_sbo number(3);
    pn_top number(3);
    pd_fec date;
    pn_cap number(17, 2);
    pn_int number(17, 2);
  
  begin
    begin
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag,
             a.ppcap,
             a.ppint --, pd_fecpro
        into pn_emp,
             pn_mod,
             pn_suc,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top,
             pd_fec,
             pn_cap,
             pn_int
        from fsd601 a
       where a.pgcod = pn_emp_1
         and a.ppmod = pn_mod_1
         and a.ppsuc = pn_suc_1
         and a.ppmda = pn_mda_1
         and a.pppap = pn_pap_1
         and a.ppcta = pn_cta_1
         and a.ppoper = pn_ope_1
         and a.ppsbop = pn_sbo_1
         and a.pptope = pn_top_1
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;
    exception
      when others then
        null;
    end;
  
    --tasa de mora                                                    
    ln_tasmor := pq_cr_cuotamora.BT_Tasa_Mora(pn_emp,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
  
    ln_dia := pd_fecpro - pd_fec;
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
  
    --interes moratorio
    ln_mor := round((Power(1 + (ln_tasmor / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
  
    ln_morTotal := nvl(ln_mor, 0) - nvl(ln_morA, 0);
    return ln_morTotal;
  end FN_Interes_Moratorio;

  --************************************************************************************
  Function FN_Interes_Compensatorio(pn_emp_1  in number,
                                    pn_mod_1  in number,
                                    pn_suc_1  in number,
                                    pn_mda_1  in number,
                                    pn_pap_1  in number,
                                    pn_cta_1  in number,
                                    pn_ope_1  in number,
                                    pn_sbo_1  in number,
                                    pn_top_1  in number,
                                    pd_fecpro in date) return number is
    ln_comTotal Number(17, 2);
    ln_tasint   number(10, 5);
    ln_dia      number(5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
  
    pn_emp number(3);
    pn_mod number(3);
    pn_suc number(3);
    pn_mda number(4);
    pn_pap number(3);
    pn_cta number(9);
    pn_ope number(9);
    pn_sbo number(3);
    pn_top number(3);
    pd_fec date;
    pn_cap number(17, 2);
    pn_int number(17, 2);
  
  begin
    begin
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag,
             a.ppcap,
             a.ppint --, pd_fecpro
        into pn_emp,
             pn_mod,
             pn_suc,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top,
             pd_fec,
             pn_cap,
             pn_int
        from fsd601 a
       where a.pgcod = pn_emp_1
         and a.ppmod = pn_mod_1
         and a.ppsuc = pn_suc_1
         and a.ppmda = pn_mda_1
         and a.pppap = pn_pap_1
         and a.ppcta = pn_cta_1
         and a.ppoper = pn_ope_1
         and a.ppsbop = pn_sbo_1
         and a.pptope = pn_top_1
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;
    exception
      when others then
        null;
    end;
  
    --tasa de interes
    ln_tasint := pq_cr_cuotamora.BT_Tasa_Interes(pn_emp,
                                                 pn_mod,
                                                 pn_suc,
                                                 pn_mda,
                                                 pn_pap,
                                                 pn_cta,
                                                 pn_ope,
                                                 pn_sbo,
                                                 pn_top);
  
    ln_dia := pd_fecpro - pd_fec;
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
  
    --interes compensatorio
    ln_comTotal := round((Power(1 + (ln_tasint / 100), (ln_dia / 360)) - 1) *
                         (ln_capTotal + ln_intTotal),
                         2);
    return ln_comTotal;
  end FN_Interes_Compensatorio;

end PQ_REPORT_LOTES;
/
