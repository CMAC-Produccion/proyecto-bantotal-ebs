create or replace procedure sp_ah_envio_adenda(P_N_PGCOD  IN NUMBER,
                                               P_N_SCMOD  IN NUMBER,
                                               P_N_SCSUC  IN NUMBER,
                                               P_N_SCMDA  IN NUMBER,
                                               P_N_SCPAP  IN NUMBER,
                                               P_N_SCCTA  IN NUMBER,
                                               P_N_SCOPER IN NUMBER,
                                               P_N_SCSBOP IN NUMBER,
                                               P_N_SCTOPE IN NUMBER,
                                               P_N_CODPAI IN NUMBER,
                                               P_N_TIPDOC IN NUMBER,
                                               P_C_NUMDOC IN VARCHAR2,
                                               P_C_CODEST IN VARCHAR2,
                                               P_D_FECPRO IN DATE, 
                                               P_C_CODUSU IN VARCHAR2,
                                               P_N_CODAGE IN NUMBER,
                                               p_c_coderr out varchar2,
                                               p_c_msgerr out varchar2
                                              ) is
                                     
   --Datos destinatarios  
    
   cursor c_datos_1 is             
      select a.* 
      from fst198 a
      Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 103
         and a.Tp1corr2 = 2
      order by 1,2,3,4,5;
    
    --cursor ref c_datos;
   
    cursor c_datos_2 is             
      select a.* 
      from fst198 a
      Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 103
         and a.Tp1corr2 = 3
      order by 1,2,3,4,5;
    
     
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(90);  
    lv_asunto     VARCHAR2(200);  
    lv_asuntoa    VARCHAR2(90); 
    lv_asuntor    VARCHAR2(90);          
    lv_directorio VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';    
    lv_archivo    VARCHAR2(100):='';
    l_bfile       BFILE;
    l_blob        BLOB; 
    lv_cuentat    VARCHAR2(10); 
begin

  If P_N_SCMOD = 21 and P_N_SCTOPE = 6 then
   lv_cuentat := 'SUELDO';
  Else
   lv_cuentat := 'CTS';
  End If;
  p_c_coderr := '000';

  lv_archivo := 'ADENDA_'||lv_cuentat||'_'||trim(P_C_NUMDOC)||'.pdf';  
  If P_N_SCMOD = 21 and P_N_SCTOPE = 6 then
    For i in c_datos_2 loop
        Case
           When i.tp1nro1 = 1 then
             lv_remitente  := lv_remitente || trim(i.tp1desc);
           When i.tp1nro1 = 2 then
             lv_asuntoa     := lv_asuntoa  || i.tp1desc;  
           When i.tp1nro1 = 3 then
             lv_asuntor     := lv_asuntor  || i.tp1desc;  
           When i.tp1nro1 = 4 then
             lv_directorio     := lv_directorio  ||  trim(i.tp1desc);                                         
           Else
             null;
        End Case;
    End Loop; 
  Else
    For i in c_datos_1 loop
        Case
           When i.tp1nro1 = 1 then
             lv_remitente  := lv_remitente || trim(i.tp1desc);
           When i.tp1nro1 = 2 then
             lv_asuntoa     := lv_asuntoa  || i.tp1desc;  
           When i.tp1nro1 = 3 then
             lv_asuntor     := lv_asuntor  || i.tp1desc;  
           When i.tp1nro1 = 4 then
             lv_directorio     := lv_directorio  ||  trim(i.tp1desc);                                         
           Else
             null;
        End Case;
    End Loop; 
  End If;
  if P_C_CODEST = 'X' then
     --ARMA CORREO Y ENVIA  
      p_c_coderr := '000';                    
      dbms_lob.createtemporary(ll_mensaje, TRUE);     
      lv_asunto := 'Comunicación de Tasa de interés preferencial en tu cuenta '||lv_cuentat||' por ser colaborador de Caja Arequipa';  
      lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado colaborador,</p>' ||  
                    '<p "font-family: Arial, sans-serif; font-size: 14px;">Bienvenido a Caja Arequipa, te informamos que podrás acceder al beneficio de una tasa de interés preferencial en tu cuenta '||lv_cuentat||' por ser colaborador de Caja Arequipa, para ello deberás firmar la Adenda respectiva en una ventanilla de cualquiera de nuestras agencias, y listo!!! </p>';                        
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                            
                                               
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa</strong></p>';                                          
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
                     
      begin
        Select lower(trim(a.jaqn002usr)) || '@cajaarequipa.pe'
          into lv_destinos
          from jaqn002 a
         where a.jaqn002pai = P_N_CODPAI
           and a.jaqn002tdo = P_N_TIPDOC                    
           and a.jaqn002ndo = Rpad(P_C_NUMDOC,12,' ')
           and rownum < 2;
      exception
      when others then
           p_c_coderr := '009';
           p_c_msgerr := 'ERROR AL OBTENER LA CUENTA DE CORREO DEL TRABAJADOR, NO SE PUDO ENVIAR CORREO.';  
           lv_destinos := null;                   
      end;  
      if lv_destinos is not null then               
        begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                         p_destinatarioscc   => '',
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lv_remitente,
                                         p_asunto            => lv_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => '',
                                         p_archivosadjuntos  => '',
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr
                                         );
        exception
        when others then  
          p_c_coderr := '00x';
          p_c_msgerr := sqlerrm;                                                   
        end;
      end if;
      dbms_lob.freetemporary(ll_mensaje);       
  Else
    begin
      insert into AQPA126(AQPA126PGC,
                          AQPA126MOD,
                          AQPA126SUC,
                          AQPA126MDA,
                          AQPA126PAP,
                          AQPA126CTA,
                          AQPA126OPE,
                          AQPA126SBO,
                          AQPA126TPO,
                          AQPA126PAI,
                          AQPA126TIP,
                          AQPA126NUM,
                          AQPA126EST,
                          AQPA126FEC,
                          AQPA126USR,
                          AQPA126AGE
                         )
                   values(P_N_PGCOD, 
                          P_N_SCMOD,
                          P_N_SCSUC,
                          P_N_SCMDA,
                          P_N_SCPAP,
                          P_N_SCCTA, 
                          P_N_SCOPER,
                          P_N_SCSBOP,
                          P_N_SCTOPE,
                          P_N_CODPAI,
                          P_N_TIPDOC,
                          P_C_NUMDOC,
                          P_C_CODEST,
                          P_D_FECPRO,
                          P_C_CODUSU,
                          P_N_CODAGE
                         );
                         
         if P_C_CODEST = 'R' then
              begin
                insert into AQPA126a(AQPA126ACOR,
                                     AQPA126APGC,
                                     AQPA126AMOD,
                                     AQPA126ASUC,
                                     AQPA126AMDA,
                                     AQPA126APAP,
                                     AQPA126ACTA,
                                     AQPA126AOPE,
                                     AQPA126ASBO,
                                     AQPA126ATPO,
                                     AQPA126APAI,
                                     AQPA126ATIP,
                                     AQPA126ANUM,
                                     AQPA126AEST,
                                     AQPA126AFEC,
                                     AQPA126AHOR,
                                     AQPA126AUSR,
                                     AQPA126AAGE                                
                                     )
                             values(SQ_AH_ID_ADENDAHIS.NEXTVAL,
                                    P_N_PGCOD, 
                                    P_N_SCMOD,
                                    P_N_SCSUC,
                                    P_N_SCMDA,
                                    P_N_SCPAP,
                                    P_N_SCCTA, 
                                    P_N_SCOPER,
                                    P_N_SCSBOP,
                                    P_N_SCTOPE,
                                    P_N_CODPAI,
                                    P_N_TIPDOC,
                                    P_C_NUMDOC,
                                    P_C_CODEST,
                                    P_D_FECPRO,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    P_C_CODUSU,
                                    P_N_CODAGE
                                    );                                                                        
              exception
              when others then
                p_c_coderr := '003';
                p_c_msgerr := 'AQPA126A-'||sqlerrm;                     
              end;                  
         Else
              begin
                insert into AQPA126a(AQPA126ACOR,
                                     AQPA126APGC,
                                     AQPA126AMOD,
                                     AQPA126ASUC,
                                     AQPA126AMDA,
                                     AQPA126APAP,
                                     AQPA126ACTA,
                                     AQPA126AOPE,
                                     AQPA126ASBO,
                                     AQPA126ATPO,
                                     AQPA126APAI,
                                     AQPA126ATIP,
                                     AQPA126ANUM,
                                     AQPA126AEST,
                                     AQPA126AFEC,
                                     AQPA126AHOR,
                                     AQPA126AUSR,
                                     AQPA126AAGE,
                                     AQPA126AARC                                       
                                     )
                             values(SQ_AH_ID_ADENDAHIS.NEXTVAL,
                                    P_N_PGCOD, 
                                    P_N_SCMOD,
                                    P_N_SCSUC,
                                    P_N_SCMDA,
                                    P_N_SCPAP,
                                    P_N_SCCTA, 
                                    P_N_SCOPER,
                                    P_N_SCSBOP,
                                    P_N_SCTOPE,
                                    P_N_CODPAI,
                                    P_N_TIPDOC,
                                    P_C_NUMDOC,
                                    P_C_CODEST,
                                    P_D_FECPRO,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    P_C_CODUSU,
                                    P_N_CODAGE,
                                    EMPTY_BLOB()
                                    )
                                    RETURN AQPA126AARC INTO l_blob;                          
                                
                              l_bfile := BFILENAME(lv_directorio, lv_archivo);
                              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                              DBMS_LOB.fileclose(l_bfile);                                  
              exception
              when others then
                p_c_coderr := '003';
                p_c_msgerr := 'AQPA126A-'||sqlerrm;                     
              end;                  
         End If;                       
    exception
    when dup_val_on_index then
      update AQPA126 a
         set a.AQPA126EST = P_C_CODEST, 
             a.AQPA126FEC = P_D_FECPRO,
             a.AQPA126USR = P_C_CODUSU,
             a.AQPA126AGE = P_N_CODAGE
       where a.AQPA126PGC = P_N_PGCOD  
         and a.AQPA126MOD = P_N_SCMOD
         and a.AQPA126SUC = P_N_SCSUC
         and a.AQPA126MDA = P_N_SCMDA
         and a.AQPA126PAP = P_N_SCPAP
         and a.AQPA126CTA = P_N_SCCTA 
         and a.AQPA126OPE = P_N_SCOPER
         and a.AQPA126SBO = P_N_SCSBOP
         and a.AQPA126TPO = P_N_SCTOPE;
                               
         if sql%notfound then 
            p_c_coderr := '002';
            p_c_msgerr := 'AQPA126-NO SE ENCONTRARON REGISTROS A ACTUALIZAR';   
         Else
            if P_C_CODEST = 'R' then
              begin
                insert into AQPA126a(AQPA126ACOR,
                                     AQPA126APGC,
                                     AQPA126AMOD,
                                     AQPA126ASUC,
                                     AQPA126AMDA,
                                     AQPA126APAP,
                                     AQPA126ACTA,
                                     AQPA126AOPE,
                                     AQPA126ASBO,
                                     AQPA126ATPO,
                                     AQPA126APAI,
                                     AQPA126ATIP,
                                     AQPA126ANUM,
                                     AQPA126AEST,
                                     AQPA126AFEC,
                                     AQPA126AHOR,
                                     AQPA126AUSR,
                                     AQPA126AAGE                                
                                     )
                             values(SQ_AH_ID_ADENDAHIS.NEXTVAL,
                                    P_N_PGCOD, 
                                    P_N_SCMOD,
                                    P_N_SCSUC,
                                    P_N_SCMDA,
                                    P_N_SCPAP,
                                    P_N_SCCTA, 
                                    P_N_SCOPER,
                                    P_N_SCSBOP,
                                    P_N_SCTOPE,
                                    P_N_CODPAI,
                                    P_N_TIPDOC,
                                    P_C_NUMDOC,
                                    P_C_CODEST,
                                    P_D_FECPRO,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    P_C_CODUSU,
                                    P_N_CODAGE
                                    );                                                                        
              exception
              when others then
                p_c_coderr := '003';
                p_c_msgerr := 'AQPA126A-'||sqlerrm;                     
              end;                  
            Else
              begin
                insert into AQPA126a(AQPA126ACOR,
                                     AQPA126APGC,
                                     AQPA126AMOD,
                                     AQPA126ASUC,
                                     AQPA126AMDA,
                                     AQPA126APAP,
                                     AQPA126ACTA,
                                     AQPA126AOPE,
                                     AQPA126ASBO,
                                     AQPA126ATPO,
                                     AQPA126APAI,
                                     AQPA126ATIP,
                                     AQPA126ANUM,
                                     AQPA126AEST,
                                     AQPA126AFEC,
                                     AQPA126AHOR,
                                     AQPA126AUSR,
                                     AQPA126AAGE,
                                     AQPA126AARC                                       
                                     )
                             values(SQ_AH_ID_ADENDAHIS.NEXTVAL,
                                    P_N_PGCOD, 
                                    P_N_SCMOD,
                                    P_N_SCSUC,
                                    P_N_SCMDA,
                                    P_N_SCPAP,
                                    P_N_SCCTA, 
                                    P_N_SCOPER,
                                    P_N_SCSBOP,
                                    P_N_SCTOPE,
                                    P_N_CODPAI,
                                    P_N_TIPDOC,
                                    P_C_NUMDOC,
                                    P_C_CODEST,
                                    P_D_FECPRO,
                                    to_char(sysdate,'HH24:mi:ss'),
                                    P_C_CODUSU,
                                    P_N_CODAGE,
                                    EMPTY_BLOB()
                                    )
                                    RETURN AQPA126AARC INTO l_blob;                          
                                
                              l_bfile := BFILENAME(lv_directorio, lv_archivo);
                              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                              DBMS_LOB.fileclose(l_bfile);                                  
              exception
              when others then
                p_c_coderr := '003';
                p_c_msgerr := 'AQPA126A-'||sqlerrm;                     
              end;                  
            End If;
            
         End If; 

         commit;
    When others then
      p_c_coderr := '001';    
      p_c_msgerr := 'AQPA126-'||Sqlerrm;
    end; 
    
    If p_c_coderr = '000' then  
    
      --ARMA CORREO Y ENVIA                
      dbms_lob.createtemporary(ll_mensaje, TRUE);     
      if P_C_CODEST = 'A' then   
         lv_asunto := lv_asuntoa;
         If P_N_SCMOD = 21 and P_N_SCTOPE = 6 then
           lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado colaborador,</p>' ||  
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta la adenda firmada en agencia, está te permitirá 
                         acceder a la tasa preferencial para trabajadores en tu cuenta '||lv_cuentat||', mientras recibas abono de 
                         remuneraciones por parte del empleador. </p>'; 
         else
           lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado colaborador,</p>' ||  
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta la adenda firmada en agencia, está te permitirá 
                         acceder a la tasa preferencial para trabajadores en tu cuenta '||lv_cuentat||'. </p>'; 

         End If;
      else
         lv_asunto := lv_asuntor;            
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado colaborador,</p>' ||  
                       '<p "font-family: Arial, sans-serif; font-size: 14px;">Se deja constancia que en fecha '|| to_char(P_D_FECPRO,'dd/mm/rrrr') ||' usted <strong>NO HA ACEPTADO</strong> 
                       firmar Adenda al Contrato de Depósitos de su cuenta '||lv_cuentat||', en consecuencia, la tasa de interés se mantiene de acuerdo al 
                       tarifario para clientes.</p>';                     
      End if;    
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                            
                                               
      lv_mensaje := 
      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa</strong></p>';                                          
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
                     
      begin
        Select lower(trim(a.jaqn002usr)) || '@cajaarequipa.pe'
          into lv_destinos
          from jaqn002 a
         where a.jaqn002pai = P_N_CODPAI
           and a.jaqn002tdo = P_N_TIPDOC                    
           and a.jaqn002ndo = Rpad(P_C_NUMDOC,12,' ')
           and rownum < 2;         
           
      exception
      when others then
           p_c_coderr := '004';
           p_c_msgerr := 'ERROR AL OBTENER LA CUENTA DE CORREO DEL TRABAJADOR, NO SE PUDO ENVIAR CORREO.';  
           lv_destinos := null;           
           
      end;  
      DBMS_OUTPUT.PUT_LINE ('lv_destinos: '||lv_destinos);
      if lv_destinos is not null then               
        begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                         p_destinatarioscc   => '',
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lv_remitente,
                                         p_asunto            => lv_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => lv_directorio,
                                         p_archivosadjuntos  => lv_archivo,
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_msgerr
                                         );
        exception
        when others then  
          p_c_coderr := '00x';
          p_c_msgerr := sqlerrm;                                                   
        end;
      end if;
      dbms_lob.freetemporary(ll_mensaje);   
    end if;
  End If;                          
         
exception 
when others then
  p_c_coderr := '00Z';
  p_c_msgerr := Sqlerrm;    
end sp_ah_envio_adenda;
/

