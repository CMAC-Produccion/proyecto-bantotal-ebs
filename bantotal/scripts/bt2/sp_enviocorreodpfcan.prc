CREATE OR REPLACE PROCEDURE SP_ENVIOCORREODPFCAN (
  p_d_fecgen IN DATE
) 
IS 
  cursor c_mail is
  SELECT *
  FROM JAQN87
  WHERE JAQN87ERR = 'null' 
  AND JAQN87EST   = 'N'
  AND trunc(JAQN87FCH) = p_d_fecgen ;
      
  lc_error  varchar2(400);    
  lc_coderr varchar2(400);    
  lc_deserr varchar2(400);  
BEGIN
  for i in c_mail loop
       begin
                      
          -- Call the procedure
          if pq_ah_enviodigital.fn_ah_valida_mail(trim(i.JAQN87MDE))='S' then
              lc_coderr := '000';
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(i.JAQN87MDE),
                                               p_destinatarioscc => '',
                                               p_destinatariosbcc => '',
                                               p_mensaje => trim(i.JAQN87CUE),
                                               p_remitente => trim(i.JAQN87MRE) ,
                                               p_asunto => trim(i.JAQN87ASU) ,
                                               p_tipomensaje => 'HTML',
                                               p_directorio => trim(i.JAQN87DIR),
                                               p_archivosadjuntos =>  trim(i.JAQN87ADJ),
                                               p_c_coderr => lc_coderr,
                                               p_c_deserr => lc_deserr
                                               );   
              if lc_coderr = '000' then 
                 update JAQN87 a
                    set a.JAQN87FEN = p_d_fecgen, --sysdate,
                        a.JAQN87HRE = to_char(sysdate,'HH24:mi:ss'),
                        a.JAQN87ERR = ' ',
                        a.JAQN87EST = 'S'
                  where a.JAQN87CID = i.JAQN87CID;
              else
                 update JAQN87 a
                    set a.JAQN87EST = 'E',
                        a.JAQN87ERR = lc_deserr 
                  where a.JAQN87CID = i.JAQN87CID;             
              end if; 
          else
           lc_deserr:='Cuenta de Correo no válida';
           update JAQN87 a
                  set a.JAQN87EST = 'E',
                      a.JAQN87ERR = lc_deserr 
                where a.JAQN87CID = i.JAQN87CID;            
          end if;             
          exception
          when others then
              lc_coderr := sqlcode;   
              lc_deserr:= lc_coderr||'-'||sqlerrm;         
              update JAQN87 a
              set a.JAQN87EST = 'E',
                a.JAQN87ERR = lc_deserr 
              where a.JAQN87CID = i.JAQN87CID;        
          end;
          commit;
      end loop;
END SP_ENVIOCORREODPFCAN;
/

