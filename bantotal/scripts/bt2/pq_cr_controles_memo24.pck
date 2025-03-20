create or replace package pq_cr_controles_memo24 is

  -- ***************************************************************************************************************************
  -- Nombre                     : PAQUETE CONTROLES PARA REPROGRAMACIONES Y REFINANCIACIONES MEMO 17 Y 18
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/1/2024 18:46:23
  -- Autor de Creación          : IGS_RCASTRO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 

  procedure sp_cr_control_periodio_gracia(ve_instancia in int,
                                          vo_gracia    out int,
                                          vo_monto     out number,
                                          ln_rpta      out varchar2);

  procedure sp_cr_plazo_residual(ve_instancia in int,
                                 vo_plazo_re  out int,
                                 ln_rspta     out varchar2);

  procedure sp_cr_rp_gracia_refinanc(ve_instancia in int,
                                     vo_gracia    out int);

  Procedure sp_cr_rp_plazo_residu_refinanc(ve_instancia in int,
                                           vo_plazo_re  out int);

  Procedure sp_cr_rp_gradiente_caj_refinanc(ve_instancia in int,
                                            vo_gradiente out int);

end pq_cr_controles_memo24;
/

create or replace package body pq_cr_controles_memo24 is

  procedure sp_cr_control_periodio_gracia(ve_instancia in int,
                                          vo_gracia    out int,
                                          vo_monto     out number,
                                          ln_rpta      out varchar2) is
    vi_pgcod        xwf700.xwfempresa%type;
    vi_aomod        xwf700.xwfmodulo%type;
    vi_aosuc        xwf700.xwfsucursal%type;
    vi_aomda        xwf700.xwfmoneda%type;
    vi_aopap        xwf700.xwfpapel%type;
    vi_aocta        xwf700.xwfcuenta%type;
    vi_aooper       xwf700.xwfoperacion%type;
    vi_aosbop       xwf700.xwfsubope%type;
    vi_aotope       xwf700.xwftipope%type;
    vi_fprpago      date;
    vi_fecactual    DATE;
    vi_periodi_guia number(9);
    ln_habilitado  number(9);
  begin
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
      select x.XLLFPRIMPA, x.xllcapital
        into vi_fprpago, vo_monto
        from x054023 x
       where x.xllpgcod = vi_pgcod
         and x.xllaomod = vi_aomod
         and x.xllaosuc = vi_aosuc
         and x.xllaomda = vi_aomda
         and x.xllaopap = vi_aopap
         and x.xllaocta = vi_aocta
         and x.xllaooper = vi_aooper
         and x.xllaosbop = 609
         and x.xllaotop = vi_aotope;
    Exception
      when others then
        null;
    END;
  
    BEGIN
      SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD = 1;
    exception
      when others then
        null;      
    END;
  
    begin
      SELECT vi_fprpago - vi_fecactual into vo_gracia FROM DUAL;
    exception
      when others then
        null;      
    end;
  
    vo_gracia := nvl(vo_gracia, 0);
  
    --GUIA DE PERIODO DE GRACIA
    BEGIN
      select TP1NRO3, TP1NRO2
        into vi_periodi_guia, ln_habilitado
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 110
         and --  for update 
             tp1corr2 = 1
         and tp1corr3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_periodi_guia := 0;
    END;
    vi_periodi_guia := nvl(vi_periodi_guia, 0);
    ln_habilitado   := nvl(ln_habilitado, 0);
    
    ln_rpta := 'S'; 
    IF ln_habilitado > 0 THEN
      IF vo_gracia > vi_periodi_guia THEN
        ln_rpta := 'N';
      ELSE
        ln_rpta := 'S';
      END IF;
    END IF;
  
  End;

  procedure sp_cr_plazo_residual(ve_instancia in int,
                                 vo_plazo_re  out int,
                                 ln_rspta     out varchar2) is
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    vi_fecpagmax date;
    vi_fecactual date;
    vi_plzo_res  number(4);
    --vi_scsdo number(17,2);
    FEC_PAGO        DATE;
    FLAG_PAGOS      varchar2(1);
    vi_fecpagmin    date;
    ln_maxPlazResid number(9);
    ln_habilitd number(9);
    
    vi_fecpagmaxPropu date;
    
    VALIDAR_PZORSD number(9); --agregado
    vi_plzo_res_vig number(17,2); --agregado
    vi_fecvencpro date;
    vi_cantcuopr number(17,2);
  begin
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
    begin
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
         AND D.PPTOPE = vi_aotope;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
    --Cuantas cuotas faltan pagar
    FLAG_PAGOS := 'S';
    BEGIN
      SELECT MAX(D.PPFPAG), 'N'
        INTO FEC_PAGO, FLAG_PAGOS
        FROM FSD601 D, FSD602 D2
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
         AND D2.PGCOD = D.PGCOD
         AND D2.PPMOD = D.PPMOD
         AND D2.PPSUC = D.PPSUC
         AND D2.PPMDA = D.PPMDA
         AND D2.PPPAP = D.PPPAP
         AND D2.PPCTA = D.PPCTA
         AND D2.PPOPER = D.PPOPER
         AND D2.PPSBOP = D.PPSBOP
         AND D2.PPTOPE = D.PPTOPE
         and d2.pp1stat = 'T'
         AND D2.PPFPAG = D.PPFPAG;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAG_PAGOS := 'S';
      WHEN OTHERS THEN
        null;        
    END;
    --OBTENER LA FECHA MINIMA DE PAGO
    IF FLAG_PAGOS = 'N' AND FEC_PAGO IS NOT NULL THEN
      begin
        SELECT MIN(D.PPFPAG)
          INTO vi_fecpagmin
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
           AND D.PPFPAG > FEC_PAGO;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
      IF vi_fecpagmin IS NULL THEN
             BEGIN
                SELECT MIN(D.PPFPAG)
                    INTO vi_fecpagmin    
                       FROM FSD601 D
                      WHERE D.PGCOD = vi_pgcod
                        AND D.PPMOD = vi_aomod
                        AND D.PPSUC = vi_aosuc
                        AND D.PPMDA = vi_aomda
                        AND D.PPPAP = vi_aopap
                        AND D.PPCTA = vi_aocta
                        AND D.PPOPER = vi_aooper
                        AND D.PPSBOP = vi_aosbop
                        AND D.PPTOPE = vi_aotope;               
             END;
      END IF;
    vi_fecactual:= vi_fecpagmin;
    ELSE
      BEGIN
        SELECT MIN(D.PPFPAG)
          INTO vi_fecactual
          FROM FSD601 D
         WHERE D.PGCOD = vi_pgcod
           AND D.PPMOD = vi_aomod
           AND D.PPSUC = vi_aosuc
           AND D.PPMDA = vi_aomda
           AND D.PPPAP = vi_aopap
           AND D.PPCTA = vi_aocta
           AND D.PPOPER = vi_aooper
           AND D.PPSBOP = vi_aosbop
           AND D.PPTOPE = vi_aotope;
     exception
      when others then
        null;        
      END;
    END IF;     
    begin
      SELECT MAX(D.PPFPAG)
        INTO vi_fecpagmaxPropu
        FROM FSD601 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = 609
         AND D.PPTOPE = vi_aotope;
    EXCEPTION
      WHEN OTHERS THEN
        vi_fecpagmaxPropu := '';
    end;    
    
   --OBTENGO EL PLAZO RESIDUAL                        
    BEGIN
      SELECT MONTHS_BETWEEN(vi_fecpagmaxPropu, vi_fecpagmax)
        INTO vi_plzo_res
        FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        vi_plzo_res := 0;
    END;    
    
    vo_plazo_re := nvl(vi_plzo_res, 0);
    
    If vo_plazo_re < 0 THEN
       vo_plazo_re := vo_plazo_re * (-1);
    END IF;
    
    --COLOCAR ESTA GUIA PARA INDICAR SI SE USA ESTA U OTRA ORDENAR EL CODIGO.
    --OBTENGO EL PLAZO RESIDUAL DEL CREDITO EN VUELO. SUB. 609
    BEGIN
      SELECT TP1NRO1 
        INTO VALIDAR_PZORSD
        FROM FST198
       WHERE TP1COD   = 1
         AND TP1COD1  = 11161
         AND TP1CORR1 = 400000
         AND TP1CORR2 = 64
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VALIDAR_PZORSD := 1;  
    END;
    
    IF VALIDAR_PZORSD <> 1 THEN
       BEGIN
            --CANTIDAD DE CUOTAS PROPUESTAS
            BEGIN
                SELECT COUNT(*)
                  INTO vi_cantcuopr
                  FROM FSD601 D
                 WHERE D.PGCOD  = vi_pgcod
                   AND D.PPMOD  = vi_aomod
                   AND D.PPSUC  = vi_aosuc
                   AND D.PPMDA  = vi_aomda
                   AND D.PPPAP  = vi_aopap
                   AND D.PPCTA  = vi_aocta
                   AND D.PPOPER = vi_aooper
                   AND D.PPSBOP = 609
                   AND D.PPTOPE = vi_aotope; 
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;    
          --CANTIDAD DE CUOTAS EN FALTANTES PENDIENTES DE PAGO.
          BEGIN
            SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual) 
              INTO vi_plzo_res_vig
            FROM DUAL;
          EXCEPTION 
            WHEN OTHERS THEN
              vi_plzo_res_vig:= 0;  
          END;
          --calcualmos el plazo residual del propuesto vs el vigente no debe superar
          vo_plazo_re :=  vi_cantcuopr - vi_plzo_res_vig;
          If vo_plazo_re < 0 THEN
             vo_plazo_re := vo_plazo_re * (-1);
          END IF;
       END;
    END IF;
  
    --guia max plazo residual
    BEGIN
      select TP1NRO3, TP1NRO2
        into ln_maxPlazResid, ln_habilitd
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 110
         and tp1corr2 = 1
         and tp1corr3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        ln_maxPlazResid := 0;
    END;
    ln_maxPlazResid := nvl(ln_maxPlazResid, 0);
    ln_habilitd := nvl(ln_habilitd, 0);
    ln_rspta := 'S';    
    IF ln_habilitd > 0 THEN
        IF vo_plazo_re > ln_maxPlazResid THEN
          ln_rspta := 'N';
        ELSE
          ln_rspta := 'S';
        END IF;
    END IF;
  End;

  procedure sp_cr_rp_gracia_refinanc(ve_instancia in int,
                                     vo_gracia    out int) is
    vi_pgcod     xwf700.xwfempresa%type;
    vi_aomod     xwf700.xwfmodulo%type;
    vi_aosuc     xwf700.xwfsucursal%type;
    vi_aomda     xwf700.xwfmoneda%type;
    vi_aopap     xwf700.xwfpapel%type;
    vi_aocta     xwf700.xwfcuenta%type;
    vi_aooper    xwf700.xwfoperacion%type;
    vi_aosbop    xwf700.xwfsubope%type;
    vi_aotope    xwf700.xwftipope%type;
    vi_fprpago   date;
    vi_fecactual DATE;
    vo_monto     number(17, 2);
    vo_fvalor    date;
    vo_periodo   number(5);
  begin
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
      select x.XLLFPRIMPA, x.xllcapital,x.xllfvalor,x.XLLPERIODO
        into vi_fprpago, vo_monto, vo_fvalor, vo_periodo
        from x054023 x
       where x.xllpgcod = vi_pgcod
         and x.xllaomod = vi_aomod
         and x.xllaosuc = vi_aosuc
         and x.xllaomda = vi_aomda
         and x.xllaopap = vi_aopap
         and x.xllaocta = vi_aocta
         and x.xllaooper = vi_aooper
         and x.xllaosbop = vi_aosbop
         and x.xllaotop = vi_aotope;
    Exception
      when others then
        null; --vo_fprpago:=0;
    END;
    
    BEGIN
      SELECT MIN(D.PPFPAG)
        INTO vi_fprpago     
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
         AND D.PPTIPO = 'M'
         AND (D.PPCAP+D.PPINT)> 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;  
      END;
    BEGIN
      SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD = 1;
    exception
      when others then
        null;      
    END;
    
    begin
      SELECT (vi_fprpago - vo_fvalor) - nvl(vo_periodo,0) into vo_gracia FROM DUAL;
    exception
      when others then
        null;      
    end;
    
    IF vo_gracia < 0 THEN
       --vo_gracia := vo_gracia * (-1);
       vo_gracia := 0;
    END IF;    
  
    vo_gracia := nvl(vo_gracia, 0);
  END;

  Procedure sp_cr_rp_plazo_residu_refinanc(ve_instancia in int,
                                           vo_plazo_re out int) is  
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;

    vi_fecpagmax date;
    vi_fecactual date;
    vi_plzo_res number(4);
    vi_scsdo number(17,2);
    FEC_PAGO DATE;
    FLAG_PAGOS varchar2(1);
    vi_fecpagmin date;
    
    ln_pgcod xwf700.xwfempresa%type;
    ln_aomod xwf700.xwfmodulo%type;
    ln_aosuc xwf700.xwfsucursal%type;
    ln_aomda xwf700.xwfmoneda%type;
    ln_aopap xwf700.xwfpapel%type;
    ln_aocta xwf700.xwfcuenta%type;
    ln_aooper xwf700.xwfoperacion%type;
    ln_aosbop xwf700.xwfsubope%type;
    ln_aotope xwf700.xwftipope%type;
    
    vi_fecpagmaxVig date;    
    
    begin
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
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
            exception
              when others then
                null;                                  
              END;
            begin               
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
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            --Cuantas cuotas faltan pagar
            FLAG_PAGOS:='S';
            BEGIN 
              SELECT MAX(D.PPFPAG),'N'
              INTO FEC_PAGO, FLAG_PAGOS 
              FROM FSD601 D,FSD602 D2
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope
                    AND D2.PGCOD  = D.PGCOD
                    AND D2.PPMOD  = D.PPMOD
                    AND D2.PPSUC  = D.PPSUC
                    AND D2.PPMDA  = D.PPMDA
                    AND D2.PPPAP  = D.PPPAP
                    AND D2.PPCTA  = D.PPCTA
                    AND D2.PPOPER = D.PPOPER
                    AND D2.PPSBOP = D.PPSBOP
                    AND D2.PPTOPE = D.PPTOPE
                    and d2.pp1stat='T'
                    AND D2.PPFPAG = D.PPFPAG;
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                FLAG_PAGOS:='S';
              WHEN OTHERS THEN
                NULL;                     
            END;
            --OBTENER LA FECHA MINIMA DE PAGO
            IF FLAG_PAGOS = 'N' AND FEC_PAGO IS NOT NULL THEN
              begin               
                SELECT MIN(D.PPFPAG)
                  INTO vi_fecpagmin    
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
                      AND D.PPFPAG > FEC_PAGO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;      
              end;
              vi_fecactual:= vi_fecpagmin;
            ELSE
              BEGIN
                  SELECT MIN(D.PPFPAG)
                      INTO vi_fecactual    
                         FROM FSD601 D
                        WHERE D.PGCOD = vi_pgcod
                          AND D.PPMOD = vi_aomod
                          AND D.PPSUC = vi_aosuc
                          AND D.PPMDA = vi_aomda
                          AND D.PPPAP = vi_aopap
                          AND D.PPCTA = vi_aocta
                          AND D.PPOPER = vi_aooper
                          AND D.PPSBOP = vi_aosbop
                          AND D.PPTOPE = vi_aotope;  
              exception
                when others then
                  null;              
              END;
            END IF;  
            
            ------fechaMax de crédito vigente
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
                  into ln_pgcod, 
                       ln_aomod, 
                       ln_aosuc, 
                       ln_aomda, 
                       ln_aopap, 
                       ln_aocta,
                       ln_aooper,
                       ln_aosbop,
                       ln_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 <> '1'
                  and rownum <= 1;
            exception
              when others then
                null;                                  
              END;
            
             begin               
              SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmaxVig     
                   FROM FSD601 D
                  WHERE D.PGCOD =  ln_pgcod
                    AND D.PPMOD =  ln_aomod
                    AND D.PPSUC =  ln_aosuc
                    AND D.PPMDA =  ln_aomda
                    AND D.PPPAP =  ln_aopap
                    AND D.PPCTA =  ln_aocta
                    AND D.PPOPER = ln_aooper
                    AND D.PPSBOP = ln_aosbop
                    AND D.PPTOPE = ln_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;            
            
            --OBTENGO EL PLAZO RESIDUAL                        
            BEGIN
              SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecpagmaxVig) 
                INTO vi_plzo_res
              FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                vi_plzo_res:= 0;  
            END;
            
            vi_plzo_res := nvl(vi_plzo_res, 0);
            
            IF vi_plzo_res < 0 THEN
               vi_plzo_res := vi_plzo_res * (-1);
            END IF;
            
            vo_plazo_re:=  vi_plzo_res; 
  END;
  
  Procedure sp_cr_rp_gradiente_caj_refinanc(ve_instancia in int,
                                            vo_gradiente out int) is
       vi_PERIODO INT;
       vi_cantcuo INT;
       vi_fecpag3 date;
       
       vi_pgcod xwf700.xwfempresa%type;
       vi_aomod xwf700.xwfmodulo%type;
       vi_aosuc xwf700.xwfsucursal%type;
       vi_aomda xwf700.xwfmoneda%type;
       vi_aopap xwf700.xwfpapel%type;
       vi_aocta xwf700.xwfcuenta%type;
       vi_aooper xwf700.xwfoperacion%type;
       vi_aosbop xwf700.xwfsubope%type;
       vi_aotope xwf700.xwftipope%type;
       
       CUOTA3 NUMBER(17,2);
       CUOTAREST NUMBER(17,2);
       vi_cant_cuot  number(6);
       vi_cuotas  number(5);
       contador number(10);
       vi_fecha_pago date;
       vi_cuota_fija number(17,2);
       vi_temporal number(17,2);
       vi_controlcuota NUMBER(10);       
       val_cuota7 number(17,2);
       val_flgCuoIgu varchar2(1);
       val_cuotMin6priCuot number(17,2);
       val_aux6primCuot number(17,2);
       vi_fecpagmax DATE;
       val_cuotMax  number(17,2);
       val_cuotMin number(17,2);
       val_fecha6cuot DATE;
       
       CURSOR CRONOGRAMA_PRP(v_pgcod number,
                            v_aomod number,              
                            v_aosuc number,
                            v_aomda number,
                            v_aopap number,
                            v_aocta number,
                            v_aooper number,
                            v_aosbop number,
                            v_aotope number
                           ) IS 
      SELECT (d.ppcap+d.ppint
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0))) cuota
                  ,D.*
        FROM FSD601 D, FSD611 D2
        WHERE D.PGCOD = v_pgcod
          AND D.PPMOD = v_aomod
          AND D.PPSUC = v_aosuc
          AND D.PPMDA = v_aomda
          AND D.PPPAP = v_aopap
          AND D.PPCTA = v_aocta
          AND D.PPOPER= v_aooper
          AND D.PPSBOP= v_aosbop
          AND D.PPTOPE= v_aotope
          AND D.pgcod =  d2.pgcod
          and D.ppmod =  d2.ppmod 
          and D.ppsuc =  d2.ppsuc
          and D.ppmda =  d2.ppmda 
          and D.pppap =  d2.pppap
          and D.ppcta =  d2.ppcta
          and D.ppoper = d2.ppoper
          and D.ppsbop = d2.ppsbop
          and D.pptope = d2.pptope
          and D.ppfpag = d2.ppfpag
          and D.PPTIPO = 'M' --AGREGADO HASL 
          ORDER BY D.PPFPAG ASC;         
       
       BEGIN
         ---VALIDAR FRECUENCIA SEA MENSUAL O MENOR
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
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
         exception
              when others then
                null;                                  
         END;
         
         -- tiene menos de 6 cuotas no aplica gradiente
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
               AND D.PPOPER= vi_aooper
               AND D.PPSBOP= vi_aosbop
               AND D.PPTOPE= vi_aotope
               and D.PPTIPO = 'M'; --AGREGADO HASL
           EXCEPTION
             WHEN OTHERS THEN
                  vi_cuotas := 0; 
           END;
           --GUIA ESPECIAL 
           BEGIN
             SELECT TP1IMP1 
             INTO vi_controlcuota
             FROM FST198 
             WHERE TP1COD  = 1
             AND   TP1COD1 = 108999
             AND  TP1CORR1 = 400000
             AND  TP1CORR2 = 301
             AND  TP1CORR3 = 1
             AND  TP1NRO1  = 1;
           EXCEPTION
             WHEN OTHERS THEN
               null;            
           END;
           vi_controlcuota := nvl(vi_controlcuota, 0);                      
           
           
           val_flgCuoIgu := 'S';
           val_cuotMin6priCuot := 0;
           val_fecha6cuot := '';
           IF vi_cuotas >= vi_controlcuota  THEN  ---mayor o igual a 7 cuotas
              --Sólo aplica para frecuencias mensuales (no aplica para créditos con flujo de caja).
              contador := 1;
              val_cuota7 := 0;
              BEGIN
                     for j in CRONOGRAMA_PRP(
                                              vi_pgcod,
                                              vi_aomod,
                                              vi_aosuc,
                                              vi_aomda,
                                              vi_aopap,
                                              vi_aocta,
                                              vi_aooper,
                                              vi_aosbop,
                                              vi_aotope
                                            ) loop  
                    
                        BEGIN                                                
                           if contador = 7 then
                              val_fecha6cuot := j.ppfpag;
                              --cuota
                              vi_cuota_fija := j.cuota; 
                              val_cuota7 := vi_cuota_fija;                             
                           end if;
                                                                        
                           --El monto de las cuotas a partir de la cuota 7 serán iguales solo hasta la penultima cuota.
                           if contador >= vi_controlcuota AND contador <= (vi_cuotas-1) THEN                            
                              --SUMAR CAPITAL + INTERES + SEGURO
                              if vi_cuota_fija <> j.cuota then --EN CASO DE QUE LA CUOTA A PARTIR DE LA 7 CUOTA SEA DIFERENTE NO APLICA CONTROL
                                 val_flgCuoIgu := 'N'; --no controlamos.
                                 val_cuota7 := 0;
                                 exit;
                              end if;  
                           end if;  
                        END;
                        contador := contador + 1;
                    end loop;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;                                                        
               END;            
               
               IF val_flgCuoIgu = 'S' THEN
                  BEGIN
                   SELECT MIN((d.ppcap+d.ppint
                          + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                          INTO val_cuotMin6priCuot 
                    FROM FSD601 D, FSD611 D2
                    WHERE D.PGCOD = vi_pgcod
                      AND D.PPMOD = vi_aomod
                      AND D.PPSUC = vi_aosuc
                      AND D.PPMDA = vi_aomda
                      AND D.PPPAP = vi_aopap
                      AND D.PPCTA = vi_aocta
                      AND D.PPOPER= vi_aooper
                      AND D.PPSBOP= vi_aosbop
                      AND D.PPTOPE= vi_aotope 
                      AND D.pgcod =  d2.pgcod
                      and D.ppmod =  d2.ppmod 
                      and D.ppsuc =  d2.ppsuc
                      and D.ppmda =  d2.ppmda 
                      and D.pppap =  d2.pppap
                      and D.ppcta =  d2.ppcta
                      and D.ppoper = d2.ppoper
                      and D.ppsbop = d2.ppsbop
                      and D.pptope = d2.pptope
                      and D.ppfpag = d2.ppfpag
                      and D.ppfpag < val_fecha6cuot
                      and D.PPTIPO = 'M' --AGREGADO HASL
                      ORDER BY D.PPFPAG ASC;   
                   EXCEPTION 
                     WHEN OTHERS THEN
                       val_cuotMin6priCuot := 0;
                   END; 
                   val_cuotMin6priCuot := nvl(val_cuotMin6priCuot, 0);  
                   
                   --calculo de gradiente
                   IF val_cuota7 <> 0 THEN
                      BEGIN
                        SELECT (1 - (val_cuotMin6priCuot/val_cuota7))* 100 INTO vo_gradiente FROM DUAL;
                      EXCEPTION 
                       WHEN OTHERS THEN   
                         vo_gradiente := 0;                 
                      END;
                    END IF;
                    
               END IF;               
               vo_gradiente := NVL(vo_gradiente, 0);                                  
               
           ELSE --menor o igual a 6 cuotas
             BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
                SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmax     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER =vi_aooper
                    AND D.PPSBOP =vi_aosbop
                    AND D.PPTOPE =vi_aotope
                    and D.PPTIPO = 'M'; --AGREGADO HASL;
             EXCEPTION
               WHEN OTHERS THEN
                  vi_fecpagmax := NULL; 
             END;
             
             val_cuotMax := 0;
             BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
               SELECT MAX((d.ppcap+d.ppint
                      + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                      INTO val_cuotMax 
                FROM FSD601 D, FSD611 D2
                WHERE D.PGCOD = vi_pgcod
                  AND D.PPMOD = vi_aomod
                  AND D.PPSUC = vi_aosuc
                  AND D.PPMDA = vi_aomda
                  AND D.PPPAP = vi_aopap
                  AND D.PPCTA = vi_aocta
                  AND D.PPOPER= vi_aooper
                  AND D.PPSBOP= vi_aosbop
                  AND D.PPTOPE= vi_aotope 
                  AND D.pgcod =  d2.pgcod
                  and D.ppmod =  d2.ppmod 
                  and D.ppsuc =  d2.ppsuc
                  and D.ppmda =  d2.ppmda 
                  and D.pppap =  d2.pppap
                  and D.ppcta =  d2.ppcta
                  and D.ppoper = d2.ppoper
                  and D.ppsbop = d2.ppsbop
                  and D.pptope = d2.pptope
                  and D.ppfpag = d2.ppfpag
                  and D.ppfpag < vi_fecpagmax
                  and D.PPTIPO = 'M' --AGREGADO HASL
                  ORDER BY D.PPFPAG ASC;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   val_cuotMax := 0;
               END; 
               val_cuotMax := nvl(val_cuotMax, 0);  
               
              val_cuotMin := 0;
               BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
               SELECT Min((d.ppcap+d.ppint
                      + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                      INTO val_cuotMin 
                FROM FSD601 D, FSD611 D2
                WHERE D.PGCOD = vi_pgcod
                  AND D.PPMOD = vi_aomod
                  AND D.PPSUC = vi_aosuc
                  AND D.PPMDA = vi_aomda
                  AND D.PPPAP = vi_aopap
                  AND D.PPCTA = vi_aocta
                  AND D.PPOPER= vi_aooper
                  AND D.PPSBOP= vi_aosbop
                  AND D.PPTOPE= vi_aotope 
                  AND D.pgcod =  d2.pgcod
                  and D.ppmod =  d2.ppmod 
                  and D.ppsuc =  d2.ppsuc
                  and D.ppmda =  d2.ppmda 
                  and D.pppap =  d2.pppap
                  and D.ppcta =  d2.ppcta
                  and D.ppoper = d2.ppoper
                  and D.ppsbop = d2.ppsbop
                  and D.pptope = d2.pptope
                  and D.ppfpag = d2.ppfpag
                  and D.ppfpag < vi_fecpagmax
                  and D.PPTIPO = 'M' --AGREGADO HASL
                  ORDER BY D.PPFPAG ASC;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   val_cuotMin := 0;
               END; 
               val_cuotMin := nvl(val_cuotMin, 0);                          
              
              --calcular gradiente
              IF val_cuotMax <> 0 THEN           
                BEGIN
                  SELECT (1-(val_cuotMin/val_cuotMax))*100 INTO vo_gradiente FROM DUAL;
                EXCEPTION 
                 WHEN OTHERS THEN   
                   vo_gradiente := 0;                 
                END;
              END IF;
                 
              vo_gradiente := NVL(vo_gradiente, 0);
           END IF;                        
         vo_gradiente := NVL(vo_gradiente, 0);     
 END;  

end pq_cr_controles_memo24;
/

