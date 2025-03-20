create or replace package PQ_CR_REPROG_DESASTRE_NATURAL is

  -- Author  : APACHECOH
  -- Created : 3/03/2022 11:00:46
  -- Purpose : 

  procedure sp_cr_codigo_credito(ve_instancia in int,
                                 vo_pgcod     out xwf700.xwfempresa%type,
                                 vo_aomod     out xwf700.xwfmodulo%type,
                                 vo_aosuc     out xwf700.xwfsucursal%type,
                                 vo_aomda     out xwf700.xwfmoneda%type,
                                 vo_aopap     out xwf700.xwfpapel%type,
                                 vo_aocta     out xwf700.xwfcuenta%type,
                                 vo_aooper    out xwf700.xwfoperacion%type,
                                 vo_aosbop    out xwf700.xwfsubope%type,
                                 vo_aotope    out xwf700.xwftipope%type,
                                 vo_rpta      out char);

  procedure sp_cr_ultima_cuota_dias_atraso(ve_instancia in int,
                                           vo_rpta      out number);

  procedure sp_cr_ultseis_cuota_dias_atraso(ve_instancia in int,
                                            vo_rpta      out number);

  procedure sp_cr_calif100_rcc(ve_instancia in int, vo_rpta out varchar2);

  -- Author  : Maycol Chavez Chuman
  -- Created : 14/03/2022 9:45:30
  -- Purpose : Reprogramacion Desatres Naturales

  PROCEDURE SP_CR_MNT_AQPB252(P_EMP    IN NUMBER,
                              P_MOD    IN NUMBER,
                              P_SUC    IN NUMBER,
                              P_MDA    IN NUMBER,
                              P_PAP    IN NUMBER,
                              P_CTA    IN NUMBER,
                              P_OPER   IN NUMBER,
                              P_SBOP   IN NUMBER,
                              P_TOP    IN NUMBER,
                              P_FINI   IN DATE,
                              P_FFIN   IN DATE,
                              P_EST    IN VARCHAR2,
                              P_IND    IN VARCHAR2,
                              P_MODO   IN VARCHAR2,
                              P_AUX1   IN VARCHAR2,
                              P_AUX2   OUT VARCHAR2,
                              P_CODERR OUT VARCHAR2,
                              P_MSGERR OUT VARCHAR2);

  PROCEDURE SP_CR_MNT_AQPC205(P_EMP        IN NUMBER,
                              P_MOD        IN NUMBER,
                              P_SUC        IN NUMBER,
                              P_MDA        IN NUMBER,
                              P_PAP        IN NUMBER,
                              P_CTA        IN NUMBER,
                              P_OPER       IN NUMBER,
                              P_SBOP       IN NUMBER,
                              P_TOP        IN NUMBER,
                              P_MSGERR     IN VARCHAR2,
                              P_MORA_PENAL IN VARCHAR2,
                              P_FCH_REG    IN DATE,
                              P_HOR_REG    IN VARCHAR2,
                              P_USU_REG    IN VARCHAR2);

end PQ_CR_REPROG_DESASTRE_NATURAL;
/

create or replace package body PQ_CR_REPROG_DESASTRE_NATURAL is

  procedure sp_cr_codigo_credito(ve_instancia in int,
                                 vo_pgcod     out xwf700.xwfempresa%type,
                                 vo_aomod     out xwf700.xwfmodulo%type,
                                 vo_aosuc     out xwf700.xwfsucursal%type,
                                 vo_aomda     out xwf700.xwfmoneda%type,
                                 vo_aopap     out xwf700.xwfpapel%type,
                                 vo_aocta     out xwf700.xwfcuenta%type,
                                 vo_aooper    out xwf700.xwfoperacion%type,
                                 vo_aosbop    out xwf700.xwfsubope%type,
                                 vo_aotope    out xwf700.xwftipope%type,
                                 vo_rpta      out char) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_codigo_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.03
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtiene la clave del crédito a partir de la instancia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_pgcod ( Codigo Empresa )
    --                              vo_aomod ( Modulo )
    --                              vo_aosuc ( Sucursal )
    --                              vo_aomda ( Moneda )
    --                              vo_aopap ( Papel )
    --                              vo_aocta ( Cuenta )
    --                              vo_aooper ( Operacion )
    --                              vo_aosbop ( Sub Operacion )
    --                              vo_aotope ( Tipo Operacion )
    --                              vo_rpta ( Respuesta )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************                                 
  BEGIN
    begin
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vo_pgcod,
             vo_aomod,
             vo_aosuc,
             vo_aomda,
             vo_aopap,
             vo_aocta,
             vo_aooper,
             vo_aosbop,
             vo_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
      --Una suboperacion menos
      vo_aosbop := vo_aosbop - 1;
      vo_rpta   := 'S';
    exception
      when others then
        vo_rpta := 'N';
    end;
  END;

  procedure sp_cr_ultima_cuota_dias_atraso(ve_instancia in int,
                                           vo_rpta      out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_ultima_cuota_dias_atraso
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.03
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtiene los dias de atraso de la ultima cuota pendiente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( n° Dias )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************  
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    ld_ult_fecpag  DATE;
    ld_sig_fecpag  DATE;
    ld_pgfape      DATE;
    ln_dias_atraso NUMBER(5);
    ln_cnt601      NUMBER(3);
  
    vi_rpta VARCHAR2(1);
    ln_flag NUMBER(5);
  
  BEGIN
    ln_dias_atraso := 0;
    ln_cnt601      := 0;
    PQ_CR_REPROG_DESASTRE_NATURAL.sp_cr_codigo_credito(ve_instancia => ve_instancia,
                                                       vo_pgcod     => vi_pgcod,
                                                       vo_aomod     => vi_aomod,
                                                       vo_aosuc     => vi_aosuc,
                                                       vo_aomda     => vi_aomda,
                                                       vo_aopap     => vi_aopap,
                                                       vo_aocta     => vi_aocta,
                                                       vo_aooper    => vi_aooper,
                                                       vo_aosbop    => vi_aosbop,
                                                       vo_aotope    => vi_aotope,
                                                       vo_rpta      => vi_rpta);
  
    if vi_rpta = 'N' then
      DBMS_OUTPUT.put_line('No existe la instancia');
      vo_rpta := 0;
      return;
    end if;
  
    --apachecoh 2023.04.27
    --Validar si es credito agricola
    /*begin
      select count(*)
        into ln_flag
        from fst198
       where tp1cod1 = 11169
         and tp1corr1 = 10
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_aomod;
    exception
      when others then
        ln_flag := 0;
    end;
    if ln_flag = 0 then
      begin
        select count(*)
          into ln_flag
          from fst198
         where tp1cod1 = 11169
           and tp1corr1 = 10
           and tp1corr2 = 3
           and tp1corr3 > 0
           and tp1nro1 = vi_aomod
           and tp1nro2 = vi_aotope;
      exception
        when others then
          ln_flag := 0;
      end;
    end if;*/
    --Obtener fecha de ultimo pago
    begin      
      select nvl(max(ppfpag), to_date('01/01/1900', 'dd/mm/rrrr'))
        into ld_ult_fecpag
        from fsd602
       where pgcod = vi_pgcod
         and ppmod = vi_aomod --and ppsuc = vi_aosuc 
         and ppmda = vi_aomda
         and pppap = vi_aopap
         and ppcta = vi_aocta
         and ppoper = vi_aooper
         and ppsbop = vi_aosbop
         and pptope = vi_aotope
         and pp1stat = 'T'
         and d602co = 'S';
    exception
      when others then
        ld_ult_fecpag := to_date('01/01/1900', 'dd/mm/rrrr');
    end;
    --Fecha de siguiente pago 
    begin
      select count(*)
        into ln_cnt601
        from fsd601
       where pgcod = vi_pgcod
         and ppmod = vi_aomod --and ppsuc = vi_aosuc 
         and ppmda = vi_aomda
         and pppap = vi_aopap
         and ppcta = vi_aocta
         and ppoper = vi_aooper
         and ppsbop = vi_aosbop
         and pptope = vi_aotope
         and ppfpag > ld_ult_fecpag
         and pptipo = 'M';
      --Verificar si es el ultimo pago   
      if ln_cnt601 > 0 then
        select min(ppfpag)
          into ld_sig_fecpag
          from fsd601
         where pgcod = vi_pgcod
           and ppmod = vi_aomod --and ppsuc = vi_aosuc 
           and ppmda = vi_aomda
           and pppap = vi_aopap
           and ppcta = vi_aocta
           and ppoper = vi_aooper
           and ppsbop = vi_aosbop
           and pptope = vi_aotope
           and ppfpag > ld_ult_fecpag
           and pptipo = 'M';
      /*else
        ld_sig_fecpag := ld_ult_fecpag; --es la ultima cuota  
      */          
      /*select pp1fech into ld_sig_fecpag
               from fsd602 
        where pgcod = vi_pgcod and ppmod = vi_aomod and ppsuc = vi_aosuc 
          and ppmda = vi_aomda and pppap = vi_aopap and ppcta = vi_aocta 
          and ppoper = vi_aooper and ppsbop = vi_aosbop and pptope = vi_aotope
          and ppfpag = ld_ult_fecpag;
      */
      end if;
    exception
      when others then
        --DBMS_OUTPUT.put_line('No existe cronograma de pagos');
        vo_rpta := 0;
        return;
    end;
    --Fecha del sistema
    begin
      select pgfape into ld_pgfape from fst017 where pgcod = 1;
    end;
    begin
      --Calcular dias de atraso      
     if ln_cnt601 > 0 then
              select ld_pgfape - ld_sig_fecpag 
                     into ln_dias_atraso 
              from dual;
     else    
        ln_dias_atraso := 0;       
      end if;
    exception
      when others then
        --DBMS_OUTPUT.put_line('No resta las fechas');
        vo_rpta := 0;
        return;
    end;
    if ln_dias_atraso < 0 then
      vo_rpta := 0;
    else
      vo_rpta := ln_dias_atraso;
    end if;
  END;

  procedure sp_cr_ultseis_cuota_dias_atraso(ve_instancia in int,
                                            vo_rpta      out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_ultseis_cuota_dias_atraso
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.03
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtiene el promedio de las últimas 6 cuotas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( n° Dias )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************  
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    ld_ult_fecpag  DATE;
    ld_sig_fecpag  DATE;
    ld_pgfape      DATE;
    ln_dias_atraso NUMBER(5);
    ln_count       NUMBER(5);
    ln_cnt601      NUMBER(3);
    ln_suma_dias   NUMBER(5);
    ln_flag        NUMBER(5);
  
    vi_rpta VARCHAR2(1);
  
    CURSOR cronograma_pago_t(vi_pgcod  xwf700.xwfempresa%type,
                             vi_aomod  xwf700.xwfmodulo%type,
                             vi_aosuc  xwf700.xwfsucursal%type,
                             vi_aomda  xwf700.xwfmoneda%type,
                             vi_aopap  xwf700.xwfpapel%type,
                             vi_aocta  xwf700.xwfcuenta%type,
                             vi_aooper xwf700.xwfoperacion%type,
                             vi_aosbop xwf700.xwfsubope%type,
                             vi_aotope xwf700.xwftipope%type,
                             vi_ppfpag date) IS
      select ppfpag, pp1fech
        from fsd602
       where pgcod = vi_pgcod
         and ppmod = vi_aomod --and ppsuc = vi_aosuc 
         and ppmda = vi_aomda
         and pppap = vi_aopap
         and ppcta = vi_aocta
         and ppoper = vi_aooper
         and ppsbop = vi_aosbop
         and pptope = vi_aotope
         and pp1stat = 'T'
         and d602co = 'S'
         and ppfpag <= vi_ppfpag
         and ROWNUM <= 5
       order by ppfpag desc;  
  
  BEGIN
    ln_dias_atraso := 0;
    ln_suma_dias   := 0;
    ln_cnt601      := 0;
    PQ_CR_REPROG_DESASTRE_NATURAL.sp_cr_codigo_credito(ve_instancia => ve_instancia,
                                                       vo_pgcod     => vi_pgcod,
                                                       vo_aomod     => vi_aomod,
                                                       vo_aosuc     => vi_aosuc,
                                                       vo_aomda     => vi_aomda,
                                                       vo_aopap     => vi_aopap,
                                                       vo_aocta     => vi_aocta,
                                                       vo_aooper    => vi_aooper,
                                                       vo_aosbop    => vi_aosbop,
                                                       vo_aotope    => vi_aotope,
                                                       vo_rpta      => vi_rpta);
  
    if vi_rpta = 'N' then
      DBMS_OUTPUT.put_line('No existe la instancia');
      vo_rpta := 0;
      return;
    end if;
  
    --apachecoh 2023.04.27
    --Validar diferentes tipos de modulos/operaciones
    /*begin
      select count(*)
        into ln_flag
        from fst198
       where tp1cod1 = 11169
         and tp1corr1 = 10
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_aomod;
    exception
      when others then
        ln_flag := 0;
    end;
    if ln_flag = 0 then
      begin
        select count(*)
          into ln_flag
          from fst198
         where tp1cod1 = 11169
           and tp1corr1 = 10
           and tp1corr2 = 2
           and tp1corr3 > 0
           and tp1nro1 = vi_aomod
           and tp1nro2 = vi_aotope;
      exception
        when others then
          ln_flag := 0;
      end;
    end if;*/
    --Obtener fecha de ultimo pago
    begin      
      select nvl(max(ppfpag), to_date('01/01/1900', 'dd/mm/rrrr'))
        into ld_ult_fecpag
        from fsd602
       where pgcod = vi_pgcod
         and ppmod = vi_aomod --and ppsuc = vi_aosuc 
         and ppmda = vi_aomda
         and pppap = vi_aopap
         and ppcta = vi_aocta
         and ppoper = vi_aooper
         and ppsbop = vi_aosbop
         and pptope = vi_aotope
         and pp1stat = 'T'
         and d602co = 'S';
    exception
      when others then
        ld_ult_fecpag := to_date('01/01/1900', 'dd/mm/rrrr');
    end;
    --Fecha de siguiente pago 
    begin      
      select count(*)
        into ln_cnt601
        from fsd601
       where pgcod = vi_pgcod
         and ppmod = vi_aomod --and ppsuc = vi_aosuc 
         and ppmda = vi_aomda
         and pppap = vi_aopap
         and ppcta = vi_aocta
         and ppoper = vi_aooper
         and ppsbop = vi_aosbop
         and pptope = vi_aotope
         and ppfpag > ld_ult_fecpag
         and pptipo = 'M';    
      if ln_cnt601 > 0 then
        select min(ppfpag)
          into ld_sig_fecpag
          from fsd601
         where pgcod = vi_pgcod
           and ppmod = vi_aomod --and ppsuc = vi_aosuc 
           and ppmda = vi_aomda
           and pppap = vi_aopap
           and ppcta = vi_aocta
           and ppoper = vi_aooper
           and ppsbop = vi_aosbop
           and pptope = vi_aotope
           and ppfpag > ld_ult_fecpag
           and pptipo = 'M';        
      /*else
        select pp1fech
         into ld_sig_fecpag
         from fsd602
        where pgcod = vi_pgcod
          and ppmod = vi_aomod --and ppsuc = vi_aosuc 
          and ppmda = vi_aomda
          and pppap = vi_aopap
          and ppcta = vi_aocta
          and ppoper = vi_aooper
          and ppsbop = vi_aosbop
          and pptope = vi_aotope
          and ppfpag = ld_ult_fecpag;*/
      end if;
    exception
      when others then
        --DBMS_OUTPUT.put_line('No existe cronograma de pagos');
        vo_rpta := 0;
        return;
    end;
   --Fecha del sistema
    begin
      select pgfape into ld_pgfape from fst017 where pgcod = 1;
    end;
    begin
      --Calcular dias de atraso      
     if ln_cnt601 > 0 then
              select ld_pgfape - ld_sig_fecpag 
                     into ln_dias_atraso 
              from dual;
     else    
        ln_dias_atraso := 0;       
      end if;
    exception
      when others then
        --DBMS_OUTPUT.put_line('No resta las fechas');
        vo_rpta := 0;
        return;
    end;
    if ln_dias_atraso < 0 then
      ln_dias_atraso := 0;
    end if;
    ln_suma_dias := ln_suma_dias + ln_dias_atraso;
  
    ln_count := 1;
  
    begin
      --Acumular los dias de atraso de la ultimas 5 cuotas adicionales
      for e in cronograma_pago_t(vi_pgcod,
                                 vi_aomod,
                                 vi_aosuc,
                                 vi_aomda,
                                 vi_aopap,
                                 vi_aocta,
                                 vi_aooper,
                                 vi_aosbop,
                                 vi_aotope,
                                 ld_ult_fecpag) loop
        begin
          select e.pp1fech - e.ppfpag into ln_dias_atraso from dual;
          ln_count := ln_count + 1;
        exception
          when others then
            ln_dias_atraso := 0;
        end;
        
        if ln_dias_atraso < 0 then
          ln_dias_atraso := 0;
        end if;
        
        ln_suma_dias := ln_suma_dias + ln_dias_atraso;
      end loop;      
    end;
    vo_rpta := round(ln_suma_dias / ln_count, 2);
  END;

  procedure sp_cr_calif100_rcc(ve_instancia in int, vo_rpta out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_calif100_rcc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.03
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Devuelve si el cliente tiene RCC 100% normal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( n° Dias )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************  
    vi_pgcod  xwf700.xwfempresa%type;
    vi_aomod  xwf700.xwfmodulo%type;
    vi_aosuc  xwf700.xwfsucursal%type;
    vi_aomda  xwf700.xwfmoneda%type;
    vi_aopap  xwf700.xwfpapel%type;
    vi_aocta  xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
  
    lv_document VARCHAR2(15);
    ln_calif0   NUMBER(7, 2);
    ln_calif1   NUMBER(7, 2);
    ln_calif2   NUMBER(7, 2);
    ln_calif3   NUMBER(7, 2);
    ln_calif4   NUMBER(7, 2);
    ld_fech_rcc DATE;
  
    vi_rpta VARCHAR2(1);
  
  BEGIN
    PQ_CR_REPROG_DESASTRE_NATURAL.sp_cr_codigo_credito(ve_instancia => ve_instancia,
                                                       vo_pgcod     => vi_pgcod,
                                                       vo_aomod     => vi_aomod,
                                                       vo_aosuc     => vi_aosuc,
                                                       vo_aomda     => vi_aomda,
                                                       vo_aopap     => vi_aopap,
                                                       vo_aocta     => vi_aocta,
                                                       vo_aooper    => vi_aooper,
                                                       vo_aosbop    => vi_aosbop,
                                                       vo_aotope    => vi_aotope,
                                                       vo_rpta      => vi_rpta);
  
    if vi_rpta = 'N' then
      DBMS_OUTPUT.put_line('No existe la instancia');
      vo_rpta := 'S';
      return;
    end if;
  
    begin
      --fecha de ultimo rcc
      select to_date(tpnro, 'ddmmyyyy')
        into ld_fech_rcc
        from fst098
       where tpcod = 7647
         and tpcorr = 12;
    exception
      when others then
        vo_rpta := 'S';
    end;
  
    begin
      --obtener documento
      select trim(sng001ndoc)
        into lv_document
        from sng001
       where sng001inst = ve_instancia;
    exception
      when others then
        vo_rpta := 'S';
        return;
    end;
  
    begin
      --obtener calificacion rcc
      select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4
        into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
        from cldrcci
       where c_tipreg = '1'
         and c_tipdet = 'Z'
         and d_fecpre = ld_fech_rcc
         and c_docide = lv_document;
    exception
      when others then
        vo_rpta := 'S';
        return;
    end;
  
    --validación
    if (ln_calif0 > 0 and ln_calif0 < 100) or
       (ln_calif1 > 0 and ln_calif1 < 100) or
       (ln_calif2 > 0 and ln_calif2 < 100) or
       (ln_calif3 > 0 and ln_calif3 < 100) or
       (ln_calif4 > 0 and ln_calif4 < 100) then
      vo_rpta := 'N';
    else
      vo_rpta := 'S';
    end if;
  
  END;

  -- *****************************************************************
  -- Nombre                     : SP_CR_MNT_AQPB252
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 14/03/2022
  -- Autor de Creación          : Maycol Chavez Chuman 
  -- Uso                        : Mantenedor AQPB252
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_EMP, P_MOD, P_SUC, P_MDA, P_PAP
  --                              P_CTA, P_OPER, P_SBOP, P_TOP, P_FINI
  --                              P_FFIN, P_EST, P_IND, P_MODO, P_AUX1
  -- Parámetros de Salida       : P_AUX2, P_CODERR, P_MSGERR
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- *****************************************************************  

  PROCEDURE SP_CR_MNT_AQPB252(P_EMP    IN NUMBER,
                              P_MOD    IN NUMBER,
                              P_SUC    IN NUMBER,
                              P_MDA    IN NUMBER,
                              P_PAP    IN NUMBER,
                              P_CTA    IN NUMBER,
                              P_OPER   IN NUMBER,
                              P_SBOP   IN NUMBER,
                              P_TOP    IN NUMBER,
                              P_FINI   IN DATE,
                              P_FFIN   IN DATE,
                              P_EST    IN VARCHAR2,
                              P_IND    IN VARCHAR2,
                              P_MODO   IN VARCHAR2,
                              P_AUX1   IN VARCHAR2,
                              P_AUX2   OUT VARCHAR2,
                              P_CODERR OUT VARCHAR2,
                              P_MSGERR OUT VARCHAR2) AS
    V_FLAG  VARCHAR2(1);
    V_FECHA DATE;
    V_FINI  DATE;
  BEGIN
    IF P_MODO IS NOT NULL THEN
      IF P_EMP IS NOT NULL AND P_MOD IS NOT NULL AND P_SUC IS NOT NULL AND
         P_MDA IS NOT NULL AND P_PAP IS NOT NULL AND P_CTA IS NOT NULL AND
         P_OPER IS NOT NULL AND P_SBOP IS NOT NULL AND P_TOP IS NOT NULL THEN
        -------------------------------
        SELECT MAX(PPFPAG)
          INTO V_FECHA
          FROM FSD602
         WHERE PGCOD = P_EMP
           AND PPMOD = P_MOD
           AND PPSUC = P_SUC
           AND PPMDA = P_MDA
           AND PPPAP = P_PAP
           AND PPCTA = P_CTA
           AND PPOPER = P_OPER
           AND PPSBOP = P_SBOP
           AND PPTOPE = P_TOP
           AND PP1STAT = 'T'
           AND D602CO = 'S';
      
        IF V_FECHA IS NOT NULL THEN
          SELECT MIN(PPFPAG)
            INTO V_FINI
            FROM FSD601
           WHERE PGCOD = P_EMP
             AND PPMOD = P_MOD
             AND PPSUC = P_SUC
             AND PPMDA = P_MDA
             AND PPPAP = P_PAP
             AND PPCTA = P_CTA
             AND PPOPER = P_OPER
             AND PPSBOP = P_SBOP
             AND PPTOPE = P_TOP
             AND PPFPAG > V_FECHA;
        ELSE
          SELECT MIN(PPFPAG)
            INTO V_FINI
            FROM FSD601
           WHERE PGCOD = P_EMP
             AND PPMOD = P_MOD
             AND PPSUC = P_SUC
             AND PPMDA = P_MDA
             AND PPPAP = P_PAP
             AND PPCTA = P_CTA
             AND PPOPER = P_OPER
             AND PPSBOP = P_SBOP
             AND PPTOPE = P_TOP;
        END IF;
        -------------------------------         
        CASE P_MODO
          WHEN 'INS' THEN
            BEGIN
              SELECT DISTINCT 'S'
                INTO V_FLAG
                FROM AQPB252
               WHERE AQPB252EMP = P_EMP
                 AND AQPB252MOD = P_MOD
                 AND AQPB252SUC = P_SUC
                 AND AQPB252MDA = P_MDA
                 AND AQPB252PAP = P_PAP
                 AND AQPB252CTA = P_CTA
                 AND AQPB252OPER = P_OPER
                 AND AQPB252SBOP = P_SBOP
                 AND AQPB252TOP = P_TOP;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_FLAG := 'N';
            END;
            IF V_FLAG = 'N' THEN
              IF (P_EMP > 0 AND P_EMP <= 999) AND
                 (P_MOD > 0 AND P_MOD <= 999) AND
                 (P_MDA >= 0 AND P_MDA <= 9999) AND
                 (P_PAP >= 0 AND P_PAP <= 9999) AND
                 (P_CTA > 0 AND P_CTA <= 999999999) AND
                 (P_OPER > 0 AND P_OPER <= 999999999) AND
                 (P_SBOP >= 0 AND P_SBOP <= 999) AND
                 (P_TOP >= 0 AND P_TOP <= 999) THEN
                INSERT INTO AQPB252
                  (AQPB252EMP,
                   AQPB252MOD,
                   AQPB252SUC,
                   AQPB252MDA,
                   AQPB252PAP,
                   AQPB252CTA,
                   AQPB252OPER,
                   AQPB252SBOP,
                   AQPB252TOP,
                   AQPB252FINI,
                   AQPB252FFIN,
                   AQPB252EST,
                   AQPB252IND)
                VALUES
                  (P_EMP,
                   P_MOD,
                   P_SUC,
                   P_MDA,
                   P_PAP,
                   P_CTA,
                   P_OPER,
                   P_SBOP,
                   P_TOP,
                   V_FINI,
                   P_FFIN,
                   P_EST,
                   P_IND);
                P_CODERR := '000';
                P_MSGERR := 'AQPB252-INS SE REGISTRO CORRECTAMENTE';
                COMMIT;
              ELSE
                P_CODERR := '005';
                P_MSGERR := 'AQPB252-INS DESBORDAMIENTO DE VARIABLES DEL CREDITO';
              END IF;
            ELSE
              P_CODERR := '004';
              P_MSGERR := 'AQPB252-INS EL REGISTRO YA EXISTE';
            END IF;
          WHEN 'UPD' THEN
            BEGIN
              SELECT DISTINCT 'S'
                INTO V_FLAG
                FROM AQPB252
               WHERE AQPB252EMP = P_EMP
                 AND AQPB252MOD = P_MOD
                 AND AQPB252SUC = P_SUC
                 AND AQPB252MDA = P_MDA
                 AND AQPB252PAP = P_PAP
                 AND AQPB252CTA = P_CTA
                 AND AQPB252OPER = P_OPER
                 AND AQPB252SBOP = P_SBOP
                 AND AQPB252TOP = P_TOP
                 AND AQPB252FINI = V_FINI
                 AND AQPB252FFIN = P_FFIN;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_FLAG := 'N';
            END;
            IF V_FLAG = 'S' THEN
              IF P_EST <> ' ' THEN
                UPDATE AQPB252
                   SET AQPB252EST = P_EST, AQPB252IND = P_IND
                 WHERE AQPB252EMP = P_EMP
                   AND AQPB252MOD = P_MOD
                   AND AQPB252SUC = P_SUC
                   AND AQPB252MDA = P_MDA
                   AND AQPB252PAP = P_PAP
                   AND AQPB252CTA = P_CTA
                   AND AQPB252OPER = P_OPER
                   AND AQPB252SBOP = P_SBOP
                   AND AQPB252TOP = P_TOP
                   AND AQPB252FINI = V_FINI
                   AND AQPB252FFIN = P_FFIN;
                P_CODERR := 000;
                P_MSGERR := 'AQPB252-UPD SE ACTUALIZO CORRECTAMENTE';
                COMMIT;
              ELSE
                P_CODERR := 007;
                P_MSGERR := 'AQPB252-UPD PARAMETROS NULOS';
              END IF;
            ELSE
              P_CODERR := 006;
              P_MSGERR := 'AQPB252-UPD EL REGISTRO NO EXISTE';
            END IF;
          ELSE
            P_CODERR := 003;
            P_MSGERR := 'AQPB252 EL MODO INGRESADO ES INCORRECTO';
        END CASE;
      ELSE
        P_CODERR := '002';
        P_MSGERR := 'AQPB252 PARAMETROS DEL CREDITO NULOS';
      END IF;
    ELSE
      P_CODERR := '001';
      P_MSGERR := 'AQPB252 DEBE INGRESAR MODO';
    END IF;
  END;

  -- *****************************************************************
  -- Nombre                     : SP_CR_MNT_AQPC205
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 14/03/2022
  -- Autor de Creación          : Maycol Chavez Chuman 
  -- Uso                        : LOG de la tabla AQPC205
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_EMP, P_MOD, P_SUC, P_MDA, P_PAP
  --                              P_CTA, P_OPER, P_SBOP, P_TOP, P_FINI
  --                              P_MSGERR, P_MORA_PENAL, P_FCH_REG
  --                              P_HOR_REG, P_USU_REG
  -- Parámetros de Salida       : P_AUX2, P_CODERR, P_MSGERR
  -- Fecha de Modificación      : --
  -- Autor de la Modificación   : --
  -- Descripción de Modificación: --
  -- ***************************************************************** 

  PROCEDURE SP_CR_MNT_AQPC205(P_EMP        IN NUMBER,
                              P_MOD        IN NUMBER,
                              P_SUC        IN NUMBER,
                              P_MDA        IN NUMBER,
                              P_PAP        IN NUMBER,
                              P_CTA        IN NUMBER,
                              P_OPER       IN NUMBER,
                              P_SBOP       IN NUMBER,
                              P_TOP        IN NUMBER,
                              P_MSGERR     IN VARCHAR2,
                              P_MORA_PENAL IN VARCHAR2,
                              P_FCH_REG    IN DATE,
                              P_HOR_REG    IN VARCHAR2,
                              P_USU_REG    IN VARCHAR2) AS
  BEGIN
    INSERT INTO AQPC205
      (AQPC205EMP,
       AQPC205MOD,
       AQPC205SUC,
       AQPC205MDA,
       AQPC205PAP,
       AQPC205CTA,
       AQPC205OPE,
       AQPC205SBO,
       AQPC205TOP,
       AQPC205DES,
       AQPC205EXN,
       AQPC205FEC,
       AQPC205HOR,
       AQPC205USU)
    VALUES
      (P_EMP,
       P_MOD,
       P_SUC,
       P_MDA,
       P_PAP,
       P_CTA,
       P_OPER,
       P_SBOP,
       P_TOP,
       P_MSGERR,
       P_MORA_PENAL,
       P_FCH_REG,
       P_HOR_REG,
       P_USU_REG);
    COMMIT;
  END;

end PQ_CR_REPROG_DESASTRE_NATURAL;
/

