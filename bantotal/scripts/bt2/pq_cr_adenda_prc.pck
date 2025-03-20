create or replace package PQ_CR_ADENDA_PRC is

-- *****************************************************************
-- Nombre   : PQ_CR_ADENDA_PRC
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 20/02/2023
-- Autor de Creación  : HSUAREZ
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************
   procedure sp_cr_enviar_mail_rrhh(
                                     VE_INSTANCIA IN NUMBER,
                                     VE_ARCHIVO IN VARCHAR,
                                     VO_COD_ERROR OUT VARCHAR,
                                     VO_MSG_ERROR OUT VARCHAR
                                   ) ;
  

end PQ_CR_ADENDA_PRC;
/

create or replace package body PQ_CR_ADENDA_PRC is
   procedure sp_cr_enviar_mail_rrhh(
                                     VE_INSTANCIA IN NUMBER,
                                     VE_ARCHIVO IN VARCHAR,
                                     VO_COD_ERROR OUT VARCHAR,
                                     VO_MSG_ERROR OUT VARCHAR
                                   ) is
                                   
-- *****************************************************************
-- Nombre                       : PQ_CR_ADENDA_PRC
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 20/02/2023
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : VE_INSTANCIA, VE_ARCHIVO
-- Retorno                      : VO_COD_ERROR, VO_MSG_ERROR
--------------------------------------------------------------------
-- Fecha de Modificación  : 07/02/2024
-- Autor de la Modificación : MCORDOVA
-- Descripción de Modificación  : Se modifica guias de parametrizacion
-- *****************************************************************

   VI_EMPRESA XWF700.XWFEMPRESA%TYPE;
   VI_SUCURSAL XWF700.XWFSUCURSAL%TYPE;
   VI_MODULO XWF700.XWFMODULO%TYPE;
   VI_MONEDA XWF700.XWFMONEDA%TYPE;
   VI_PAPEL XWF700.XWFPAPEL%TYPE;
   VI_CUENTA XWF700.XWFCUENTA%TYPE;
   VI_OPERACION XWF700.XWFOPERACION%TYPE;
   VI_SUBOPE XWF700.XWFSUBOPE%TYPE;
   VI_TIPOPE XWF700.XWFTIPOPE%TYPE;
   lv_archivo VARCHAR(50);
   lv_destinos varchar(150);
   lv_destinos_c varchar(150);
   ll_mensaje varchar(250);
   lv_remitente varchar(250);
   lv_asunto varchar(250);
   lv_directorio varchar(250);
   
   vi_pepais fsr008.pepais%type;
   vi_petdoc fsr008.petdoc%type;
   vi_pendoc fsr008.pendoc%type;
   vi_nombre varchar(150);
   
   begin
     --OBTENER LOS DATOS PARA ENVIO DEL CORREO directorio y archivo.
     BEGIN
         SELECT X.XWFEMPRESA,X.XWFSUCURSAL,X.XWFMODULO,X.XWFMONEDA,X.XWFPAPEL,X.XWFCUENTA,X.XWFOPERACION,X.XWFSUBOPE,X.XWFTIPOPE
         INTO VI_EMPRESA,VI_SUCURSAL,VI_MODULO,VI_MONEDA,VI_PAPEL,VI_CUENTA,VI_OPERACION,VI_SUBOPE,VI_TIPOPE
         FROM XWF700 X WHERE XWFPRCINS = VE_INSTANCIA AND XWFCAR3='1';         
         
         SELECT PEPAIS,PETDOC,PENDOC 
         INTO VI_PEPAIS,VI_PETDOC,VI_PENDOC FROM FSR008 F WHERE F.CTNRO=VI_CUENTA AND F.CTTFIR='T' AND F.TTCOD=1;
         
         select d.penom into vi_nombre from fsd001 d where d.pepais=vi_pepais and d.petdoc=vi_petdoc and d.pendoc=vi_pendoc ;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
      --OBTENER DIRETORIO DE GUIA ESPECIAL.
      BEGIN
         SELECT TRIM(TP1DESC)
         INTO lv_directorio
          FROM FST198 F
         WHERE F.TP1COD  = 1
           AND F.TP1COD1 = 11153
           AND F.TP1CORR1= 20
           AND F.TP1CORR2= 2
           AND F.TP1CORR3= 0;
      END;
     --OBTENER LOS MENSAJES QUE SE ENVIARA LA ADENDA DEL COLABORADOR.
     BEGIN
       ll_mensaje :='Se realizo el desembolso del Credito con Cuenta: '||vi_cuenta||' y Operacion: '||vi_operacion|| 'del Colaborador:'||vi_nombre;
       lv_asunto := 'Desembolso de Colaborador CAJA - Cuenta y Operacion : '||vi_cuenta||'-'||vi_operacion; 
       lv_remitente := 'notificaciones@cajaarequipa.pe';
       lv_archivo := VE_ARCHIVO;
       lv_destinos := 'creditostrabajadores@cajaarequipa.pe';
     END;
     
     begin
      -- Call the procedure
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => lv_destinos_c,
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivo,
                                       p_c_coderr          => VO_COD_ERROR,
                                       p_c_deserr          => VO_MSG_ERROR);
    exception
      when others then
        VO_COD_ERROR := '99';
        VO_MSG_ERROR := sqlerrm;
    end;
   EXCEPTION 
     WHEN OTHERS THEN
       NULL;
   end;
end PQ_CR_ADENDA_PRC;
/

