create or replace package PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM is

  -- Author  : CALARCONAP
  -- Created : 21/01/2025 14:57:29
  -- Purpose : PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM
  -- USO     : Paquetes que validan reprogramacion por normalizacion  

  PROCEDURE SP_CR_NUMCUOTAS_RPC_G1(INSTANCIA  IN NUMBER,
                                   USUARIO    in varchar2,                                   
                                   RPTA_FINAL OUT VARCHAR2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2);

  procedure sp_cr_MoraMaxCuoPen_Repro_r2(instancia     in number,
                                         usuario       in varchar2,
                                         moraMaxCuoPen out varchar2,
                                         codigo_error  out varchar2,
                                         mensaje_error out varchar2);

  procedure sp_cr_resolutorE_Repro_r3(instancia     in number,
                                      usuario       in varchar2,
                                      lc_flag       out varchar2,
                                      codigo_error  out varchar2,
                                      mensaje_error out varchar2);

  PROCEDURE SP_CR_RNG95_RSC_GRP4(P_INSTANCIA IN NUMBER,
                                 P_USUARIO   IN VARCHAR2,
                                 P_RESPUESTA OUT VARCHAR2,
                                 P_CODERROR  OUT VARCHAR2,
                                 P_MSGERROR  OUT VARCHAR2);

  procedure sp_cr_reprogsincrm_005(INSTANCIA  in number,
                                   USUARIO    in varchar2,
                                   RPTA_FINAL out varchar2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2);

  PROCEDURE SP_CR_MOR_MAXPND_RPRG_RPC_G6(P_INSTANCIA IN NUMBER,
                                         P_USUARIO   IN VARCHAR2,
                                         P_RESPUESTA OUT VARCHAR2,
                                         P_CODERROR  OUT VARCHAR2,
                                         P_MSGERROR  OUT VARCHAR2);

  -----control en obj RAQPC834-----------------------------------------------                                              
   procedure sp_cr_MoraMaxReprog(ln_Instancia    in number,
                                ln_MoraMaxRepro out number);
                                
  -----control en obj RAQPC832-----------------------------------------------
  procedure sp_cr_MoraMaxCuoPen(ln_Instancia     in number,
                                ln_MoraMaxCuoPen out number);

end PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM;
/
create or replace package body PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM is

  -- Author  : CALARCONAP
  -- Created : 15/01/2025 
  -- Purpose : PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM
  -- USO     : Paquetes que validan reprogramacion por normalizacion  

  PROCEDURE SP_CR_NUMCUOTAS_RPC_G1(INSTANCIA  IN NUMBER,
                                   USUARIO    in varchar2,
                                   RPTA_FINAL OUT VARCHAR2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2) IS
  
    ----------------------------------------------------------------------------------------------------
    -- NOMBRE                      : SP_CR_NUMCUOTAS_RPC_G1
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 21/01/2025
    -- AUTOR DE CREACION           : MHUAMANIA
    -- USO                         : VALIDA SI TIENE ATRASO DE LAS ULTIMAS 6 CUOTAS CANCELADAS
    -- PARAMETROS                  : USUARIO | VARCHAR2
    --                               INSTANCIA   | NUMBER
    --                               RPTA_FINAL | VARCHAR2
    --                               COD_ERROR  | VARCHAR2
    --                               MSG_SALIDA  | VARCHAR2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    ----------------------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    ----------------------------------------------------------------------------------------------------                                                 
  
    vi_pgcod       number;
    vi_aomod       number;
    vi_aosuc       number;
    vi_aomda       number;
    vi_aopap       number;
    vi_aocta       number;
    vi_aooper      number;
    vi_aosbop      number;
    vi_aotope      number;
    CUOTAS_TOTALES number;
  
  BEGIN
  
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
       where xwfprcins = INSTANCIA
         and xwfcar3 <> '1';
    
    exception
      when others then
        COD_ERROR  := '0001';
        MSG_SALIDA := 'La instancia no es valida';
        RETURN;
    END;
  
    --CUOTAS FSD601
    begin
      SELECT COUNT(*)
        INTO CUOTAS_TOTALES
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
         and D.d601co = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
        CUOTAS_TOTALES := 0;
    end;
  
    RPTA_FINAL := CUOTAS_TOTALES;
  
    if CUOTAS_TOTALES < 4 THEN
      COD_ERROR  := '0002';
      MSG_SALIDA := 'El mínimo de cuotas pagadas debe es >= a 4';
    else
      COD_ERROR  := '0000';
      MSG_SALIDA := '';
    end if;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RPTA_FINAL := NULL;
  END SP_CR_NUMCUOTAS_RPC_G1;

  procedure sp_cr_MoraMaxCuoPen_Repro_r2(instancia     in number,
                                         usuario       in varchar2,
                                         moraMaxCuoPen out varchar2,
                                         codigo_error  out varchar2,
                                         mensaje_error out varchar2) is
  -- Author  : MCORDOVA
  -- Created : 15/01/2025 
  -- Purpose : sp_cr_MoraMaxCuoPen_Repro_r2
  -- USO     : REGLA 2 DE NORMALIZACION  
  
    ln_pgcod      number;
    ln_sucursal   number;
    ln_modulo     number;
    ln_moneda     number;
    ln_papel      number;
    ln_cuenta     number;
    ln_operacion  number;
    ln_subopera   number;
    ln_tipopera   number;
    ld_FchSist    date;
    ld_UltFchPago date;
    ld_FchPrxCuot date;
  begin
  
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = instancia
         and x.xwfcar3 = 1; --<> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(ppfpag)
        into ld_UltFchPago
        from fsd602
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag <= ld_FchSist
         and pp1stat = 'T';
    exception
      when others then
        codigo_error  := '0001';
        mensaje_error := 'No existe fecha de ultimo pago.';
    end;
  
    begin
      select min(ppfpag)
        into ld_FchPrxCuot
        from fsd601
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag > ld_UltFchPago;
    exception
      when others then
        codigo_error  := '0002';
        mensaje_error := 'No existe fecha de proxima cuota.';
    end;
  
    if ld_FchPrxCuot is not null then
      moraMaxCuoPen := to_char(ld_FchSist - ld_FchPrxCuot);
      codigo_error  := '0001';
      mensaje_error := '';
    end if;
  
  end sp_cr_MoraMaxCuoPen_Repro_r2;

  procedure sp_cr_resolutorE_Repro_r3(instancia     in number,
                                      usuario       in varchar2,
                                      lc_flag       out varchar2,
                                      codigo_error  out varchar2,
                                      mensaje_error out varchar2) is
                                      
  -- Author  : MCORDOVA
  -- Created : 15/01/2025 
  -- Purpose : sp_cr_resolutorE_Repro_r3
  -- USO     : REGLA 3 DE NORMALIZACION  
  
    ln_nromora   number := 0;
    ln_registros number := 0;
    ln_diaaux    number;
    V_PGFAPE     date;
    ln_Pepais    NUMBER;
    ln_Petdoc    NUMBER;
    ln_Pendoc    CHAR;
    resultado    number;
    ln_dias   number;
  
    cursor cuotas is
      select *
        from (select f601.*
                from fsd010 d10, fsd601 f601
               where d10.Pgcod = 1
                 and d10.Aocta in (select Ctnro
                                     from fsr008
                                    where pepais = ln_Pepais
                                      and Petdoc = ln_Petdoc
                                      and pendoc = ln_Pendoc
                                      and Ttcod = 1
                                      and Cttfir = 'T')
                 and (d10.Aomod in
                     (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in
                              ((select tp1nro1
                                 from fst198
                                where tp1cod = 1
                                  and tp1cod1 = 11004
                                  and tp1corr1 = 1
                                  and tp1corr2 = 1))) or Aomod = 117)
                 and d10.Aostat <> 99
                 and f601.pgcod = 1
                 and d10.aomod = f601.ppmod
                 and d10.aosuc = f601.ppsuc
                 and d10.aomda = f601.ppmda
                 and d10.aopap = f601.pppap
                 and d10.aocta = f601.ppcta
                 and d10.aooper = f601.ppoper
                 and d10.aosbop = f601.ppsbop
                 and f601.d601co = 'S'
                 and f601.ppfpag <= v_pgfape
               order by f601.ppfpag desc) f
       where ROWNUM <= 6;
  
  begin
  
    BEGIN
      SELECT PGFAPE INTO V_PGFAPE FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    /*
    BEGIN
      SELECT * FROM FSR008 WHERE CTNRO in (
      SELECT XWFCUENTA 
      FROM XWF700 
      WHERE XWFPRCINS = instancia AND 
      XWFCAR3 = '1' AND 
      ROWNUM = 1) AND Ttcod = 1 AND Cttfir = 'T';
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
    */
    for c in cuotas loop
    
      ln_registros := ln_registros + 1;
    
      begin
      
        select (f.d602fc - f.ppfpag)
          into ln_diaaux
          from fsd602 f
         where f.pgcod = c.pgcod
           and f.ppmod = c.ppmod
           and f.ppsuc = c.ppsuc
           and f.ppmda = c.ppmda
           and f.pppap = c.pppap
           and f.ppcta = c.ppcta
           and f.ppoper = c.ppoper
           and f.ppsbop = c.ppsbop
           and f.pptope = c.pptope
           and f.ppfpag = c.ppfpag
           and f.pp1stat = 'T'
           and f.d602co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          begin
            ln_diaaux := v_pgfape - c.ppfpag;
          end;
      end;
    
      ln_nromora := nvl(ln_nromora, 0) + nvl(ln_diaaux, 0);
    
    end loop;
  
    if ln_nromora < 0 then
      ln_nromora := 0;
    end if;
  
    if ln_registros > 0 then
    
      --pq_cr_control_reprog_sincapit_cambifech.sp_cr_pagos(ln_nromora, ln_registros, lc_flag);
    
      resultado := nvl(ln_nromora, 0) / nvl(ln_registros, 0);
    
      begin
      
        select TP1NRO1
          INTO ln_dias
          From fst198 J
         where tp1cod = 1
           and tp1cod1 = 11152
           AND J.TP1CORR1 = 190
           AND J.TP1CORR2 = 1
           AND j.TP1CORR3 = 1;
      
      exception
        when others then
          null;
        
      end;
    
      if resultado <= ln_dias then
        lc_flag := 'N';      
      else
        lc_flag := 'S';
      end if;
    
      codigo_error  := '0000';
      mensaje_error := '';
      
    else
      
      if ln_registros <= 0 then
      
        lc_flag       := 'S';
        codigo_error  := '0001';
        mensaje_error := '';
      
      end if;
    
    end if;
  
  end sp_cr_resolutorE_Repro_r3;

  PROCEDURE SP_CR_RNG95_RSC_GRP4(P_INSTANCIA IN NUMBER,
                                 P_USUARIO   IN VARCHAR2,
                                 P_RESPUESTA OUT VARCHAR2,
                                 P_CODERROR  OUT VARCHAR2,
                                 P_MSGERROR  OUT VARCHAR2) IS
  
    ----------------------------------------------------------------------------------------------------
    -- NOMBRE                      : SP_CR_RNG95_RSC_GRP4
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 15/01/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : VALIDA SI TIENE ATRASO DE LAS ULTIMAS 6 CUOTAS CANCELADAS
    -- PARAMETROS                  : P_INSTANCIA | NUMBER(10)
    --                               P_USUARIO   | VARCHAR2(10)
    --                               P_RESPUESTA | VARCHAR2(1)
    --                               P_CODERROR  | VARCHAR2(5)
    --                               P_MSGERROR  | VARCHAR2(255)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    ----------------------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    ----------------------------------------------------------------------------------------------------                                                 
  
    V_MORAMAXRPG NUMBER(17) := 0;
    V_CODERROR   VARCHAR2(5) := '00000';
    V_MSGERROR   VARCHAR2(255) := NULL;
    V_RESPUESTA  VARCHAR2(1) := NULL;
  BEGIN
    BEGIN
      PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM.SP_CR_MORAMAXREPROG(LN_INSTANCIA    => P_INSTANCIA,
                                                                  LN_MORAMAXREPRO => V_MORAMAXRPG);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF V_MORAMAXRPG >= 45 THEN
      V_CODERROR  := '90001';
      V_MSGERROR  := 'Atraso de las últimas 06 cuotas canceladas mayor o igual a 45 días';
      V_RESPUESTA := 'S';
    ELSE
      V_RESPUESTA := 'N';
    END IF;
  
    P_RESPUESTA := V_RESPUESTA;
    P_CODERROR  := V_CODERROR;
    V_MSGERROR  := V_MSGERROR;
  
  END SP_CR_RNG95_RSC_GRP4;


  procedure sp_cr_reprogsincrm_005(INSTANCIA  in number,
                                   USUARIO    in varchar2,
                                   RPTA_FINAL out varchar2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2) is
  
  -- Author  : JALVARO
  -- Created : 15/01/2025 
  -- Purpose : sp_cr_reprogsincrm_005
  -- USO     : REGLA 5 DE NORMALIZACION  
  
    RPTA_1 varchar2(1);
  begin
  
    begin
    
      pQ_CR_CALIFICACIONES.sp_cr_VerfCalDetTitConyRL6M(ln_Instancia     => INSTANCIA,
                                                       lc_VerifCalDet6M => RPTA_1);
    
      begin
        if RPTA_1 = 'S' then
          RPTA_FINAL := 'S';
          MSG_SALIDA := 'Calificacion de los ultimos 6 meses diferente a normal';
        else
          RPTA_FINAL := 'N';
          MSG_SALIDA := '';
        end if;
      
      exception
        when others then
          COD_ERROR  := '001';
          MSG_SALIDA := 'Error';
      end;
    
    exception
      when others then
        null;
    end;
  
  end sp_cr_reprogsincrm_005;

  PROCEDURE SP_CR_MOR_MAXPND_RPRG_RPC_G6(P_INSTANCIA IN NUMBER,
                                         P_USUARIO   IN VARCHAR2,
                                         P_RESPUESTA OUT VARCHAR2,
                                         P_CODERROR  OUT VARCHAR2,
                                         P_MSGERROR  OUT VARCHAR2) IS
  
    ----------------------------------------------------------------------------------------------------
    -- NOMBRE                      : SP_CR_MOR_MAXPND_RPRG_RPC_G6
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 21/01/2025
    -- AUTOR DE CREACION           : MHUAMANIA
    -- USO                         : Valida la mora maxima segun isntancia
    -- PARAMETROS                  : P_INSTANCIA IN  NUMBER,
    --P_USUARIO   IN  VARCHAR2,
    --P_RESPUESTA OUT VARCHAR2,
    --P_CODERROR  OUT VARCHAR2,
    --P_MSGERROR  OUT VARCHAR2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    ----------------------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    ----------------------------------------------------------------------------------------------------                                                 
  
    V_MoraMaxCuoPen NUMBER(17) := 0;
  BEGIN
    BEGIN
      PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM.sp_cr_MoraMaxCuoPen(ln_Instancia     => P_INSTANCIA,
                                                                  ln_MoraMaxCuoPen => V_MoraMaxCuoPen);
      --falta error en el procedimiento
    EXCEPTION
      WHEN OTHERS THEN
        P_CODERROR := '0001';
        P_MSGERROR := 'Error en la instancia';
    END;
  
    P_RESPUESTA := cast(V_MoraMaxCuoPen as varchar);
    IF V_MoraMaxCuoPen > 30 THEN
      P_CODERROR := '0002';
      P_MSGERROR := 'Sólo puede tener una cuota pendiente con atraso mayor a 30 días';
    
    ELSE
      P_CODERROR := '0000';
      P_MSGERROR := '';
    END IF;
  
  END SP_CR_MOR_MAXPND_RPRG_RPC_G6;
  
  procedure sp_cr_MoraMaxReprog(ln_Instancia    in number,
                                ln_MoraMaxRepro out number) is
  
  -- Author  : MCORDOVA
  -- Created : 15/01/2025 
  -- Purpose : sp_cr_MoraMaxReprog
  -- USO     : Obtiene maxima reprogramacion  
  
    cursor calendario(ln_pgcod     number,
                      ln_sucursal  number,
                      ln_modulo    number,
                      ln_moneda    number,
                      ln_papel     number,
                      ln_cuenta    number,
                      ln_operacion number,
                      ln_subopera  number,
                      ln_tipopera  number,
                      ld_FchSist   date) is
      select f.pgcod  ln_pgcod,
             f.ppsuc  ln_sucursal,
             f.ppmod  ln_modulo,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subopera,
             f.pptope ln_tipopera,
             f.ppfpag ld_FchCalendario
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppsuc = ln_sucursal
         and f.ppmod = ln_modulo
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_subopera
         and f.pptope = ln_tipopera
         and f.ppfpag <= ld_FchSist;
  
    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_subopera     number;
    ln_tipopera     number;
    ld_FchSist      date;
    ln_MoraCuota    number := 0;
    ln_MoraCuotaAux number := 0;
  
  begin
  
    begin
    
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = 1; --<> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    for c in calendario(ln_pgcod,
                        ln_sucursal,
                        ln_modulo,
                        ln_moneda,
                        ln_papel,
                        ln_cuenta,
                        ln_operacion,
                        ln_subopera,
                        ln_tipopera,
                        ld_FchSist) loop
    
      begin
        select max(pp1fech - ppfpag)
          into ln_MoraCuota
          from fsd602
         where pgcod = C.LN_PGCOD
           and ppsuc = c.ln_sucursal
           and ppmod = c.ln_modulo
           and ppmda = c.ln_moneda
           and pppap = c.ln_papel
           and ppcta = c.ln_cuenta
           and ppoper = c.ln_operacion
           and ppsbop = c.ln_subopera
           and pptope = c.ln_tipopera
           and pp1stat = 'T'
           and ppfpag = c.ld_fchcalendario;
      exception
        when no_Data_found then
          ln_MoraCuota := ld_FchSist - c.ld_fchcalendario;
      end;
    
      if ln_MoraCuota > ln_MoraCuotaAux then
        ln_MoraCuotaAux := ln_MoraCuota;
      end if;
    
    end loop;
    ln_MoraMaxRepro := ln_MoraCuotaAux;
  
  end sp_cr_MoraMaxReprog;
  
  ----------------------------------------------------------------------------------------------  
  procedure sp_cr_MoraMaxCuoPen(ln_Instancia     in number,
                                ln_MoraMaxCuoPen out number) is
  
  -- Author  : MCORDOVA
  -- Created : 15/01/2025 
  -- Purpose : sp_cr_MoraMaxCuoPen
  -- USO     : Obtiene maxima cuota pendiente
  
    ln_pgcod      number;
    ln_sucursal   number;
    ln_modulo     number;
    ln_moneda     number;
    ln_papel      number;
    ln_cuenta     number;
    ln_operacion  number;
    ln_subopera   number;
    ln_tipopera   number;
    ld_FchSist    date;
    ld_UltFchPago date;
    ld_FchPrxCuot date;
  begin
  
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = 1; --<> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(ppfpag)
        into ld_UltFchPago
        from fsd602
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag <= ld_FchSist
         and pp1stat = 'T'
      /*and rownum = 1*/
      ;
    exception
      when others then
        null;
    end;
  
    begin
      select min(ppfpag)
        into ld_FchPrxCuot
        from fsd601
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag > ld_UltFchPago;
    exception
      when others then
        null;
      
    end;
  
    if ld_FchPrxCuot is not null then
      ln_MoraMaxCuoPen := ld_FchSist - ld_FchPrxCuot;
    end if;
  
  end sp_cr_MoraMaxCuoPen;
  ---------------------------------------------------------------------------------------------- 

end PQ_CR_VALID_RNG_RPG_NORMALIZACION_SCRM;
/
