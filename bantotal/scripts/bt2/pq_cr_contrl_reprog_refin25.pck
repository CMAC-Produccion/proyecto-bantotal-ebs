create or replace package pq_cr_contrl_reprog_refin25 is

  /* ************************************************************************************************************
      -- Nombre                     : pq_cr_contrl_reprog_refin25
      -- Sistema                    : BANTOTAL
      -- Descripción                : paquete para resolutor de reprog y refinanciacion
      -- Versión                    : 1.0
      -- Fecha de Creación          : 02/08/2025
      -- Autor de Creación          : RCASTRO
      -- Versión                    : 
      -- Fecha de Modificación      :
      -- Autor de la Modificación   : 
      -- Descripción de Modificación: 
      --
  * *************************************************************************************************************/

  PROCEDURE sp_cr_rp_gradiente_caj_refinanc(ve_instancia       NUMBER,
                                            porcMenorGradiente out number);

  PROCEDURE sp_cr_rp_gradiente_caj_reprgSinCap(VE_INSTANCIA IN NUMBER,
                                               VE_USER      IN VARCHAR2,
                                               VO_RESULTADO OUT VARCHAR2,
                                               VO_COD_ERROR OUT VARCHAR2,
                                               VO_MSG_ERROR OUT VARCHAR2);

end pq_cr_contrl_reprog_refin25;
/
create or replace package body pq_cr_contrl_reprog_refin25 is

  PROCEDURE sp_cr_rp_gradiente_caj_refinanc(ve_instancia       NUMBER,
                                            porcMenorGradiente out number) is
  
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    CAP_CUOTA    NUMBER(17, 2);
    CAP_SEGURO   NUMBER(17, 2);
    vi_fecpagmax DATE;
  
    val_cuota7          number(17, 2);
    val_flgCuoIgu       varchar2(1);
    val_cuotMin6priCuot number(17, 2);
    val_aux6primCuot    number(17, 2);
    --vi_fecpagmax        DATE;
    val_cuotMax      number(17, 2);
    val_cuotMin      number(17, 2);
    val_fecha6cuot   DATE;
    VAL_FECHAMaxGrad date;
    contador         number(10);
  
    vi_cuotas            number(10);
    var_segrow           number(17, 2);
    val_cuotrow          number(17, 2);
    val_porcentPerm      number(17, 2);
    val_montoDifCuota    number(17, 2);
    val_esGradiente      varchar2(1);
    val_porcertCuota     number(10, 2);
    val_MenorPorcGradien number(10, 2);
  
    CURSOR CRONOGRAMA_PRP(v_pgcod  number,
                          v_aomod  number,
                          v_aosuc  number,
                          v_aomda  number,
                          v_aopap  number,
                          v_aocta  number,
                          v_aooper number,
                          v_aosbop number,
                          v_aotope number) IS
      SELECT (d.ppcap + d.ppint
             ) cuota,
             D.*
        FROM FSD601 D 
       WHERE D.PGCOD = v_pgcod
         AND D.PPMOD = v_aomod
         AND D.PPSUC = v_aosuc
         AND D.PPMDA = v_aomda
         AND D.PPPAP = v_aopap
         AND D.PPCTA = v_aocta
         AND D.PPOPER = v_aooper
         AND D.PPSBOP = v_aosbop
         AND D.PPTOPE = v_aotope

         and D.PPTIPO = 'M'  
       ORDER BY D.PPFPAG ASC;
  
    CURSOR CRONOGRAMA_GRADIENT(v_pgcod   number,
                               v_aomod   number,
                               v_aosuc   number,
                               v_aomda   number,
                               v_aopap   number,
                               v_aocta   number,
                               v_aooper  number,
                               v_aosbop  number,
                               v_aotope  number,
                               V_FECHGRA DATE) IS
      SELECT (d.ppcap + d.ppint
             ) cuota,
             D.*
        FROM FSD601 D 
       WHERE D.PGCOD = v_pgcod
         AND D.PPMOD = v_aomod
         AND D.PPSUC = v_aosuc
         AND D.PPMDA = v_aomda
         AND D.PPPAP = v_aopap
         AND D.PPCTA = v_aocta
         AND D.PPOPER = v_aooper
         AND D.PPSBOP = v_aosbop
         AND D.PPTOPE = v_aotope

         and D.PPTIPO = 'M'
       ORDER BY D.PPFPAG ASC;
  
  BEGIN
    BEGIN
      select TP1IMP1
        INTO val_porcentPerm
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 302
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    val_porcentPerm := nvl(val_porcentPerm, 0);
  
    BEGIN
      select TP1IMP1
        INTO val_montoDifCuota
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 302
         AND TP1CORR2 = 1
         AND TP1CORR3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    val_montoDifCuota := nvl(val_montoDifCuota, 0);
  
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vi_pgcod,
             vi_aomod,
             vi_aosuc,
             vi_aomda,
             vi_aopap,
             vi_aocta,
             vi_aooper,
             vi_aosbop,
             vi_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
  
    BEGIN
      SELECT COUNT(*)
        INTO vi_cuotas
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
         and D.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        vi_cuotas := 0;
    END;
  
    --UCOTA MAXIMA 
    BEGIN
      --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
      SELECT MAX(D.PPFPAG)
        INTO vi_fecpagmax
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
         and D.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        vi_fecpagmax := NULL;
    END;
  
    BEGIN
      --obtener la cuota mayor de todas las cuotas 
      SELECT MAX((d.ppcap + d.ppint +
                 (nvl(d2.ppimp11 + d2.ppimp12 + d2.ppimp13 + d2.ppimp14 +
                       d2.ppimp15 + d2.ppimp16 + d2.ppimp17 + d2.ppimp18 +
                       d2.ppimp19 + d2.ppimp20,
                       0)))) cuota --,
      -- D.PPFPAG FECHAPAGO
        INTO val_cuotMax
        FROM FSD601 D
        left join FSD611 D2
          on D.pgcod = d2.pgcod
         and D.ppmod = d2.ppmod
         and D.ppsuc = d2.ppsuc
         and D.ppmda = d2.ppmda
         and D.pppap = d2.pppap
         and D.ppcta = d2.ppcta
         and D.ppoper = d2.ppoper
         and D.ppsbop = d2.ppsbop
         and D.pptope = d2.pptope
         and D.ppfpag = d2.ppfpag
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
            
            --and D.ppfpag < vi_fecpagmax
         and D.PPTIPO = 'M'
       ORDER BY D.PPFPAG ASC;
    EXCEPTION
      WHEN OTHERS THEN
        val_cuotMax := 0;
    END;
  
    val_cuotMax          := nvl(val_cuotMax, 0);
    val_esGradiente      := 'N';
    contador             := 1;
    val_cuotrow          := 0;
    val_MenorPorcGradien := 0;
    BEGIN
    
      for j in CRONOGRAMA_PRP(vi_pgcod, vi_aomod, vi_aosuc, vi_aomda, vi_aopap, vi_aocta, vi_aooper, vi_aosbop, vi_aotope) loop
        val_cuotrow := 0;
        var_segrow := 0;
        BEGIN
          BEGIN
            SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                   PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 +
                   PPIMP20)
              INTO var_segrow
              FROM FSD611 b
             WHERE b.PGCOD = vi_pgcod
               AND b.PPMOD = vi_aomod
               AND b.PPSUC = vi_aosuc
               AND b.PPMDA = vi_aomda
               AND b.PPPAP = vi_aopap
               AND b.PPCTA = vi_aocta
               AND b.PPOPER = vi_aooper
               AND b.PPSBOP = vi_aosbop
               AND b.PPTOPE = vi_aotope
               AND B.PPFPAG = j.ppfpag
               AND B.PPTIPO = 'M'
             ORDER BY b.PPFPAG ASC;
          
          EXCEPTION
            WHEN OTHERS THEN
              var_segrow := 0;
          END;
          var_segrow := nvl(var_segrow, 0);
        
          val_cuotrow := j.cuota + var_segrow;
          IF val_cuotMax > (val_cuotrow + val_montoDifCuota) THEN            
             val_esGradiente := 'S'; 
             EXIT;                               
          END IF;
        END;
      end loop;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF val_esGradiente = 'S' THEN
      contador             := 1;
      val_MenorPorcGradien := 0;
      BEGIN
        for j in CRONOGRAMA_PRP(vi_pgcod, vi_aomod, vi_aosuc, vi_aomda, vi_aopap, vi_aocta, vi_aooper, vi_aosbop, vi_aotope) loop
          val_cuotrow := 0;
          var_segrow  := 0;
          BEGIN
            begin
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                     PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 +
                     PPIMP20)
                INTO var_segrow
                FROM FSD611 b
               WHERE b.PGCOD = vi_pgcod
                 AND b.PPMOD = vi_aomod
                 AND b.PPSUC = vi_aosuc
                 AND b.PPMDA = vi_aomda
                 AND b.PPPAP = vi_aopap
                 AND b.PPCTA = vi_aocta
                 AND b.PPOPER = vi_aooper
                 AND b.PPSBOP = vi_aosbop
                 AND b.PPTOPE = vi_aotope
                 AND B.PPFPAG = j.ppfpag
                 AND B.PPTIPO = 'M'
               ORDER BY b.PPFPAG ASC;
            
            EXCEPTION
              WHEN OTHERS THEN
                var_segrow := 0;
            END;
            var_segrow := nvl(var_segrow, 0);
          
            val_cuotrow      := j.cuota + var_segrow;
            val_porcertCuota := 0;
            IF val_cuotrow <> 0 THEN
              val_porcertCuota := ((j.ppcap / val_cuotrow) * 100);
            END IF;
            
            IF contador = 1 THEN
              val_MenorPorcGradien := val_porcertCuota;
            ELSE
              IF val_porcertCuota < val_MenorPorcGradien THEN
                val_MenorPorcGradien := val_porcertCuota;
              END IF;
            end if;
          end;
          contador := contador + 1;
        end loop;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    porcMenorGradiente := val_MenorPorcGradien;
  END;

  PROCEDURE sp_cr_rp_gradiente_caj_reprgSinCap(VE_INSTANCIA IN NUMBER,
                                               VE_USER      IN VARCHAR2,
                                               VO_RESULTADO OUT VARCHAR2,
                                               VO_COD_ERROR OUT VARCHAR2,
                                               VO_MSG_ERROR OUT VARCHAR2) is
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    CAP_CUOTA    NUMBER(17, 2);
    CAP_SEGURO   NUMBER(17, 2);
    vi_fecpagmax DATE;
  
    val_cuota7          number(17, 2);
    val_flgCuoIgu       varchar2(1);
    val_cuotMin6priCuot number(17, 2);
    val_aux6primCuot    number(17, 2);
    --vi_fecpagmax        DATE;
    val_cuotMax      number(17, 2);
    val_cuotMin      number(17, 2);
    val_fecha6cuot   DATE;
    VAL_FECHAMaxGrad date;
    contador         number(10);
  
    vi_cuotas            number(10);
    var_segrow           number(17, 2);
    val_cuotrow          number(17, 2);
    val_porcentPerm      number(17, 2);
    val_montoDifCuota    number(17, 2);
    val_esGradiente      varchar2(1);
    val_porcertCuota     number(10, 2);
    val_MenorPorcGradien number(10, 2);
    porcMenorGradiente  number(10, 2);
  
    CURSOR CRONOGRAMA_PRP(v_pgcod  number,
                          v_aomod  number,
                          v_aosuc  number,
                          v_aomda  number,
                          v_aopap  number,
                          v_aocta  number,
                          v_aooper number,
                          v_aosbop number,
                          v_aotope number) IS
      SELECT (d.ppcap + d.ppint
             ) cuota,
             D.*
        FROM FSD601 D 
       WHERE D.PGCOD = v_pgcod
         AND D.PPMOD = v_aomod
         AND D.PPSUC = v_aosuc
         AND D.PPMDA = v_aomda
         AND D.PPPAP = v_aopap
         AND D.PPCTA = v_aocta
         AND D.PPOPER = v_aooper
         AND D.PPSBOP = 609--v_aosbop
         AND D.PPTOPE = v_aotope

         and D.PPTIPO = 'M'  
       ORDER BY D.PPFPAG ASC;
  
    CURSOR CRONOGRAMA_GRADIENT(v_pgcod   number,
                               v_aomod   number,
                               v_aosuc   number,
                               v_aomda   number,
                               v_aopap   number,
                               v_aocta   number,
                               v_aooper  number,
                               v_aosbop  number,
                               v_aotope  number,
                               V_FECHGRA DATE) IS
      SELECT (d.ppcap + d.ppint
             ) cuota,
             D.*
        FROM FSD601 D 
       WHERE D.PGCOD = v_pgcod
         AND D.PPMOD = v_aomod
         AND D.PPSUC = v_aosuc
         AND D.PPMDA = v_aomda
         AND D.PPPAP = v_aopap
         AND D.PPCTA = v_aocta
         AND D.PPOPER = v_aooper
         AND D.PPSBOP = 609--v_aosbop
         AND D.PPTOPE = v_aotope

         and D.PPTIPO = 'M'
       ORDER BY D.PPFPAG ASC;
  
  BEGIN
    VO_RESULTADO := 'N';    
  
    BEGIN
      select TP1IMP1
        INTO val_porcentPerm
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 302
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    val_porcentPerm := nvl(val_porcentPerm, 0);
  
    BEGIN
      select TP1IMP1
        INTO val_montoDifCuota
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 302
         AND TP1CORR2 = 1
         AND TP1CORR3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    val_montoDifCuota := nvl(val_montoDifCuota, 0);
  
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vi_pgcod,
             vi_aomod,
             vi_aosuc,
             vi_aomda,
             vi_aopap,
             vi_aocta,
             vi_aooper,
             vi_aosbop,
             vi_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
  
    BEGIN
      SELECT COUNT(*)
        INTO vi_cuotas
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = 609--v_aosbop
         AND D.PPTOPE = vi_aotope
         and D.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        vi_cuotas := 0;
    END;
  
    --UCOTA MAXIMA 
    BEGIN
      --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
      SELECT MAX(D.PPFPAG)
        INTO vi_fecpagmax
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = 609--v_aosbop
         AND D.PPTOPE = vi_aotope
         and D.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        vi_fecpagmax := NULL;
    END;
  
    BEGIN
      --obtener la cuota mayor de todas las cuotas 
      SELECT MAX((d.ppcap + d.ppint +
                 (nvl(d2.ppimp11 + d2.ppimp12 + d2.ppimp13 + d2.ppimp14 +
                       d2.ppimp15 + d2.ppimp16 + d2.ppimp17 + d2.ppimp18 +
                       d2.ppimp19 + d2.ppimp20,
                       0)))) cuota --,
      -- D.PPFPAG FECHAPAGO
        INTO val_cuotMax
        FROM FSD601 D
        left join FSD611 D2
          on D.pgcod = d2.pgcod
         and D.ppmod = d2.ppmod
         and D.ppsuc = d2.ppsuc
         and D.ppmda = d2.ppmda
         and D.pppap = d2.pppap
         and D.ppcta = d2.ppcta
         and D.ppoper = d2.ppoper
         and D.ppsbop = d2.ppsbop
         and D.pptope = d2.pptope
         and D.ppfpag = d2.ppfpag
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = 609--v_aosbop
         AND D.PPTOPE = vi_aotope
            
            --and D.ppfpag < vi_fecpagmax
         and D.PPTIPO = 'M'
       ORDER BY D.PPFPAG ASC;
    EXCEPTION
      WHEN OTHERS THEN
        val_cuotMax := 0;
    END;
  
    val_cuotMax          := nvl(val_cuotMax, 0);
    val_esGradiente      := 'N';
    contador             := 1;
    val_cuotrow          := 0;
    val_MenorPorcGradien := 0;
    BEGIN
    
      for j in CRONOGRAMA_PRP(vi_pgcod, vi_aomod, vi_aosuc, vi_aomda, vi_aopap, vi_aocta, vi_aooper, vi_aosbop, vi_aotope) loop
        val_cuotrow := 0;
        var_segrow := 0;
        BEGIN
          BEGIN
            SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                   PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 +
                   PPIMP20)
              INTO var_segrow
              FROM FSD611 b
             WHERE b.PGCOD = vi_pgcod
               AND b.PPMOD = vi_aomod
               AND b.PPSUC = vi_aosuc
               AND b.PPMDA = vi_aomda
               AND b.PPPAP = vi_aopap
               AND b.PPCTA = vi_aocta
               AND b.PPOPER = vi_aooper
               AND b.PPSBOP = 609--v_aosbop
               AND b.PPTOPE = vi_aotope
               AND B.PPFPAG = j.ppfpag
               AND B.PPTIPO = 'M'
             ORDER BY b.PPFPAG ASC;
          
          EXCEPTION
            WHEN OTHERS THEN
              var_segrow := 0;
          END;
          var_segrow := nvl(var_segrow, 0);
        
          val_cuotrow := j.cuota + var_segrow;
          IF val_cuotMax > (val_cuotrow + val_montoDifCuota) THEN            
             val_esGradiente := 'S'; 
             EXIT;                               
          END IF;
        END;
      end loop;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF val_esGradiente = 'S' THEN
      contador             := 1;
      val_MenorPorcGradien := 0;
      BEGIN
        for j in CRONOGRAMA_PRP(vi_pgcod, vi_aomod, vi_aosuc, vi_aomda, vi_aopap, vi_aocta, vi_aooper, vi_aosbop, vi_aotope) loop
          val_cuotrow := 0;
          var_segrow  := 0;
          BEGIN
            begin
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                     PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 +
                     PPIMP20)
                INTO var_segrow
                FROM FSD611 b
               WHERE b.PGCOD = vi_pgcod
                 AND b.PPMOD = vi_aomod
                 AND b.PPSUC = vi_aosuc
                 AND b.PPMDA = vi_aomda
                 AND b.PPPAP = vi_aopap
                 AND b.PPCTA = vi_aocta
                 AND b.PPOPER = vi_aooper
                 AND b.PPSBOP = 609--v_aosbop
                 AND b.PPTOPE = vi_aotope
                 AND B.PPFPAG = j.ppfpag
                 AND B.PPTIPO = 'M'
               ORDER BY b.PPFPAG ASC;
            
            EXCEPTION
              WHEN OTHERS THEN
                var_segrow := 0;
            END;
            var_segrow := nvl(var_segrow, 0);
          
            val_cuotrow      := j.cuota + var_segrow;
            val_porcertCuota := 0;
            IF val_cuotrow <> 0 THEN
              val_porcertCuota := ((j.ppcap / val_cuotrow) * 100);
            END IF;
            
            IF contador = 1 THEN
              val_MenorPorcGradien := val_porcertCuota;
            ELSE
              IF val_porcertCuota < val_MenorPorcGradien THEN
                val_MenorPorcGradien := val_porcertCuota;
              END IF;
            end if;
          end;
          contador := contador + 1;
        end loop;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
  
    porcMenorGradiente := val_MenorPorcGradien;
  
    IF porcMenorGradiente < val_porcentPerm THEN
      VO_RESULTADO := 'S';
    ELSE
      VO_RESULTADO := 'N';
    END IF;
    
    END IF;
  END;

END;
/
