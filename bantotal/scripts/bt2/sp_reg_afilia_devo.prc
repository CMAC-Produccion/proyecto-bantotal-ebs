create or replace procedure SP_REG_AFILIA_DEVO
(      PI_CODIGOCLIENTE            IN VARCHAR2,
       PI_NOMBRECLIENTE            IN VARCHAR2,
       PI_MAILCLIENTE              IN VARCHAR2,
       PI_CELULARCLIENTE           IN VARCHAR2,
       PI_SEXOCLIENTE              IN VARCHAR2,
       PI_ENVIARCELULAR            IN VARCHAR2,
       PI_ENVIARMAIL               IN VARCHAR2,
       PI_CODE                     OUT NUMBER
) IS

BEGIN
  INSERT INTO /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS(
                codigo_cliente,
                nombre_cliente,
                mail_cliente,
                celular_cliente,
                sexo_cliente,
                enviar_celular,
                enviar_mail                 )
   values(
                PI_CODIGOCLIENTE,
                PI_NOMBRECLIENTE,
                PI_MAILCLIENTE,
                PI_CELULARCLIENTE,
                PI_SEXOCLIENTE,
                PI_ENVIARCELULAR,
                PI_ENVIARMAIL               );
   commit;
   PI_CODE:= 1;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
        Null;
        BEGIN
          UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
              SET mail_cliente     = PI_MAILCLIENTE,
                  celular_cliente  = PI_CELULARCLIENTE,
                  enviar_celular   = PI_ENVIARCELULAR,
                  enviar_mail      = PI_ENVIARMAIL

              WHERE codigo_cliente =PI_CODIGOCLIENTE;

          COMMIT;
         PI_CODE:= 2;
       END;

END SP_REG_AFILIA_DEVO;
/

