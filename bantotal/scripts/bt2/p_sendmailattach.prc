create or replace procedure P_SendMailAttach
(
p_DestinatariosPara     VARCHAR2,
p_DestinatariosCC       VARCHAR2 DEFAULT NULL,
p_DestinatariosBcc      VARCHAR2 DEFAULT NULL,
p_Mensaje               VARCHAR2 DEFAULT NULL,
p_Remitente             VARCHAR2 DEFAULT NULL,
p_Asunto                VARCHAR2 DEFAULT NULL,
p_TipoMensaje           VARCHAR2 DEFAULT 'HTML',
p_Directorio            VARCHAR2 DEFAULT NULL,
p_ArchivosAdjuntos      VARCHAR2
)
AS

  p_c_coderr varchar2(10);
  p_c_deserr varchar2(50);

begin

  begin
    
    pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(p_DestinatariosPara),
                                     p_destinatarioscc => trim(p_DestinatariosCC),
                                     p_destinatariosbcc => trim(p_DestinatariosBcc),
                                     p_mensaje => p_Mensaje,
                                     p_remitente => trim(p_Remitente),
                                     p_asunto => trim(p_Asunto),
                                     p_tipomensaje => trim(p_TipoMensaje),
                                     p_directorio => trim(p_Directorio),
                                     p_archivosadjuntos => trim(p_ArchivosAdjuntos),
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr);
  end;


  exception when others then
    dbms_output.put_line(p_c_coderr);
    dbms_output.put_line(p_c_deserr);
end;
/

