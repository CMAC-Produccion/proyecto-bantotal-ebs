create or replace package PQ_CR_MONTO_CAPITALIZADO is

  -- *****************************************************************
  -- NOMBRE                     : PQ_CR_MONTO_CAPITALIZADO
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CRÉDITOS - ACTIVAS
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 2024.03.04
  -- AUTOR DE CREACIÓN          : APACHECOH
  -- USO                        : BUSCA DATOS CONSULTA BURO
  -- ESTADO                     : ACTIVO
  -- ACCESO                     : PÚBLICO
  -- FECHA DE MODIFICACIÓN      : 2024.03.27
  -- AUTOR DE LA MODIFICACIÓN   : APACHECOH
  -- DESCRIPCIÓN DE MODIFICACIÓN: Se actualizó la devolución del procedimiento
  -- FECHA DE MODIFICACIÓN      : 2024.05.23
  -- AUTOR DE LA MODIFICACIÓN   : APACHECOH
  -- DESCRIPCIÓN DE MODIFICACIÓN: Se actualizó el interes deudor
  -- FECHA DE MODIFICACIÓN      : 2024.05.29
  -- AUTOR DE LA MODIFICACIÓN   : APACHECOH
  -- DESCRIPCIÓN DE MODIFICACIÓN: Se cambio la historia por la AQPB838
  -- ***************************************************************** 
  PROCEDURE SP_CR_GRABAR_LOG_HISTORIA_N(P_N_CTA  IN NUMBER,
                                        P_N_OPER IN NUMBER,
                                        P_V_USU  IN VARCHAR2);

  PROCEDURE SP_CR_GRABAR_LOG_HISTORIA(P_N_CTA  IN NUMBER,
                                      P_N_OPER IN NUMBER,
                                      P_V_USU  IN VARCHAR2);

  PROCEDURE SP_CR_OBTENER_MONTO_CAPITALIZADO_N(P_N_CTA      IN NUMBER,
                                               P_N_OPER     IN NUMBER,
                                               P_V_USU      IN VARCHAR2,
                                               P_D_ULT_FEC  OUT DATE,
                                               P_N_TOT_MONT OUT NUMBER,
                                               P_V_ERROR    OUT VARCHAR2);

  PROCEDURE SP_CR_OBTENER_MONTO_CAPITALIZADO(P_N_CTA      IN NUMBER,
                                             P_N_OPER     IN NUMBER,
                                             P_V_USU      IN VARCHAR2,
                                             P_D_ULT_FEC  OUT DATE,
                                             P_N_TOT_MONT OUT NUMBER,
                                             P_V_ERROR    OUT VARCHAR2);

end PQ_CR_MONTO_CAPITALIZADO;
/

create or replace package body PQ_CR_MONTO_CAPITALIZADO is

  PROCEDURE SP_CR_GRABAR_LOG_HISTORIA(P_N_CTA  IN NUMBER,
                                      P_N_OPER IN NUMBER,
                                      P_V_USU  IN VARCHAR2) IS
    V_ERROR VARCHAR2(1000);
  
    V_AQPC955PAIS NUMBER(4);
    V_AQPC955TDOC NUMBER(4);
    V_AQPC955NDOC VARCHAR2(12);
  
    V_AQPC955CORR NUMBER(10);
    V_AQPC955COR  NUMBER(10);
    V_AQPC955INST NUMBER(10);
    V_AQPC955ESTA VARCHAR2(2);
    L_PGCOD       NUMBER(3);
    L_HCMOD       NUMBER(5);
    L_HTRAN       NUMBER(5);
    L_HNREL       NUMBER(7);
    L_HSUCOR      NUMBER(4);
    L_HFCON       DATE;
    L_SIG_FEC     DATE;
    V_AQPC955IMP1 NUMBER(17, 2);
    V_AQPC955IMP2 NUMBER(17, 2);
    V_AQPC955MONT NUMBER(17, 2);
    V_AQPC955AUX1 NUMBER(17, 2);
  
    CURSOR HISTORIA(P_N_CTA NUMBER, P_N_OPER NUMBER) IS
      select *
        from (select j.jaqz698fep AQPC955FEP,
                     j.jaqz698cor AQPC955COR,
                     j.jaqz698emp AQPC955EMP,
                     j.jaqz698mod AQPC955MOD,
                     j.jaqz698suc AQPC955SUC,
                     j.jaqz698mda AQPC955MDA,
                     j.jaqz698pap AQPC955PAP,
                     j.jaqz698cta AQPC955CTA,
                     j.jaqz698ope AQPC955OPER,
                     j.jaqz698sbo AQPC955SBOP,
                     j.jaqz698top AQPC955TOPE,
                     j.jaqz698inst AQPC955INST,
                     j.jaqz698est AQPC955ESTA,
                     'MASIVA' AQPC955MODO,
                     'NO CONTABLE' AQPC955CONT,
                     'REPROGRAMACION' AQPC955TIPO,
                     'JAQZ698' AQPC955SUBT,
                     'Reprogramacion Sin Capitalizacion Masiva' AQPC955TRXD
                from jaqz698 j
               where j.jaqz698cta = P_N_CTA
                 and j.jaqz698ope = P_N_OPER
                 and j.jaqz698est in ('C', 'Z')
              union
              select k.jaqa400fec,
                     0,
                     k.jaqa400emp,
                     k.jaqa400mod,
                     k.jaqa400suc,
                     k.jaqa400mda,
                     k.jaqa400pap,
                     k.jaqa400cta,
                     k.jaqa400ope,
                     k.jaqa400sbo,
                     k.jaqa400top,
                     k.jaqa400ai1,
                     k.jaqa400est,
                     'INDIVIDUAL',
                     'NO CONTABLE',
                     'REPROGRAMACION',
                     'JAQA400',
                     'Reprogramacion Sin Capitalizacion Individual'
                from jaqa400 k
               where k.jaqa400cta = P_N_CTA
                 and k.jaqa400ope = P_N_OPER
                 and k.jaqa400est = 'C'
              UNION
              select /*+ all_rows */
               AQPC955FEP,
               AQPC955COR,
               max(AQPC955EMP),
               max(AQPC955MOD),
               max(AQPC955SUC),
               max(AQPC955MDA),
               max(AQPC955PAP),
               max(AQPC955CTA),
               max(AQPC955OPER),
               max(AQPC955SBOP),
               max(AQPC955TOPE),
               AQPC955INST,
               AQPC955ESTA,
               AQPC955MODO,
               AQPC955CONT,
               AQPC955TIPO,
               AQPC955SUBT,
               AQPC955TRXD
                from (select /*+ all_rows */
                      DISTINCT d.hfcon AQPC955FEP,
                               0 AQPC955COR,
                               d.pgcod AQPC955EMP,
                               d.hmodul AQPC955MOD,
                               d.hsucor AQPC955SUC,
                               d.hmda AQPC955MDA,
                               d.hpap AQPC955PAP,
                               d.hcta AQPC955CTA,
                               d.hoper AQPC955OPER,
                               d.hsubop AQPC955SBOP,
                               d.htoper AQPC955TOPE,
                               0 AQPC955INST,
                               'C' AQPC955ESTA,
                               'INDIVIDUAL' AQPC955MODO,
                               'CONTABLE' AQPC955CONT,
                               CASE
                                 when t.tp1corr2 = 1 then
                                  'REFINANCIACION'
                                 when t.tp1corr2 = 2 then
                                  'REPROGRAMACION'
                               END AQPC955TIPO,
                               CONCAT(CONCAT(TO_CHAR(d.hcmod), '-'),
                                      TO_CHAR(d.htran)) AQPC955SUBT,
                               (select e.trnom
                                  from fst034 e
                                 where e.pgcod = 1
                                   and e.trmod = c.hcmod
                                   and e.trnro = c.htran) AQPC955TRXD
                        from fsh015 c, fsh016 d, fst198 t
                       where c.pgcod = d.pgcod
                         and c.hcmod = d.hcmod
                         and c.hsucor = d.hsucor
                         and c.htran = d.htran
                         and c.hnrel = d.hnrel
                         and c.hfcon = d.hfcon
                         and d.hcmod = t.tp1nro1
                         and d.htran = t.tp1nro2
                         and (d.hcord = t.tp1imp2 or d.hcord = t.tp1imp1)
                         and t.tp1cod = 1
                         and t.tp1cod1 = 11172
                         and t.tp1corr1 = 1
                         and t.tp1corr2 in (1, 2)
                         and c.hccorr = 0
                         and d.hcta = P_N_CTA
                         and d.hoper = P_N_OPER) T
               group by AQPC955FEP,
                        AQPC955COR,
                        AQPC955INST,
                        AQPC955ESTA,
                        AQPC955MODO,
                        AQPC955CONT,
                        AQPC955TIPO,
                        AQPC955SUBT,
                        AQPC955TRXD)
       order by 1;
  BEGIN
    --Limpieza de registros
    BEGIN
      UPDATE AQPC955
         SET AQPC955EHAB = 'I'
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Cargar historia de reprogramaciones y refinanciaciones
    V_AQPC955CORR := 0;
    FOR I IN HISTORIA(P_N_CTA, P_N_OPER) LOOP
      BEGIN
        SELECT PEPAIS, PETDOC, TRIM(PENDOC)
          INTO V_AQPC955PAIS, V_AQPC955TDOC, V_AQPC955NDOC
          FROM FSR008 A
         WHERE A.CTNRO = P_N_CTA
           AND A.CTTFIR = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          V_AQPC955PAIS := 0;
          V_AQPC955TDOC := 0;
          V_AQPC955NDOC := '';
      END;
      IF I.AQPC955SUBT = 'JAQA400' THEN
        BEGIN
          SELECT MAX(A.AQPB088COR)
            INTO V_AQPC955COR
            FROM AQPB088 A
           WHERE AQPB088CTA = P_N_CTA
             AND AQPB088OPE = P_N_OPER
             AND AQPB088FEP = I.AQPC955FEP;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955COR := 0;
        END;
      ELSE
        V_AQPC955COR := I.AQPC955COR;
      END IF;
      --Calculo del Monto Capitalizado 
      V_AQPC955IMP1 := 0;
      V_AQPC955IMP2 := 0;
      V_AQPC955MONT := 0;
      IF I.AQPC955SUBT = 'JAQA400' OR I.AQPC955SUBT = 'JAQZ698' THEN
        --Hallar instancia
        V_AQPC955INST := I.AQPC955INST;
        --Hallar la siguiente reprogramacion
        BEGIN
          select nvl(min(fep), to_date('01/01/2099', 'dd/mm/rrrr'))
            into L_SIG_FEC
            from (select j.jaqa400fec fep
                    from jaqa400 j
                   where j.jaqa400cta = P_N_CTA
                     and j.jaqa400ope = P_N_OPER
                     and j.jaqa400est = 'C'
                     and j.jaqa400fec > I.AQPC955FEP
                  union
                  select k.jaqz698fep
                    from jaqz698 k
                   where k.jaqz698cta = P_N_CTA
                     and k.jaqz698ope = P_N_OPER
                     and k.jaqz698est in ('C', 'Z')
                     and k.jaqz698fep > I.AQPC955FEP
                  union
                  select /*+ all_rows */
                  distinct d.hfcon fep
                    from fsh015 c, fsh016 d, fst198 t
                   where c.pgcod = d.pgcod
                     and c.hcmod = d.hcmod
                     and c.hsucor = d.hsucor
                     and c.htran = d.htran
                     and c.hnrel = d.hnrel
                     and c.hfcon = d.hfcon
                     and d.hcmod = t.tp1nro1
                     and d.htran = t.tp1nro2
                     and (d.hcord = t.tp1imp2)
                     and t.tp1cod = 1
                     and t.tp1cod1 = 11172
                     and t.tp1corr1 = 1
                     and t.tp1corr2 in (1, 2)
                     and c.hccorr = 0
                     and d.hcta = P_N_CTA
                     and d.hoper = P_N_OPER
                     and d.hfcon > I.AQPC955FEP);
        EXCEPTION
          WHEN OTHERS THEN
            L_SIG_FEC := to_date('01/01/2099', 'dd/mm/rrrr');
        END;
        --
        BEGIN
          select nvl((SUM(distinct f.pp1cap) * -1), 0)
            into V_AQPC955MONT
            from fsd602 f, fst198 t
           where f.pgcod = I.AQPC955EMP
             and f.ppmod = I.AQPC955MOD
             and f.ppsuc = I.AQPC955SUC
             and f.ppmda = I.AQPC955MDA
             and f.pppap = I.AQPC955PAP
             and f.ppcta = I.AQPC955CTA
             and f.ppoper = I.AQPC955OPER
             and f.ppsbop = I.AQPC955SBOP
             and f.pptope = I.AQPC955TOPE
             and f.pp1cap < 0
             and f.d602co = 'S'
             and t.tp1cod = 1
             and t.tp1cod1 = 10876
             and t.tp1corr1 = f.d602mo
             and t.tp1corr2 = f.d602tr
             and f.pp1fech >= I.AQPC955FEP
             and f.pp1fech < L_SIG_FEC;
          V_AQPC955IMP1 := V_AQPC955MONT;
          V_AQPC955AUX1 := V_AQPC955MONT;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955MONT := 0;
        END;
      ELSE
        --******************************************************************************
        --Hallar instancia
        BEGIN
          SELECT MAX(XWFPRCINS)
            INTO V_AQPC955INST
            FROM XWF700 X
           WHERE X.XWFEMPRESA = I.AQPC955EMP
             AND X.XWFMODULO = I.AQPC955MOD
                --AND X.XWFSUCURSAL = I.AQPC955SUC
             AND X.XWFMONEDA = I.AQPC955MDA
             AND X.XWFPAPEL = I.AQPC955PAP
             AND X.XWFCUENTA = I.AQPC955CTA
             AND X.XWFOPERACION = I.AQPC955OPER
                --AND X.XWFSUBOPE = I.AQPC955SBOP
             AND X.XWFTIPOPE = I.AQPC955TOPE
             AND XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955INST := 0;
        END;
        --Hallar la siguiente reprogramacion
        BEGIN
          select nvl(min(fep), to_date('01/01/2099', 'dd/mm/rrrr'))
            into L_SIG_FEC
            from (select j.jaqa400fec fep
                    from jaqa400 j
                   where j.jaqa400cta = P_N_CTA
                     and j.jaqa400ope = P_N_OPER
                     and j.jaqa400est = 'C'
                     and j.jaqa400fec > I.AQPC955FEP
                  union
                  select k.jaqz698fep
                    from jaqz698 k
                   where k.jaqz698cta = P_N_CTA
                     and k.jaqz698ope = P_N_OPER
                     and k.jaqz698est in ('C', 'Z')
                     and k.jaqz698fep > I.AQPC955FEP
                  union
                  select /*+ all_rows */
                  distinct d.hfcon fep
                    from fsh015 c, fsh016 d, fst198 t
                   where c.pgcod = d.pgcod
                     and c.hcmod = d.hcmod
                     and c.hsucor = d.hsucor
                     and c.htran = d.htran
                     and c.hnrel = d.hnrel
                     and c.hfcon = d.hfcon
                     and d.hcmod = t.tp1nro1
                     and d.htran = t.tp1nro2
                     and (d.hcord = t.tp1imp2)
                     and t.tp1cod = 1
                     and t.tp1cod1 = 11172
                     and t.tp1corr1 = 1
                     and t.tp1corr2 in (1, 2)
                     and c.hccorr = 0
                     and d.hcta = P_N_CTA
                     and d.hoper = P_N_OPER
                     and d.hfcon > I.AQPC955FEP);
        EXCEPTION
          WHEN OTHERS THEN
            L_SIG_FEC := to_date('01/01/2099', 'dd/mm/rrrr');
        END;
        --
        BEGIN
          select nvl((SUM(distinct f.pp1cap) * -1), 0)
            into V_AQPC955AUX1
            from fsd602 f, fst198 t
           where f.pgcod = I.AQPC955EMP
             and f.ppmod = I.AQPC955MOD
             and f.ppsuc = I.AQPC955SUC
             and f.ppmda = I.AQPC955MDA
             and f.pppap = I.AQPC955PAP
             and f.ppcta = I.AQPC955CTA
             and f.ppoper = I.AQPC955OPER
             and f.ppsbop >= I.AQPC955SBOP
             and f.pptope = I.AQPC955TOPE
             and f.pp1cap < 0
             and f.d602co = 'S'
             and t.tp1cod = 1
             and t.tp1cod1 = 10876
             and t.tp1corr1 = f.d602mo
             and t.tp1corr2 = f.d602tr
             and f.pp1fech >= I.AQPC955FEP
             and f.pp1fech < L_SIG_FEC;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955AUX1 := 0;
        END;
        --
        BEGIN
          select c.pgcod,
                 c.hcmod,
                 c.hsucor,
                 c.htran,
                 c.hnrel,
                 c.hfcon,
                 sum(case
                       when t.tp1imp1 = d.hcord then
                        d.hcimp1
                     end) ord1,
                 sum(case
                       when t.tp1imp2 = d.hcord then
                        d.hcimp1
                     end) ord2,
                 (sum(case
                        when t.tp1imp1 = d.hcord then
                         d.hcimp1
                      end) - sum(case
                                    when t.tp1imp2 = d.hcord then
                                     d.hcimp1
                                  end)) monto_cap
            into L_PGCOD,
                 L_HCMOD,
                 L_HTRAN,
                 L_HNREL,
                 L_HSUCOR,
                 L_HFCON,
                 V_AQPC955IMP1,
                 V_AQPC955IMP2,
                 V_AQPC955MONT
            from fsh015 c, fsh016 d, fst198 t
           where c.pgcod = d.pgcod
             and c.hcmod = d.hcmod
             and c.hsucor = d.hsucor
             and c.htran = d.htran
             and c.hnrel = d.hnrel
             and c.hfcon = d.hfcon
             and d.hcmod = t.tp1nro1
             and d.htran = t.tp1nro2
             and (d.hcord = t.tp1imp1 or d.hcord = t.tp1imp2)
             and t.tp1cod = 1
             and t.tp1cod1 = 11172
             and t.tp1corr1 = 1
             and t.tp1corr2 in (1, 2)
             and c.hccorr = 0
             and d.hcta = P_N_CTA
             and d.hoper = P_N_OPER
             and d.hfcon = I.AQPC955FEP
           group by c.pgcod, c.hcmod, c.hsucor, c.htran, c.hnrel, c.hfcon;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      --Inserción en la tabla log AQPC955
      BEGIN
        V_AQPC955CORR := V_AQPC955CORR + 1;
        INSERT INTO AQPC955
          (AQPC955FERG,
           AQPC955HORG,
           AQPC955USRG,
           AQPC955PAIS,
           AQPC955TDOC,
           AQPC955NDOC,
           AQPC955CORR,
           AQPC955EMP,
           AQPC955MOD,
           AQPC955SUC,
           AQPC955MDA,
           AQPC955PAP,
           AQPC955CTA,
           AQPC955OPER,
           AQPC955SBOP,
           AQPC955TOPE,
           AQPC955FEP,
           AQPC955COR,
           AQPC955INS,
           AQPC955ESTA,
           AQPC955CONT,
           AQPC955TIPO,
           AQPC955MODO,
           AQPC955SUBT,
           AQPC955TRXD,
           AQPC955IMP1,
           AQPC955IMP2,
           AQPC955MONT,
           AQPC955AUX1,
           AQPC955EHAB /*,AQPC955AUX2, AQPC955AUX3, AQPC955AUX4, AQPC955AUX5, AQPC955AUX6, AQPC955AUX7, AQPC955AUX8, AQPC834AUX9, AQPC834AUX10*/)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USU,
           V_AQPC955PAIS,
           V_AQPC955TDOC,
           V_AQPC955NDOC,
           V_AQPC955CORR,
           I.AQPC955EMP,
           I.AQPC955MOD,
           I.AQPC955SUC,
           I.AQPC955MDA,
           I.AQPC955PAP,
           I.AQPC955CTA,
           I.AQPC955OPER,
           I.AQPC955SBOP,
           I.AQPC955TOPE,
           I.AQPC955FEP,
           V_AQPC955COR,
           V_AQPC955INST,
           I.AQPC955ESTA,
           I.AQPC955CONT,
           I.AQPC955TIPO,
           I.AQPC955MODO,
           I.AQPC955SUBT,
           I.AQPC955TRXD,
           V_AQPC955IMP1,
           V_AQPC955IMP2,
           V_AQPC955MONT,
           V_AQPC955AUX1,
           'H');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          V_ERROR := SQLERRM;
      END;
    END LOOP;
  END SP_CR_GRABAR_LOG_HISTORIA;

  PROCEDURE SP_CR_GRABAR_LOG_HISTORIA_N(P_N_CTA  IN NUMBER,
                                        P_N_OPER IN NUMBER,
                                        P_V_USU  IN VARCHAR2) IS
    V_ERROR VARCHAR2(1000);
  
    V_AQPC955PAIS NUMBER(4);
    V_AQPC955TDOC NUMBER(4);
    V_AQPC955NDOC VARCHAR2(12);
  
    V_AQPC955CORR NUMBER(10);
    V_AQPC955COR  NUMBER(10);
    V_AQPC955INST NUMBER(10);
    V_AQPC955ESTA VARCHAR2(2);
    L_PGCOD       NUMBER(3);
    L_HCMOD       NUMBER(5);
    L_HTRAN       NUMBER(5);
    L_HNREL       NUMBER(7);
    L_HSUCOR      NUMBER(4);
    L_HFCON       DATE;
    L_SIG_FEC     DATE;
    V_AQPC955IMP1 NUMBER(17, 2);
    V_AQPC955IMP2 NUMBER(17, 2);
    V_AQPC955MONT NUMBER(17, 2);
    V_AQPC955AUX1 NUMBER(17, 2);
  
    CURSOR HISTORIA(P_N_CTA NUMBER, P_N_OPER NUMBER) IS
      select *
        from (select j.jaqz698fep AQPC955FEP,
                     j.jaqz698cor AQPC955COR,
                     j.jaqz698emp AQPC955EMP,
                     j.jaqz698mod AQPC955MOD,
                     j.jaqz698suc AQPC955SUC,
                     j.jaqz698mda AQPC955MDA,
                     j.jaqz698pap AQPC955PAP,
                     j.jaqz698cta AQPC955CTA,
                     j.jaqz698ope AQPC955OPER,
                     j.jaqz698sbo AQPC955SBOP,
                     j.jaqz698top AQPC955TOPE,
                     j.jaqz698inst AQPC955INST,
                     j.jaqz698est AQPC955ESTA,
                     'MASIVA' AQPC955MODO,
                     'NO CONTABLE' AQPC955CONT,
                     'REPROGRAMACION' AQPC955TIPO,
                     'JAQZ698' AQPC955SUBT,
                     'Reprogramacion Sin Capitalizacion Masiva' AQPC955TRXD
                from jaqz698 j
               where j.jaqz698cta = P_N_CTA
                 and j.jaqz698ope = P_N_OPER
                 and j.jaqz698est in ('C', 'Z')
              union
              select k.jaqa400fec,
                     0,
                     k.jaqa400emp,
                     k.jaqa400mod,
                     k.jaqa400suc,
                     k.jaqa400mda,
                     k.jaqa400pap,
                     k.jaqa400cta,
                     k.jaqa400ope,
                     k.jaqa400sbo,
                     k.jaqa400top,
                     k.jaqa400ai1,
                     k.jaqa400est,
                     'INDIVIDUAL',
                     'NO CONTABLE',
                     'REPROGRAMACION',
                     'JAQA400',
                     'Reprogramacion Sin Capitalizacion Individual'
                from jaqa400 k
               where k.jaqa400cta = P_N_CTA
                 and k.jaqa400ope = P_N_OPER
                 and k.jaqa400est = 'C'
              UNION
              select /*+ all_rows */
              DISTINCT d.hfcon,
                       0,
                       d.pgcod,
                       d.hmodul,
                       d.hsucor,
                       d.hmda,
                       d.hpap,
                       d.hcta,
                       d.hoper,
                       d.hsubop,
                       d.htoper,
                       0,
                       'C',
                       'INDIVIDUAL',
                       'CONTABLE',
                       CASE
                         when t.tp1corr2 = 1 then
                          'REFINANCIACION'
                         when t.tp1corr2 = 2 then
                          'REPROGRAMACION'
                       END,
                       CONCAT(CONCAT(TO_CHAR(d.hcmod), '-'),
                              TO_CHAR(d.htran)),
                       (select e.trnom
                          from fst034 e
                         where e.pgcod = 1
                           and e.trmod = c.hcmod
                           and e.trnro = c.htran)
                from fsh015 c, fsh016 d, fst198 t
               where c.pgcod = d.pgcod
                 and c.hcmod = d.hcmod
                 and c.hsucor = d.hsucor
                 and c.htran = d.htran
                 and c.hnrel = d.hnrel
                 and c.hfcon = d.hfcon
                 and d.hcmod = t.tp1nro1
                 and d.htran = t.tp1nro2
                 and (d.hcord = t.tp1imp2)
                 and t.tp1cod = 1
                 and t.tp1cod1 = 11172
                 and t.tp1corr1 = 1
                 and t.tp1corr2 in (1, 2)
                 and c.hccorr = 0
                 and d.hcta = P_N_CTA
                 and d.hoper = P_N_OPER)
       order by 1;
  BEGIN
    --Limpieza de registros
    BEGIN
      UPDATE AQPC955
         SET AQPC955EHAB = 'I'
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Cargar historia de reprogramaciones y refinanciaciones
    V_AQPC955CORR := 0;
    FOR I IN HISTORIA(P_N_CTA, P_N_OPER) LOOP
      BEGIN
        SELECT PEPAIS, PETDOC, TRIM(PENDOC)
          INTO V_AQPC955PAIS, V_AQPC955TDOC, V_AQPC955NDOC
          FROM FSR008 A
         WHERE A.CTNRO = P_N_CTA
           AND A.CTTFIR = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          V_AQPC955PAIS := 0;
          V_AQPC955TDOC := 0;
          V_AQPC955NDOC := '';
      END;
      IF I.AQPC955SUBT = 'JAQA400' THEN
        BEGIN
          SELECT MAX(A.AQPB088COR)
            INTO V_AQPC955COR
            FROM AQPB088 A
           WHERE AQPB088CTA = P_N_CTA
             AND AQPB088OPE = P_N_OPER
             AND AQPB088FEP = I.AQPC955FEP;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955COR := 0;
        END;
      ELSE
        V_AQPC955COR := I.AQPC955COR;
      END IF;
      --Calculo del Monto Capitalizado 
      V_AQPC955IMP1 := 0;
      V_AQPC955IMP2 := 0;
      V_AQPC955MONT := 0;
      IF I.AQPC955SUBT = 'JAQA400' OR I.AQPC955SUBT = 'JAQZ698' THEN
        --Hallar instancia
        V_AQPC955INST := I.AQPC955INST;
        --Hallar la siguiente reprogramacion
        BEGIN
          select nvl(min(fep), to_date('01/01/2099', 'dd/mm/rrrr'))
            into L_SIG_FEC
            from (select j.jaqa400fec fep
                    from jaqa400 j
                   where j.jaqa400cta = P_N_CTA
                     and j.jaqa400ope = P_N_OPER
                     and j.jaqa400est = 'C'
                     and j.jaqa400fec > I.AQPC955FEP
                  union
                  select k.jaqz698fep
                    from jaqz698 k
                   where k.jaqz698cta = P_N_CTA
                     and k.jaqz698ope = P_N_OPER
                     and k.jaqz698est in ('C', 'Z')
                     and k.jaqz698fep > I.AQPC955FEP
                  union
                  select /*+ all_rows */
                  distinct d.hfcon fep
                    from fsh015 c, fsh016 d, fst198 t
                   where c.pgcod = d.pgcod
                     and c.hcmod = d.hcmod
                     and c.hsucor = d.hsucor
                     and c.htran = d.htran
                     and c.hnrel = d.hnrel
                     and c.hfcon = d.hfcon
                     and d.hcmod = t.tp1nro1
                     and d.htran = t.tp1nro2
                     and (d.hcord = t.tp1imp2)
                     and t.tp1cod = 1
                     and t.tp1cod1 = 11172
                     and t.tp1corr1 = 1
                     and t.tp1corr2 in (1, 2)
                     and c.hccorr = 0
                     and d.hcta = P_N_CTA
                     and d.hoper = P_N_OPER
                     and d.hfcon > I.AQPC955FEP);
        EXCEPTION
          WHEN OTHERS THEN
            L_SIG_FEC := to_date('01/01/2099', 'dd/mm/rrrr');
        END;
        --
        BEGIN
          select nvl((SUM(distinct f.pp1cap) * -1), 0)
            into V_AQPC955MONT
            from fsd602 f, fst198 t
           where f.pgcod = I.AQPC955EMP
             and f.ppmod = I.AQPC955MOD
             and f.ppsuc = I.AQPC955SUC
             and f.ppmda = I.AQPC955MDA
             and f.pppap = I.AQPC955PAP
             and f.ppcta = I.AQPC955CTA
             and f.ppoper = I.AQPC955OPER
             and f.ppsbop = I.AQPC955SBOP
             and f.pptope = I.AQPC955TOPE
             and f.pp1cap < 0
             and f.d602co = 'S'
             and t.tp1cod = 1
             and t.tp1cod1 = 10876
             and t.tp1corr1 = f.d602mo
             and t.tp1corr2 = f.d602tr
             and f.pp1fech >= I.AQPC955FEP
             and f.pp1fech < L_SIG_FEC;
          V_AQPC955IMP1 := V_AQPC955MONT;
          V_AQPC955AUX1 := V_AQPC955MONT;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955MONT := 0;
        END;
      ELSE
        --******************************************************************************
        --Hallar instancia
        BEGIN
          SELECT MAX(XWFPRCINS)
            INTO V_AQPC955INST
            FROM XWF700 X
           WHERE X.XWFEMPRESA = I.AQPC955EMP
             AND X.XWFMODULO = I.AQPC955MOD
                --AND X.XWFSUCURSAL = I.AQPC955SUC
             AND X.XWFMONEDA = I.AQPC955MDA
             AND X.XWFPAPEL = I.AQPC955PAP
             AND X.XWFCUENTA = I.AQPC955CTA
             AND X.XWFOPERACION = I.AQPC955OPER
                --AND X.XWFSUBOPE = I.AQPC955SBOP
             AND X.XWFTIPOPE = I.AQPC955TOPE
             AND XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955INST := 0;
        END;
        --Hallar la siguiente reprogramacion
        BEGIN
          select nvl(min(fep), to_date('01/01/2099', 'dd/mm/rrrr'))
            into L_SIG_FEC
            from (select j.jaqa400fec fep
                    from jaqa400 j
                   where j.jaqa400cta = P_N_CTA
                     and j.jaqa400ope = P_N_OPER
                     and j.jaqa400est = 'C'
                     and j.jaqa400fec > I.AQPC955FEP
                  union
                  select k.jaqz698fep
                    from jaqz698 k
                   where k.jaqz698cta = P_N_CTA
                     and k.jaqz698ope = P_N_OPER
                     and k.jaqz698est in ('C', 'Z')
                     and k.jaqz698fep > I.AQPC955FEP
                  union
                  select /*+ all_rows */
                  distinct d.hfcon fep
                    from fsh015 c, fsh016 d, fst198 t
                   where c.pgcod = d.pgcod
                     and c.hcmod = d.hcmod
                     and c.hsucor = d.hsucor
                     and c.htran = d.htran
                     and c.hnrel = d.hnrel
                     and c.hfcon = d.hfcon
                     and d.hcmod = t.tp1nro1
                     and d.htran = t.tp1nro2
                     and (d.hcord = t.tp1imp2)
                     and t.tp1cod = 1
                     and t.tp1cod1 = 11172
                     and t.tp1corr1 = 1
                     and t.tp1corr2 in (1, 2)
                     and c.hccorr = 0
                     and d.hcta = P_N_CTA
                     and d.hoper = P_N_OPER
                     and d.hfcon > I.AQPC955FEP);
        EXCEPTION
          WHEN OTHERS THEN
            L_SIG_FEC := to_date('01/01/2099', 'dd/mm/rrrr');
        END;
        --
        BEGIN
          select nvl((SUM(distinct f.pp1cap) * -1), 0)
            into V_AQPC955AUX1
            from fsd602 f, fst198 t
           where f.pgcod = I.AQPC955EMP
             and f.ppmod = I.AQPC955MOD
             and f.ppsuc = I.AQPC955SUC
             and f.ppmda = I.AQPC955MDA
             and f.pppap = I.AQPC955PAP
             and f.ppcta = I.AQPC955CTA
             and f.ppoper = I.AQPC955OPER
             and f.ppsbop >= I.AQPC955SBOP
             and f.pptope = I.AQPC955TOPE
             and f.pp1cap < 0
             and f.d602co = 'S'
             and t.tp1cod = 1
             and t.tp1cod1 = 10876
             and t.tp1corr1 = f.d602mo
             and t.tp1corr2 = f.d602tr
             and f.pp1fech >= I.AQPC955FEP
             and f.pp1fech < L_SIG_FEC;
        EXCEPTION
          WHEN OTHERS THEN
            V_AQPC955AUX1 := 0;
        END;
        --
        BEGIN
          select c.pgcod,
                 c.hcmod,
                 c.hsucor,
                 c.htran,
                 c.hnrel,
                 c.hfcon,
                 sum(case
                       when t.tp1imp1 = d.hcord then
                        d.hcimp1
                     end) ord1,
                 sum(case
                       when t.tp1imp2 = d.hcord then
                        d.hcimp1
                     end) ord2,
                 (sum(case
                        when t.tp1imp1 = d.hcord then
                         d.hcimp1
                      end) - sum(case
                                    when t.tp1imp2 = d.hcord then
                                     d.hcimp1
                                  end)) monto_cap
            into L_PGCOD,
                 L_HCMOD,
                 L_HTRAN,
                 L_HNREL,
                 L_HSUCOR,
                 L_HFCON,
                 V_AQPC955IMP1,
                 V_AQPC955IMP2,
                 V_AQPC955MONT
            from fsh015 c, fsh016 d, fst198 t
           where c.pgcod = d.pgcod
             and c.hcmod = d.hcmod
             and c.hsucor = d.hsucor
             and c.htran = d.htran
             and c.hnrel = d.hnrel
             and c.hfcon = d.hfcon
             and d.hcmod = t.tp1nro1
             and d.htran = t.tp1nro2
             and (d.hcord = t.tp1imp1 or d.hcord = t.tp1imp2)
             and t.tp1cod = 1
             and t.tp1cod1 = 11172
             and t.tp1corr1 = 1
             and t.tp1corr2 in (1, 2)
             and c.hccorr = 0
             and d.hcta = P_N_CTA
             and d.hoper = P_N_OPER
             and d.hfcon = I.AQPC955FEP
           group by c.pgcod, c.hcmod, c.hsucor, c.htran, c.hnrel, c.hfcon;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      --Inserción en la tabla log AQPC955
      BEGIN
        V_AQPC955CORR := V_AQPC955CORR + 1;
        INSERT INTO AQPC955
          (AQPC955FERG,
           AQPC955HORG,
           AQPC955USRG,
           AQPC955PAIS,
           AQPC955TDOC,
           AQPC955NDOC,
           AQPC955CORR,
           AQPC955EMP,
           AQPC955MOD,
           AQPC955SUC,
           AQPC955MDA,
           AQPC955PAP,
           AQPC955CTA,
           AQPC955OPER,
           AQPC955SBOP,
           AQPC955TOPE,
           AQPC955FEP,
           AQPC955COR,
           AQPC955INS,
           AQPC955ESTA,
           AQPC955CONT,
           AQPC955TIPO,
           AQPC955MODO,
           AQPC955SUBT,
           AQPC955TRXD,
           AQPC955IMP1,
           AQPC955IMP2,
           AQPC955MONT,
           AQPC955AUX1,
           AQPC955EHAB /*,AQPC955AUX2, AQPC955AUX3, AQPC955AUX4, AQPC955AUX5, AQPC955AUX6, AQPC955AUX7, AQPC955AUX8, AQPC834AUX9, AQPC834AUX10*/)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USU,
           V_AQPC955PAIS,
           V_AQPC955TDOC,
           V_AQPC955NDOC,
           V_AQPC955CORR,
           I.AQPC955EMP,
           I.AQPC955MOD,
           I.AQPC955SUC,
           I.AQPC955MDA,
           I.AQPC955PAP,
           I.AQPC955CTA,
           I.AQPC955OPER,
           I.AQPC955SBOP,
           I.AQPC955TOPE,
           I.AQPC955FEP,
           V_AQPC955COR,
           V_AQPC955INST,
           I.AQPC955ESTA,
           I.AQPC955CONT,
           I.AQPC955TIPO,
           I.AQPC955MODO,
           I.AQPC955SUBT,
           I.AQPC955TRXD,
           V_AQPC955IMP1,
           V_AQPC955IMP2,
           V_AQPC955MONT,
           V_AQPC955AUX1,
           'H');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          V_ERROR := SQLERRM;
      END;
    END LOOP;
  END SP_CR_GRABAR_LOG_HISTORIA_N;

  PROCEDURE SP_CR_OBTENER_MONTO_CAPITALIZADO(P_N_CTA      IN NUMBER,
                                             P_N_OPER     IN NUMBER,
                                             P_V_USU      IN VARCHAR2,
                                             P_D_ULT_FEC  OUT DATE,
                                             P_N_TOT_MONT OUT NUMBER,
                                             P_V_ERROR    OUT VARCHAR2) IS
    P_N_FLAG     NUMBER(5);
    P_N_ULT_MONT NUMBER(17, 2);
  BEGIN
    P_V_ERROR := '000';
    BEGIN
      PQ_CR_MONTO_CAPITALIZADO.SP_CR_GRABAR_LOG_HISTORIA(P_N_CTA,
                                                         P_N_OPER,
                                                         P_V_USU);
    EXCEPTION
      WHEN OTHERS THEN
        P_V_ERROR := '999';
    END;
    --Ultima Fecha
    BEGIN
      SELECT MAX(AQPC955FEP)
        INTO P_D_ULT_FEC
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H'
         AND AQPC955MONT > 0;
    EXCEPTION
      WHEN OTHERS THEN
        P_D_ULT_FEC := to_date('01/01/1900');
    END;
    --Ultimo monto capitalizado
    BEGIN
      SELECT AQPC955MONT
        INTO P_N_ULT_MONT
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H'
         AND AQPC955MONT > 0
         AND AQPC955FEP = P_D_ULT_FEC;
    EXCEPTION
      WHEN OTHERS THEN
        P_N_ULT_MONT := 0;
    END;
    --Total monto capitalizado
    BEGIN
      SELECT SUM(AQPC955MONT)
        INTO P_N_TOT_MONT
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        P_N_TOT_MONT := 0;
    END;
    BEGIN
      SELECT TP1NRO2
        INTO P_N_FLAG
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11169
         AND TP1CORR1 = 6
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF P_N_FLAG = 1 THEN
      P_N_TOT_MONT := P_N_ULT_MONT;
    ELSIF P_N_FLAG = 2 THEN
      P_N_TOT_MONT := P_N_TOT_MONT;
    END IF;
  
  END SP_CR_OBTENER_MONTO_CAPITALIZADO;

  PROCEDURE SP_CR_OBTENER_MONTO_CAPITALIZADO_N(P_N_CTA      IN NUMBER,
                                               P_N_OPER     IN NUMBER,
                                               P_V_USU      IN VARCHAR2,
                                               P_D_ULT_FEC  OUT DATE,
                                               P_N_TOT_MONT OUT NUMBER,
                                               P_V_ERROR    OUT VARCHAR2) IS
    P_N_FLAG     NUMBER(5);
    P_N_ULT_MONT NUMBER(17, 2);
  BEGIN
    P_V_ERROR := '000';
    BEGIN
      PQ_CR_MONTO_CAPITALIZADO.SP_CR_GRABAR_LOG_HISTORIA_N(P_N_CTA,
                                                           P_N_OPER,
                                                           P_V_USU);
    EXCEPTION
      WHEN OTHERS THEN
        P_V_ERROR := '999';
    END;
    --Ultima Fecha
    BEGIN
      SELECT MAX(AQPC955FEP)
        INTO P_D_ULT_FEC
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H'
         AND AQPC955MONT > 0;
    EXCEPTION
      WHEN OTHERS THEN
        P_D_ULT_FEC := to_date('01/01/1900');
    END;
    --Ultimo monto capitalizado
    BEGIN
      SELECT AQPC955MONT
        INTO P_N_ULT_MONT
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H'
         AND AQPC955MONT > 0
         AND AQPC955FEP = P_D_ULT_FEC;
    EXCEPTION
      WHEN OTHERS THEN
        P_N_ULT_MONT := 0;
    END;
    --Total monto capitalizado
    BEGIN
      SELECT SUM(AQPC955MONT)
        INTO P_N_TOT_MONT
        FROM AQPC955
       WHERE AQPC955USRG = P_V_USU
         AND AQPC955CTA = P_N_CTA
         AND AQPC955OPER = P_N_OPER
         AND AQPC955EHAB = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        P_N_TOT_MONT := 0;
    END;
    BEGIN
      SELECT TP1NRO2
        INTO P_N_FLAG
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11169
         AND TP1CORR1 = 6
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF P_N_FLAG = 1 THEN
      P_N_TOT_MONT := P_N_ULT_MONT;
    ELSIF P_N_FLAG = 2 THEN
      P_N_TOT_MONT := P_N_TOT_MONT;
    END IF;
  
  END SP_CR_OBTENER_MONTO_CAPITALIZADO_N;

end PQ_CR_MONTO_CAPITALIZADO;
/

