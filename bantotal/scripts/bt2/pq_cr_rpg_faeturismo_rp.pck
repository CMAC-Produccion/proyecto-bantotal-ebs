create or replace package PQ_CR_RPG_FAETURISMO_RP is

  -- Author  : APACHECOH
  -- Created : 15/03/2023 17:43:46
  -- Purpose : 
  procedure sp_cr_clave_credito(ve_instancia in int,
                                vo_pgcod     out xwf700.xwfempresa%type,
                                vo_aomod     out xwf700.xwfmodulo%type,
                                vo_aosuc     out xwf700.xwfsucursal%type,
                                vo_aomda     out xwf700.xwfmoneda%type,
                                vo_aopap     out xwf700.xwfpapel%type,
                                vo_aocta     out xwf700.xwfcuenta%type,
                                vo_aooper    out xwf700.xwfoperacion%type,
                                vo_aosbop    out xwf700.xwfsubope%type,
                                vo_aotope    out xwf700.xwftipope%type,
                                vo_rpta      out varchar2);

  procedure sp_cr_faeturismo_capitalinteres(vi_instancia in number,
                                            vo_respuesta out varchar2);

end PQ_CR_RPG_FAETURISMO_RP;
/

create or replace package body PQ_CR_RPG_FAETURISMO_RP is

  procedure sp_cr_clave_credito(ve_instancia in int,
                                vo_pgcod     out xwf700.xwfempresa%type,
                                vo_aomod     out xwf700.xwfmodulo%type,
                                vo_aosuc     out xwf700.xwfsucursal%type,
                                vo_aomda     out xwf700.xwfmoneda%type,
                                vo_aopap     out xwf700.xwfpapel%type,
                                vo_aocta     out xwf700.xwfcuenta%type,
                                vo_aooper    out xwf700.xwfoperacion%type,
                                vo_aosbop    out xwf700.xwfsubope%type,
                                vo_aotope    out xwf700.xwftipope%type,
                                vo_rpta      out varchar2) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.20
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Hallar la clave del crédito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( Resultado S/N )    
    --                              vo_pgcod ( Codigo Empresa )
    --                              vo_aomod ( Modulo )
    --                              vo_aosuc ( Sucursal )
    --                              vo_aomda ( Moneda )
    --                              vo_aopap ( Papel )
    --                              vo_aocta ( Cuenta )
    --                              vo_aooper ( Operacion )
    --                              vo_aosbop ( Sub Operacion )
    --                              vo_aotope ( Tipo Operacion )
    -- ******************************************************************
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
      vo_rpta := 'S';
    EXCEPTION
      when others then
        vo_rpta := 'N';
    END;
  END;

  procedure sp_cr_faeturismo_capitalinteres(vi_instancia in number,
                                            vo_respuesta out varchar2) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.15
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor para verificar que la nueva reprogramación tenga la misma cantidad de cuotas y el capital/interes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_instancia ( Instancia )
    -- Parámetros de Salida       : vo_respuesta ( Respuesta )      
    -- ******************************************************************
    pn_cod  xwf700.xwfempresa%type;
    pn_mod  xwf700.xwfmodulo%type;
    pn_suc  xwf700.xwfsucursal%type;
    pn_mda  xwf700.xwfmoneda%type;
    pn_pap  xwf700.xwfpapel%type;
    pn_cta  xwf700.xwfcuenta%type;
    pn_oper xwf700.xwfoperacion%type;
    pn_sbop xwf700.xwfsubope%type;
    pn_tope xwf700.xwftipope%type;
    pv_rpta varchar2(2);
  
    ln_pais number(5);
    ln_tdoc number(5);
    lv_ndoc varchar2(12);
  
    ld_fpag   date;
    ln_cuot_0 number(5);
    ln_cuot_1 number(5);
    ln_cuot_2 number(5);
  
  begin
  
    begin
      PQ_CR_RPG_FAETURISMO_RP.sp_cr_clave_credito(vi_instancia,
                                                  vo_pgcod     => pn_cod,
                                                  vo_aomod     => pn_mod,
                                                  vo_aosuc     => pn_suc,
                                                  vo_aomda     => pn_mda,
                                                  vo_aopap     => pn_pap,
                                                  vo_aocta     => pn_cta,
                                                  vo_aooper    => pn_oper,
                                                  vo_aosbop    => pn_sbop,
                                                  vo_aotope    => pn_tope,
                                                  vo_rpta      => pv_rpta);
    
    exception
      when others then
        vo_respuesta := 'S';
    end;
    /*begin
      select max(ppfpag)
        into ld_fpag
        from fsd602 a
       where a.pgcod = pn_cod
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = (pn_sbop - 1)
         and a.pptope = pn_tope
         and a.d602co = 'S';
    exception
      when others then
        ld_fpag := null;
    end;
  
    if ld_fpag is null then
      begin
        select min(ppfpag)
          into ld_fpag
          from fsd601 a
         where a.pgcod = pn_cod
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_oper
           and a.ppsbop = (pn_sbop - 1)
           and a.pptope = pn_tope;
      
      exception
        when others then
          ld_fpag := null;
      end;
    end if;*/
    --Validamos el # de cuotas para la suboperación nueva y la antigua    
    begin
      select count(*)
        into ln_cuot_0
        from fsd601 a
       where a.pgcod = pn_cod
         and a.ppmod = pn_mod
         --and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = (pn_sbop - 1)
         and a.pptope = pn_tope;
    exception
      when others then
        ln_cuot_0 := 0;
    end;
    begin
      select count(*)
        into ln_cuot_1
        from fsd601 a
       where a.pgcod = pn_cod
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = pn_sbop
         and a.pptope = pn_tope
         and a.ppcap > 0
         and a.ppint > 0;
    exception
      when others then
        ln_cuot_1 := 0;
    end; 
    begin
      select count(*)
        into ln_cuot_2
        from fsd602 a
       where a.pgcod = pn_cod
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = (pn_sbop - 1)
         and a.pptope = pn_tope
         and a.pp1stat = 'T'
         and a.d602co = 'S';   
    exception
      when others then
        ln_cuot_2 := 0;
    end;       
    --Existe diferencia
    if (ln_cuot_0 - ln_cuot_2) <> ln_cuot_1 then
      vo_respuesta := 'N';
    else
      vo_respuesta := 'S';
    end if;
  end sp_cr_faeturismo_capitalinteres;

end PQ_CR_RPG_FAETURISMO_RP;
/

