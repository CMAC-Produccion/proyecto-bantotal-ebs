create or replace package "PQ_AH_ENVIODIGITAL" is
   -- *****************************************************************
    -- Nombre                     : PQ_AH_ENVIODIGITAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Envios de mail
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 12/04/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó parametro en alerta de experiencia al cliente
    -- Fecha de Modificación      : 14/10/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó campos de fecha hora y usuario de regularización 
    -- Fecha de Modificación      : 23/10/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó envio mail bienvenida a ex CREDINKA
    -- Fecha de Modificación      : 02/12/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó envio mail migracion saldos CTS ex CREDINKA
    -- Fecha de Modificación      : 16/12/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó envio mail migracion saldos AHORROS ex CREDINKA    
    -- Fecha de Modificación      : 02/04/2025
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se comentó procedimiento CREDINKA
    -- *****************************************************************    

  -- Public function and procedure declarations
  Procedure sp_ah_envio_ape(P_D_FECPRO IN DATE,
                            P_C_CODUSU IN VARCHAR2,           
                            P_N_CTAINI IN NUMBER,             
                            P_N_CTAFIN IN NUMBER,
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2         
                            );
  Procedure sp_ah_envio_mail(P_N_CODPAI IN NUMBER,          
                             P_N_TIPDOC IN NUMBER,
                             P_C_NUMDOC IN VARCHAR2,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_ADJUNT IN VARCHAR2,
                             P_C_TIPENV IN VARCHAR2,
                             p_c_deslob in out clob,        
                             p_c_nomdir out varchar2,
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2
                            );                            
  Procedure sp_ah_mail_cta(P_N_NUMCTA IN NUMBER,
                           P_C_TIPCTA IN VARCHAR2, --E='EMPLEADOR' C='CLIENTE'        
                           p_n_codpai out number,          
                           p_n_tipdoc out number,
                           p_c_numdoc out varchar2,
                           p_c_emails out varchar2
                          );
  Function fn_ah_valida_mail(P_C_MAIL IN VARCHAR2) return varchar2;      
  Function fn_ah_valida_celular(P_C_NUMTEL IN VARCHAR2,P_N_TIPCEL IN NUMBER) return varchar2;                                                    
  Procedure sp_ah_registra_envio_cli(P_N_PGCOD  IN NUMBER,          
                                     P_N_SCMOD  IN NUMBER,
                                     P_N_SCSUC  IN NUMBER,
                                     P_N_SCMDA  IN NUMBER,
                                     P_N_SCPAP  IN NUMBER,
                                     P_N_SCCTA  IN NUMBER,
                                     P_N_SCOPER IN NUMBER,
                                     P_N_SCSBOP IN NUMBER,
                                     P_N_SCTOPE IN NUMBER,
                                     P_N_CTAEMP IN NUMBER,
                                     P_C_CODEST IN VARCHAR2,
                                     P_C_CODUSU IN VARCHAR2,
                                     P_C_DESMOT IN VARCHAR2,
                                     P_C_DESLOB IN CLOB,
                                     P_C_NOMCON IN VARCHAR2, --NOMBRE DEL CONTRATO
                                     P_C_NOMCAR IN VARCHAR2, --NOMBRE DE LA CARTILLA
                                     P_D_FECPRO IN DATE,
                                     P_C_NOMDIR IN VARCHAR2, --DIRECTORIO     
                                     P_C_DIRMAI IN VARCHAR2, --MAILS  
                                     P_N_CODENV IN NUMBER,                                                                                                                 
                                     p_c_coderr out varchar2,
                                     p_c_deserr out varchar2                                 
                                     );
  Procedure sp_ah_registra_envio_emp(P_N_CTAEMP IN NUMBER,
                                     P_C_CODEST IN VARCHAR2,
                                     P_C_CODUSU IN VARCHAR2,
                                     P_C_DESMOT IN VARCHAR2,
                                     P_C_DESLOB IN CLOB,
                                     P_D_FECPRO IN DATE,
                                     P_C_DIRMAI IN VARCHAR2, --MAILS
                                     p_c_coderr out varchar2,
                                     p_c_deserr out varchar2                                 
                                     );     
  Function fn_ah_nombre_per(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2              
                           ) return varchar2;
                           
  Procedure sp_ah_envio_mail_jpla(P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2,                      
                                  P_N_SUCINI IN NUMBER,
                                  P_N_SUCFIN IN NUMBER,
                                  p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2                                     
                                  );                           
                           
  Procedure sp_ah_registra_envio_jepla(P_N_CODSUC IN NUMBER,
                                       P_C_CODEST IN VARCHAR2,
                                       P_C_CODUSU IN VARCHAR2,
                                       P_C_DESMOT IN VARCHAR2,
                                       P_C_DESLOB IN CLOB,
                                       P_D_FECPRO IN DATE,
                                       P_C_DIRMAI IN VARCHAR2, --MAILS
                                       p_c_coderr out varchar2,
                                       p_c_deserr out varchar2                                 
                                       );    
  Function fn_ah_verifica_envio(P_C_TIPVER IN VARCHAR2,
                                P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_SCMOD  IN NUMBER,
                                P_N_SCSUC  IN NUMBER,
                                P_N_SCMDA  IN NUMBER,
                                P_N_SCPAP  IN NUMBER,
                                P_N_SCCTA  IN NUMBER,
                                P_N_SCOPER IN NUMBER,
                                P_N_SCSBOP IN NUMBER,
                                P_N_SCTOPE IN NUMBER                            
                               ) return varchar2;                                                                                                                                
  Procedure sp_ah_registra_envio(P_N_PGCOD  IN NUMBER,          
                                 P_N_SCMOD  IN NUMBER,
                                 P_N_SCSUC  IN NUMBER,
                                 P_N_SCMDA  IN NUMBER,
                                 P_N_SCPAP  IN NUMBER,
                                 P_N_SCCTA  IN NUMBER,
                                 P_N_SCOPER IN NUMBER,
                                 P_N_SCSBOP IN NUMBER,
                                 P_N_SCTOPE IN NUMBER,
                                 P_N_CTAEMP IN NUMBER,
                                 P_C_CODUSU IN VARCHAR2,
                                 P_C_DESMOT IN VARCHAR2,
                                 P_D_FECPRO IN DATE,    
                                 P_N_CODMED IN NUMBER,
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2
                                 );    
  Procedure sp_ah_envio_ape_afp(P_D_FECPRO IN DATE,
                                P_C_CODUSU IN VARCHAR2,              
                                P_C_MAIL   IN VARCHAR2,    
                                P_N_PGCOD  IN NUMBER,   
                                P_N_SCMOD  IN NUMBER,
                                P_N_SCSUC  IN NUMBER,
                                P_N_SCMDA  IN NUMBER,
                                P_N_SCPAP  IN NUMBER,
                                P_N_SCCTA  IN NUMBER,
                                P_N_SCOPER IN NUMBER,
                                P_N_SCSBOP IN NUMBER,
                                P_N_SCTOPE IN NUMBER,                                                                  
                                p_c_coderr out VARCHAR2,
                                p_c_deserr out VARCHAR2         
                               ); 
  Procedure sp_ah_notifica_cancel(P_D_FECPRO IN DATE,
                                  P_N_PGCOD  IN NUMBER,  
                                  P_N_SCMOD  IN NUMBER,
                                  P_N_SCSUC  IN NUMBER,
                                  P_N_SCMDA  IN NUMBER,
                                  P_N_SCPAP  IN NUMBER,
                                  P_N_SCCTA  IN NUMBER,
                                  P_N_SCOPER IN NUMBER,
                                  P_N_SCSBOP IN NUMBER,
                                  P_N_SCTOPE IN NUMBER,
                                  P_N_CODCON IN NUMBER,
                                  P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER,
                                  P_C_NUMDOC IN VARCHAR2,
                                  p_c_indnot in out varchar2,
                                  p_c_coderr out varchar2,
                                  p_c_msgerr out varchar2
                                  );       
  Procedure sp_ah_notifica_jpla(P_D_FECPRO IN DATE,
                                P_N_CODSUC IN NUMBER,
                                P_D_FECINI IN DATE,
                                P_D_FECFIN IN DATE,      
                                P_C_NOMARC IN VARCHAR2,                           
                                p_c_coderr out varchar2,
                                p_c_msgerr out varchar2
                               );     
  Procedure sp_ah_envio_com(P_D_FECPRO IN DATE,
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
                            P_N_SCMTO  IN NUMBER,
                            P_C_EMAILS in VARCHAR2,
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2         
                            );    
  Procedure sp_ah_gencor_carta(P_D_FECPRO IN DATE,
                               p_n_numcor out number
                               );  
Procedure sp_ah_notifica_ape_jpla(P_N_PGCOD  IN NUMBER,
                                  P_N_SCMOD  IN NUMBER,
                                  P_N_SCSUC  IN NUMBER,
                                  P_N_SCMDA  IN NUMBER,
                                  P_N_SCCTA  IN NUMBER,
                                  P_N_SCOPER IN NUMBER,
                                  P_N_SCSBOP IN NUMBER,
                                  P_N_SCTOPE IN NUMBER,
                                  P_N_SCMTO  IN NUMBER,
                                  P_D_FECPRO IN DATE,    
                                  P_C_CODUSU IN VARCHAR2,
                                  p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2                                                            
                                 );  

 Procedure sp_ah_notifica_ape_can(P_N_PGCOD  IN NUMBER,
                                  P_N_SCMOD  IN NUMBER,
                                  P_N_SCSUC  IN NUMBER,
                                  P_N_SCMDA  IN NUMBER,
                                  P_N_SCPAP  IN NUMBER,                                  
                                  P_N_SCCTA  IN NUMBER,
                                  P_N_SCOPER IN NUMBER,
                                  P_N_SCSBOP IN NUMBER,
                                  P_N_SCTOPE IN NUMBER,
                                  P_N_SCMTO  IN NUMBER,
                                  P_N_MODOPE IN NUMBER,
                                  P_N_TRXOPE IN NUMBER, 
                                  P_N_ITSUC  IN NUMBER,     
                                  P_N_ITREL  IN NUMBER,                                                                 
                                  P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2,                                                                                                
                                  p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2                                                            
                                 );        

 Procedure sp_ah_enrola_cel(P_N_PGCOD  IN NUMBER,                                                                 
                            P_N_SCCTA  IN NUMBER,                                                                                                                             
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2                                                            
                           ); 
 Procedure sp_ah_envio_ape_cdk(P_D_FECINI IN DATE,
                               P_D_FECFIN IN DATE,           
                               p_c_coderr out VARCHAR2,
                               p_c_deserr out VARCHAR2         
                              );                                                                                                                                                                                                                                                                                                                                               
  Procedure sp_ah_envio_sal_cdk(P_C_CODUSU in VARCHAR2,       
                                p_c_coderr out VARCHAR2,
                                p_c_deserr out VARCHAR2         
                                );  
/*                                
  Procedure sp_ah_envio_migah_cdk(p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2         
                                 );                                                              
*/                                 
end PQ_AH_ENVIODIGITAL;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body "PQ_AH_ENVIODIGITAL" is

  Procedure sp_ah_envio_ape(P_D_FECPRO IN DATE,
                            P_C_CODUSU IN VARCHAR2,           
                            P_N_CTAINI IN NUMBER,             
                            P_N_CTAFIN IN NUMBER,
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2         
                            ) is         
       
  cursor c_empleadores(ln_codmod in number, 
                       ln_tipope in number, 
                       ln_dias   in number
                       ) is
--    Select distinct 
    Select /*+index(b fsr01103) index(a fsd01112)*/ 
           distinct 
           b.r1cta cuentaemp
      from fsd011 a,
           fsr011 b
     where a.pgcod = b.r1cod
       and b.r1cta between P_N_CTAINI and P_N_CTAFIN
       and b.r1cod = b.r2cod
       and a.scmod = b.r2mod
       and a.scsuc = b.r2suc
       and a.scmda = b.r2mda
       and a.scpap = b.r2pap
       and a.sccta = b.r2cta
       and a.scoper = b.r2oper
       and a.scsbop = b.r2sbop
       and a.sctope = b.r2tope
       and b.r011co = 'S'
       and b.relcod = 45
       and a.pgcod  = 1
       and a.scmod  = ln_codmod
       and a.sctope = ln_tipope
       and a.scstat = 4
       and a.scfval >= P_D_FECPRO - ln_dias
       and not exists (Select /*+index(x SYS_C00977357)*/ 1 
                         from jaqz188 x 
                        where x.jaqz188pgc = b.r2cod 
                          and x.jaqz188mod = b.r2mod
                          and x.jaqz188suc = b.r2suc
                          and x.jaqz188mda = b.r2mda
                          and x.jaqz188pap = b.r2pap
                          and x.jaqz188cta = b.r2cta
                          and x.jaqz188ope = b.r2oper
                          and x.jaqz188sbo = b.r2sbop
                          and x.jaqz188tpo = b.r2tope
                          and x.jaqz188est = 'S'
                      );     
  cursor c_empleadores_empleado(ln_numcta in number, 
                                ln_codmod in number, 
                                ln_tipope in number, 
                                ln_dias   in number
                                ) is
    Select a.pgcod,
           a.scmod,
           a.scsuc,
           a.scmda,
           a.scpap,
           a.sccta,
           a.scoper,
           a.scsbop,
           a.sctope,
           case
             when a.scmod = 21 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0')
             when a.scmod = 22 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')||lpad(a.sctope,3,'0')               
             Else
               lpad(a.sccta,9,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')
           end cuentacli,
           a.scfval            
      from fsd011 a,
           fsr011 b
     where a.pgcod = b.r1cod
       and b.r1cta = decode(ln_numcta,0,b.r1cta,ln_numcta)
       and b.r1cod = b.r2cod
       and a.scmod = b.r2mod
       and a.scsuc = b.r2suc
       and a.scmda = b.r2mda
       and a.scpap = b.r2pap
       and a.sccta = b.r2cta
       and a.scoper = b.r2oper
       and a.scsbop = b.r2sbop
       and a.sctope = b.r2tope
       and b.r011co = 'S'
       and b.relcod = 45
       and a.pgcod  = 1
       and a.scmod  = ln_codmod
       and a.sctope = ln_tipope
       and a.scstat = 4
       and a.scfval >= P_D_FECPRO - ln_dias   
       --and b.r2cta = 702629
       and not exists (Select 1 
                         from jaqz188 x 
                        where x.jaqz188pgc = b.r2cod 
                          and x.jaqz188mod = b.r2mod
                          and x.jaqz188suc = b.r2suc
                          and x.jaqz188mda = b.r2mda
                          and x.jaqz188pap = b.r2pap
                          and x.jaqz188cta = b.r2cta
                          and x.jaqz188ope = b.r2oper
                          and x.jaqz188sbo = b.r2sbop
                          and x.jaqz188tpo = b.r2tope
                          and x.jaqz188est = 'S'
                      )
     and not exists (select 1 
                       from jaql054 z 
                      where z.jaql54pgco = b.r2cod 
                        and z.jaql54scsu = b.r2suc
                        and z.jaql54scmd = b.r2mda
                        and z.jaql54scpa = b.r2pap
                        and z.jaql54scct = b.r2cta
                        and z.jaql54scop = b.r2oper
                        and z.jaql54scsb = b.r2sbop
                        and z.jaql54scto = b.r2tope
                        and z.jaql54scmo = b.r2mod 
                        and z.jaql54enti = 230 
                        and z.JAQL54TIMI = 'M' 
                      ); --FILTRAR LAS APERTURAS X MIGRACION MANUAL CREDINKA                                     
  cursor c_datos is
    Select a.* 
      from fst198 a
     where a.tp1cod   = 1 
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 84
       and a.tp1corr2 = 1;  
       
  cursor c_datos2 is
    Select a.* 
      from fst198 a
     where a.tp1cod   = 1 
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 84
       and a.tp1corr2 = 2;   
       
  cursor c_datos5 is
    Select a.* 
      from fst198 a
     where a.tp1cod   = 1 
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 84
       and a.tp1corr2 = 5;              
       
  cursor c_datos8(ln_tp1nro1 in number, ln_tp1nro2 in number) is
    Select a.* 
      from fst198 a
     where a.tp1cod   = 1 
       and a.tp1cod1  = 10825
       and a.tp1corr1 = 84
       and a.tp1corr2 = 7
       and a.tp1nro1  = ln_tp1nro1
       and a.tp1nro2  = ln_tp1nro2;   
            
  lv_adjuntos         varchar2(32767);
  lv_adjuntos_all     varchar2(32767);  
  ln_dias             number(9):= 0;
  ln_tipmai           number(9):= 0;
  ln_numtra           number(9):= 0;
  ln_codpai           number(3);
  ln_tipdoc           number(2);
  lc_numdoc           varchar2(12);
  lc_emails           varchar2(32767);
  lc_estado           char(1);
  lb_deslob           clob;
  lb_deslob1          clob;  
  lv_mensaje          varchar2(32767);  
  lv_nomdir           varchar2(30);
  lv_cartilla         varchar2(32);
  lv_contrato         varchar2(32);
  lv_contacto         varchar2(110);
  lv_estado           varchar2(1):= 'N'; 
  ln_paiemp           number(3);
  ln_tipemp           number(2);
  lc_numemp           varchar2(12);
  lc_maiemp           varchar2(32767);  
  ln_codenv           number(1):= 0;  
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    --OBTENEMOS DÍAS TOPE PARA ENVÍO DE MAIL
    ln_dias := 0;
    For x in c_datos5 loop
      ln_dias := x.tp1nro1;
    end loop;   
    
    -- BARREMOS LOS TIPOS DE PRODUCTO HABILITADOS
    For i in c_datos loop
        --OBTENEMOS POR TIPO DE PRODUCTO TIPO DE ENVIO DE EMAIL
        For x in c_datos8(i.tp1nro1,i.tp1nro2) loop
          ln_tipmai := x.tp1nro3;
        end loop;      
        
        --listado de empleadores
        For j in c_empleadores(i.tp1nro1,i.tp1nro2,ln_dias) loop
          --listado de trabajadores x empleador
          lv_adjuntos_all := null;
          ln_numtra := 0;
          --obtenemos correo del empleador
          pq_ah_enviodigital.sp_ah_mail_cta(p_n_numcta => j.cuentaemp,
                                            P_c_tipcta => 'E',           
                                            p_n_codpai => ln_paiemp,
                                            p_n_tipdoc => ln_tipemp,
                                            p_c_numdoc => lc_numemp,
                                            p_c_emails => lc_maiemp
                                            );            
          dbms_lob.createtemporary(lb_deslob1, TRUE);              
          For k in c_empleadores_empleado(j.cuentaemp,
                                          i.tp1nro1,
                                          i.tp1nro2,
                                          ln_dias  
                                          ) loop
             --armamos los nombres de los archivos a adjuntar                             
             lv_adjuntos := null;
             lv_cartilla := null;
             lv_contrato := null;
             ln_numtra := ln_numtra + 1;                             
             For z in c_datos2 loop
               lv_adjuntos := lv_adjuntos || substr(z.tp1desc,1,1)||k.cuentacli||'.pdf;';               
               if z.tp1nro1 = 1 then
                  lv_cartilla := substr(z.tp1desc,1,1)||k.cuentacli||'.pdf';
               end if;             
               if z.tp1nro1 = 2 then
                  lv_contrato := substr(z.tp1desc,1,1)||k.cuentacli||'.pdf';
               end if;  
               if z.tp1nro1 <> 2 then
                  lv_adjuntos_all := lv_adjuntos_all || substr(z.tp1desc,1,1)||k.cuentacli||'.pdf;';                     
               End If;                          
             End loop;
             lv_adjuntos := substr(lv_adjuntos,1,length(lv_adjuntos)-1);
             
             --obtenemos correo electronicos del trabajador
             pq_ah_enviodigital.sp_ah_mail_cta(p_n_numcta => k.sccta,
                                               P_c_tipcta => 'C',           
                                               p_n_codpai => ln_codpai,
                                               p_n_tipdoc => ln_tipdoc,
                                               p_c_numdoc => lc_numdoc,
                                               p_c_emails => lc_emails
                                               );         
             lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(ln_codpai,ln_tipdoc,lc_numdoc);                                                   
             lv_mensaje := 
                          '<tr>'||
                          ' <td width="15" height="23">'||ln_numtra||'.</td>'||
                          ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">'||trim(lv_contacto)||'</td>'||
                          '</tr>';                                          
             lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                      
             dbms_lob.writeappend(lb_deslob1, length(lv_mensaje), lv_mensaje);  
                                                                
             if ln_tipmai in (1,3) then --solo trabajador y ambos
                --Validamos si ya no se ha enviado el mail
                lv_estado := pq_ah_enviodigital.fn_ah_verifica_envio(p_c_tipver => 'C',--Cliente
                                                                     p_d_fecpro => P_D_FECPRO,
                                                                     p_n_pgcod  => k.pgcod,
                                                                     p_n_scmod  => k.scmod,
                                                                     p_n_scsuc  => k.scsuc,
                                                                     p_n_scmda  => k.scmda,
                                                                     p_n_scpap  => k.scpap,
                                                                     p_n_sccta  => k.sccta,
                                                                     p_n_scoper => k.scoper,
                                                                     p_n_scsbop => k.scsbop,
                                                                     p_n_sctope => k.sctope
                                                                     );                 
                 if lv_estado = 'N' then                                                    
                     --enviamos mail al trabajador
                     -- Call the procedure

                      if trim(lc_emails) is not null then                                 
                        pq_ah_enviodigital.sp_ah_envio_mail(p_n_codpai => ln_codpai,
                                                            p_n_tipdoc => ln_tipdoc,
                                                            p_c_numdoc => lc_numdoc,
                                                            p_c_emails => lc_emails,
                                                            p_c_adjunt => lv_adjuntos,
                                                            p_c_tipenv => 'C',
                                                            p_c_deslob => lb_deslob,
                                                            p_c_nomdir => lv_nomdir,
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_deserr => p_c_deserr
                                                            );   
                        ln_codenv := 1;                                                            
                      else
                        if trim(lc_maiemp) is not null then
                          ln_codenv := 4;
                        Else  
                          p_c_coderr := '00c';                                      
                          p_c_deserr := 'No existe cuenta de correo asociada';             
                        End If;          
                      end if;     
                                                                                                                      
                      if p_c_coderr = '000' then
                         lc_estado := 'S';    
                         p_c_deserr := 'Envío Satisfactorio';             
                      Else
                         lc_estado := 'N';
                         ln_codenv := 2;                         
                      End If; 
                      begin
                          -- Call the procedure
                          pq_ah_enviodigital.sp_ah_registra_envio_cli(p_n_pgcod  => k.pgcod,
                                                                      p_n_scmod  => k.scmod,
                                                                      p_n_scsuc  => k.scsuc,
                                                                      p_n_scmda  => k.scmda,
                                                                      p_n_scpap  => k.scpap,
                                                                      p_n_sccta  => k.sccta,
                                                                      p_n_scoper => k.scoper,
                                                                      p_n_scsbop => k.scsbop,
                                                                      p_n_sctope => k.sctope,
                                                                      p_n_ctaemp => j.cuentaemp,
                                                                      p_c_codest => lc_estado,
                                                                      p_c_codusu => P_C_CODUSU,
                                                                      p_c_desmot => p_c_deserr,
                                                                      p_c_deslob => lb_deslob,
                                                                      p_c_nomcon => lv_contrato,
                                                                      p_c_nomcar => lv_cartilla,
                                                                      p_d_fecpro => P_D_FECPRO,
                                                                      p_c_nomdir => trim(lv_nomdir),
                                                                      p_c_dirmai => trim(lc_emails),
                                                                      p_n_codenv => ln_codenv,
                                                                      p_c_coderr => p_c_coderr,
                                                                      p_c_deserr => p_c_deserr
                                                                      );
                      end;
                      --fin armado  
                 End If;                  
             End if; --fin envio por tipo de producto                                          
          End loop;  
          --fin listado empleados por cada empleador
          lv_adjuntos_all := lv_adjuntos_all || lv_contrato;                     
          --lv_adjuntos_all := substr(lv_adjuntos_all,1,length(lv_adjuntos_all)-1);
          
          if ln_tipmai in (2,3) then --solo empleador o ambos     
             --Validamos si ya no se ha enviado el mail
             lv_estado := pq_ah_enviodigital.fn_ah_verifica_envio(p_c_tipver => 'E',--Cliente
                                                                  p_d_fecpro => P_D_FECPRO,
                                                                  p_n_pgcod  => null,
                                                                  p_n_scmod  => null,
                                                                  p_n_scsuc  => null,
                                                                  p_n_scmda  => null,
                                                                  p_n_scpap  => null,
                                                                  p_n_sccta  => j.cuentaemp,
                                                                  p_n_scoper => null,
                                                                  p_n_scsbop => null,
                                                                  p_n_sctope => null
                                                                  );    
              if lv_estado = 'N' then                                                                                                                                                      
                  --enviamos mail al empleador
                  -- Call the procedure
                  if ln_numtra > 0 then      
                      if trim(lc_maiemp) is not null then                                                                                   
                        pq_ah_enviodigital.sp_ah_envio_mail(p_n_codpai => ln_paiemp,
                                                            p_n_tipdoc => ln_tipemp,
                                                            p_c_numdoc => lc_numemp,
                                                            p_c_emails => lc_maiemp,
                                                            p_c_adjunt => lv_adjuntos_all,
                                                            p_c_tipenv => 'E',
                                                            p_c_deslob => lb_deslob1,      
                                                            p_c_nomdir => lv_nomdir,                                        
                                                            p_c_coderr => p_c_coderr,
                                                            p_c_deserr => p_c_deserr
                                                            );        
                      else
                        p_c_coderr := '00e';                                      
                        p_c_deserr := 'No existe cuenta de correo asociada';             
                      end if;                                                 
                      if p_c_coderr = '000' then
                         lc_estado := 'S';        
                         p_c_deserr := 'Envío Satisfactorio';                      
                      Else
                         lc_estado := 'N';
                      End If;                                                                                     
                      begin
                        -- Call the procedure
                        pq_ah_enviodigital.sp_ah_registra_envio_emp(p_n_ctaemp => j.cuentaemp,
                                                                    p_c_codest => lc_estado,
                                                                    p_c_codusu => P_C_CODUSU,
                                                                    p_c_desmot => p_c_deserr,
                                                                    p_c_deslob => lb_deslob1,
                                                                    p_d_fecpro => P_D_FECPRO,
                                                                    p_c_dirmai => trim(lc_maiemp),
                                                                    p_c_coderr => p_c_coderr,
                                                                    p_c_deserr => p_c_deserr
                                                                   );
                      end;   
                  End if; 
              End if; 
          End If;--fin validación tipo de envio de mail 
          dbms_lob.freetemporary(lb_deslob1);    
        end loop;  
        --fin list empleadores
    End loop;
    --fin barrido de tipo prod    
  End sp_ah_envio_ape;    
  Procedure sp_ah_envio_mail(P_N_CODPAI IN NUMBER,          
                             P_N_TIPDOC IN NUMBER,
                             P_C_NUMDOC IN VARCHAR2,
                             P_C_EMAILS IN VARCHAR2,
                             P_C_ADJUNT IN VARCHAR2,
                             P_C_TIPENV IN VARCHAR2,
                             p_c_deslob in out clob,
                             p_c_nomdir out varchar2,
                             p_c_coderr out varchar2,
                             p_c_deserr out varchar2
                            ) is 
  cursor c_datos(ln_Tp1corr2 in number) is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 84
       and a.Tp1corr2 = ln_Tp1corr2
  order by a.tp1cod, 
           a.tp1cod1, 
           a.tp1corr1, 
           a.tp1corr2, 
           a.tp1corr3; 
                                   
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(30);  
  lv_asunto     VARCHAR2(90);  
  lv_directorio VARCHAR2(30);  
  lv_archivos   VARCHAR2(32767);  
  lv_contacto   VARCHAR2(110);  
  lv_destinos   VARCHAR2(32767):='';  
  ln_Tp1corr2   NUMBER(9);
  l_offset      NUMBER;
  l_ammount     NUMBER;
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    lv_destinos := P_C_EMAILS;
    lv_archivos := P_C_ADJUNT;
    
    if P_C_TIPENV = 'C' then
       ln_Tp1corr2 := 9;
    End If; 
    if P_C_TIPENV = 'E' then
       ln_Tp1corr2 := 10;
    End If;
            
    --Obtenemos datos para el envio
    For i in c_datos(ln_Tp1corr2) loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := lv_asunto || trim(i.tp1desc);
         When i.tp1nro1 = 3 then
           lv_directorio := trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
    p_c_nomdir := lv_directorio;
    lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(P_N_CODPAI,P_N_TIPDOC,P_C_NUMDOC);    
    Case
      When P_C_TIPENV = 'C' then        
        dbms_lob.createtemporary(ll_mensaje, TRUE);              
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)||'</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Te damos la más cordial bienvenida a Caja Arequipa, gracias por depositar tu confianza en nosotros abriendo tu cuenta CTS en nuestra institución.<br/>Para realizar retiros de tu cuenta (de cumplirse con los requisitos según normativa vigente), debes acercarte a cualquiera de nuestras agencias a nivel nacional y firmar la documentación del caso.</p>'||          
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Asimismo, en cumplimiento del DS. 001-97-TR Texto Unico Ordenado de la Ley de Compensación por Tiempo de Servicios, te adjuntamos, sin perjuicio de regularizar su firma:</p>';          
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
        lv_mensaje := '
                      <table width="1000" height="54" border="0">
                        <tbody>  
                          <tr>
                            <td width="15" height="23">1.</td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Contrato de depósitos y servicios complementarios</td>
                          </tr>                                  
                          <tr>
                            <td width="15" height="23">2.</td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Cartilla de Información de tu cuenta CTS.</td>
                          </tr>
                        </tbody>
                      </table>';   
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Recuerda que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto ganarás por tu dinero en el transcurso de un año.<br/>Para mayor información de tasas de interés, comisiones y gastos ingresa a www.cajaarequipa.pe o visita nuestra red de agencias a nivel nacional.</p>' ||          
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Jefe de Ahorros<br/>Caja Arequipa</strong></p>';                                          
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
        
      When P_C_TIPENV = 'E' then
        dbms_lob.createtemporary(ll_mensaje, TRUE);              
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados Sres. '||trim(lv_contacto)||'</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Les damos la más cordial bienvenida a Caja Arequipa, gracias por depositar la confianza de sus trabajadores en nuestra entidad abriendo su cuenta CTS.<br/>Le informamos que para que el trabajador pueda realizar retiros de su cuenta (de cumplirse con los requisitos según normativa vigente), debe acercarse a cualquiera de nuestras agencias a nivel nacional y firmar la documentación del caso.</p>'||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Asimismo, en cumplimiento del art. 28 del DS. 001-97-TR Texto Unico Ordenado de la Ley de Compensación por Tiempo de Servicios, le adjuntamos, <u>para su entrega a los trabajadores listados líneas abajo</u>:</p>';                        
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                      
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
        lv_mensaje := '
                      <table width="1000" height="54" border="0">
                        <tbody>  
                          <tr>
                            <td width="15" height="23">(i)</td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Contrato de depósitos y servicios complementarios, y</td>
                          </tr>                                  
                          <tr>
                            <td width="15" height="23">(ii)</td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Cartilla de Información de cuenta CTS.</td>
                          </tr>
                        </tbody>
                      </table>';   
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong><u>Relación de trabajadores</u></strong></p>';  
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                      
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                         
        lv_mensaje := '
                      <table width="1000" height="54" border="0">
                        <tbody> ';     
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
        
        --adicionamos el clob con el detalle de los trabajadores
            l_offset  := 1;
            l_ammount := 1900;                     
            while l_offset < dbms_lob.getlength(p_c_deslob) loop
              lv_mensaje := dbms_lob.substr(p_c_deslob, l_ammount, l_offset);
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);   
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
              l_offset  := l_offset + l_ammount;
              l_ammount := least(1900, dbms_lob.getlength(p_c_deslob) - l_ammount);
            end loop;          
        --fin de adicion del clob
                                                                                                                                            
        lv_mensaje := ' </tbody>'||         
                      '</table>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Agradecemos tener en cuenta y comunicar a sus trabajadores, que la TREA (Tasa de Rendimiento Efectiva Anual), es la tasa que te permitirá determinar cuánto se gana por el dinero depositado en el transcurso de un año.<br/>Para mayor información de tasas de interés, comisiones y gastos pueden ingresar a www.cajaarequipa.pe o visitar nuestra red de agencias a nivel nacional.</p>' ||          
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Jefe de Ahorros<br/>Caja Arequipa</strong></p>';                                          
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
        
      Else
        null;
      End Case;              
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
      p_c_deslob := ll_mensaje;
      dbms_lob.freetemporary(ll_mensaje);    
                                   
  end sp_ah_envio_mail;                                                      
  Procedure sp_ah_mail_cta(P_N_NUMCTA IN NUMBER,
                           P_C_TIPCTA IN VARCHAR2, --E='EMPLEADOR' C='CLIENTE'        
                           p_n_codpai out number,          
                           p_n_tipdoc out number,
                           p_c_numdoc out varchar2,
                           p_c_emails out varchar2
                          ) is  
  cursor c_mail_cli is
    Select trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1)) email,
           a.pepais,
           a.petdoc,
           a.pendoc
      from fsr008 a,
           fsx001 b
     where a.pgcod = 1
       and a.ctnro = P_N_NUMCTA
       and a.pepais = b.pepais
       and a.petdoc = b.petdoc
       and a.pendoc = b.pendoc
       and a.ttcod  = 1
       and a.cttfir = 'T'
       and b.txcod = 0
       and trim(b.pextxt) is not null
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S';                              
       
  cursor c_mail_emp is
    Select trim(b.jaqz172mai) email,
           a.pepais,
           a.petdoc,
           a.pendoc
      from fsr008 a,
           jaqz172 b
     where a.pgcod  = 1
       and a.ctnro  = P_N_NUMCTA
       and a.pepais = b.jaqz172pai
       and a.petdoc = b.jaqz172tpo
       and a.pendoc = b.jaqz172num
       and a.ttcod  = 1
       and a.cttfir = 'T'
       and trim(b.jaqz172mai) is not null
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(b.jaqz172mai)) = 'S'  
     union       
    Select trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1)) email,
           a.pepais,
           a.petdoc,
           a.pendoc
      from fsr008 a,
           fsx001 b
     where a.pgcod  = 1
       and a.ctnro  = P_N_NUMCTA
       and a.pepais = b.pepais
       and a.petdoc = b.petdoc
       and a.pendoc = b.pendoc
       and a.ttcod  = 1
       and a.cttfir = 'T'
       and b.txcod = 0
       and trim(b.pextxt) is not null
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S';          
  begin
    if P_C_TIPCTA = 'C' then
       For i in c_mail_cli loop
        p_c_emails := p_c_emails ||i.email||';' ;
        p_n_codpai := i.pepais; 
        p_n_tipdoc := i.petdoc;
        p_c_numdoc := i.pendoc;        
       end loop;
       p_c_emails := substr(p_c_emails,1,length(p_c_emails)-1);
    else
       For i in c_mail_emp loop
        p_c_emails := p_c_emails ||i.email||';' ;
        p_n_codpai := i.pepais; 
        p_n_tipdoc := i.petdoc;
        p_c_numdoc := i.pendoc;        
       end loop;
       p_c_emails := substr(p_c_emails,1,length(p_c_emails)-1);      
    end if; 
    if p_c_emails is null then
      begin
         Select a.pepais,
                a.petdoc,
                a.pendoc
           into p_n_codpai,
                p_n_tipdoc,
                p_c_numdoc         
           from fsr008 a
          where a.ctnro  = P_N_NUMCTA
            and a.ttcod  = 1
            and a.cttfir = 'T';         
      exception
      when others then  
           p_n_codpai := 0;
           p_n_tipdoc := 0;
           p_c_numdoc := null;         
      end;
    End If;    
  exception
  when others then  
    p_n_codpai := 0;
    p_n_tipdoc := 0;
    p_c_numdoc := null;
    p_c_emails := null;
  end sp_ah_mail_cta;    
  
  Function fn_ah_valida_mail(P_C_MAIL IN VARCHAR2) return varchar2 is
    lc_valida varchar2(1):='N';
  begin
      pq_cl_volcado_campana.sp_valida_mail(p_c_mail  => P_C_MAIL,
                                           p_c_error => lc_valida
                                           );
   return lc_valida;                                           
  Exception 
  when others then
      return 'N';    
  end fn_ah_valida_mail; 
  Function fn_ah_valida_celular(P_C_NUMTEL IN VARCHAR2,P_N_TIPCEL IN NUMBER) return varchar2 is
    lc_valida varchar2(1):='N';
  begin

    pq_cl_volcado_campana.sp_valida_telefono(p_c_numtel => P_C_NUMTEL,
                                             p_n_tipcel => P_N_TIPCEL,
                                             p_c_error  => lc_valida
                                             );                                           
   return lc_valida;                                           
  Exception 
  when others then
      return 'N';    
  end fn_ah_valida_celular;  
  Procedure sp_ah_registra_envio_cli(P_N_PGCOD  IN NUMBER,          
                                     P_N_SCMOD  IN NUMBER,
                                     P_N_SCSUC  IN NUMBER,
                                     P_N_SCMDA  IN NUMBER,
                                     P_N_SCPAP  IN NUMBER,
                                     P_N_SCCTA  IN NUMBER,
                                     P_N_SCOPER IN NUMBER,
                                     P_N_SCSBOP IN NUMBER,
                                     P_N_SCTOPE IN NUMBER,
                                     P_N_CTAEMP IN NUMBER,
                                     P_C_CODEST IN VARCHAR2,
                                     P_C_CODUSU IN VARCHAR2,
                                     P_C_DESMOT IN VARCHAR2,
                                     P_C_DESLOB IN CLOB,
                                     P_C_NOMCON IN VARCHAR2, --NOMBRE DEL CONTRATO
                                     P_C_NOMCAR IN VARCHAR2, --NOMBRE DE LA CARTILLA
                                     P_D_FECPRO IN DATE,    
                                     P_C_NOMDIR IN VARCHAR2, --DIRECTORIO
                                     P_C_DIRMAI IN VARCHAR2, --MAILS
                                     P_N_CODENV IN NUMBER,                                                       
                                     p_c_coderr out varchar2,
                                     p_c_deserr out varchar2
                                     ) is    
  l_bfile     BFILE;
  l_bfile1    BFILE;  
  l_blob      BLOB;                                     
  l_blob1     BLOB;
  ld_fecpro   date;
  lc_horpro   char(8);
  lc_usrpro   char(10);  
  lc_med      number(1):=0;
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    if P_C_CODEST = 'S' THEN
      insert into jaqz188 (jaqz188pgc, 
                           jaqz188mod, 
                           jaqz188suc, 
                           jaqz188mda, 
                           jaqz188pap, 
                           jaqz188cta, 
                           jaqz188ope, 
                           jaqz188sbo, 
                           jaqz188tpo, 
                           jaqz188cte, 
                           jaqz188fep, 
                           jaqz188hop, 
                           jaqz188usp, 
                           jaqz188fev, 
                           jaqz188hev, 
                           jaqz188uev, 
                           jaqz188med, 
                           jaqz188est, 
                           jaqz188mot, 
                           jaqz188cue, 
                           jaqz188cbl, 
                           jaqz188abl,
                           jaqz188mai
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
                           P_N_CTAEMP,
                           P_D_FECPRO,
                           to_char(sysdate,'HH24:mi:ss'),
                           P_C_CODUSU,
                           P_D_FECPRO,
                           to_char(sysdate,'HH24:mi:ss'),
                           P_C_CODUSU,
                           P_N_CODENV, --MAIL
                           P_C_CODEST,
                           P_C_DESMOT,
                           P_C_DESLOB,                         
                           EMPTY_BLOB(),
                           EMPTY_BLOB(),
                           P_C_DIRMAI          
                           )
                           RETURN jaqz188cbl, jaqz188abl INTO l_blob,l_blob1;
          l_bfile := BFILENAME(P_C_NOMDIR, P_C_NOMCON);
          DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
          DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
          DBMS_LOB.fileclose(l_bfile);
          
          l_bfile1 := BFILENAME(P_C_NOMDIR, P_C_NOMCAR);
          DBMS_LOB.fileopen(l_bfile1, Dbms_Lob.File_Readonly);
          DBMS_LOB.loadfromfile(l_blob1,l_bfile1,DBMS_LOB.getlength(l_bfile1));
          DBMS_LOB.fileclose(l_bfile1);        
        Else
          insert into jaqz188 (jaqz188pgc, 
                               jaqz188mod, 
                               jaqz188suc, 
                               jaqz188mda, 
                               jaqz188pap, 
                               jaqz188cta, 
                               jaqz188ope, 
                               jaqz188sbo, 
                               jaqz188tpo, 
                               jaqz188cte, 
                               jaqz188fep, 
                               jaqz188hop, 
                               jaqz188usp, 
                               jaqz188fev, 
                               jaqz188hev, 
                               jaqz188uev, 
                               jaqz188med, 
                               jaqz188est, 
                               jaqz188mot,
                               jaqz188mai
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
                               P_N_CTAEMP,
                               P_D_FECPRO,
                               to_char(sysdate,'HH24:mi:ss'),
                               P_C_CODUSU,
                               P_D_FECPRO,
                               Null,
                               Null,
                               P_N_CODENV, --NO ENVIO
                               P_C_CODEST,
                               P_C_DESMOT,
                               P_C_DIRMAI          
                               );           
        END IF; 
        COMMIT;
  exception
  when dup_val_on_index then        
        if P_C_CODEST = 'S' then    
          begin                
              Select jaqz188fep, 
                     jaqz188hop, 
                     jaqz188usp,
                     jaqz188med
                into ld_fecpro,
                     lc_horpro,
                     lc_usrpro,
                     lc_med
                from jaqz188                
               where jaqz188pgc = P_N_PGCOD
                 and jaqz188mod = P_N_SCMOD
                 and jaqz188suc = P_N_SCSUC
                 and jaqz188mda = P_N_SCMDA
                 and jaqz188pap = P_N_SCPAP
                 and jaqz188cta = P_N_SCCTA
                 and jaqz188ope = P_N_SCOPER
                 and jaqz188sbo = P_N_SCSBOP
                 and jaqz188tpo = P_N_SCTOPE;
                 
               if lc_med <> 3 then --si no fue regularizado
                   delete from jaqz188
                    where jaqz188pgc = P_N_PGCOD
                      and jaqz188mod = P_N_SCMOD
                      and jaqz188suc = P_N_SCSUC
                      and jaqz188mda = P_N_SCMDA
                      and jaqz188pap = P_N_SCPAP
                      and jaqz188cta = P_N_SCCTA
                      and jaqz188ope = P_N_SCOPER
                      and jaqz188sbo = P_N_SCSBOP
                      and jaqz188tpo = P_N_SCTOPE;
                   
                      insert into jaqz188 (jaqz188pgc, 
                                           jaqz188mod, 
                                           jaqz188suc, 
                                           jaqz188mda, 
                                           jaqz188pap, 
                                           jaqz188cta, 
                                           jaqz188ope, 
                                           jaqz188sbo, 
                                           jaqz188tpo, 
                                           jaqz188cte, 
                                           jaqz188fep, 
                                           jaqz188hop, 
                                           jaqz188usp, 
                                           jaqz188fev, 
                                           jaqz188hev, 
                                           jaqz188uev, 
                                           jaqz188med, 
                                           jaqz188est, 
                                           jaqz188mot, 
                                           jaqz188cue, 
                                           jaqz188cbl, 
                                           jaqz188abl,
                                           jaqz188mai
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
                                           P_N_CTAEMP,
                                           ld_fecpro,
                                           lc_horpro,
                                           lc_usrpro, 
                                           P_D_FECPRO,                                  
                                           to_char(sysdate,'HH24:mi:ss'),
                                           P_C_CODUSU,
                                           P_N_CODENV, --MAIL
                                           P_C_CODEST,
                                           P_C_DESMOT,
                                           P_C_DESLOB,                         
                                           EMPTY_BLOB(),
                                           EMPTY_BLOB(),
                                           P_C_DIRMAI          
                                           )
                                           RETURN jaqz188cbl, jaqz188abl INTO l_blob,l_blob1;
                                           
                          l_bfile := BFILENAME(P_C_NOMDIR, P_C_NOMCON);
                          DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                          DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                          DBMS_LOB.fileclose(l_bfile);
                          
                          l_bfile1 := BFILENAME(P_C_NOMDIR, P_C_NOMCAR);
                          DBMS_LOB.fileopen(l_bfile1, Dbms_Lob.File_Readonly);
                          DBMS_LOB.loadfromfile(l_blob1,l_bfile1,DBMS_LOB.getlength(l_bfile1));
                          DBMS_LOB.fileclose(l_bfile1);       
               end if;                              
           exception
           when others then  
             p_c_coderr := '0x3';
             p_c_deserr := sqlerrm;                
           end;            
        else
           Update jaqz188 
              set jaqz188fev = P_D_FECPRO, 
                  jaqz188hev = to_char(sysdate,'HH24:mi:ss'),
                  jaqz188uev = P_C_CODUSU,
                  jaqz188est = P_C_CODEST,
                  jaqz188mot = P_C_DESMOT,          
                  jaqz188mai = P_C_DIRMAI,   
                  jaqz188cte = P_N_CTAEMP,
                  jaqz188med = P_N_CODENV --NO ENVIO 
            where jaqz188pgc = P_N_PGCOD  
              and jaqz188mod = P_N_SCMOD  
              and jaqz188suc = P_N_SCSUC  
              and jaqz188mda = P_N_SCMDA  
              and jaqz188pap = P_N_SCPAP  
              and jaqz188cta = P_N_SCCTA  
              and jaqz188ope = P_N_SCOPER 
              and jaqz188sbo = P_N_SCSBOP 
              and jaqz188tpo = P_N_SCTOPE;                     
        End If; 
        commit;   
  when others then
     p_c_coderr := '001';
     p_c_deserr := sqlerrm;                       
  end sp_ah_registra_envio_cli;                                             
  Procedure sp_ah_registra_envio_emp(P_N_CTAEMP IN NUMBER,
                                     P_C_CODEST IN VARCHAR2,
                                     P_C_CODUSU IN VARCHAR2,
                                     P_C_DESMOT IN VARCHAR2,
                                     P_C_DESLOB IN CLOB,
                                     P_D_FECPRO IN DATE,
                                     P_C_DIRMAI IN VARCHAR2, --MAILS
                                     p_c_coderr out varchar2,
                                     p_c_deserr out varchar2                                 
                                     ) is
  begin
    p_c_coderr := '000'; 
    p_c_deserr := '';
    
    insert into jaqz188a(jaqz188afep,
                         jaqz188acte,
                         jaqz188ahop,
                         jaqz188ausp,
                         jaqz188aest,
                         jaqz188amot,
                         jaqz188acue,
                         jaqz188amai
                         )
                   values(P_D_FECPRO,
                          P_N_CTAEMP,
                          to_char(sysdate,'HH24:mi:ss'), 
                          P_C_CODUSU,
                          P_C_CODEST,
                          P_C_DESMOT,
                          P_C_DESLOB,
                          P_C_DIRMAI                          
                          );
                          commit;
  exception
  when dup_val_on_index then
    update jaqz188a a
       set a.jaqz188ahop = to_char(sysdate,'HH24:mi:ss'),
           a.jaqz188ausp = P_C_CODUSU,
           a.jaqz188aest = P_C_CODEST,
           a.jaqz188amot = P_C_DESMOT,
           a.jaqz188acue = P_C_DESLOB,
           a.jaqz188amai = P_C_DIRMAI
     where a.jaqz188afep = P_D_FECPRO
       and a.jaqz188acte = P_N_CTAEMP;
       commit;
  when others then                        
     p_c_coderr := '001';
     p_c_deserr := sqlerrm;        
  end sp_ah_registra_envio_emp;                                       
  Function fn_ah_nombre_per(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2              
                           ) return varchar2 is
  lv_contacto varchar2(110);
  begin    
    Select trim(a.pfnom1)||' '/*||trim(a.pfnom2)||' '*/||trim(a.pfape1)||' '||trim(a.pfape2)
      into lv_contacto 
      from fsd002 a 
     where a.pfpais = P_N_CODPAI
       and a.pftdoc = P_N_TIPDOC
       and a.pfndoc = rpad(P_C_NUMDOC,12,' ');
       return lv_contacto;                                       
  Exception 
  When no_data_found then
    begin    
      Select trim(a.pjrazs)
        into lv_contacto 
        from fsd003 a 
       where a.pjpais = P_N_CODPAI
         and a.pjtdoc = P_N_TIPDOC
         and a.pjndoc = rpad(P_C_NUMDOC,12,' ');
         return lv_contacto;                                       
    Exception 
    When others then
       return lv_contacto;
    end;   
  when others then
      return lv_contacto;
  end fn_ah_nombre_per;   
  Procedure sp_ah_envio_mail_jpla(P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2,           
                                  P_N_SUCINI IN NUMBER,
                                  P_N_SUCFIN IN NUMBER,
                                  p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2                                      
                                  ) is    
    cursor c_datos is              
      select a.* 
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 84
         and a.Tp1corr2 = 11
    order by a.tp1cod, 
             a.tp1cod1, 
             a.tp1corr1, 
             a.tp1corr2, 
             a.tp1corr3; 
                  
      cursor c_sucursal is
        Select * 
          from fst001 a 
         where a.pgcod = 1 
           and a.sucurs >= P_N_SUCINI
           and a.sucurs <= P_N_SUCFIN
           and a.sucurs < 400; 
               
      cursor c_no_envios_cli(ld_fecpro in date, ln_sucurs in number) is
        Select x.*, 
               z.ctnom, 
               w.pepais, 
               w.petdoc, 
               w.pendoc 
          from jaqz188  x, 
               jaqz188a y,
               fsd008   z,
               fsr008   w
         where x.jaqz188fev  = y.jaqz188afep
           and x.jaqz188cte  = y.jaqz188acte
           and x.jaqz188est  = y.jaqz188aest
           and z.pgcod       = w.pgcod
           and w.ctnro       = x.jaqz188cta         
           and y.jaqz188acte = z.ctnro 
           and x.jaqz188fev  = ld_fecpro
           and x.jaqz188suc  = ln_sucurs
           and y.jaqz188aest = 'N'
           and w.pgcod       = 1  
           and w.ttcod       = 1
           and w.cttfir      = 'T'       
           and x.jaqz188mai  is null --NO EXISTE CUENTA DE CORREO
           and x.jaqz188med  = 2; --NO ENVIO
           
  ld_fecpro     DATE;
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(30);  
  lv_asunto     VARCHAR2(90);  
  lv_directorio VARCHAR2(30);  
  lv_archivos   VARCHAR2(32767);  
  lv_contacto   VARCHAR2(110);  
  lc_usrori     char(10):= null;
  lc_usrsup     char(10):= null;  
  ln_numtra     number(9):=0;
  lc_estado     char(1):='N';
  lv_destinos   VARCHAR2(32767):= '';  
  lv_estado     VARCHAR2(1):= 'N';  
  begin
  p_c_coderr := '000';
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := lv_asunto || trim(i.tp1desc);
         When i.tp1nro1 = 3 then
           lv_directorio := trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
        
    ld_fecpro := P_D_FECPRO;    
    --Barremos las sducursales y verificamos las aperturas no notificadas    
    For i in c_sucursal loop
      --Validamos si ya no se ha enviado el mail
      lv_estado := pq_ah_enviodigital.fn_ah_verifica_envio(p_c_tipver => 'J',--Cliente
                                                           p_d_fecpro => ld_fecpro,
                                                           p_n_pgcod  => null,
                                                           p_n_scmod  => null,
                                                           p_n_scsuc  => null,
                                                           p_n_scmda  => null,
                                                           p_n_scpap  => null,
                                                           p_n_sccta  => i.sucurs,
                                                           p_n_scoper => null,
                                                           p_n_scsbop => null,
                                                           p_n_sctope => null
                                                          );    
      if lv_estado = 'N' then                  
          p_c_coderr := '000';
          dbms_lob.createtemporary(ll_mensaje, TRUE);              
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Jefe de Plataforma:</p>' ||  
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Se informa sobre la apertura de cuentas CTS que no se logró notificar por vía electrónica.</p>';
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);        
          lv_mensaje := '<table width="1000" height="54" border="0">'||
                        '  <tbody> ';     
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
          --obtenemos todos los empleadores      
          ln_numtra  := 0;
          For j in c_no_envios_cli(ld_fecpro,i.sucurs) loop     
             lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(j.pepais,j.petdoc,j.pendoc);         
             ln_numtra := ln_numtra + 1;
             lv_mensaje := 
                          '<tr>'||
                          ' <td width="15" height="23">'||ln_numtra||'.</td>'||
                          ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Nombre cliente:'||trim(lv_contacto)||'</td>'||
                          '</tr>';                                          
             lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                      
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
             lv_mensaje := 
                          '<tr>'||
                          ' <td width="15" height="23"></td>'||
                          ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Cuenta cliente:'||j.jaqz188cta||'</td>'||
                          '</tr>'||
                          '<tr>'||
                          ' <td width="15" height="23"></td>'||
                          ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Fecha Apertura:'||trim(to_char(j.jaqz188fep,'dd/mm/rrrr'))||'</td>'||
                          '</tr>'||
                          '<tr>'||
                          ' <td width="15" height="23"></td>'||
                          ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">Empleador:'||trim(j.ctnom)||'</td>'||
                          '</tr>';                                          
             lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                      
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                 
          end loop;                                                                                                                                               
          lv_mensaje := ' </tbody>'||         
                        '</table>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Puede generar reporte del sistema en Bantotal.</p>' ||          
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales,<br/>Caja Arequipa</strong></p>';                                          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
          if ln_numtra > 0 then
              --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
              begin                                             
                Select b.sng057usr, b.sng057sup
                  into lc_usrori, 
                       lc_usrsup
                  from fst046 a, 
                       sng057 b 
                 where a.pgcod     = b.sng055emp
                   and a.ubuser    = b.sng057usr
                   and a.ubsuc     =  i.sucurs
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
                           and c.ubsuc     =  i.sucurs
                           and d.sng055car = 50
                       )
                   and rownum < 2;                           
              exception
              when others then       
                lc_usrori := '';
                lc_usrsup := '';
              end;  
                     
              if trim(lc_usrori) is not null then        
                --Enviamos el correo
                CASE
                WHEN trim(lc_usrsup) is not null THEN
                  lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe'||';'||lower(trim(lc_usrsup))||'@cajaarequipa.pe';
                ELSE
                  lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe';
                END CASE;       
                
                begin
                  -- Call the procedure
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lower(trim(lc_usrori))||'@cajaarequipa.pe',
                                                   p_destinatarioscc   => CASE
                                                                            WHEN trim(lc_usrsup) is not null THEN
                                                                              lower(trim(lc_usrsup))||'@cajaarequipa.pe'
                                                                            ELSE
                                                                              ''
                                                                            END,
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
              else
                p_c_coderr := '00c';                                      
                p_c_deserr := 'No existe usuario Jefe de plataforma para la sucursal';           
                lv_destinos := null;
              end if;
              
              if p_c_coderr = '000' then
                 lc_estado := 'S';    
                 p_c_deserr := 'Envío Satisfactorio';             
              Else
                 lc_estado := 'N';
              End If;   
              --registramos log de envios a jefes de plataforma.    
              begin
                -- Call the procedure
                pq_ah_enviodigital.sp_ah_registra_envio_jepla(p_n_codsuc => i.sucurs,
                                                              p_c_codest => lc_estado,
                                                              p_c_codusu => P_C_CODUSU,
                                                              p_c_desmot => p_c_deserr,
                                                              p_c_deslob => ll_mensaje,
                                                              p_d_fecpro => ld_fecpro,
                                                              p_c_dirmai => lv_destinos,
                                                              p_c_coderr => p_c_coderr,
                                                              p_c_deserr => p_c_deserr
                                                             );
              end;       
          end if;  
          dbms_lob.freetemporary(ll_mensaje);   
      End If;       
    end loop;  
  exception
    when others then
    p_c_coderr := '00v';       
    p_c_deserr := sqlerrm;
  end sp_ah_envio_mail_jpla;  
  Procedure sp_ah_registra_envio_jepla(P_N_CODSUC IN NUMBER,
                                       P_C_CODEST IN VARCHAR2,
                                       P_C_CODUSU IN VARCHAR2,
                                       P_C_DESMOT IN VARCHAR2,
                                       P_C_DESLOB IN CLOB,
                                       P_D_FECPRO IN DATE,
                                       P_C_DIRMAI IN VARCHAR2, --MAILS
                                       p_c_coderr out varchar2,
                                       p_c_deserr out varchar2                                 
                                       ) is
  begin
    p_c_coderr := '000'; 
    p_c_deserr := '';
    
    insert into jaqz188b(jaqz188bfep,
                         jaqz188bsuc,
                         jaqz188bhop,
                         jaqz188busp,
                         jaqz188best,
                         jaqz188bmot,
                         jaqz188bcue,
                         jaqz188bmai
                         )
                   values(P_D_FECPRO,
                          P_N_CODSUC,
                          to_char(sysdate,'HH24:mi:ss'), 
                          P_C_CODUSU,
                          P_C_CODEST,
                          P_C_DESMOT,
                          P_C_DESLOB,
                          P_C_DIRMAI                          
                          );
                          commit;
  exception
  when dup_val_on_index then
    update jaqz188b a
       set a.jaqz188bhop = to_char(sysdate,'HH24:mi:ss'),
           a.jaqz188busp = P_C_CODUSU,
           a.jaqz188best = P_C_CODEST,
           a.jaqz188bmot = P_C_DESMOT,
           a.jaqz188bcue = P_C_DESLOB,
           a.jaqz188bmai = P_C_DIRMAI
     where a.jaqz188bfep = P_D_FECPRO
       and a.jaqz188bsuc = P_N_CODSUC;
       commit;
  when others then                        
     p_c_coderr := '001';
     p_c_deserr := sqlerrm;        
  end sp_ah_registra_envio_jepla;  
  Function fn_ah_verifica_envio(P_C_TIPVER IN VARCHAR2,
                                P_D_FECPRO IN DATE,
                                P_N_PGCOD  IN NUMBER,
                                P_N_SCMOD  IN NUMBER,
                                P_N_SCSUC  IN NUMBER,
                                P_N_SCMDA  IN NUMBER,
                                P_N_SCPAP  IN NUMBER,
                                P_N_SCCTA  IN NUMBER,
                                P_N_SCOPER IN NUMBER,
                                P_N_SCSBOP IN NUMBER,
                                P_N_SCTOPE IN NUMBER                            
                               ) return varchar2 is  
  lv_estado varchar2(1):= 'N';                               
  begin          
    Case                     
      When P_C_TIPVER = 'C' then --Cliente
        begin
           Select jaqz188est
             into lv_estado 
             from jaqz188 a
            where a.jaqz188pgc = P_N_PGCOD  
              and a.jaqz188mod = P_N_SCMOD  
              and a.jaqz188suc = P_N_SCSUC  
              and a.jaqz188mda = P_N_SCMDA  
              and a.jaqz188pap = P_N_SCPAP  
              and a.jaqz188cta = P_N_SCCTA  
              and a.jaqz188ope = P_N_SCOPER 
              and a.jaqz188sbo = P_N_SCSBOP 
              and a.jaqz188tpo = P_N_SCTOPE;              
        exception
        when others then
          lv_estado := 'N';
        end;
      When P_C_TIPVER = 'E' then --Empleador
        begin
          Select a.jaqz188aest 
            into lv_estado 
            from jaqz188a a
           where a.jaqz188afep = P_D_FECPRO
             and a.jaqz188acte = P_N_SCCTA;       
        exception
        when others then
          lv_estado := 'N';
        end;        
      When P_C_TIPVER = 'J' then --Jefe de plataforma
        begin
          Select a.jaqz188best a
            into lv_estado    
            from jaqz188b a          
           where a.jaqz188bfep = P_D_FECPRO
             and a.jaqz188bsuc = P_N_SCSUC;
        exception
        when others then
          lv_estado := 'N';
        end;          
      Else
          lv_estado := 'N';
    End Case; 
    return lv_estado;
  exception
  when others then
    lv_estado := 'N';
    return lv_estado;     
  End fn_ah_verifica_envio;                           
  Procedure sp_ah_registra_envio(P_N_PGCOD  IN NUMBER,          
                                 P_N_SCMOD  IN NUMBER,
                                 P_N_SCSUC  IN NUMBER,
                                 P_N_SCMDA  IN NUMBER,
                                 P_N_SCPAP  IN NUMBER,
                                 P_N_SCCTA  IN NUMBER,
                                 P_N_SCOPER IN NUMBER,
                                 P_N_SCSBOP IN NUMBER,
                                 P_N_SCTOPE IN NUMBER,
                                 P_N_CTAEMP IN NUMBER,
                                 P_C_CODUSU IN VARCHAR2,
                                 P_C_DESMOT IN VARCHAR2,
                                 P_D_FECPRO IN DATE,    
                                 P_N_CODMED IN NUMBER,
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2
                                 ) is    
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
      insert into jaqz188 (jaqz188pgc, 
                           jaqz188mod, 
                           jaqz188suc, 
                           jaqz188mda, 
                           jaqz188pap, 
                           jaqz188cta, 
                           jaqz188ope, 
                           jaqz188sbo, 
                           jaqz188tpo, 
                           jaqz188cte, 
                           jaqz188fep, 
                           jaqz188hop, 
                           jaqz188usp, 
                           jaqz188fev, 
                           jaqz188hev, 
                           jaqz188uev, 
                           jaqz188frg, 
                           jaqz188hrg, 
                           jaqz188urg,                            
                           jaqz188med, 
                           jaqz188est,
                           jaqz188mot
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
                           P_N_CTAEMP,
                           P_D_FECPRO,
                           to_char(sysdate,'HH24:mi:ss'),
                           P_C_CODUSU,
                           null,
                           null,
                           null,
                           P_D_FECPRO,
                           to_char(sysdate,'HH24:mi:ss'),
                           P_C_CODUSU,
                           P_N_CODMED, --MAIL
                           'S',
                           P_C_DESMOT
                           );                           
  exception
  when dup_val_on_index then        
           Update jaqz188 
              set /*jaqz188fev = P_D_FECPRO, 
                  jaqz188hev = to_char(sysdate,'HH24:mi:ss'), 
                  jaqz188uev = P_C_CODUSU,*/
                  jaqz188frg = P_D_FECPRO, 
                  jaqz188hrg = to_char(sysdate,'HH24:mi:ss'), 
                  jaqz188urg = P_C_CODUSU,                                    
                  jaqz188est = 'S',
                  jaqz188ax9 = P_C_DESMOT,  
                  jaqz188cte = P_N_CTAEMP,
                  jaqz188ax1 = P_N_CODMED             
            where jaqz188pgc = P_N_PGCOD  
              and jaqz188mod = P_N_SCMOD  
              and jaqz188suc = P_N_SCSUC  
              and jaqz188mda = P_N_SCMDA  
              and jaqz188pap = P_N_SCPAP  
              and jaqz188cta = P_N_SCCTA  
              and jaqz188ope = P_N_SCOPER 
              and jaqz188sbo = P_N_SCSBOP 
              and jaqz188tpo = P_N_SCTOPE;    
  when others then
     p_c_coderr := '001';
     p_c_deserr := sqlerrm;                       
  end sp_ah_registra_envio;
  Procedure sp_ah_envio_ape_afp(P_D_FECPRO IN DATE,
                                P_C_CODUSU IN VARCHAR2,              
                                P_C_MAIL   IN VARCHAR2,    
                                P_N_PGCOD  IN NUMBER,   
                                P_N_SCMOD  IN NUMBER,
                                P_N_SCSUC  IN NUMBER,
                                P_N_SCMDA  IN NUMBER,
                                P_N_SCPAP  IN NUMBER,
                                P_N_SCCTA  IN NUMBER,
                                P_N_SCOPER IN NUMBER,
                                P_N_SCSBOP IN NUMBER,
                                P_N_SCTOPE IN NUMBER,                                                                  
                                p_c_coderr out VARCHAR2,
                                p_c_deserr out VARCHAR2         
                               ) is  
                              
  lv_cadena       varchar2(20);
  lv_archivos     varchar2(100); 
  lv_destinos     varchar2(100); 
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100); 
  lv_nomcon       varchar2(100); 
  lv_nomcar       varchar2(100); 
  lv_estado       CHAR(1);
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  
  l_bfile         BFILE;
  l_bfile1        BFILE;  
  l_blob          BLOB;                                     
  l_blob1         BLOB;                             
  begin
    lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';
    lv_remitente := 'procesosbantotal@cajaarequipa.pe';
    lv_asunto    := 'Bienvenido a Caja Arequipa';
    lv_destinos  := trim(P_C_MAIL);
    lv_cadena    := lpad(P_N_SCCTA,9,0)||lpad(P_N_SCMOD,3,0)||lpad(P_N_SCMDA,3,0)||lpad(P_N_SCSBOP,2,0)||lpad(P_N_SCTOPE,3,0);
    lv_nomcon    := 'T'||lv_cadena||'.pdf';
    lv_nomcar    := 'C'||lv_cadena||'.pdf';
    lv_archivos  := lv_nomcon||';'||lv_nomcar;
    -- ARMADO DEL CUERPO
    
    dbms_lob.createtemporary(ll_mensaje, TRUE);              
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Cliente:</p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Reciba la más cordial bienvenida a la familia de Caja Arequipa.</p>'||          
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Sobre la base de la solicitud recibida por la Asociación de Administradoras de Fondo de Pensiones y pueda recibir los fondos liberados provenientes de sus aportes a la AFP, amparados en el DU Nro.056-2020, hemos abierto una Cuenta de Ahorros a su nombre, la cual recomendamos mantenerla activa por un periodo mínimo no menor a 190 días o hasta cuando haya recibido la totalidad de sus abonos.</p>'||                                                                          
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Cabe precisar que dichos fondos; tal como indica la Ley vigente, tienen el carácter de intangibles.</p>'||                     
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Formatos Contractuales</strong></p>'||                                       
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Se adjunta los siguientes con los cuales se formaliza la contratación no presencial:</p>';                                                                                            
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
    lv_mensaje := '
                  <table width="1200" height="54" border="0">
                    <tbody>                      
                      <tr>
                        <td width="15" height="23">1.</td>
                        <td width="900" "font-family: Arial, sans-serif; font-size: 14px;">Contrato de Depósitos y Servicios Complementarios y</td>
                      </tr>                                  
                      <tr>
                        <td width="15" height="23">2.</td>
                        <td width="900" "font-family: Arial, sans-serif; font-size: 14px;">Cartilla de Información.</td>
                      </tr>
                    </tbody>
                  </table>';   
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Tarjeta de Débito</strong></p>';
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
    lv_mensaje := '
                  <table width="1200" height="54" border="0">
                    <tbody>                      
                      <tr>
                        <td width="15" height="23">a.</td>
                        <td width="900" "font-family: Arial, sans-serif; font-size: 14px;">De tener un producto de ahorros vigente contratado con Caja Arequipa, se afiliará esta nueva cuenta a su Tarjeta de Débito.</td>                 
                      </tr>                                  
                      <tr>
                        <td width="15" height="23">b.</td>
                        <td width="900" "font-family: Arial, sans-serif; font-size: 14px;">De ser su primera cuenta con Caja Arequipa lo invitamos a acercarse a cualquiera de nuestras agencias a nivel nacional y recoger su Tarjeta de Débito totalmente gratuita.</td>
                      </tr>
                    </tbody>
                  </table>';      
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                    
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Agradecemos tu preferencia.</p>'||       
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Atentamente</p>'||                                                                    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Jefe de Productos Pasivos<br/>Caja Arequipa</strong></p>';                                          
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);        
      --ENVIO MAIL
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
      if p_c_coderr = '000' then
         lv_estado := 'S';
         p_c_deserr := 'ENVIO SATISFACTORIO';
      Else
         lv_estado := 'N';
      End If;
      begin
        insert into aqpa118b(aqpa118bpgc,
                             aqpa118bmod,
                             aqpa118bsuc,
                             aqpa118bmda,
                             aqpa118bpap,
                             aqpa118bcta,
                             aqpa118bope,
                             aqpa118bsbo,
                             aqpa118btop,
                             aqpa118bcon,
                             aqpa118bcar,
                             aqpa118bcue,
                             aqpa118best,
                             aqpa118bmai,
                             aqpa118busr,
                             aqpa118bfec,
                             aqpa118bhor,
                             aqpa118bmot
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
                             EMPTY_BLOB(),
                             EMPTY_BLOB(), 
                             ll_mensaje,
                             lv_estado,
                             lv_destinos, 
                             P_C_CODUSU,                          
                             P_D_FECPRO,
                             to_char(sysdate,'HH24:mi:ss'),
                             p_c_deserr                                     
                             )
                             RETURN aqpa118bcon, aqpa118bcar INTO l_blob,l_blob1;
            l_bfile := BFILENAME(lv_directorio, lv_nomcon);
            DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
            DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
            DBMS_LOB.fileclose(l_bfile);
            
            l_bfile1 := BFILENAME(lv_directorio, lv_nomcar);
            DBMS_LOB.fileopen(l_bfile1, Dbms_Lob.File_Readonly);
            DBMS_LOB.loadfromfile(l_blob1,l_bfile1,DBMS_LOB.getlength(l_bfile1));
            DBMS_LOB.fileclose(l_bfile1);  
            commit;          
      exception 
      when others then
        begin
          insert into aqpa118b(aqpa118bpgc,
                               aqpa118bmod,
                               aqpa118bsuc,
                               aqpa118bmda,
                               aqpa118bpap,
                               aqpa118bcta,
                               aqpa118bope,
                               aqpa118bsbo,
                               aqpa118btop,
                               aqpa118bcue,
                               aqpa118best,
                               aqpa118bmai,
                               aqpa118busr,
                               aqpa118bfec,
                               aqpa118bhor,
                               aqpa118bmot
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
                               ll_mensaje,
                               lv_estado,
                               lv_destinos, 
                               P_C_CODUSU,                          
                               P_D_FECPRO,
                               to_char(sysdate,'HH24:mi:ss'),
                               p_c_deserr                                     
                               );  
                               commit;                                     
        exception 
        when others then
           p_c_coderr := '00y';
           p_c_deserr := sqlerrm;      
        end;
      end;
      dbms_lob.freetemporary(ll_mensaje);  
  exception
  when others then      
    p_c_coderr := '00x';
    p_c_deserr := sqlerrm;          
  end sp_ah_envio_ape_afp;      
  Procedure sp_ah_notifica_cancel(P_D_FECPRO IN DATE,
                                  P_N_PGCOD  IN NUMBER,  
                                  P_N_SCMOD  IN NUMBER,
                                  P_N_SCSUC  IN NUMBER,
                                  P_N_SCMDA  IN NUMBER,
                                  P_N_SCPAP  IN NUMBER,
                                  P_N_SCCTA  IN NUMBER,
                                  P_N_SCOPER IN NUMBER,
                                  P_N_SCSBOP IN NUMBER,
                                  P_N_SCTOPE IN NUMBER,
                                  P_N_CODCON IN NUMBER,
                                  P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER,
                                  P_C_NUMDOC IN VARCHAR2,
                                  p_c_indnot in out varchar2,
                                  p_c_coderr out varchar2,
                                  p_c_msgerr out varchar2
                                  ) is
                         
  CURSOR c_mail is
    Select distinct trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1)) mail
      from fsx001 b
     where b.pepais = P_N_CODPAI
       and b.petdoc = P_N_TIPDOC
       and b.pendoc = rpad(P_C_NUMDOC,12,' ')
       and b.txcod = 0
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S';
       
  CURSOR c_celular is
    Select distinct trim(a.dotelfp) celular
      from fsr005 a 
     where a.pepais = P_N_CODPAI 
       and a.petdoc = P_N_TIPDOC
       and a.pendoc = rpad(P_C_NUMDOC,12,' ')
       and pq_ah_enviodigital.fn_ah_valida_celular(trim(a.dotelfp),1) = 'S';      

  ln_cont         number(9):=0;
  lv_destinos     varchar2(400):= '';     
  lv_archivo      varchar2(21) := '';  
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100); 
  lv_estado       CHAR(1);
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  
  l_bfile         BFILE;
  l_blob          BLOB;                                         
  lv_concatenado  varchar2(27):='';
  lv_nombre       varchar2(130):=''; 
  lv_tipper       char(1):='';                             
  begin     
    p_c_coderr := '000';
    pq_ah_new_comision.sp_ah_tipper(p_n_codpgc => P_N_PGCOD,
                                    p_n_numcta => P_N_SCCTA,
                                    p_c_codval => lv_tipper
                                    );
    if lv_tipper = 'F' then                               
      if P_N_CODCON = 1 then --CONSULTA
         ln_cont :=0;
         lv_destinos := '';
         p_c_indnot := 'F';                
         for j in c_mail loop
           ln_cont := ln_cont + 1;
           lv_destinos := lv_destinos || j.mail||';';
         end loop;
         if ln_cont > 0 then
            p_c_indnot := 'M';
         else
           For i in c_celular loop
             p_c_indnot := 'S';  
             exit;
           End loop;
         End If;
      End if;
    End If; 
    if lv_tipper = 'J' then  
      if P_N_CODCON = 1 then --CONSULTA
         ln_cont :=0;
         lv_destinos := '';     
         p_c_indnot := 'F';                       
         for j in c_mail loop
           ln_cont := ln_cont + 1;
           lv_destinos := lv_destinos || j.mail||';';
         end loop;
         if ln_cont > 0 then
            p_c_indnot := 'M';
         End If;
      End if;      
    End If;            
                                   
    if P_N_CODCON = 2 then --ENVIO Y REGISTRO
      lv_destinos := '';
      if p_c_indnot = 'M' then
         p_c_indnot := 'X';--NO CANCELAR CUENTA
         
         --OBTENEMOS NOMBRE DEL CLIENTE
         begin
           Select a.petipo 
             into lv_tipper
             from fsd001 a 
            where a.pepais = P_N_CODPAI
              and a.petdoc = P_N_TIPDOC
              and a.pendoc = rpad(P_C_NUMDOC,12,' ');
         exception
         when others then
           lv_tipper := '';
         end;
         if lv_tipper = 'F' then
           begin
             Select trim(a.PFNOM1)||' '||trim(a.PFAPE1)
               into lv_nombre
               from fsd002 a 
              where a.pfpais = P_N_CODPAI
                and a.pftdoc = P_N_TIPDOC
                and a.pfndoc = rpad(P_C_NUMDOC,12,' ');
           exception
           when others then
             lv_nombre := '';
           end;           
         End if;
         
         if lv_tipper = 'J' then
           begin
             Select trim(a.PJRAZS)
               into lv_nombre
               from fsd003 a 
              where a.pjpais = P_N_CODPAI
                and a.pjtdoc = P_N_TIPDOC
                and a.pjndoc = rpad(P_C_NUMDOC,12,' ');
           exception
           when others then
             lv_nombre := '';
           end;           
         End if;         
         
         lv_concatenado := lpad(P_N_SCCTA,9,'0')||lpad(P_N_SCMOD,3,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCSBOP,2,'0')||lpad(P_N_SCTOPE,3,'0');
         --ENVIA MAIL CON TODOS LOS CORREOS DEL CLIENTE ADJUNTANDO CARTA
         lv_archivo := lpad(P_N_CODPAI,3,'0')||lpad(P_N_TIPDOC,2,'0')||lpad(P_C_NUMDOC,12,'0')||'.pdf';
         for j in c_mail loop
           lv_destinos := lv_destinos || j.mail||';';
         end loop;  
         lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1); 
         
         lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';
         lv_remitente := 'procesosbantotal@cajaarequipa.pe';
         lv_asunto    := 'Aviso de Cancelacion de cuenta';
         -- ARMADO DEL CUERPO        
         dbms_lob.createtemporary(ll_mensaje, TRUE);              
         lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola: '||lv_nombre||'</p>' ||  
                       '<p "font-family: Arial, sans-serif; font-size: 14px;">Le comunicamos que con fecha '||to_char(P_D_FECPRO,'DD/MM/RRRR')||' su cuenta '||lv_concatenado||' ha sido cancelada, conforme lo indicado en carta adjunta.</p>'||          
                       '<p "font-family: Arial, sans-serif; font-size: 14px;">Para tramitar una nueva cuenta puedes usar nuestra  APP, Página  Web (<a href="http://www.cajaarequipa.pe">www.cajaarequipa.pe</a>) o acercándote a cualquiera de nuestras agencias a nivel nacional portando tu DNI.</p>';                                                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
         lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';                                          
         lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);        
          --ENVIO MAIL
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
          if p_c_coderr = '000' then
             lv_estado  := 'S';
             p_c_indnot := 'C';
             p_c_msgerr := 'ENVIO SATISFACTORIO';
          Else
             lv_estado := 'N';
          End If; 
          --REGISTRAMOS LOG    
          begin
           insert into aqpa122(aqpa122pgc,
                               aqpa122mod,
                               aqpa122suc,
                               aqpa122mda,
                               aqpa122pap,
                               aqpa122cta,
                               aqpa122ope,
                               aqpa122sub,
                               aqpa122tpo,
                               aqpa122pai,
                               aqpa122pet,
                               aqpa122num,
                               aqpa122tip,
                               aqpa122fec,
                               aqpa122hor,
                               aqpa122des,
                               aqpa122est,
                               aqpa122msg,
                               aqpa122cue,
                               aqpa122arc
                               ) values
                               (P_N_PGCOD,  
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
                                'M',
                                P_D_FECPRO,
                                TO_CHAR(SYSDATE,'hh24:mi:ss'),
                                lv_destinos,
                                lv_estado,
                                p_c_msgerr,
                                ll_mensaje,
                                EMPTY_BLOB()
                               )
                             RETURN aqpa122arc INTO l_blob;
            l_bfile := BFILENAME(lv_directorio, lv_archivo);
            DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
            DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
            DBMS_LOB.fileclose(l_bfile);    
            commit;                           
          exception
          when dup_val_on_index then
            null;
          when others then
             p_c_coderr := sqlcode;
             p_c_msgerr := sqlerrm;          
          end;    
          dbms_lob.freetemporary(ll_mensaje);             
      End if;
      if p_c_indnot = 'S' then
         p_c_indnot := 'X';--NO CANCELAR CUENTA
         --REGISTRA EN ICHANNEL CADA CELULAR DEL CLIENTE
         For i in c_celular loop
          lv_destinos := lv_destinos || i.celular||';';
          pq_ah_reg_alertaafiliacion.sp_ah_registra_ichannel(p_n_jaqy660cta  => P_N_SCCTA,
                                                             p_c_jaqy660tme  => 'S',
                                                             p_c_jaqy660afi  => '',
                                                             p_c_jaqy660aux1 => '',
                                                             p_c_jaqy660aux2 => 'N'||TRIM(i.celular),
                                                             p_c_code        => p_c_coderr,
                                                             p_c_error       => p_c_msgerr
                                                             );   
           if p_c_coderr = '0' and p_c_indnot <> 'C' then
              p_c_indnot := 'C'; --cancelar cuenta                       
           End If;                                                  
         End loop; 
         --REGISTRA aqpa122
         begin
           insert into aqpa122(aqpa122pgc,
                               aqpa122mod,
                               aqpa122suc,
                               aqpa122mda,
                               aqpa122pap,
                               aqpa122cta,
                               aqpa122ope,
                               aqpa122sub,
                               aqpa122tpo,
                               aqpa122pai,
                               aqpa122pet,
                               aqpa122num,
                               aqpa122tip,
                               aqpa122fec,
                               aqpa122hor,
                               aqpa122des,
                               aqpa122est,
                               aqpa122msg
                               ) values
                               (P_N_PGCOD,  
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
                                'S',
                                P_D_FECPRO,
                                TO_CHAR(SYSDATE,'hh24:mi:ss'),
                                lv_destinos,
                                DECODE(p_c_indnot,'C','S','N'),
                                DECODE(p_c_indnot,'C','REGISTRO DE NOTIFICACION EXITOSA',p_c_msgerr)
                               );
                               commit;
         exception
         when dup_val_on_index then
           null;
         when others then
            p_c_coderr := sqlcode;
            p_c_msgerr := sqlerrm;          
         end;             
      End if;
      if p_c_indnot = 'F' then
         p_c_indnot := 'X';--NO CANCELAR CUENTA
         --REGISTRA LOG
         begin
           insert into aqpa122(aqpa122pgc,
                               aqpa122mod,
                               aqpa122suc,
                               aqpa122mda,
                               aqpa122pap,
                               aqpa122cta,
                               aqpa122ope,
                               aqpa122sub,
                               aqpa122tpo,
                               aqpa122pai,
                               aqpa122pet,
                               aqpa122num,
                               aqpa122tip,
                               aqpa122fec,
                               aqpa122hor,
                               aqpa122est,
                               aqpa122msg
                               ) values
                               (P_N_PGCOD,  
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
                                'F',
                                P_D_FECPRO,
                                TO_CHAR(SYSDATE,'hh24:mi:ss'),
                                'N',
                                'NO SE PUEDE NOTIFICAR NO PRESENTA CORREO NI CELULAR VÁLIDO'
                               );
                               commit;
         exception
         when dup_val_on_index then
           null;
         when others then
            p_c_coderr := sqlcode;
            p_c_msgerr := sqlerrm;          
         end;
      End if;            
    End if;  
  exception
  when others then  
    p_c_indnot := '';
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;       
  end sp_ah_notifica_cancel;  
Procedure sp_ah_notifica_jpla(P_D_FECPRO IN DATE,
                              P_N_CODSUC IN NUMBER,
                              P_D_FECINI IN DATE,
                              P_D_FECFIN IN DATE,      
                              P_C_NOMARC IN VARCHAR2,                           
                              p_c_coderr out varchar2,
                              p_c_msgerr out varchar2
                             ) is                                                       
                            
  
  lv_destinos     varchar2(400):= '';     
  lv_archivo      varchar2(21) := '';  
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100); 
  lv_estado       CHAR(1);
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  
  l_bfile         BFILE;
  l_blob          BLOB;                                         
  lv_indenv       char(1):='N';
  lc_usrori       char(10);
  lc_usrsup       char(10); 
  begin      
  p_c_coderr := '000';                               
              
  lv_archivo := trim(P_C_NOMARC);
  lv_destinos := ''; 
           
  lv_directorio:= 'DTPUMP_PR_EMAIL_DIG';
  lv_remitente := 'procesosbantotal@cajaarequipa.pe';
  lv_asunto    := 'Comunicacion Cancelacion de cuentas Caja Arequipa';
  -- ARMADO DEL CUERPO        
  dbms_lob.createtemporary(ll_mensaje, TRUE);              
  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Jefe de Plataforma</p>' ||  
               '<p "font-family: Arial, sans-serif; font-size: 14px;">En adjunto archivo PDF a imprimir y publicar en agencia.</p>';          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
  lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';                                          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
  begin
    Select a.aqpa122best
      into lv_indenv 
      from aqpa122b a 
     where a.aqpa122bfec = P_D_FECPRO
       and a.aqpa122bsuc = P_N_CODSUC;
  exception
  when others then 
     lv_indenv := 'N';     
  end;  
  if lv_indenv = 'N' then
      --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
      begin                  
        Select b.sng057usr, b.sng057sup
          into lc_usrori, 
               lc_usrsup
          from fst046 a, 
               sng057 b 
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = P_N_CODSUC
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
                   and c.ubsuc     = P_N_CODSUC
                   and d.sng055car = 50
               )
           and rownum < 2;
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;  
                     
    if trim(lc_usrori) is not null then        
      --Enviamos el correo
      CASE
      WHEN trim(lc_usrsup) is not null THEN
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe'||';'||lower(trim(lc_usrsup))||'@cajaarequipa.pe';
      ELSE
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe';
      END CASE; 
      
       --ENVIO MAIL
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
        if p_c_coderr = '000' then
           lv_estado  := 'S';
           p_c_msgerr := 'ENVIO SATISFACTORIO';
        Else
           lv_estado := 'N';
        End If; 
      Else
        p_c_msgerr := 'NO SE ENCONTRO USUARIO DE JPLA PARA ENVIO DE ARCHIVO';
        lv_estado := 'N';           
      End If;      
    else
      p_c_msgerr := 'ENVIO SATISFACTORIO';
      lv_estado := 'S';      
    End If;         
 
  if lv_indenv = 'N' then        
      --REGISTRAMOS LOG    
      begin
       insert into aqpa122b(aqpa122bfec,
                            aqpa122bsuc,
                            aqpa122bfin,
                            aqpa122bffi,
                            aqpa122bust,
                            aqpa122buss,
                            aqpa122bhor,
                            aqpa122best,
                            aqpa122bmsg,
                            aqpa122bnom,
                            aqpa122barc,
                            aqpa122bcue
                           ) values
                           (P_D_FECPRO,
                            P_N_CODSUC,
                            P_D_FECINI,
                            P_D_FECFIN,
                            lc_usrori,
                            lc_usrsup,                                
                            TO_CHAR(SYSDATE,'hh24:mi:ss'),
                            lv_estado,
                            p_c_msgerr,
                            lv_archivo,
                            EMPTY_BLOB(),
                            ll_mensaje
                           )
                         RETURN aqpa122barc INTO l_blob;
        l_bfile := BFILENAME(lv_directorio, lv_archivo);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);    
        commit;                           
      exception
      when dup_val_on_index then
        delete from aqpa122b a
         where a.aqpa122bfec = P_D_FECPRO
           and a.aqpa122bsuc = P_N_CODSUC;
           commit;
            begin
             insert into aqpa122b(aqpa122bfec,
                                  aqpa122bsuc,
                                  aqpa122bfin,
                                  aqpa122bffi,
                                  aqpa122bust,
                                  aqpa122buss,
                                  aqpa122bhor,
                                  aqpa122best,
                                  aqpa122bmsg,
                                  aqpa122bnom,
                                  aqpa122barc,
                                  aqpa122bcue
                                 ) values
                                 (P_D_FECPRO,
                                  P_N_CODSUC,
                                  P_D_FECINI,
                                  P_D_FECFIN,
                                  lc_usrori,
                                  lc_usrsup,                                  
                                  TO_CHAR(SYSDATE,'hh24:mi:ss'),
                                  lv_estado,
                                  p_c_msgerr,
                                  lv_archivo,
                                  EMPTY_BLOB(),
                                  ll_mensaje
                                 )
                               RETURN aqpa122barc INTO l_blob;
              l_bfile := BFILENAME(lv_directorio, lv_archivo);
              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
              DBMS_LOB.fileclose(l_bfile);    
              commit;                           
            exception
            when others then
               p_c_coderr := sqlcode;
               p_c_msgerr := sqlerrm;          
            end;       
      when others then
         p_c_coderr := sqlcode;
         p_c_msgerr := sqlerrm;          
      end; 
  end if;   
  dbms_lob.freetemporary(ll_mensaje);                  
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;       
  end sp_ah_notifica_jpla;     
  Procedure sp_ah_envio_com(P_D_FECPRO IN DATE,
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
                            P_N_SCMTO  IN NUMBER,
                            P_C_EMAILS in VARCHAR2,
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2         
                            ) is  
  cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 110
       and a.Tp1corr2 > 1
  order by a.tp1cod, 
           a.tp1cod1, 
           a.tp1corr1, 
           a.tp1corr2,   
           a.tp1corr3;
                                        
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);     
  lv_remitente  VARCHAR2(30);  
  lv_asunto     VARCHAR2(90);  
  lv_destinos   VARCHAR2(32767):='';    
  lv_contacto   VARCHAR2(200);    
  ln_corcar     NUMBER(10) := 0;  
  lv_direccion  VARCHAR2(200);                   
  begin
    p_c_coderr := '000';
    p_c_deserr := '';
    lv_destinos := P_C_EMAILS;   
            
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1corr2 = 3 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1corr2 = 2 then
           lv_asunto     := lv_asunto || trim(i.tp1desc);       
         Else
           null;
      End Case;                                      
    End Loop;   
    --titular de la cuenta
    begin
      Select trim(b.pfnom1)||' '||trim(b.pfnom2)||' '||trim(b.pfape1)||' '||trim(b.pfape2),
             trim(c.sngc13dir)
        into lv_contacto,
             lv_direccion
        from fsr008 a,
             fsd002 b,
             sngc13 c 
       where a.pepais = b.pfpais
         and a.petdoc = b.pftdoc
         and a.pendoc = b.pfndoc
         and b.pfpais = c.sngc13pais
         and b.pftdoc = c.sngc13tdoc
         and b.pfndoc = c.sngc13ndoc
         and c.docod = 1
         and c.sngc13est = 'H'
         and a.pgcod = 1 
         and a.ctnro = P_N_SCCTA
         and a.ttcod = 1
         and a.cttfir = 'T';
    exception
    when others then
      lv_contacto := '';  
      lv_direccion := '';
    end;
    -- Call the procedure
    pq_ah_enviodigital.sp_ah_gencor_carta(p_d_fecpro => P_D_FECPRO,
                                          p_n_numcor => ln_corcar
                                         );    

    dbms_lob.createtemporary(ll_mensaje, TRUE);
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Arequipa'|| TO_CHAR (P_D_FECPRO, ', DD "de" Month "de" YYYY','NLS_DATE_LANGUAGE=Spanish')||'</p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Señor(a)(ita):</p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">'||lv_contacto||'</p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Dirección:'||lv_direccion||'</p>';                                                                                                                                                                                                                                 
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);        
              
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Presente.-</p>' ||  
                  '<br/>'||
                  '<br/>'||
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">De nuestra consideración. </p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">Nos es grato dirigirnos a usted a fin de saludarlo e informarle que de acuerdo la Ley N° </p>'||          
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">31022, los fondos provenientes del Sistema Privado de Pensiones o de los Bonos otorgados </p>' ||            
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">por el Gobierno Nacional, mantienen la condición de intangibles y por lo tanto no están </p>' ||            
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">sujetos al cobro de comisiones y/o gastos, producto de las operaciones realizadas con los </p>' ||  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">mismos.</p>' ||    
                  '<br/>'||                             
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">En atención a los alcances de la norma antes indicada, le informamos que Caja Arequipa </p>' ||            
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">ha implementado un procedimiento para la devolución inmediata de las comisiones que </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">hubieran sido cobradas en exceso, mediante el depósito en la cuenta de ahorro que nuestro </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">cliente tuviera vigente, sin embargo teniendo en cuenta que usted ha sido beneficiado con </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">uno de los fondos antes indicados y que a la fecha no mantiene vigente una cuenta de </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">ahorros vigente al momento de la devolución; por ello, lo invitamos a apersonarse a </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">cualquiera de nuestras agencias a nivel nacional, portando su DNI, a fin de solicitar la </p>' ||    
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">devolución de la comisión por transferencia ascendente a: S/ '|| to_char(P_N_SCMTO,'90.90')||'.</p>' ||                                                                                                                                  
                  '<p "font-family: Arial, sans-serif; font-size: 14px;">cobrada la comisión.</p>'||
                  '<br/>';                                                                                                                                                                                                                                  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
       
    lv_mensaje := '<br/>'||                                                                                                                              
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente,<br/>Caja Arequipa</strong></p>';                                          
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
        
      if trim(lv_destinos) is not null then
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
                                                   p_c_deserr          => p_c_deserr
                                                   );
          exception
          when others then  
               p_c_coderr := '00x';
               p_c_deserr := sqlerrm;                                                   
          end;
      else
               p_c_coderr := '00y';
               p_c_deserr := 'No existe cuenta de correo asociada';              
      end if;
      
      --registramos el resultado del envío
      begin
        insert into aqpa131a a (AQPA131AANO,
                                AQPA131ACOD,
                                AQPA131APGC,
                                AQPA131AMOD,
                                AQPA131ASUC,
                                AQPA131AMDA,
                                AQPA131APAP,
                                AQPA131ACTA,
                                AQPA131AOPE,
                                AQPA131ASUB,
                                AQPA131ATPO,
                                AQPA131AFEC,
                                AQPA131AHOR,
                                AQPA131AUSU,
                                AQPA131AMTO,
                                AQPA131AMAI,
                                AQPA131ACUE,
                                AQPA131AEST,
                                AQPA131AMSG
                                ) values
                                (to_number(to_char(P_D_FECPRO,'RRRR')),
                                 ln_corcar,
                                 P_N_PGCOD, 
                                 P_N_SCMOD, 
                                 P_N_SCSUC, 
                                 P_N_SCMDA, 
                                 P_N_SCPAP, 
                                 P_N_SCCTA, 
                                 P_N_SCOPER,
                                 P_N_SCSBOP,
                                 P_N_SCTOPE,
                                 P_D_FECPRO,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 P_C_CODUSU,
                                 P_N_SCMTO, 
                                 P_C_EMAILS,
                                 ll_mensaje,
                                 decode(p_c_coderr,'000','S','N'),
                                 decode(p_c_coderr,'000','Envío Satisfactorio',p_c_deserr)
                                 );
                                 commit;
                                 
      exception
      when others then
           p_c_coderr :=  sqlcode;
           p_c_deserr := sqlerrm;        
      end;
      dbms_lob.freetemporary(ll_mensaje);         
  exception
  when others then   
       p_c_coderr :=  sqlcode;
       p_c_deserr := sqlerrm;                           
  end sp_ah_envio_com;         

  Procedure sp_ah_gencor_carta(P_D_FECPRO IN DATE,
                               p_n_numcor out number
                               ) is
  ln_itrel number(10) := 0;                               
  begin
              begin
               select a.aqpa131cod
                 into ln_itrel
                 from aqpa131 a
                where a.aqpa131ano = to_number(to_char(P_D_FECPRO,'RRRR'))                  
                  for update of a.aqpa131cod;                  
              exception
              when no_data_found then
                   begin
                   insert into aqpa131(aqpa131ano,
                                       aqpa131cod                                       
                                       )                             
                                values(to_number(to_char(P_D_FECPRO,'RRRR')),
                                       0                                      
                                       );
                    end;   
                           
                    begin
                       select a.aqpa131cod
                         into ln_itrel
                         from aqpa131 a
                        where a.aqpa131ano = to_number(to_char(P_D_FECPRO,'RRRR'))                 
                          for update of a.aqpa131cod;           
                    end;        
              end;    
      -- Actualización.
      ln_itrel := ln_itrel + 1;
     update aqpa131 a 
        set a.aqpa131cod = ln_itrel 
      where a.aqpa131ano = to_number(to_char(P_D_FECPRO,'RRRR'));
      -- Grabación.
      commit;      
      p_n_numcor := ln_itrel;            
  end sp_ah_gencor_carta;        
  Procedure sp_ah_notifica_ape_jpla(P_N_PGCOD  IN NUMBER,
                                    P_N_SCMOD  IN NUMBER,
                                    P_N_SCSUC  IN NUMBER,
                                    P_N_SCMDA  IN NUMBER,
                                    P_N_SCCTA  IN NUMBER,
                                    P_N_SCOPER IN NUMBER,
                                    P_N_SCSBOP IN NUMBER,
                                    P_N_SCTOPE IN NUMBER,
                                    P_N_SCMTO  IN NUMBER,
                                    P_D_FECPRO IN DATE,    
                                    P_C_CODUSU IN VARCHAR2,
                                    p_c_coderr out varchar2,
                                    p_c_deserr out varchar2         
                               ) is                                                       
                            
  
  lv_destinos     varchar2(400):= '';     
  lv_archivo      varchar2(21) := '';  
  lv_remitente    varchar2(100); 
  lv_asunto       varchar2(100);   
  lv_directorio   varchar2(100);    
  ll_mensaje      CLOB;
  lv_mensaje      VARCHAR2(32767);  

                                     
  
  lc_usrori       char(10);
  lc_usrsup       char(10); 
  lc_cuenta       varchar2(27);
  lv_producto     varchar2(30);
  lv_tipo         varchar2(80);
  lv_sucursal     varchar2(30);
  lc_hora         char(8);
  begin      
  p_c_coderr := '000';                                             
  lv_destinos := '';            
  lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
  lv_asunto    := 'Alerta Apertura cliente PROCEDIMIENTO REFORZADO';
  lc_hora    := to_char(sysdate,'HH24:mi:ss'); 
  
  --ARMAMOS LA CUENTA CONCATENA
  If P_N_SCMOD = 21 THEN
    lc_cuenta := lpad(P_N_SCCTA,9,'0')||lpad(P_N_SCMOD,3,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCSBOP,2,'0')||lpad(P_N_SCTOPE,3,'0');
  Else
    lc_cuenta := lpad(P_N_SCCTA,9,'0')||lpad(P_N_SCMOD,3,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCOPER,9,'0')||lpad(P_N_SCTOPE,3,'0');    
  End If; 
  
  begin
    Select trim(upper(a.tonom))
      into lv_producto
      from fst004 a 
     where a.modulo = P_N_SCMOD
       and a.totope = P_N_SCTOPE;
  exception
  when others then
    lv_producto   := '';
  end;
  
  begin
    Select upper(trim(c.SNG036LTTX))
      into lv_tipo
      from SNG039 b,
           SNG036 c
     where c.sng036idio = 'ES'
       and to_number(trim(c.SNG036LTCO)) = b.sng039ltco
       and b.SNG038Prog = 'HSNGCPF1'
       and b.SNG038CpId = 86
       and b.SNG039ValC = rpad(P_N_SCMTO,10,' ');
  exception
  when others then
    lv_tipo   := '';
  end;  
  
  --obtenemos descripccion de la sucursal donde se hizo
  begin
    select trim(a.scnom)
      into lv_sucursal
      from fst001 a
     where a.pgcod  = P_N_PGCOD
       and a.sucurs = P_N_SCSUC;
  exception
  when others then     
    lv_sucursal := '';
  end;  
  -- ARMADO DEL CUERPO        
  dbms_lob.createtemporary(ll_mensaje, TRUE);              
  lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) Usuario</p>'||  
               '<p "font-family: Arial, sans-serif; font-size: 14px;">Se informa sobre la siguiente APERTURA DE CUENTA realizado en el sistema Bantotal.</p>';          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);  
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
   lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=2 width=450>'||
              '  <tr>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b>Datos:</b></td>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b></b></td>'||
              '  </tr>          ';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Cuenta Cliente:'||'</td>'||
        '    <td align="left">'||to_char(P_N_SCCTA)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Producto:'||'</td>'||
        '    <td align="left">'||lc_cuenta||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Operaci&oacute;n:'||'</td>'||
        '    <td align="left">'||lv_producto||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Tipo:'||'</td>'||
        '    <td align="left">'||'PROCEDIMIENTO REFORZADO - '||lv_tipo||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);             

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Sucursal:'||'</td>'||
        '    <td align="left">'||lv_sucursal||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Operador:'||'</td>'||
        '    <td align="left">'||trim(P_C_CODUSU)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);           
            
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Fecha-Hora apertura:'||'</td>'||
        '    <td align="left">'||to_char(P_D_FECPRO,'dd/mm/rrrr')||' '||lc_hora||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        lv_mensaje := 
        '</table>'||
        '<br/>'||
        '<br/>';      
  
             
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
  lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales<br/>Caja Arequipa</strong></p>';                                          
  lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  


      --Obtenemos el correo del jefe de plataforma de la agencia correspondiente    
      begin                  
        Select b.sng057usr, b.sng057sup
          into lc_usrori, 
               lc_usrsup
          from fst046 a, 
               sng057 b 
         where a.pgcod     = b.sng055emp
           and a.ubuser    = b.sng057usr
           and a.ubsuc     = P_N_SCSUC
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
                   and c.ubsuc     = P_N_SCSUC
                   and d.sng055car = 50
               )
           and rownum < 2;
      exception
      when others then       
        lc_usrori := '';
        lc_usrsup := '';
      end;  
                     
    if trim(lc_usrori) is not null then        
      --Enviamos el correo
      CASE
      WHEN trim(lc_usrsup) is not null THEN
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe'||';'||lower(trim(lc_usrsup))||'@cajaarequipa.pe';
      ELSE
        lv_destinos := lower(trim(lc_usrori))||'@cajaarequipa.pe';
      END CASE; 
      
       --ENVIO MAIL
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
                                                 p_c_deserr          => p_c_deserr
                                                 );
        exception
        when others then  
             p_c_coderr := '00x';
             p_c_deserr := sqlerrm;                                                   
        end; 
        if p_c_coderr = '000' then
           p_c_deserr := 'ENVIO SATISFACTORIO';       
        End If; 
      Else
        p_c_deserr := 'NO SE ENCONTRO USUARIO DE JPLA PARA ENVIO DE ARCHIVO';        
      End If;      
 
  dbms_lob.freetemporary(ll_mensaje);                  
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;       
  end sp_ah_notifica_ape_jpla;  
  
 Procedure sp_ah_notifica_ape_can(P_N_PGCOD  IN NUMBER,
                                  P_N_SCMOD  IN NUMBER,
                                  P_N_SCSUC  IN NUMBER,
                                  P_N_SCMDA  IN NUMBER,
                                  P_N_SCPAP  IN NUMBER,
                                  P_N_SCCTA  IN NUMBER,
                                  P_N_SCOPER IN NUMBER,
                                  P_N_SCSBOP IN NUMBER,
                                  P_N_SCTOPE IN NUMBER,
                                  P_N_SCMTO  IN NUMBER,
                                  P_N_MODOPE IN NUMBER,
                                  P_N_TRXOPE IN NUMBER,
                                  P_N_ITSUC  IN NUMBER,
                                  P_N_ITREL  IN NUMBER,
                                  P_D_FECPRO IN DATE,
                                  P_C_CODUSU IN VARCHAR2,
                                  p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2                                                            
                                 ) is
 cursor c_titulares is
   Select *
     from fsr008 a
    where a.pgcod = P_N_PGCOD
      and a.ctnro = P_N_SCCTA
      and a.ttcod = 1;
      
 cursor c_mails(ln_pais in number, ln_tipdoc in number, lc_numdoc in char) is
   Select b.pepais,b.petdoc,b.pendoc,trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1)) mail
     from fsx001 b
    where b.pepais = ln_pais
      and b.petdoc = ln_tipdoc
      and b.pendoc = lc_numdoc
      and b.txcod  = 0
      and trim(b.pextxt) is not null
      and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S';          
      
 lv_nombre       varchar2(70) := null;      
 lv_destinos     varchar2(400):= '';     
 lv_archivo      varchar2(21) := '';  
 lv_remitente    varchar2(100); 
 lv_asunto       varchar2(100);   
 lv_directorio   varchar2(100);    
 ll_mensaje      CLOB;
 lv_mensaje      VARCHAR2(32767); 
 lc_hora         char(8);
 ln_canal        number(9)    := 0;
 ln_scmod        number(3)    := 0; 
 lv_canal        varchar2(70) := null;      
 lv_tipo         varchar2(70) := null;      
 lv_monto        varchar2(70) := null;      
 lv_moneda       varchar2(70) := null;      
 lv_plazo        varchar2(70) := null;     
 lv_cuenta       varchar2(70) := null;     
 lv_operacion    varchar2(70) := null;    
 lc_estado       char(1)      := null;
 ln_tipope       number(9):=0;  
 begin                                 
 p_c_coderr   := '000';   
 p_c_deserr   := '';
                                                     
 lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
  
 if P_N_SCMOD = 122 then
    ln_scmod := 22;
 Else
    ln_scmod := P_N_SCMOD;
 end if;
 
 lv_cuenta    := lpad(P_N_SCCTA,9,'0')||lpad(ln_scmod,3,'0')||lpad(P_N_SCMDA,3,'0')||lpad(P_N_SCOPER,9,'0')||lpad(P_N_SCTOPE,3,'0');    
 lv_monto     := to_char(P_N_SCMTO,'999,999,999.90');
 
 --OBTENEMOS LA DESCRIPCCION DE LA TRANSACCION
 begin
   Select upper(trim(a.trnom))
     into lv_operacion
     from fst034 a
    where a.pgcod = P_N_PGCOD
      and a.trmod = P_N_MODOPE
      and a.trnro = P_N_TRXOPE;
 exception
 when others then
   lv_operacion := null;
   p_c_coderr   := '001';   
   p_c_deserr   := 'No se encontró descripcción de la transacción'; 
   return;  
 end;
 
 --OBTENEMOS LA MONEDA DE LA TRANSACCION
 begin
   Select upper(trim(a.monom))
     into lv_moneda
     from fst005 a
    where a.moneda = P_N_SCMDA;
 exception
 when others then
   lv_moneda := null;
   p_c_coderr   := '002';   
   p_c_deserr   := 'No se encontró descripcción de la moneda'; 
   return;   
 end; 
 
 --OBTENEMOS EL PLAZO DEL PRODUCTO
 begin
   Select to_char(a.aopzo)
     into lv_plazo
     from fsd010 a
    where a.pgcod  = P_N_PGCOD  
      and a.aomod  = P_N_SCMOD 
      and a.aosuc  = P_N_SCSUC 
      and a.aomda  = P_N_SCMDA 
      and a.aopap  = P_N_SCPAP
      and a.aocta  = P_N_SCCTA 
      and a.aooper = P_N_SCOPER
      and a.aosbop = P_N_SCSBOP
      and a.aotope = P_N_SCTOPE;
 exception
 when others then
   lv_plazo := null;
   p_c_coderr   := '003';   
   p_c_deserr   := 'No se encontró plazo'; 
   return;   
 end; 
 
 --OBTENEMOS LA DESCRIPCCION DEL CANAL
 begin
   Select upper(trim(a.tp1desc)), a.tp1imp1, a.tp1imp2
     into lv_canal, ln_canal, ln_tipope
     from fst198 a
    where a.tp1cod = 1
      and a.tp1cod1 = 10825
      and a.tp1corr1 = 115
      and a.tp1corr2 = 1
      and a.tp1nro1 = P_N_MODOPE
      and a.tp1nro2 = P_N_TRXOPE
      and rownum <2;  
 exception
 when others then
   lv_canal := null;
   ln_canal := null;
   p_c_coderr   := '004';   
   p_c_deserr   := 'No se encontró descripcción del canal'; 
   return;  
 end;
 
 if ln_tipope = 1 then
   lv_asunto    := 'Apertura de Cuenta'; 
 End if;
 If ln_tipope = 2 then
   lv_asunto    := 'Cancelación de cuenta'; 
 end if;   
 
 --OBTENEMOS HORA DE LA OPERACIÓN
 begin
   Select trim(a.ithora)
     into lc_hora
     from fsd015 a
    where a.pgcod  = P_N_PGCOD  
      and a.itsuc  = P_N_ITSUC 
      and a.itmod  = P_N_MODOPE 
      and a.ittran = P_N_TRXOPE  
      and a.itnrel = P_N_ITREL 
      and a.itcorr = 0
      and a.itcont = 'S';
 exception
 when others then
   lc_hora      := to_char(sysdate,'HH24:mi:ss');  
 end; 
 
 if ln_canal = 1 then
    -- obtenemos descripcción de la agencia
     begin
       Select 'AGENCIA '||upper(trim(a.scnom))
         into lv_canal
         from fst001 a
        where a.pgcod  = P_N_PGCOD
          and a.sucurs = P_N_ITSUC;
     exception
     when others then
       lv_canal := null;
       p_c_coderr   := '004';   
       p_c_deserr   := 'No se encontró descripcción del canal'; 
       return;  
     end;    
 End if;
 
 --OBTENEMOS TIPO DE OPERACION
 begin
   Select upper(trim(a.tonom))
     into lv_tipo
     from fst004 a
    where a.modulo = decode(P_N_SCMOD,122,22,P_N_SCMOD)
      and a.totope = P_N_SCTOPE;
 exception
 when others then
   lv_tipo := null;
   p_c_coderr   := '005';   
   p_c_deserr   := 'No se encontró descripcción de tipo de operación'; 
   return;  
 end; 
 
   for i in c_titulares loop
     lv_destinos := null;
     for j in c_mails(i.pepais,i.petdoc,i.pendoc) loop
       lv_destinos  := lv_destinos||j.mail ||';';      
     End loop;
     --SOLO SI TIENE CORREO
     if lv_destinos is not null then
       
         lv_destinos := substr(lv_destinos,1,length(lv_destinos)-1);
         lv_nombre    := '';
         
         --NOMBRE DEL TITULAR
         begin
           Select trim(a.pfnom1)
             into lv_nombre
             from fsd002 a
            where a.pfpais = i.pepais
              and a.pftdoc = i.petdoc
              and a.pfndoc = i.pendoc;
         exception
         when others then
           begin
             Select trim(a.pjrazs)
               into lv_nombre
               from fsd003 a
              where a.pjpais = i.pepais
                and a.pjtdoc = i.petdoc
                and a.pjndoc = i.pendoc;
           exception
           when others then
             lv_nombre := null;
           end;     
         end;
         
          -- ARMADO DEL CUERPO        
          dbms_lob.createtemporary(ll_mensaje, TRUE);              
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a) '||lv_nombre||'</p>'||  
                       '<p "font-family: Arial, sans-serif; font-size: 14px;">Caja Arequipa le informa sobre la operación de '||lv_operacion||' realizada hoy a las '||lc_hora||' en:</p>';          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);  
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
          
          lv_mensaje := '<table cellspacing=0 cellpadding=2 width=450>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
                      
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Canal:'||'</td>'||
          '    <td align="left">'||lv_canal||'</td>'||
          '  </tr>                ';    
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);    
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
                
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Tipo de operación:'||'</td>'||
          '    <td align="left">'||lv_tipo||'</td>'||
          '  </tr>                ';       
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Importe:'||'</td>'||
          '    <td align="left">'||lv_monto||'</td>'||
          '  </tr>                ';       
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Moneda:'||'</td>'||
          '    <td align="left">'||lv_moneda||'</td>'||
          '  </tr>                ';       
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);             

          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Plazo:'||'</td>'||
          '    <td align="left">'||lv_plazo||' días'||'</td>'||
          '  </tr>                ';       
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
                
          lv_mensaje := 
          '  <tr>'||
          '    <td align="left">'||'Nro. Cuenta del depósito:'||'</td>'||
          '    <td align="left">'||lv_cuenta||'</td>'||
          '  </tr>                ';       
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);           
                                  
          lv_mensaje := 
          '</table>';   
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
          
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Si tuviera alguna consulta acerca de la información brindada podrá acercarse a cualquiera de nuestras agencias.</p>';          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                            
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            
          lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa.</strong></p>';                                          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
          
          
           --ENVIO MAIL
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
                                                     p_c_deserr          => p_c_deserr
                                                     );
            exception
            when others then  
                 p_c_coderr := '00x';
                 p_c_deserr := sqlerrm; 
                 lc_estado := 'N';                                                  
            end; 
            if p_c_coderr = '000' then
               p_c_deserr := 'ENVIO SATISFACTORIO';   
               lc_estado := 'S';  
            Else
               lc_estado := 'N'; 
            End If;  
            
            --REGISTRO DE LOG                
            begin                  
                insert into jaqz187c(jaqz187cpgc,
                                     jaqz187cmod,
                                     jaqz187csuc,
                                     jaqz187cmda,
                                     jaqz187cpap,
                                     jaqz187ccta,
                                     jaqz187cope,
                                     jaqz187csub,
                                     jaqz187ctop,
                                     jaqz187cpai,
                                     jaqz187ctpo,
                                     jaqz187cnum,
                                     jaqz187cmdx,
                                     jaqz187ctrx,
                                     jaqz187cfep,
                                     jaqz187chop,
                                     jaqz187cusp,
                                     jaqz187cest,
                                     jaqz187cmot,
                                     jaqz187ccue,
                                     jaqz187cmai
                                     )
                               values(P_N_PGCOD, 
                                      decode(P_N_SCMOD,122,22,P_N_SCMOD), 
                                      P_N_SCSUC, 
                                      P_N_SCMDA, 
                                      P_N_SCPAP, 
                                      P_N_SCCTA, 
                                      P_N_SCOPER,
                                      P_N_SCSBOP,
                                      P_N_SCTOPE,
                                      i.pepais,
                                      i.petdoc,
                                      i.pendoc,
                                      P_N_MODOPE,
                                      P_N_TRXOPE,
                                      P_D_FECPRO,
                                      to_char(sysdate,'HH24:mi:ss'), 
                                      P_C_CODUSU,
                                      lc_estado,
                                      p_c_deserr,
                                      ll_mensaje,
                                      lv_destinos                          
                                      );
                                      commit;
            exception
            when dup_val_on_index then
                update jaqz187c a
                   set a.jaqz187cfep = P_D_FECPRO,
                       a.jaqz187chop = to_char(sysdate,'HH24:mi:ss'),
                       a.jaqz187cusp = P_C_CODUSU,
                       a.jaqz187cest = lc_estado,
                       a.jaqz187cmot = p_c_deserr,
                       a.jaqz187ccue = ll_mensaje,
                       a.jaqz187cmai = lv_destinos
                 where a.jaqz187cpgc = P_N_PGCOD 
                   and a.jaqz187cmod = decode(P_N_SCMOD,122,22,P_N_SCMOD)  
                   and a.jaqz187csuc = P_N_SCSUC 
                   and a.jaqz187cmda = P_N_SCMDA 
                   and a.jaqz187cpap = P_N_SCPAP 
                   and a.jaqz187ccta = P_N_SCCTA 
                   and a.jaqz187cope = P_N_SCOPER
                   and a.jaqz187csub = P_N_SCSBOP
                   and a.jaqz187ctop = P_N_SCTOPE
                   and a.jaqz187cpai = i.pepais
                   and a.jaqz187ctpo = i.petdoc
                   and a.jaqz187cnum = i.pendoc
                   and a.jaqz187cmdx = P_N_MODOPE
                   and a.jaqz187ctrx = P_N_TRXOPE;                                                                                                                
                   commit;
            when others then                        
                null;
            end;      
            
            if p_c_coderr <> '000' then         
                --                       
                --REGISTRAMOS RENVIO   
                --
                begin
                    pq_cr_enviar_correos.sp_ah_reprocesa_mail(p_n_codpro => 1,--ALERTA APERTURA Y CANCELACIONES DPF
                                                              p_c_asunto => lv_asunto,
                                                              p_c_despar => lv_destinos,
                                                              p_c_descoc => '',
                                                              p_c_descco => '',
                                                              p_c_mensaj => ll_mensaje,
                                                              p_c_remite => lv_remitente,
                                                              p_c_direct => lv_directorio,
                                                              p_c_adjunt => lv_archivo,
                                                              p_n_aux001 => null,
                                                              p_n_aux002 => null,
                                                              p_n_aux003 => null,
                                                              p_n_aux004 => null,
                                                              p_d_aux005 => null,
                                                              p_d_aux006 => null,
                                                              p_c_aux007 => lv_cuenta,
                                                              p_c_aux008 => null,
                                                              p_c_aux009 => null,
                                                              p_c_coderr => p_c_coderr,
                                                              p_c_msgerr => p_c_deserr
                                                              );              
                end;
            End If;
            dbms_lob.freetemporary(ll_mensaje);                      
        end if; 
   end loop;
   if P_N_TRXOPE in (800,600) then
    --
    --VALIDAMOS ALERTA PARA EXPERIENCIA AL CLIENTE
    --    
    -- Call the procedure
    If ln_canal = 1 then
       lv_canal := 'VENTANILLA';
    End If;
    pq_cl_alertas.sp_cl_alertas(p_n_numcta => P_N_SCCTA,
                                p_d_fecpro => P_D_FECPRO,
                                p_c_tippro => 'A',
                                P_C_CANAL  => lv_canal,
                                P_C_CODUSU => P_C_CODUSU                                 
                                );         
    --FIN EXPERIENCIA AL CLIENTE                            
   End if;  
 exception
 when others then
   p_c_coderr   := sqlcode;
   p_c_deserr   := sqlerrm;
 end sp_ah_notifica_ape_can;    
 Procedure sp_ah_enrola_cel(P_N_PGCOD  IN NUMBER,                                                                 
                            P_N_SCCTA  IN NUMBER,                                                                                                                             
                            p_c_coderr out VARCHAR2,
                            p_c_deserr out VARCHAR2                                                            
                           ) is
  cursor c_celulares is
  Select distinct lpad(a.pepais,3,'0')||lpad(a.petdoc,2,'0')||lpad(trim(a.pendoc),12,'0')||lpad(trim(a.dotelfp),9,'0') codigo,trim(a.dotelfp) celular
   from fsr005 a,
        fsr008 b
  where a.pepais = b.pepais
    and a.petdoc = b.petdoc
    and a.pendoc = b.pendoc
    and b.ttcod = 1
    and b.pgcod = P_N_PGCOD
    and b.ctnro = P_N_SCCTA    
    and PQ_AH_ENVIODIGITAL.fn_ah_valida_celular(trim(a.dotelfp),1)= 'S' ;                              
 begin
   p_c_coderr := '0';
   for i in c_celulares loop
     
      pq_ah_reg_alertaafiliacion.sp_ah_registra_ichannel(p_n_jaqy660cta  => P_N_SCCTA,
                                                         p_c_jaqy660tme  => 'S',
                                                         p_c_jaqy660afi  => '',
                                                         p_c_jaqy660aux1 => i.celular,
                                                         p_c_jaqy660aux2 => i.codigo,
                                                         p_c_code        => p_c_coderr,
                                                         p_c_error       => p_c_deserr
                                                         );   
   end loop;
 exception
 when others then
  p_c_coderr := sqlcode;
  p_c_deserr := sqlerrm;   
 end sp_ah_enrola_cel;    
 Procedure sp_ah_envio_ape_cdk(P_D_FECINI IN DATE,
                               P_D_FECFIN IN DATE,           
                               p_c_coderr out VARCHAR2,
                               p_c_deserr out VARCHAR2         
                              ) is
  cursor empleadores_empleado is
     Select a.pgcod,
           a.scmod,
           a.scsuc,
           a.scmda,
           a.scpap,
           a.sccta,
           a.scoper,
           a.scsbop,
           a.sctope,
           case
             when a.scmod = 21 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0')
             when a.scmod = 22 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')||lpad(a.sctope,3,'0')               
             Else
               lpad(a.sccta,9,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')
           end cuentacli,
           a.scfval,
           b.r1cta            
      from fsd011 a,
           fsr011 b
     where a.pgcod = b.r1cod
       and b.r1cod = b.r2cod
       and a.scmod = b.r2mod
       and a.scsuc = b.r2suc
       and a.scmda = b.r2mda
       and a.scpap = b.r2pap
       and a.sccta = b.r2cta
       and a.scoper = b.r2oper
       and a.scsbop = b.r2sbop
       and a.sctope = b.r2tope
       and b.r011co = 'S'
       and b.relcod = 45
       and a.pgcod  = 1
       and a.scmod  = 21
       and a.sctope = 2
       and a.scstat = 4
       and a.scfval between P_D_FECINI and P_D_FECFIN
       and not exists (Select 1 
                         from jaqz188d x 
                        where x.jaqz188dpgc = b.r2cod 
                          and x.jaqz188dmod = b.r2mod
                          and x.jaqz188dsuc = b.r2suc
                          and x.jaqz188dmda = b.r2mda
                          and x.jaqz188dpap = b.r2pap
                          and x.jaqz188dcta = b.r2cta
                          and x.jaqz188dope = b.r2oper
                          and x.jaqz188dsbo = b.r2sbop
                          and x.jaqz188dtpo = b.r2tope
                          and x.jaqz188dest = 'S' --LOG ENVIO BIENVENIDA ES CREDINKA
                      )       
       and exists (select 1 
                       from jaql054 z 
                      where z.jaql54pgco = b.r2cod 
                        and z.jaql54scsu = b.r2suc
                        and z.jaql54scmd = b.r2mda
                        and z.jaql54scpa = b.r2pap
                        and z.jaql54scct = b.r2cta
                        and z.jaql54scop = b.r2oper
                        and z.jaql54scsb = b.r2sbop
                        and z.jaql54scto = b.r2tope
                        and z.jaql54scmo = b.r2mod 
                        and z.jaql54enti = 230 
                        and z.JAQL54TIMI = 'M' 
                      ); --APERTURAS X MIGRACION MANUAL CREDINKA
                      
   
  lv_contacto   varchar2(110);    
  ln_codpai     number(3);
  ln_tipdoc     number(2);
  lc_numdoc     varchar2(12);
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);      
  lv_destinos   VARCHAR2(32767):='';   
  
  l_bfile     BFILE;
  l_blob      BLOB; 
  lv_estado   varchar2(1):='N';                                    
    
  begin
  p_c_coderr := '000';  
  for i in empleadores_empleado loop
     --verificamos si ya se envió
     begin
         Select jaqz188dest
           into lv_estado 
           from jaqz188d a
          where a.jaqz188dpgc = i.pgcod 
            and a.jaqz188dmod = i.scmod 
            and a.jaqz188dsuc = i.scsuc 
            and a.jaqz188dmda = i.scmda 
            and a.jaqz188dpap = i.scpap 
            and a.jaqz188dcta = i.sccta 
            and a.jaqz188dope = i.scoper 
            and a.jaqz188dsbo = i.scsbop 
            and a.jaqz188dtpo = i.sctope;              
     exception
     when others then
       lv_estado := 'N';
     end;         
      
     If lv_estado = 'N' then
        lv_mensaje := '';
        --obtenemos correo electronicos del trabajador
        pq_ah_enviodigital.sp_ah_mail_cta(p_n_numcta => i.sccta,
                                          P_c_tipcta => 'C',           
                                          p_n_codpai => ln_codpai,
                                          p_n_tipdoc => ln_tipdoc,
                                          p_c_numdoc => lc_numdoc,
                                          p_c_emails => lv_destinos
                                         );         
        lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(ln_codpai,ln_tipdoc,lc_numdoc);            
              
        if trim(lv_destinos) is not null then                                 
            dbms_lob.createtemporary(ll_mensaje, TRUE);              
            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">CAJA AREQUIPA</p>' ||  
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">CONSTANCIA DE CTA CTS</p>'||        
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Titular: '||trim(lv_contacto)||'</p>' ||                       
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Nro de Cta CTS:'||trim(i.cuentacli)||'</p>' ||                                                   
                          '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
      
            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Puedes verificar tu cuenta en nuestros canales de atención.</p>' ||          
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                          '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
            begin
                    -- Call the procedure
                    p_c_coderr := '000';
                    pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                     p_destinatarioscc   => '',
                                                     p_destinatariosbcc  => '',
                                                     p_mensaje           => ll_mensaje,
                                                     p_remitente         => 'procesoscts@cajaarequipa.pe',
                                                     p_asunto            => 'Bienvenido a Caja Arequipa Cuenta CTS ',
                                                     p_tipomensaje       => 'HTML',
                                                     p_directorio        => 'DTPUMP_PR_EMAIL_DIG',
                                                     p_archivosadjuntos  => 'Carta-Bienvenida.pdf',
                                                     p_c_coderr          => p_c_coderr,
                                                     p_c_deserr          => p_c_deserr
                                                     );
            exception
            when others then  
                 p_c_coderr := '00x';
                 p_c_deserr := sqlerrm;                                                   
            end;
          
            --registramos envio
            begin
              insert into jaqz188d(jaqz188dpgc,
                                   jaqz188dmod,
                                   jaqz188dsuc,
                                   jaqz188dmda,
                                   jaqz188dpap,
                                   jaqz188dcta,
                                   jaqz188dope,
                                   jaqz188dsbo,
                                   jaqz188dtpo,
                                   jaqz188dcte,
                                   jaqz188dfep,
                                   jaqz188dhop,
                                   jaqz188dusp,
                                   jaqz188dfev,
                                   jaqz188dhev,
                                   jaqz188duev,
                                   jaqz188dest,
                                   jaqz188dmot,
                                   jaqz188dcue,
                                   jaqz188dcbl,
                                   jaqz188dmai
                                   )
                            values(i.pgcod,
                                   i.scmod,
                                   i.scsuc,
                                   i.scmda,
                                   i.scpap,
                                   i.sccta,
                                   i.scoper,
                                   i.scsbop,
                                   i.sctope,
                                   i.r1cta,
                                   trunc(sysdate),
                                   to_char(sysdate,'hh:mi:ss'),
                                   'BANTOTAL',
                                   trunc(sysdate),
                                   to_char(sysdate,'hh:mi:ss'),
                                   'BANTOTAL',
                                   decode(p_c_coderr,'000','S','N'),
                                   decode(p_c_coderr,'000','Envío Satisfactorio',p_c_deserr),
                                   ll_mensaje,
                                   EMPTY_BLOB(),
                                   lv_destinos                             
                                   )
                                   RETURN jaqz188dcbl INTO l_blob; 
                                   
                l_bfile := BFILENAME('DTPUMP_PR_EMAIL_DIG', 'Carta-Bienvenida.pdf');
                DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                DBMS_LOB.fileclose(l_bfile);        
            exception 
            when dup_val_on_index then
              if p_c_coderr = '000' then
                 update jaqz188d a
                    set  a.jaqz188dfev = trunc(sysdate),                               
                         a.jaqz188dhev = to_char(sysdate,'hh:mi:ss'),
                         a.jaqz188duev = 'BANTOTAL', 
                         a.jaqz188dest = 'S',
                         a.jaqz188dmot = 'Envío Satisfactorio'
                  where a.jaqz188dpgc = i.pgcod 
                    and a.jaqz188dmod = i.scmod 
                    and a.jaqz188dsuc = i.scsuc 
                    and a.jaqz188dmda = i.scmda 
                    and a.jaqz188dpap = i.scpap 
                    and a.jaqz188dcta = i.sccta 
                    and a.jaqz188dope = i.scoper 
                    and a.jaqz188dsbo = i.scsbop 
                    and a.jaqz188dtpo = i.sctope;               
              Else
                 update jaqz188d a
                    set  a.jaqz188dfev = trunc(sysdate),                               
                         a.jaqz188dhev = to_char(sysdate,'hh:mi:ss'),
                         a.jaqz188duev = 'BANTOTAL', 
                         a.jaqz188dmot = p_c_deserr
                  where a.jaqz188dpgc = i.pgcod 
                    and a.jaqz188dmod = i.scmod 
                    and a.jaqz188dsuc = i.scsuc 
                    and a.jaqz188dmda = i.scmda 
                    and a.jaqz188dpap = i.scpap 
                    and a.jaqz188dcta = i.sccta 
                    and a.jaqz188dope = i.scoper 
                    and a.jaqz188dsbo = i.scsbop 
                    and a.jaqz188dtpo = i.sctope;             
              End If;    
            When Others then  
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;    
            end;   
         dbms_lob.freetemporary(ll_mensaje);                 
         COMMIT;                                 
        End If;        
     End If; 
  End loop;  
  Exception
  when others then   
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;                                                                     
  end sp_ah_envio_ape_cdk;                                                                                                                                                                   
  Procedure sp_ah_envio_sal_cdk(P_C_CODUSU in VARCHAR2,       
                                p_c_coderr out VARCHAR2,
                                p_c_deserr out VARCHAR2         
                                ) is
  cursor c_cartas is
    select a.* 
      from jaql456 a 
     where a.jaql456usu = rpad(P_C_CODUSU,10,' ');
   
  lv_contacto   varchar2(110);    
  ln_codpai     number(3);
  ln_tipdoc     number(2);
  lc_numdoc     varchar2(12);
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);      
  lv_destinos   VARCHAR2(32767):='';   
  
  l_bfile     BFILE;
  l_blob      BLOB;     
  ln_pgcod       number(3):=1;
  ln_scmod       number(3):=21;
  ln_scsuc       number(3);
  ln_scmda       number(4);
  ln_scpap       number(3):=0;
  ln_sccta       number(9);
  ln_scoper      number(9):=0;
  ln_scsbop      number(3);
  ln_sctope      number(3):=2;
  lv_flag     char(1):='N';
  begin
  p_c_coderr := '000';  
  for i in c_cartas loop
    ln_scmda := substr(trim(i.jaql456cta),13,3);
    ln_sccta := substr(trim(i.jaql456cta),1,9);
    ln_scsbop := substr(trim(i.jaql456cta),16,2);
    begin
      select x.scsuc
        into ln_scsuc 
        from fsd011 x 
       where x.pgcod  = 1 
         and x.scmod  = 21 
         and x.scmda  = ln_scmda
         and x.scpap  = 0
         and x.sccta  = ln_sccta
         and x.scoper = 0
         and x.scsbop = ln_scsbop
         and x.sctope = 2;
    exception
    when others then
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;       
       ln_scsuc := 0;    
    end;
    
    if ln_scsuc >0 then
        begin
         Select 'S'
           into lv_flag
           from jaqz188e x 
          where x.jaqz188epgc = ln_pgcod
            and x.jaqz188emod = ln_scmod
            and x.jaqz188esuc = ln_scsuc
            and x.jaqz188emda = ln_scmda
            and x.jaqz188epap = ln_scpap
            and x.jaqz188ecta = ln_sccta
            and x.jaqz188eope = ln_scoper
            and x.jaqz188esbo = ln_scsbop
            and x.jaqz188etpo = ln_sctope
            and x.jaqz188eest = 'S';
        Exception
        When Others then    
          lv_flag := 'N';
        end;
        
        If lv_flag = 'N' then 
          lv_mensaje := '';
          --obtenemos correo electronicos del trabajador
          pq_ah_enviodigital.sp_ah_mail_cta(p_n_numcta => i.jaql456ax1,
                                            P_c_tipcta => 'C',           
                                            p_n_codpai => ln_codpai,
                                            p_n_tipdoc => ln_tipdoc,
                                            p_c_numdoc => lc_numdoc,
                                            p_c_emails => lv_destinos
                                           );         
          lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(ln_codpai,ln_tipdoc,lc_numdoc);            
                
          if trim(lv_destinos) is not null then                                 
              dbms_lob.createtemporary(ll_mensaje, TRUE);              
              lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">CAJA AREQUIPA</p>' ||  
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Migración de saldo de tu cuenta CTS </p>'||        
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Titular: '||trim(lv_contacto)||'</p>' ||                       
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Nro de Cta CTS:'||trim(i.jaql456cta)||'</p>' ||                                                   
                            '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
        
              lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Puedes pasar a recoger tu tarjeta en cualquier agencia a Nivel Nacional.</p>' ||          
                            '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                            '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
              begin
                      -- Call the procedure
                      p_c_coderr := '000';
                      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                       p_destinatarioscc   => '',
                                                       p_destinatariosbcc  => '',
                                                       p_mensaje           => ll_mensaje,
                                                       p_remitente         => 'procesoscts@cajaarequipa.pe',
                                                       p_asunto            => 'MIGRACION CTS -  Caja Arequipa',
                                                       p_tipomensaje       => 'HTML',
                                                       p_directorio        => 'DTPUMP_PR_EMAIL',
                                                       p_archivosadjuntos  => trim(i.jaql456cta)||'.pdf',
                                                       p_c_coderr          => p_c_coderr,
                                                       p_c_deserr          => p_c_deserr
                                                       );
              exception
              when others then  
                   p_c_coderr := '00x';
                   p_c_deserr := sqlerrm;                                                   
              end;
            
              --registramos envio
              begin
                insert into jaqz188e(jaqz188epgc,
                                     jaqz188emod,
                                     jaqz188esuc,
                                     jaqz188emda,
                                     jaqz188epap,
                                     jaqz188ecta,
                                     jaqz188eope,
                                     jaqz188esbo,
                                     jaqz188etpo,
                                     jaqz188ecte,
                                     jaqz188efep,
                                     jaqz188ehop,
                                     jaqz188eusp,
                                     jaqz188efev,
                                     jaqz188ehev,
                                     jaqz188euev,
                                     jaqz188eest,
                                     jaqz188emot,
                                     jaqz188ecue,
                                     jaqz188ecbl,
                                     jaqz188emai
                                     )
                              values(ln_pgcod,
                                     ln_scmod,
                                     ln_scsuc,
                                     ln_scmda,
                                     ln_scpap,
                                     ln_sccta,
                                     ln_scoper,
                                     ln_scsbop,
                                     ln_sctope,
                                     i.jaql456ax2,
                                     trunc(sysdate),
                                     to_char(sysdate,'hh:mi:ss'),
                                     'BANTOTAL',
                                     trunc(sysdate),
                                     to_char(sysdate,'hh:mi:ss'),
                                     'BANTOTAL',
                                     decode(p_c_coderr,'000','S','N'),
                                     decode(p_c_coderr,'000','Envío Satisfactorio',p_c_deserr),
                                     ll_mensaje,
                                     EMPTY_BLOB(),
                                     lv_destinos                             
                                     )
                                     RETURN jaqz188ecbl INTO l_blob; 
                                     
                  l_bfile := BFILENAME('DTPUMP_PR_EMAIL', trim(i.jaql456cta)||'.pdf');
                  DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                  DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                  DBMS_LOB.fileclose(l_bfile);        
              exception 
              when dup_val_on_index then
                if p_c_coderr = '000' then
                   update jaqz188e a
                      set  a.jaqz188efev = trunc(sysdate),                               
                           a.jaqz188ehev = to_char(sysdate,'hh:mi:ss'),
                           a.jaqz188euev = 'BANTOTAL', 
                           a.jaqz188eest = 'S',
                           a.jaqz188emot = 'Envío Satisfactorio'
                    where a.jaqz188epgc = ln_pgcod 
                      and a.jaqz188emod = ln_scmod 
                      and a.jaqz188esuc = ln_scsuc 
                      and a.jaqz188emda = ln_scmda 
                      and a.jaqz188epap = ln_scpap 
                      and a.jaqz188ecta = ln_sccta 
                      and a.jaqz188eope = ln_scoper 
                      and a.jaqz188esbo = ln_scsbop 
                      and a.jaqz188etpo = ln_sctope;               
                Else
                   update jaqz188e a
                      set  a.jaqz188efev = trunc(sysdate),                               
                           a.jaqz188ehev = to_char(sysdate,'hh:mi:ss'),
                           a.jaqz188euev = 'BANTOTAL', 
                           a.jaqz188emot = p_c_deserr
                    where a.jaqz188epgc = ln_pgcod 
                      and a.jaqz188emod = ln_scmod 
                      and a.jaqz188esuc = ln_scsuc 
                      and a.jaqz188emda = ln_scmda 
                      and a.jaqz188epap = ln_scpap 
                      and a.jaqz188ecta = ln_sccta 
                      and a.jaqz188eope = ln_scoper 
                      and a.jaqz188esbo = ln_scsbop 
                      and a.jaqz188etpo = ln_sctope;             
                End If;    
              When Others then  
                p_c_coderr := sqlcode;
                p_c_deserr := sqlerrm;    
              end;   
           dbms_lob.freetemporary(ll_mensaje);                 
           COMMIT;                                 
          End If; 
        End if;       
    End if;        
  End loop;        
  Exception
  when others then   
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;                                                                     
  end sp_ah_envio_sal_cdk;      
  /*                                                                                                                                                              
  Procedure sp_ah_envio_migah_cdk(p_c_coderr out VARCHAR2,
                                  p_c_deserr out VARCHAR2         
                                 ) is
  cursor c_cuentas is
    Select a.pgcod,
           a.scmod,
           a.scsuc,
           a.scmda,
           a.scpap,
           a.sccta,
           a.scoper,
           a.scsbop,
           a.sctope,
           case
             when a.scmod = 21 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scsbop,2,'0')||lpad(a.sctope,3,'0')
             when a.scmod = 22 then
               lpad(a.sccta,9,'0')||lpad(a.scmod,3,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')||lpad(a.sctope,3,'0')               
             Else
               lpad(a.sccta,9,'0')||lpad(a.scmda,3,'0')||lpad(a.scoper,9,'0')
           end cuentacli,
           a.scfval         
      from fsd011 a,
           aqpa150 z
     where a.pgcod  = z.AQPA150PGC   
       and a.scmod  = z.AQPA150MOD
       and a.scsuc  = z.AQPA150SUC
       and a.scmda  = z.AQPA150MDA
       and a.scpap  = z.AQPA150PAP
       and a.sccta  = z.AQPA150CTA
       and a.scoper = z.AQPA150OPE
       and a.scsbop = z.AQPA150SBO
       and a.sctope = z.AQPA150TPO
       and a.pgcod  = 1
       and a.scmod  = 21
       and (nvl(z.aqpa150sbo,0) >0
             and z.aqpa150msg is null
            )      
        and z.aqpa150est <> 81
        and trim(z.aqpa150ax9) is null
        and z.AQPA150NUM <> '20100210909'
        and (z.aqpa150scp + z.aqpa150sit) > 0
        and trim(z.aqpa150cue) <> '8711000050'               
        and not exists (Select 1 
                         from jaqz188f x 
                        where x.jaqz188fpgc = z.AQPA150PGC  
                          and x.jaqz188fmod = z.AQPA150MOD
                          and x.jaqz188fsuc = z.AQPA150SUC
                          and x.jaqz188fmda = z.AQPA150MDA
                          and x.jaqz188fpap = z.AQPA150PAP
                          and x.jaqz188fcta = z.AQPA150CTA
                          and x.jaqz188fope = z.AQPA150OPE
                          and x.jaqz188fsbo = z.AQPA150SBO
                          and x.jaqz188ftpo = z.AQPA150TPO
                          and x.jaqz188fest = 'S' --LOG ENVIO MIGRA SALDO AHORROS EX CREDINKA
                      );
                     
                                                   
  lv_contacto   varchar2(110);    
  ln_codpai     number(3);
  ln_tipdoc     number(2);
  lc_numdoc     varchar2(12);
  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);      
  lv_destinos   VARCHAR2(32767):='';   
  
  l_bfile     BFILE;
  l_blob      BLOB;                                   
    
  begin
  p_c_coderr := '000';  
  for i in c_cuentas loop
                
        lv_mensaje := '';
        --obtenemos correo electronicos del trabajador
        pq_ah_enviodigital.sp_ah_mail_cta(p_n_numcta => i.sccta,
                                          P_c_tipcta => 'C',           
                                          p_n_codpai => ln_codpai,
                                          p_n_tipdoc => ln_tipdoc,
                                          p_c_numdoc => lc_numdoc,
                                          p_c_emails => lv_destinos
                                         );         
        lv_contacto := pq_ah_enviodigital.fn_ah_nombre_per(ln_codpai,ln_tipdoc,lc_numdoc);            
              
        if trim(lv_destinos) is not null then                                 
            dbms_lob.createtemporary(ll_mensaje, TRUE);              
            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">CAJA AREQUIPA</p>' ||  
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Migración de saldo de tu cuenta Ahorro</p>'||        
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Titular: '||trim(lv_contacto)||'</p>' ||                       
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Nro de Cuenta de ahorros:'||trim(i.cuentacli)||'</p>' ||                                                   
                          '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
      
            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Puedes pasar a recoger tu tarjeta en cualquier agencia a Nivel Nacional.</p>' ||          
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Para más información visitamos en: https://www.cajaarequipa.pe/bienvenidos-a-caja-arequipa/</p>'||                                                        
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Cordialmente.</p>'||                                                        
                          '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
            begin
                    -- Call the procedure
                    p_c_coderr := '000';
                    pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                                     p_destinatarioscc   => '',
                                                     p_destinatariosbcc  => '',
                                                     p_mensaje           => ll_mensaje,
                                                     p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                                     p_asunto            => 'MIGRACION DE SALDO DE AHORROS -  Caja Arequipa ',
                                                     p_tipomensaje       => 'HTML',
                                                     p_directorio        => 'DTPUMP_PR_EMAIL_DIG',
                                                     p_archivosadjuntos  => 'Carta_ahorros.pdf',
                                                     p_c_coderr          => p_c_coderr,
                                                     p_c_deserr          => p_c_deserr
                                                     );
            exception
            when others then  
                 p_c_coderr := '00x';
                 p_c_deserr := sqlerrm;                                                   
            end;
          
            --registramos envio
            begin
              insert into jaqz188f(jaqz188fpgc,
                                   jaqz188fmod,
                                   jaqz188fsuc,
                                   jaqz188fmda,
                                   jaqz188fpap,
                                   jaqz188fcta,
                                   jaqz188fope,
                                   jaqz188fsbo,
                                   jaqz188ftpo,
                                   jaqz188fcte,
                                   jaqz188ffep,
                                   jaqz188fhop,
                                   jaqz188fusp,
                                   jaqz188ffev,
                                   jaqz188fhev,
                                   jaqz188fuev,
                                   jaqz188fest,
                                   jaqz188fmot,
                                   jaqz188fcue,
                                   jaqz188fcbl,
                                   jaqz188fmai
                                   )
                            values(i.pgcod,
                                   i.scmod,
                                   i.scsuc,
                                   i.scmda,
                                   i.scpap,
                                   i.sccta,
                                   i.scoper,
                                   i.scsbop,
                                   i.sctope,
                                   null,
                                   trunc(sysdate),
                                   to_char(sysdate,'hh:mi:ss'),
                                   'BANTOTAL',
                                   trunc(sysdate),
                                   to_char(sysdate,'hh:mi:ss'),
                                   'BANTOTAL',
                                   decode(p_c_coderr,'000','S','N'),
                                   decode(p_c_coderr,'000','Envío Satisfactorio',p_c_deserr),
                                   ll_mensaje,
                                   EMPTY_BLOB(),
                                   lv_destinos                             
                                   )
                                   RETURN jaqz188fcbl INTO l_blob; 
                                   
                l_bfile := BFILENAME('DTPUMP_PR_EMAIL_DIG', 'Carta_ahorros.pdf');
                DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                DBMS_LOB.fileclose(l_bfile);        
            exception 
            when dup_val_on_index then
              if p_c_coderr = '000' then
                 update jaqz188f a
                    set  a.jaqz188ffev = trunc(sysdate),                               
                         a.jaqz188fhev = to_char(sysdate,'hh:mi:ss'),
                         a.jaqz188fuev = 'BANTOTAL', 
                         a.jaqz188fest = 'S',
                         a.jaqz188fmot = 'Envío Satisfactorio'
                  where a.jaqz188fpgc = i.pgcod 
                    and a.jaqz188fmod = i.scmod 
                    and a.jaqz188fsuc = i.scsuc 
                    and a.jaqz188fmda = i.scmda 
                    and a.jaqz188fpap = i.scpap 
                    and a.jaqz188fcta = i.sccta 
                    and a.jaqz188fope = i.scoper 
                    and a.jaqz188fsbo = i.scsbop 
                    and a.jaqz188ftpo = i.sctope;               
              Else
                 update jaqz188f a
                    set  a.jaqz188ffev = trunc(sysdate),                               
                         a.jaqz188fhev = to_char(sysdate,'hh:mi:ss'),
                         a.jaqz188fuev = 'BANTOTAL', 
                         a.jaqz188fmot = p_c_deserr
                  where a.jaqz188fpgc = i.pgcod 
                    and a.jaqz188fmod = i.scmod 
                    and a.jaqz188fsuc = i.scsuc 
                    and a.jaqz188fmda = i.scmda 
                    and a.jaqz188fpap = i.scpap 
                    and a.jaqz188fcta = i.sccta 
                    and a.jaqz188fope = i.scoper 
                    and a.jaqz188fsbo = i.scsbop 
                    and a.jaqz188ftpo = i.sctope;             
              End If;    
            When Others then  
              p_c_coderr := sqlcode;
              p_c_deserr := sqlerrm;    
            end;   
         dbms_lob.freetemporary(ll_mensaje);                 
         COMMIT;                                 
        End If;        
  End loop;  
  Exception
  when others then   
    p_c_coderr := sqlcode;
    p_c_deserr := sqlerrm;                                                                     
  end sp_ah_envio_migah_cdk;  
  */
end PQ_AH_ENVIODIGITAL;
 /* GOLDENGATE_DDL_REPLICATION */
/
