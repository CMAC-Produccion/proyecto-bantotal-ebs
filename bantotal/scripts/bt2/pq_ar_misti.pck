create or replace package PQ_AR_MISTI is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AR_MISTI
  -- Sistema               : BANTOTAL
  -- Módulo                : ARQUITECTURA - MISTI
  -- Versión               : 1.0
  -- Estado                : Activo
  -- Acceso                : Público
  --
  -- Fecha de Creación     : 09/05/2019
  -- Autor de Creación     : JPINTO
  -- Uso                   : Implementación de Micro Servicios de MISTI   
  --
  -- Fecha de Modificación : 04/09/2019
  -- Autor de Creación     : JPINTO
  -- Descripción Modific.  : Se agregaron procedimientos y funciones para el SIMULADOR CON SEGMENTACION de MISTI
  --                       : -sp_obtenerTarifarios                   OK
  --                       : -sp_obtenerMontosMinMaxDef              OK
  --                       : -fn_obtenerVariacionMontos              OK           
  --                       : -sp_obtenerFrecuencia                   OK
  --                       : -sp_obtenerlistadofrecuencia            OK
  --                       : -fn_obtenerDesgravamen                  OK
  --                       : -fn_obtenerVariacionCuotas              OK
  --                       : -fn_obtenerVariacionDesgravamen         OK
  --
  -- Fecha de Modificación : 04/07/2020
  -- Autor de Creación     : CPFURO
  -- Descripción Modific.  : Se agregaron procedimientos y funciones para el SIMULADOR CON SEGMENTACION de MISTI
  --                       : -sp_obtenerMotivoVisita                 OK
  --                       : -sp_registrarVisita                     OK
  --                       : -sp_registrarVisitaFoto                 OK           
  --                       : -sp_obtenerVisitas                      OK
  --                       : -sp_obtenerVisitaFoto                   OK
  --                       : -sp_obtenerVisitasUsuario               OK
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure sp_buscarClienteCampana(p_n_codpai in number,
                                    p_n_tipdoc in number,
                                    p_c_numdoc in varchar2,
                                    p_c_coderr out varchar2,
                                    p_c_msgerr out varchar2);

  procedure sp_buscarPizarraCampanaFijas(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2);

  procedure sp_buscarSegmentacionCliente(p_c_codusu varchar2,
                                         p_n_codpai number,
                                         p_n_tipdoc number,
                                         p_c_numdoc varchar2,
                                         p_c_segcli out varchar2,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2);

  procedure sp_buscarPersona(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_n_codpai in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2);

  procedure sp_buscarCuentaClientePersona(BL_DATOS   IN OUT SYS_REFCURSOR,
                                          p_n_codpai in number,
                                          p_n_tipdoc in number,
                                          p_c_numdoc in varchar2,
                                          p_c_coderr out varchar2,
                                          p_c_msgerr out varchar2);

  procedure sp_buscarProductoCampanaFija(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_n_codpai in number,
                                         p_n_tipdoc in number,
                                         p_c_numdoc in varchar2,
                                         p_n_codcam in number,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2);

  procedure sp_obtenerTarifarios(BL_DATOS   IN OUT SYS_REFCURSOR,
                                 p_n_modulo in number,
                                 p_n_tipope in number,
                                 p_n_moneda in number,
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2);

  procedure sp_obtenerMontosMinMaxDef(BL_DATOS   IN OUT SYS_REFCURSOR,
                                      p_n_modulo in number,
                                      p_n_tipope in number,
                                      p_n_moneda in number,
                                      p_c_coderr out varchar2,
                                      p_c_msgerr out varchar2);

  procedure sp_obtenerFrecuencia(p_n_modulo in number,
                                 p_n_tipope in number,
                                 p_n_moneda in number,
                                 p_n_frecue out number,
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2);

  procedure sp_obtenerListadoFrecuencia(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_n_modulo in number,
                                        p_n_tipope in number,
                                        p_n_moneda in number,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);
  procedure sp_obtenerProductosSegmentos(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2);

  procedure sp_obtenerMotivoVisita(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  procedure sp_registrarVisita(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_tipdoc in varchar2,
                                        p_c_numdoc in varchar2,
                                        p_n_instan in number,
                                        p_n_codmot in number,
                                        p_c_coment in varchar2,
                                        p_n_poslat in number,
                                        p_n_poslon in number,
                                        p_s_fechor in varchar2,
                                        p_n_numfot in number,
                                        p_s_diregm in varchar2,
                                        p_c_codrei in varchar2,
                                        p_c_msgrei in varchar2,
                                        p_c_codtrc out varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  procedure sp_registrarVisitaFoto(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_codtrc in varchar2,
                                        p_n_numfot in number,
                                        p_c_texfot in varchar2,
                                        p_b_fotb64 in blob,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  procedure sp_obtenerVisitas(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_s_codusu in varchar2,
                                        --p_s_coduss in varchar2,
                                        p_n_coddom in number,
                                        p_c_tipdoc in varchar2,
                                        p_c_numdoc in varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  procedure sp_obtenerVisitaFoto(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_codtrc in varchar2,
                                        p_n_numfot in number,
                                        p_c_texfot out varchar2,
                                        p_b_fotb64 out blob,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  procedure sp_obtenerVisitasUsuario(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_s_codusu in varchar2,
                                        p_s_fecing in varchar2,
                                        p_n_totfot out number,
                                        p_c_realiz out number,
                                        p_c_nomusu out varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);
                                        
                                        
  --// Funciones Atómicas                           

  function fn_obtenerNombrePersona(p_n_codpai in number,
                                   p_n_tipdoc in number,
                                   p_c_numdoc in varchar2) return varchar2;

  function fn_obtenerDireccionPersona(p_n_codpai in number,
                                      p_n_tipdoc in number,
                                      p_c_numdoc in varchar2) return varchar2;

  function fn_obtenerTelefonoPersona(p_n_codpai in number,
                                     p_n_tipdoc in number,
                                     p_c_numdoc in varchar2) return varchar2;

  function fn_obtenerVariacionMontos return number;

  function fn_obtenerDesgravamen return number;

  function fn_obtenerVariacionDesgravamen return number;

  function fn_obtenerVariacionCuotas return number;

  function fn_obtenerCalificacionConsumo(p_n_codpai number,
                                         p_n_tipdoc number,
                                         p_c_numdoc varchar2) return varchar2;

end PQ_AR_MISTI;
/

create or replace package body PQ_AR_MISTI is
  --//
  procedure sp_buscarClienteCampana(p_n_codpai in number,
                                    p_n_tipdoc in number,
                                    p_c_numdoc in varchar2,
                                    p_c_coderr out varchar2,
                                    p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARCLIENTECAMPANA
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 09/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar si el DNI ingresado esta en al repositorio de clientes que acceden a campañas 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    ln_canreg number := 0;
    --//
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    begin
      select count(1)
        into ln_canreg
        from jaqy346c a1
       where a1.jaqy346cpai = p_n_codpai
         and a1.jaqy346ctdo = p_n_tipdoc
         and a1.jaqy346cndo = p_c_numdoc;
    exception
      when others then
        p_c_coderr := '01000';
        p_c_msgerr := 'No Existen registros encontrados para ese documento';
    end;
    --//
    if ln_canreg = 0 then
      p_c_coderr := '01001';
      p_c_msgerr := 'Cliente no tiene campaña de montos fijos';
    end if;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarClienteCampana;

  procedure sp_buscarPizarraCampanaFijas(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARPIZARRACAMPANA
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 09/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar si el DNI ingresado esta en al repositorio de clientes que acceden a campañas 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    open BL_DATOS for
      select t1.tp1corr3 as Oferta,
             --TO_CHAR(t1.tp1nro1, '99,999,999.99') as Monto,
             t1.tp1nro1 as Monto,
             t1.tp1imp1 as Tasa,
             t1.tp1nro2 as Plazo_12,
             t1.tp1imp2 as Cuota_12,
             t1.tp1nro3 as Plazo_18,
             t1.tp1imp3 as Cuota_18
        from fst198 t1
       where t1.tp1cod1 = 10801
         and t1.tp1corr1 = 314
         and t1.tp1corr2 = 1
         and t1.tp1corr3 > 0;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarPizarraCampanaFijas;

  procedure sp_buscarSegmentacionCliente(p_c_codusu varchar2,
                                         p_n_codpai number,
                                         p_n_tipdoc number,
                                         p_c_numdoc varchar2,
                                         p_c_segcli out varchar2,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARSEGMENTACIONCLIENTE
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 09/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar la Segmentación del cliente 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    lc_segcli varchar2(100) := null;
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    begin
      pq_apl_segmentacion.sp_carga_data(pd_fecpro => trunc(sysdate),
                                        -- fecha del dia
                                        pn_pai => p_n_codpai,
                                        -- pais
                                        pn_tdo => p_n_tipdoc,
                                        -- tipo de documento
                                        pc_doc => p_c_numdoc,
                                        -- nro de documento
                                        pc_usr => Upper(p_c_codusu)
                                        -- usuario que esta ejecutando el paquete
                                        );
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
  
    --//
    begin
      select jaqy067ncal
        into lc_segcli
        from (select a.jaqz086paic,
                     a.jaqz086tdoc,
                     a.jaqz086tndoc,
                     b.jaqy067ncal
                from JAQZ086_APLINEA a, jaqy067 b
               where a.jaqz086paic = p_n_codpai
                 and a.jaqz086tdoc = p_n_tipdoc
                 and a.jaqz086tndoc = rpad(trim(p_c_numdoc), 12, ' ')
                 and a.jaqz086usr = Upper(p_c_codusu)
                 and a.jaqz086calf = b.jaqy067ccal)
       where rownum <= 1;
    exception
      when others then
        p_c_coderr := '01001';
        p_c_msgerr := 'No Existen Segmentación para este cliente';
    end;
    p_c_segcli := lc_segcli;
    --//
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarSegmentacionCliente;

  procedure sp_buscarPersona(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_n_codpai in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARSEGMENTACIONCLIENTE
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 09/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar la Segmentación del cliente 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    lc_segcli varchar2(100) := null;
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    open BL_DATOS for
      select fn_obtenerNombrePersona(p_n_codpai, p_n_tipdoc, p_c_numdoc) nomper,
             fn_obtenerDireccionPersona(p_n_codpai, p_n_tipdoc, p_c_numdoc) dirper,
             fn_obtenerTelefonoPersona(p_n_codpai, p_n_tipdoc, p_c_numdoc) telper
        from dual d1;
    --//
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarPersona;

  --//  
  procedure sp_buscarCuentaClientePersona(BL_DATOS   IN OUT SYS_REFCURSOR,
                                          p_n_codpai in number,
                                          p_n_tipdoc in number,
                                          p_c_numdoc in varchar2,
                                          p_c_coderr out varchar2,
                                          p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARCUENTACLIENTEPERSONA
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 09/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar cuentas cliente de la persona 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    open BL_DATOS for
      select a3.ctnro
        from fsr008 a3
       where a3.pepais = p_n_codpai
         and a3.petdoc = p_n_tipdoc
         and a3.pendoc = rpad(trim(p_c_numdoc), 12, ' ')
         and a3.cttfir = 'T';
    --//
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarCuentaClientePersona;

  procedure sp_buscarProductoCampanaFija(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_n_codpai in number,
                                         p_n_tipdoc in number,
                                         p_c_numdoc in varchar2,
                                         p_n_codcam in number,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_BUSCARPRODUCTOCAMPANAFIJA
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 15/05/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar Productos Campana Fija 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    open BL_DATOS for
      select c1.jaql626mod as codmod,
             (select t3.mdnom from fst003 t3 where t3.modulo = c1.jaql626mod) as desmod,
             c1.jaql626tope as codtop,
             c1.jaql626desc as destop
        from jaql626 c1
       where jaql626cam = 7
         and c1.jaql626mod = 101
         and c1.jaql626tope in (242, 243);
    --//
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarProductoCampanaFija;

  procedure sp_obtenerTarifarios(BL_DATOS   IN OUT SYS_REFCURSOR,
                                 p_n_modulo in number,
                                 p_n_tipope in number,
                                 p_n_moneda in number,
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2) is
  
    p_n_parame number := 17;
  begin
    p_c_coderr := '00000';
    p_c_msgerr := '';
    p_n_parame := 17;
    --//
    open BL_DATOS for
      SELECT A.PGCOD  empresa,
             A.TAMOD  modulo,
             A.TPIZAR pizarra,
             A.TAMDA  moneda,
             A.TAPAP  papel,
             A.TAFDES fecha_desde,
             A.TAMTO  monto,
             A.TAPZO  plazo,
             A.TATOL  tolerancia,
             A.TATASA tasa
        FROM FSR025 A
       WHERE A.TAMOD = p_n_modulo
         AND A.TPIZAR IN (SELECT B.PP028DEFN
                            FROM FPP028 B
                           WHERE B.PP028MOD = p_n_modulo
                             AND B.PP017PAR = p_n_parame
                             AND B.PP028TOP = p_n_tipope
                             AND B.PP028MDA = p_n_moneda)
         AND A.TAMDA = p_n_moneda
         AND A.TAPAP = 0;
  
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := 'No hay tarifarios definidos para este producto.';
  end sp_obtenerTarifarios;

  procedure sp_obtenerMontosMinMaxDef(BL_DATOS   IN OUT SYS_REFCURSOR,
                                      p_n_modulo in number,
                                      p_n_tipope in number,
                                      p_n_moneda in number,
                                      p_c_coderr out varchar2,
                                      p_c_msgerr out varchar2) is
    p_n_parame number := 105;
  begin
    p_c_coderr := '00000';
    p_c_msgerr := '';
    p_n_parame := 105;
    --//
    open BL_DATOS for
      select a.pp028defn as defecto,
             a.pp028minn as minimo,
             a.pp028maxn as maximo --a.*
        from fpp028 a
       where a.pp017par = p_n_parame
         and a.pp028mod = p_n_modulo
         and a.pp028top = p_n_tipope
         and a.pp028mda = p_n_moneda
         and a.pp028pap = 0;
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerMontosMinMaxDef;

  procedure sp_obtenerFrecuencia(p_n_modulo in number,
                                 p_n_tipope in number,
                                 p_n_moneda in number,
                                 p_n_frecue out number,
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2) is
    p_n_parame number := 18;
  begin
    p_c_coderr := '00000';
    p_c_msgerr := '';
    p_n_parame := 18;
    --//
    p_n_frecue := 0;
    --//
    begin
      select a.pp028defn defecto
        into p_n_frecue
        from fpp028 a
       where a.pp017par = p_n_parame
         and a.pp028mod = p_n_modulo
         and a.pp028top = p_n_tipope
         and a.pp028mda = p_n_moneda
         and a.pp028pap = 0;
    exception
      when others then
        p_n_frecue := 0;
    end;
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerFrecuencia;

  procedure sp_obtenerListadoFrecuencia(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_n_modulo in number,
                                        p_n_tipope in number,
                                        p_n_moneda in number,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    p_n_parame number := 18;
  begin
    p_c_coderr := '00000';
    p_c_msgerr := '';
    p_n_parame := 18;
    --//
    --//
    open BL_DATOS for
      select a.PP026COD as codigo, a.PP026DSC as descripcion
        from fpp026 a
       where a.pp017par = p_n_parame
         and a.pp026mod = p_n_modulo
         and a.pp026top = p_n_tipope
         and a.pp026mda = p_n_moneda
         and a.pp026pap = 0; -- PP026COD, PP026DSC ; -- listado de frecuencias a mostrar
  
    /*
    BL_DATOS      
    if 1 = 1 then
      open BL_DATOS for
      select '' as codigo, '' as descripcion
        from dual;
    end if;     
    */
  
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerListadoFrecuencia;

  procedure sp_obtenerProductosSegmentos(BL_DATOS   IN OUT SYS_REFCURSOR,
                                         p_c_coderr out varchar2,
                                         p_c_msgerr out varchar2) is
    p_n_parame number := 18;
  begin
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    --//
    open BL_DATOS for
    
      select j.jaql722codi as codigo, j.jaql722desc as descripcion
        from JAQl722 j
       where j.jaql722cogr = 8;
  
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerProductosSegmentos;
  
  procedure sp_obtenerMotivoVisita(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_obtenerMotivoVisita
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Retornar motivos de visita 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    ln_tp1cod   number := 1;
    ln_tp1cod1  number := 11142;
    ln_tp1corr1 number := 1;
    ln_tp1corr2 number := 1;
  begin 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    --//
    open BL_DATOS for
      
      SELECT TP1CORR3 AS CODMOT, TP1DESC AS DESMOT
        FROM FST198 
        WHERE TP1COD = ln_tp1cod AND TP1COD1 = ln_tp1cod1 AND TP1CORR1 = ln_tp1corr1 AND TP1CORR2 = ln_tp1corr2;
      /*SELECT TP1CORR3 AS C_MOTVISITA, TP1DESC AS D_MOTVISITA
        FROM FST198 
        WHERE TP1COD = ln_tp1cod AND TP1COD1 = ln_tp1cod1 AND TP1CORR1 = ln_tp1corr1 AND TP1CORR2 = ln_tp1corr2;*/
        
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;  
  end sp_obtenerMotivoVisita;
  
  procedure sp_registrarVisita(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_tipdoc in varchar2,
                                        p_c_numdoc in varchar2,
                                        p_n_instan in number,
                                        p_n_codmot in number,
                                        p_c_coment in varchar2,
                                        p_n_poslat in number,
                                        p_n_poslon in number,
                                        p_s_fechor in varchar2,
                                        p_n_numfot in number,
                                        p_s_diregm in varchar2,
                                        p_c_codrei in varchar2,
                                        p_c_msgrei in varchar2,
                                        p_c_codtrc out varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : SP_REGISTRARVISITA
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Registrar la visita que se realizo al cliente 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    --ln_canreg number := 0;
    ln_tipdoc number   := TO_NUMBER(p_c_tipdoc, '999');
    ld_fecing date     := TO_DATE(SUBSTR(p_s_fechor,1,10), 'DD-MM-YYYY');
    ld_afecin date     := TO_DATE(p_s_fechor, 'DD-MM-YYYY HH24:MI:SS');
    lc_horing char(5)  := to_char(ld_afecin, 'HH24:MI');
    lc_trcvis char(16) := to_char(ld_fecing, 'YYMMDD');
    
    lc_trcusu char(4)  := substr(p_s_codusu, 1, 4);
    ln_pendoc char(12) := '00';
    --ln_subope number   := 0;
    
    ln_pgcod number   := 0;
    ln_sucur number   := 0;
    ln_modulo number  := 0;
    ln_moneda number  := 0;
    ln_papel number   := 0;
    ln_ctnro number   := 0;
    ln_oper number    := 0;
    ln_subope number  := 0;
    ln_tipope number  := 0;
    ln_perval number  := 0;
    ln_pais number    := 0;
    ln_condom number  := 0;
    ln_aqpb208idl number;
    
    --XWFEMPRESA, XWFSUCURSAL, XWFMODULO, XWFMONEDA, XWFPAPEL, XWFCUENTA, XWFOPERACION, XWFSUBOPE, XWFTIPOPE
    --ln_pgcod, ln_sucur, ln_modulo, ln_moneda, ln_papel, ln_ctnro, ln_oper, ln_subope, ln_tipope 
    
    ld_timst date     := cast(current_timestamp as date);
    ln_ttcod number   := 1;
    lc_cttfir char(1) := 'T';
    --//
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    INSERT INTO AQPB206 (AQPB206USU, AQPB206CDO, AQPB206TDO, AQPB206NDO, AQPB206CMO, AQPB206INS, AQPB206EMP, AQPB206SUC, AQPB206MOD, AQPB206MDA, AQPB206PAP, AQPB206CTA, AQPB206OPE, 
            AQPB206SBO, AQPB206TOP, AQPB206COM, AQPB206LAT, AQPB206LON, AQPB206FEC, AQPB206HOR, AQPB206TST, AQPB206TRC, AQPB206NFO, AQPB206DIR)
          VALUES (p_s_codusu, p_n_coddom, ln_tipdoc, p_c_numdoc, p_n_codmot, p_n_instan, 0, 0, 0, 0, 0, 0, 0, 0, 0, p_c_coment, p_n_poslat, p_n_poslon, ld_fecing, lc_horing, 
            ld_timst, ' ', 0, p_s_diregm)
          RETURNING AQPB206IDL INTO ln_aqpb208idl;
    --//
    begin
      begin
        SELECT TPNRO INTO ln_pais
          FROM FST098 WHERE PGCOD = 1 AND TPCOD = 307  AND TPCORR = 1;  
      exception
        when others then
          p_c_coderr := '01212';
          p_c_msgerr := 'No se pudo obtener país';
      end;
      
      begin
        SELECT PGCOD into ln_pgcod 
          FROM FST046 
          WHERE TRIM(UBUSER) = TRIM(p_s_codusu);  
      exception
        when others then
          p_c_coderr := '01201';
          p_c_msgerr := 'Usuario no es válido';
      end;
      
      if not p_n_coddom = 1 and not p_n_coddom = 3 then
        p_c_coderr := '01202';
        p_c_msgerr := 'Código de domicilio no es válido';
      else
        SELECT COUNT(1) INTO ln_condom
          FROM SNGC13 WHERE SNGC13PAIS = ln_pais AND SNGC13TDOC = p_c_tipdoc AND TRIM(SNGC13NDOC) = p_c_numdoc AND DOCOD = p_n_coddom AND SNGC13EST = 'H';
        if ln_condom = 0 then
          if p_n_coddom = 1 then
            p_c_coderr := '01213';
            p_c_msgerr := 'No se tiene registrado un domicilio legal ';-- || to_char(ln_condom) || ' - ' || to_char(p_n_coddom);
          end if;
          if p_n_coddom = 3 then 
            p_c_coderr := '01214';
            p_c_msgerr := 'No se tiene registrado un domicilio de negocio';
          end if;
          
        end if;  
      end if;
      
      if ln_tipdoc != 21 then
        p_c_coderr := '01203';
        p_c_msgerr := 'Código de tipo de documento no es válido';
      end if;
      
      begin
        SELECT COUNT(*) into ln_perval
          FROM FSD001 
          WHERE PEPAIS = 604 AND PETDOC = p_c_tipdoc AND trim(PENDOC) = p_c_numdoc AND PETIPO = 'F';
          
        if ln_perval = 0 then
          p_c_coderr := '01210';
          p_c_msgerr := 'Persona no esta registrada';
        end if;
         
      end;
      
      if p_n_instan <> 9999999999 then
      begin
        SELECT MAX(T1.XWFSUBOPE) into ln_subope 
          FROM XWF700 T1
          INNER JOIN FSD011 T2 ON (T2.PGCOD = T1.XWFEMPRESA AND T2.SCMOD = T1.XWFMODULO AND T2.SCMDA = T1.XWFMONEDA AND T2.SCPAP = T1.XWFPAPEL AND T2.SCCTA = T1.XWFCUENTA 
            AND T2.SCSUC = T1.XWFSUCURSAL AND T2.SCOPER = T1.XWFOPERACION AND T2.SCSBOP = T1.XWFSUBOPE AND T2.SCTOPE = T1.XWFTIPOPE) AND T2.SCSTAT <> 99
          WHERE T1.XWFPRCINS = p_n_instan;
      exception
        when others then
          p_c_coderr := '01204';
          p_c_msgerr := 'Instancia no es válida';
      end;
        
      begin 
        SELECT T1.XWFEMPRESA, T1.XWFSUCURSAL, T1.XWFMODULO, T1.XWFMONEDA, T1.XWFPAPEL, T1.XWFCUENTA, T1.XWFOPERACION, T1.XWFSUBOPE, T1.XWFTIPOPE INTO ln_pgcod, ln_sucur, ln_modulo, ln_moneda, ln_papel, ln_ctnro, ln_oper, ln_subope, ln_tipope
          FROM XWF700 T1
          INNER JOIN FSD011 T2 ON (T2.PGCOD = T1.XWFEMPRESA AND T2.SCMOD = T1.XWFMODULO AND T2.SCMDA = T1.XWFMONEDA AND T2.SCPAP = T1.XWFPAPEL AND T2.SCCTA = T1.XWFCUENTA 
            AND T2.SCSUC = T1.XWFSUCURSAL AND T2.SCOPER = T1.XWFOPERACION AND T2.SCSBOP = T1.XWFSUBOPE AND T2.SCTOPE = T1.XWFTIPOPE) AND T2.SCSTAT <> 99
          WHERE T1.xwfprcins = p_n_instan AND T1.XWFSUBOPE = ln_subope;  
        if ln_ctnro = 0 then 
          p_c_coderr := '01204';
          p_c_msgerr := 'Instancia no es válida';
        else
          --
          SELECT pendoc INTO ln_pendoc 
            FROM fsr008 
            WHERE ctnro = ln_ctnro
            AND ttcod = ln_ttcod AND cttfir = lc_cttfir AND petdoc = ln_tipdoc;
          
          if trim(ln_pendoc) != p_c_numdoc then 
            p_c_coderr := '01205';
            p_c_msgerr := 'Número de Documento o Instancia no es válido ';
          end if;
          
        end if;
      exception
        when others then
          p_c_coderr := '01204';
          p_c_msgerr := 'Instancia no es válida';  
      end;  
      end if;
      
      if p_c_coderr = '00000' then
      
        lc_trcvis := trim(lc_trcvis) || trim(lc_trcusu);
        lc_trcvis := trim(lc_trcvis) || trim(to_char(sysdate, 'HH24MISS'));
        
        UPDATE AQPB206 SET AQPB206EMP = ln_pgcod, AQPB206SUC = ln_sucur, AQPB206MOD = ln_modulo, AQPB206MDA = ln_moneda, AQPB206PAP = ln_papel, AQPB206CTA = ln_ctnro, AQPB206OPE = ln_oper, 
          AQPB206SBO = ln_subope, AQPB206TOP = ln_tipope, AQPB206TRC = trim(lc_trcvis), AQPB206NFO = 0, AQPB206DIR = p_s_diregm, AQPB206CRE = p_c_codrei, AQPB206DRE = p_c_msgrei
          WHERE AQPB206IDL = ln_aqpb208idl;
        
        --INSERT INTO AQPB206 (AQPB206USU, AQPB206CDO, AQPB206TDO, AQPB206NDO, AQPB206CMO, AQPB206INS, AQPB206EMP, AQPB206SUC, AQPB206MOD, AQPB206MDA, AQPB206PAP, AQPB206CTA, AQPB206OPE, 
          --AQPB206SBO, AQPB206TOP, AQPB206COM, AQPB206LAT, AQPB206LON, AQPB206FEC, AQPB206HOR, AQPB206TST, AQPB206TRC, AQPB206NFO, AQPB206DIR, AQPB206CRE, AQPB206DRE)
          --VALUES (p_s_codusu, p_n_coddom, ln_tipdoc, p_c_numdoc, p_n_codmot, p_n_instan, ln_pgcod, ln_sucur, ln_modulo, ln_moneda, ln_papel, ln_ctnro, ln_oper, ln_subope, ln_tipope, 
          --p_c_coment, p_n_poslat, p_n_poslon, ld_fecing, lc_horing, ld_timst, trim(lc_trcvis), 0, p_s_diregm, p_c_codrei, p_c_msgrei);
          
        p_c_codtrc := lc_trcvis;
      else
        UPDATE AQPB206 SET AQPB206CRE = p_c_coderr, AQPB206DRE = p_c_msgerr WHERE AQPB206IDL = ln_aqpb208idl;
      end if;

    end;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_registrarVisita;
  
  procedure sp_registrarVisitaFoto(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_codtrc in varchar2,
                                        p_n_numfot in number,
                                        p_c_texfot in varchar2,
                                        p_b_fotb64 in blob,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_registrarVisitaFoto
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Registrar fotos de la visita que se realizo al cliente 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    ln_canreg number   := 0;
    ln_idlog  number   := 0;
    ln_coridl number   := 0;
    ls_codusu char(12) := '';
    ln_coddom number   := 0;
    --//
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := ' ';
    --//
    begin
      
      begin
        SELECT AQPB206IDL, AQPB206USU, AQPB206CDO INTO ln_idlog, ls_codusu, ln_coddom
          FROM AQPB206
          WHERE AQPB206TRC = p_c_codtrc;
      exception
        when others then
          p_c_coderr := '01201';
          p_c_msgerr := 'Código único de transacción no es válido';
      end;
      
      if ln_idlog != 0 and trim(ls_codusu) != trim(p_s_codusu) then 
        p_c_coderr := '01202';
        p_c_msgerr := 'Usuario no válido';
      end if;
      
      if ln_idlog != 0 and ln_coddom != p_n_coddom then 
        p_c_coderr := '01203';
        p_c_msgerr := 'Código de domicilio no es válido';
      end if;
      
      if p_b_fotb64 is null then
      --if p_c_texfot is null then
        p_c_coderr := '01211';
        p_c_msgerr := 'No hay foto a registrar';
      end if;
      
      begin
        SELECT count(1) INTO ln_coridl 
          FROM AQPB207
          WHERE AQPB207IDL = ln_idlog and AQPB207COR = p_n_numfot;
        if ln_coridl = 1 then
          p_c_coderr := '01206';
          p_c_msgerr := 'Número de foto ya existe';
        end if;
      end;
      
      if p_c_coderr = '00000' then
        begin       
        
          INSERT INTO AQPB207 (AQPB207IDL, AQPB207COR, AQPB207TFO, AQPB207FOT, AQPB207CRE, AQPB207DRE) 
            VALUES (ln_idlog, p_n_numfot, p_c_texfot, p_b_fotb64, p_c_coderr, p_c_msgerr);
            
          UPDATE AQPB206 SET AQPB206NFO = AQPB206NFO + 1 WHERE AQPB206IDL = ln_idlog;
          
        end;
      end if;

    end;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_registrarVisitaFoto;

  procedure sp_obtenerVisitas(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_s_codusu in varchar2,
                                        --p_s_coduss in varchar2,
                                        p_n_coddom in number,
                                        p_c_tipdoc in varchar2,
                                        p_c_numdoc in varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_obtenerVisitas
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Retorna las visitas registradas
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    ln_tipdoc number := TO_NUMBER(p_c_tipdoc, '999');
    ln_pgcod number  := 0;
    ln_relus number  := 0;
    
    ln_tp1cod   number := 1;
    ln_tp1cod1  number := 11142;
    ln_tp1corr1 number := 1;
    ln_tp1corr2 number := 1;
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := ' ';
    --//
    
    begin
        SELECT PGCOD into ln_pgcod 
          FROM FST046 
          WHERE TRIM(UBUSER) = TRIM(p_s_codusu);  
      exception
        when others then
          p_c_coderr := '01201';
          p_c_msgerr := 'Usuario no es válido';
    end;
    
    /*begin
        SELECT PGCOD into ln_pgcod 
          FROM FST046 
          WHERE TRIM(UBUSER) = TRIM(p_s_coduss);  
      exception
        when others then
          p_c_coderr := '01207';
          p_c_msgerr := 'Usuario supervisor no es válido';
    end;
    
    begin
        SELECT COUNT(1) INTO ln_relus
          FROM SNG057 
          WHERE TRIM(SNG057USR) = TRIM(p_s_codusu) AND TRIM(SNG057JEF) = TRIM(p_s_coduss); 
          
        if ln_relus = 0 then
          p_c_coderr := '01208';
          p_c_msgerr := 'Relación usuario y usuario supervisor no es válida';
        end if;
    end;*/
    
    if not p_n_coddom = 1 and not p_n_coddom = 3 then
      p_c_coderr := '01202';
      p_c_msgerr := 'Código de domicilio no es válido';
    end if;
    
    if ln_tipdoc != 21 then
      p_c_coderr := '01203';
      p_c_msgerr := 'Código de tipo de documento no es válido';
    end if;
    
    open BL_DATOS for
      
      SELECT T1.AQPB206USU AS CODUSU, T2.UBNOM AS NOMUSU, T1.AQPB206INS AS INSTAN, T1.AQPB206CMO AS CODMOT, T3.TP1DESC AS DESMOT, T1.AQPB206COM AS COMENT, T1.AQPB206LAT AS POSLAT, T1.AQPB206LON AS POSLON, 
        (to_char(T1.AQPB206FEC, 'DD-MM-YYYY ')||T1.AQPB206HOR) AS FECHOR, AQPB206NFO AS NUMFOT, AQPB206DIR AS DIREGM, AQPB206CRE AS CODREI, AQPB206DRE AS MSGREI, AQPB206TRC AS CODTRC
        
        FROM AQPB206 T1
        INNER JOIN FST746 T2 ON (TRIM(T2.UBUSER) = T1.AQPB206USU)
        INNER JOIN FST198 T3 ON (T3.TP1COD = T1.AQPB206EMP AND T3.TP1COD1 = ln_tp1cod1 AND T3.TP1CORR1 = ln_tp1corr1 AND T3.TP1CORR2 = ln_tp1corr2 AND T3.TP1CORR3 = T1.AQPB206CMO)
        WHERE T1.AQPB206USU = p_s_codusu AND T1.AQPB206CDO = p_n_coddom AND T1.AQPB206TDO = ln_tipdoc AND T1.AQPB206NDO = p_c_numdoc
        order by T1.AQPB206IDL desc;
      /*SELECT AQPB206CDO AS COD_DOM, AQPB206TDO AS COD_TIPDOC, AQPB206NDO AS NUMDOC, AQPB206INS AS INSTANCIA, AQPB206COM AS COMENTARIO, AQPB206LAT AS LATITUD, AQPB206LON AS LONGITUD, AQPB206FEC AS FECHA, 
        AQPB206HOR AS HORA, AQPB206NFO AS NRO_FOTOS, AQPB206DIR AS DIREC, AQPB206CRE AS COD_RES, AQPB206DRE AS DES_RES, AQPB206TRC AS CU_TRAN
        FROM AQPB206 
        WHERE AQPB206USU = p_s_codusu AND AQPB206CDO = p_n_coddom AND AQPB206TDO = ln_tipdoc AND AQPB206NDO = p_c_numdoc
        order by AQPB206IDL desc;*/
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerVisitas;
  
  procedure sp_obtenerVisitaFoto(p_s_codusu in varchar2,
                                        p_n_coddom in number,
                                        p_c_codtrc in varchar2,
                                        p_n_numfot in number,
                                        p_c_texfot out varchar2,
                                        p_b_fotb64 out blob,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_obtenerVisitaFoto
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Obtiene la foto registrada 
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    ln_canreg number   := 0;--
    ln_idlog  number   := 0;
    ln_idlnfo number   := 0;
    ls_codusu char(12) := '';
    ln_coddom number   := 0;
    ln_coridl number   := 0;
    --//
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := ' ';
    --//
    begin
      
      begin
        SELECT AQPB206IDL, AQPB206USU, AQPB206CDO INTO ln_idlog, ls_codusu, ln_coddom
          FROM AQPB206
          WHERE AQPB206TRC = p_c_codtrc;
      exception
        when others then
          p_c_coderr := '01209';
          p_c_msgerr := 'Código único de transacción no es válido';
      end;
      
      if ln_idlog != 0 and trim(ls_codusu) != trim(p_s_codusu) then 
        p_c_coderr := '01201';
        p_c_msgerr := 'Usuario no válido';
      end if;
      
      if ln_idlog != 0 and ln_coddom != p_n_coddom then 
        p_c_coderr := '01202';
        p_c_msgerr := 'Código de domicilio no es válido';
      end if;
      
       begin
        SELECT count(1) INTO ln_coridl 
          FROM AQPB207
          WHERE AQPB207IDL = ln_idlog and AQPB207COR = p_n_numfot;
        if ln_coridl = 0 then
          p_c_coderr := '01211';
          p_c_msgerr := 'Foto no existe';
        end if;
      end;
      
      if p_c_coderr = '00000' then
        begin
          
          SELECT AQPB207TFO, AQPB207FOT INTO p_c_texfot, p_b_fotb64
            FROM AQPB207
            WHERE AQPB207IDL = ln_idlog AND AQPB207COR = p_n_numfot;
            
        end;
      end if;

    end;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerVisitaFoto;

  procedure sp_obtenerVisitasUsuario(BL_DATOS   IN OUT SYS_REFCURSOR,
                                        p_s_codusu in varchar2,
                                        p_s_fecing in varchar2,
                                        p_n_totfot out number,
                                        p_c_realiz out number,
                                        p_c_nomusu out varchar2,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_obtenerVisitasUsuario
    -- Sistema               : BANTOTAL
    -- Módulo                : MISTI
    -- Versión               : 1.0
    -- Fecha de Creación     : 04/07/2020
    -- Autor de Creación     : CPFURO
    -- Uso                   : Retorna las visitas registradas
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
    --// Definición de Variables 
    --ln_tipdoc number := TO_NUMBER(p_c_tipdoc, '999');
    ln_pgcod number    := 0;
    ln_relus number    := 0;
    ln_tp1cod   number := 1;
    ln_tp1cod1  number := 11142;
    ln_tp1corr1 number := 1;
    ln_tp1corr2 number := 1;
    ld_fecing date     := TO_DATE(SUBSTR(p_s_fecing,1,10), 'DD-MM-YYYY');
    --lc_ubnom varchar2 := ' ';
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := ' ';
    --//
    
    begin
        SELECT PGCOD into ln_pgcod 
          FROM FST046 
          WHERE TRIM(UBUSER) = TRIM(p_s_codusu);  
        SELECT UBNOM INTO p_c_nomusu
          FROM FST746 
          WHERE TRIM(UBUSER) = TRIM(p_s_codusu);
      exception
        when others then
          p_c_coderr := '01201';
          p_c_msgerr := 'Usuario no es válido';
    end;
    
    /*begin
        SELECT PGCOD into ln_pgcod 
          FROM FST046 
          WHERE TRIM(UBUSER) = TRIM(p_s_coduss);  
      exception
        when others then
          p_c_coderr := '01207';
          p_c_msgerr := 'Usuario supervisor no es válido';
    end;
    
    begin
        SELECT COUNT(1) INTO ln_relus
          FROM SNG057 
          WHERE TRIM(SNG057USR) = TRIM(p_s_codusu) AND TRIM(SNG057JEF) = TRIM(p_s_coduss); 
          
        if ln_relus = 0 then
          p_c_coderr := '01208';
          p_c_msgerr := 'Relación usuario y usuario supervisor no es valida';
        end if;
    end;*/
    
    begin
        SELECT SUM(T1.AQPB206NFO) INTO p_n_totfot
          FROM AQPB206 T1 
          INNER JOIN XWF700 T2 ON (T2.XWFPRCINS = T1.AQPB206INS AND T2.XWFSUBOPE = 0)
          INNER JOIN FSR008 T3 ON (T3.CTNRO = T2.XWFCUENTA AND T3.CTTFIR = 'T' AND T3.TTCOD = 1)
          INNER JOIN FSD002 T4 ON (T4.PFPAIS = T3.PEPAIS AND T4.PFTDOC = T3.PETDOC AND T4.PFNDOC = T3.PENDOC)
          WHERE T1.AQPB206USU = p_s_codusu; 
          
    end;
    
    open BL_DATOS for
      
      SELECT T1.AQPB206USU AS CODUSU, T6.UBNOM AS NOMUSU, T1.AQPB206CDO AS CODDOM, T1.AQPB206TDO AS TIPDOC, T1.AQPB206NDO AS NUMDOC, T4.PFAPE1 AS APECLI, T4.PFNOM1 AS NOMCLI, T1.AQPB206CMO AS CODMOT, 
        T5.TP1DESC AS DESMOT, T1.AQPB206COM AS COMENT, T1.AQPB206LAT AS POSLAT, T1.AQPB206LON AS POSLON, (to_char(T1.AQPB206FEC, 'DD-MM-YYYY ')||T1.AQPB206HOR) AS FECHOR, 
        to_char(T1.AQPB206TST, 'DD-MM-YYYY HH24:MI:SS') AS FECENVIO, T1.AQPB206TRC AS CODTRA, T1.AQPB206DIR AS DIREGM, T1.AQPB206NFO AS NUMFOT, T1.AQPB206CRE AS CODREI, T1.AQPB206DRE AS MSGREI
        FROM AQPB206 T1 
        --INNER JOIN XWF700 T2 ON (T2.XWFPRCINS = T1.AQPB206INS AND T2.XWFSUBOPE = T1.AQPB206SBO AND T2.XWFOPERACION = T1.AQPB206OPE)
        --INNER JOIN FSR008 T3 ON (T3.CTNRO = T2.XWFCUENTA AND T3.CTTFIR = 'T' AND T3.TTCOD = 1)
        INNER JOIN FSD002 T4 ON (T4.PFPAIS = 604 AND T4.PFTDOC = T1.AQPB206TDO AND trim(T4.PFNDOC) = T1.AQPB206NDO)
        INNER JOIN FST198 T5 ON (T5.TP1COD = 1 AND T5.TP1COD1 = ln_tp1cod1 AND T5.TP1CORR1 = ln_tp1corr1 AND T5.TP1CORR2 = ln_tp1corr2 AND T5.TP1CORR3 = T1.AQPB206CMO)
        INNER JOIN FST746 T6 ON (TRIM(T6.UBUSER) = T1.AQPB206USU)
        WHERE T1.AQPB206USU = p_s_codusu AND T1.AQPB206FEC = ld_fecing;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_obtenerVisitasUsuario;
  

  /******************************************* FUNCIONES *******************************************/
  function fn_obtenerNombrePersona(p_n_codpai in number,
                                   p_n_tipdoc in number,
                                   p_c_numdoc in varchar2) return varchar2 is
    lc_nomper varchar2(100) := null;
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
  begin
    --// Inicialización 
    lc_coderr := '00000';
    lc_msgerr := '';
    --//
    select trim(pfape1) || ' ' || trim(pfape2) || ' ' || trim(pfnom1) || ' ' ||
           trim(pfnom2)
      into lc_nomper
      from fsd002 d2
     where d2.pfpais = p_n_codpai
       and d2.pftdoc = p_n_tipdoc
       and d2.pfndoc = rpad(p_c_numdoc, 12, ' ');
  
    return lc_nomper;
    --//
  exception
    when no_data_found then
      lc_coderr := '01002';
      lc_msgerr := 'Cliente no existe en Caja Arequipa';
      return lc_msgerr;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerNombrePersona;

  --//
  function fn_obtenerDireccionPersona(p_n_codpai in number,
                                      p_n_tipdoc in number,
                                      p_c_numdoc in varchar2) return varchar2 is
    lc_dirper varchar2(500) := null;
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
  begin
    --// Inicialización 
    lc_coderr := '00000';
    lc_msgerr := '';
    --//
    select trim(d1.sngc13dsc1) || ' / ' || trim(d1.sngc13dir) || ' / ' ||
           decode(trim(d1.sngc13ref1), null, 'SIN REFERENCIA',
                  trim(d1.sngc13ref)) c_dircli
      into lc_dirper
      from sngc13 d1
     where d1.sngc13pais = p_n_codpai
       and d1.sngc13tdoc = p_n_tipdoc
       and d1.sngc13ndoc = rpad(p_c_numdoc, 12, ' ')
       and d1.sngc13est = 'H'
       and d1.docod in (1, 3);
  
    return lc_dirper;
    --//
  exception
    when no_data_found then
      lc_coderr := '01002';
      lc_msgerr := 'Cliente no existe en Caja Arequipa';
      return lc_msgerr;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerDireccionPersona;

  --//
  function fn_obtenerTelefonoPersona(p_n_codpai in number,
                                     p_n_tipdoc in number,
                                     p_c_numdoc in varchar2) return varchar2 is
    lc_telper varchar2(500) := null;
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
  begin
    --// Inicialización 
    lc_coderr := '00000';
    lc_msgerr := '';
    --//
    select trim(t1.dotelfp)
      into lc_telper
      from fsr005 t1
     where t1.pepais = 604
       and t1.petdoc = 21
       and t1.pendoc = rpad(trim(p_c_numdoc), 12, ' ')
       and t1.docod in (1, 3)
       and rownum <= 1;
  
    return lc_telper;
    --//
  exception
    when no_data_found then
      lc_coderr := '01002';
      lc_msgerr := 'Cliente no existe en Caja Arequipa';
      return lc_msgerr;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerTelefonoPersona;

  --//
  function fn_obtenerVariacionMontos return number is
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
    ln_varmon number := 0;
  begin
    --//
    select t1.tp1nro1
      into ln_varmon
      from fst198 t1
     where t1.tp1cod1 = 10801
       and t1.tp1corr1 = 315
       and t1.tp1corr2 = 1
       and t1.tp1corr3 = 1;
  
    return ln_varmon;
  
  exception
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerVariacionMontos;

  --//
  function fn_obtenerDesgravamen return number is
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
    ln_desgra number := 0;
  begin
    --//
    select t1.tp1imp1
      into ln_desgra
      from fst198 t1
     where t1.tp1cod1 = 10801
       and t1.tp1corr1 = 315
       and t1.tp1corr2 = 1
       and t1.tp1corr3 = 2;
  
    return ln_desgra;
  
  exception
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerDesgravamen;
  --//  

  function fn_obtenerVariacionDesgravamen return number is
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
    ln_vardes number := 0;
  begin
    --//
    select t1.tp1imp1
      into ln_vardes
      from fst198 t1
     where t1.tp1cod1 = 10801
       and t1.tp1corr1 = 315
       and t1.tp1corr2 = 1
       and t1.tp1corr3 = 4;
  
    return ln_vardes;
  
  exception
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerVariacionDesgravamen;

  function fn_obtenerVariacionCuotas return number is
    lc_coderr varchar2(5) := '00000';
    lc_msgerr varchar2(1000) := '';
    ln_varcuo number := 0;
  begin
    --//
    select t1.tp1nro1
      into ln_varcuo
      from fst198 t1
     where t1.tp1cod1 = 10801
       and t1.tp1corr1 = 315
       and t1.tp1corr2 = 1
       and t1.tp1corr3 = 3;
  
    return ln_varcuo;
  
  exception
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      return lc_msgerr;
  end fn_obtenerVariacionCuotas;
  --//

  function fn_obtenerCalificacionConsumo(p_n_codpai number,
                                         p_n_tipdoc number,
                                         p_c_numdoc varchar2) return varchar2 is
  
    lc_calcli varchar2(100);
  begin
    lc_calcli := null;
  
    begin
      -- Call the procedure
      pq_cr_segment_cons_aplic.sp_carga_data(pd_fecpro => trunc(sysdate),
                                             --fecha de proceso
                                             pn_pai => p_n_codpai,
                                             --pais
                                             pn_tdo => p_n_tipdoc,
                                             --tipo de documento
                                             pc_doc => p_c_numdoc,
                                             --nro de documento
                                             pc_usr => 'RDSBMOBILE');
      --usuario que esta ejecuta
    
    exception
      when others then
        null;
    end;
  
    select b.jaqz662ncal
      into lc_calcli
      from JAQZ663_APL a
     inner join JAQZ662 b
        on a.jaqz663calf = b.jaqz662ccal
     where a.jaqz663paic = p_n_codpai
       and a.jaqz663tdoc = p_n_tipdoc
       and a.jaqz663tndoc = rpad(trim(p_c_numdoc), 12, ' ')
       and a.jaqz663usr = 'RDSBMOBILE';
  
  exception
    when others then
      return lc_calcli;
  end fn_obtenerCalificacionConsumo;

end PQ_AR_MISTI;
/

