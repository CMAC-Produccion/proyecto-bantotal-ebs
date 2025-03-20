create or replace package PQ_CR_EQUIFAX is

-- *****************************************************************
-- Nombre                     : PQ_CR_EQUIFAX
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 10/01/2021
-- Autor de Creación          : Alonso Pacheco Huachaca
-- Uso                        : Extrae información para reporte Crediticio Equifax
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 
-- Autor de Modificación      : 
-- Descripción de Modificación: 
-- 
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  PROCEDURE sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_ENTID IN VARCHAR2,P_C_TICTA IN VARCHAR2, 
                                  P_C_FECHA OUT VARCHAR2, P_D_FECMOR OUT DATE ); 
                                  
  PROCEDURE sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_ENTID IN VARCHAR2, 
                                  P_C_FECHA OUT VARCHAR2, P_D_FECMOR OUT DATE );                               
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_importacion_exportacion( P_N_SERIAL IN NUMBER, 
                                           P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2 ); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_actualizar_mora( P_N_SERIAL IN NUMBER );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_actualizar_mora_reg( P_N_SERIAL IN NUMBER );
                                 
end PQ_CR_EQUIFAX;
/

create or replace package body PQ_CR_EQUIFAX is

  PROCEDURE sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_ENTID IN VARCHAR2, P_C_TICTA IN VARCHAR2,
                                  P_C_FECHA OUT VARCHAR2, P_D_FECMOR OUT DATE )
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_fecha_mora_max
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/01/2022
  -- Autor de Creación          : Alonso Pacheco Huachaca
  -- Uso                        : CALCULA LA FECHA EN LA QUE OCURRIÓ LA MORA MÁXIMA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                              P_C_ENTID ( ENTIDAD ) 
  --                              P_C_TICTA ( TIPO CUENTA CARTERA ) 
  -- Parámetros de Salida       : P_C_FECHA ( fecha varchar de maxima mora )
  --                            : P_D_FECMOR ( fecha de maxima mora )
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
     ln_maximora number(5) := 0;      
  BEGIN                    
     BEGIN      
       SELECT MAX(AQPB515BMAXMO) INTO ln_maximora             
             FROM AQPB515B WHERE AQPB515BSERIAL = P_N_SERIAL AND SUBSTR(AQPB515BENTID,1,70) = P_C_ENTID AND AQPB515BTICTA = P_C_TICTA;
       
       SELECT MAX(AQPB515BULTAC) INTO P_D_FECMOR             
             FROM AQPB515B WHERE AQPB515BSERIAL = P_N_SERIAL AND SUBSTR(AQPB515BENTID,1,70) = P_C_ENTID AND AQPB515BTICTA = P_C_TICTA
                             AND AQPB515BMAXMO = ln_maximora;
                             
       P_C_FECHA := to_char(P_D_FECMOR,'MON-RRRR');
     EXCEPTION WHEN OTHERS THEN
        P_D_FECMOR := to_date('01/01/0001', 'DD/MM/YYYY');
        P_C_FECHA := to_char(P_D_FECMOR,'MON-RRRR');
     END;                                                   
  END sp_cr_fecha_mora_max;
  
  PROCEDURE sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_ENTID IN VARCHAR2,
                                  P_C_FECHA OUT VARCHAR2, P_D_FECMOR OUT DATE )
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_fecha_mora_max
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/01/2022
  -- Autor de Creación          : Alonso Pacheco Huachaca
  -- Uso                        : CALCULA LA FECHA EN LA QUE OCURRIÓ LA MORA MÁXIMA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                              P_C_ENTID ( ENTIDAD ) 
  --                              P_C_TICTA ( TIPO CUENTA CARTERA ) 
  -- Parámetros de Salida       : P_C_FECHA ( fecha varchar de maxima mora )
  --                            : P_D_FECMOR ( fecha de maxima mora )
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
     ln_maximora number(5) := 0;      
  BEGIN                    
     BEGIN      
       SELECT MAX(AQPB515BMAXMO) INTO ln_maximora             
             FROM AQPB515B WHERE AQPB515BSERIAL = P_N_SERIAL AND SUBSTR(AQPB515BENTID,1,75) = P_C_ENTID;
       
       SELECT MAX(AQPB515BULTAC) INTO P_D_FECMOR             
             FROM AQPB515B WHERE AQPB515BSERIAL = P_N_SERIAL AND SUBSTR(AQPB515BENTID,1,75) = P_C_ENTID
                             AND AQPB515BMAXMO = ln_maximora;
                             
       P_C_FECHA := to_char(P_D_FECMOR,'MON-RRRR');
     EXCEPTION WHEN OTHERS THEN
        P_D_FECMOR := to_date('01/01/0001', 'DD/MM/YYYY');
        P_C_FECHA := to_char(P_D_FECMOR,'MON-RRRR');
     END;                                                   
  END sp_cr_fecha_mora_max;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_importacion_exportacion( P_N_SERIAL IN NUMBER, 
                                           P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2)
  IS     
  -- *****************************************************************
  -- Nombre                     : sp_cr_importacion_exportacion
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 11/01/2022
  -- Autor de Creación          : Alonso Pacheco Huachaca
  -- Uso                        : CARGA DE DATOS IMPORTACION  Y EXPORTACION
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA )
  --                            : P_C_USUARIO ( USUARIO )
  --                            : P_C_MAQUINA ( MAQUINA )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************  
  cursor c_imp_exp is 
      select AQPB515Jserial,anio, sum(num_op_imp) as num_op_imp ,sum(totfob_imp)as totfob_imp,sum(fob_flet_imp)as fob_flet_imp,sum(cant_pai_imp) as cant_pai_imp,sum(num_op_exp)as num_op_exp,sum(totfob_exp)as totfob_exp,sum(cant_pai_exp)as cant_pai_exp
      from 
      (
            select AQPB515Jserial,
                   EXTRACT(year FROM AQPB515Jfepre) as anio,
                   sum(AQPB515Jnuope) as num_op_imp,
                   sum(AQPB515Jtofob) as totfob_imp,
                   sum(AQPB515Jfofls) as fob_flet_imp,
                   sum(AQPB515Jnpai) as cant_pai_imp,
                   0 num_op_exp,
                   0 totfob_exp,
                   0 cant_pai_exp
             from AQPB515J
             where AQPB515Jserial = P_N_SERIAL
             group by AQPB515Jserial, EXTRACT(year FROM AQPB515Jfepre) --importaciones
          union
              select AQPB515Kserial,                     
                     EXTRACT(year FROM AQPB515Kfeexp) as anio,
                     0 num_op_imp,
                     0 totfob_imp,
                     0 fob_flet_imp,
                     0 cant_pai_imp,
                     sum(AQPB515Knuope) num_op_exp,
                     sum(AQPB515Ktofob) as totfob_exp,
                     sum(AQPB515Knpai) as cant_pai_exp
               from AQPB515K
               where AQPB515Kserial = P_N_SERIAL
               group by AQPB515Kserial, EXTRACT(year FROM AQPB515Kfeexp) -- exportaciones
      )group by AQPB515Jserial,anio
      order by anio desc;  
      
      ln_tipo AQPB908C.AQPB908Ctip%type; 
      ln_corr AQPB908C.AQPB908Cnro%type;                     
  BEGIN
  ln_tipo:=5;
  ln_corr:=0;
  
      delete from AQPB908C
    where AQPB908Cusu = P_C_USUARIO
      and AQPB908Cmaq = P_C_MAQUINA
      and AQPB908Ctip = ln_tipo;     
     commit;
     
     
   for de in c_imp_exp loop    
           
              ln_corr := ln_corr + 1;
               insert into AQPB908C 
                  (AQPB908Cusu,
                   AQPB908Cmaq,
                   AQPB908Ctip,
                   AQPB908Cnro,
                   AQPB908Cnum1,
                   AQPB908Cnum2,
                   AQPB908Cnum3,
                   AQPB908Cnum4,
                   AQPB908Cnum5,
                   AQPB908Cnum6,
                   AQPB908Cnum7,
                   AQPB908Cnum8
                   )  
               values
                  (P_C_USUARIO,
                   P_C_MAQUINA,
                   ln_tipo,
                   ln_corr,
                   de.anio,
                   de.num_op_imp,
                   de.totfob_imp,
                   de.fob_flet_imp,
                   de.cant_pai_imp,
                   de.num_op_exp,
                   de.totfob_exp,
                   de.cant_pai_exp
                    );    
               COMMIT;                              
           end loop;
                                                 
  END sp_cr_importacion_exportacion;  
    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_actualizar_mora( P_N_SERIAL IN NUMBER)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_actualizar_mora
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 08/02/2022
  -- Autor de Creación          : Alonso Pacheco Huachaca
  -- Uso                        : ACTUALIZAR LA EDAD MORA Y MAXIMA MORA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- ***************************************************************** 
     ln_edadmora number(5);
     ln_maximora number(5);
     lc_edmora varchar2(5);
     lc_estado varchar2(5);
     lc_compor varchar2(50);
     ln_cont   number(5);
     ln_atraso number(5);     
     lc_atraso varchar2(10);
     V_AQPB515BCOMPOR VARCHAR2(50); 
     V_AQPB515BESTADO VARCHAR2(2); 
     V_AQPB515BFECVE  DATE; 
     V_AQPB515BULTAC  DATE;
     V_AQPB515BEMORA  VARCHAR2(3); 
     V_AQPB515BINDBO  VARCHAR2(3); 
     V_AQPB515BMAXMO  NUMERIC(10,2);
     V_AQPB515BSALAC  NUMERIC(10,2);
     V_AQPB515BCONCOD VARCHAR2(16);
     V_AQPB515BCREUSR VARCHAR2(30);
     V_AQPB515BCRETIM TIMESTAMP(6); 
     V_AQPB515BCONDIC VARCHAR2(30);
     V_AQPB515BMONED  VARCHAR2(10);
     
     CURSOR ENTIDADES IS
        SELECT DISTINCT AQPB515BULTAC, AQPB515BENTID, AQPB515BFECVE, AQPB515BNUMER, AQPB515BCONDIC
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO = '0'
        ORDER BY AQPB515BENTID, AQPB515BULTAC, AQPB515BFECVE;         
        
     CURSOR ENTIDADES_2 IS
        SELECT DISTINCT AQPB515BENTID, AQPB515BTICTA 
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO = '0';
        
     CURSOR ENTIDADES_3 IS
        SELECT AQPB515BENTID, AQPB515BTICTA, SUM(AQPB515BSALAC) AQPB515BSALAC
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO = '0'
        GROUP BY AQPB515BENTID, AQPB515BTICTA;
  BEGIN
     FOR I IN ENTIDADES LOOP
       ln_edadmora := 0;
       ln_atraso := 0;
       ln_cont := 0;
       lc_atraso := '';
       lc_estado := '17';
       lc_compor := '';
       BEGIN          
          --Dias de atraso a la ultima fecha reportada
          SELECT I.AQPB515BULTAC - I.AQPB515BFECVE INTO ln_edadmora FROM DUAL;           
          --Estado de la mora maxima
          IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN                
             lc_estado := '01';
          ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN                
             lc_estado := '17';
          ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
             lc_estado := '18';
          ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
             lc_estado := '19';
          ELSE
             lc_estado := '20';
          END IF;
          IF I.AQPB515BCONDIC = 'CARTCAST' AND ln_edadmora < 120 THEN
             lc_estado := '45';
          END IF;                  
          --Calcular el comportamiento de la deuda   
          FOR E IN 0..ABS(TRUNC(MONTHS_BETWEEN(I.AQPB515BFECVE,I.AQPB515BULTAC))) LOOP     
              ln_cont := ln_cont + 1;         
              SELECT ADD_MONTHS(I.AQPB515BULTAC,-E) - I.AQPB515BFECVE INTO ln_atraso FROM DUAL; 
              IF ln_atraso >= 0 AND ln_atraso < 30 THEN                
                 lc_atraso := 'N';
              ELSIF ln_atraso >= 30 AND ln_atraso < 60 THEN                
                 lc_atraso := '1';
              ELSIF ln_atraso >= 60 AND ln_atraso < 90 THEN
                 lc_atraso := '2';
              ELSIF ln_atraso >= 90 AND ln_atraso < 120 THEN
                 lc_atraso := '3';
              ELSIF ln_atraso >= 120 AND ln_atraso < 150 THEN
                 lc_atraso := '4';
              ELSIF ln_atraso >= 150 AND ln_atraso < 180 THEN
                 lc_atraso := 'J';
              ELSE
                 lc_atraso := 'J';
              END IF;       
              IF I.AQPB515BCONDIC = 'CARTCAST' THEN
                 lc_atraso := 'J';
              END IF;    
              IF ln_cont < 30 THEN
                  lc_compor := concat( lc_compor, lc_atraso );  
              END IF;  
          END LOOP;
          --Actualizar edad de la mora, estado y comportamiento           
          IF ln_edadmora > 730 THEN     
            IF ln_edadmora > 730 AND ln_edadmora <= 1095 THEN   
               lc_edmora := '903';
            ELSIF ln_edadmora > 1095 AND ln_edadmora <= 1460 THEN   
               lc_edmora := '904';
            ELSIF ln_edadmora > 1460 AND ln_edadmora <= 1825 THEN   
               lc_edmora := '905';  
            ELSE  
               lc_edmora := '906';     
            END IF;
            
               DBMS_OUTPUT.put_line('lc_edmora '|| lc_edmora);
            UPDATE AQPB515B SET AQPB515BEMORA = lc_edmora, 
                                AQPB515BESTADO = lc_estado, 
                                AQPB515BCOMPOR = lc_compor
                    WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = I.AQPB515BENTID
                      AND AQPB515BNUMER = I.AQPB515BNUMER AND AQPB515BINDBO = '0';
          ELSE                
            UPDATE AQPB515B SET AQPB515BEMORA = LPAD(TO_CHAR(ln_edadmora), 3, '0'), 
                                AQPB515BESTADO = lc_estado,
                                AQPB515BCOMPOR = lc_compor 
                     WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = I.AQPB515BENTID 
                       AND AQPB515BNUMER = I.AQPB515BNUMER AND AQPB515BINDBO = '0';
          END IF; 
       EXCEPTION WHEN 
                 OTHERS THEN                 
            UPDATE AQPB515B SET AQPB515BEMORA = '030', AQPB515BESTADO = '17', AQPB515BCOMPOR = '1'
                     WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = I.AQPB515BENTID 
                       AND AQPB515BNUMER = I.AQPB515BNUMER AND AQPB515BINDBO = '0';
       END;              
    END LOOP;
    
    --Actualiza en todos los registros la maxima mora por entidad
    FOR J IN ENTIDADES_2 LOOP
       ln_maximora := 0;
       BEGIN
         SELECT MAX(CAST(AQPB515BEMORA AS INT)) INTO ln_maximora 
                FROM AQPB515B 
         WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
           AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO = '0';
         
         UPDATE AQPB515B SET AQPB515BMAXMO = ln_maximora 
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO = '0';
       END;   
    END LOOP;
    
    --Se inserta registro con saldo total con AQPB515BINDBO = '3' para el reporte
    FOR K IN ENTIDADES_3 LOOP       
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '17'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';
       BEGIN  
         
         --Busca la mora maxima por entidad
         BEGIN
           SELECT MAX(AQPB515BULTAC) INTO V_AQPB515BULTAC FROM AQPB515B
                  WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = K.AQPB515BENTID 
                    AND AQPB515BTICTA = K.AQPB515BTICTA AND AQPB515BINDBO = '0'; 
         EXCEPTION 
           WHEN OTHERS THEN
             ln_maximora := 0;
         END;
         --Busca el periodo minimo de la entidad
         BEGIN      
           SELECT MIN(AQPB515BFECVE) INTO V_AQPB515BFECVE FROM AQPB515B
                  WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = K.AQPB515BENTID AND AQPB515BTICTA = K.AQPB515BTICTA
                    AND AQPB515BULTAC = V_AQPB515BULTAC AND AQPB515BINDBO = '0';
           EXCEPTION 
            WHEN OTHERS THEN
                 DBMS_OUTPUT.put_line('Error al buscar minima fecha.');
         END;   
         --Obtiene los datos, el periodo minimo presenta el comportamiento mas completo
         BEGIN         
           SELECT AQPB515BCOMPOR, AQPB515BESTADO, AQPB515BFECVE, AQPB515BEMORA, AQPB515BMAXMO, AQPB515BSALAC,
                  AQPB515BCONCOD, AQPB515BCREUSR, AQPB515BCRETIM, AQPB515BCONDIC, AQPB515BMONED, AQPB515BINDBO
             INTO V_AQPB515BCOMPOR, V_AQPB515BESTADO, V_AQPB515BFECVE, V_AQPB515BEMORA, V_AQPB515BMAXMO, V_AQPB515BSALAC, 
                  V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC, V_AQPB515BMONED, V_AQPB515BINDBO
             FROM AQPB515B
           WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = K.AQPB515BENTID AND AQPB515BTICTA = K.AQPB515BTICTA
             AND AQPB515BULTAC = V_AQPB515BULTAC AND AQPB515BFECVE = V_AQPB515BFECVE AND AQPB515BINDBO = '0' AND ROWNUM = 1;           
         EXCEPTION 
            WHEN OTHERS THEN
                 DBMS_OUTPUT.put_line('No se encontro datos. '||K.AQPB515BENTID);
                 DBMS_OUTPUT.put_line('No se encontro datos. '||K.AQPB515BTICTA);
                 DBMS_OUTPUT.put_line('No se encontro datos. '||V_AQPB515BFECVE);
                 DBMS_OUTPUT.put_line('No se encontro datos. '||V_AQPB515BULTAC);
         END;   
         IF V_AQPB515BINDBO = '0' THEN
           V_AQPB515BINDBO := '3';
         ELSE
           V_AQPB515BINDBO := '4';
         END IF;
         BEGIN
            INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                   AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                   AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                   AQPB515BMONED,AQPB515BFECAP) 
            VALUES(P_N_SERIAL,' ',V_AQPB515BULTAC,'999',K.AQPB515BENTID,V_AQPB515BESTADO,V_AQPB515BFECVE,
                   V_AQPB515BCOMPOR,V_AQPB515BEMORA,K.AQPB515BTICTA,V_AQPB515BINDBO,K.AQPB515BSALAC,0.00,
                   V_AQPB515BMAXMO,'18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                   V_AQPB515BMONED,V_AQPB515BFECVE); 
             COMMIT;
          EXCEPTION 
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Error al insertar total entidad.');
          END; 
       END;   
    END LOOP;
  END sp_cr_actualizar_mora;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_actualizar_mora_reg(P_N_SERIAL IN NUMBER)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_actualizar_mora_reg
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 08/02/2022
  -- Autor de Creación          : Alonso Pacheco Huachaca
  -- Uso                        : ACTUALIZAR LA EDAD MORA Y MAXIMA MORA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL( IDENTIFICADOR CONSULTA )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- ***************************************************************** 
     ln_edadmora number(5);
     ln_maximora number(5);
     lc_estado varchar2(5);
     lc_compor varchar2(50);
     lc_condic varchar2(50);
     ln_cont   number(5);
     ln_atraso number(5);     
     lc_atraso varchar2(10);
     ld_maxFecha date;
     ld_minFecha date;
     ld_maxfecALL date;
     ln_flagEst number(3);
     ln_flagRCC number(2);
     V_AQPB515BCOMPOR VARCHAR2(50); 
     V_AQPB515BESTADO VARCHAR2(2); 
     V_AQPB515BFECVE  DATE; 
     V_AQPB515BFECAP  DATE;
     V_AQPB515BULTAC  DATE;
     V_AQPB515BEMORA  VARCHAR2(3); 
     V_AQPB515BINDBO  VARCHAR2(3); 
     V_AQPB515BMAXMO  NUMERIC(10,2);
     V_AQPB515BSALAC  NUMERIC(10,2);
     V_AQPB515BCUPO   NUMERIC(10,2);
     V_AQPB515BCONCOD VARCHAR2(16);
     V_AQPB515BCREUSR VARCHAR2(30);
     V_AQPB515BCRETIM TIMESTAMP(6); 
     V_AQPB515BCONDIC VARCHAR2(30);
     V_AQPB515BMONED  VARCHAR2(10);
     L_AQPB515BENTID  VARCHAR2(150);
     L_AQPB515BTICTA  VARCHAR2(10);
     
     --LINEAS DE CREDITO
     CURSOR ENTIDADES(P_D_FECHA DATE) IS     
        SELECT AQPB515ACOENT, AQPB515ANOENT
          FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOPUC LIKE '81_9230_%'
          AND AQPB515AFEACT = P_D_FECHA
        GROUP BY AQPB515ACOENT, AQPB515ANOENT;      
          
     --CREDITOS CASTIGADOS
     CURSOR ENTIDADES_0 IS     
        SELECT AQPB515ACOENT, AQPB515ANOENT, MAX(AQPB515AFEACT) AQPB515AFEACT
          FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOPUC LIKE '81_302%'
        GROUP BY AQPB515ACOENT, AQPB515ANOENT;  
     
     CURSOR RCC(P_V_CODENT VARCHAR2) IS
        SELECT AQPB515ACONDI, AQPB515AFEACT
            FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = P_V_CODENT
              AND AQPB515ACOPUC LIKE '81_302%'
        GROUP BY AQPB515ACONDI, AQPB515AFEACT
        ORDER BY AQPB515AFEACT DESC;
        
     --SALDOS  
     CURSOR ENTIDADES_1 IS          
        SELECT AQPB515ACOENT, AQPB515ANOENT, MAX(AQPB515AFEACT) AQPB515AFEACT
               FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL 
              AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') 
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0303') 
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0308'))
        GROUP BY AQPB515ACOENT, AQPB515ANOENT;
        
     --GASTOS
     CURSOR ENTIDADES_1_2 IS          
        SELECT AQPB515ACOENT, AQPB515ANOENT, MAX(AQPB515AFEACT) AQPB515AFEACT
             FROM AQPB515A
          WHERE AQPB515ASERIAL = P_N_SERIAL 
                AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]') OR REGEXP_LIKE(aqpb515acopuc, '^71.[1-4]'))
                AND NOT REGEXP_LIKE(aqpb515acopuc,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601')
          GROUP BY AQPB515ACOENT, AQPB515ANOENT;
                      
     CURSOR RCC_1(P_V_CODENT VARCHAR2) IS
        SELECT AQPB515ACONDI, AQPB515AFEACT
            FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = P_V_CODENT
              AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') 
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0303') 
              OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0308'))
        GROUP BY AQPB515ACONDI, AQPB515AFEACT;        
        
     CURSOR RCC_1_2(P_V_CODENT VARCHAR2) IS
        SELECT AQPB515ACONDI, AQPB515AFEACT
            FROM AQPB515A
        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = P_V_CODENT
              AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]') OR REGEXP_LIKE(aqpb515acopuc, '^71.[1-4]'))
              AND NOT REGEXP_LIKE(aqpb515acopuc,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601')
        GROUP BY AQPB515ACONDI, AQPB515AFEACT;        
                       
     CURSOR ENTIDADES_2 IS
        SELECT DISTINCT AQPB515BCODSU, AQPB515BENTID, AQPB515BTICTA 
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO IN ('1','5'); 
           
     CURSOR ENTIDADES_2_5(P_V_CODENT VARCHAR2, P_V_TICTA VARCHAR2) IS
        SELECT DISTINCT AQPB515BENTID, AQPB515BULTAC, AQPB515BFECVE,
                        AQPB515BCONDIC, CAST(AQPB515BEMORA AS INT) AQPB515BEMORA
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO IN ('1','5')
          AND AQPB515BCODSU = P_V_CODENT AND AQPB515BTICTA = P_V_TICTA
        ORDER BY AQPB515BENTID, AQPB515BULTAC DESC, AQPB515BFECVE;
                 
     CURSOR ENTIDADES_3 IS
        SELECT DISTINCT AQPB515BCODSU, AQPB515BENTID, AQPB515BTICTA 
          FROM AQPB515B
        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BINDBO IN ('1','5')
          AND AQPB515BNUMER = 998;   
        
  BEGIN
     
     ld_maxFecha := TO_DATE('01/01/0001','dd/MM/yyyy');    
     ln_flagRCC := 0;   
     --Obtener maxima fecha reportada         
     BEGIN                      
       SELECT MAX(AQPB515AFEACT) INTO ld_maxFecha FROM AQPB515A
              WHERE AQPB515ASERIAL = P_N_SERIAL;
     EXCEPTION 
        WHEN OTHERS THEN
             ld_maxFecha  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
     END; 
        
     --ITERACION ENTIDADES MODULO SBS     
     FOR J IN ENTIDADES_2 LOOP
              
        L_AQPB515BENTID := '';
        L_AQPB515BTICTA := '';
        ln_cont := 0;
        lc_compor := ''; 
        lc_estado := '17'; 
        
        FOR I IN ENTIDADES_2_5(J.AQPB515BCODSU, J.AQPB515BTICTA) LOOP
           ln_edadmora := 0;
           lc_atraso := '';
           lc_condic := '';        
           BEGIN          
              --Dias de atraso a la ultima fecha reportada
              ln_edadmora := I.AQPB515BEMORA;      
              IF ln_cont = 0 THEN    
                --Estado de la mora maxima
                IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN                
                   lc_estado := '01';
                ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN                
                   lc_estado := '17';
                ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
                   lc_estado := '18';
                ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
                   lc_estado := '19';
                ELSE
                   lc_estado := '20';
                END IF;    
              END IF; 
              --Tipo Linea de Credito                
              ln_cont := ln_cont + 1;                               
                IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN   
                   IF I.AQPB515BCONDIC <> 'PERDIDA' THEN                                     
                      lc_atraso := 'N';  
                   ELSE                           
                      lc_atraso := 'J';  
                   END IF;
                ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN                
                   lc_atraso := '1';
                ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
                   lc_atraso := '2';
                ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
                   lc_atraso := '3';
                ELSIF ln_edadmora >= 120 AND ln_edadmora < 150 THEN
                   lc_atraso := '4';
                ELSIF ln_edadmora >= 150 AND ln_edadmora < 180 THEN
                   lc_atraso := 'J';
                ELSE
                   lc_atraso := 'J';
                END IF;  
              IF ln_cont < 30 THEN
                  lc_compor := concat( lc_compor, lc_atraso );  
              END IF;                       
                                     
           EXCEPTION WHEN 
                     OTHERS THEN                 
                NULL;
           END;              
       END LOOP;  
         
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '01'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy');
       V_AQPB515BFECAP  := TO_DATE('01/01/0001','dd/MM/yyyy');  
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';
       
       --Busca el periodo maximo de la entidad       
       BEGIN
         SELECT MAX(AQPB515BULTAC) INTO V_AQPB515BULTAC FROM AQPB515B
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5');
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('Error al buscar la fecha maxima.');
       END;       
       --Busca el periodo minimo de la entidad
       BEGIN
         SELECT MIN(AQPB515BFECVE) INTO V_AQPB515BFECVE FROM AQPB515B
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5');
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('Error al buscar la fecha minima.');
       END;                                           
       --Buscar datos de la entidad 
       BEGIN         
         SELECT AQPB515BEMORA, AQPB515BMAXMO, AQPB515BSALAC, AQPB515BCONCOD, 
                AQPB515BCREUSR, AQPB515BCRETIM, AQPB515BCONDIC, AQPB515BMONED, AQPB515BINDBO, AQPB515BCUPO
           INTO V_AQPB515BEMORA, V_AQPB515BMAXMO, V_AQPB515BSALAC, V_AQPB515BCONCOD, 
                V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC, V_AQPB515BMONED, V_AQPB515BINDBO, V_AQPB515BCUPO
           FROM AQPB515B
         WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID AND AQPB515BTICTA = J.AQPB515BTICTA
           AND AQPB515BULTAC = V_AQPB515BULTAC AND AQPB515BINDBO IN ('1','5') AND ROWNUM = 1;    
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('No se encontro datos: '|| J.AQPB515BENTID);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| J.AQPB515BTICTA);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| V_AQPB515BFECVE);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| V_AQPB515BULTAC);
       END;   
       
       BEGIN      
         --Hallar el estado de la deuda
         IF ld_maxFecha = V_AQPB515BULTAC THEN
            V_AQPB515BESTADO := lc_estado;
         ELSE
            V_AQPB515BESTADO := '06';
         END IF;    
         --Insercion final         
         BEGIN
            INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                   AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                   AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                   AQPB515BMONED,AQPB515BFECAP) 
            VALUES(P_N_SERIAL,J.AQPB515BCODSU,V_AQPB515BULTAC,'998',J.AQPB515BENTID,V_AQPB515BESTADO,V_AQPB515BFECVE,
                   lc_compor,V_AQPB515BEMORA,J.AQPB515BTICTA,V_AQPB515BINDBO,V_AQPB515BSALAC,0,
                   V_AQPB515BMAXMO,'18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                   V_AQPB515BMONED,V_AQPB515BFECVE); 
         EXCEPTION 
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BULTAC);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BFECVE);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BSALAC);
              DBMS_OUTPUT.put_line('Error al insertar: ' || J.AQPB515BENTID);
         END; 
       END;  
       /*--Actualiza estado cancelado si no presenta deuda en ultimo periodo  
       BEGIN
         SELECT COUNT(*) INTO ln_flagEst
                FROM AQPB515B       
         WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID AND AQPB515BTICTA = J.AQPB515BTICTA AND
               AQPB515BFECVE = ld_maxFecha AND AQPB515BINDBO IN ('1','5');               
         IF ln_flagEst = 0 THEN    
               IF J.AQPB515BTICTA <> 'TDC' AND J.AQPB515BTICTA <> 'CRD' AND J.AQPB515BTICTA <> 'CAS'  THEN
                    UPDATE AQPB515B SET AQPB515BESTADO = '06'
                        WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                          AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5');
               END IF;
         END IF;
       END;*/                 
    END LOOP;  
    
    --ITERACION CREDITOS FALTANTES  
    FOR L IN ENTIDADES_1 LOOP      
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '1'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';      
       
       ln_flagEst := 0;           
       ln_atraso := 0;
       lc_atraso := ''; 
       lc_compor := '';    
       --Buscar saldo de cartera creditos por entidad acorde a la tabla de RCC           
       BEGIN           
         SELECT NVL(SUM(AQPB515ASALDO),0) INTO V_AQPB515BSALAC FROM AQPB515A
                WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT
                  AND AQPB515AFEACT = L.AQPB515AFEACT 
                  AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') 
                  OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')
                  OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0303') 
                  OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0308'));
       EXCEPTION 
          WHEN OTHERS THEN
               V_AQPB515BSALAC := 0;
       END;         
       IF V_AQPB515BSALAC <> 0 THEN
           ln_flagRCC := 1;
           --Existe en el modulo de SBS               
           SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                  WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = L.AQPB515ACOENT 
                    AND AQPB515BFECVE = L.AQPB515AFEACT AND AQPB515BINDBO IN ('1','5')
                    AND AQPB515BSALAC = 0 AND AQPB515BNUMER = 998;   
           IF ln_flagEst = 0 THEN  
             --Obtener minima fecha reportada         
             BEGIN                      
               SELECT MIN(AQPB515AFEACT) INTO V_AQPB515BFECVE FROM AQPB515A
                      WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT
                        AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') 
                        OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')
                        OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0303') 
                        OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0308'));
             EXCEPTION 
                WHEN OTHERS THEN 
                    NULL;
             END; 
             --Validamos que no exista el registro
             SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                    WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = L.AQPB515ACOENT 
                      AND AQPB515BFECVE = L.AQPB515AFEACT AND AQPB515BINDBO IN ('1','5')
                      AND (AQPB515BSALAC = V_AQPB515BSALAC OR AQPB515BNUMER = '998');                         
             IF ln_flagEst = 0 THEN  
                 --Obtener datos generales
                 BEGIN     
                     SELECT AQPB515ACONCOD, AQPB515ACREUSR, AQPB515ACRETIM, AQPB515ACALIF
                            INTO V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC
                     FROM AQPB515A
                          WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT                      
                            AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') 
                            OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')
                            OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0303') 
                            OR REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]0308'));
                 EXCEPTION 
                    WHEN OTHERS THEN
                      NULL;
                 END; 
                 ln_cont := 0;
                 FOR Z IN RCC_1(L.AQPB515ACOENT) LOOP
                    ln_cont := ln_cont + 1;
                    IF Z.AQPB515ACONDI = 'PER' THEN                  
                       lc_atraso := 'J';                   
                    ELSIF Z.AQPB515ACONDI = 'NOR' THEN                  
                       lc_atraso := 'N';
                    ELSE                               
                       lc_atraso := '4';
                    END IF;
                    IF ln_cont < 30 THEN
                       lc_compor := concat( lc_compor, lc_atraso );  
                    END IF; 
                 END LOOP;
                 --Hallar el estado de la deuda  
                 IF ld_maxFecha = L.AQPB515AFEACT THEN
                    V_AQPB515BESTADO := '01';
                 ELSE
                    V_AQPB515BESTADO := '06';
                 END IF; 
                 --Insertar datos en AQPB515B
                 BEGIN
                    INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                           AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                           AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                           AQPB515BMONED,AQPB515BFECAP) 
                    VALUES(P_N_SERIAL,L.AQPB515ACOENT,L.AQPB515AFEACT,'998',L.AQPB515ANOENT,V_AQPB515BESTADO,V_AQPB515BFECVE,
                           lc_compor,'000','CRD','1',V_AQPB515BSALAC,0,0,
                           '18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                           'S/.',V_AQPB515BFECVE); 
                 EXCEPTION 
                    WHEN OTHERS THEN
                      DBMS_OUTPUT.put_line('Error al insertar: ' || L.AQPB515ANOENT);
                 END;
             END IF;           
           ELSE                   
               --Hallar el estado de la deuda
               IF ld_maxFecha = L.AQPB515AFEACT THEN
                  V_AQPB515BESTADO := '01';
               ELSE
                  V_AQPB515BESTADO := '06';
               END IF;           
               BEGIN                   
                    UPDATE AQPB515B SET AQPB515BSALAC = V_AQPB515BSALAC, AQPB515BTICTA = 'CRD', AQPB515BESTADO = V_AQPB515BESTADO
                           WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = L.AQPB515ANOENT 
                             AND AQPB515BINDBO IN ('1','5') AND AQPB515BULTAC = L.AQPB515AFEACT
                             AND AQPB515BNUMER = 998;                       
                 EXCEPTION 
                    WHEN OTHERS THEN
                      DBMS_OUTPUT.put_line('Error al actualizar: ' || L.AQPB515ANOENT);
                 END;   
           END IF;  
        END IF;
     END LOOP;
     
    --ITERACION CREDITOS FALTANTES  
    IF ln_flagRCC = 0 THEN
      
    FOR L IN ENTIDADES_1_2 LOOP      
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '1'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';      
       
       ln_flagEst := 0;           
       ln_atraso := 0;
       lc_atraso := ''; 
       lc_compor := '';    
       --Buscar saldo de cartera creditos por entidad acorde a la tabla de RCC           
       BEGIN           
          SELECT NVL(SUM(AQPB515ASALDO),0) INTO V_AQPB515BSALAC FROM AQPB515A
                WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT
                  AND AQPB515AFEACT = L.AQPB515AFEACT 
                  AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]') OR REGEXP_LIKE(aqpb515acopuc, '^71.[1-4]'))
                  AND NOT REGEXP_LIKE(aqpb515acopuc,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601');
       EXCEPTION 
          WHEN OTHERS THEN
              V_AQPB515BSALAC := 0;
       END;         
       IF V_AQPB515BSALAC <> 0 THEN
           --Existe en el modulo de SBS               
           SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                  WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = L.AQPB515ACOENT 
                    AND AQPB515BFECVE = L.AQPB515AFEACT AND AQPB515BINDBO IN ('1','5')
                    AND AQPB515BSALAC = 0 AND AQPB515BNUMER = 998;   
           IF ln_flagEst = 0 THEN  
             --Obtener minima fecha reportada         
             BEGIN                      
               SELECT MIN(AQPB515AFEACT) INTO V_AQPB515BFECVE FROM AQPB515A
                        WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT
                          AND AQPB515AFEACT = L.AQPB515AFEACT 
                          AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]') OR REGEXP_LIKE(aqpb515acopuc, '^71.[1-4]'))
                          AND NOT REGEXP_LIKE(aqpb515acopuc,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601');
             EXCEPTION 
                WHEN OTHERS THEN 
                    NULL;
             END; 
             --Validamos que no exista el registro
             SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                    WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = L.AQPB515ACOENT 
                      AND AQPB515BFECVE = L.AQPB515AFEACT AND AQPB515BINDBO IN ('1','5')
                      AND (AQPB515BSALAC = V_AQPB515BSALAC OR AQPB515BNUMER = '998');                     
             IF ln_flagEst = 0 THEN  
                 --Obtener datos generales
                 BEGIN     
                     SELECT AQPB515ACONCOD, AQPB515ACREUSR, AQPB515ACRETIM, AQPB515ACALIF
                            INTO V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC
                      FROM AQPB515A
                          WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = L.AQPB515ACOENT AND AQPB515AFEACT = L.AQPB515AFEACT 
                            AND (REGEXP_LIKE(aqpb515acopuc, '^14.[1-6]') OR REGEXP_LIKE(aqpb515acopuc, '^71.[1-4]'))
                            AND NOT REGEXP_LIKE(aqpb515acopuc,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601');
                 EXCEPTION 
                    WHEN OTHERS THEN
                        NULL;
                 END; 
                 ln_cont := 0;
                 FOR Z IN RCC_1_2(L.AQPB515ACOENT) LOOP
                    ln_cont := ln_cont + 1;
                    IF Z.AQPB515ACONDI = 'PER' THEN                  
                       lc_atraso := 'J';                   
                    ELSIF Z.AQPB515ACONDI = 'NOR' THEN                  
                       lc_atraso := 'N';
                    ELSE                               
                       lc_atraso := '4';
                    END IF;
                    IF ln_cont < 30 THEN
                       lc_compor := concat( lc_compor, lc_atraso );  
                    END IF; 
                 END LOOP;
                 --Hallar el estado de la deuda  
                 IF ld_maxFecha = L.AQPB515AFEACT THEN
                    V_AQPB515BESTADO := '01';
                 ELSE
                    V_AQPB515BESTADO := '06';
                 END IF;  
                 --Insertar datos en AQPB515B
                 BEGIN
                    INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                           AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                           AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                           AQPB515BMONED,AQPB515BFECAP) 
                    VALUES(P_N_SERIAL,L.AQPB515ACOENT,L.AQPB515AFEACT,'998',L.AQPB515ANOENT,V_AQPB515BESTADO,V_AQPB515BFECVE,
                           lc_compor,'000','CRD','1',V_AQPB515BSALAC,0,0,
                           '18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                           'S/.',V_AQPB515BFECVE); 
                 EXCEPTION 
                    WHEN OTHERS THEN
                      DBMS_OUTPUT.put_line('Error al insertar: ' || L.AQPB515ANOENT);
                 END;
             END IF;           
           ELSE                   
               --Hallar el estado de la deuda
               IF ld_maxFecha = L.AQPB515AFEACT THEN
                  V_AQPB515BESTADO := '01';
               ELSE
                  V_AQPB515BESTADO := '06';
               END IF;           
               BEGIN                   
                    UPDATE AQPB515B SET AQPB515BSALAC = V_AQPB515BSALAC, AQPB515BTICTA = 'CRD', AQPB515BESTADO = V_AQPB515BESTADO
                           WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = L.AQPB515ANOENT 
                             AND AQPB515BINDBO IN ('1','5') AND AQPB515BULTAC = L.AQPB515AFEACT
                             AND AQPB515BNUMER = 998;                       
                 EXCEPTION 
                    WHEN OTHERS THEN
                      DBMS_OUTPUT.put_line('Error al actualizar: ' || L.AQPB515ANOENT);
                 END;   
           END IF;  
        END IF;
     END LOOP;
     END IF;
     
     --ITERACION DE CREDITOS CASTIGADOS
     FOR H IN ENTIDADES_0 LOOP      
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '1'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';      
       
       ln_flagEst := 0;           
       ln_atraso := 0;
       lc_atraso := '';   
       lc_compor := '';  
       --Buscar saldo de cartera castigada por entidad acorde a la tabla de RCC           
       BEGIN           
         SELECT NVL(SUM(AQPB515ASALDO),0) INTO V_AQPB515BSALAC FROM AQPB515A
                WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = H.AQPB515ACOENT
                  AND AQPB515AFEACT = H.AQPB515AFEACT AND AQPB515ACOPUC LIKE '81_302%';
       EXCEPTION 
          WHEN OTHERS THEN
               V_AQPB515BSALAC := 0.00;
       END;             
       IF V_AQPB515BSALAC <> 0 THEN
         --Existe en el modulo de SBS               
         SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = H.AQPB515ACOENT 
                  AND AQPB515BULTAC = H.AQPB515AFEACT AND AQPB515BINDBO IN ('1','5')
                  AND AQPB515BSALAC = 0 AND AQPB515BNUMER = 998;    
                   
         IF ln_flagEst = 0 THEN  
           --Obtener minima fecha reportada         
           BEGIN                      
             SELECT MIN(AQPB515AFEACT) INTO V_AQPB515BFECVE FROM AQPB515A
                    WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = H.AQPB515ACOENT
                      AND AQPB515ACOPUC LIKE '81_302%';
           EXCEPTION 
              WHEN OTHERS THEN
                SELECT MIN(AQPB515AFEACT) INTO V_AQPB515BFECVE FROM AQPB515A
                    WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = H.AQPB515ACOENT;
           END;
           --Obtener datos generales
           BEGIN     
               SELECT AQPB515ACONCOD, AQPB515ACREUSR, AQPB515ACRETIM, AQPB515ACALIF
                      INTO V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC
               FROM AQPB515A
                    WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = H.AQPB515ACOENT
                      AND AQPB515ACOPUC LIKE '81_302%';
           EXCEPTION 
              WHEN OTHERS THEN
                SELECT AQPB515ACONCOD, AQPB515ACREUSR, AQPB515ACRETIM, AQPB515ACALIF
                      INTO V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC
                FROM AQPB515A
                    WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = H.AQPB515ACOENT AND ROWNUM = 1;
           END; 
           ln_cont := 0;
           FOR Z IN RCC(H.AQPB515ACOENT) LOOP
              ln_cont := ln_cont + 1;
              IF Z.AQPB515ACONDI = 'PER' THEN                  
                 lc_atraso := 'J';                
              ELSIF Z.AQPB515ACONDI = 'NOR' THEN                  
                 lc_atraso := 'N';
              ELSE                               
                 lc_atraso := '5';
              END IF;
              IF ln_cont < 30 THEN
                 lc_compor := concat( lc_compor, lc_atraso );  
              END IF; 
           END LOOP;
           --Hallar el estado de la deuda  
           IF ld_maxFecha = H.AQPB515AFEACT THEN
              V_AQPB515BESTADO := '20';
           ELSE
              V_AQPB515BESTADO := '06';
           END IF;           
           /*DBMS_OUTPUT.put_line('------------'); 
           DBMS_OUTPUT.put_line('J.AQPB515BENTID ' || H.AQPB515ANOENT); 
           DBMS_OUTPUT.put_line('J.AQPB515BTICTA ' || 'CAS'); 
           DBMS_OUTPUT.put_line('V_AQPB515BULTAC: ' || H.AQPB515AFEACT); 
           DBMS_OUTPUT.put_line('V_AQPB515BFECVE: ' || V_AQPB515BFECVE); 
           DBMS_OUTPUT.put_line('V_AQPB515BESTADO: ' || V_AQPB515BESTADO);
           DBMS_OUTPUT.put_line('V_AQPB515BSALAC: ' || V_AQPB515BSALAC);
           DBMS_OUTPUT.put_line('------------'); */
           --Insertar datos en AQPB515B
           BEGIN
              INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                     AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                     AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                     AQPB515BMONED,AQPB515BFECAP) 
              VALUES(P_N_SERIAL,H.AQPB515ACOENT,H.AQPB515AFEACT,'998',H.AQPB515ANOENT,V_AQPB515BESTADO,V_AQPB515BFECVE,
                     lc_compor,'000','CAS','1',V_AQPB515BSALAC,0,0,
                     '18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                     'S/.',V_AQPB515BFECVE); 
           EXCEPTION 
              WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Error al insertar: ' || H.AQPB515ANOENT);
           END;          
         ELSE    
           --Hallar el estado de la deuda  
           IF ld_maxFecha = H.AQPB515AFEACT THEN
              V_AQPB515BESTADO := '20';
           ELSE
              V_AQPB515BESTADO := '06';
           END IF;                
           BEGIN                   
                UPDATE AQPB515B SET AQPB515BSALAC = V_AQPB515BSALAC, AQPB515BTICTA = 'CAS', AQPB515BESTADO = V_AQPB515BESTADO
                       WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = H.AQPB515ANOENT 
                         AND AQPB515BINDBO IN ('1','5') AND AQPB515BULTAC = H.AQPB515AFEACT
                         AND AQPB515BNUMER = 998;
           EXCEPTION 
                  WHEN OTHERS THEN
                    DBMS_OUTPUT.put_line('Error al actualizar: ' || H.AQPB515ANOENT);
           END;      
         END IF;
       END IF;  
     END LOOP;    
     
     --ITERACION DE LINEAS DE CREDITO  
     FOR K IN ENTIDADES(ld_maxFecha) LOOP      
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '1'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';      
        
       ln_flagEst := 0;        
       ln_atraso := 0;
       lc_atraso := '';  
       lc_compor := ''; 
       --Buscar saldo de linea de credito por entidad acorde a la tabla de RCC           
       BEGIN           
         SELECT NVL(SUM(AQPB515ASALDO),0) INTO V_AQPB515BCUPO FROM AQPB515A
                WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = K.AQPB515ACOENT
                  AND AQPB515AFEACT = ld_maxFecha AND AQPB515ACOPUC LIKE '81_9230_%';
       EXCEPTION 
          WHEN OTHERS THEN
               V_AQPB515BCUPO := 0.00;
       END;    
       IF V_AQPB515BCUPO <> 0 THEN
         --Existe en el modulo de SBS               
         SELECT COUNT(*) INTO ln_flagEst FROM AQPB515B        
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BCODSU = K.AQPB515ACOENT 
                  AND AQPB515BFECVE = ld_maxFecha AND AQPB515BINDBO IN ('1','5');          
         IF ln_flagEst = 0 THEN  
             --Obtener minima fecha reportada en RCC         
             BEGIN                      
               SELECT MIN(AQPB515AFEACT) INTO V_AQPB515BFECVE FROM AQPB515A
                      WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = K.AQPB515ACOENT
                        AND AQPB515ACOPUC LIKE '81_9230_%';
             EXCEPTION 
                WHEN OTHERS THEN
                     V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
             END;
             ln_cont := 0;
             --Obtener datos generales 
             FOR E IN 0..ABS(TRUNC(MONTHS_BETWEEN(ld_maxFecha,V_AQPB515BFECVE))) LOOP     
                ln_cont := ln_cont + 1;                  
                lc_atraso := 'N';
                IF ln_cont < 30 THEN
                   lc_compor := concat( lc_compor, lc_atraso );  
                END IF;  
              END LOOP; 
              BEGIN     
                 SELECT AQPB515ACONCOD, AQPB515ACREUSR, AQPB515ACRETIM, AQPB515ACALIF
                        INTO V_AQPB515BCONCOD, V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC
                 FROM AQPB515A
                      WHERE AQPB515ASERIAL = P_N_SERIAL AND AQPB515ACOENT = K.AQPB515ACOENT
                        AND AQPB515AFEACT = ld_maxFecha AND AQPB515ACOPUC LIKE '81_9230_%';
              EXCEPTION 
                WHEN OTHERS THEN
                     DBMS_OUTPUT.put_line('No se encontro datos: '|| K.AQPB515ANOENT);
                     DBMS_OUTPUT.put_line('No se encontro datos: '|| V_AQPB515BFECVE);
              END;  
              --Insertar datos en AQPB515B
              BEGIN               
                  INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                         AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                         AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                         AQPB515BMONED,AQPB515BFECAP) 
                  VALUES(P_N_SERIAL,K.AQPB515ACOENT,ld_maxFecha,'998',K.AQPB515ANOENT,'17',V_AQPB515BFECVE,
                         lc_compor,'000','TDC','1',0.00,V_AQPB515BCUPO,0,
                         '15',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                         'S/.',V_AQPB515BFECVE); 
              EXCEPTION 
                  WHEN OTHERS THEN
                    DBMS_OUTPUT.put_line('Error al insertar: ' || K.AQPB515ANOENT);
              END;
         ELSE           
           BEGIN                   
                UPDATE AQPB515B SET AQPB515BCUPO = V_AQPB515BCUPO
                       WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = K.AQPB515ANOENT 
                         AND AQPB515BINDBO IN ('1','5') AND AQPB515BULTAC = ld_maxFecha;
           EXCEPTION 
              WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Error al actualizar: ' || K.AQPB515ANOENT);
           END;        
         END IF;       
       END IF;  
     END LOOP;                  
    
    --ITERACION FINAL
    FOR J IN ENTIDADES_3 LOOP
       ln_maximora := 0;
       ln_flagEst  := 0; 
       
       --Actualiza en todos los registros la maxima mora por entidad
       BEGIN
           SELECT MAX(AQPB515BEMORA) INTO ln_maximora 
                  FROM AQPB515B 
           WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
             AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5')
             AND AQPB515BNUMER = 998;
       EXCEPTION WHEN OTHERS THEN
            ln_maximora := 0;
       END; 
       BEGIN  
         UPDATE AQPB515B SET AQPB515BMAXMO = ln_maximora 
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5')
                  AND AQPB515BNUMER = 998;
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;       
            
       V_AQPB515BCOMPOR := '';      
       V_AQPB515BINDBO  := ''; 
       V_AQPB515BESTADO := '01'; 
       V_AQPB515BFECVE  := TO_DATE('01/01/0001','dd/MM/yyyy');
       V_AQPB515BFECAP  := TO_DATE('01/01/0001','dd/MM/yyyy');  
       V_AQPB515BULTAC  := TO_DATE('01/01/0001','dd/MM/yyyy'); 
       V_AQPB515BEMORA  := '000'; 
       V_AQPB515BMAXMO  := 0.00;
       V_AQPB515BSALAC  := 0.00;
       V_AQPB515BCUPO   := 0.00;
       V_AQPB515BCONDIC := '';
       V_AQPB515BMONED  := '';
                
       --Busca el periodo maximo de la entidad       
       BEGIN
         SELECT MAX(AQPB515BULTAC) INTO V_AQPB515BULTAC FROM AQPB515B
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5');
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('Error al buscar la fecha maxima.');
       END;       
       --Busca el periodo minimo de la entidad
       BEGIN
         SELECT MIN(AQPB515BFECVE) INTO V_AQPB515BFECVE FROM AQPB515B
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BINDBO IN ('1','5');
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('Error al buscar la fecha minima.');
       END;  
       --Busca el saldo vigente de la ultima fecha
       BEGIN         
         SELECT AQPB515BSALAC INTO V_AQPB515BSALAC FROM AQPB515B 
                WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID 
                  AND AQPB515BTICTA = J.AQPB515BTICTA AND AQPB515BULTAC = V_AQPB515BULTAC
                  AND AQPB515BINDBO IN ('1','5'); 
       EXCEPTION WHEN OTHERS THEN
           V_AQPB515BSALAC := 0;
       END;   
       --Obtiene los datos, el periodo minimo presenta el comportamiento mas completo
       BEGIN         
         SELECT AQPB515BCOMPOR, AQPB515BESTADO, AQPB515BEMORA, AQPB515BMAXMO, AQPB515BSALAC, AQPB515BCONCOD, 
                AQPB515BCREUSR, AQPB515BCRETIM, AQPB515BCONDIC, AQPB515BMONED, AQPB515BINDBO, AQPB515BCUPO
           INTO V_AQPB515BCOMPOR, V_AQPB515BESTADO, V_AQPB515BEMORA, V_AQPB515BMAXMO, V_AQPB515BSALAC, V_AQPB515BCONCOD, 
                V_AQPB515BCREUSR, V_AQPB515BCRETIM, V_AQPB515BCONDIC, V_AQPB515BMONED, V_AQPB515BINDBO, V_AQPB515BCUPO
           FROM AQPB515B
         WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BENTID = J.AQPB515BENTID AND AQPB515BTICTA = J.AQPB515BTICTA
           AND AQPB515BULTAC = V_AQPB515BULTAC AND AQPB515BINDBO IN ('1','5') AND AQPB515BNUMER = 998;
           
           DBMS_OUTPUT.put_line('J.AQPB515BENTID ' || J.AQPB515BENTID); 
           DBMS_OUTPUT.put_line('J.AQPB515BTICTA ' || J.AQPB515BTICTA); 
           DBMS_OUTPUT.put_line('V_AQPB515BULTAC: ' || V_AQPB515BULTAC); 
           DBMS_OUTPUT.put_line('V_AQPB515BFECVE: ' || V_AQPB515BFECVE);
           DBMS_OUTPUT.put_line('V_AQPB515BESTADO: ' || V_AQPB515BESTADO);
           
       EXCEPTION 
          WHEN OTHERS THEN
               DBMS_OUTPUT.put_line('No se encontro datos: '|| J.AQPB515BENTID);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| J.AQPB515BTICTA);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| V_AQPB515BFECVE);
               DBMS_OUTPUT.put_line('No se encontro datos: '|| V_AQPB515BULTAC);
       END;   
       BEGIN    
         IF V_AQPB515BINDBO = '0' OR V_AQPB515BINDBO = '5' THEN
           V_AQPB515BINDBO := '3';
         ELSE
           V_AQPB515BINDBO := '4';
         END IF;
         --Insercion final         
         BEGIN
            INSERT INTO AQPB515B(AQPB515BSERIAL,AQPB515BCODSU,AQPB515BULTAC,AQPB515BNUMER,AQPB515BENTID,AQPB515BESTADO,
                   AQPB515BFECVE,AQPB515BCOMPOR,AQPB515BEMORA,AQPB515BTICTA,AQPB515BINDBO,AQPB515BSALAC,AQPB515BCUPO,
                   AQPB515BMAXMO,AQPB515BTIDET,AQPB515BCONCOD,AQPB515BCREUSR,AQPB515BCRETIM,AQPB515BCONDIC,
                   AQPB515BMONED,AQPB515BFECAP) 
            VALUES(P_N_SERIAL,J.AQPB515BCODSU,V_AQPB515BULTAC,'999',J.AQPB515BENTID,V_AQPB515BESTADO,V_AQPB515BFECVE,
                   V_AQPB515BCOMPOR,V_AQPB515BEMORA,J.AQPB515BTICTA,V_AQPB515BINDBO,V_AQPB515BSALAC,V_AQPB515BCUPO,
                   V_AQPB515BMAXMO,'18',V_AQPB515BCONCOD,V_AQPB515BCREUSR,V_AQPB515BCRETIM,V_AQPB515BCONDIC,
                   V_AQPB515BMONED,V_AQPB515BFECVE); 
         EXCEPTION 
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BULTAC);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BFECVE);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_AQPB515BSALAC);
              DBMS_OUTPUT.put_line('Error al insertar: ' || J.AQPB515BENTID);
         END; 
       END;  
    END LOOP;  
     
   --Actualizamos el Tipo Temporal
   BEGIN
        UPDATE AQPB515B SET AQPB515BTICTA = 'CRE' WHERE AQPB515BSERIAL = P_N_SERIAL AND AQPB515BTICTA = 'CRD'; 
   EXCEPTION 
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Error al actualizar: ' || 'CRD');
   END;   
   
  END sp_cr_actualizar_mora_reg;
  
end PQ_CR_EQUIFAX;
/

