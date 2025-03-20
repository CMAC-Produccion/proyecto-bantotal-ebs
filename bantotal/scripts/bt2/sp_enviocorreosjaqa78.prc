CREATE OR REPLACE PROCEDURE "SP_ENVIOCORREOSJAQA78" (
  p_d_fecgen IN DATE
) 
IS 

   cursor c_mail is
   SELECT *
   FROM JAQA78
   WHERE JAQA78ERR = 'null' 
   AND JAQA78EST = 'N'
   AND trunc(JAQA78FEN) = p_d_fecgen ;
      
  lc_error  varchar2(400);    
  lc_coderr varchar2(400);    
  lc_deserr varchar2(400); 
BEGIN
    for i in c_mail loop
       begin
                      
          -- Call the procedure
          if pq_ah_enviodigital.fn_ah_valida_mail(trim(i.JAQA78mde))='S' then
              lc_coderr := '000';
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(i.jaqa78mde),
                                               p_destinatarioscc => '',
                                               p_destinatariosbcc => '',
                                               p_mensaje => trim(i.jaqa78cue),
                                               p_remitente => trim(i.jaqa78mre) ,
                                               p_asunto => trim(i.jaqa78asu) ,
                                               p_tipomensaje => 'HTML',
                                               p_directorio => trim(i.jaqa78dir),
                                               p_archivosadjuntos =>  trim(i.jaqa78adj),
                                               p_c_coderr => lc_coderr,
                                               p_c_deserr => lc_deserr
                                               );   
              if lc_coderr = '000' then                                                                                               
                 update JAQA78 a
                    set a.jaqa78fen = p_d_fecgen, --sysdate,
                        a.jaqa78hre = to_char(sysdate,'HH24:mi:ss'),
                        a.JAQA78ERR = ' ',
                        a.jaqa78est = 'S'
                  where a.jaqa78id = i.jaqa78id;
              else
                 update JAQA78 a
                    set a.jaqa78est = 'E',
                        a.jaqa78ERR = lc_deserr 
                  where a.jaqa78id = i.jaqa78iD;             
              end if; 
          else
           lc_deserr:='Cuenta de Correo no válida';
           update JAQA78 a
                  set a.jaqa78est = 'E',
                      a.jaqa78err = lc_deserr 
                where a.jaqa78id = i.jaqa78id;            
          end if;             
          exception
          when others then
              lc_coderr := sqlcode;   
              lc_deserr:= lc_coderr||'-'||sqlerrm;         
              update JAQA78 a
              set a.jaqa78est = 'E',
                a.jaqa78err = lc_deserr 
              where a.jaqa78id = i.jaqa78id;        
          end;
          commit;
      end loop;
      

END SP_ENVIOCORREOSJAQA78;
/

