create or replace package PQ_CR_VALID_RNG_RPG_SCRM is

  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_VALID_RNG_RPG_SCRM
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Activas
     -- Descripción                : Paquete de reglas sin crm 94 y 95 
     -- Versión                    : 1.0
     -- Fecha de Creación          : 20/09/2024
     -- Autor de Creación          : HSUAREZ
     -- Estado                     : Activo
     -- Acceso                     : Público  
     -- Fecha de Modificacion      : 30/09/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se ajusto regla 5, para obtener correctamente fecha de reprogamacion
     -- Fecha de Modificacion      : 01/10/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se volvió ajustar regla 5, el where anterior se agrego para filtrar correctamente Nro reprogramaciones
     -- Fecha de Modificacion      : 24/10/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se agrego tabla fsd010 para corregir filtrado de ultima fecha de reprogramacion
  * *************************************************************************************************************/

  procedure sp_cr_repro_credito_01(INSTANCIA  in number,
                                   USUARIO    in varchar2,
                                   RPTA_FINAL out varchar2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2);

  procedure sp_rng_reprogsincapit_G2(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2);

  PROCEDURE SP_CR_REPROG_GRUPO_3(P_INSTANCIA IN NUMBER,
                                 P_USUARIO   IN VARCHAR2,
                                 P_RESPUESTA OUT VARCHAR2,
                                 P_COD_ERROR OUT VARCHAR2,
                                 P_MENSAJE   OUT VARCHAR2);
  PROCEDURE SP_CR_CLIENTE_REPROG_4(P_INSTANCIA IN NUMBER,
                                   P_USUARIO   IN VARCHAR2,
                                   P_RESPUESTA OUT VARCHAR2,
                                   P_COD_ERROR OUT VARCHAR2,
                                   P_MENSAJE   OUT VARCHAR2);
  procedure SP_CR_CLIENTE_REPROG_05(p_ins         in number,
                                    p_usuario     in varchar2,
                                    p_c_respuesta out varchar2,
                                    p_c_coderr    out varchar2,
                                    p_c_deserr    out varchar2);
  procedure sp_rng_reprogsincapit_G6(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2);
  procedure sp_cr_reprog_condicion_007(instancia in number,
                                       usuario   in varchar2,
                                       rpt       out varchar2,
                                       coderr    out varchar2,
                                       msgerr    out varchar2);
  procedure sp_rng_reprogsincapit_G8(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2);

  procedure sp_cr_reprog_condicion_09(instancia in number,
                                      usuario   in varchar2,
                                      rpt       out varchar2,
                                      coderr    out varchar2,
                                      msgerr    out varchar2);

  PROCEDURE SP_RNG_REPROGSINCAPIT_G10(Ln_Instancia number,
                                      Usuario      varchar2,
                                      flgRpta      out varchar2,
                                      CodError     out varchar2,
                                      Mensaje      out varchar2);

  procedure sp_rng_reprogsincapit_G11(ln_Instancia number,
                                      Usuario      varchar2,
                                      flgRpta      out varchar2,
                                      CodError     out varchar2,
                                      Mensaje      out varchar2);
  
  procedure sp_cr_repg_cantcuopag(ln_instancia number,
                                  cantCuoPag   OUT number);
  PROCEDURE SP_CR_VALIDAR_OPINION_G12 (
                                        VEI_N_INSTANCE IN NUMBER,
                                        VEI_V_UBUSER   IN VARCHAR2,
                                        VEO_V_RPTA     OUT VARCHAR2,
                                        VEO_V_CODERROR OUT VARCHAR2,
                                        VEO_V_MSGERROR OUT VARCHAR2    
                                       );
  PROCEDURE SP_CR_OBTENER_REFINAN_G13(
                                      VEI_N_INSTANCE IN NUMBER,
                                      VEI_V_UBUSER   IN VARCHAR2,
                                      VEO_V_RPTA     OUT VARCHAR2,
                                      VEO_V_CODERROR OUT VARCHAR2,
                                      VEO_V_MSGERROR OUT VARCHAR2  
                                     );
end PQ_CR_VALID_RNG_RPG_SCRM;
/

create or replace package body PQ_CR_VALID_RNG_RPG_SCRM is
  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_VALID_RNG_RPG_SCRM
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Activas
     -- Descripción                : Paquete de reglas sin crm 94 y 95 
     -- Versión                    : 1.0
     -- Fecha de Creación          : 20/09/2024
     -- Autor de Creación          : HSUAREZ
     -- Estado                     : Activo
     -- Acceso                     : Público  
     -- Fecha de Modificacion      : 30/09/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se ajusto regla 5 para obtener correctamente fecha de reprogamacion
     -- Fecha de Modificacion      : 01/10/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se volvió ajustar regla 5, el where anterior se agrego para filtrar correctamente Nro reprogramaciones
     -- Fecha de Modificacion      : 24/10/2024
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion de Modificacion: Se agrego tabla fsd010 para corregir filtrado de ultima fecha de reprogramacion
  * *************************************************************************************************************/

  procedure sp_cr_repro_credito_01(INSTANCIA  in number,
                                   USUARIO    in varchar2,
                                   RPTA_FINAL out varchar2,
                                   COD_ERROR  out varchar2,
                                   MSG_SALIDA out varchar2) is
  
    RPTA_1    varchar2(1);
    RPTA_2    varchar2(1);
    RPTA_3    varchar2(1) := 'N';
    vi_cuenta number(9);
    vi_pais   number(3);
    vi_tdoc   number(2);
    vi_ndoc   char(12);
    vi_fape   date;
  
  begin
  
    begin
      select A.XWFCUENTA
        into vi_cuenta
        from xwf700 A
       where A.XWFPRCINS = INSTANCIA
         and a.xwfcar3 = '1';
    exception
      when others then
        COD_ERROR  := '001';
        MSG_SALIDA := 'Error en la cuenta';
    end;
  
    begin
      select B.PEPAIS, B.PETDOC, B.PENDOC
        INTO vi_pais, vi_tdoc, vi_ndoc
        from fsr008 B
       where B.CTNRO = vi_cuenta
         and b.ttcod = 1
         and b.cttfir = 'T';
    exception
      when others then
        COD_ERROR  := '002';
        MSG_SALIDA := 'Error en la clave';
    end;
  
    begin
      select pgfape into vi_fape from fst017 where pgcod = 1;
    exception
      when others then
        COD_ERROR  := '003';
        MSG_SALIDA := 'Error en fecha del sistema';
    end;
  
    begin
    
      PQ_CR_RN_REPROGRAMADOS.sp_cr_resolutorA(ln_ins     => instancia,
                                              lc_var     => RPTA_1,
                                              lc_cod_err => COD_ERROR,
                                              lc_msg_err => MSG_SALIDA);
    
      PQ_CR_REPROGRAMACIONES_RPC.sp_cr_resolutorG(ln_Pepais => vi_pais,
                                                  ln_Petdoc => vi_tdoc,
                                                  ln_Pendoc => vi_ndoc,
                                                  ld_FchPrc => vi_fape,
                                                  lc_flag   => RPTA_2);
    
    exception
      when others then
        COD_ERROR  := '004';
        MSG_SALIDA := 'Error en paquete';
    end;
  
    begin
      if RPTA_1 = 'S' and RPTA_2 = 'S' and RPTA_3 = 'S' then
        RPTA_FINAL := 'S';
        MSG_SALIDA := 'Cliente con crédito en mora.';
      else
        RPTA_FINAL := 'N';
        MSG_SALIDA := '';
      end if;
    
    exception
      when others then
        COD_ERROR  := '005';
        MSG_SALIDA := 'Error';
    end;
  
  end sp_cr_repro_credito_01;

  procedure sp_rng_reprogsincapit_G2(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2) is
  
    ln_NroCuoPagRepr number(10);
  
    ln_pgcod     number;
    ln_sucursal  number;
    ln_modulo    number;
    ln_moneda    number;
    ln_papel     number;
    ln_cuenta    number;
    ln_operacion number;
    ln_subopera  number;
    ln_tipopera  number;
  
  begin
  
    begin
      select w.xwfempresa,
             w.xwfsucursal,
             w.xwfmodulo,
             w.xwfmoneda,
             w.xwfpapel,
             w.xwfcuenta,
             w.xwfoperacion,
             w.xwfsubope,
             w.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 w
       where w.xwfprcins = ln_Instancia
         and w.xwfcar3 = 1; --<> '1';
    exception
      when others then
        ln_pgcod     := 0;
        ln_sucursal  := 0;
        ln_modulo    := 0;
        ln_moneda    := 0;
        ln_papel     := 0;
        ln_cuenta    := 0;
        ln_operacion := 0;
        ln_subopera  := 0;
        ln_tipopera  := 0;
    end;
  
    begin
      /* pQ_CR_REPROGRAMACIONES.sp_cr_NroCuotPagRep(ln_Instancia,
      ln_NroCuoPagRepr);*/
      PQ_CR_VALID_RNG_RPG_SCRM.sp_cr_repg_cantcuopag(ln_Instancia,
                                                     ln_NroCuoPagRepr);
    exception
      when others then
        null;
    end;
    ln_NroCuoPagRepr := NVL(ln_NroCuoPagRepr, 0);
  
    IF ln_NroCuoPagRepr = 0 AND ln_modulo = 101 AND
       ln_tipopera IN (353, 355) THEN
      CodError := '00001';
      flgRpta  := 'S';
      Mensaje  := 'Cliente no ha cancelado al menos una cuota de su financiamiento';
    ELSE
      CodError := '00000';
      flgRpta  := 'N';
      Mensaje  := '';
    END IF;
  
  end sp_rng_reprogsincapit_G2;

  PROCEDURE SP_CR_REPROG_GRUPO_3(P_INSTANCIA IN NUMBER,
                                 P_USUARIO   IN VARCHAR2,
                                 P_RESPUESTA OUT VARCHAR2,
                                 P_COD_ERROR OUT VARCHAR2,
                                 P_MENSAJE   OUT VARCHAR2) IS
    V_NROCUOPAG NUMBER(17);
  
    vi_pgcod  number;
    vi_aomod  number;
    vi_aosuc  number;
    vi_aomda  number;
    vi_aopap  number;
    vi_aocta  number;
    vi_aooper number;
    vi_aosbop number;
    vi_aotope number;
  
    CantPago number(5);
  BEGIN
    BEGIN
      /* PQ_CR_REPROGRAMACIONES.SP_CR_NROCUOTPAGREP(LN_INSTANCIA     => P_INSTANCIA,
      LN_NROCUOPAGREPR => V_NROCUOPAG);*/
    
      PQ_CR_VALID_RNG_RPG_SCRM.sp_cr_repg_cantcuopag(P_INSTANCIA,
                                                     V_NROCUOPAG);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF V_NROCUOPAG = 0 THEN
      P_COD_ERROR := '00001';
      P_RESPUESTA := 'S'; -- BLOQUEA
      P_MENSAJE   := 'Cliente no ha cancelado al menos una cuota de su financiamiento';
    ELSE
      P_COD_ERROR := '00000';
      P_RESPUESTA := 'N'; -- NO BLOQUEA
      P_MENSAJE   := '';
    END IF;
  END SP_CR_REPROG_GRUPO_3;

  PROCEDURE SP_CR_CLIENTE_REPROG_4(P_INSTANCIA IN NUMBER,
                                   P_USUARIO   IN VARCHAR2,
                                   P_RESPUESTA OUT VARCHAR2,
                                   P_COD_ERROR OUT VARCHAR2,
                                   P_MENSAJE   OUT VARCHAR2) IS
  BEGIN
    BEGIN
      PQ_CR_REPROG_SIN_CAPT.SP_CR_NRO_REPROGRAMADOS(P_INSTANCIA => P_INSTANCIA,
                                                    P_RESPUESTA => P_RESPUESTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF P_RESPUESTA = 'S' THEN
      P_MENSAJE := 'Cliente con crédito en mora.';
    ELSE
      P_MENSAJE := '';
    END IF;
  END;

  procedure SP_CR_CLIENTE_REPROG_05(p_ins         in number,
                                    p_usuario     in varchar2,
                                    p_c_respuesta out varchar2,
                                    p_c_coderr    out varchar2,
                                    p_c_deserr    out varchar2) is
  
    ln_NRO_REPROG       number;
    ln_NRO_CUOTAS_PAG   number;
    LN_FECHA_ULT_REPROG DATE;
  begin  
    p_c_respuesta     := 'N';
    p_c_coderr        := '000';
    p_c_deserr        := '';
    ln_NRO_REPROG     := 0;
    ln_NRO_CUOTAS_PAG := 0;
  
    begin
      BEGIN
        select MAX(FECHA)
          into LN_FECHA_ULT_REPROG
          from (select jaqa400fec FECHA
                  from jaqa400
                 where jaqa400ai1 = p_ins
                   and jaqa400est = 'C'
                union all
                select jaqz698fep FECHA
                  from jaqz698 j, xwf700 x
                 where j.jaqz698emp = x.xwfempresa
                   and j.jaqz698mod = x.xwfmodulo
                   and j.jaqz698suc = x.xwfsucursal
                   and j.jaqz698mda = x.xwfmoneda
                   and j.jaqz698pap = x.xwfpapel
                   and j.jaqz698cta = x.xwfcuenta
                   and j.jaqz698ope = x.xwfoperacion
                   and j.jaqz698sbo = x.xwfsubope
                   and j.jaqz698top = x.xwftipope
                   and x.xwfprcins = p_ins
                   and xwfcar3 = '1'
                   and j.jaqz698est = 'C'
                union all         
                   select z.aofval FECHA
                from xwf700 x, sng001 s, fsd010 z 
               where s.sng001inst = x.xwfprcins
                 and xwfprcins = p_ins
                 and xwfcar3 = '1'    
                 and z.pgcod = x.xwfempresa
                 and z.aomod = x.xwfmodulo
                 and z.aosuc = x.xwfsucursal
                 and z.aomda = x.xwfmoneda
                 and z.aopap = x.xwfpapel
                 and z.aocta = x.xwfcuenta
                 and z.aooper = x.xwfoperacion
                 and z.aosbop = x.xwfsubope
                 and z.aotope = x.xwftipope
                 and s.sng001ori in ( SELECT a.tp1nro1 
                                      FROM FST198 a 
                                      WHERE a.tp1cod = 1 and a.tp1cod1 = 11177 and a.tp1corr1 = 1 and 
                                      a.tp1corr2 = 1 and a.tp1nro1 > 0 
                                      )                    
                   );
                   --30-09-24 calarconap Se ajusto la consulta para filtrar correctamente segun guia 11177
                                      
                   /*select x.xwffec1 FECHA
                  from xwf700 x
                 where xwfprcins = p_ins
                   and xwfcar3 <> '1' */
                   
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      ---
      begin
        select count(1)
          into ln_NRO_CUOTAS_PAG
          from xwf700 x, fsd602 d
         where x.xwfprcins = p_ins
           and d.pgcod = x.xwfempresa
           and d.ppmod = x.xwfmodulo
           and d.ppsuc = x.xwfsucursal
           and d.ppmda = x.xwfmoneda
           and d.pppap = x.xwfpapel
           and d.ppcta = x.xwfcuenta
           and d.ppoper = x.xwfoperacion
           and d.ppsbop = x.xwfsubope
           and d.pptope = x.xwftipope
           and d.ppfpag > LN_FECHA_ULT_REPROG
           and d.pp1stat = 'T'
           and d.d602co = 'S';
      exception
        when others then
          null;
      end;
      begin
        select count(1)
          into ln_NRO_REPROG
          from (select jaqa400fec
                  from jaqa400
                 where jaqa400ai1 = p_ins
                   and jaqa400est = 'C'
                union all
                select jaqz698fep
                  from jaqz698 j, xwf700 x
                 where j.jaqz698emp = x.xwfempresa
                   and j.jaqz698mod = x.xwfmodulo
                   and j.jaqz698suc = x.xwfsucursal
                   and j.jaqz698mda = x.xwfmoneda
                   and j.jaqz698pap = x.xwfpapel
                   and j.jaqz698cta = x.xwfcuenta
                   and j.jaqz698ope = x.xwfoperacion
                   and j.jaqz698sbo = x.xwfsubope
                   and j.jaqz698top = x.xwftipope
                   and x.xwfprcins = p_ins
                   and xwfcar3 = '1'
                   and j.jaqz698est = 'C'
                union all               
                      select z.aofval 
                from xwf700 x, sng001 s, fsd010 z 
               where s.sng001inst = x.xwfprcins
                 and xwfprcins = p_ins
                 and xwfcar3 = '1'    
                 and z.pgcod = x.xwfempresa
                 and z.aomod = x.xwfmodulo
                 and z.aosuc = x.xwfsucursal
                 and z.aomda = x.xwfmoneda
                 and z.aopap = x.xwfpapel
                 and z.aocta = x.xwfcuenta
                 and z.aooper = x.xwfoperacion
                 and z.aosbop = x.xwfsubope
                 and z.aotope = x.xwftipope
                 and s.sng001ori in ( SELECT a.tp1nro1 
                                      FROM FST198 a 
                                      WHERE a.tp1cod = 1 and a.tp1cod1 = 11177 and a.tp1corr1 = 1 and 
                                      a.tp1corr2 = 1 and a.tp1nro1 > 0 
                                      )
                   
                   );
      exception
        when others then
          null;
      end;
    
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_deserr := sqlerrm;
        --null;
      --return;
    end;
  
    if ln_NRO_REPROG >= 1 and ln_NRO_CUOTAS_PAG < 6 then
      p_c_coderr    := '0001';
      p_c_deserr    := 'cliente tiene dos reprogramados y no ha pagado 06 cuotas';
      p_c_respuesta := 'S';
    end if;
  
  end SP_CR_CLIENTE_REPROG_05;

  procedure sp_rng_reprogsincapit_G6(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2) is
  
    lc_VerifCalDet6M    varchar2(2);
    ln_MoraMaxTitConyRL number(10);
  
  begin
    begin
      PQ_CR_CALIFICACIONES.sp_cr_VerfCalDetTitConyRL6M(ln_Instancia,
                                                       lc_VerifCalDet6M);
    exception
      when others then
        null;
    end;
  
    begin
      PQ_CR_CALIFICACIONES.sp_cr_MoraMaxTitConyRL(ln_Instancia,
                                                  ln_MoraMaxTitConyRL);
    exception
      when others then
        null;
    end;
    ln_MoraMaxTitConyRL := NVL(ln_MoraMaxTitConyRL, 0);
    IF lc_VerifCalDet6M = 'S' AND ln_MoraMaxTitConyRL >= 45.00 THEN
      CodError := '00001';
      flgRpta  := 'S';
      Mensaje  := 'Se permite atrasos y clasificación diferente a normal sólo en Caja Arequipa';
    ELSE
      CodError := '00000';
      flgRpta  := 'N';
      Mensaje  := '';
    END IF;
  end sp_rng_reprogsincapit_G6;

  procedure sp_cr_reprog_condicion_007(instancia in number,
                                       usuario   in varchar2,
                                       rpt       out varchar2,
                                       coderr    out varchar2,
                                       msgerr    out varchar2) is
  
    contador number := 0;
  begin
    begin
      select COUNT(*)
        into contador
        from (select jaqa400fec
                from jaqa400
               where jaqa400ai1 = instancia
                 and jaqa400est = 'C'
              union all
              select jaqz698fep
                from jaqz698 j, xwf700 x
               where j.jaqz698emp = x.xwfempresa
                 and j.jaqz698mod = x.xwfmodulo
                 and j.jaqz698suc = x.xwfsucursal
                 and j.jaqz698mda = x.xwfmoneda
                 and j.jaqz698pap = x.xwfpapel
                 and j.jaqz698cta = x.xwfcuenta
                 and j.jaqz698ope = x.xwfoperacion
                 and j.jaqz698sbo = x.xwfsubope
                 and j.jaqz698top = x.xwftipope
                 and x.xwfprcins = instancia
                 and xwfcar3 = '1'
                 and j.jaqz698est = 'C'
              union all 
                          select z.aofval 
                from xwf700 x, sng001 s, fsd010 z 
               where s.sng001inst = x.xwfprcins
                 and xwfprcins = instancia
                 and xwfcar3 = '1'    
                 and z.pgcod = x.xwfempresa
                 and z.aomod = x.xwfmodulo
                 and z.aosuc = x.xwfsucursal
                 and z.aomda = x.xwfmoneda
                 and z.aopap = x.xwfpapel
                 and z.aocta = x.xwfcuenta
                 and z.aooper = x.xwfoperacion
                 and z.aosbop = x.xwfsubope
                 and z.aotope = x.xwftipope
                 and s.sng001ori in ( SELECT a.tp1nro1 
                                      FROM FST198 a 
                                      WHERE a.tp1cod = 1 and a.tp1cod1 = 11177 and a.tp1corr1 = 1 and 
                                      a.tp1corr2 = 1 and a.tp1nro1 > 0 
                                      ) 
                                      );                                      
                /*select x.xwffec1
                from xwf700 x
               where xwfprcins = instancia
                 and xwfcar3 <> '1');
                  */                                 
                 
    exception
      when others then
        null;
    end;
  
    if contador >= 2 then
      rpt    := 'S';
      coderr := '0001';
      msgerr := 'Cliente tiene 2 reprogramaciones contabilizadas';
    else
      rpt    := 'N';
      coderr := '0000';
      msgerr := '';
    end if;
  
  end sp_cr_reprog_condicion_007;

  procedure sp_rng_reprogsincapit_G8(ln_Instancia number,
                                     Usuario      varchar2,
                                     flgRpta      out varchar2,
                                     CodError     out varchar2,
                                     Mensaje      out varchar2) is
    DIAS_IMPAGA_PROP   number(10);
    FECHA_PROP         DATE;
    ld_FchUltPagoTotal DATE;
    FECHA_PENDPDGO     DATE;
  
    ln_pgcod     number;
    ln_sucursal  number;
    ln_modulo    number;
    ln_moneda    number;
    ln_papel     number;
    ln_cuenta    number;
    ln_operacion number;
    ln_subopera  number;
    ln_tipopera  number;
  
  begin
    begin
      select w.xwfempresa,
             w.xwfsucursal,
             w.xwfmodulo,
             w.xwfmoneda,
             w.xwfpapel,
             w.xwfcuenta,
             w.xwfoperacion,
             w.xwfsubope,
             w.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 w
       where w.xwfprcins = ln_Instancia
         and w.xwfcar3 = 1; --<> '1';
    exception
      when others then
        ln_pgcod     := 0;
        ln_sucursal  := 0;
        ln_modulo    := 0;
        ln_moneda    := 0;
        ln_papel     := 0;
        ln_cuenta    := 0;
        ln_operacion := 0;
        ln_subopera  := 0;
        ln_tipopera  := 0;
    end;
  
    ------------------------------------
  
    BEGIN
      select CASE
               WHEN TRIM(MIN(D11.PPFPAG)) IS NULL THEN
                TO_DATE('01/01/2000', 'dd/mm/rrrr')
               ELSE
                MIN(d11.ppfpag)
             end FECHAPAGO_PROPUESTO
        INTO FECHA_PROP
      --*
        from fsd601 d11
       where d11.pgcod = ln_pgcod
         and d11.ppsuc = ln_sucursal
         and d11.ppmod = ln_modulo
         and d11.ppmda = ln_moneda
         and d11.pppap = ln_papel
         and d11.ppcta = ln_cuenta
         and d11.ppoper = ln_operacion
         and d11.ppsbop = 609
         and d11.pptope = ln_tipopera;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      SELECT MAX(D.PPFPAG)
        INTO ld_FchUltPagoTotal
        FROM FSD601 D, FSD602 D2
       WHERE D.PGCOD = ln_pgcod
         AND D.PPMOD = ln_modulo
         AND D.PPSUC = ln_sucursal
         AND D.PPMDA = ln_moneda
         AND D.PPPAP = ln_papel
         AND D.PPCTA = ln_cuenta
         AND D.PPOPER = ln_operacion
         AND D.PPSBOP = ln_subopera
         AND D.PPTOPE = ln_tipopera
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
    exception
      when no_data_found then
        ld_FchUltPagoTotal := null;
    end;
  
    if ld_FchUltPagoTotal is not null then
      begin
        select MIN(f.ppfpag)
          into FECHA_PENDPDGO
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_sucursal
           and f.ppmda = ln_moneda
           and f.pppap = ln_papel
           and f.ppcta = ln_cuenta
           and f.ppoper = ln_operacion
           and f.ppsbop = ln_subopera
           and f.pptope = ln_tipopera
           and f.ppfpag > ld_FchUltPagoTotal
           and f.d601co = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;
    
      IF FECHA_PENDPDGO IS NULL THEN
        BEGIN
          SELECT MIN(D.PPFPAG)
            INTO FECHA_PENDPDGO
            FROM FSD601 D
           WHERE D.PGCOD = ln_pgcod
             AND D.PPMOD = ln_modulo
             AND D.PPSUC = ln_sucursal
             AND D.PPMDA = ln_moneda
             AND D.PPPAP = ln_papel
             AND D.PPCTA = ln_cuenta
             AND D.PPOPER = ln_operacion
             AND D.PPSBOP = ln_subopera
             AND D.PPTOPE = ln_tipopera;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    
    ELSE
      BEGIN
        SELECT MIN(D.PPFPAG)
          INTO FECHA_PENDPDGO
          FROM FSD601 D
         WHERE D.PGCOD = ln_pgcod
           AND D.PPMOD = ln_modulo
           AND D.PPSUC = ln_sucursal
           AND D.PPMDA = ln_moneda
           AND D.PPPAP = ln_papel
           AND D.PPCTA = ln_cuenta
           AND D.PPOPER = ln_operacion
           AND D.PPSBOP = ln_subopera
           AND D.PPTOPE = ln_tipopera;
      exception
        when others then
          null;
      END;
    END IF;
  
    DIAS_IMPAGA_PROP := FECHA_PROP - FECHA_PENDPDGO;
  
    DIAS_IMPAGA_PROP := NVL(DIAS_IMPAGA_PROP, 0);
  
    IF DIAS_IMPAGA_PROP > 60.00 THEN
      CodError := '00001';
      flgRpta  := 'S';
      Mensaje  := 'Fecha de primer pago mayor a la permitida';
    ELSE
      CodError := '00000';
      flgRpta  := 'N';
      Mensaje  := '';
    END IF;
  
  end sp_rng_reprogsincapit_G8;

  procedure sp_cr_reprog_condicion_09(instancia in number,
                                      usuario   in varchar2,
                                      rpt       out varchar2,
                                      coderr    out varchar2,
                                      msgerr    out varchar2) is
  
    CUO_PEND               number;
    CUO_CRE_NVO            number;
    respuesta1             varchar2(1);
    respuesta2             varchar2(1);
    vi_pgcod               number;
    vi_aomod               number;
    vi_aosuc               number;
    vi_aomda               number;
    vi_aopap               number;
    vi_aocta               number;
    vi_aooper              number;
    vi_aosbop              number;
    vi_aotope              number;
    CUOTAS_TOTALES         number;
    CUOTAS_TOTALES_PAGADAS number;
    CUOTAS_TOTALES_2       number;
    DIF_CANTCUO            number;
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
       where xwfprcins = instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
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
  
    --CUOTAS PAGADAS
    begin
      SELECT COUNT(*)
        INTO CUOTAS_TOTALES_PAGADAS
        FROM FSD602 D
       WHERE D.PGCOD = vi_pgcod
         AND D.PPMOD = vi_aomod
         AND D.PPSUC = vi_aosuc
         AND D.PPMDA = vi_aomda
         AND D.PPPAP = vi_aopap
         AND D.PPCTA = vi_aocta
         AND D.PPOPER = vi_aooper
         AND D.PPSBOP = vi_aosbop
         AND D.PPTOPE = vi_aotope
         AND D.PP1STAT = 'T'
         and d.d602co = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        CUOTAS_TOTALES_PAGADAS := 0;
    end;
  
    --CUO_PEND 
    CUO_PEND := CUOTAS_TOTALES - CUOTAS_TOTALES_PAGADAS;
  
    --CUO_CRE_NVO
    /*begin
      select s.xllcantcuo
        into CUO_CRE_NVO
        from xwf700 x, x054023 s
       where x.xwfempresa = s.xllpgcod
         and x.xwfsucursal = s.xllaosuc
         and x.xwfmodulo = s.xllaomod
         and x.xwfmoneda = s.xllaomda
         and x.xwfpapel = s.xllaopap
         and x.xwfcuenta = s.xllaocta
         and x.xwfoperacion = s.xllaooper
         and x.xwfsubope = s.xllaosbop
         and x.xwftipope = s.xllaotop
         and x.xwfprcins = instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        CUO_CRE_NVO := 0;
    end;*/
  
    begin
      SELECT COUNT(*)
        INTO CUOTAS_TOTALES_2
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
    exception
      when others then
        null;
    end;
  
    DIF_CANTCUO := CUOTAS_TOTALES_2 - CUO_PEND;
  
    /*if CUO_CRE_NVO > CUO_PEND + 3 then
        respuesta1 := 'S';
      else
        respuesta1 := 'N';
      end if;
    */
    if DIF_CANTCUO > 3 then
      rpt := 'S';
    else
      rpt := 'N';
    end if;
  
    if rpt = 'S' then
      --rpt    := 'S';
      coderr := '0001';
      msgerr := 'No se puede aumentar más de tres cuotas a la nueva operación.';
    else
      --rpt    := 'N';
      coderr := '0000';
      msgerr := '';
    end if;
  end sp_cr_reprog_condicion_09;

  PROCEDURE SP_RNG_REPROGSINCAPIT_G10(Ln_Instancia number,
                                      Usuario      varchar2,
                                      flgRpta      out varchar2,
                                      CodError     out varchar2,
                                      Mensaje      out varchar2) IS
  BEGIN
    PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(Ln_Instancia,
                                                                   flgRpta,
                                                                   CodError,
                                                                   Mensaje);
    ---
    if flgRpta <> 'S' then
      flgRpta  := 'S';
      CodError := '0001';
      Mensaje  := 'RSC:Tiene mas de 30 dias de atraso.';
    else
      flgRpta  := 'N';
      CodError := '0000';
      Mensaje  := '';
    end if;
  END;

  procedure sp_rng_reprogsincapit_G11(ln_Instancia number,
                                      Usuario      varchar2,
                                      flgRpta      out varchar2,
                                      CodError     out varchar2,
                                      Mensaje      out varchar2) IS
    vi_pgcod        number;
    vi_aomod        number;
    vi_aosuc        number;
    vi_aomda        number;
    vi_aopap        number;
    vi_aocta        number;
    vi_aooper       number;
    vi_aosbop       number;
    vi_aotope       number;
    vo_periodo      NUMBER(6);
    vo_periodoPropu NUMBER(6);
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
       where xwfprcins = ln_Instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
  
    BEGIN
      select x.XLLPERIODO
        into vo_periodo
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
      select x.XLLPERIODO
        into vo_periodoPropu
        from x054023 x
       where x.xllpgcod = vi_pgcod
         and x.xllaomod = vi_aomod
         and x.xllaosuc = vi_aosuc
         and x.xllaomda = vi_aomda
         and x.xllaopap = vi_aopap
         and x.xllaocta = vi_aocta
         and x.xllaooper = vi_aooper
         and x.xllaosbop = 609 --vi_aosbop
         and x.xllaotop = vi_aotope;
    Exception
      when others then
        null; --vo_fprpago:=0;
    END;
  
    vo_periodoPropu := nvl(vo_periodoPropu, 0);
    vo_periodo      := nvl(vo_periodo, 0);
  
    IF vo_periodoPropu > vo_periodo THEN
      CodError := '00001';
      flgRpta  := 'S';
      Mensaje  := 'Periodo mayor a la permitida';
    ELSE
      CodError := '00000';
      flgRpta  := 'N';
      Mensaje  := '';
    END IF;
  END;

  procedure sp_cr_repg_cantcuopag(ln_instancia number,
                                  cantCuoPag   out number) IS
    vi_pgcod  number;
    vi_aomod  number;
    vi_aosuc  number;
    vi_aomda  number;
    vi_aopap  number;
    vi_aocta  number;
    vi_aooper number;
    vi_aosbop number;
    vi_aotope number;
  
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
       where xwfprcins = ln_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    END;
  
    begin
      SELECT COUNT(1)
        INTO cantCuoPag
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
    exception
      when no_data_found then
        cantCuoPag := 0;
    end;
  
    cantCuoPag := nvl(cantCuoPag, 0);
  END;

  PROCEDURE SP_CR_VALIDAR_OPINION_G12 (
                                        VEI_N_INSTANCE IN NUMBER,
                                        VEI_V_UBUSER   IN VARCHAR2,
                                        VEO_V_RPTA     OUT VARCHAR2,
                                        VEO_V_CODERROR OUT VARCHAR2,
                                        VEO_V_MSGERROR OUT VARCHAR2    
                                       ) IS
  VII_REQUIEREOPINION VARCHAR(10);
  VII_TIENEOPINION    NUMBER(9);                             
  VII_TIPOOPINION     VARCHAR(10);
  BEGIN
    ------DENTRO DEL GRUPO
    VEO_V_RPTA := 'N';
    VEO_V_CODERROR := '00000';
        BEGIN
          pq_cr_reprogramaopinion.sp_validamontoopinionCap(VEI_N_INSTANCE,
                                                           VII_REQUIEREOPINION);                     
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        VEO_V_RPTA := 'N';        
        IF VII_REQUIEREOPINION = 'S' THEN
           VEO_V_RPTA     := 'S';
           VEO_V_CODERROR := '00001';
           VEO_V_MSGERROR := 'Monto mayor a S/ 50000 - antes Dic 2022 - posteriores Jun 2023';
        END IF;
        ------VALIDAR SI INGRESARON OPINION      
        pq_cr_reprogramaexo.sp_validaopinion(VEI_N_INSTANCE,
                                             VII_TIENEOPINION,
                                             VII_TIPOOPINION,
                                             VEO_V_MSGERROR);
        ------VALIDAR MENSAJE SI SALTA POLITICA
        IF VEO_V_RPTA = 'N' or
           (VII_TIENEOPINION = 1 and VII_TIPOOPINION = 'V') THEN
           VEO_V_RPTA := 'N';
        ELSE
          VEO_V_MSGERROR := 'RSC:Requiere Opinion de Riesgos';
          VEO_V_RPTA := 'S';
        END IF;
  END;

  PROCEDURE SP_CR_OBTENER_REFINAN_G13(
                                      VEI_N_INSTANCE IN NUMBER,
                                      VEI_V_UBUSER   IN VARCHAR2,
                                      VEO_V_RPTA     OUT VARCHAR2,
                                      VEO_V_CODERROR OUT VARCHAR2,
                                      VEO_V_MSGERROR OUT VARCHAR2  
                                     )IS
  BEGIN
     VEO_V_RPTA := 'N';
     --VALIDAR SI EL ORIGEN ES REFINANCIADO
     BEGIN
      SELECT 'S' INTO VEO_V_RPTA FROM SNG001 WHERE SNG001INST=VEI_N_INSTANCE AND SNG001ORI=3 AND ROWNUM=1;
     EXCEPTION
       WHEN OTHERS THEN
         VEO_V_RPTA := 'N';
     END;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
end PQ_CR_VALID_RNG_RPG_SCRM;
/

