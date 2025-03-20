create or replace procedure sp_Enviar_Correo(p_DestinatariosPara     VARCHAR2,
                             p_DestinatariosCC       VARCHAR2,
                             p_DestinatariosBcc      VARCHAR2,
                             p_Mensaje               CLOB,
                             p_Remitente             VARCHAR2,
                             p_Asunto                VARCHAR2,
                             p_TipoMensaje           VARCHAR2,
                             p_Directorio            VARCHAR2,
                             p_ArchivosAdjuntos      VARCHAR2,
                             p_c_coderr              out varchar2,
                             p_c_deserr              out varchar2 ) is
begin                                    
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(p_DestinatariosPara),
                                           p_destinatarioscc   => trim(p_DestinatariosCC),
                                           p_destinatariosbcc  => trim(p_destinatariosbcc),
                                           p_mensaje           => trim(p_mensaje),
                                           p_remitente         => trim(p_remitente),
                                           p_asunto            => trim(p_asunto),
                                           p_tipomensaje       => trim(p_tipomensaje),
                                           p_directorio        => trim(p_directorio),
                                           p_archivosadjuntos  => trim(p_archivosadjuntos),
                                           p_c_coderr          => p_c_coderr,
                                           p_c_deserr          => p_c_deserr
                                           );
                                          
  
end sp_Enviar_Correo;
/

