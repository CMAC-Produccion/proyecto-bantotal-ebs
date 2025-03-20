CREATE OR REPLACE PROCEDURE SP_CONCATENA_MAIL
(
PC_ORIGEN       VARCHAR2,
PC_DESTINO      VARCHAR2,
PC_TITULO       VARCHAR2,
PC_MENSAJE      VARCHAR2

)
as
 Dominio               VARCHAR2(20) := '@cajaarequipa.pe';
 OrigenCorreo          VARCHAR2(50);
 DestinoCorreo         VARCHAR2(50);
BEGIN

  OrigenCorreo  := PC_ORIGEN||Dominio;
  DestinoCorreo := PC_DESTINO||Dominio;

  BEGIN
    SYS.SP_SY_ENVIAMAIL(OrigenCorreo,
                        DestinoCorreo,
                        PC_TITULO,
                        PC_MENSAJE);
                        
   exception
     when others then     
       dbms_output.put_line(sqlerrm);                       
  END;

  
END;
/

