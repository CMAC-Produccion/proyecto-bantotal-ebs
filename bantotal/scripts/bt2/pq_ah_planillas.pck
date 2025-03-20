create or replace package PQ_AH_PLANILLAS is
   -- *****************************************************************
    -- Nombre                     : PQ_AH_PLANILLAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Paquete relacionado a todo el flujo de CTS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 15/10/2024
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se adicionó registro de cuenta cliente del empleado y del empleador
    -- Fecha de Modificación      : 24/10/2024
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se adicionó tipo de producto en procedimiento de obtención de cuenta empleador
    -- *****************************************************************   
  
  Procedure sp_ah_registra(P_D_FECPRO IN DATE,
                           P_C_TIPCAR IN VARCHAR2,   
                           P_C_TIPFOR IN VARCHAR2,           
                           P_C_CODUSU IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,
                           P_N_NUMCTA IN NUMBER,
                           P_N_NOMARC IN VARCHAR2,
                           p_n_numsec out number,
                           p_c_coderr out varchar2,                    
                           p_c_deserr out varchar2
                           );
                           
  Procedure sp_ah_upd_est(P_N_NUMSEC IN NUMBER,
                          P_D_FECPRO IN DATE,
                          P_C_CODUSU IN VARCHAR2,
                          P_C_CODEST IN VARCHAR2,
                          P_C_DESMSG IN VARCHAR2,
                          P_C_COMAIL IN VARCHAR2,                          
                          p_c_coderr out varchar2,                    
                          p_c_deserr out varchar2
                         );
                                                    
  procedure P_SendMailAttach(p_DestinatariosPara     VARCHAR2,
                             p_DestinatariosCC       VARCHAR2, 
                             p_DestinatariosBcc      VARCHAR2, 
                             p_Mensaje               CLOB, 
                             p_Remitente             VARCHAR2, 
                             p_Asunto                VARCHAR2, 
                             p_TipoMensaje           VARCHAR2, 
                             p_Directorio            VARCHAR2, 
                             p_ArchivosAdjuntos      VARCHAR2,
                             p_c_coderr              out varchar2,
                             p_c_deserr              out varchar2
                            );  
                              
  Procedure sp_ah_envia_mail(P_D_FECPRO IN DATE,
                             P_C_TIPCAR IN VARCHAR2,  
                             P_C_TIPFOR IN VARCHAR2,            
                             P_C_CODUSU IN VARCHAR2,
                             p_c_coderr out varchar2,                    
                             p_c_deserr out varchar2
                             );                            
                             
  procedure sp_cl_add_months(P_D_FECINI IN DATE,
                             P_N_NUMMEN IN NUMBER,            
                             p_d_fecfin out date
                             );                             
                             
  Procedure sp_ah_veri_pro(P_D_FECPRO IN DATE,
                           P_C_TIPCAR IN VARCHAR2,  
                           P_C_TIPFOR IN VARCHAR2,            
                           P_C_CODUSU IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,
                           P_N_NUMINI IN NUMBER,
                           P_N_NUMFIN IN NUMBER,                                                                                 
                           p_c_coderr out varchar2,                    
                           p_c_deserr out varchar2
                           ); 
                           
  Procedure sp_ah_valida_envio(P_D_FECPRO IN DATE,
                               P_C_TIPCAR IN VARCHAR2,  
                               P_C_TIPFOR IN VARCHAR2,            
                               P_C_CODUSU IN VARCHAR2,
                               P_N_CODPAI IN NUMBER,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2,   
                               p_n_numsec out number,
                               p_c_coderr out varchar2,                    
                               p_c_deserr out varchar2
                              );   
  Procedure sp_ah_planillas(P_N_NUMSEQ IN NUMBER,
                            P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_D_FECPRO IN OUT DATE,
                            P_C_CODHOR IN OUT VARCHAR2,
                            P_C_CODUSU IN OUT VARCHAR2,                                       
                            P_C_TIPACC IN OUT VARCHAR2,
                            P_C_TIPFOR IN VARCHAR2,
                            P_C_CODEXT IN VARCHAR2,
                            P_C_TIPABO IN OUT VARCHAR2,
                            P_N_CODBAN IN OUT NUMBER,
                            P_N_NUMCOD IN OUT NUMBER,
                            P_C_CODCTA IN OUT VARCHAR2,
                            P_C_DESOBS IN OUT VARCHAR2,
                            P_C_CODMES IN OUT VARCHAR2,
                            P_N_NUMANO IN OUT NUMBER,
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2
                           );
                           
  Procedure sp_ah_regcar(P_N_CODPAI IN NUMBER,
                         P_N_TIPDOC IN NUMBER,
                         P_C_NUMDOC IN VARCHAR2,
                         P_N_NUMCTA IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,
                         P_C_NOMARC IN VARCHAR2,
                         P_C_NOMREP IN VARCHAR2,
                         P_C_TIPFOR IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         P_C_TIPABO IN VARCHAR2,
                         P_N_CODBAN IN NUMBER,
                         P_N_NUMCOD IN NUMBER,
                         P_C_CODCTA IN VARCHAR2,
                         P_C_CODMES IN VARCHAR2,
                         P_N_NUMANO IN NUMBER,                         
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        );      
                        
  Procedure sp_ah_regdes(P_N_NUMSEQ IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,                         
                         P_C_NOMREP IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ); 
  Procedure sp_ah_regest(P_N_NUMSEQ IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,                         
                         P_C_DESOBS IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        );                                                                                              
  Procedure sp_ah_regdat(P_N_NUMSEQ IN NUMBER,
                         p_d_fecpro out date,
                         p_c_horpro out varchar2,
                         p_c_codusu out varchar2,
                         p_c_tipabo out varchar2,
                         p_n_codban out number,
                         p_n_numcod out number,
                         p_c_codcta out varchar2,
                         p_c_codmes out varchar2,
                         p_n_numano out number,
                         p_c_desobs out varchar2,                         
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        );     
  Procedure sp_ah_regenv(P_D_FECPRO IN DATE,
                         P_N_NUMIMP IN NUMBER,
                         P_C_CODUSU IN VARCHAR2,     
                         P_N_PGCOD  IN NUMBER, 
                         P_N_SCMOD  IN NUMBER, 
                         P_N_SCSUC  IN NUMBER,  
                         P_N_SCMDA  IN NUMBER,  
                         P_N_SCPAP  IN NUMBER,  
                         P_N_SCCTA  IN NUMBER,  
                         P_N_SCOPER IN NUMBER,  
                         P_N_SCSBOP IN NUMBER,  
                         P_N_SCTOPE IN NUMBER,
                         P_C_NOMARC IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         P_C_MAICOR IN VARCHAR2,
                         P_C_DESOBS IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        );                     
  Procedure sp_ah_enviomail(P_D_FECPRO IN DATE,
                            P_C_CODHOR IN VARCHAR2,
                            P_C_TIPENV IN VARCHAR2,
                            P_N_NUMSEQ IN NUMBER,
                            P_C_NOMARC IN VARCHAR2,           
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                           );                                       
  procedure sp_genera_cartas_cts(P_D_FECPRO IN DATE,
                                 P_C_CODUSU IN VARCHAR2,   
                                 P_N_PGCOD  IN NUMBER, 
                                 P_N_SCMOD  IN NUMBER, 
                                 P_N_SCSUC  IN NUMBER,  
                                 P_N_SCMDA  IN NUMBER,  
                                 P_N_SCPAP  IN NUMBER,  
                                 P_N_SCCTA  IN NUMBER,  
                                 P_N_SCOPER IN NUMBER,  
                                 P_N_SCSBOP IN NUMBER,  
                                 P_N_SCTOPE IN NUMBER,
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2                                     
                                );              
  Procedure sp_ah_valida_mail_emp(P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER,  
                                  P_C_NUMDOC IN VARCHAR2,
                                  p_c_indmai out varchar2
                                 );                                    
  Procedure sp_ah_cta_emp_cts(P_N_CODPAI IN NUMBER,
                              P_N_TIPDOC IN NUMBER,  
                              P_C_NUMDOC IN VARCHAR2,
                              P_N_TIPPRO IN NUMBER,
                              p_c_numcta out number,
                              p_c_coderr out varchar2,
                              p_c_deserr out varchar2
                             ); 
  Procedure sp_ah_planillas1(P_N_NUMSEQ IN NUMBER,
                            P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_D_FECPRO IN OUT DATE,
                            P_C_CODHOR IN OUT VARCHAR2,
                            P_C_CODUSU IN OUT VARCHAR2,                                       
                            P_C_TIPACC IN OUT VARCHAR2,
                            P_C_TIPFOR IN VARCHAR2,
                            P_C_CODEXT IN VARCHAR2,
                            P_C_TIPABO IN OUT VARCHAR2,
                            P_N_CODBAN IN OUT NUMBER,
                            P_N_NUMCOD IN OUT NUMBER,
                            P_C_CODCTA IN OUT VARCHAR2,
                            P_C_DESOBS IN OUT VARCHAR2,
                            P_C_CODMES IN OUT VARCHAR2,
                            P_N_NUMANO IN OUT NUMBER,
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2
                           );      
  Procedure sp_ah_enviomail1(P_D_FECPRO IN DATE,
                             P_C_CODHOR IN VARCHAR2,
                             P_C_TIPENV IN VARCHAR2,
                             P_N_NUMSEQ IN NUMBER,
                             P_C_NOMARC IN VARCHAR2,           
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2                         
                            );      
  Procedure sp_ah_genera_codpla(P_D_FECPRO IN DATE,
                                P_N_PAIS   IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,         
                                p_c_coderr out varchar2,
                                p_c_deserr out varchar2                         
                              );   
  Procedure sp_ah_saldo_cdk(P_N_CTACLI IN NUMBER,
                            P_N_CTAEMP IN NUMBER,
                            P_N_CODMON IN NUMBER,
                            p_n_saldo  out number,   
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                            );                                                                                                                                     
end PQ_AH_PLANILLAS;
/

create or replace package body PQ_AH_PLANILLAS is

  Procedure sp_ah_registra(P_D_FECPRO IN DATE,
                           P_C_TIPCAR IN VARCHAR2,  
                           P_C_TIPFOR IN VARCHAR2,            
                           P_C_CODUSU IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,
                           P_N_NUMCTA IN NUMBER,
                           P_N_NOMARC IN VARCHAR2,
                           p_n_numsec out number,
                           p_c_coderr out varchar2,                    
                           p_c_deserr out varchar2
                           ) is
  lc_usuario char(10):=null;
  ln_codsuc  number(3):=0;
  l_bfile    BFILE;
  l_blob     BLOB;
  lc_flag    CHAR(1):='N';
  lv_nomrep  varchar2(30);
  begin
    --obtenemos sucursal del suuario
    lc_usuario := rpad(P_C_CODUSU,10,' ');
    begin
      select x.ubsuc 
        into ln_codsuc 
        from fst046 x 
       where x.pgcod = 1 
         and x.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 0;
    end;    
            
   --obtenemos repositorio
    begin
      select trim(a.tp1desc)
        into lv_nomrep 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio  
    exception
    when others then
      lv_nomrep := '';
    end;     
    begin                       
      insert into JAQZ174(JAQZ174SEC, 
                          JAQZ174TIP, 
                          JAQZ174FOR,
                          JAQZ174FEC, 
                          JAQZ174HOR, 
                          JAQZ174USU, 
                          JAQZ174AGE, 
                          JAQZ174PAI, 
                          JAQZ174TPO, 
                          JAQZ174NUM, 
                          JAQZ174CTA, 
                          JAQZ174NOM, 
                          JAQZ174ARC,                           
                          JAQZ174EST
                          )
                   values(SQ_AH_ID_PLANILLAS.NEXTVAL,
                          P_C_TIPCAR,
                          P_C_TIPFOR,
                          P_D_FECPRO,
                          to_char(sysdate,'hh24:mi:ss'),
                          P_C_CODUSU,
                          ln_codsuc,
                          P_N_CODPAI,
                          P_N_TIPDOC,
                          P_C_NUMDOC,
                          P_N_NUMCTA,
                          P_N_NOMARC,
                          EMPTY_BLOB(),
                          'G'
                          )
                          RETURN JAQZ174ARC INTO l_blob;                          
        select SQ_AH_ID_PLANILLAS.CURRVAL into p_n_numsec from dual;
                          
        l_bfile := BFILENAME(lv_nomrep, P_N_NOMARC);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;                                
                
      p_c_coderr := '000';
      p_c_deserr := '';
    exception
    when others then                           
      p_c_coderr := '001';
      p_c_deserr := sqlerrm;
      begin    
          begin       
            select 'S'
              into lc_flag 
              from jaqz174 x 
             where x.jaqz174sec = p_n_numsec;               
          exception
          when others then 
            lc_flag := 'N';  
          end;
          
          if lc_flag = 'N' then
            insert into JAQZ174(JAQZ174SEC, 
                                JAQZ174TIP, 
                                JAQZ174FOR,
                                JAQZ174FEC, 
                                JAQZ174HOR, 
                                JAQZ174USU, 
                                JAQZ174AGE, 
                                JAQZ174PAI, 
                                JAQZ174TPO, 
                                JAQZ174NUM, 
                                JAQZ174CTA, 
                                JAQZ174NOM, 
                                JAQZ174EST,
                                JAQZ174ERR
                                )
                         values(SQ_AH_ID_PLANILLAS.NEXTVAL,
                                P_C_TIPCAR,
                                P_C_TIPFOR,
                                P_D_FECPRO,                                  
                                to_char(sysdate,'hh24:mi:ss'),
                                P_C_CODUSU,
                                ln_codsuc,
                                P_N_CODPAI,
                                P_N_TIPDOC,
                                P_C_NUMDOC,
                                P_N_NUMCTA,
                                P_N_NOMARC,
                                'E',
                                p_c_deserr
                                );
          Else
             update jaqz174 x 
                set JAQZ174ERR = p_c_deserr 
              where x.jaqz174sec = p_n_numsec;              
          End if;                               
          commit;     
          select SQ_AH_ID_PLANILLAS.CURRVAL into p_n_numsec from dual;                                                                     
      exception
      when others then  
        p_c_coderr := '002';
        p_c_deserr := substr(sqlerrm,1,100);        
      end;
    end;
  end sp_ah_registra;
  Procedure sp_ah_upd_est(P_N_NUMSEC IN NUMBER,
                          P_D_FECPRO IN DATE,
                          P_C_CODUSU IN VARCHAR2,
                          P_C_CODEST IN VARCHAR2,
                          P_C_DESMSG IN VARCHAR2,
                          P_C_COMAIL IN VARCHAR2,
                          p_c_coderr out varchar2,                    
                          p_c_deserr out varchar2
                         ) is
  ln_codsuc  number(3):=0; 
  lc_usuario char(10):=null;                        
  begin
    p_c_coderr:= '000';
    --obtenemos sucursal del suuario
    lc_usuario := rpad(P_C_CODUSU,10,' ');    
    begin
      select x.ubsuc 
        into ln_codsuc 
        from fst046 x 
       where x.pgcod = 1 
         and x.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 0;
    end; 
        
    if P_C_CODEST IN ('E','I') then
      update JAQZ174 
         set JAQZ174EST = P_C_CODEST,
             JAQZ174ERR = decode(trim(JAQZ174ERR),'',P_C_DESMSG,trim(JAQZ174ERR)||'\'||P_C_DESMSG), 
             JAQZ174MOT = 'No se pudo enviar',
             JAQZ174MAI = P_C_COMAIL,
             JAQZ174FEV = P_D_FECPRO,           
             JAQZ174HOV = to_char(sysdate,'hh24:mi:ss'),           
             JAQZ174USV = P_C_CODUSU,           
             JAQZ174AGV = ln_codsuc                                     
       where JAQZ174SEC = P_N_NUMSEC;
        commit; 
    Else
      update JAQZ174 
         set JAQZ174EST = P_C_CODEST,             
             JAQZ174ERR = '', 
             JAQZ174MOT = P_C_DESMSG,
             JAQZ174MAI = P_C_COMAIL,
             JAQZ174FEV = P_D_FECPRO,           
             JAQZ174HOV = to_char(sysdate,'hh24:mi:ss'),           
             JAQZ174USV = P_C_CODUSU,           
             JAQZ174AGV = ln_codsuc                                     
       where JAQZ174SEC = P_N_NUMSEC;
        commit;       
    End If;         
  exception
  when others then                                                           
    p_c_coderr := '00X';
    p_c_deserr := substr(sqlerrm,1,100);         
  end;                             
  procedure P_SendMailAttach(p_DestinatariosPara     VARCHAR2,
                             p_DestinatariosCC       VARCHAR2,
                             p_DestinatariosBcc      VARCHAR2,
                             p_Mensaje               CLOB,
                             p_Remitente             VARCHAR2,
                             p_Asunto                VARCHAR2,
                             p_TipoMensaje           VARCHAR2,
                             p_Directorio            VARCHAR2,
                             p_ArchivosAdjuntos      VARCHAR2,
                             p_c_coderr              out varchar2,
                             p_c_deserr              out varchar2                             
                             ) is
  cursor c_host is
    select * 
      from fst198
     Where Tp1cod  = 1
       and Tp1cod1  = 10825
       and Tp1corr1 = 61
       and Tp1corr2 = 7;  
       
  lc_hostname varchar2(64);
  lv_smtp     varchar2(30);
  lv_host     varchar2(30);
  ln_port     number(9);      
  
  l_offset     number;
  l_ammount    number;   
       
  c utl_smtp.connection;
  --v_mesg             VARCHAR2(32767);
  
  --Procedimiento para escritura de Headers
  -----------------------------------------------------------------
  PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2, p_c_coderr OUT VARCHAR2, p_c_deserr OUT VARCHAR2) AS
  BEGIN    
      p_c_coderr := '000';                                                     
      utl_smtp.write_data(c, name || ': ' || header || utl_tcp.CRLF);
  EXCEPTION
  WHEN OTHERS THEN     
    p_c_coderr := '1001';
    p_c_deserr := p_c_coderr ||'-' ||sqlerrm;
    
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '1001x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;      
  END;
  -----------------------------------------------------------------

  --Procedimiento para Adicion de Destinatarios
  -----------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE add_rcpt(p_Destinatarios in VARCHAR2,p_c_coderr  out varchar2, p_c_deserr out varchar2) AS
  l_Cadena varchar2(32767) := p_Destinatarios;
  l_LargoCadena number;
  l_Comas number;
  l_PosicionComa number := 0;
  l_Destinatario varchar2(100);
  BEGIN
  p_c_coderr := '000';
  l_LargoCadena := length(l_Cadena);
  l_Comas := l_LargoCadena-length(replace(l_Cadena,';'));

  --Bloque 1 Asginacion del RCPT
      IF l_Comas > 0 THEN
            FOR l_segmento IN 1 .. l_Comas LOOP

                l_Destinatario := substr(l_Cadena, l_PosicionComa + 1, instr(l_Cadena,';',1,l_segmento) - (l_PosicionComa + 1));

                l_PosicionComa := instr(l_Cadena,';',1,l_Segmento);
                utl_smtp.rcpt(c, l_Destinatario);

            END LOOP;
      END IF;
  -- Fin de Bloque 1

  -- Bloque 2: Para insercion del ultimo recipient solicitado (o el primero, si es unico)
      l_Destinatario := substr(l_Cadena, l_PosicionComa + 1, l_LargoCadena);
      utl_smtp.rcpt(c, l_Destinatario);
  -- Fin Bloque 2
  EXCEPTION
  WHEN OTHERS THEN     
    p_c_coderr := '1006';
    p_c_deserr := p_c_coderr ||'-' ||sqlerrm;
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '1006x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END;
  ---------------------------------------------------------------------------------------------------------------------------------


  -- Procedimiento de adicion de cabeceras para destinatarios
  ---------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE add_headers_rcpt(p_Destinatarios IN VARCHAR2, p_Type IN VARCHAR2,p_c_coderr out varchar2,p_c_deserr out varchar2) AS
  l_Cadena varchar2(32767) := p_Destinatarios;
  l_LargoCadena number;
  l_Comas number;
  l_PosicionComa number := 0;
  l_Destinatario varchar2(100);
  BEGIN
  p_c_coderr := '000';
  l_LargoCadena := length(l_Cadena);
  l_Comas := l_LargoCadena-length(replace(l_Cadena,';'));

  --Bloque 1 Asginacion del Destinatario al header
      IF l_Comas > 0 THEN
            FOR l_segmento IN 1 .. l_Comas LOOP

                l_Destinatario := substr(l_Cadena, l_PosicionComa + 1, instr(l_Cadena,';',1,l_segmento) - (l_PosicionComa + 1));

                l_PosicionComa := instr(l_Cadena,';',1,l_Segmento);

                -- Se generan los encabezados para envio, en caso de Bcc no se agrega el Header
                IF p_Type = 'TO' THEN
                  send_header('To', l_Destinatario, p_c_coderr, p_c_deserr);
                ELSE
                  send_header('Cc', l_Destinatario, p_c_coderr, p_c_deserr);
                END IF;
                
                  if p_c_deserr is not null then
                    return;
                  End If;                  

            END LOOP;
            
      END IF;
  -- Fin de Bloque 1

  -- Bloque 2: Para insercion del ultimo recipient solicitado (o el primero, si es unico)
      l_Destinatario := substr(l_Cadena, l_PosicionComa + 1, l_LargoCadena);
      IF p_Type = 'TO' THEN
         send_header('To', l_Destinatario, p_c_coderr, p_c_deserr);
      ELSE
         send_header('Cc', l_Destinatario, p_c_coderr, p_c_deserr);
      END IF;
      
      if p_c_deserr is not null then
        return;
      End If;           
  -- Fin Bloque 2
  EXCEPTION
  WHEN OTHERS THEN     
    p_c_coderr := '1007';
    p_c_deserr := p_c_coderr ||'-' ||sqlerrm;
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '1007x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END;
  ----------------------------------------------------------------------------------------------------------------------------------------------

  PROCEDURE write_boundary(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,
                           p_last IN BOOLEAN DEFAULT false,
                           p_c_coderr     out varchar2, 
                           p_c_deserr     out varchar2                              
                           )
  IS
  BEGIN
    p_c_coderr := '000';
    IF (p_last) THEN
      UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468--'||UTL_TCP.CRLF);
    ELSE
      UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468'||UTL_TCP.CRLF);
    END IF;
  EXCEPTION
  WHEN OTHERS THEN  
    p_c_coderr := '5001';
    p_c_deserr := p_c_coderr ||'-'||sqlerrm;
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5001x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END write_boundary;
  
  PROCEDURE write_mime_header(p_conn  in out nocopy utl_smtp.connection,
                              p_name  in varchar2,
                              p_value in varchar2,
                              p_c_coderr out varchar2,
                              p_c_deserr out varchar2
                              )
  IS
  BEGIN
     p_c_coderr := '000';
     UTL_SMTP.WRITE_RAW_DATA(
     p_conn,
     UTL_RAW.CAST_TO_RAW( p_name || ': ' || p_value || UTL_TCP.CRLF)
     );
  EXCEPTION
  WHEN OTHERS THEN  
    p_c_coderr := '5003';
    p_c_deserr := p_c_coderr ||'-'||sqlerrm;    
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5003x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;         
  END write_mime_header;  
  
  PROCEDURE begin_attachment(p_conn         IN OUT NOCOPY UTL_SMTP.CONNECTION,
                             p_mime_type    IN VARCHAR2 DEFAULT 'text/plain',
                             p_inline       IN BOOLEAN DEFAULT false,
                             p_filename     IN VARCHAR2 DEFAULT null,
                             p_transfer_enc IN VARCHAR2 DEFAULT null,
                             p_c_coderr     out varchar2, 
                             p_c_deserr     out varchar2   
                             )
  IS

  BEGIN
     p_c_coderr := '000';
     write_boundary(p_conn,false,p_c_coderr,p_c_deserr);
     if p_c_deserr is not null then
       return;
     End If;

     IF (p_transfer_enc IS NOT NULL) THEN
       write_mime_header(p_conn, 'Content-Transfer-Encoding',p_transfer_enc,p_c_coderr,p_c_deserr);
       if p_c_deserr is not null then
         return;
       End If;       
     END IF;

     write_mime_header(p_conn, 'Content-Type', p_mime_type,p_c_coderr,p_c_deserr);
     if p_c_deserr is not null then
       return;
     End If;
     
     IF (p_filename IS NOT NULL) THEN
        IF (p_inline) THEN
           write_mime_header(p_conn,'Content-Disposition', 'inline; filename="' || p_filename || '"',p_c_coderr,p_c_deserr);
           if p_c_deserr is not null then
             return;
           End If;           
        ELSE
           write_mime_header(p_conn,'Content-Disposition', 'attachment; filename="' || p_filename || '"',p_c_coderr,p_c_deserr);
           if p_c_deserr is not null then
             return;
           End If;           
        END IF;
     END IF;
     UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);
  EXCEPTION
  WHEN OTHERS THEN  
    p_c_coderr := '5002';
    p_c_deserr := p_c_coderr ||'-'||sqlerrm;     
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5002x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END begin_attachment;

  PROCEDURE end_attachment(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,
                           p_last IN BOOLEAN DEFAULT TRUE,
                           p_c_coderr out varchar2,
                           p_c_deserr out varchar2
                           )
  IS

  BEGIN
     p_c_coderr := '000';
     IF (p_last) THEN
      write_boundary(p_conn, p_last,p_c_coderr,p_c_deserr);
      if p_c_deserr is not null then
        return;
      End if;  
     END IF;
  EXCEPTION
  WHEN OTHERS THEN  
    p_c_coderr := '5004';
    p_c_deserr := p_c_coderr ||'-'||sqlerrm;     
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5004x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END end_attachment;      

  PROCEDURE binary_attachment(p_conn      IN OUT UTL_SMTP.CONNECTION,
                              p_file_name IN VARCHAR2,
                              p_mime_type in VARCHAR2,
                              p_oracle_directory IN VARCHAR2,
                              p_c_coderr         out varchar2, 
                              p_c_deserr         out varchar2                               
                              )                            
  IS

  v_amt            BINARY_INTEGER := 672 * 3; 
  v_bfile          BFILE;
  v_file_length    PLS_INTEGER;
  v_buf            RAW(2100);
  v_modulo         PLS_INTEGER;
  v_pieces         PLS_INTEGER;
  v_file_pos       pls_integer := 1;

BEGIN
  p_c_coderr := '000';
  begin_attachment(p_conn => p_conn,
                   p_mime_type => p_mime_type,
                   p_inline => TRUE,
                   p_filename => p_file_name,
                   p_transfer_enc => 'base64',
                   p_c_coderr     => p_c_coderr,
                   p_c_deserr     => p_c_deserr
                   );
  if p_c_deserr is not null then
    return;
  End If;                     

  BEGIN
     v_bfile := BFILENAME(p_oracle_directory, p_file_name);

     -- Get the size of the file to be attached
     v_file_length := DBMS_LOB.GETLENGTH(v_bfile);

     -- Calculate the number of pieces the file will be split up into
     v_pieces := TRUNC(v_file_length / v_amt);

     -- Calculate the remainder after dividing the file into v_amt chunks
     v_modulo := MOD(v_file_length, v_amt);

     IF (v_modulo <> 0) THEN
       -- Since the file does not divide equally
       -- we need to go round the loop an extra time to write the last
       -- few bytes - so add one to the loop counter.
       v_pieces := v_pieces + 1;
     END IF;

     DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);


     FOR i IN 1 .. v_pieces LOOP
       -- we can read at the beginning of the loop as we have already calculated
       -- how many iterations we will take and so do not need to check
       -- end of file inside the loop.
       v_buf := NULL;
       DBMS_LOB.READ(v_bfile, v_amt, v_file_pos, v_buf);
       v_file_pos := I * v_amt + 1;
       UTL_SMTP.WRITE_RAW_DATA(p_conn, UTL_ENCODE.BASE64_ENCODE(v_buf));
     END LOOP;
   END;

   DBMS_LOB.FILECLOSE(v_bfile); 
   UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);  
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_c_coderr := '5005';
       p_c_deserr := p_c_coderr ||'-'||sqlerrm;    
       DBMS_LOB.FILECLOSE(v_bfile);
       UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);     
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5005x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;           
  WHEN OTHERS THEN
       p_c_coderr := '5006';
       p_c_deserr := p_c_coderr ||'-'||sqlerrm;    
       DBMS_LOB.FILECLOSE(v_bfile);
       UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);     
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '5006x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;              
  END binary_attachment;

  /*
  -- Procedimiento para adjuntar los archivos al stream del correo
  ---------------------------------------------------------------------------------------------------------------------
  PROCEDURE file_attach(p_Archivo varchar2) AS
  -- Variables para el procesamiento de Archivos
   rfile     RAW(57);
   flen      number;
   --bsize     NUMBER;
   src_file  bfile;
   buffer_   integer := 57;
   i         integer := 1;
  BEGIN

      -- Escribir cabecera MIME
      utl_smtp.write_data(c,'--MIME.Bound'||utl_tcp.CRLF);
      send_header('Content-Type','application/octet-stream; name="' || p_Archivo || '"');
      send_header('Content-Disposition', 'attachment; filename="' || p_Archivo || '"');
      send_header('Content-Transfer-Encoding', 'base64' );
      utl_smtp.write_data(c, utl_tcp.CRLF);

      -- Adicion del Archivo
      src_file := bfilename(p_Directorio, p_Archivo);
                flen := dbms_lob.getlength(src_file);

                dbms_lob.fileopen(src_file, dbms_lob.file_readonly);

                while i < flen loop
                      dbms_lob.read( src_file, buffer_, i, rfile );
                      utl_smtp.write_raw_data(c, utl_encode.base64_encode(rfile));
                      utl_smtp.write_data(c, utl_tcp.CRLF);
                      i := i + buffer_;
                end loop while_loop;

                dbms_lob.fileclose(src_file);
                utl_smtp.write_data(c, utl_tcp.CRLF||utl_tcp.CRLF);

  END;
  ------------------------------------------------------------------------------------------------------------------------------------
  */

  --Procedimiento para separacion y Adicion de Archivos Adjuntos
  ------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE add_attachments(p_Adjuntos in VARCHAR2, p_c_coderr out varchar2, p_c_deserr out varchar2) AS
  l_Cadena varchar2(32767) := p_Adjuntos;
  l_LargoCadena number;
  l_Comas number;
  l_PosicionComa number := 0;
  l_Archivo varchar2(100);
  
  BEGIN
  p_c_coderr := '000';
  l_LargoCadena := length(l_Cadena);
  l_Comas := l_LargoCadena-length(replace(l_Cadena,';'));

  --Bloque 1 Adicion del Archivo
      IF l_Comas > 0 THEN
            FOR l_segmento IN 1 .. l_Comas LOOP

                l_Archivo := substr(l_Cadena, l_PosicionComa + 1, instr(l_Cadena,';',1,l_segmento) - (l_PosicionComa + 1));
                binary_attachment(c,l_Archivo,'text/plain; name="'||l_Archivo||'"',trim(p_Directorio),p_c_coderr,p_c_deserr);
                if p_c_deserr is not null then
                  return;
                End If;  
                l_PosicionComa := instr(l_Cadena,';',1,l_Segmento);
            END LOOP;
      END IF;
  -- Fin de Bloque 1

  -- Bloque 2: Para insercion del ultimo archivo (o el primero, si es unico)
      l_Archivo := substr(l_Cadena, l_PosicionComa + 1, l_LargoCadena);
      binary_attachment(c,l_Archivo,'text/plain; name="'||l_Archivo||'"',trim(p_Directorio),p_c_coderr,p_c_deserr);
      if p_c_deserr is not null then
        return;
      End If;  
  -- Fin Bloque 2
    end_attachment(p_conn => c,
                   p_last => true,
                   p_c_coderr  => p_c_coderr, 
                   p_c_deserr  => p_c_deserr        
                   );         
  EXCEPTION
  WHEN OTHERS THEN     
    p_c_coderr := '1002';
    p_c_deserr := p_c_coderr ||'-' ||sqlerrm;
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '1002x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
  END;  
  
  --
  -- Inicia el código del armado del email
  --
  BEGIN
      p_c_coderr := '000';
      
      begin
--        select host_name
        select replace(upper(host_name),'.CMAC-AREQUIPA.COM.PE','')
          into lc_hostname
          from v$instance;
      end;
      
      For i in c_host loop
          lv_host := upper(TRIM(substr(i.tp1desc,1,instr(i.tp1desc,'/')-1)));        
          lv_smtp := TRIM(substr(i.tp1desc,instr(i.tp1desc,'/')+1,length(trim(i.tp1desc)))); 
          ln_port := i.tp1nro3;
          
          if upper(lc_hostname) = lv_host then
            Exit;
          End if;
      End loop;
      
      -- Bloque de Apertura de Conexion
      c := utl_smtp.open_connection(lv_smtp,ln_port);  --Recuerden que puede ser el nombre NetBios o la IP
      utl_smtp.helo(c, lv_smtp);
      utl_smtp.mail(c, p_Remitente);-- Remitente
      
      -- Bloque de Adicion de Destinatarios
      IF trim(p_DestinatariosPara) IS NOT NULL THEN
          add_rcpt(trim(p_DestinatariosPara), p_c_coderr, p_c_deserr);
          if p_c_deserr is not null then
            return;
          End If;            
      END IF;

      IF trim(p_DestinatariosCC) IS NOT NULL THEN
          add_rcpt(trim(p_DestinatariosCC), p_c_coderr, p_c_deserr);
          if p_c_deserr is not null then
            return;
          End If;            
      END IF;

      IF trim(p_DestinatariosBcc) IS NOT NULL THEN
          add_rcpt(trim(p_DestinatariosBcc), p_c_coderr, p_c_deserr);
          if p_c_deserr is not null then
            return;
          End If;            
      END IF;
            
      --Bloque de Apertura de Datos
      begin
               utl_smtp.open_data(c);
      Exception
      when others then
          p_c_coderr := '1003';
          p_c_deserr := p_c_coderr ||'-' ||sqlerrm;
          return;
      end;
                   
      -- Bloque de Adicion de Cabeceras de Mail
      IF trim(p_DestinatariosPara) IS NOT NULL THEN
          add_headers_rcpt(trim(p_DestinatariosPara), 'TO', p_c_coderr, p_c_deserr);
          if p_c_deserr is not null then
            return;
          End If;              
      END IF;

      IF trim(p_DestinatariosCC) IS NOT NULL THEN
          add_headers_rcpt(trim(p_DestinatariosCC), 'CC',p_c_coderr, p_c_deserr);
          if p_c_deserr is not null then
            return;
          End If;              
      END IF;

      send_header('Subject', trim(p_Asunto),p_c_coderr, p_c_deserr); --Asunto
      if p_c_deserr is not null then
        return;
      End If;        
      send_header('From', trim(p_Remitente),p_c_coderr, p_c_deserr); -- De
      if p_c_deserr is not null then
        return;
      End If;    
      
      send_header('Content-Transfer-Encoding', '7bit',p_c_coderr, p_c_deserr);   
      if p_c_deserr is not null then
        return;
      End If;            
      send_header('Content-Type','multipart/mixed;boundary="DMW.Boundary.605592468"',p_c_coderr, p_c_deserr); 
      if p_c_deserr is not null then
        return;
      End If;            
      send_header('MIME-Version','1.0',p_c_coderr, p_c_deserr);
      if p_c_deserr is not null then
        return;
      End If;            
      utl_smtp.write_data(c, utl_tcp.CRLF||'--DMW.Boundary.605592468'||utl_tcp.CRLF);
      send_header('Content-Transfer-Encoding', 'binary',p_c_coderr, p_c_deserr); 
      if p_c_deserr is not null then
        return;
      End If;            
                
      IF p_Mensaje IS NOT NULL THEN
        IF trim(p_TipoMensaje) = 'TEXT' THEN               
            send_header('Content-Type','text/plain',p_c_coderr, p_c_deserr);    
            if p_c_deserr is not null then
              return;
            End If;                  
            utl_smtp.write_data(c, utl_tcp.CRLF ||p_Mensaje||utl_tcp.CRLF);                                                     
        Else                       
            send_header('Content-Type','text/html',p_c_coderr, p_c_deserr);  
            if p_c_deserr is not null then
              return;
            End If;        
                                                  
            l_offset  := 1;
            l_ammount := 1900;      
            utl_smtp.write_data(c, utl_tcp.CRLF);
                
            while l_offset < dbms_lob.getlength(p_Mensaje) loop
              utl_smtp.write_data(c,dbms_lob.substr(p_Mensaje, l_ammount, l_offset));
              l_offset  := l_offset + l_ammount;
              l_ammount := least(1900, dbms_lob.getlength(p_Mensaje) - l_ammount);
            end loop;     
            utl_smtp.write_data(c, utl_tcp.CRLF);      
            utl_smtp.write_data(c, utl_tcp.CRLF ||utl_tcp.CRLF);                                        
        End If; 
      End If;
      
      -- Bloque de Envio de Adjuntos
      if trim(p_ArchivosAdjuntos) is not null then
         add_attachments(trim(p_ArchivosAdjuntos), p_c_coderr , p_c_deserr);         
         if p_c_deserr is not null then         
            return;
         End If;                  
      End If;         
      
      
      begin
        -- Bloque de Cierre de Datos y Envio del Mail
        utl_smtp.close_data(c);
      exception
      when others then
           p_c_coderr := '3000x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                   
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '30001';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
          end;        
      end;
      
      begin
         -- Bloque de Cierre de Conexion
         --utl_smtp.quit(c);
         utl_smtp.close_connection(c);
      exception
      when others then
       p_c_coderr := '40001';
       p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                         
      end;         
      
      EXCEPTION        
       WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error then
           p_c_coderr := '1005';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                   
          -- Bloque de Cierre de Conexion          
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '20000';
           p_c_deserr := 'Unable to send mail0: '||sqlerrm;                      
          end;
       WHEN OTHERS THEN
           p_c_coderr := '2000x';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                   
          -- Bloque de Cierre de Conexion
          begin
             --utl_smtp.quit(c);
             utl_smtp.close_connection(c);
          exception
          when others then
           p_c_coderr := '20001';
           p_c_deserr := p_c_deserr||'-'||p_c_coderr||'-'||sqlerrm;                   
          end;          
      END;  
  Procedure sp_ah_envia_mail(P_D_FECPRO IN DATE,
                             P_C_TIPCAR IN VARCHAR2,  
                             P_C_TIPFOR IN VARCHAR2,            
                             P_C_CODUSU IN VARCHAR2,
                             p_c_coderr out varchar2,                    
                             p_c_deserr out varchar2
                             ) is    
                               
  cursor c_planilla(lc_usuario in char) is
    select x.*
      from jaqz174 x 
     where x.jaqz174tip = P_C_TIPCAR                              
       and x.jaqz174for = P_C_TIPFOR
       and x.jaqz174fec = P_D_FECPRO
       and x.jaqz174usu = lc_usuario
       and x.jaqz174est = 'G';
       
  cursor c_contactos(ln_pais in number, ln_tipo in number, lc_numero in char)        is
   select y.* 
     from jaqz172 y
    where y.jaqz172pai = ln_pais
      and y.jaqz172tpo = ln_tipo
      and y.jaqz172num = lc_numero
      and trim(y.jaqz172mai) is not null
      and pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';
      /*and case
            when REGEXP_LIKE(trim(y.jaqz172mai),
                             '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                             'i') then
             'S'
            else
             'N'
          end = 'S';     */ 
  
  cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 61
       and a.Tp1corr2 = 6; 
      
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(30);  
    lv_asunto     VARCHAR2(30);  
    lv_directorio VARCHAR2(30);  
    lv_archivos   VARCHAR2(30);  
    lv_contacto   VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';  
    lv_estado     CHAR(1);
    lv_deserr     VARCHAR2(400);  
    lv_coderr     VARCHAR2(400);      
    lc_usuario    CHAR(10);
    ln_cont       NUMBER(9):=0;
    ln_cont2      NUMBER(9):=0;
    ln_moneda     NUMBER(3):=0;
    lv_moneda     VARCHAR2(15):=null;
    lv_valida     VARCHAR2(1);
    
  begin
    p_c_coderr := '000';   
    lc_usuario := rpad(P_C_CODUSU,10,' ');
      
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := trim(i.tp1desc);
         When i.tp1nro1 = 3 then
           lv_directorio := trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
      
    ln_cont := 0;       
    For j in c_planilla(lc_usuario) loop
        ln_cont  := ln_cont + 1;
        ln_cont2 := 0;
        lv_destinos := '';
        ln_moneda := to_number(substr(j.jaqz174nom,1,3));
        if ln_moneda= 0 then
          lv_moneda := 'soles';
        Else
          lv_moneda := 'd&oacute;lares';
        End If;
        For k in c_contactos(j.jaqz174pai,j.jaqz174tpo,j.jaqz174num) loop            
           ln_cont2 := ln_cont2 + 1;  
           lv_destinos := lv_destinos||trim(k.jaqz172mai)||';';   
           lv_contacto := trim(k.jaqz172no1);      
        End loop;  
        lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
                
        if ln_cont2 > 0 then
            dbms_lob.createtemporary(ll_mensaje, TRUE);  
            if ln_cont2 > 1 then           
               lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados(a): </p>' ||  
                             '<p "font-family: Arial, sans-serif; font-size: 14px;">De acuerdo a lo registrado en nuestro sistema, adjunto se remite la planilla de cuentas CTS en '||lv_moneda||' de sus trabajadores.</p>';  
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
               lv_mensaje := '<table  style="padding:0" border="0" cellspacing="0">
                                <tbody>
                                  <tr>
                                  <td height=368>                                  
                                  <img src="https://www.cajaarequipa.pe/documents/parte1.jpg" border="0" height=368>
                                  </td>      
                                  </tr>	
                                  <tr>
                                  <td height=167>
                                  <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                  <img src="https://www.cajaarequipa.pe/documents/parte3.jpg" border="0" height=167>
                                  </a>
                                  </td>      
                                  </tr>	 
                                  <tr>
                                  <td height=166>
                                  <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                  <img src="https://www.cajaarequipa.pe/documents/parte2.jpg" border="0" height=166>
                                  </a>
                                  </td>      
                                  </tr>	 
                                  <tr>
                                  <td height=264>
                                  <img src="https://www.cajaarequipa.pe/documents/parte4.jpg" border="0" height=264>
                                  </td>      
                                  </tr>	                                                                                                                                          
                                </tbody>
                              </table>';        
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                              
               lv_mensaje := 
               '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
               
               lv_mensaje := 
               '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';                                          
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                         
            Else            
               lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                             '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| lv_contacto || '</p>' ||
                             '<p "font-family: Arial, sans-serif; font-size: 14px;">De acuerdo a lo registrado en nuestro sistema, adjunto se remite la planilla de cuentas CTS en '||lv_moneda||' de sus trabajadores.</p>';                               
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                   
               lv_mensaje := '<table  style="padding:0" border="0" cellspacing="0">
                                <tbody>
                                  <tr>
                                  <td height=368>                                  
                                  <img src="https://www.cajaarequipa.pe/documents/parte1.jpg" border="0" height=368>
                                  </td>      
                                  </tr>	
                                  <tr>
                                  <td height=167>
                                  <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                  <img src="https://www.cajaarequipa.pe/documents/parte3.jpg" border="0" height=167>
                                  </a>
                                  </td>      
                                  </tr>	 
                                  <tr>
                                  <td height=166>
                                  <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                  <img src="https://www.cajaarequipa.pe/documents/parte2.jpg" border="0" height=166>
                                  </a>
                                  </td>      
                                  </tr>	 
                                  <tr>
                                  <td height=264>
                                  <img src="https://www.cajaarequipa.pe/documents/parte4.jpg" border="0" height=264>
                                  </td>      
                                  </tr>	                                                                                                                                          
                                </tbody>
                              </table>';       
                                       
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
               
               lv_mensaje := 
               '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                         
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
               
               lv_mensaje := 
               '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';                                          
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                         
                          
            End If;  
            
            begin
              p_c_coderr := '000';
              lv_archivos := trim(j.jaqz174nom);
              
                  begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                   p_destinatarioscc   => '',
                                                   p_destinatariosbcc  => CASE
                                                                          WHEN P_C_TIPFOR = 'M' THEN
                                                                            lower(TRIM(P_C_CODUSU))||'@cajaarequipa.pe'
                                                                          ELSE
                                                                            ''
                                                                          END,
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_remitente,
                                                   p_asunto            => lv_asunto,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => lv_directorio,
                                                   p_archivosadjuntos  => lv_archivos,
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_deserr
                                                   );
                  exception
                  when others then  
                       p_c_coderr := '00x';
                       p_c_deserr := sqlerrm;                                                   
                  end;
                                               
                  if p_c_coderr <> '000' then
                     lv_estado := 'E';
                     lv_deserr := p_c_deserr;
                  Else
                     if ln_cont2 = 1 then
                       lv_valida := 'N'; 
  	                   pq_cl_volcado_campana.sp_valida_mail(lv_destinos,lv_valida);
                       If lv_valida = 'N' then
                         lv_estado := 'E';
                         lv_deserr := 'Cuenta de correo incorrecta';                         
                       Else
                         lv_estado := 'S';
                         lv_deserr := 'Envio Satisfactorio';                         
                         End If;  
                     else
                       lv_estado := 'S';
                       lv_deserr := 'Envio Satisfactorio';
                     End if;
                  End If;
                  
                  -- Call the procedure
                  pq_ah_planillas.sp_ah_upd_est(p_n_numsec => j.jaqz174sec,
                                                p_d_fecpro => P_D_FECPRO,
                                                p_c_codusu => P_C_CODUSU,
                                                p_c_codest => lv_estado,
                                                p_c_desmsg => lv_deserr,
                                                p_c_comail => lv_destinos,
                                                p_c_coderr => lv_coderr,
                                                p_c_deserr => lv_deserr
                                                ); 
                if  lv_coderr <> '000' then
                  return;
                End If;                                                      
            exception
            when others then                                                                                  
              p_c_coderr := '00x';
              p_c_deserr := sqlerrm;        
            end;  
            dbms_lob.freetemporary(ll_mensaje);        
        Else --no tiene contactos       
          --obtenemos mail de la empresa
            begin
              select trim(substr(qq.pextxt,1,instr(qq.pextxt,'\')-1)) 
                into lv_destinos
                from (
                        select z.*
                          from fsx001 z 
                         where z.pepais = j.jaqz174pai
                           and z.petdoc = j.jaqz174tpo
                           and z.pendoc = j.jaqz174num  
                           and z.txcod  = 0 
                      order by z.pexren desc
                     )qq   
                where rownum =1
                  and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(qq.pextxt,1,instr(qq.pextxt,'\')-1))) = 'S';
                  /*and case
                        when REGEXP_LIKE(trim(substr(qq.pextxt,1,instr(qq.pextxt,'\')-1)) ,
                                         '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                         'i') then
                         'S'
                        else
                         'N'
                      end = 'S';     */           
                begin
                   p_c_coderr := '000';                  
                   dbms_lob.createtemporary(ll_mensaje, TRUE);              
                   lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                                 '<p "font-family: Arial, sans-serif; font-size: 14px;">De acuerdo a lo registrado en nuestro sistema, adjunto se remite la planilla de cuentas CTS en '||lv_moneda||' de sus trabajadores.</p>';  	                                
                   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
                   lv_mensaje := '<table  style="padding:0" border="0" cellspacing="0">
                                    <tbody>
                                      <tr>
                                      <td height=368>                                  
                                      <img src="https://www.cajaarequipa.pe/documents/parte1.jpg" border="0" height=368>
                                      </td>      
                                      </tr>	
                                      <tr>
                                      <td height=167>
                                      <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                      <img src="https://www.cajaarequipa.pe/documents/parte3.jpg" border="0" height=167>
                                      </a>
                                      </td>      
                                      </tr>	 
                                      <tr>
                                      <td height=166>
                                      <a href="https://www.cajaarequipa.pe/cuenta-cts/">
                                      <img src="https://www.cajaarequipa.pe/documents/parte2.jpg" border="0" height=166>
                                      </a>
                                      </td>      
                                      </tr>	 
                                      <tr>
                                      <td height=264>
                                      <img src="https://www.cajaarequipa.pe/documents/parte4.jpg" border="0" height=264>
                                      </td>      
                                      </tr>	                                                                                                                                          
                                    </tbody>
                                  </table>';  

                   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                  
                   lv_mensaje := 
                   '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';           
                                  
                   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
                   
                   lv_mensaje := 
                   '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';                                          
                   dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                         
                   
                                                   
                  lv_archivos := trim(j.jaqz174nom);
                      begin
                      -- Call the procedure
                      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                       p_destinatarioscc   => '',
                                                       p_destinatariosbcc  => CASE
                                                                              WHEN P_C_TIPFOR = 'M' THEN
                                                                                lower(TRIM(P_C_CODUSU))||'@cajaarequipa.pe'
                                                                              ELSE
                                                                                ''
                                                                              END,
                                                       p_mensaje           => ll_mensaje,
                                                       p_remitente         => lv_remitente,
                                                       p_asunto            => lv_asunto,
                                                       p_tipomensaje       => '',
                                                       p_directorio        => lv_directorio,
                                                       p_archivosadjuntos  => lv_archivos,
                                                       p_c_coderr          => p_c_coderr,
                                                       p_c_deserr          => p_c_deserr
                                                       );
                      exception
                      when others then                                                                                    
                         p_c_coderr := '00x';
                         p_c_deserr := sqlerrm;                             
                      end;  
                                                       
                      if p_c_coderr <> '000' then
                         lv_estado := 'E';
                         lv_deserr := p_c_deserr;
                      Else
                         lv_valida := 'N'; 
                         pq_cl_volcado_campana.sp_valida_mail(lv_destinos,lv_valida);
                         If lv_valida = 'N' then
                           lv_estado := 'E';
                           lv_deserr := 'Cuenta de correo incorrecta';                         
                         Else
                           lv_estado := 'S';
                           lv_deserr := 'Envio Satisfactorio';                         
                         End If;  
                      End If;
                      
                      -- Call the procedure
                      pq_ah_planillas.sp_ah_upd_est(p_n_numsec => j.jaqz174sec,
                                                    p_d_fecpro => P_D_FECPRO,
                                                    p_c_codusu => P_C_CODUSU,
                                                    p_c_codest => lv_estado,
                                                    p_c_desmsg => lv_deserr,
                                                    p_c_comail => lv_destinos,                                                
                                                    p_c_coderr => lv_coderr,
                                                    p_c_deserr => lv_deserr
                                                    ); 
                    if  lv_coderr <> '000' then
                      return;
                     End If;                                                                         
                exception
                when others then                                                                                  
                  p_c_coderr := '00x';
                  p_c_deserr := sqlerrm;        
                end;                  
                dbms_lob.freetemporary(ll_mensaje);
            Exception
            when others then  
              p_c_coderr := '00z';
              p_c_deserr := 'No existe email destino para enviar la planilla'; 
              --registramos el error en la tabla    

              lv_estado := 'E';
              lv_deserr := p_c_deserr;
              -- Call the procedure
              pq_ah_planillas.sp_ah_upd_est(p_n_numsec => j.jaqz174sec,
                                            p_d_fecpro => P_D_FECPRO,
                                            p_c_codusu => P_C_CODUSU,
                                            p_c_codest => lv_estado,
                                            p_c_desmsg => lv_deserr,
                                            p_c_comail => lv_destinos,                                            
                                            p_c_coderr => p_c_coderr,
                                            p_c_deserr => p_c_deserr
                                            );   
                if  p_c_coderr <> '000' then
                  return;
                End If;                                                           
            End;          
        End If;  
    End loop;
    if ln_cont = 0 then
       p_c_coderr := '00y';
       p_c_deserr := 'No Existen Planillas a enviar.';    
    Else
       If p_c_coderr = '000' then            
          p_c_deserr := 'Envio Satisfactorio';
       End if;      
    End if;      
  exception 
  when others then  
    p_c_coderr := '00x';
    p_c_deserr := sqlerrm;
  end sp_ah_envia_mail;                             
  procedure sp_cl_add_months(P_D_FECINI IN DATE,
                             P_N_NUMMEN IN NUMBER,            
                             p_d_fecfin out date
                             ) is            
  begin
    p_d_fecfin := Add_months(P_D_FECINI,P_N_NUMMEN);
  exception
  when others then  
    p_d_fecfin := Null;
  end;   
  Procedure sp_ah_veri_pro(P_D_FECPRO IN DATE,
                           P_C_TIPCAR IN VARCHAR2,  
                           P_C_TIPFOR IN VARCHAR2,            
                           P_C_CODUSU IN VARCHAR2,
                           P_N_CODPAI IN NUMBER,
                           P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,   
                           P_N_NUMINI IN NUMBER,
                           P_N_NUMFIN IN NUMBER,                           
                           p_c_coderr out varchar2,                    
                           p_c_deserr out varchar2
                           ) is  
  lc_usuario char(10):=null;
  lc_numdoc  char(12):=null;
                           
  begin
     p_c_coderr := '000';        
    --obtenemos sucursal del suuario
    lc_usuario := rpad(P_C_CODUSU,10,' ');
    lc_numdoc  := rpad(P_C_NUMDOC,12,' ');
    
    if P_C_TIPFOR = 'M' then
       --verificamos si hay otras generadas para mismo usuario, fecha, misma empresa  
       begin
         update jaqz174 x 
            set x.jaqz174est = 'I',
                x.jaqz174err = 'Inhabilitado por Reproceso'
          where x.jaqz174tip = P_C_TIPCAR
            and x.jaqz174for = P_C_TIPFOR
            and x.jaqz174fec = P_D_FECPRO
            and x.jaqz174usu = lc_usuario
            and x.jaqz174pai = P_N_CODPAI
            and x.jaqz174tpo = P_N_TIPDOC
            and x.jaqz174num = lc_numdoc
            and x.jaqz174est = 'G';
       end;
    Else
       begin
         update jaqz174 x 
            set x.jaqz174est = 'I',
                x.jaqz174err = 'Inhabilitado por Reproceso'
          where x.jaqz174tip = P_C_TIPCAR
            and x.jaqz174for = P_C_TIPFOR
            and x.jaqz174fec = P_D_FECPRO
            and x.jaqz174usu = lc_usuario
            and x.jaqz174cta >= P_N_NUMINI
            and x.jaqz174cta <= P_N_NUMFIN
            and x.jaqz174est = 'G';
       end;         
    End If;  
    commit;         
  exception
  when others then  
    p_c_coderr := '002';
    p_c_deserr := substr(sqlerrm,1,100);        
  end sp_ah_veri_pro;     
  Procedure sp_ah_valida_envio(P_D_FECPRO IN DATE,
                               P_C_TIPCAR IN VARCHAR2,  
                               P_C_TIPFOR IN VARCHAR2,            
                               P_C_CODUSU IN VARCHAR2,
                               P_N_CODPAI IN NUMBER,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2,   
                               p_n_numsec out number,           	
                               p_c_coderr out varchar2,                    
                               p_c_deserr out varchar2
                              ) is  
  lc_usuario char(10):=null;
  lc_numdoc  char(12):=null;  
  ln_total   number(15):=0;                             
  begin
     p_c_coderr := '000';        
    --obtenemos sucursal del suuario
    lc_usuario := rpad(P_C_CODUSU,10,' ');
    lc_numdoc  := rpad(P_C_NUMDOC,12,' ');    
            
    if P_C_TIPFOR = 'M' then
       select nvl(min(x.jaqz174SEC),0)
         into ln_total
         from jaqz174 x
        where x.jaqz174tip = P_C_TIPCAR
          and x.jaqz174for = P_C_TIPFOR
          and x.jaqz174fec = P_D_FECPRO
          and x.jaqz174usu = lc_usuario
          and x.jaqz174pai = P_N_CODPAI
          and x.jaqz174tpo = P_N_TIPDOC
          and x.jaqz174num = lc_numdoc
          and x.jaqz174est = 'G';       
    Else
       select nvl(min(x.jaqz174SEC),0)
         into ln_total       
         from jaqz174 x
        where x.jaqz174tip = P_C_TIPCAR
          and x.jaqz174for = P_C_TIPFOR
          and x.jaqz174fec = P_D_FECPRO
          and x.jaqz174usu = lc_usuario
          and x.jaqz174est = 'G';      
    End If;
    p_n_numsec := ln_total;        
    
    if ln_total > 0 then
       p_c_coderr := '000';
       p_c_deserr := '';      
    else
       p_c_coderr := '001';
       p_c_deserr := 'No Existe Planillas pendientes de enviar';      
    End if;
  exception
  when others then  
       p_c_coderr := '00x';
       p_c_deserr := 'No Existe Planillas pendientes de enviar';
  end;        
  Procedure sp_ah_planillas(P_N_NUMSEQ IN NUMBER,
                            P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_D_FECPRO IN OUT DATE,
                            P_C_CODHOR IN OUT VARCHAR2,
                            P_C_CODUSU IN OUT VARCHAR2,                                       
                            P_C_TIPACC IN OUT VARCHAR2,
                            P_C_TIPFOR IN VARCHAR2,
                            P_C_CODEXT IN VARCHAR2,
                            P_C_TIPABO IN OUT VARCHAR2,
                            P_N_CODBAN IN OUT NUMBER,
                            P_N_NUMCOD IN OUT NUMBER,
                            P_C_CODCTA IN OUT VARCHAR2,
                            P_C_DESOBS IN OUT VARCHAR2,
                            P_C_CODMES IN OUT VARCHAR2,
                            P_N_NUMANO IN OUT NUMBER,
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2
                           ) is   
/* ************************************************************************************************************
    -- Nombre                     : sp_ah_planillas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Módulo de carga planillas CTS 
    -- Descripción                : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Versión                    : 2.0
    -- Fecha de Modificación      : 15/05/2019
    -- Autor de la Modificación   : YLOZADA
    -- Descripción de Modificación: Se adicionó validación cuando empleador presente mas de una cuenta cliente
    --
* *************************************************************************************************************/
                           
  ln_codsuc  number(3);    
  lc_usuario char(10);   
  --lc_pendoc  char(12);     
  ln_numcta  number(9):=0;    
  lv_nomarc  varchar2(30);
  lv_nomrep  varchar2(30);
  lv_deserr  varchar2(255);      
  lv_tipo    varchar2(1); 
  --ln_cont    number(9):=0;
  --lv_cadena  varchar2(400);
  --lv_aguja   varchar2(400);
  --ln_pos     number(9):=0;  
  lc_desusu varchar2(30):='';
  lc_desage varchar2(30):='';
 
/*  cursor c_cuentas(lc_pendoc in char) is  
    select distinct b.ctnro
      from fsr008 b 
     where b.pepais = P_N_CODPAI 
       and b.petdoc = P_N_TIPDOC
       and b.pendoc = lc_pendoc                                                           
       and b.pgcod  = 1
       and b.ttcod  = 1
       and b.cttfir = 'T'    
  order by b.pepais,
           b.petdoc,
           b.pendoc;  */
                      
/* cursor c_cuentasa(p_n_numcta in number) is  
    select lpad(b.pepais, 3, '0') ||
           lpad(b.petdoc, 2, '0') ||
           lpad(trim(b.pendoc), 12, '0') cadena
      from fsr008 b
     where b.pgcod = 1
       and b.ctnro = p_n_numcta
     order by b.pepais, b.petdoc, b.pendoc;     */
                 
  begin
    p_c_coderr := '000';
    p_c_deserr := '';    
    -- Datos basicos
    lc_usuario := rpad(P_C_CODUSU,10,' ');   
    --lc_pendoc  := rpad(P_C_NUMDOC,12,' ');            

    begin
      select x.ubsuc 
        into ln_codsuc 
        from fst046 x 
       where x.pgcod  = 1 
         and x.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 0;
    end; 
    --cuenta cliente de la persona juridica
    --ln_cont := 0;
    --ln_pos  := 0;
    --lv_cadena := null;
/*    for i in c_cuentas loop
        ln_cont := ln_cont + 1;
        lv_aguja := null;
        for j in c_cuentasa(i.ctnro) loop        
           lv_aguja := lv_aguja || j.cadena;    
        End loop;
        if ln_cont > 1 then 
           ln_pos := instr(lv_cadena,lv_aguja);   
        End if;
        lv_cadena := lv_cadena||'*'||lv_aguja;
        
        if ln_pos > 0 then        
              p_c_coderr := '001';
              p_c_deserr := 'Error: Cliente presenta mas de una cuenta cliente';   
              return; 
        Else
          ln_numcta := i.ctnro;         
        End If;                
      End loop;  */
      
    -- inicio ylozada 15/05/2019  
      pq_ah_planillas.sp_ah_cta_emp_cts(p_n_codpai => P_N_CODPAI, 
                                        p_n_tipdoc => P_N_TIPDOC,
                                        p_c_numdoc => P_C_NUMDOC,   
                                        p_n_tippro => 2,    
                                        p_c_numcta => ln_numcta,
                                        p_c_coderr => p_c_coderr,
                                        p_c_deserr => p_c_deserr
                                        );    
      if p_c_coderr <> '000' Then                                     
           return;  
      End if;           
    
    --fin ylozada15/05/2019
    /*
    if ln_numcta = 0 then
          p_c_coderr := '001';
          p_c_deserr := 'Error: Cliente no presenta una cuenta cliente';           
          return;       
    End If;
    */
    --obtenemos repositorio
    begin
      select trim(a.tp1desc)
        into lv_nomrep 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio  
    exception
    when others then
       p_c_coderr := '002';
       p_c_deserr := 'Error: No existe repositorio definido';
       return;
    end; 
            
    Case
      When P_C_TIPACC = 'C' then --CARGA
        lv_nomarc := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(P_N_TIPDOC,2,'0')||lpad(trim(P_C_NUMDOC),12,'0')||P_C_CODEXT;  
        pq_ah_planillas.sp_ah_regcar(p_n_codpai => P_N_CODPAI,
                                     p_n_tipdoc => P_N_TIPDOC,
                                     p_c_numdoc => P_C_NUMDOC,
                                     p_n_numcta => ln_numcta,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_nomarc => lv_nomarc,
                                     p_c_nomrep => lv_nomrep,
                                     p_c_tipfor => P_C_TIPFOR,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_tipabo => P_C_TIPABO,
                                     p_n_codban => P_N_CODBAN,
                                     p_n_numcod => P_N_NUMCOD,
                                     p_c_codcta => P_C_CODCTA,
                                     p_c_codmes => P_C_CODMES,
                                     p_n_numano => P_N_NUMANO,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
                                     
        if p_c_coderr = '000' then                             
           lv_deserr := 'Grabación satisfactoria';         
        End If;                                              
         
        if p_c_coderr = '000' then          
          lv_tipo := 'P'; --Envio a procesos centrales
          --obtenemos la agencia          
          begin
            Select a.scnom
              into lc_desage
              from fst001 a 
             where a.pgcod  = 1 
               and a.sucurs = ln_codsuc;
          exception
          when others then  
            lc_desage := '';
          end;               
          --obtenemos el nombre del usuario
          begin
            Select a.ubnom
              into lc_desusu
              from fst746 a 
             where a.ubuser = lc_usuario;
          exception
          when others then  
            lc_desusu := '';
          end;                         
                           
          pq_ah_planillas.sp_ah_enviomail(p_d_fecpro => P_D_FECPRO,
                                          p_c_codhor => P_C_CODHOR,
                                          p_c_tipenv => lv_tipo,
                                          p_n_numseq => ln_numcta,
                                          p_c_nomarc => lc_desage||'- '||lc_desusu||' - '||lc_usuario,
                                          p_c_coderr => p_c_coderr,
                                          p_c_deserr => p_c_deserr
                                          );                                          
                                                                              
          if p_c_coderr <> '000' then                             
             lv_deserr := lv_deserr||', '||'no se pudo enviar email: '||substr(p_c_deserr,1,150);         
          End If;      
          p_c_deserr := lv_deserr ;                                                                                                                                                                  
        End If;                                      
                                     
      When P_C_TIPACC = 'D' then --DESCARGA              
        pq_ah_planillas.sp_ah_regdes(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_nomrep => lv_nomrep,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
      When P_C_TIPACC = 'P' then --PROCESADO
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           p_c_deserr := 'Se procesó el archivo satisfactoriamente';         
        End If;   
                                             
      When P_C_TIPACC = 'E' then --PENDIENTE       
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           p_c_deserr := 'Grabación satisfatoria';         
        End If;                                        
                                     
      When P_C_TIPACC = 'R' then --RECHAZADO               
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           lv_deserr := 'Grabación satisfactoria';         
        End If;                                              
         
        if p_c_coderr = '000' then          
          lv_tipo := 'C'; --Envio al contacto          
                                          
          pq_ah_planillas.sp_ah_enviomail(p_d_fecpro => P_D_FECPRO,
                                          p_c_codhor => P_C_CODHOR,
                                          p_c_tipenv => lv_tipo,
                                          p_n_numseq => P_N_NUMSEQ,
                                          p_c_nomarc => null,
                                          p_c_coderr => p_c_coderr,
                                          p_c_deserr => p_c_deserr
                                          );                                          
                                                                              
          if p_c_coderr <> '000' then                             
             lv_deserr := lv_deserr||', '||'no se pudo enviar email: '||substr(p_c_deserr,1,150);         
          End If;      
          p_c_deserr := lv_deserr ;                                                                                                                                                                  
        End If; 
                                                                                           
      When P_C_TIPACC = 'A' then --ANULADO
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
      When P_C_TIPACC = 'X' then --DATOS PARA PROCESAR                                                    
        pq_ah_planillas.sp_ah_regdat(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => p_d_fecpro,
                                     p_c_horpro => p_c_codhor,
                                     p_c_codusu => p_c_codusu,
                                     p_c_tipabo => p_c_tipabo,
                                     p_n_codban => p_n_codban,
                                     p_n_numcod => p_n_numcod,
                                     p_c_codcta => p_c_codcta,
                                     p_c_codmes => p_c_codmes,
                                     p_n_numano => p_n_numano,
                                     p_c_desobs => p_c_desobs,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );                                                                                                
    End Case;  

  exception
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;
  end sp_ah_planillas;       
  
  Procedure sp_ah_regcar(P_N_CODPAI IN NUMBER,
                         P_N_TIPDOC IN NUMBER,
                         P_C_NUMDOC IN VARCHAR2,
                         P_N_NUMCTA IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,
                         P_C_NOMARC IN VARCHAR2,
                         P_C_NOMREP IN VARCHAR2,
                         P_C_TIPFOR IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         P_C_TIPABO IN VARCHAR2,
                         P_N_CODBAN IN NUMBER,
                         P_N_NUMCOD IN NUMBER,
                         P_C_CODCTA IN VARCHAR2,
                         P_C_CODMES IN VARCHAR2,
                         P_N_NUMANO IN NUMBER,                                   
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ) is                
  l_bfile    BFILE;
  l_blob     BLOB;                            
  begin       
    p_c_coderr := '000';
    p_c_deserr := '';
                     
    insert into JAQZ177(jaqz177seq,
                        jaqz177fca,
                        jaqz177hrc,
                        jaqz177usc,
                        jaqz177agc,
                        jaqz177pai,
                        jaqz177tpo,
                        jaqz177num,
                        jaqz177cta,
                        jaqz177nom,
                        jaqz177arc,
                        jaqz177tfo,
                        jaqz177tip,
                        jaqz177ban,
                        jaqz177cod,                        
                        jaqz177cue,
                        jaqz177mes,
                        jaqz177ano,
                        jaqz177est,
                        jaqz177fer,
                        jaqz177hor,
                        jaqz177usr,
                        jaqz177agr
                        )
                 values(SQ_AH_ID_GENPLA.NEXTVAL,
                        P_D_FECPRO,
                        P_C_HORPRO,
                        P_C_CODUSU,
                        P_N_CODAGE,
                        P_N_CODPAI,
                        P_N_TIPDOC,
                        P_C_NUMDOC,
                        P_N_NUMCTA,
                        P_C_NOMARC,
                        EMPTY_BLOB(),
                        P_C_TIPFOR,
                        P_C_TIPABO,
                        P_N_CODBAN,
                        P_N_NUMCOD,
                        P_C_CODCTA,
                        P_C_CODMES,
                        P_N_NUMANO,
                        P_C_CODEST,
                        trunc(sysdate),
                        to_char(sysdate,'HH24:mi:ss'),
                        P_C_CODUSU,
                        P_N_CODAGE                        
                        )
                        RETURN jaqz177arc INTO l_blob;                          
                                
      l_bfile := BFILENAME(P_C_NOMREP, P_C_NOMARC);
      DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
      DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
      DBMS_LOB.fileclose(l_bfile);
      COMMIT;                                
                     
  exception
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_ah_regcar;   
                    
  Procedure sp_ah_regdes(P_N_NUMSEQ IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,                         
                         P_C_NOMREP IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ) is                
  vblob BLOB;
  vstart NUMBER := 1;
  bytelen NUMBER := 32000;
  len NUMBER;
  my_vr RAW(32000);
  x NUMBER;
  l_output utl_file.file_type;   
  lv_nomarc      varchar2(30);                      
  
  begin                    
    p_c_coderr := '000';
    p_c_deserr := '';   
    vstart  := 1;
    bytelen := 32000;

    -- get length of blob
    begin
      Select dbms_lob.getlength(a.jaqz177arc), 
             a.jaqz177arc,
             trim(a.jaqz177nom)
        into len, 
             vblob,
             lv_nomarc
        from jaqz177 a
       where a.jaqz177seq = P_N_NUMSEQ;
    Exception  
    When Others then
      p_c_coderr := '006';
      p_c_deserr := sqlerrm;        
      return;
    End;    
    -- define output directory
    l_output := utl_file.fopen(P_C_NOMREP, lv_nomarc,'wb', 32760);

 
    -- save blob length
    x := len;

    -- if small enough for a single write
    If len < 32760 then
      utl_file.put_raw(l_output,vblob);
      utl_file.fflush(l_output);
    Else -- write in pieces
        vstart := 1;
        While vstart < len and bytelen > 0
        Loop
           dbms_lob.read(vblob,bytelen,vstart,my_vr);

           utl_file.put_raw(l_output,my_vr);
           utl_file.fflush(l_output);

           -- set the start position for the next cut
           vstart := vstart + bytelen;

           -- set the end position if less than 32000 bytes
           x := x - bytelen;
           If x < 32000 Then
              bytelen := x;
           End If;
        End Loop;
        utl_file.fclose(l_output);
    End If;   
    begin
      update jaqz177 a
         set a.jaqz177fde = P_D_FECPRO,
             a.jaqz177hrd = P_C_HORPRO,
             a.jaqz177usd = P_C_CODUSU,
             a.jaqz177agd = P_N_CODAGE,
             a.jaqz177est = P_C_CODEST,
             a.jaqz177fem = P_D_FECPRO,
             a.jaqz177hom = P_C_HORPRO,
             a.jaqz177usm = P_C_CODUSU,  
             a.jaqz177agm = P_N_CODAGE
       where a.jaqz177seq = P_N_NUMSEQ;
    Exception  
    When Others then
      p_c_coderr := '005';
      p_c_deserr := sqlerrm;        
      return;
    End;  
    commit;    
  Exception
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_ah_regdes; 
  Procedure sp_ah_regest(P_N_NUMSEQ IN NUMBER,
                         P_D_FECPRO IN DATE,
                         P_C_HORPRO IN VARCHAR2,
                         P_C_CODUSU IN VARCHAR2,
                         P_N_CODAGE IN VARCHAR2,                         
                         P_C_DESOBS IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ) is
  Begin     
    p_c_coderr := '000';
    p_c_deserr := '';   
                                 
    update jaqz177 a
       set a.jaqz177fpr = P_D_FECPRO,
           a.jaqz177hrp = P_C_HORPRO,
           a.jaqz177usp = P_C_CODUSU,
           a.jaqz177agp = P_N_CODAGE,
           a.jaqz177est = P_C_CODEST,
           a.jaqz177obs = P_C_DESOBS,
           a.jaqz177fem = P_D_FECPRO,
           a.jaqz177hom = P_C_HORPRO,
           a.jaqz177usm = P_C_CODUSU,  
           a.jaqz177agm = P_N_CODAGE                
     where a.jaqz177seq = P_N_NUMSEQ;   
     commit; 
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_ah_regest;      
  
  Procedure sp_ah_regdat(P_N_NUMSEQ IN NUMBER,
                         p_d_fecpro out date,
                         p_c_horpro out varchar2,
                         p_c_codusu out varchar2,
                         p_c_tipabo out varchar2,
                         p_n_codban out number,
                         p_n_numcod out number,
                         p_c_codcta out varchar2,
                         p_c_codmes out varchar2,
                         p_n_numano out number,
                         p_c_desobs out varchar2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ) is
  Begin     
    p_c_coderr := '000';
    p_c_deserr := '';   
                                 
     select a.jaqz177fca,
            a.jaqz177hrc,
            a.jaqz177usc,
            a.jaqz177tip,
            a.jaqz177ban,
            a.jaqz177cod,
            a.jaqz177cue,
            a.jaqz177mes,
            a.jaqz177ano,
            a.jaqz177obs
       into p_d_fecpro,    
            p_c_horpro,
            p_c_codusu,
            p_c_tipabo,
            p_n_codban,
            p_n_numcod,
            p_c_codcta,
            p_c_codmes,
            p_n_numano,
            p_c_desobs
       from jaqz177 a
      where a.jaqz177seq = P_N_NUMSEQ;     
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_ah_regdat;    
  Procedure sp_ah_regenv(P_D_FECPRO IN DATE,
                         P_N_NUMIMP IN NUMBER,
                         P_C_CODUSU IN VARCHAR2,     
                         P_N_PGCOD  IN NUMBER, 
                         P_N_SCMOD  IN NUMBER, 
                         P_N_SCSUC  IN NUMBER,  
                         P_N_SCMDA  IN NUMBER,  
                         P_N_SCPAP  IN NUMBER,  
                         P_N_SCCTA  IN NUMBER,  
                         P_N_SCOPER IN NUMBER,  
                         P_N_SCSBOP IN NUMBER,  
                         P_N_SCTOPE IN NUMBER,
                         P_C_NOMARC IN VARCHAR2,
                         P_C_CODEST IN VARCHAR2,
                         P_C_MAICOR IN VARCHAR2,
                         P_C_DESOBS IN VARCHAR2,
                         p_c_coderr out varchar2,
                         p_c_deserr out varchar2                         
                        ) is
                        
  lc_usuario char(10):=null;
  ln_codsuc  number(3):=0;
  l_bfile    BFILE;
  l_blob     BLOB;
  lv_nomrep  varchar2(30);   
  ld_fecsis  date;  
  ln_ctaemp  number(9):=0;             
  Begin     
    p_c_coderr := '000';
    p_c_deserr := '';  
    
    begin 
      select a.pgfape 
        into ld_fecsis 
        from fst017 a 
       where a.pgcod = 1; 
    Exception 
    when others then 
      ld_fecsis := trunc(sysdate); 
    End; 
    
    --obtenemos sucursal del suuario
    lc_usuario := rpad(P_C_CODUSU,10,' ');
    begin
      select x.ubsuc 
        into ln_codsuc 
        from fst046 x 
       where x.pgcod = 1 
         and x.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 0;
    end;    
            
   --obtenemos repositorio
    begin
      select trim(a.tp1desc)
        into lv_nomrep 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio  
    exception
    when others then
      lv_nomrep := '';
    end;     
   --obtenemos cuenta cliente del empleador
    begin
      select a.r1cta
        into ln_ctaemp
        from fsr011 a
       Where a.relcod = 45
         and a.r2mod  = P_N_SCMOD  
         and a.r2cta  = P_N_SCCTA 
         and a.r2oper = P_N_SCOPER
         and a.r2sbop = P_N_SCSBOP 
         and a.r2cod  = P_N_PGCOD 
         and a.r2suc  = P_N_SCSUC 
         and a.r2mda  = P_N_SCMDA 
         and a.r2pap  = P_N_SCPAP  
         and a.r2tope = P_N_SCTOPE
         and a.r011co = 'S';
    exception
    when others then
      lv_nomrep := '';
    end;         
    
    If P_C_CODEST = 'S' then
      begin      
        insert into JAQZ178(jaqz178seq,
                            jaqz178fec,
                            jaqz178hor,
                            jaqz178usr,
                            jaqz178age,
                            jaqz178imp,
                            jaqz178car,
                            jaqz178pgc,
                            jaqz178mod,
                            jaqz178suc,
                            jaqz178mda,
                            jaqz178pap,
                            jaqz178cta,
                            jaqz178ope,
                            jaqz178sbo,
                            jaqz178tpo,
                            jaqz178nom,
                            jaqz178est,
                            jaqz178mot,
                            jaqz178mai,
                            jaqz178ax5,
                            jaqz178ax2
                          )
                   values(SQ_AH_ID_ENVCAR.NEXTVAL,
                          P_D_FECPRO,
                          to_char(sysdate,'HH24:mi:ss'),
                          lc_usuario,
                          ln_codsuc,
                          P_N_NUMIMP,
                          EMPTY_BLOB(),
                          P_N_PGCOD, 
                          P_N_SCMOD,
                          P_N_SCSUC,
                          P_N_SCMDA, 
                          P_N_SCPAP, 
                          P_N_SCCTA, 
                          P_N_SCOPER,
                          P_N_SCSBOP,
                          P_N_SCTOPE,
                          P_C_NOMARC,
                          P_C_CODEST,
                          P_C_DESOBS,
                          P_C_MAICOR,
                          ld_fecsis,
                          ln_ctaemp
                          )  

                          RETURN jaqz178car INTO l_blob;                          
                          --select SQ_AH_ID_ENVCAR.CURRVAL into p_n_numsec from dual;
                              
                          l_bfile := BFILENAME(lv_nomrep, P_C_NOMARC);
                          DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                          DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                          DBMS_LOB.fileclose(l_bfile);
      Exception
      When Others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;                        
      End;                                                                                                          
  Else
    begin  
      insert into JAQZ178(jaqz178seq,
                          jaqz178fec,
                          jaqz178hor,
                          jaqz178usr,
                          jaqz178age,
                          jaqz178imp,
                          jaqz178pgc,
                          jaqz178mod,
                          jaqz178suc,
                          jaqz178mda,
                          jaqz178pap,
                          jaqz178cta,
                          jaqz178ope,
                          jaqz178sbo,
                          jaqz178tpo,
                          jaqz178nom,
                          jaqz178est,
                          jaqz178mot,
                          jaqz178mai,
                          jaqz178ax5,
                          jaqz178ax2
                        )
                 values(SQ_AH_ID_ENVCAR.NEXTVAL,
                        P_D_FECPRO,
                        to_char(sysdate,'HH24:mi:ss'),
                        lc_usuario,
                        ln_codsuc,
                        P_N_NUMIMP,                      
                        P_N_PGCOD, 
                        P_N_SCMOD,
                        P_N_SCSUC,
                        P_N_SCMDA, 
                        P_N_SCPAP, 
                        P_N_SCCTA, 
                        P_N_SCOPER,
                        P_N_SCSBOP,
                        P_N_SCTOPE,
                        P_C_NOMARC,
                        P_C_CODEST,
                        P_C_DESOBS,
                        P_C_MAICOR,
                        ld_fecsis,
                        ln_ctaemp
                        );   
    Exception
    When Others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;                       
    End;                       
                       
  End If; 
  COMMIT;                       
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_ah_regenv;   
  Procedure sp_ah_enviomail(P_D_FECPRO IN DATE,
                            P_C_CODHOR IN VARCHAR2,
                            P_C_TIPENV IN VARCHAR2,
                            P_N_NUMSEQ IN NUMBER,
                            P_C_NOMARC IN VARCHAR2,           
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                           ) is
  cursor c_empresa is
    select x.*
      from jaqz177 x 
     where x.jaqz177seq = P_N_NUMSEQ
       and x.jaqz177est = 'R';
       
  cursor c_importacion is       
    select x.*
      from jaql071 x 
     where x.jaql71nuim = P_N_NUMSEQ
       and x.jaql71esta = 'P';
              
  cursor c_contactos(ln_pais in number, ln_tipo in number, lc_numero in char)        is
   select y.* 
     from jaqz172 y
    where y.jaqz172pai = ln_pais
      and y.jaqz172tpo = ln_tipo
      and y.jaqz172num = lc_numero
      and trim(y.jaqz172mai) is not null
      and pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';      
/*      and case
            when REGEXP_LIKE(trim(y.jaqz172mai),
                             '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                             'i') then
             'S'
            else
             'N'
          end = 'S'; */       
  
  cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 61
       and a.Tp1corr2 = 6; 
       
  cursor c_importacion_det is       
    select x.*
      from jaql072 x
     where x.jaql72nuim = P_N_NUMSEQ
        and x.jaql72impo > 0;
  cursor c_cartas is
    select a.* 
      from jaql456 a 
     where a.jaql456usu = rpad(P_C_TIPENV,10,' ')
       and a.jaql456cta = P_C_NOMARC;    
       
  cursor c_mail is       
    select trim(a.tp1desc) tp1desc
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 72
       and a.Tp1corr2 = 5; 
                  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(30);  
    lv_asunto     VARCHAR2(30);  
    lv_asunto1    VARCHAR2(30);  
    lv_directorio VARCHAR2(30);  
    lv_archivos   VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';    
    ln_cont2      NUMBER(9):=0;     
    lv_estado     VARCHAR2(30);                    
    lv_empresa    VARCHAR2(70);
    lv_motivo     VARCHAR2(400);
    ln_pais       NUMBER(3);
    ln_tipdoc     NUMBER(2);
    lc_numdoc     CHAR(12);
    lv_contacto   VARCHAR2(30);
    lc_Flag       CHAR(1);
    ln_suc        NUMBER(3);
  begin
    p_c_coderr := '000';       
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := trim(i.tp1desc);
         When i.tp1nro1 = 3 then
           lv_directorio := trim(i.tp1desc);
         When i.tp1nro1 = 4 then
           lv_asunto1    := trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
    If P_C_TIPENV = 'C' then  --contactos de la empresa con el error
      For j in c_empresa loop
          lv_motivo := j.jaqz177obs;
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = j.jaqz177pai 
               and a.pjtdoc = j.jaqz177tpo
               and a.pjndoc = j.jaqz177num;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = j.jaqz177pai 
                 and a.petdoc = j.jaqz177tpo
                 and a.pendoc = j.jaqz177num;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
          
          Begin
            select upper(trim(substr(a.tp1desc,3,28)))
              into lv_estado 
              from fst198 a 
             where a.tp1cod   = 1
               and a.tp1cod1  = 10825
               and a.tp1corr1 = 72
               and a.tp1corr2 = 2
               and substr(a.tp1desc,1,1) = j.jaqz177est;
          Exception
          When others then  
            lv_estado := null;
          end;
                                              
          For k in c_contactos(j.jaqz177pai,j.jaqz177tpo,j.jaqz177num) loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.jaqz172mai)||';';   
             lv_contacto := trim(k.jaqz172no1); 
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
              dbms_lob.createtemporary(ll_mensaje, TRUE);     
              if ln_cont2 > 1 then          
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a procesar la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||'.</p>';            
              Else
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a procesar la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||'.</p>';            
              End If;              
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

              lv_mensaje := '
                            <table width="830" height="54" border="0">
                              <tbody>
                                <tr>
                                <td "font-family: Arial, sans-serif; font-size: 14px;" width="15" colspan="2" height="23"><p><strong>Detalles del motivo</strong>:</p></td>      
                                </tr>	  
                                              
                                <tr>
                                  <td width="15" height="23"><strong></strong></td>
                                  <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">'||lv_motivo||'.</td>
                                </tr>
                              </tbody>
                            </table>';               
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                                   
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := '';
                          
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If; 
      End loop;   
    End If;  
    If P_C_TIPENV = 'E' then  --empleador con la planilla
      For j in c_importacion loop
          Begin
            select a.pepais,
                   a.petdoc,
                   a.pendoc
              into ln_pais,
                   ln_tipdoc,
                   lc_numdoc
              from fsr008 a 
             where a.pgcod = 1
               and a.ctnro = j.jaql71ctem
               and a.ttcod = 1
               and a.cttfir = 'T';
          Exception
          when others then
               ln_pais   := 0;   
               ln_tipdoc := 0;
               lc_numdoc := '';
          End;          
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = ln_pais 
               and a.pjtdoc = ln_tipdoc
               and a.pjndoc = lc_numdoc;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = ln_pais
                 and a.petdoc = ln_tipdoc
                 and a.pendoc = lc_numdoc;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
          
          Begin
            select upper(trim(substr(a.tp1desc,3,28)))
              into lv_estado 
              from fst198 a 
             where a.tp1cod   = 1
               and a.tp1cod1  = 10825
               and a.tp1corr1 = 72
               and a.tp1corr2 = 2
               and substr(a.tp1desc,1,1) = j.jaql71esta;
          Exception
          When others then  
            lv_estado := null;
          end;
                                              
          For k in c_contactos(ln_pais,ln_tipdoc,lc_numdoc) loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.jaqz172mai)||';';   
             lv_contacto := trim(k.jaqz172no1);      
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
              dbms_lob.createtemporary(ll_mensaje, TRUE);     
              if ln_cont2 > 1 then          
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a realizar el abono de la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||' satisfactoriamente'||'.</p>'||              
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta reporte con el detalle en formato PDF'||'.</p>';           
              Else
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a realizar el abono de la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||' satisfactoriamente'||'.</p>'||             
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta reporte con el detalle en formato PDF'||'.</p>';           
              End If;              
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := P_C_NOMARC;
                          
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If; 
      End loop;         
    End If;
    If P_C_TIPENV = 'P' then  --Procesos Centrales
          Begin
            select a.pepais,
                   a.petdoc,
                   a.pendoc
              into ln_pais,
                   ln_tipdoc,
                   lc_numdoc
              from fsr008 a 
             where a.pgcod = 1
               and a.ctnro = P_N_NUMSEQ
               and a.ttcod = 1
               and a.cttfir = 'T';
          Exception
          when others then
               ln_pais   := 0;   
               ln_tipdoc := 0;
               lc_numdoc := '';
          End;          
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = ln_pais 
               and a.pjtdoc = ln_tipdoc
               and a.pjndoc = lc_numdoc;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = ln_pais
                 and a.petdoc = ln_tipdoc
                 and a.pendoc = lc_numdoc;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
                                                        
          For k in c_mail loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.tp1desc)||';';   
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
                dbms_lob.createtemporary(ll_mensaje, TRUE);     
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Bantotal le informa: </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se ha ingresado una planilla nueva de CTS de la empresa:</p>';                              
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                lv_mensaje := '
                              <table width="1200" height="50" border="0">
                                <tbody>
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Raz&oacute;n Social:</strong>'||lv_empresa||'</td>      
                                  </tr>	
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Documento:</strong>'||lc_numdoc||'</td>      
                                  </tr>	     
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Agencia-Usuario:</strong>'||P_C_NOMARC||'</td>      
                                  </tr>	                                                                                                                                                                                                                         
                                </tbody>
                              </table>
                              ';               
            
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := '';
                          
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If;      
    End If;    
    If P_C_TIPENV  not in ('C','E','P') then --trabajador adjuntando la carta cts digital
      if trim(P_C_NOMARC) is null then
          For j in c_importacion_det loop
              Begin
                select a.pepais,
                       a.petdoc,
                       a.pendoc
                  into ln_pais,
                       ln_tipdoc,
                       lc_numdoc
                  from fsr008 a 
                 where a.pgcod = 1
                   and a.ctnro = j.jaql72scct
                   and a.ttcod = 1
                   and a.cttfir = 'T';
              Exception
              when others then
                   ln_pais   := 0;   
                   ln_tipdoc := 0;
                   lc_numdoc := '';
              End;    
              
              Begin
                select trim(b.pfnom1)
                  into lv_contacto
                  from fsd002 b 
                 where b.pfpais = ln_pais
                   and b.pftdoc = ln_tipdoc               
                   and b.pfndoc = lc_numdoc;
              Exception
              when others then
                   lv_contacto := '';   
              End;     
              
              --PROYECTO CTS SEGUNDA PARTE
/*              Begin
                select 1
                  into ln_cont2
                  from jaqz173 c 
                 where c.jaqz173pai = ln_pais
                   and c.jaqz173tpo = ln_tipdoc
                   and c.jaqz173num = lc_numdoc
                   and c.jaqz173ser = 1
                   and c.jaqz173med = 1
                   and c.jaqz173est = 'A';
              Exception
              when others then
                   ln_cont2 := 0;
              End;*/  
              
               ln_cont2 := 1;              
              --solo obtener correo si esta afiliado               
              if ln_cont2 = 1 then
                Begin
                  select substr(c.pextxt,1,instr(c.pextxt,'\')-1)
                    into lv_destinos
                    from fsx001 c 
                   where c.pepais = ln_pais
                     and c.petdoc = ln_tipdoc
                     and c.pendoc = lc_numdoc
                     and c.txcod  = 0
                     and c.pexren = 99 --correspondencia
                     and trim(c.pextxt) is not null
                     and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1))) = 'S';                     
/*                     and case
                           when REGEXP_LIKE(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1)),
                                            '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                            'i') then
                            'S'
                           else
                            'N'
                         end = 'S';  */                   
                Exception
               /* when no_data_found then
                  Begin
                    select trim(c.jaqz173mai)
                      into lv_destinos
                      from jaqz173 c 
                     where c.jaqz173pai = ln_pais
                       and c.jaqz173tpo = ln_tipdoc
                       and c.jaqz173num = lc_numdoc
                       and c.jaqz173ser = 1
                       and c.jaqz173med = 1
                       and c.jaqz173est = 'A'
                       and trim(c.jaqz173mai) is not null
                       and pq_ah_enviodigital.fn_ah_valida_mail(trim(c.jaqz173mai)) = 'S';                       
\*                       and case
                             when REGEXP_LIKE(trim(c.jaqz173mai),
                                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                              'i') then
                              'S'
                             else
                              'N'
                           end = 'S'; *\                       
                  Exception
                  when others then
                       lv_destinos := '';   
                       ln_cont2 := 0;
                  End; */
                when others then                
                     lv_destinos := '';   
                     ln_cont2 := 0;                
                End;
              end if;                                
              --FIN
              
              Begin
                 select 'S' 
                   into lc_Flag
                   from jaqz178   
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178imp = j.jaql72nuim
                    and jaqz178pgc = j.jaql72pgco 
                    and jaqz178mod = j.jaql72scmo
                    and jaqz178suc = j.jaql72scsu
                    and jaqz178mda = j.jaql72scmd
                    and jaqz178pap = j.jaql72scpa
                    and jaqz178cta = j.jaql72scct
                    and jaqz178ope = j.jaql72scop
                    and jaqz178sbo = j.jaql72scsb
                    and jaqz178tpo = j.jaql72scto
                    and jaqz178est = 'S';    
              Exception
              when others then
                   lc_flag := 'N';
              End;                                                                              
             
              If ln_cont2 > 0 and lc_flag = 'N' then        
                  dbms_lob.createtemporary(ll_mensaje, TRUE);     
                  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta su carta CTS con el &uacute;ltimo abono realizado por su empleador'||'.</p>';           

                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
                  lv_mensaje := 
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

                  lv_archivos := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(ln_tipdoc,2,'0')||lpad(trim(lc_numdoc),12,'0')||'.pdf';  
                  
                  begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                   p_destinatarioscc   => '',
                                                   p_destinatariosbcc  => '',
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_remitente,
                                                   p_asunto            => lv_asunto1,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => lv_directorio,
                                                   p_archivosadjuntos  => lv_archivos,
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_deserr
                                                   );
                  exception
                  when others then  
                       p_c_coderr := '00x';
                       p_c_deserr := sqlerrm;                                                   
                  end;
                  dbms_lob.freetemporary(ll_mensaje);    
                  --registramos el envío o error en el log
                  if p_c_coderr = '000' then
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => j.jaql72pgco,
                                                   p_n_scmod  => j.jaql72scmo,
                                                   p_n_scsuc  => j.jaql72scsu,
                                                   p_n_scmda  => j.jaql72scmd,
                                                   p_n_scpap  => j.jaql72scpa,
                                                   p_n_sccta  => j.jaql72scct,
                                                   p_n_scoper => j.jaql72scop,
                                                   p_n_scsbop => j.jaql72scsb,
                                                   p_n_sctope => j.jaql72scto,
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'S',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => null,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                
                  Else
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => j.jaql72pgco,
                                                   p_n_scmod  => j.jaql72scmo,
                                                   p_n_scsuc  => j.jaql72scsu,
                                                   p_n_scmda  => j.jaql72scmd,
                                                   p_n_scpap  => j.jaql72scpa,
                                                   p_n_sccta  => j.jaql72scct,
                                                   p_n_scoper => j.jaql72scop,
                                                   p_n_scsbop => j.jaql72scsb,
                                                   p_n_sctope => j.jaql72scto,
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'E',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => p_c_deserr,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                 
                  End If;                                       
              End If; 
              IF lc_flag = 'S' then
                 update jaqz178 
                    set jaqz178ax1 = 1
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178imp = j.jaql72nuim
                    and jaqz178pgc = j.jaql72pgco 
                    and jaqz178mod = j.jaql72scmo
                    and jaqz178suc = j.jaql72scsu
                    and jaqz178mda = j.jaql72scmd
                    and jaqz178pap = j.jaql72scpa
                    and jaqz178cta = j.jaql72scct
                    and jaqz178ope = j.jaql72scop
                    and jaqz178sbo = j.jaql72scsb
                    and jaqz178tpo = j.jaql72scto
                    and jaqz178est = 'S';    
              End If;  
          End loop;         
      Else
          For j in c_cartas loop
              Begin
                select a.pepais,
                       a.petdoc,
                       a.pendoc
                  into ln_pais,
                       ln_tipdoc,
                       lc_numdoc
                  from fsr008 a 
                 where a.pgcod = 1
                   and a.ctnro = to_number(substr(j.jaql456cta,1,9))
                   and a.ttcod = 1
                   and a.cttfir = 'T';
              Exception
              when others then
                   ln_pais   := 0;   
                   ln_tipdoc := 0;
                   lc_numdoc := '';
              End;    
              
              Begin
                select trim(b.pfnom1)
                  into lv_contacto
                  from fsd002 b 
                 where b.pfpais = ln_pais
                   and b.pftdoc = ln_tipdoc               
                   and b.pfndoc = lc_numdoc;
              Exception
              when others then
                   lv_contacto := '';   
              End;     

              --PROYECTO CTS SEGUNDA PARTE
/*              Begin
                select 1
                  into ln_cont2
                  from jaqz173 c 
                 where c.jaqz173pai = ln_pais
                   and c.jaqz173tpo = ln_tipdoc
                   and c.jaqz173num = lc_numdoc
                   and c.jaqz173ser = 1
                   and c.jaqz173med = 1
                   and c.jaqz173est = 'A';
              Exception
              when others then
                   ln_cont2 := 0;
              End;*/ 
              ln_cont2 := 1;               
              --solo obtener correo si esta afiliado               
              if ln_cont2 = 1 then                              
                Begin
                  select substr(c.pextxt,1,instr(c.pextxt,'\')-1)
                    into lv_destinos
                    from fsx001 c 
                   where c.pepais = ln_pais
                     and c.petdoc = ln_tipdoc
                     and c.pendoc = lc_numdoc
                     and c.txcod  = 0
                     and c.pexren = 99 --correspondencia
                     and trim(c.pextxt) is not null
                     and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1))) = 'S';                     
/*                     and case
                           when REGEXP_LIKE(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1)),
                                            '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                            'i') then
                            'S'
                           else
                            'N'
                         end = 'S';  */                    
                Exception
/*                when no_data_found then
                  Begin
                    select trim(c.jaqz173mai)
                      into lv_destinos
                      from jaqz173 c 
                     where c.jaqz173pai = ln_pais
                       and c.jaqz173tpo = ln_tipdoc
                       and c.jaqz173num = lc_numdoc
                       and c.jaqz173ser = 1
                       and c.jaqz173med = 1
                       and c.jaqz173est = 'A'
                       and trim(c.jaqz173mai) is not null
                       and pq_ah_enviodigital.fn_ah_valida_mail(trim(c.jaqz173mai)) = 'S';                     
\*                       and case
                             when REGEXP_LIKE(trim(c.jaqz173mai),
                                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                              'i') then
                              'S'
                             else
                              'N'
                           end = 'S'; *\                       
                  Exception
                  when others then
                       lv_destinos := '';   
                       ln_cont2 := 0;
                  End; */                   
                when others then
                     lv_destinos := '';   
                     ln_cont2 := 0;
                End; 
              End if;              
              --FIN
              
              Begin
                 select 'S',x.scsuc
                   into lc_Flag,ln_suc
                   from fsd011 x
                  Where x.pgcod  = 1
                    and x.scmod  = 21
                    and x.scmda  = to_number(substr(j.jaql456cta,13,3))
                    and x.scpap  = 0
                    and x.sccta  = to_number(substr(j.jaql456cta,1,9))
                    and x.scoper = 0
                    and x.scsbop = to_number(substr(j.jaql456cta,16,2))
                    and x.sctope = to_number(substr(j.jaql456cta,18,3));
              Exception
              when others then
                   lc_flag := 'N';
                   ln_suc  := 0;
              End;                   
                                 
              Begin
                 select 'S' 
                   into lc_Flag
                   from jaqz178   
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178pgc = 1
                    and jaqz178mod = 21
                    and jaqz178suc = ln_suc
                    and jaqz178mda = to_number(substr(j.jaql456cta,13,3))
                    and jaqz178pap = 0
                    and jaqz178cta = to_number(substr(j.jaql456cta,1,9))
                    and jaqz178ope = 0
                    and jaqz178sbo = to_number(substr(j.jaql456cta,16,2))
                    and jaqz178tpo = to_number(substr(j.jaql456cta,18,3))
                    and jaqz178est = 'S';    
              Exception
              when others then
                   lc_flag := 'N';
              End;                                                                              
             
              If ln_cont2 > 0 and lc_flag = 'N' then        
                  dbms_lob.createtemporary(ll_mensaje, TRUE);     
                  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta su carta CTS con el &uacute;ltimo abono realizado por su empleador'||'.</p>';           

                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
                  lv_mensaje := 
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

                  lv_archivos := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(ln_tipdoc,2,'0')||lpad(trim(lc_numdoc),12,'0')||'.pdf';  
                  
                  begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                   p_destinatarioscc   => '',
                                                   p_destinatariosbcc  => '',
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_remitente,
                                                   p_asunto            => lv_asunto1,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => lv_directorio,
                                                   p_archivosadjuntos  => lv_archivos,
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_deserr
                                                   );
                  exception
                  when others then  
                       p_c_coderr := '00x';
                       p_c_deserr := sqlerrm;                                                   
                  end;
                  dbms_lob.freetemporary(ll_mensaje);    
                  --registramos el envío o error en el log
                  if p_c_coderr = '000' then
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => 1,
                                                   p_n_scmod  => 21,
                                                   p_n_scsuc  => ln_suc,
                                                   p_n_scmda  => to_number(substr(j.jaql456cta,13,3)),
                                                   p_n_scpap  => 0,
                                                   p_n_sccta  => to_number(substr(j.jaql456cta,1,9)),
                                                   p_n_scoper => 0,
                                                   p_n_scsbop => to_number(substr(j.jaql456cta,16,2)),
                                                   p_n_sctope => to_number(substr(j.jaql456cta,18,3)),
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'S',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => null,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                
                  Else
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => 1,
                                                   p_n_scmod  => 21,
                                                   p_n_scsuc  => ln_suc,
                                                   p_n_scmda  => to_number(substr(j.jaql456cta,13,3)),
                                                   p_n_scpap  => 0,
                                                   p_n_sccta  => to_number(substr(j.jaql456cta,1,9)),
                                                   p_n_scoper => 0,
                                                   p_n_scsbop => to_number(substr(j.jaql456cta,16,2)),
                                                   p_n_sctope => to_number(substr(j.jaql456cta,18,3)),
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'E',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => p_c_deserr,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                 
                  End If;                                       
              End If; 
              IF lc_flag = 'S' then
                 update jaqz178 
                    set jaqz178ax1 = 1
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178pgc = 1
                    and jaqz178mod = 21
                    and jaqz178suc = ln_suc
                    and jaqz178mda = to_number(substr(j.jaql456cta,13,3))
                    and jaqz178pap = 0
                    and jaqz178cta = to_number(substr(j.jaql456cta,1,9))
                    and jaqz178ope = 0
                    and jaqz178sbo = to_number(substr(j.jaql456cta,16,2))
                    and jaqz178tpo = to_number(substr(j.jaql456cta,18,3))
                    and jaqz178est = 'S';    
              End If;              
          End loop;    
      
      End if;              
    End If;
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;                                 
  end sp_ah_enviomail;                                                         
  procedure sp_genera_cartas_cts(P_D_FECPRO IN DATE,
                                 P_C_CODUSU IN VARCHAR2,    
                                 P_N_PGCOD  IN NUMBER, 
                                 P_N_SCMOD  IN NUMBER, 
                                 P_N_SCSUC  IN NUMBER,  
                                 P_N_SCMDA  IN NUMBER,  
                                 P_N_SCPAP  IN NUMBER,  
                                 P_N_SCCTA  IN NUMBER,  
                                 P_N_SCOPER IN NUMBER,  
                                 P_N_SCSBOP IN NUMBER,  
                                 P_N_SCTOPE IN NUMBER,
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2                                     
                                 ) is
                                           
  ln_tasa        number(10,6);  
  lc_nomemp      char(70);
  ln_paisE       number(5);
  ln_tipoE       number(5);
  lc_numdocE     char(12);
  lc_nomclt      char(170);
  ln_paisC       number(5);
  ln_tipoC       number(5);
  lc_numdocC     char(12);
  lc_desdirC     char(140);
  ln_dptoC       number(8);
  ln_provC       number(8); 
  ln_distC       number(8);
  lc_distriC     char(30);
  lc_departC     char(30);
  lc_cuenta      char(20);
  lc_Siglas      char(4);
  lc_Siglad      char(4);
  ln_saldo       number(18,2) :=0;
  ln_cont        number := 0;
  lc_provC       char(30);
  ln_r1cta       number(9):=0;
  --ld_fecsis      date;
begin
  p_c_coderr := '000';
  
  delete from jaql456 where jaql456usu = rpad(P_C_CODUSU,10,' ');
  COMMIT;
  
  begin
    select upper(mosign) into lc_Siglas from fst005 where moneda = 0;
    select upper(mosign) into lc_Siglad from fst005 where moneda = 101;
    --select a.pgfape into ld_fecsis from fst017 a where a.pgcod = 1; 
  end;
  
  /*if P_D_FECPRO <> ld_fecsis then
      begin
                  
        select a.bcsdmo, 
               a.bctasa 
          into ln_saldo,
               ln_tasa
          from fsh012 a 
         where a.bcemp  = P_N_PGCOD
           and a.bcsuc  = P_N_SCSUC
           and a.bcmda  = P_N_SCMDA
           and a.bcpap  = P_N_SCPAP
           and a.bccta  = P_N_SCCTA
           and a.bcoper = P_N_SCOPER
           and a.bcsbop = P_N_SCSBOP
           and a.bctop  = P_N_SCTOPE
           and a.bcfech = P_D_FECPRO;
          
      Exception
      When others then
          ln_tasa := 0;
          ln_saldo := 0;
          p_c_coderr := sqlcode; 
          p_c_deserr := 'No se encontró tasa ni saldo para el producto';    
          return;
      End;    
  Else  */
   
      begin
                  
        pq_segmentacion_clientes_pas.sp_tasa(vpgcod  => P_N_PGCOD,
                                             vscsuc  => P_N_SCSUC,
                                             vsccta  => P_N_SCCTA,
                                             vscmda  => P_N_SCMDA,
                                             vscpap  => P_N_SCPAP,
                                             vscoper => P_N_SCOPER,
                                             vscsbop => P_N_SCSBOP,
                                             vsctope => P_N_SCTOPE,
                                             vscmod  => P_N_SCMOD,
                                             tasa    => ln_tasa
                                             );
      Exception
      When others then
          ln_tasa := 0;
          p_c_coderr := sqlcode; 
          p_c_deserr := 'No se encontró tasa para el producto';    
          return;
      End;
  --End If;

  lc_cuenta := lpad(P_N_SCCTA,9,'0')||lpad(P_N_SCMOD,3,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCSBOP,2,'0')||lpad(P_N_SCTOPE,3,'0');
  --obtenemos la cuenta cliente del empleador
  Begin            
    select x.r1cta 
      into ln_r1cta
      from fsr011 x
     where x.r2mod  = P_N_SCMOD
       and x.r2cta  = P_N_SCCTA
       and x.r2oper = P_N_SCOPER
       and x.r2sbop = P_N_SCSBOP
       and x.r2cod  = P_N_PGCOD
       and x.r2suc  = P_N_SCSUC
       and x.r2mda  = P_N_SCMDA
       and x.r2pap  = P_N_SCPAP
       and x.r2tope = P_N_SCTOPE
       and x.relcod = 45
       and x.r011co = 'S';
  Exception
  When others then
      ln_r1cta := 0;
      p_c_coderr := sqlcode; 
      p_c_deserr := 'No se encontró cuenta cliente del empleador';      
      return;
  End;           

  Begin
   select y.pepais,
          y.petdoc,
          y.pendoc 
     into ln_paisE,
          ln_tipoE,
          lc_numdocE
     from fsr008 y
    where y.ctnro = ln_r1cta
      and y.ttcod = 1
      and y.cttfir = 'T'; 
  Exception
   when others then
      p_c_coderr := sqlcode; 
      p_c_deserr := 'No se encontró datos de la cuenta cliente del empleador';
      return;
  End;
             
  Begin
    select trim(PJRAZS)
      into lc_nomemp
      from fsd003
     where pjpais = ln_paisE
       and pjtdoc = ln_tipoE
       and pjndoc = lc_numdocE;
  Exception
  When no_data_found then            
      Begin
        select trim(PFAPE1) || ' ' || trim(PFAPE2) || ', ' || trim(pfnom1) || ' ' ||trim(pfnom2)
          into lc_nomemp
          from fsd002
         where pfpais = ln_paisE
           and pftdoc = ln_tipoE
           and pfndoc = lc_numdocE;
      Exception
      When others then
          lc_nomemp := '';
          p_c_coderr := sqlcode; 
          p_c_deserr := 'No se encontró nombre del empleador'; 
          return;        
      End;                           
  When others then
   lc_nomemp := '';
   p_c_coderr := sqlcode; 
   p_c_deserr := 'No se encontró nombre del empleador';     
   return;    
  End;
             
  Begin
   select y.pepais,
          y.petdoc,
          y.pendoc 
     into ln_paisC,
          ln_tipoC,
          lc_numdocC
     from fsr008 y
    where y.ttcod  = 1
      and y.cttfir = 'T'                 
      and y.ctnro  = P_N_SCCTA;
  Exception
  When others then
     p_c_coderr := sqlcode; 
     p_c_deserr := 'No se encontró nombre del empleador';        
     return; 
  End;
             
  Begin
    select trim(PFAPE1) || ' ' || trim(PFAPE2) || ', ' || trim(pfnom1) || ' ' ||trim(pfnom2)
      into lc_nomclt
      from fsd002
     where pfpais = ln_paisC
       and pftdoc = ln_tipoC
       and pfndoc = lc_numdocC;
  Exception
  When others then
     p_c_coderr := sqlcode; 
     p_c_deserr := 'No se encontró nombre del cliente';            
     return;
  End;
                                          
  Begin
   -- direccion 
   select Trim(Sngc13Dir), Sngc13Dpto, Sngc13Prov, Sngc13Dist
     into lc_desdirC, ln_dptoC, ln_provC, ln_distC
     from sngc13
    where docod = 2
      and sngc13pais = ln_paisC
      and sngc13tdoc = ln_tipoC
      and sngc13ndoc = lc_numdocC
      and sngc13est  = 'H';
  Exception
  When no_data_found then
     Begin
       -- direccion 
       select Trim(Sngc13Dir), Sngc13Dpto, Sngc13Prov, Sngc13Dist
         into lc_desdirC, ln_dptoC, ln_provC, ln_distC
         from sngc13
        where docod = 1
          and sngc13pais = ln_paisC
          and sngc13tdoc = ln_tipoC
          and sngc13ndoc = lc_numdocC
          and sngc13est  = 'H';
      Exception
      When others then
        lc_desdirC := ''; 
        ln_dptoC   := 0; 
        ln_provC   := 0; 
        ln_distC   := 0;
        p_c_coderr := sqlcode; 
        p_c_deserr := 'No se encontró dirección del cliente';            
        return;    
      End;    
  When others then
    lc_desdirC := ''; 
    ln_dptoC   := 0; 
    ln_provC   := 0; 
    ln_distC   := 0;
    p_c_coderr := sqlcode; 
    p_c_deserr := 'No se encontró dirección del cliente';            
    return;    
  End;
                   
  Begin
   select DepNom
     into lc_departC
     from FST068 --DEPARTAMENTO
    Where Pais = ln_paisC
      and DepCod = ln_dptoC;
  Exception
  When others then
     lc_departC := '';
     p_c_coderr := sqlcode; 
     p_c_deserr := 'No se encontró departamento del cliente';            
     return;     
  End;
                   
  Begin                   
   select LocNom
     into lc_provC
     from FST070 --PROVINCIA
    Where Pais = ln_paisC
      and DepCod = ln_dptoC
      and LocCod = ln_provC;
  Exception
  When others then
     lc_provC := '';
     p_c_coderr := sqlcode; 
     p_c_deserr := 'No se encontró provincia del cliente';            
     return;     
  End;
                   
  Begin
   select fst071dsc
     into lc_distriC
     from FST071 --DISTRITO
    Where Fst071Pai = ln_paisC
      and Fst071Col = ln_distC;
  Exception
  When others then
     lc_distriC := '';
     p_c_coderr := sqlcode; 
     p_c_deserr := 'No se encontró distrito del cliente';            
     return;     
  End;
           
  --SACAMOS EL SALDO DE LA CUENTA
  --if P_D_FECPRO = ld_fecsis then  
    Begin
     select scsdo
       into ln_saldo
       from fsd011
      where pgcod  = P_N_PGCOD 
        and scmod  = P_N_SCMOD 
        and scsuc  = P_N_SCSUC 
        and scmda  = P_N_SCMDA 
        and sccta  = P_N_SCCTA 
        and scpap  = P_N_SCPAP 
        and scoper = P_N_SCOPER
        and scsbop = P_N_SCSBOP
        and sctope = P_N_SCTOPE;
    Exception
     when others then
       ln_saldo := 0;
       p_c_coderr := sqlcode; 
       p_c_deserr := 'No se encontró registro de saldo del cliente';            
       return;     
    End; 
  --End If;      
                     
  -- REGISTRAMOS LA INFORMACIÓN
  BEGIN
     ln_cont := ln_cont + 1;             
     insert into JAQL456(JAQL456COR, 
                         JAQL456USU, 
                         JAQL456NEM, --70
                         JAQL456DIE, 
                         JAQL456CTA, 
                         JAQL456FDE, 
                         JAQL456SMN, 
                         JAQL456SDO, 
                         JAQL456DIC, 
                         JAQL456DDE, 
                         JAQL456DEE, 
                         JAQL456DDC, 
                         JAQL456DEC, 
                         JAQL456TAS,
                         JAQL456NEC,--170
                         JAQL456PRE,
                         JAQL456PRC,
                         JAQL456TEE,
                         JAQL456TEC,
                         JAQL456AX1,
                         JAQL456AX2,
                         JAQL456AX3
                         )
                  values(ln_cont,
                         P_C_CODUSU,
                         lc_nomemp,
                         null,
                         lc_cuenta,
                         P_D_FECPRO,
                         decode(P_N_SCMDA,0,lc_Siglas,lc_Siglad),
                         ln_saldo,
                         lc_desdirC,
                         null,
                         null,
                         lc_distriC,
                         lc_departC,
                         ln_tasa,
                         lc_nomclt,
                         null,
                         lc_provC,
                         null,
                         null,
                         P_N_SCCTA,
                         ln_r1cta,
                         P_N_SCMDA                                                  
                         );
                  commit;
             
  EXCEPTION
  WHEN OTHERS THEN
     p_c_coderr := sqlcode; 
     p_c_deserr := 'Error en el registro de datos de la carta CTS';            
     return;
  END;    
  EXCEPTION
  WHEN OTHERS THEN
     p_c_coderr := sqlcode; 
     p_c_deserr := sqlerrm;            
     return;
  end sp_genera_cartas_cts;  
  Procedure sp_ah_valida_mail_emp(P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER,  
                                  P_C_NUMDOC IN VARCHAR2,
                                  p_c_indmai out varchar2
                                 ) is  
  ln_cuentas number(9):= 0;                                 
  begin
     select count(1)
       into ln_cuentas
       from jaqz172 y
      where y.jaqz172pai = P_N_CODPAI
        and y.jaqz172tpo = P_N_TIPDOC
        and y.jaqz172num = rpad(P_C_NUMDOC, 12, ' ')
        and trim(y.jaqz172mai) is not null
        and pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';        
/*        and case
              when REGEXP_LIKE(trim(y.jaqz172mai),
                               '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                               'i') then
               'S'
              else
               'N'
            end = 'S';*/
    if ln_cuentas = 0 then
      begin
        select count(1)
          into ln_cuentas
          from (
                  select z.*
                    from fsx001 z 
                   where z.pepais = P_N_CODPAI
                     and z.petdoc = P_N_TIPDOC
                     and z.pendoc = rpad(P_C_NUMDOC, 12, ' ')
                     and z.txcod  = 0 
                order by z.pexren desc
               )qq   
          where rownum = 1
            and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(qq.pextxt,1,instr(qq.pextxt,'\')-1))) = 'S';          
           /* and case
                  when REGEXP_LIKE(trim(substr(qq.pextxt,1,instr(qq.pextxt,'\')-1)),
                                   '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                   'i') then
                   'S'
                  else
                   'N'
                end = 'S';    */
         if ln_cuentas > 0 then
           p_c_indmai := 'S';     
         Else
           p_c_indmai := 'N';     
         End if;             
      exception
      when others then
        p_c_indmai := 'N';                
      end;
    ELse
       p_c_indmai := 'S';           
    End If;            
  Exception     
  When others then
    p_c_indmai := 'N';     
  end sp_ah_valida_mail_emp;
  Procedure sp_ah_cta_emp_cts(P_N_CODPAI IN NUMBER,
                              P_N_TIPDOC IN NUMBER,  
                              P_C_NUMDOC IN VARCHAR2,
                              P_N_TIPPRO IN NUMBER,                              
                              p_c_numcta out number,
                              p_c_coderr out varchar2,
                              p_c_deserr out varchar2                             
                             ) is  
/* ************************************************************************************************************
    -- Nombre                     : sp_ah_cta_emp_cts
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Cuenta cliente del empleador de CTS
    -- Descripción                : Retorna la cuenta cliente del empleador en base a un documento
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/05/2019
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Versión                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/                             
  cursor c_cuentas(lc_pendoc in char) is  
  select distinct b.ctnro
    from fsr008 b
   where b.pepais = P_N_CODPAI
     and b.petdoc = P_N_TIPDOC
     and b.pendoc = lc_pendoc
     and b.pgcod = 1
     and b.ttcod = 1
     and b.cttfir = 'T'
     and not exists (Select 1
            from fst056 x
           where x.pgcod = b.pgcod
             and x.ctnro = b.ctnro
             and trim(x.ubuser) is null
             )--excluimos las cuentas inhabilitadas
   order by b.pepais, b.petdoc, b.pendoc; 
           
  lc_pendoc  char(12);     
  ln_cont    number(9):=0;
  ln_numcta  number(9):=0;                                        
  begin
    p_c_coderr := '000';
    p_c_deserr := '';       
    lc_pendoc  := rpad(P_C_NUMDOC,12,' ');                
    ln_cont := 0;   
    for i in c_cuentas(lc_pendoc) loop --validamos cuantas cts cliente tienne como titular principal
        ln_cont   := ln_cont + 1;
        ln_numcta := i.ctnro;   
    End Loop;
           
    if ln_cont > 1 then        --si tienne mas de 1 buscamos la q este asociada a cts cts
       begin
            select distinct 
                   b.ctnro
              into ln_numcta
              from fsr011 a,
                   fsr008 b
             where a.r1cod  = b.pgcod
               and a.r1cta  = b.ctnro
               and b.pepais = P_N_CODPAI
               and b.petdoc = P_N_TIPDOC
               and b.pendoc = lc_pendoc
               and b.pgcod  = 1
               and b.ttcod  = 1
               and b.cttfir = 'T'
               and a.relcod = 45
               and a.r2tope = P_N_TIPPRO
               and a.r011co = 'S';           
       exception
       when no_data_found then   --si no hay asociadas, obtenemos la que tenga integración única
             begin
                Select x.ctnro
                  into ln_numcta
                  from fsr008 x
                 where x.pgcod = 1
                   and x.ctnro in (select distinct b.ctnro
                                     from fsr008 b
                                    where b.pepais = P_N_CODPAI
                                      and b.petdoc = P_N_TIPDOC
                                      and b.pendoc = lc_pendoc
                                      and b.pgcod = 1
                                      and b.ttcod = 1
                                      and b.cttfir = 'T'
                                  )
                 group by x.ctnro
                having count(1) = 1;         
             exception
             when too_many_rows then  
                p_c_coderr := '001';
                p_c_deserr := 'Error: Cliente presenta mas de una cuenta cliente con única integración';           
                return;                
             when others then
                p_c_coderr := '00z';
                p_c_deserr := sqlerrm;
                return; 
             end;         
       when too_many_rows then
          p_c_coderr := '00x';
          p_c_deserr := 'Error: Cliente presenta mas de una cuenta cliente, asociada a cuentas CTS/REM';           
          return;                        
       when others then
          p_c_coderr := '00x';
          p_c_deserr := sqlerrm;
          return; 
       end;
    End If;      
    p_c_numcta := ln_numcta;
    if ln_numcta = 0 then
       p_c_coderr := '00y';
       p_c_deserr := 'Error: Cliente no presenta una cuenta cliente';           
       return;       
    End If;    
  exception
  when others then      
       p_c_coderr := '00w';
       p_c_deserr := sqlerrm;
  end sp_ah_cta_emp_cts;                            
Procedure sp_ah_planillas1(P_N_NUMSEQ IN NUMBER,
                            P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,
                            P_D_FECPRO IN OUT DATE,
                            P_C_CODHOR IN OUT VARCHAR2,
                            P_C_CODUSU IN OUT VARCHAR2,                                       
                            P_C_TIPACC IN OUT VARCHAR2,
                            P_C_TIPFOR IN VARCHAR2,
                            P_C_CODEXT IN VARCHAR2,
                            P_C_TIPABO IN OUT VARCHAR2,
                            P_N_CODBAN IN OUT NUMBER,
                            P_N_NUMCOD IN OUT NUMBER,
                            P_C_CODCTA IN OUT VARCHAR2,
                            P_C_DESOBS IN OUT VARCHAR2,
                            P_C_CODMES IN OUT VARCHAR2,
                            P_N_NUMANO IN OUT NUMBER,
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2
                           ) is   
/* ************************************************************************************************************
    -- Nombre                     : sp_ah_planillas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Módulo de carga planillas CTS 
    -- Descripción                : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Versión                    : 2.0
    -- Fecha de Modificación      : 15/05/2019
    -- Autor de la Modificación   : YLOZADA
    -- Descripción de Modificación: Se adicionó validación cuando empleador presente mas de una cuenta cliente
    --
* *************************************************************************************************************/
                           
  ln_codsuc  number(3);    
  lc_usuario char(10);   
  --lc_pendoc  char(12);     
  ln_numcta  number(9):=0;    
  lv_nomarc  varchar2(30);
  lv_nomrep  varchar2(30);
  lv_nomrep1 varchar2(30);  
  lv_deserr  varchar2(255);      
  lv_tipo    varchar2(1); 
  --ln_cont    number(9):=0;
  --lv_cadena  varchar2(400);
  --lv_aguja   varchar2(400);
  --ln_pos     number(9):=0;  
  lc_desusu varchar2(30):='';
  lc_desage varchar2(30):='';
 
/*  cursor c_cuentas(lc_pendoc in char) is  
    select distinct b.ctnro
      from fsr008 b 
     where b.pepais = P_N_CODPAI 
       and b.petdoc = P_N_TIPDOC
       and b.pendoc = lc_pendoc                                                           
       and b.pgcod  = 1
       and b.ttcod  = 1
       and b.cttfir = 'T'    
  order by b.pepais,
           b.petdoc,
           b.pendoc;  */
                      
/* cursor c_cuentasa(p_n_numcta in number) is  
    select lpad(b.pepais, 3, '0') ||
           lpad(b.petdoc, 2, '0') ||
           lpad(trim(b.pendoc), 12, '0') cadena
      from fsr008 b
     where b.pgcod = 1
       and b.ctnro = p_n_numcta
     order by b.pepais, b.petdoc, b.pendoc;     */
                 
  begin
    p_c_coderr := '000';
    p_c_deserr := '';    
    -- Datos basicos
    lc_usuario := rpad(P_C_CODUSU,10,' ');   
    --lc_pendoc  := rpad(P_C_NUMDOC,12,' ');            

    begin
      select x.ubsuc 
        into ln_codsuc 
        from fst046 x 
       where x.pgcod  = 1 
         and x.ubuser = lc_usuario;
    exception
    when others then
      ln_codsuc := 0;
    end; 
    --cuenta cliente de la persona juridica
    --ln_cont := 0;
    --ln_pos  := 0;
    --lv_cadena := null;
/*    for i in c_cuentas loop
        ln_cont := ln_cont + 1;
        lv_aguja := null;
        for j in c_cuentasa(i.ctnro) loop        
           lv_aguja := lv_aguja || j.cadena;    
        End loop;
        if ln_cont > 1 then 
           ln_pos := instr(lv_cadena,lv_aguja);   
        End if;
        lv_cadena := lv_cadena||'*'||lv_aguja;
        
        if ln_pos > 0 then        
              p_c_coderr := '001';
              p_c_deserr := 'Error: Cliente presenta mas de una cuenta cliente';   
              return; 
        Else
          ln_numcta := i.ctnro;         
        End If;                
      End loop;  */
      
    -- inicio ylozada 15/05/2019  
      pq_ah_planillas.sp_ah_cta_emp_cts(p_n_codpai => P_N_CODPAI, 
                                        p_n_tipdoc => P_N_TIPDOC,
                                        p_c_numdoc => P_C_NUMDOC, 
                                        p_n_tippro => 2,      
                                        p_c_numcta => ln_numcta,
                                        p_c_coderr => p_c_coderr,
                                        p_c_deserr => p_c_deserr
                                        );    
      if p_c_coderr <> '000' Then                                     
           return;  
      End if;           
    
    --fin ylozada15/05/2019
    /*
    if ln_numcta = 0 then
          p_c_coderr := '001';
          p_c_deserr := 'Error: Cliente no presenta una cuenta cliente';           
          return;       
    End If;
    */
    --obtenemos repositorio
    begin
      select trim(a.tp1desc)
        into lv_nomrep 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio  
    exception
    when others then
       p_c_coderr := '002';
       p_c_deserr := 'Error: No existe repositorio definido';
       return;
    end; 
    --obtenemos repositorio DE PRUEBA ********
    begin
      select trim(a.tp1desc)
        into lv_nomrep1 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 5; --repositorio  
    exception
    when others then
       p_c_coderr := '002';
       p_c_deserr := 'Error: No existe repositorio definido';
       return;
    end;--*****************************     
            
    Case
      When P_C_TIPACC = 'C' then --CARGA
        lv_nomarc := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(P_N_TIPDOC,2,'0')||lpad(trim(P_C_NUMDOC),12,'0')||P_C_CODEXT;  
        pq_ah_planillas.sp_ah_regcar(p_n_codpai => P_N_CODPAI,
                                     p_n_tipdoc => P_N_TIPDOC,
                                     p_c_numdoc => P_C_NUMDOC,
                                     p_n_numcta => ln_numcta,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_nomarc => lv_nomarc,
                                     p_c_nomrep => lv_nomrep,
                                     p_c_tipfor => P_C_TIPFOR,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_tipabo => P_C_TIPABO,
                                     p_n_codban => P_N_CODBAN,
                                     p_n_numcod => P_N_NUMCOD,
                                     p_c_codcta => P_C_CODCTA,
                                     p_c_codmes => P_C_CODMES,
                                     p_n_numano => P_N_NUMANO,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
                                     
        if p_c_coderr = '000' then                             
           lv_deserr := 'Grabación satisfactoria';         
        End If;                                              
         
        if p_c_coderr = '000' then          
          lv_tipo := 'P'; --Envio a procesos centrales
          --obtenemos la agencia          
          begin
            Select a.scnom
              into lc_desage
              from fst001 a 
             where a.pgcod  = 1 
               and a.sucurs = ln_codsuc;
          exception
          when others then  
            lc_desage := '';
          end;               
          --obtenemos el nombre del usuario
          begin
            Select a.ubnom
              into lc_desusu
              from fst746 a 
             where a.ubuser = lc_usuario;
          exception
          when others then  
            lc_desusu := '';
          end;                         
          --*******+ CAMIAR EL NOMBRE A sp_ah_enviomail***************                 
          pq_ah_planillas.sp_ah_enviomail1(p_d_fecpro => P_D_FECPRO,
                                           p_c_codhor => P_C_CODHOR,
                                           p_c_tipenv => lv_tipo,
                                           p_n_numseq => ln_numcta,
                                           p_c_nomarc => lc_desage||'- '||lc_desusu||' - '||lc_usuario,
                                           p_c_coderr => p_c_coderr,
                                           p_c_deserr => p_c_deserr
                                           );                                          
                                                                              
          if p_c_coderr <> '000' then                             
             lv_deserr := lv_deserr||', '||'no se pudo enviar email: '||substr(p_c_deserr,1,150);         
          End If;      
          p_c_deserr := lv_deserr ;                                                                                                                                                                  
        End If;                                      
                                     
      When P_C_TIPACC = 'D' then --DESCARGA              
        pq_ah_planillas.sp_ah_regdes(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_nomrep => lv_nomrep1, -- OJO SE CAMBIO REGRESARLO A   lv_nomrep
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
      When P_C_TIPACC = 'P' then --PROCESADO
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           p_c_deserr := 'Se procesó el archivo satisfactoriamente';         
        End If;   
                                             
      When P_C_TIPACC = 'E' then --PENDIENTE       
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           p_c_deserr := 'Grabación satisfatoria';         
        End If;                                        
                                     
      When P_C_TIPACC = 'R' then --RECHAZADO               
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
        if p_c_coderr = '000' then                             
           lv_deserr := 'Grabación satisfactoria';         
        End If;                                              
         
        if p_c_coderr = '000' then          
          lv_tipo := 'C'; --Envio al contacto          
          --*******+ CAMIAR EL NOMBRE A sp_ah_enviomail***************                                 
          pq_ah_planillas.sp_ah_enviomail1(p_d_fecpro => P_D_FECPRO,
                                           p_c_codhor => P_C_CODHOR,
                                           p_c_tipenv => lv_tipo,
                                           p_n_numseq => P_N_NUMSEQ,
                                           p_c_nomarc => null,
                                           p_c_coderr => p_c_coderr,
                                           p_c_deserr => p_c_deserr
                                           );                                          
                                                                              
          if p_c_coderr <> '000' then                             
             lv_deserr := lv_deserr||', '||'no se pudo enviar email: '||substr(p_c_deserr,1,150);         
          End If;      
          p_c_deserr := lv_deserr ;                                                                                                                                                                              
        End If; 
                                                                                           
      When P_C_TIPACC = 'A' then --ANULADO
        pq_ah_planillas.sp_ah_regest(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => P_D_FECPRO,
                                     p_c_horpro => P_C_CODHOR,
                                     p_c_codusu => P_C_CODUSU,
                                     p_n_codage => ln_codsuc,
                                     p_c_desobs => P_C_DESOBS,
                                     p_c_codest => P_C_TIPACC,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );
      When P_C_TIPACC = 'X' then --DATOS PARA PROCESAR                                                    
        pq_ah_planillas.sp_ah_regdat(p_n_numseq => P_N_NUMSEQ,
                                     p_d_fecpro => p_d_fecpro,
                                     p_c_horpro => p_c_codhor,
                                     p_c_codusu => p_c_codusu,
                                     p_c_tipabo => p_c_tipabo,
                                     p_n_codban => p_n_codban,
                                     p_n_numcod => p_n_numcod,
                                     p_c_codcta => p_c_codcta,
                                     p_c_codmes => p_c_codmes,
                                     p_n_numano => p_n_numano,
                                     p_c_desobs => p_c_desobs,
                                     p_c_coderr => p_c_coderr,
                                     p_c_deserr => p_c_deserr
                                     );                                                                                                
    End Case;  

  exception
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;
  end sp_ah_planillas1;   
  Procedure sp_ah_enviomail1(P_D_FECPRO IN DATE,
                             P_C_CODHOR IN VARCHAR2,
                             P_C_TIPENV IN VARCHAR2,
                             P_N_NUMSEQ IN NUMBER,
                             P_C_NOMARC IN VARCHAR2,           
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2                         
                            ) is
  cursor c_empresa is
    select x.*
      from jaqz177 x 
     where x.jaqz177seq = P_N_NUMSEQ
       and x.jaqz177est = 'R';
       
  cursor c_importacion is       
    select x.*
      from jaql071 x 
     where x.jaql71nuim = P_N_NUMSEQ
       and x.jaql71esta = 'P';
              
  cursor c_contactos(ln_pais in number, ln_tipo in number, lc_numero in char)        is
   select y.* 
     from jaqz172 y
    where y.jaqz172pai = ln_pais
      and y.jaqz172tpo = ln_tipo
      and y.jaqz172num = lc_numero
      and trim(y.jaqz172mai) is not null
      and pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';      
/*      and case
            when REGEXP_LIKE(trim(y.jaqz172mai),
                             '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                             'i') then
             'S'
            else
             'N'
          end = 'S'; */       
  
  cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 61
       and a.Tp1corr2 = 6 
       and a.Tp1corr3 <> 3;
       
  cursor c_importacion_det is       
    select x.*
      from jaql072 x
     where x.jaql72nuim = P_N_NUMSEQ
        and x.jaql72impo > 0;
  cursor c_cartas is
    select a.* 
      from jaql456 a 
     where a.jaql456usu = rpad(P_C_TIPENV,10,' ')
       and a.jaql456cta = P_C_NOMARC;    
       
  cursor c_mail is       
    select trim(a.tp1desc) tp1desc
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 72
       and a.Tp1corr2 = 5; 
                  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(30);  
    lv_asunto     VARCHAR2(30);  
    lv_asunto1    VARCHAR2(30);  
    lv_directorio VARCHAR2(30);  
    lv_archivos   VARCHAR2(30);  
    lv_destinos   VARCHAR2(4000):='';   
    lv_jpla       VARCHAR2(4000):='';   
    ln_cont2      NUMBER(9):=0;     
    lv_estado     VARCHAR2(30);                    
    lv_empresa    VARCHAR2(70);
    lv_motivo     VARCHAR2(400);
    ln_pais       NUMBER(3);
    ln_tipdoc     NUMBER(2);
    lc_numdoc     CHAR(12);
    lv_contacto   VARCHAR2(30);
    lc_Flag       CHAR(1);
    ln_suc        NUMBER(3);
    lc_usrori       char(10);
    lc_usrsup       char(10);    
  begin
    p_c_coderr := '000';       
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := trim(i.tp1desc);
         When i.tp1nro1 = 5 then
           lv_directorio := trim(i.tp1desc);
         When i.tp1nro1 = 4 then
           lv_asunto1    := trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
    If P_C_TIPENV = 'C' then  --contactos de la empresa con el error        
      For j in c_empresa loop        
          --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
          begin                  
            Select trim(b.sng057usr), trim(b.sng057sup)
              into lc_usrori, 
                   lc_usrsup
              from fst046 a, 
                   sng057 b 
             where a.pgcod     = b.sng055emp
               and a.ubuser    = b.sng057usr
               and a.ubsuc     = j.jaqz177agc
               and b.sng055car = 50 --JEFE DE PLATAFORMA                   
               and decode(b.sng057fin, null, to_date('01/01/0001','dd/mm/rrrr'),b.sng057fin) =
                   (Select decode(max(d.sng057fin),
                                  null,
                                  to_date('01/01/0001','dd/mm/rrrr'),
                                  max(d.sng057fin)
                                  )
                      from fst046 c, 
                           sng057 d
                     where c.pgcod     = d.sng055emp
                       and c.ubuser    = d.sng057usr
                       and c.ubsuc     = j.jaqz177agc
                       and d.sng055car = 50
                   )
               and rownum < 2;
          exception
          when others then       
            lc_usrori := '';
            lc_usrsup := '';
          end; 
                 
          lv_motivo := j.jaqz177obs;
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = j.jaqz177pai 
               and a.pjtdoc = j.jaqz177tpo
               and a.pjndoc = j.jaqz177num;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = j.jaqz177pai 
                 and a.petdoc = j.jaqz177tpo
                 and a.pendoc = j.jaqz177num;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
          
          Begin
            select upper(trim(substr(a.tp1desc,3,28)))
              into lv_estado 
              from fst198 a 
             where a.tp1cod   = 1
               and a.tp1cod1  = 10825
               and a.tp1corr1 = 72
               and a.tp1corr2 = 2
               and substr(a.tp1desc,1,1) = j.jaqz177est;
          Exception
          When others then  
            lv_estado := null;
          end;
                                              
          For k in c_contactos(j.jaqz177pai,j.jaqz177tpo,j.jaqz177num) loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.jaqz172mai)||';';   
             lv_contacto := trim(k.jaqz172no1); 
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
              dbms_lob.createtemporary(ll_mensaje, TRUE);     
              if ln_cont2 > 1 then          
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a procesar la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||'.</p>';            
              Else
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a procesar la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||'.</p>';            
              End If;              
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

              lv_mensaje := '
                            <table width="830" height="54" border="0">
                              <tbody>
                                <tr>
                                <td "font-family: Arial, sans-serif; font-size: 14px;" width="15" colspan="2" height="23"><p><strong>Detalles del motivo</strong>:</p></td>      
                                </tr>	  
                                              
                                <tr>
                                  <td width="15" height="23"><strong></strong></td>
                                  <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">'||lv_motivo||'.</td>
                                </tr>
                              </tbody>
                            </table>';               
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                                   
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := '';
                          
              begin                
              CASE
              WHEN trim(lc_usrsup) is not null THEN
                lv_jpla := lower(trim(lc_usrori))||'@cajaarequipa.pe'||';'||lower(trim(lc_usrsup))||'@cajaarequipa.pe';
              ELSE
                lv_jpla := lower(trim(lc_usrori))||'@cajaarequipa.pe';
              END CASE;               
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                               p_destinatarioscc   => lv_jpla,
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje,
                                               p_remitente         => lv_remitente,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => lv_directorio,
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If; 
      End loop;   
    End If;  
    If P_C_TIPENV = 'E' then  --empleador con la planilla
      For j in c_importacion loop
          Begin
            select a.pepais,
                   a.petdoc,
                   a.pendoc
              into ln_pais,
                   ln_tipdoc,
                   lc_numdoc
              from fsr008 a 
             where a.pgcod = 1
               and a.ctnro = j.jaql71ctem
               and a.ttcod = 1
               and a.cttfir = 'T';
          Exception
          when others then
               ln_pais   := 0;   
               ln_tipdoc := 0;
               lc_numdoc := '';
          End;          
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = ln_pais 
               and a.pjtdoc = ln_tipdoc
               and a.pjndoc = lc_numdoc;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = ln_pais
                 and a.petdoc = ln_tipdoc
                 and a.pendoc = lc_numdoc;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
          
          Begin
            select upper(trim(substr(a.tp1desc,3,28)))
              into lv_estado 
              from fst198 a 
             where a.tp1cod   = 1
               and a.tp1cod1  = 10825
               and a.tp1corr1 = 72
               and a.tp1corr2 = 2
               and substr(a.tp1desc,1,1) = j.jaql71esta;
          Exception
          When others then  
            lv_estado := null;
          end;
                                              
          For k in c_contactos(ln_pais,ln_tipdoc,lc_numdoc) loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.jaqz172mai)||';';   
             lv_contacto := trim(k.jaqz172no1);      
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
              dbms_lob.createtemporary(ll_mensaje, TRUE);     
              if ln_cont2 > 1 then          
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a realizar el abono de la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||' satisfactoriamente'||'.</p>'||              
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta reporte con el detalle en formato PDF'||'.</p>';           
              Else
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se procedi&oacute; a realizar el abono de la planilla de la empresa '||lv_empresa||' en nuestro sistema, el cual ha sido '||lv_estado||' satisfactoriamente'||'.</p>'||             
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta reporte con el detalle en formato PDF'||'.</p>';           
              End If;              
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := P_C_NOMARC;
                          
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If; 
      End loop;         
    End If;
    If P_C_TIPENV = 'P' then  --Procesos Centrales
          Begin
            select a.pepais,
                   a.petdoc,
                   a.pendoc
              into ln_pais,
                   ln_tipdoc,
                   lc_numdoc
              from fsr008 a 
             where a.pgcod = 1
               and a.ctnro = P_N_NUMSEQ
               and a.ttcod = 1
               and a.cttfir = 'T';
          Exception
          when others then
               ln_pais   := 0;   
               ln_tipdoc := 0;
               lc_numdoc := '';
          End;          
          Begin
            select trim(a.pjrazs)
              into lv_empresa 
              from fsd003 a 
             where a.pjpais = ln_pais 
               and a.pjtdoc = ln_tipdoc
               and a.pjndoc = lc_numdoc;
          Exception
          When no_data_found then  
            Begin
              select trim(a.penom)
                into lv_empresa 
                from fsd001 a 
               where a.pepais = ln_pais
                 and a.petdoc = ln_tipdoc
                 and a.pendoc = lc_numdoc;
            Exception
            When others then  
              lv_empresa := null;
            end;
          When others then   
            lv_empresa := null;
          end;
                                                        
          For k in c_mail loop            
             ln_cont2 := ln_cont2 + 1;  
             lv_destinos := lv_destinos||trim(k.tp1desc)||';';   
          End loop;  
          
          lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
          If ln_cont2 > 0 then        
                dbms_lob.createtemporary(ll_mensaje, TRUE);     
                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Bantotal le informa: </p>' ||  
                              '<p "font-family: Arial, sans-serif; font-size: 14px;">Se ha ingresado una planilla nueva de CTS de la empresa:</p>';                              
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                lv_mensaje := '
                              <table width="1200" height="50" border="0">
                                <tbody>
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Raz&oacute;n Social:</strong>'||lv_empresa||'</td>      
                                  </tr>	
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Documento:</strong>'||lc_numdoc||'</td>      
                                  </tr>	     
                                  <tr>
                                     <td "font-family: Arial, sans-serif; font-size: 14px;" width="10"  height="10"><strong>Agencia-Usuario:</strong>'||P_C_NOMARC||'</td>      
                                  </tr>	                                                                                                                                                                                                                         
                                </tbody>
                              </table>
                              ';               
            
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

              lv_archivos := '';
                          
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
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
              dbms_lob.freetemporary(ll_mensaje);                           
          End If;                         
    End If;    
      
    If P_C_TIPENV  not in ('C','E','P') then --trabajador adjuntando la carta cts digital
      if trim(P_C_NOMARC) is null then
          For j in c_importacion_det loop
              Begin
                select a.pepais,
                       a.petdoc,
                       a.pendoc
                  into ln_pais,
                       ln_tipdoc,
                       lc_numdoc
                  from fsr008 a 
                 where a.pgcod = 1
                   and a.ctnro = j.jaql72scct
                   and a.ttcod = 1
                   and a.cttfir = 'T';
              Exception
              when others then
                   ln_pais   := 0;   
                   ln_tipdoc := 0;
                   lc_numdoc := '';
              End;    
              
              Begin
                select trim(b.pfnom1)
                  into lv_contacto
                  from fsd002 b 
                 where b.pfpais = ln_pais
                   and b.pftdoc = ln_tipdoc               
                   and b.pfndoc = lc_numdoc;
              Exception
              when others then
                   lv_contacto := '';   
              End;     
              
              --PROYECTO CTS SEGUNDA PARTE
/*              Begin
                select 1
                  into ln_cont2
                  from jaqz173 c 
                 where c.jaqz173pai = ln_pais
                   and c.jaqz173tpo = ln_tipdoc
                   and c.jaqz173num = lc_numdoc
                   and c.jaqz173ser = 1
                   and c.jaqz173med = 1
                   and c.jaqz173est = 'A';
              Exception
              when others then
                   ln_cont2 := 0;
              End;*/  
              
               ln_cont2 := 1;              
              --solo obtener correo si esta afiliado               
              if ln_cont2 = 1 then
                Begin
                  select substr(c.pextxt,1,instr(c.pextxt,'\')-1)
                    into lv_destinos
                    from fsx001 c 
                   where c.pepais = ln_pais
                     and c.petdoc = ln_tipdoc
                     and c.pendoc = lc_numdoc
                     and c.txcod  = 0
                     and c.pexren = 99 --correspondencia
                     and trim(c.pextxt) is not null
                     and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1))) = 'S';                     
/*                     and case
                           when REGEXP_LIKE(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1)),
                                            '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                            'i') then
                            'S'
                           else
                            'N'
                         end = 'S';  */                   
                Exception
               /* when no_data_found then
                  Begin
                    select trim(c.jaqz173mai)
                      into lv_destinos
                      from jaqz173 c 
                     where c.jaqz173pai = ln_pais
                       and c.jaqz173tpo = ln_tipdoc
                       and c.jaqz173num = lc_numdoc
                       and c.jaqz173ser = 1
                       and c.jaqz173med = 1
                       and c.jaqz173est = 'A'
                       and trim(c.jaqz173mai) is not null
                       and pq_ah_enviodigital.fn_ah_valida_mail(trim(c.jaqz173mai)) = 'S';                       
\*                       and case
                             when REGEXP_LIKE(trim(c.jaqz173mai),
                                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                              'i') then
                              'S'
                             else
                              'N'
                           end = 'S'; *\                       
                  Exception
                  when others then
                       lv_destinos := '';   
                       ln_cont2 := 0;
                  End; */
                when others then                
                     lv_destinos := '';   
                     ln_cont2 := 0;                
                End;
              end if;                                
              --FIN
              
              Begin
                 select 'S' 
                   into lc_Flag
                   from jaqz178   
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178imp = j.jaql72nuim
                    and jaqz178pgc = j.jaql72pgco 
                    and jaqz178mod = j.jaql72scmo
                    and jaqz178suc = j.jaql72scsu
                    and jaqz178mda = j.jaql72scmd
                    and jaqz178pap = j.jaql72scpa
                    and jaqz178cta = j.jaql72scct
                    and jaqz178ope = j.jaql72scop
                    and jaqz178sbo = j.jaql72scsb
                    and jaqz178tpo = j.jaql72scto
                    and jaqz178est = 'S';    
              Exception
              when others then
                   lc_flag := 'N';
              End;                                                                              
             
              If ln_cont2 > 0 and lc_flag = 'N' then        
                  dbms_lob.createtemporary(ll_mensaje, TRUE);     
                  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta su carta CTS con el &uacute;ltimo abono realizado por su empleador'||'.</p>';           

                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
                  lv_mensaje := 
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

                  lv_archivos := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(ln_tipdoc,2,'0')||lpad(trim(lc_numdoc),12,'0')||'.pdf';  
                  
                  begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                   p_destinatarioscc   => '',
                                                   p_destinatariosbcc  => '',
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_remitente,
                                                   p_asunto            => lv_asunto1,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => lv_directorio,
                                                   p_archivosadjuntos  => lv_archivos,
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_deserr
                                                   );
                  exception
                  when others then  
                       p_c_coderr := '00x';
                       p_c_deserr := sqlerrm;                                                   
                  end;
                  dbms_lob.freetemporary(ll_mensaje);    
                  --registramos el envío o error en el log
                  if p_c_coderr = '000' then
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => j.jaql72pgco,
                                                   p_n_scmod  => j.jaql72scmo,
                                                   p_n_scsuc  => j.jaql72scsu,
                                                   p_n_scmda  => j.jaql72scmd,
                                                   p_n_scpap  => j.jaql72scpa,
                                                   p_n_sccta  => j.jaql72scct,
                                                   p_n_scoper => j.jaql72scop,
                                                   p_n_scsbop => j.jaql72scsb,
                                                   p_n_sctope => j.jaql72scto,
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'S',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => null,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                
                  Else
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => j.jaql72pgco,
                                                   p_n_scmod  => j.jaql72scmo,
                                                   p_n_scsuc  => j.jaql72scsu,
                                                   p_n_scmda  => j.jaql72scmd,
                                                   p_n_scpap  => j.jaql72scpa,
                                                   p_n_sccta  => j.jaql72scct,
                                                   p_n_scoper => j.jaql72scop,
                                                   p_n_scsbop => j.jaql72scsb,
                                                   p_n_sctope => j.jaql72scto,
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'E',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => p_c_deserr,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                 
                  End If;                                       
              End If; 
              IF lc_flag = 'S' then
                 update jaqz178 
                    set jaqz178ax1 = 1
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178imp = j.jaql72nuim
                    and jaqz178pgc = j.jaql72pgco 
                    and jaqz178mod = j.jaql72scmo
                    and jaqz178suc = j.jaql72scsu
                    and jaqz178mda = j.jaql72scmd
                    and jaqz178pap = j.jaql72scpa
                    and jaqz178cta = j.jaql72scct
                    and jaqz178ope = j.jaql72scop
                    and jaqz178sbo = j.jaql72scsb
                    and jaqz178tpo = j.jaql72scto
                    and jaqz178est = 'S';    
              End If;  
          End loop;         
      Else
          For j in c_cartas loop
              Begin
                select a.pepais,
                       a.petdoc,
                       a.pendoc
                  into ln_pais,
                       ln_tipdoc,
                       lc_numdoc
                  from fsr008 a 
                 where a.pgcod = 1
                   and a.ctnro = to_number(substr(j.jaql456cta,1,9))
                   and a.ttcod = 1
                   and a.cttfir = 'T';
              Exception
              when others then
                   ln_pais   := 0;   
                   ln_tipdoc := 0;
                   lc_numdoc := '';
              End;    
              
              Begin
                select trim(b.pfnom1)
                  into lv_contacto
                  from fsd002 b 
                 where b.pfpais = ln_pais
                   and b.pftdoc = ln_tipdoc               
                   and b.pfndoc = lc_numdoc;
              Exception
              when others then
                   lv_contacto := '';   
              End;     

              --PROYECTO CTS SEGUNDA PARTE
/*              Begin
                select 1
                  into ln_cont2
                  from jaqz173 c 
                 where c.jaqz173pai = ln_pais
                   and c.jaqz173tpo = ln_tipdoc
                   and c.jaqz173num = lc_numdoc
                   and c.jaqz173ser = 1
                   and c.jaqz173med = 1
                   and c.jaqz173est = 'A';
              Exception
              when others then
                   ln_cont2 := 0;
              End;*/ 
              ln_cont2 := 1;               
              --solo obtener correo si esta afiliado               
              if ln_cont2 = 1 then                              
                Begin
                  select substr(c.pextxt,1,instr(c.pextxt,'\')-1)
                    into lv_destinos
                    from fsx001 c 
                   where c.pepais = ln_pais
                     and c.petdoc = ln_tipdoc
                     and c.pendoc = lc_numdoc
                     and c.txcod  = 0
                     and c.pexren = 99 --correspondencia
                     and trim(c.pextxt) is not null
                     and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1))) = 'S';                     
/*                     and case
                           when REGEXP_LIKE(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1)),
                                            '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                            'i') then
                            'S'
                           else
                            'N'
                         end = 'S';  */                    
                Exception
/*                when no_data_found then
                  Begin
                    select trim(c.jaqz173mai)
                      into lv_destinos
                      from jaqz173 c 
                     where c.jaqz173pai = ln_pais
                       and c.jaqz173tpo = ln_tipdoc
                       and c.jaqz173num = lc_numdoc
                       and c.jaqz173ser = 1
                       and c.jaqz173med = 1
                       and c.jaqz173est = 'A'
                       and trim(c.jaqz173mai) is not null
                       and pq_ah_enviodigital.fn_ah_valida_mail(trim(c.jaqz173mai)) = 'S';                     
\*                       and case
                             when REGEXP_LIKE(trim(c.jaqz173mai),
                                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                              'i') then
                              'S'
                             else
                              'N'
                           end = 'S'; *\                       
                  Exception
                  when others then
                       lv_destinos := '';   
                       ln_cont2 := 0;
                  End; */                   
                when others then
                     lv_destinos := '';   
                     ln_cont2 := 0;
                End; 
              End if;              
              --FIN
              
              Begin
                 select 'S',x.scsuc
                   into lc_Flag,ln_suc
                   from fsd011 x
                  Where x.pgcod  = 1
                    and x.scmod  = 21
                    and x.scmda  = to_number(substr(j.jaql456cta,13,3))
                    and x.scpap  = 0
                    and x.sccta  = to_number(substr(j.jaql456cta,1,9))
                    and x.scoper = 0
                    and x.scsbop = to_number(substr(j.jaql456cta,16,2))
                    and x.sctope = to_number(substr(j.jaql456cta,18,3));
              Exception
              when others then
                   lc_flag := 'N';
                   ln_suc  := 0;
              End;                   
                                 
              Begin
                 select 'S' 
                   into lc_Flag
                   from jaqz178   
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178pgc = 1
                    and jaqz178mod = 21
                    and jaqz178suc = ln_suc
                    and jaqz178mda = to_number(substr(j.jaql456cta,13,3))
                    and jaqz178pap = 0
                    and jaqz178cta = to_number(substr(j.jaql456cta,1,9))
                    and jaqz178ope = 0
                    and jaqz178sbo = to_number(substr(j.jaql456cta,16,2))
                    and jaqz178tpo = to_number(substr(j.jaql456cta,18,3))
                    and jaqz178est = 'S';    
              Exception
              when others then
                   lc_flag := 'N';
              End;                                                                              
             
              If ln_cont2 > 0 and lc_flag = 'N' then        
                  dbms_lob.createtemporary(ll_mensaje, TRUE);     
                  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||  
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">'|| trim(lv_contacto) || '</p>' ||                                
                                '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta su carta CTS con el &uacute;ltimo abono realizado por su empleador'||'.</p>';           

                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                                                        
                  lv_mensaje := 
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         

                  lv_archivos := to_char(P_D_FECPRO,'rrmmdd')||replace(P_C_CODHOR,':','')||lpad(ln_tipdoc,2,'0')||lpad(trim(lc_numdoc),12,'0')||'.pdf';  
                  
                  begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                   p_destinatarioscc   => '',
                                                   p_destinatariosbcc  => '',
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_remitente,
                                                   p_asunto            => lv_asunto1,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => lv_directorio,
                                                   p_archivosadjuntos  => lv_archivos,
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_deserr
                                                   );
                  exception
                  when others then  
                       p_c_coderr := '00x';
                       p_c_deserr := sqlerrm;                                                   
                  end;
                  dbms_lob.freetemporary(ll_mensaje);    
                  --registramos el envío o error en el log
                  if p_c_coderr = '000' then
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => 1,
                                                   p_n_scmod  => 21,
                                                   p_n_scsuc  => ln_suc,
                                                   p_n_scmda  => to_number(substr(j.jaql456cta,13,3)),
                                                   p_n_scpap  => 0,
                                                   p_n_sccta  => to_number(substr(j.jaql456cta,1,9)),
                                                   p_n_scoper => 0,
                                                   p_n_scsbop => to_number(substr(j.jaql456cta,16,2)),
                                                   p_n_sctope => to_number(substr(j.jaql456cta,18,3)),
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'S',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => null,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                
                  Else
                      pq_ah_planillas.sp_ah_regenv(p_d_fecpro => P_D_FECPRO,
                                                   p_n_numimp => P_N_NUMSEQ,
                                                   p_c_codusu => P_C_TIPENV,
                                                   p_n_pgcod  => 1,
                                                   p_n_scmod  => 21,
                                                   p_n_scsuc  => ln_suc,
                                                   p_n_scmda  => to_number(substr(j.jaql456cta,13,3)),
                                                   p_n_scpap  => 0,
                                                   p_n_sccta  => to_number(substr(j.jaql456cta,1,9)),
                                                   p_n_scoper => 0,
                                                   p_n_scsbop => to_number(substr(j.jaql456cta,16,2)),
                                                   p_n_sctope => to_number(substr(j.jaql456cta,18,3)),
                                                   p_c_nomarc => lv_archivos,
                                                   p_c_codest => 'E',
                                                   p_c_maicor => lv_destinos,
                                                   p_c_desobs => p_c_deserr,
                                                   p_c_coderr => p_c_coderr,
                                                   p_c_deserr => p_c_deserr
                                                  );                 
                  End If;                                       
              End If; 
              IF lc_flag = 'S' then
                 update jaqz178 
                    set jaqz178ax1 = 1
                  Where jaqz178fec = P_D_FECPRO
                    and jaqz178pgc = 1
                    and jaqz178mod = 21
                    and jaqz178suc = ln_suc
                    and jaqz178mda = to_number(substr(j.jaql456cta,13,3))
                    and jaqz178pap = 0
                    and jaqz178cta = to_number(substr(j.jaql456cta,1,9))
                    and jaqz178ope = 0
                    and jaqz178sbo = to_number(substr(j.jaql456cta,16,2))
                    and jaqz178tpo = to_number(substr(j.jaql456cta,18,3))
                    and jaqz178est = 'S';    
              End If;              
          End loop;    
      
      End if;              
    End If;
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;                                 
  end sp_ah_enviomail1;        
  Procedure sp_ah_genera_codpla(P_D_FECPRO IN DATE,
                                P_N_PAIS   IN NUMBER,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,         
                                p_c_coderr out varchar2,
                                p_c_deserr out varchar2                         
                              ) is  
  ln_numgen number(9):=0;  
  ln_codgen number(3):=0;
  lc_numdoc char(12):='';                            
  begin
    p_c_coderr := '0000';
    lc_numdoc := P_C_NUMDOC;
    --validar contra guia de parametria de cantidad d egeneraciones por dia
    begin
      Select a.tp1nro1
        into ln_numgen
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10825
         and a.tp1corr1 = 124
         and a.tp1corr2 = 1;
    exception
    when others then
      ln_numgen := 0;
    end;
    
    begin
     select aqpa140num
       into ln_codgen
       from aqpa140
      where aqpa140fec = P_D_FECPRO
        and aqpa140pai = P_N_PAIS
        and aqpa140tip = P_N_TIPDOC
        and aqpa140doc = lc_numdoc
        for update of aqpa140num;                  
    exception
    when no_data_found then
         begin
         insert into aqpa140(aqpa140fec,
                             aqpa140pai,
                             aqpa140tip,
                             aqpa140doc,
                             aqpa140num
                             )                             
                      values(P_D_FECPRO,
                             P_N_PAIS,
                             P_N_TIPDOC,
                             lc_numdoc,                             
                             0
                            );
          end;   
                             
          begin
           select aqpa140num
             into ln_codgen
             from aqpa140
            where aqpa140fec = P_D_FECPRO
              and aqpa140pai = P_N_PAIS
              and aqpa140tip = P_N_TIPDOC
              and aqpa140doc = lc_numdoc
              for update of aqpa140num;           
          end;        
    end;    
      -- Actualización.
    ln_codgen := ln_codgen + 1;
    if ln_codgen <= ln_numgen And ln_numgen  > 0 then     
     update aqpa140 
        set aqpa140num = ln_codgen  
      where aqpa140fec = P_D_FECPRO
        and aqpa140pai = P_N_PAIS
        and aqpa140tip = P_N_TIPDOC
        and aqpa140doc = lc_numdoc;      
      -- Grabación.
        commit;
        p_c_deserr := 'OK';
    Else
        p_c_coderr := '0001';       
        p_c_deserr := 'Se superó el número de intentos';    
        rollback;
    End If;
  exception
  when others then   
    p_c_coderr := '000x';        
    p_c_deserr := sqlerrm;       
  end sp_ah_genera_codpla;                                         
  Procedure sp_ah_saldo_cdk(P_N_CTACLI IN NUMBER,
                            P_N_CTAEMP IN NUMBER,
                            P_N_CODMON IN NUMBER,
                            p_n_saldo  out number,   
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                            ) is 
  ln_pacl    number(3); 
  ln_tpcl    number(2);  
  lc_docl    char(12);
  ln_paem    number(3);  
  ln_tpem    number(2);  
  lc_doem    char(12);                               
  begin
    p_c_coderr := '000';
    p_n_saldo := -1;
    --obtenemos datos del cliente
    begin
      select a.pepais,a.petdoc,a.pendoc
        into ln_pacl, ln_tpcl, lc_docl 
        from fsr008 a 
       where a.pgcod = 1 
         and a.ctnro = P_N_CTACLI 
         and a.ttcod = 1 
         and a.cttfir = 'T';
    exception
    when others then
      p_c_coderr := sqlcode;
      p_c_deserr := sqlerrm;           
      return;   
    end;
    --obtenemos datos del empleador
    begin
      select a.pepais,a.petdoc,a.pendoc
        into ln_paem, ln_tpem, lc_doem 
        from fsr008 a 
       where a.pgcod = 1 
         and a.ctnro = P_N_CTAEMP 
         and a.ttcod = 1 
         and a.cttfir = 'T';
    exception
    when others then
      p_c_coderr := sqlcode;
      p_c_deserr := sqlerrm;    
      return;          
    end;    
    --OBTENEMOS EL SALDO
    begin
      select a.aqpa149sald
        into p_n_saldo
        from aqpa149 a 
       where a.aqpa149pacl = ln_pacl   
         and a.aqpa149tpcl = ln_tpcl
         and a.aqpa149docl = lc_docl
         and a.aqpa149paem = ln_paem  
         and a.aqpa149tpem = ln_tpem
         and a.aqpa149doem = lc_doem
         and a.aqpa149mone = P_N_CODMON;
    exception
    when others then
      p_c_coderr := sqlcode;
      p_c_deserr := sqlerrm;       
      return;    
    end;      
  Exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;      
  end sp_ah_saldo_cdk;                            
End PQ_AH_PLANILLAS;
/

