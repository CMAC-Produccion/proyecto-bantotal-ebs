create or replace package pq_cr_aprob_reprogramaciones is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_APROB_REPROGRAMACIONES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 26.03.2024
  -- Autor de Creación          : Alexander Acuña Ramirez
  -- Uso                        : Extrae información sobre créditos sin capitalización para aprobar reprogramaciones
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 19.04.2024
  -- Autor de Modificación      : Alexander Acuña Ramirez
  -- Descripción de Modificación: Se agregaron procedimientos para obtener datos adicionales(Fecha cuota impaga actual y 
  -- Fecha vencimiento anterior) 
  -- Fecha de Modificación      : 28.08.2024
  -- Autor de Modificación      : Clinton Alarcon Apaza
  -- Descripción de Modificación: Se reemplazo funcion 'fn_dias_atraso' por 'fn_dias_atraso_rpc' para casos de reprogramaciones
  -- 
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


PROCEDURE sp_cr_obtener_informacion_reprogramaciones(P_INSTANCIA              IN NUMBER,
                                                     O_NRO_REPROGRAMACION     OUT NUMBER,
                                                     O_FECHA_OTORGAMIENTO     OUT DATE,
                                                     O_MONTO                  OUT NUMBER,
                                                     O_PLAZO                  OUT NUMBER,
                                                     O_DIAS_ATRASO            OUT NUMBER,
                                                     O_ANALISIS_OBSERVACION   OUT VARCHAR2,
                                                     O_DESTINO_OBSERVACION    OUT VARCHAR2,
                                                     O_VOLUNTAD_OBSERVACION   OUT VARCHAR2,
                                                     CODMSG OUT VARCHAR2,
                                                     DESMSG OUT VARCHAR2);

PROCEDURE sp_cr_clave_credito(  P_INSTANCIA      IN NUMBER,
                                O_EMPRESA        OUT NUMBER,
                                O_MODULO         OUT NUMBER,
                                O_SUCURSAL       OUT NUMBER,
                                O_MONEDA         OUT NUMBER,
                                O_PAPEL          OUT NUMBER,
                                O_CUENTA         OUT NUMBER,
                                O_OPERACION      OUT NUMBER,
                                O_SUBOPERACION   OUT NUMBER,
                                O_TIPO_OPERACION OUT NUMBER,
                                CODMSG OUT VARCHAR2,
                                DESMSG OUT VARCHAR2);

PROCEDURE sp_cr_obtener_fecha_otorgamiento(P_EMPRESA            IN NUMBER,
                                           P_MODULO             IN NUMBER,
                                           P_SUCURSAL           IN NUMBER,
                                           P_MONEDA             IN NUMBER,
                                           P_PAPEL              IN NUMBER,
                                           P_CUENTA             IN NUMBER,
                                           P_OPERACION          IN NUMBER,
                                           P_SUBOPERACION       IN NUMBER,
                                           P_TIPO_OPERACION     IN NUMBER,
                                           O_FECHA_OTORGAMIENTO OUT DATE,
                                           CODMSG OUT VARCHAR2,
                                           DESMSG OUT VARCHAR2);
                                          
PROCEDURE sp_cr_obtener_montos_y_plazo(P_EMPRESA IN NUMBER,
                                       P_MODULO  IN NUMBER,
                                       P_SUCURSAL  IN NUMBER,
                                       P_MONEDA  IN NUMBER,
                                       P_PAPEL IN NUMBER,
                                       P_CUENTA IN NUMBER,
                                       P_OPERACION IN NUMBER,
                                       P_TIPO_OPERACION IN NUMBER,
                                       O_MONTO OUT NUMBER,
                                       O_PLAZO OUT NUMBER,
                                       CODMSG OUT VARCHAR2,
                                       DESMSG OUT VARCHAR2);

PROCEDURE sp_cr_obtener_observaciones(P_INSTANCIA      IN NUMBER,
                                      O_ANALISIS_OBSERVACION OUT VARCHAR2,
                                      O_DESTINO_OBSERVACION  OUT VARCHAR2,
                                      O_VOLUNTAD_OBSERVACION OUT VARCHAR2,
                                      CODMSG OUT VARCHAR2,
                                      DESMSG OUT VARCHAR2);
                                      
PROCEDURE sp_cr_obtener_fecha_cuota_impaga( P_INSTANCIA      IN NUMBER,
                                            O_FEC_CUO_IMPAGA OUT DATE,
                                            CODMSG           OUT VARCHAR2,
                                            DESMSG           OUT VARCHAR2);
                                            
PROCEDURE sp_cr_obtener_fecha_vencimiento_anterior( P_INSTANCIA      IN NUMBER,
                                                    O_FEC_VEN_ANT OUT DATE,
                                                    CODMSG           OUT VARCHAR2,
                                                    DESMSG           OUT VARCHAR2);

PROCEDURE sp_cr_monto_desembolsado(P_INSTANCIA      IN NUMBER,
                                   O_MONTO_DESEM    OUT NUMBER,
                                   CODMSG           OUT VARCHAR2,
                                   DESMSG           OUT VARCHAR2);
 
PROCEDURE sp_cr_obtener_cuota_anterior(P_INSTANCIA IN NUMBER,
                                       O_CUOTA     OUT NUMBER,
                                       CODMSG      OUT VARCHAR2,
                                       DESMSG      OUT VARCHAR2);

PROCEDURE sp_cr_obtener_cuota_nueva(P_INSTANCIA IN NUMBER,
                                    O_CUOTA     OUT NUMBER,
                                    CODMSG      OUT VARCHAR2,
                                    DESMSG      OUT VARCHAR2);
PROCEDURE sp_cr_obtener_cuotas_anteriores(P_INSTANCIA IN NUMBER,
                                          O_CUOTAS     OUT NUMBER,
                                          CODMSG      OUT VARCHAR2,
                                          DESMSG      OUT VARCHAR2);
PROCEDURE sp_cr_obtener_cuotas_propuestas(P_INSTANCIA IN NUMBER,
                                   O_CUOTAS    OUT NUMBER,
                                   CODMSG      OUT VARCHAR2,
                                   DESMSG      OUT VARCHAR2);

                                   
end pq_cr_aprob_reprogramaciones;
/

create or replace package body pq_cr_aprob_reprogramaciones is

PROCEDURE sp_cr_clave_credito(P_INSTANCIA      IN NUMBER,
                                O_EMPRESA        OUT NUMBER,
                                O_MODULO         OUT NUMBER,
                                O_SUCURSAL       OUT NUMBER,
                                O_MONEDA         OUT NUMBER,
                                O_PAPEL          OUT NUMBER,
                                O_CUENTA         OUT NUMBER,
                                O_OPERACION      OUT NUMBER,
                                O_SUBOPERACION   OUT NUMBER,
                                O_TIPO_OPERACION OUT NUMBER,
                                CODMSG OUT VARCHAR2,
                                DESMSG OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_clave_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26.03.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Devuelve la clave del crédito basandose en la instancia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA(Instancia)
    -- Retorno                    : O_EMPRESA ( Código de empresa )
    --                              O_MODULO ( Módulo )
    --                              O_SUCURSAL ( Sucursal )
    --                              O_MONEDA ( Moneda )
    --                              O_PAPEL ( Papel )
    --                              O_CUENTA ( Cuenta )
    --                              O_OPERACION ( Operación )
    --                              O_SUBOPERACION ( Suboperacion )
    --                              O_TIPO_OPERACION ( Tipo de operación )
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
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
        into O_EMPRESA,
             O_MODULO,
             O_SUCURSAL,
             O_MONEDA,
             O_PAPEL,
             O_CUENTA,
             O_OPERACION,
             O_SUBOPERACION,
             O_TIPO_OPERACION
        from xwf700
       where xwfprcins = P_INSTANCIA
         and xwfcar3 = '1';
    exception
      when NO_DATA_FOUND  then
        CODMSG := '001';
        DESMSG := 'Clave de crédito no encontrada';
      when others then
        CODMSG := '999';
        DESMSG := 'Error desconocido al realizar la consulta';
    end;
  
  END sp_cr_clave_credito;

PROCEDURE sp_cr_obtener_fecha_otorgamiento(
                                          P_EMPRESA IN NUMBER,
                                          P_MODULO  IN NUMBER,
                                          P_SUCURSAL  IN NUMBER,
                                          P_MONEDA  IN NUMBER,
                                          P_PAPEL IN NUMBER,
                                          P_CUENTA IN NUMBER,
                                          P_OPERACION IN NUMBER,
                                          P_SUBOPERACION IN NUMBER,
                                          P_TIPO_OPERACION IN NUMBER,
                                          O_FECHA_OTORGAMIENTO OUT DATE,
                                          CODMSG OUT VARCHAR2,
                                          DESMSG OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_fecha_otorgamiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26.03.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la fecha de otorgamiento del crédito usando la clave del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_EMPRESA (Codigo de empresa)
    --                              P_MODULO ( Módulo )
    --                              P_SUCURSAL ( Sucursal )
    --                              P_MONEDA ( Moneda )
    --                              P_PAPEL ( Papel )
    --                              P_CUENTA ( Cuenta )
    --                              P_OPERACION ( Operación )
    --                              P_SUBOPERACION ( Suboperacion )
    --                              P_TIPO_OPERACION ( Tipo de operación )
    -- Retorno                    : O_FECHA_OTORGAMIENTO ( Fecha de otorgamiento del credito )
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
   
   BEGIN
     
          begin
              select AOFVAL into O_FECHA_OTORGAMIENTO
                             from fsd010 f 
                             where f.pgcod = P_EMPRESA and 
                             f.aomod = P_MODULO and
                             f.aosuc = P_SUCURSAL and
                             f.aomda = P_MONEDA and
                             f.aopap = P_PAPEL and
                             f.aocta = P_CUENTA and
                             f.aooper =  P_OPERACION and
                             f.aosbop = P_SUBOPERACION and
                             f.aotope = P_TIPO_OPERACION;  
          exception
            when NO_DATA_FOUND  then
              CODMSG := '001';
              DESMSG := 'Fecha de otorgamiento del crédito no encontrada';
          end;
  END sp_cr_obtener_fecha_otorgamiento;

PROCEDURE sp_cr_obtener_montos_y_plazo(P_EMPRESA IN NUMBER,
                                          P_MODULO  IN NUMBER,
                                          P_SUCURSAL  IN NUMBER,
                                          P_MONEDA  IN NUMBER,
                                          P_PAPEL IN NUMBER,
                                          P_CUENTA IN NUMBER,
                                          P_OPERACION IN NUMBER,
                                          P_TIPO_OPERACION IN NUMBER,
                                          O_MONTO OUT NUMBER,
                                          O_PLAZO OUT NUMBER,
                                          CODMSG OUT VARCHAR2,
                                          DESMSG OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_montos_y_plazo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26.03.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna el monto y plazo del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_EMPRESA (Codigo de empresa)
    --                              P_MODULO ( Módulo )
    --                              P_SUCURSAL ( Sucursal )
    --                              P_MONEDA ( Moneda )
    --                              P_PAPEL ( Papel )
    --                              P_CUENTA ( Cuenta )
    --                              P_OPERACION ( Operación )
    --                              P_TIPO_OPERACION ( Tipo de operación )
    -- Retorno                    : O_MONTO ( Monto del credito )
    --                              O_PLAZO ( Plazo del credito )
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                           
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
   
   BEGIN
          
          --- Monto ---
          begin
               select x.xllcapital 
                    into 
                    O_MONTO
                    from x054023 x
                    where 
                    x.xllpgcod = P_EMPRESA and
                    x.xllaomod = P_MODULO and
                    x.xllaosuc = P_SUCURSAL and
                    x.xllaomda = P_MONEDA and
                    x.xllaopap = P_PAPEL and
                    x.xllaocta = P_CUENTA and
                    x.xllaooper = P_OPERACION and
                    X.XLLAOSBOP = 609 AND
                    x.xllaotop = P_TIPO_OPERACION; 
          exception
            when NO_DATA_FOUND  then
              CODMSG := '001';
              DESMSG := 'Monto del crédito no encontrada';
          end;
          
          
          --- Plazo ---
          
          begin
              select NVL(SUM(F.PPPZO),0)
                    into
                    O_PLAZO
                    from FSD601 F
                    where 
                    F.PGCOD = P_EMPRESA and
                    F.PPMOD = P_MODULO and
                    F.PPSUC = P_SUCURSAL and
                    F.PPMDA = P_MONEDA and
                    F.PPPAP = P_PAPEL and
                    F.PPCTA = P_CUENTA and
                    F.PPOPER = P_OPERACION and
                    F.PPSBOP = 609 and
                    F.PPTOPE = P_TIPO_OPERACION;    
          exception  
            when NO_DATA_FOUND  then
              CODMSG := '001';
              DESMSG := 'Plazo del crédito no encontrada';
          end;          
END sp_cr_obtener_montos_y_plazo;



PROCEDURE sp_cr_obtener_observaciones(P_INSTANCIA      IN NUMBER,
                                      O_ANALISIS_OBSERVACION OUT VARCHAR2,
                                      O_DESTINO_OBSERVACION  OUT VARCHAR2,
                                      O_VOLUNTAD_OBSERVACION OUT VARCHAR2,
                                      CODMSG              OUT VARCHAR2,
                                      DESMSG              OUT VARCHAR2)
                                                     IS
     -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_observaciones
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05.03.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna las observaciones de un crédito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA(Instancia)
    --
    -- Retorno                    : O_ANALISIS_OBSERVACION(Observaciones analisis)
    --                              O_DESTINO_OBSERVACION (Destino del credito)
    --                              O_VOLUNTAD_OBSERVACION (Voluntad de pago)
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************    
    aqpb556_cod aqpb556.aqpb556cod%type;
    aqpb556_fecr aqpb556.aqpb556fecr%type;

                      
    BEGIN
     begin
       
       -- Seleccionamos ultimo codigo de credito --
       select max(aqpb556cod) 
              into aqpb556_cod 
              from aqpb556 where aqpb556inst = P_INSTANCIA;
       
       -- Seleccionamos la última fecha
       
       SELECT aqpb556fecr into aqpb556_fecr FROM aqpb556 WHERE aqpb556cod = aqpb556_cod;
       
       -- Seleccionamos observaciones
     
       select jaqa400aec, -- Análisis de indicadores
              jaqa400dcr, -- Destino y recomendación del crédito
              jaqa400vpg  -- Voluntad de pago
              into 
              O_ANALISIS_OBSERVACION,
              O_DESTINO_OBSERVACION,
              O_VOLUNTAD_OBSERVACION
      from jaqa400
      where
           jaqa400fec = aqpb556_fecr and
           jaqa400ai1 = P_INSTANCIA;
      exception
        when NO_DATA_FOUND  then
              CODMSG := '001';
              DESMSG := 'Observaciones no encontradas';
      end;
END sp_cr_obtener_observaciones;
  
    

PROCEDURE sp_cr_obtener_fecha_cuota_impaga( P_INSTANCIA      IN NUMBER,
                                            O_FEC_CUO_IMPAGA OUT DATE,
                                            CODMSG OUT VARCHAR2,
                                            DESMSG OUT VARCHAR2)
                                            IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_fecha_cuota_impaga
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la fecha de cuota impaga actual.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA(Instancia)
    -- Retorno                    : O_FEC_CUO_IMPAGA ( Fecha de cuota  )
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                       
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;  
    fsd602_date fsd602.pp1fech%type;   
    BEGIN
      begin
        -- Obtenemos clave del crédito
        pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                         vi_pgcod,
                                                         vi_aomod,
                                                         vi_aosuc,
                                                         vi_aomda,
                                                         vi_aopap,
                                                         vi_aocta,
                                                         vi_aooper,
                                                         vi_aosbop,
                                                         vi_aotope,
                                                         CODMSG,
                                                         DESMSG);
                                                         
        select max(ppfpag) into fsd602_date from fsd602 where 
               pgcod  = vi_pgcod and
               ppmod  = vi_aomod and
               ppsuc  = vi_aosuc and
               ppmda  = vi_aomda and
               pppap  = vi_aopap and
               ppcta  = vi_aocta and
               ppoper = vi_aooper and
               ppsbop = vi_aosbop and
               pptope = vi_aotope and
               pp1stat = 'T' and
               D602CO = 'S';
               
          SELECT Min(ppfvto) into O_FEC_CUO_IMPAGA
                FROM fsd601
                WHERE 
                    pgcod  = vi_pgcod AND
                    ppmod  = vi_aomod AND
                    ppsuc  = vi_aosuc AND
                    ppmda  = vi_aomda AND
                    pppap  = vi_aopap AND
                    ppcta  = vi_aocta AND
                    ppoper = vi_aooper AND
                    ppsbop = vi_aosbop AND
                    pptope = vi_aotope AND
                    ppfvto > fsd602_date;
      
      exception
        when TOO_MANY_ROWS then
              CODMSG := '002';
              DESMSG := 'Más de un registro encontrado para los criterios dados.';
        when NO_DATA_FOUND  then
              CODMSG := '001';
              DESMSG := 'Observaciones no encontradas';
      end;
    END sp_cr_obtener_fecha_cuota_impaga;

PROCEDURE sp_cr_obtener_fecha_vencimiento_anterior(
    P_INSTANCIA      IN NUMBER,
    O_FEC_VEN_ANT OUT DATE,
    CODMSG           OUT VARCHAR2,
    DESMSG           OUT VARCHAR2
) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_fecha_vencimiento_anterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la fecha de vencimiento del ultimo pago del cronograma actual.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA(Instancia)
    -- Retorno                    : O_FEC_VEN_ANT ( Fecha de vencimiento  )
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                       
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************  
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
BEGIN
    -- Obtenemos llave del crédito
    pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(
        P_INSTANCIA,
        vi_pgcod,
        vi_aomod,
        vi_aosuc,
        vi_aomda,
        vi_aopap,
        vi_aocta,
        vi_aooper,
        vi_aosbop,
        vi_aotope,
        CODMSG,
        DESMSG
    );

    -- Buscamos la fecha de vencimiento anterior
    SELECT MAX(ppfvto) INTO O_FEC_VEN_ANT
    FROM fsd601
    WHERE 
        pgcod = vi_pgcod AND
        ppmod = vi_aomod AND
        ppsuc = vi_aosuc AND
        ppmda = vi_aomda AND
        pppap = vi_aopap AND
        ppcta = vi_aocta AND
        ppoper = vi_aooper AND
        ppsbop = vi_aosbop AND
        pptope = vi_aotope;

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        CODMSG := '002';
        DESMSG := 'Más de un registro encontrado para los criterios dados.';
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM;
END sp_cr_obtener_fecha_vencimiento_anterior;


PROCEDURE sp_cr_monto_desembolsado(P_INSTANCIA      IN NUMBER,
                                   O_MONTO_DESEM    OUT NUMBER,
                                   CODMSG           OUT VARCHAR2,
                                   DESMSG           OUT VARCHAR2)
                                   IS
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;                                  
BEGIN
    -- Obtenemos llave del crédito
    pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(
        P_INSTANCIA,
        vi_pgcod,
        vi_aomod,
        vi_aosuc,
        vi_aomda,
        vi_aopap,
        vi_aocta,
        vi_aooper,
        vi_aosbop,
        vi_aotope,
        CODMSG,
        DESMSG
    );
    
    select AOIMP into O_MONTO_DESEM from fsd010
    where 
        pgcod  = vi_pgcod and
        aomod  = vi_aomod and
        aosuc  = vi_aosuc and
        aomda  = vi_aomda and
        aopap  = vi_aopap and
        aocta  = vi_aocta and 
        aooper = vi_aooper and
        aosbop = vi_aosbop and 
        aotope = vi_aotope;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        CODMSG := '002';
        DESMSG := 'Más de un registro encontrado para los criterios dados.';
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM; 
END sp_cr_monto_desembolsado;

PROCEDURE sp_cr_obtener_informacion_reprogramaciones(P_INSTANCIA          IN NUMBER,
                                                     O_NRO_REPROGRAMACION OUT NUMBER,
                                                     O_FECHA_OTORGAMIENTO OUT DATE,
                                                     O_MONTO              OUT NUMBER,
                                                     O_PLAZO              OUT NUMBER,
                                                     O_DIAS_ATRASO        OUT NUMBER,
                                                     O_ANALISIS_OBSERVACION   OUT VARCHAR2,
                                                     O_DESTINO_OBSERVACION    OUT VARCHAR2,
                                                     O_VOLUNTAD_OBSERVACION   OUT VARCHAR2,
                                                     CODMSG               OUT VARCHAR2,
                                                     DESMSG               OUT VARCHAR2)
                                                     IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_informacion_reprogramaciones
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26.03.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna el numero de reprogramaciones, fecha de otorgamiento
    --                              Monto, Plazo, Dias de atraso y propuesta del credito.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA ( Instancia del crédito )
    --
    -- Retorno                    : O_NRO_REPROGRAMACION ( Numero de reprogramaciones )
    --                              O_FECHA_OTORGAMIENTO ( Fecha de otorgamiento del credito )
    --                              O_MONTO ( Monto del credito )
    --                              O_PLAZO ( Plazo de credito )
    --                              O_DIAS_ATRASO ( Dias de atraso del credito )
    --                              O_PROPUESTA ( Propuesta del credito )    
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
                                       
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;  
     vi_date DATE;  
                               
    BEGIN
     begin


        pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                         vi_pgcod,
                                                         vi_aomod,
                                                         vi_aosuc,
                                                         vi_aomda,
                                                         vi_aopap,
                                                         vi_aocta,
                                                         vi_aooper,
                                                         vi_aosbop,
                                                         vi_aotope,
                                                         CODMSG,
                                                         DESMSG);
                              
        pq_cr_aprob_reprogramaciones.sp_cr_obtener_fecha_otorgamiento(vi_pgcod,
                                                                       vi_aomod,
                                                                       vi_aosuc,
                                                                       vi_aomda,
                                                                       vi_aopap,
                                                                       vi_aocta,
                                                                       vi_aooper,
                                                                       vi_aosbop,
                                                                       vi_aotope,
                                                                       O_FECHA_OTORGAMIENTO,
                                                                       CODMSG,
                                                                       DESMSG);
                                      
         pq_cr_aprob_reprogramaciones.sp_cr_obtener_montos_y_plazo(vi_pgcod,
                                                                   vi_aomod,
                                                                   vi_aosuc,
                                                                   vi_aomda,
                                                                   vi_aopap,
                                                                   vi_aocta,
                                                                   vi_aooper,
                                                                   vi_aotope,
                                                                   O_MONTO,
                                                                   O_PLAZO,
                                                                   CODMSG,
                                                                   DESMSG);
         

         pq_cr_validar_rng_reprog.SP_VALIDAR_NRO_REPROGN(P_INSTANCIA, O_NRO_REPROGRAMACION);
         
         pq_cr_aprob_reprogramaciones.sp_cr_obtener_observaciones(P_INSTANCIA,
                                                              O_ANALISIS_OBSERVACION,
                                                              O_DESTINO_OBSERVACION,
                                                              O_VOLUNTAD_OBSERVACION,
                                                              CODMSG,
                                                              DESMSG);
                                                              

                                    
         -- Fecha de sistema ---                    
         select pgfape into vi_date from fst017 where pgcod = 1;
                           
         O_DIAS_ATRASO := fn_dias_atraso_rpc(vi_date,
                                         vi_pgcod,
                                         vi_aomod,
                                         vi_aosuc,
                                         vi_aomda,
                                         vi_aopap,
                                         vi_aocta,
                                         vi_aooper,
                                         vi_aosbop,
                                         vi_aotope,
                                         null,
                                         null);
                                         
         
      exception
        when others then
             CODMSG := '999';
             DESMSG := 'Error desconocido al momento de ejecutar la consulta';
         
      end;
     
      

    END sp_cr_obtener_informacion_reprogramaciones;
    
    
PROCEDURE sp_cr_obtener_cuota_anterior(P_INSTANCIA IN NUMBER,
                                      O_CUOTA     OUT NUMBER,
                                      CODMSG      OUT VARCHAR2,
                                      DESMSG      OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_cuota_anterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la cuota anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA ( Instancia del crédito )
    --
    -- Retorno                    : O_CUOTA ( Cuota anterior )    
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
    -- Variables --
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;  
    vi_date DATE;
    vi_cap NUMBER;
    vi_seg NUMBER; 
    
    BEGIN
      -- Clave del Crédito --
      pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                         vi_pgcod,
                                                         vi_aomod,
                                                         vi_aosuc,
                                                         vi_aomda,
                                                         vi_aopap,
                                                         vi_aocta,
                                                         vi_aooper,
                                                         vi_aosbop,
                                                         vi_aotope,
                                                         CODMSG,
                                                         DESMSG);  
      select   COALESCE(MAX(ppfpag), TO_DATE('01/01/1900', 'mm/dd/yyyy')) into vi_date from fsd602 where 
               pgcod  = vi_pgcod and
               ppmod  = vi_aomod and
               ppsuc  = vi_aosuc and
               ppmda  = vi_aomda and
               pppap  = vi_aopap and
               ppcta  = vi_aocta and
               ppoper = vi_aooper and
               ppsbop = vi_aosbop and
               pptope = vi_aotope and
               pp1stat = 'T' and
               D602CO = 'S';
      
      -- Cuota Impaga ---         
      select NVL((PPCAP + PPINT), 0) into vi_cap
             from fsd601
             where 
             pgcod  = vi_pgcod and
             ppmod  = vi_aomod and
             ppsuc  = vi_aosuc and
             ppmda  = vi_aomda and
             pppap  = vi_aopap and
             ppcta  = vi_aocta and
             ppoper = vi_aooper and
             ppsbop = vi_aosbop and
             pptope = vi_aotope and
             ppfvto > vi_date and
             ROWNUM = 1
             ORDER BY ppfvto ASC;
      

      --sEGUROS 
      select NVL((PPIMP10 + 
                  PPIMP11 + 
                  PPIMP12 + 
                  PPIMP13 + 
                  PPIMP14 + 
                  PPIMP15 + 
                  PPIMP16 + 
                  PPIMP17 + 
                  PPIMP18 + 
                  PPIMP19 + 
                  PPIMP20), 0) into vi_seg
      from FSD611 b
      where 
        b.PGCOD = vi_pgcod and
        b.PPMOD = vi_aomod and
        b.PPSUC = vi_aosuc and
        b.PPMDA = vi_aomda and
        b.PPPAP = vi_aopap and
        b.PPCTA = vi_aocta and
        b.PPOPER = vi_aooper and
        b.PPSBOP = vi_aosbop and
        b.PPTOPE = vi_aotope and
        b.ppfpag > vi_date and 
        ROWNUM = 1
       order by b.PPFPAG asc;
       
       O_CUOTA := NVL((vi_cap + vi_seg), 0);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        CODMSG := '002';
        DESMSG := 'Más de un registro encontrado para los criterios dados.';
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM; 
    
END sp_cr_obtener_cuota_anterior;
       
PROCEDURE sp_cr_obtener_cuota_nueva(P_INSTANCIA IN NUMBER,
                                    O_CUOTA     OUT NUMBER,
                                    CODMSG      OUT VARCHAR2,
                                    DESMSG      OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_cuota_nueva
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la cuota nueva
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA ( Instancia del crédito )
    --
    -- Retorno                    : O_CUOTA ( Cuota nueva )    
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
    -- Variables --
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;  
    vi_date DATE;
    vi_cap NUMBER;
    vi_seg NUMBER; 
    
    BEGIN
      -- Clave del Crédito --
      pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                         vi_pgcod,
                                                         vi_aomod,
                                                         vi_aosuc,
                                                         vi_aomda,
                                                         vi_aopap,
                                                         vi_aocta,
                                                         vi_aooper,
                                                         vi_aosbop,
                                                         vi_aotope,
                                                         CODMSG,
                                                         DESMSG);  
      select   COALESCE(MAX(ppfpag), TO_DATE('01/01/1900', 'mm/dd/yyyy')) into vi_date from fsd602 where 
               pgcod  = vi_pgcod and
               ppmod  = vi_aomod and
               ppsuc  = vi_aosuc and
               ppmda  = vi_aomda and
               pppap  = vi_aopap and
               ppcta  = vi_aocta and
               ppoper = vi_aooper and
               ppsbop = vi_aosbop and
               pptope = vi_aotope and
               pp1stat = 'T' and
               D602CO = 'S';
      
      -- Cuota Impaga ---         
      select nvl((PPCAP + PPINT), 0) into vi_cap
             from fsd601
             where 
             pgcod  = vi_pgcod and
             ppmod  = vi_aomod and
             ppsuc  = vi_aosuc and
             ppmda  = vi_aomda and
             pppap  = vi_aopap and
             ppcta  = vi_aocta and
             ppoper = vi_aooper and
             ppsbop = 609 and
             pptope = vi_aotope and
             ppfvto > vi_date and
             ROWNUM = 1
             ORDER BY ppfvto ASC;
      

      --sEGUROS 
      select nvl((PPIMP10 + 
                  PPIMP11 + 
                  PPIMP12 + 
                  PPIMP13 + 
                  PPIMP14 + 
                  PPIMP15 + 
                  PPIMP16 + 
                  PPIMP17 + 
                  PPIMP18 + 
                  PPIMP19 + 
                  PPIMP20),0) into vi_seg
      from FSD611 b
      where 
        b.PGCOD = vi_pgcod and
        b.PPMOD = vi_aomod and
        b.PPSUC = vi_aosuc and
        b.PPMDA = vi_aomda and
        b.PPPAP = vi_aopap and
        b.PPCTA = vi_aocta and
        b.PPOPER = vi_aooper and
        b.PPSBOP = 609 and
        b.PPTOPE = vi_aotope and
        ROWNUM = 1
       order by b.PPFPAG asc;
       
       O_CUOTA := nvl((vi_cap + vi_seg),0);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        CODMSG := '002';
        DESMSG := 'Más de un registro encontrado para los criterios dados.';
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM; 
    
END sp_cr_obtener_cuota_nueva;

PROCEDURE sp_cr_obtener_cuotas_anteriores(P_INSTANCIA IN NUMBER,
                                          O_CUOTAS     OUT NUMBER,
                                          CODMSG      OUT VARCHAR2,
                                          DESMSG      OUT VARCHAR2)
                                          IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_cuotas_anteriores
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la cantidad de cuotas vigentes antes de reprogramación
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA ( Instancia del crédito )
    --
    -- Retorno                    : O_CUOTA ( Cuota nueva )    
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
vi_pgcod xwf700.xwfempresa%type;
vi_aomod xwf700.xwfmodulo%type;
vi_aosuc xwf700.xwfsucursal%type;
vi_aomda xwf700.xwfmoneda%type;
vi_aopap xwf700.xwfpapel%type;
vi_aocta xwf700.xwfcuenta%type;
vi_aooper xwf700.xwfoperacion%type;
vi_aosbop xwf700.xwfsubope%type;
vi_aotope xwf700.xwftipope%type;  
vi_date DATE;
BEGIN
  -- Obtenemos clave del crédito
  pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                   vi_pgcod,
                                                   vi_aomod,
                                                   vi_aosuc,
                                                   vi_aomda,
                                                   vi_aopap,
                                                   vi_aocta,
                                                   vi_aooper,
                                                   vi_aosbop,
                                                   vi_aotope,
                                                   CODMSG,
                                                   DESMSG);
  

  
  
  select PPFPAG into vi_date
  from fsd602 where
        pgcod = vi_pgcod 
    and ppmod = vi_aomod 
    and ppsuc = vi_aosuc
    and ppmda = vi_aomda
    and pppap = vi_aopap
    and ppcta = vi_aocta
    and ppoper = vi_aooper
    and ppsbop = vi_aosbop
    and pp1stat='T' 
    and d602co='S'
    order by PPFPAG desc
    FETCH FIRST 1 ROW ONLY;
  
  
  select count(*) into O_CUOTAS from fsd601 
  where 
        pgcod = vi_pgcod 
    and ppmod = vi_aomod 
    and ppsuc = vi_aosuc
    and ppmda = vi_aomda
    and pppap = vi_aopap
    and ppcta = vi_aocta
    and ppoper = vi_aooper
    and ppsbop = vi_aosbop
    and ppfpag > vi_date;

  
  

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM;   
END sp_cr_obtener_cuotas_anteriores;

PROCEDURE sp_cr_obtener_cuotas_propuestas(P_INSTANCIA IN NUMBER,
                                          O_CUOTAS     OUT NUMBER,
                                          CODMSG      OUT VARCHAR2,
                                          DESMSG      OUT VARCHAR2)
                                          IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_cuotas_anteriores
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Retorna la cantidad de cuotas de reprogramación
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_INSTANCIA ( Instancia del crédito )
    --
    -- Retorno                    : O_CUOTA ( Cuota nueva )    
    --
    --                              CODMSG ( Codigo de error )
    --                              DESMSG ( Mensaje de error complementario )                      
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
vi_pgcod xwf700.xwfempresa%type;
vi_aomod xwf700.xwfmodulo%type;
vi_aosuc xwf700.xwfsucursal%type;
vi_aomda xwf700.xwfmoneda%type;
vi_aopap xwf700.xwfpapel%type;
vi_aocta xwf700.xwfcuenta%type;
vi_aooper xwf700.xwfoperacion%type;
vi_aosbop xwf700.xwfsubope%type;
vi_aotope xwf700.xwftipope%type; 
vi_date DATE; 
BEGIN
  -- Obtenemos clave del crédito
  pq_cr_aprob_reprogramaciones.sp_cr_clave_credito(P_INSTANCIA,
                                                   vi_pgcod,
                                                   vi_aomod,
                                                   vi_aosuc,
                                                   vi_aomda,
                                                   vi_aopap,
                                                   vi_aocta,
                                                   vi_aooper,
                                                   vi_aosbop,
                                                   vi_aotope,
                                                   CODMSG,
                                                   DESMSG);
                                                   
  select count(*) into O_CUOTAS
  from fsd601 
  where pgcod = vi_pgcod 
    and ppmod = vi_aomod 
    and ppsuc = vi_aosuc
    and ppmda = vi_aomda
    and pppap = vi_aopap
    and ppcta = vi_aocta
    and ppoper = vi_aooper
    and ppsbop = 609
  order by ppfval asc;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        CODMSG := '001';
        DESMSG := 'No se encontraron datos para los criterios especificados.';
    WHEN OTHERS THEN
        CODMSG := '999';
        DESMSG := 'Error desconocido: ' || SQLERRM;   
END sp_cr_obtener_cuotas_propuestas; 
   
   
end pq_cr_aprob_reprogramaciones;
/

