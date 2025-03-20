CREATE OR REPLACE PACKAGE PQ_AH_REG_ALERTAAFILIACION IS
    -- *****************************************************************
    -- Nombre                     : Afiliación a notificaciones
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.12.22
    -- Autor de Creación          : YLOZADA
    -- Uso                        : Envía notificaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 08/03/2025
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se adiciono canal y dni de usuario 
    -- *****************************************************************      
  PROCEDURE SP_AH_REGISTRA_AFILIACION(P_C_JAQY660TIP IN VARCHAR2,
                                      P_N_JAQY660PGO IN NUMBER,
                                      P_N_JAQY660SUC IN NUMBER,
                                      P_N_JAQY660MOD IN NUMBER,
                                      P_N_JAQY660MDA IN NUMBER,
                                      P_N_JAQY660CTA IN NUMBER,
                                      P_N_JAQY660PAP IN NUMBER,
                                      P_N_JAQY660OPE IN NUMBER,
                                      P_N_JAQY660SUB IN NUMBER,
                                      P_N_JAQY660TOP IN NUMBER,
                                      P_D_JAQY660FCH IN DATE,
                                      P_C_JAQY660USU IN VARCHAR2,                                      
                                      P_C_JAQY660TPR IN VARCHAR2,
                                      P_C_JAQY660TME IN VARCHAR2,
                                      P_C_JAQY660AFI IN VARCHAR2,
                                      P_C_JAQY660FDE IN DATE,
                                      P_C_JAQY660UDE IN VARCHAR2,
                                      P_C_JAQY660AUX1 IN NUMBER,
                                      P_C_JAQY660AUX2 IN VARCHAR2,
                                      P_C_HORA        IN VARCHAR2,
                                      P_C_CODE       OUT VARCHAR2,
                                      P_C_ERROR      OUT VARCHAR2
                                     );
   PROCEDURE SH_DATOS_CLIENTES_ICHANNEL(P_N_CUENTA IN NUMBER,
                                        P_C_NOMBRE OUT VARCHAR2,
                                        P_S_SEXO   OUT VARCHAR2                                        
                                        );   
  PROCEDURE SP_AH_AFILIA_CREDITO(P_N_PGCOD  IN NUMBER,
                                 P_N_ITSUC  IN NUMBER,           
                                 P_N_ITMOD  IN NUMBER,
                                 P_N_ITTRAN IN NUMBER,                                
                                 P_N_ITNREL IN NUMBER,
                                 P_N_ITORD  IN NUMBER,  
                                 P_N_ITSBO  IN NUMBER,
                                 lc_coderr out varchar2,
                                 lc_msgerr out varchar2                                 
                                );                                                                       
  PROCEDURE SP_AH_REGISTRA_ICHANNEL(P_N_JAQY660CTA  IN NUMBER,
                                    P_C_JAQY660TME  IN VARCHAR2,
                                    P_C_JAQY660AFI  IN VARCHAR2,
                                    P_C_JAQY660AUX1 IN NUMBER,
                                    P_C_JAQY660AUX2 IN VARCHAR2,
                                    p_c_code        out varchar2,
                                    p_c_error       out varchar2
                                   );
                                   
  PROCEDURE SP_AH_CORREO_REGISTRO(P_D_FECPRO      IN DATE,
                                  P_C_CODUSU      IN VARCHAR2,
                                  P_N_NUMCTA      IN NUMBER,
                                  P_N_CODAGE      IN NUMBER,                  
                                  P_C_CADENA      IN VARCHAR2,
                                  P_C_JAQY660TME  IN VARCHAR2,
                                  P_C_JAQY660AFI  IN VARCHAR2,--MAIL
                                  P_C_JAQY660AUX1 IN VARCHAR2,--CELULAR
                                  p_c_coderr      out varchar2,
                                  p_c_msgerr      out varchar2
                                  );                                   
END PQ_AH_REG_ALERTAAFILIACION;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_REG_ALERTAAFILIACION IS
  PROCEDURE SP_AH_REGISTRA_AFILIACION(P_C_JAQY660TIP IN VARCHAR2,
                                      P_N_JAQY660PGO IN NUMBER,
                                      P_N_JAQY660SUC IN NUMBER,
                                      P_N_JAQY660MOD IN NUMBER,
                                      P_N_JAQY660MDA IN NUMBER,
                                      P_N_JAQY660CTA IN NUMBER,
                                      P_N_JAQY660PAP IN NUMBER,
                                      P_N_JAQY660OPE IN NUMBER,
                                      P_N_JAQY660SUB IN NUMBER,
                                      P_N_JAQY660TOP IN NUMBER,                                      
                                      P_D_JAQY660FCH IN DATE,
                                      P_C_JAQY660USU IN VARCHAR2,                                     
                                      P_C_JAQY660TPR IN VARCHAR2,
                                      P_C_JAQY660TME IN VARCHAR2,
                                      P_C_JAQY660AFI IN VARCHAR2,
                                      P_C_JAQY660FDE IN DATE,
                                      P_C_JAQY660UDE IN VARCHAR2,
                                      P_C_JAQY660AUX1 IN NUMBER,
                                      P_C_JAQY660AUX2 IN VARCHAR2,
                                      P_C_HORA        IN VARCHAR2,
                                      P_C_CODE       OUT VARCHAR2,
                                      P_C_ERROR      OUT VARCHAR2
                                     ) IS
  
  C_DATO_NOMBRE     VARCHAR2(100);
  C_DATO_SEXO       VARCHAR2(1);
  C_DATO_MAIL       VARCHAR2(65);
  C_DATO_CELULAR    VARCHAR2(20);  
  V_MAIL            VARCHAR2(1);
  V_SMS             VARCHAR2(1);
  V_FECHA           DATE;
  ln_suafi          number(3) := 0;
  lc_numdoc         char(12):='';
  BEGIN
      P_C_CODE := '0';
      C_DATO_NOMBRE  := '';
      C_DATO_SEXO := '';
      C_DATO_MAIL := '';
      C_DATO_CELULAR := ''; 
      V_MAIL := '';
      V_SMS  := '';
     

      IF P_C_JAQY660FDE IS NULL THEN
         V_FECHA := null;--to_date('01/01/2000','dd/mm/yyyy');
      ELSE
         V_FECHA := P_C_JAQY660FDE;
      END IF;
     
       If P_C_JAQY660TME  = 'M' THEN
          C_DATO_MAIL := P_C_JAQY660AFI;
          V_MAIL := 'S';
          V_SMS  := 'N';
                
       ELSIF P_C_JAQY660TME  = 'S' THEN
          C_DATO_CELULAR := P_C_JAQY660AUX1;
          V_MAIL := 'N';
          V_SMS  := 'S';
       ELSIF P_C_JAQY660TME  = 'A' THEN
          C_DATO_CELULAR := P_C_JAQY660AUX1;
          C_DATO_MAIL := P_C_JAQY660AFI;
          V_MAIL := 'S';
          V_SMS  := 'S'; 
       ELSIF P_C_JAQY660TME  = 'N' THEN   
          C_DATO_CELULAR := '';
          C_DATO_MAIL := '';
          V_MAIL := 'N';
          V_SMS  := 'N';          
       End if;
       SH_DATOS_CLIENTES_ICHANNEL(P_N_JAQY660CTA,
                                  C_DATO_NOMBRE,
                                  C_DATO_SEXO);                                   
       BEGIN
         select X.PENDOC 
           into lc_numdoc 
           from FSR008 X 
          WHERE X.PGCOD = 1 
            AND X.CTNRO = P_N_JAQY660CTA
            AND X.TTCOD = 1 
            AND X.CTTFIR = 'T';            
       EXCEPTION
       WHEN OTHERS THEN
         lc_numdoc := null;
       END;                        
       
       BEGIN                          
          INSERT INTO /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                  nombre_cliente,
                                                  mail_cliente,
                                                  celular_cliente,
                                                  sexo_cliente,
                                                  enviar_celular,
                                                  enviar_mail)
                                           values(P_C_JAQY660AUX2,  ---P_N_JAQY660CTA,
                                                  C_DATO_NOMBRE,
                                                  decode(substr(P_C_JAQY660AUX2,1,1),'C','',C_DATO_MAIL),
                                                  C_DATO_CELULAR,
                                                  C_DATO_SEXO,
                                                  V_SMS,                                                  
                                                  decode(substr(P_C_JAQY660AUX2,1,1),'C','N',V_MAIL)
                                                  );
           commit;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                 BEGIN
                    IF P_C_JAQY660TME = 'N' THEN
                      UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente = '',
                              celular_cliente = '',
                              enviar_celular = 'N',
                              enviar_mail = 'N'
                        WHERE codigo_cliente =P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'M' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente = decode(substr(P_C_JAQY660AUX2,1,1),'C','',C_DATO_MAIL),
                              celular_cliente = '',
                              enviar_celular = 'N',
                              enviar_mail = decode(substr(P_C_JAQY660AUX2,1,1),'C','N','S')
                        WHERE codigo_cliente = P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'S' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente =  '',
                              celular_cliente = C_DATO_CELULAR ,
                              enviar_celular = 'S',
                              enviar_mail = 'N'
                        WHERE codigo_cliente = P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'A' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente =  decode(P_C_JAQY660TIP,'C','',C_DATO_MAIL),
                              celular_cliente = C_DATO_CELULAR ,
                              enviar_celular = 'S',
                              enviar_mail = decode(P_C_JAQY660TIP,'C','N','S')
                        WHERE codigo_cliente =P_C_JAQY660AUX2;    
                    END IF;
                    COMMIT;
                 EXCEPTION
                  WHEN OTHERS THEN
                     P_C_CODE  := sqlcode;
                     P_C_ERROR := sqlerrm;
                 END;
        END;
          
        BEGIN
          select ubsuc 
            into ln_suafi
            from fst046
           where pgcod  = P_N_JAQY660PGO
             and ubuser = rpad(P_C_JAQY660USU, 10, ' ');             
        EXCEPTION
          WHEN OTHERS THEN
            ln_suafi := 0;     
        END;
          


       INSERT INTO JAQY660 (JAQY660TIP,
                            JAQY660PGO,
                            JAQY660SUC,
                            JAQY660MOD,
                            JAQY660MDA,
                            JAQY660CTA,
                            JAQY660PAP,
                            JAQY660OPE,
                            JAQY660SUB,
                            JAQY660TOP,                            
                            JAQY660FCH,
                            JAQY660HRA, 
                            JAQY660SAF, 
                            JAQY660USU,                            
                            JAQY660TPR,
                            JAQY660TME,
                            JAQY660AFI,
                            JAQY660FDE,
                            JAQY660UDE,  
                            JAQY660AUX1,                         
                            JAQY660AUX2,
                            JAQY660AUX6,
                            JAQY660AUX7
                            )
                      VALUES(P_C_JAQY660TIP,
                             P_N_JAQY660PGO,
                             P_N_JAQY660SUC,
                             P_N_JAQY660MOD,
                             P_N_JAQY660MDA,
                             P_N_JAQY660CTA,
                             P_N_JAQY660PAP,
                             P_N_JAQY660OPE,
                             P_N_JAQY660SUB,
                             P_N_JAQY660TOP,                             
                             P_D_JAQY660FCH,
                             P_C_HORA,--TO_CHAR(sysdate,'HH24:mi:ss'),
                             ln_suafi,
                             P_C_JAQY660USU,                            
                             P_C_JAQY660TPR,
                             P_C_JAQY660TME,
                             P_C_JAQY660AFI,
                             V_FECHA,--- P_C_JAQY660FDE,
                             P_C_JAQY660UDE,
                             P_C_JAQY660AUX1,
                             P_C_JAQY660AUX2,
                             lc_numdoc,
                             decode(P_C_JAQY660USU,'NSBTUSER','DIGITAL','VENTANILLA')
                            );
                            COMMIT;
  EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         IF P_C_JAQY660TME = 'N' THEN
         
           UPDATE JAQY660
              SET JAQY660UDE = P_C_JAQY660UDE,
                  JAQY660FDE = P_C_JAQY660FDE,                  
                  JAQY660TPR = P_C_JAQY660TPR,
                  JAQY660TME = P_C_JAQY660TME,
                  JAQY660HRD = P_C_HORA,--TO_CHAR(sysdate,'HH24:mi:ss'),
                  JAQY660SDE = ln_suafi,         
                  JAQY660AUX8 = decode(P_C_JAQY660USU,'NSBTUSER','DIGITAL','VENTANILLA')                           
            WHERE JAQY660TIP = P_C_JAQY660TIP
              AND JAQY660PGO = P_N_JAQY660PGO
              AND JAQY660SUC = P_N_JAQY660SUC
              AND JAQY660MOD = P_N_JAQY660MOD
              AND JAQY660MDA = P_N_JAQY660MDA
              AND JAQY660CTA = P_N_JAQY660CTA
              AND JAQY660PAP = P_N_JAQY660PAP
              AND JAQY660OPE = P_N_JAQY660OPE
              AND JAQY660SUB = P_N_JAQY660SUB
              AND JAQY660TOP = P_N_JAQY660TOP;

        ELSIF P_C_JAQY660TME = 'M' THEN
         UPDATE JAQY660
              SET JAQY660FCH = P_D_JAQY660FCH,
                  JAQY660USU = P_C_JAQY660USU,
                  JAQY660TPR = P_C_JAQY660TPR,
                  JAQY660TME = P_C_JAQY660TME,
                  JAQY660AFI = P_C_JAQY660AFI,
                  JAQY660HRA = P_C_HORA,--TO_CHAR(sysdate,'HH24:mi:ss'),
                  JAQY660SAF = ln_suafi,
                  JAQY660AUX7 = decode(P_C_JAQY660USU,'NSBTUSER','DIGITAL','VENTANILLA')  
            WHERE JAQY660TIP = P_C_JAQY660TIP
              AND JAQY660PGO = P_N_JAQY660PGO
              AND JAQY660SUC = P_N_JAQY660SUC
              AND JAQY660MOD = P_N_JAQY660MOD
              AND JAQY660MDA = P_N_JAQY660MDA
              AND JAQY660CTA = P_N_JAQY660CTA
              AND JAQY660PAP = P_N_JAQY660PAP
              AND JAQY660OPE = P_N_JAQY660OPE
              AND JAQY660SUB = P_N_JAQY660SUB
              AND JAQY660TOP = P_N_JAQY660TOP;
        ELSIF  P_C_JAQY660TME = 'S' THEN
         UPDATE JAQY660
              SET JAQY660FCH = P_D_JAQY660FCH,
                  JAQY660USU = P_C_JAQY660USU,
                  JAQY660TPR = P_C_JAQY660TPR,
                  JAQY660TME = P_C_JAQY660TME,                  
                  JAQY660AUX1 = P_C_JAQY660AUX1,
                  JAQY660HRA = P_C_HORA,--TO_CHAR(sysdate,'HH24:mi:ss'),
                  JAQY660SAF = ln_suafi,      
                  JAQY660AUX7 = decode(P_C_JAQY660USU,'NSBTUSER','DIGITAL','VENTANILLA')              
            WHERE JAQY660TIP = P_C_JAQY660TIP
              AND JAQY660PGO = P_N_JAQY660PGO
              AND JAQY660SUC = P_N_JAQY660SUC
              AND JAQY660MOD = P_N_JAQY660MOD
              AND JAQY660MDA = P_N_JAQY660MDA
              AND JAQY660CTA = P_N_JAQY660CTA
              AND JAQY660PAP = P_N_JAQY660PAP
              AND JAQY660OPE = P_N_JAQY660OPE
              AND JAQY660SUB = P_N_JAQY660SUB
              AND JAQY660TOP = P_N_JAQY660TOP;
         ELSIF  P_C_JAQY660TME = 'A' THEN
         UPDATE JAQY660
              SET JAQY660FCH = P_D_JAQY660FCH,
                  JAQY660USU = P_C_JAQY660USU,
                  JAQY660TPR = P_C_JAQY660TPR,
                  JAQY660TME = P_C_JAQY660TME,                  
                  JAQY660AUX1 = P_C_JAQY660AUX1,
                  JAQY660AFI = P_C_JAQY660AFI,
                  JAQY660HRA = P_C_HORA,--TO_CHAR(sysdate,'HH24:mi:ss'),
                  JAQY660SAF = ln_suafi,
                  JAQY660AUX7 = decode(P_C_JAQY660USU,'NSBTUSER','DIGITAL','VENTANILLA')                    
            WHERE JAQY660TIP = P_C_JAQY660TIP
              AND JAQY660PGO = P_N_JAQY660PGO
              AND JAQY660SUC = P_N_JAQY660SUC
              AND JAQY660MOD = P_N_JAQY660MOD
              AND JAQY660MDA = P_N_JAQY660MDA
              AND JAQY660CTA = P_N_JAQY660CTA
              AND JAQY660PAP = P_N_JAQY660PAP
              AND JAQY660OPE = P_N_JAQY660OPE
              AND JAQY660SUB = P_N_JAQY660SUB
              AND JAQY660TOP = P_N_JAQY660TOP;
        END IF;
        COMMIT;
       END;

  WHEN OTHERS THEN
    P_C_CODE  := sqlcode;
    P_C_ERROR := sqlerrm;
  END SP_AH_REGISTRA_AFILIACION;
  PROCEDURE SH_DATOS_CLIENTES_ICHANNEL(P_N_CUENTA IN NUMBER,
                                        P_C_NOMBRE OUT VARCHAR2,
                                        P_S_SEXO   OUT VARCHAR2) IS
     
     C_NOMBRE VARCHAR2(80);
     C_SEXO   VARCHAR2(1);
     BEGIN
       SELECT (TRIM(F2.PFAPE1) ||' '||TRIM(F2.PFAPE2)||' , ' || TRIM(F2.PFNOM1) || ' ' || TRIM(F2.PFNOM2)) as nombre,
              F2.Pfcant              
         INTO C_NOMBRE, 
              C_SEXO
         FROM FSR008 F8, FSD002 F2
        WHERE F8.PGCOD = 1
          AND F8.CTNRO = P_N_CUENTA
          AND F8.CTTFIR = 'T'
          AND F2.PFPAIS = F8.PEPAIS
          AND F2.PFTDOC = F8.PETDOC
          AND F2.PFNDOC = F8.PENDOC;
        P_C_NOMBRE := C_NOMBRE;
        P_S_SEXO   := C_SEXO;
       EXCEPTION     
         WHEN OTHERS then
            BEGIN
              SELECT (TRIM(F3.PJRAZS)) as nombre,
                     'N'
                INTO C_NOMBRE, 
                     C_SEXO
                FROM FSR008 F8,FSD003 F3
               WHERE F8.PGCOD = 1
                 AND F8.CTNRO = P_N_CUENTA
                 AND F8.CTTFIR = 'T'
                 AND F3.PJPAIS = F8.PEPAIS
                 AND F3.PJTDOC = F8.PETDOC
                 AND F3.PJNDOC = F8.PENDOC;
                 P_C_NOMBRE := C_NOMBRE;
                 P_S_SEXO   := C_SEXO;
             EXCEPTION     
               WHEN OTHERS then               
                  C_NOMBRE := 'No se encontro nombre cliente';
                  P_C_NOMBRE := C_NOMBRE;
             END;          
  END SH_DATOS_CLIENTES_ICHANNEL;                                   
  PROCEDURE SP_AH_AFILIA_CREDITO(P_N_PGCOD  IN NUMBER,
                                 P_N_ITSUC  IN NUMBER,           
                                 P_N_ITMOD  IN NUMBER,
                                 P_N_ITTRAN IN NUMBER,                                
                                 P_N_ITNREL IN NUMBER,
                                 P_N_ITORD  IN NUMBER,  
                                 P_N_ITSBO  IN NUMBER,
                                 lc_coderr out varchar2,
                                 lc_msgerr out varchar2
                                ) is     
  pragma autonomous_transaction;                                                            
  ln_ctnro   number(9);  
  ln_itoper  number(9);  
  ln_itsubo  number(3);  
  ln_sucdes  number(3);  
  ln_ittope  number(3);  
  ln_moneda  number(4);  
  ln_modulo  number(3);
  ln_papel   number(4);  
  lc_mail    char(65);
  ln_pais    number(3);     
  ln_tipdoc  number(2);   
  ln_numdoc  char(12);    
  ld_fecpro  date;
  ld_fecdes  date;
  lc_celular char(20);    
  lc_tipo    char(1);
  lc_codusu  char(10);
  lc_usudes  char(10);
  lc_indmail char(1);
  lc_indcelu char(1);
  ln_len     number(3):=0;
  lc_cadena  varchar2(27);
  lv_ide     varchar2(1):='';
  begin                  
    begin
        select a.modulo,
               a.ctnro,
               a.itoper,
               a.itsubo,
               a.itsucd,
               a.ittope,
               a.moneda,
               a.papel,
               b.ituing
          into ln_modulo,
               ln_ctnro,
               ln_itoper,          
               ln_itsubo,          
               ln_sucdes,          
               ln_ittope,          
               ln_moneda,          
               ln_papel,
               lc_codusu       
          from fsd016 a,
               fsd015 b
         where a.pgcod  = b.pgcod
           and a.itsuc  = b.itsuc
           and a.itmod  = b.itmod
           and a.ittran = b.ittran
           and a.itnrel = b.itnrel
           and a.pgcod  = P_N_PGCOD
           and a.itsuc  = P_N_ITSUC
           and a.itmod  = P_N_ITMOD
           and a.ittran = P_N_ITTRAN
           and a.itnrel = P_N_ITNREL
           and a.itord  = P_N_ITORD
           and a.itsbor = P_N_ITSBO;
    exception
    when others then            
      ln_ctnro := 0;   
      lc_coderr := '001';
      lc_msgerr := lc_coderr||' - '||'No se encontró cuenta cliente';
      return;
    end;    
    
    if ln_ctnro > 0 then
      --Obtenemos mail de correspondencia para envio de correo y celular de correspondencia para afiliación.
      begin
        select a.pepais,
               a.petdoc,
               a.pendoc
          into ln_pais,   
               ln_tipdoc, 
               ln_numdoc    
          from fsr008 a 
         where a.pgcod = 1 
           and a.ctnro = ln_ctnro
           and a.ttcod = 1
           and a.cttfir = 'T';           
      Exception
      when others then  
           ln_pais   := 0;     
           ln_tipdoc := 0; 
           ln_numdoc := '';  
           lc_coderr := '002';
           lc_msgerr := lc_coderr||' - '||'No se encontró cuenta en FSR008';
           return;                    
      end;
      
      if ln_pais > 0 then
        --fecha de sistema
        begin 
          select a.pgfape 
            into ld_fecpro 
            from fst017 a 
           where a.pgcod = 1; 
        exception 
        when others then 
          ld_fecpro := trunc(sysdate);
        end;
        --correo
        begin
          select substr(a.pextxt,1,instr(a.pextxt,'\')-1)
            into lc_mail
            from fsx001 a
           where a.pepais = ln_pais
             and a.petdoc = ln_tipdoc
             and a.pendoc = ln_numdoc
             and a.txcod  = 0
             and a.pexren = 99;             
        Exception
        when others then  
             lc_mail := '';  
        end;
        
        --validar email
        begin
          -- Call the procedure
          pq_cl_volcado_campana.sp_valida_mail(p_c_mail => trim(lc_mail),
                                               p_c_error => lc_indmail
                                               );
        end;
                 
        --celular
        begin
          select a.dotelfp
            into lc_celular
            from fsr005 a,
                 sngc17 b
           where a.pepais = b.sngc17pais
             and a.petdoc = b.sngc17tdoc
             and a.pendoc = b.sngc17ndoc
             and a.pepais = ln_pais
             and a.petdoc = ln_tipdoc
             and a.pendoc = ln_numdoc
             and a.docod  = b.sngc17dcod
             and b.sngc17corr = 99
             and b.sngc16ttel <> 2
             and a.docod  = 2;
        Exception
        when others then  
             lc_celular := '';  
        end;  
        
        --validar celular
        begin
          select length(to_number(trim(lc_celular)))
            into ln_len
            from dual;
          if ln_len = 9 then
             lc_indcelu := 'S'; 
          else
             lc_indcelu := 'N';    
          End If;    
        Exception
        when others then  
             lc_indcelu := 'N'; 
        end;   
                
        If lc_indmail ='S' and lc_indcelu = 'S' then
           lc_tipo := 'A';
        End if;

        If lc_indmail ='S' and lc_indcelu = 'N' then
           lc_tipo := 'M';
        End if;
        
        If lc_indmail ='N' and lc_indcelu = 'S' then
           lc_tipo := 'S';
        End if;
        
        If lc_indmail ='N' and lc_indcelu = 'N' then
           lc_tipo := 'N';
        End if;
        
        --Obtenemos el diferenciador para afiliación
        begin
          Select substr(a.tp1desc,1,1)
            into lv_ide
            from fst198 a
           where a.tp1cod   = 1
             and a.tp1cod1  = 10825
             and a.tp1corr1 = 74
             and a.tp1corr2 = 1
             and a.tp1nro1  = P_N_ITMOD
             and a.tp1nro2  = P_N_ITTRAN;
        exception
        when no_data_found then  
          lv_ide := '';
          lc_coderr := '004';
          lc_msgerr := lc_coderr||' - '||'No esta parametrizado el identificador de alerta';          
          return; 
        when others then
          lc_coderr := '005';
          lc_msgerr := lc_coderr||' - '||sqlerrm;                              
          return; 
        end;
                                 
        lc_cadena := lv_ide||lpad(ln_ctnro,9,'0')||lpad(ln_moneda,3,'0')||lpad(ln_itoper,9,'0');--C = corresponsal
        --validamos si es transacción normal o extorno
        If P_N_ITMOD > 500 then  
           ld_fecdes := ld_fecpro;
           lc_tipo   := 'N';
           lc_usudes := lc_codusu;
        Else
           ld_fecdes := null;
           lc_usudes := null;
        End If;    
        
        if lc_tipo <> 'N' then
          -- Call the procedure
          pq_ah_reg_alertaafiliacion.sp_ah_registra_afiliacion(p_c_jaqy660tip  => 'C',
                                                               p_n_jaqy660pgo  => 1,
                                                               p_n_jaqy660suc  => ln_sucdes,
                                                               p_n_jaqy660mod  => ln_modulo,
                                                               p_n_jaqy660mda  => ln_moneda,
                                                               p_n_jaqy660cta  => ln_ctnro,
                                                               p_n_jaqy660pap  => ln_papel,
                                                               p_n_jaqy660ope  => ln_itoper,
                                                               p_n_jaqy660sub  => ln_itsubo,
                                                               p_n_jaqy660top  => ln_ittope,
                                                               p_d_jaqy660fch  => ld_fecpro,
                                                               p_c_jaqy660usu  => lc_codusu,
                                                               p_c_jaqy660tpr  => 'C',
                                                               p_c_jaqy660tme  => lc_tipo,
                                                               p_c_jaqy660afi  => lc_mail,
                                                               p_c_jaqy660fde  => ld_fecdes,
                                                               p_c_jaqy660ude  => lc_usudes,
                                                               p_c_jaqy660aux1 => to_number(trim(lc_celular)),
                                                               p_c_jaqy660aux2 => lc_cadena,
                                                               p_c_hora        => TO_CHAR(sysdate,'HH24:mi:ss'),
                                                               p_c_code        => lc_coderr,
                                                               p_c_error       => lc_msgerr
                                                               );   
        end if;                                                                 
      End If;         
    End If; 
  Exception
  when others then
    lc_coderr := '003';
    lc_msgerr := lc_coderr||' - '||sqlerrm;
  End SP_AH_AFILIA_CREDITO;
  PROCEDURE SP_AH_REGISTRA_ICHANNEL(P_N_JAQY660CTA  IN NUMBER,
                                    P_C_JAQY660TME  IN VARCHAR2,
                                    P_C_JAQY660AFI  IN VARCHAR2,
                                    P_C_JAQY660AUX1 IN NUMBER,
                                    P_C_JAQY660AUX2 IN VARCHAR2,
                                    p_c_code        out varchar2,
                                    p_c_error       out varchar2
                                   ) IS
  
  C_DATO_NOMBRE VARCHAR2(100);
  C_DATO_SEXO VARCHAR2(1);
  C_DATO_MAIL VARCHAR2(65);
  C_DATO_CELULAR VARCHAR2(20);  
  V_MAIL VARCHAR2(1);
  V_SMS VARCHAR2(1);
  BEGIN
      P_C_CODE := '0';
      C_DATO_NOMBRE  := '';
      C_DATO_SEXO := '';
      C_DATO_MAIL := '';
      C_DATO_CELULAR := ''; 
      V_MAIL := '';
      V_SMS  := '';
     
     
       If P_C_JAQY660TME  = 'M' THEN
          C_DATO_MAIL := P_C_JAQY660AFI;
          V_MAIL := 'S';
          V_SMS  := 'N';
                
       ELSIF P_C_JAQY660TME  = 'S' THEN
          C_DATO_CELULAR := P_C_JAQY660AUX1;
          V_MAIL := 'N';
          V_SMS  := 'S';
       ELSIF P_C_JAQY660TME  = 'A' THEN
          C_DATO_CELULAR := P_C_JAQY660AUX1;
          C_DATO_MAIL := P_C_JAQY660AFI;
          V_MAIL := 'S';
          V_SMS  := 'S'; 
       ELSIF P_C_JAQY660TME  = 'N' THEN   
          C_DATO_CELULAR := '';
          C_DATO_MAIL := '';
          V_MAIL := 'N';
          V_SMS  := 'N';          
       End if;
       SH_DATOS_CLIENTES_ICHANNEL(P_N_JAQY660CTA,
                                  C_DATO_NOMBRE,
                                  C_DATO_SEXO); 
                                  
                               
       BEGIN                          
          INSERT INTO /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                  nombre_cliente,
                                                  mail_cliente,
                                                  celular_cliente,
                                                  sexo_cliente,
                                                  enviar_celular,
                                                  enviar_mail)
                                           values(P_C_JAQY660AUX2,  ---P_N_JAQY660CTA,
                                                  C_DATO_NOMBRE,
                                                  decode(substr(P_C_JAQY660AUX2,1,1),'C','',C_DATO_MAIL),
                                                  C_DATO_CELULAR,
                                                  C_DATO_SEXO,
                                                  V_SMS,                                                  
                                                  decode(substr(P_C_JAQY660AUX2,1,1),'C','N',V_MAIL)
                                                  );
           commit;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                 BEGIN
                    IF P_C_JAQY660TME = 'N' THEN
                      UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente = '',
                              celular_cliente = '',
                              enviar_celular = 'N',
                              enviar_mail = 'N'
                        WHERE codigo_cliente =P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'M' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente = decode(substr(P_C_JAQY660AUX2,1,1),'C','',C_DATO_MAIL),
                              celular_cliente = '',
                              enviar_celular = 'N',
                              enviar_mail = decode(substr(P_C_JAQY660AUX2,1,1),'C','N','S')
                        WHERE codigo_cliente = P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'S' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente =  '',
                              celular_cliente = C_DATO_CELULAR ,
                              enviar_celular = 'S',
                              enviar_mail = 'N'
                        WHERE codigo_cliente = P_C_JAQY660AUX2;
                    ELSIF  P_C_JAQY660TME = 'A' THEN
                     UPDATE /*CLIENTES_AFILIADOS@ichannel*/ichannelalert.CLIENTES_AFILIADOS
                          SET mail_cliente =  C_DATO_MAIL,
                              celular_cliente = C_DATO_CELULAR ,
                              enviar_celular = 'S',
                              enviar_mail = 'S'
                        WHERE codigo_cliente = P_C_JAQY660AUX2;    
                    END IF;
                    COMMIT;
                 EXCEPTION
                  WHEN OTHERS THEN
                     P_C_CODE  := sqlcode;
                     P_C_ERROR := sqlerrm;
                 END;
        END;
  END SP_AH_REGISTRA_ICHANNEL;          
  PROCEDURE SP_AH_CORREO_REGISTRO(P_D_FECPRO      IN DATE,
                                  P_C_CODUSU      IN VARCHAR2,
                                  P_N_NUMCTA      IN NUMBER,
                                  P_N_CODAGE      IN NUMBER,                  
                                  P_C_CADENA      IN VARCHAR2,
                                  P_C_JAQY660TME  IN VARCHAR2,
                                  P_C_JAQY660AFI  IN VARCHAR2,--MAIL
                                  P_C_JAQY660AUX1 IN VARCHAR2,--CELULAR
                                  p_c_coderr      out varchar2,
                                  p_c_msgerr      out varchar2
                                 ) IS  
  lv_cadena    varchar2(4000):='';  
  lc_agencia   char(30);    
  ll_mensaje   CLOB;
  lv_mensaje   VARCHAR2(32767);      
  lv_destinos  VARCHAR2(32767):='';   
  lv_nombre    VARCHAR2(160):='';  
  lv_medio     VARCHAR2(100):='';                                               
  lv_remitente VARCHAR2(100):= 'notificacionesbantotal@cajaarequipa.pe';
  lv_asunto    VARCHAR2(100):= '';
  lc_hora      VARCHAR2(8):= to_char(sysdate,'HH24:mi:ss');      
  x            Number(9):=0;
  y            Number(9):=0;     
  lv_producto  VARCHAR2(27):='';    
  ln_pais       NUMBER(3);
  ln_tipdoc     NUMBER(2);
  lc_numdoc     CHAR(12);                        
  BEGIN
  p_c_coderr := '000';                                                      
  lc_hora    := to_char(sysdate,'HH24:mi:ss'); 

    lv_cadena := replace(P_C_CADENA,'C','');
    
    --OBTENEMOS LA AGENCIA
    BEGIN
      select x.scnom 
        into lc_agencia 
        from fst001 x 
       where x.pgcod = 1 
         and x.sucurs = P_N_CODAGE;
    EXCEPTION
    WHEN OTHERS THEN
      lc_agencia := null;
    END;    
    --OBTENEMOS NOMBRE DEL CLIENTE
    BEGIN
      select trim(y.pfape1)||' '||trim(y.pfape2)||' '||trim(y.pfnom1)||' '||trim(y.pfnom2),
             y.pfpais,
             y.pftdoc,
             y.pfndoc     
        into lv_nombre,
             ln_pais,
             ln_tipdoc,
             lc_numdoc         
        from fsr008 x, 
             fsd002 y
       where x.pepais = y.pfpais
         and x.petdoc = y.pftdoc
         and x.pendoc = y.pfndoc
         and x.pgcod = 1 
         and x.ctnro = P_N_NUMCTA
         and x.ttcod = 1
         and x.cttfir = 'T';
    EXCEPTION
    WHEN OTHERS THEN
      lv_nombre := null;
      ln_pais   := 0;
      ln_tipdoc := 0;
      lc_numdoc := '';
    END; 
     
    if P_C_JAQY660TME = 'S' then
       lv_medio := 'SMS'; 
    End if; 
    if P_C_JAQY660TME = 'M' then
       lv_medio := 'Mail'; 
    End if;      
    if P_C_JAQY660TME = 'A' then
       lv_medio := 'Mail y SMS'; 
    End if;      
 
    lv_destinos := TRIM(P_C_JAQY660AFI);            
    dbms_lob.createtemporary(ll_mensaje, TRUE);              
    if P_C_JAQY660TME <> 'N' then
        lv_asunto := 'AFILIACION A ENVIO DE NOTIFICACIONES POR USO DE TARJETA DE DEBITO VISA';      
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a):</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">'||lv_nombre||'</p>'||        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjuntamos la afiliación(s) realizadas en la agencia: '||trim(lc_agencia)||' el día '||to_char(P_D_FECPRO,'dd/mm/rrrr')||' a las '||lc_hora||'.</p>'||     
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Usuario que realizó la operación: '||trim(P_C_CODUSU)||'</p>' ||                    
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Medio de envío: '||trim(lv_medio)||'</p>' ||                       
                      '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
                
        if P_C_JAQY660TME = 'S' then
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Celular: '||trim(P_C_JAQY660AUX1)||'</p>' ||                       
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);        
        End If;    
        if P_C_JAQY660TME = 'M' then
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">E-mail: '||trim(P_C_JAQY660AFI)||'</p>' ||                       
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
        End If;     
        if P_C_JAQY660TME = 'A' then
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">E-mail: '||trim(P_C_JAQY660AFI)||'</p>' ||                       
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>'||        
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Celular: '||trim(P_C_JAQY660AUX1)||'</p>' ||                       
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
        End If;     
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Productos afiliados: </strong></p>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
        
    Else
        lv_asunto := 'DESAFILIACION A ENVIO DE NOTIFICACIONES POR USO DE TARJETA DE DEBITO VISA';       
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a):</p>' ||  
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">'||lv_nombre||'</p>'||        
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Adjuntamos la(s) desafiliaciones realizadas en la agencia: '||trim(lc_agencia)||' el día '||to_char(P_D_FECPRO,'dd/mm/rrrr')||' a las '||lc_hora||'.</p>'||     
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Usuario que realizó la operación: '||trim(P_C_CODUSU)||'</p>' ||                    
                      '<p "font-family: Arial, sans-serif; font-size: 14px;"></p>';          
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);              
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Productos desafiliados: </strong></p>';
        lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                            
    End If;
    
    if lv_destinos is null then
        --buscamos correo
        begin
          select substr(c.pextxt,1,instr(c.pextxt,'\')-1)
            into lv_destinos
            from fsx001 c 
           where c.pepais = ln_pais
             and c.petdoc = ln_tipdoc
             and c.pendoc = lc_numdoc
             and c.txcod  = 0
             and trim(c.pextxt) is not null
             and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(c.pextxt,1,instr(c.pextxt,'\')-1))) = 'S'
             and rownum =1;
        exception
        when others then                 
          lv_destinos := null;
        end;      
    End If;  
    
    lv_mensaje := '<table width="1000" height="54" border="0">'||
                  '  <tbody> ';     
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
    --FOR DE PRODUCTOS
      x:= 0;
      y:=0;
      While y >= x loop        
        select instr(lv_cadena,'-',x+1) into y from dual;
        lv_producto := substr(lv_cadena,x+1,y-(x+1));
        if y > 0 then
          lv_mensaje := 
                      '<tr>'||
                      ' <td width="784" "font-family: Arial, sans-serif; font-size: 14px;">'||trim(lv_producto)||'</td>'||
                      '</tr>'; 
          lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                         
          x:= y;
        end if;
      End loop;
    --FIN DE FOR DE PRODUCTOS     
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Cordialmente.</strong></p>'||                                                        
                  '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Caja Arequipa</strong></p>';                                          
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                                    
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
    
    if lv_destinos is not null then  
      begin
              -- Call the procedure
              p_c_coderr := '000';
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
            If p_c_coderr <> '000'then            
                PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 4,--RENVIO AFILIACION/DESAFILIACION NOTIFICACIONES
                                                          P_C_ASUNTO => lv_asunto,
                                                          P_C_DESPAR => lv_destinos,
                                                          P_C_DESCOC => null,
                                                          P_C_DESCCO => null,
                                                          P_C_MENSAJ => lv_destinos,
                                                          P_C_REMITE => lv_remitente,
                                                          P_C_DIRECT => null,
                                                          P_C_ADJUNT => null,
                                                          P_N_AUX001 => null ,
                                                          P_N_AUX002 => null,
                                                          P_N_AUX003 => null,
                                                          P_N_AUX004 => null,
                                                          P_D_AUX005 => null,
                                                          P_D_AUX006 => null,
                                                          P_C_AUX007 => null,
                                                          P_C_AUX008 => null,
                                                          P_C_AUX009 => null,
                                                          p_c_coderr => p_c_coderr,
                                                          p_c_msgerr => p_c_msgerr
                                                          );                          
            End If;                                                 
      exception
      when others then  
           p_c_coderr := '00x';
           p_c_msgerr := sqlerrm;                                                   
      end;
    end if;
    dbms_lob.freetemporary(ll_mensaje);                 
  EXCEPTION
  WHEN OTHERS THEN                   
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
  END SP_AH_CORREO_REGISTRO;                                 
end PQ_AH_REG_ALERTAAFILIACION;
/

