CREATE OR REPLACE PACKAGE PQ_CR_BUSQUEDA_DIRECCION_2  is
-- *****************************************************************
-- Nombre                     : PQ_CR_EXPERIAN
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2014.04.27
-- Autor de Creación          : CMAC-SFERNANDEM
-- Uso                        : Extrae
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
--
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_limpia_direccion_trigger(P_PAIS  number,P_TDOC number,P_NDOC varchar2,P_DOCOD number,P_CORR number,P_UGEO varchar2,
                                      P_DPTO NUMBER,P_PROV NUMBER,P_DIST NUMBER,P_DIRECCION varchar2, P_EST in char);
  Procedure sp_cr_volcado_palabras( P_BUSQUEDA in varchar2,
                                  P_PAIS in NUMBER,
                                  P_DPTO in NUMBER,
                                  P_PROVINCIA in NUMBER,
                                  P_UBIGEO in VARCHAR2,
                                  P_USU in varchar2,
                                  P_MAQUINA in varchar2,
                                  P_TOT_CON2 out number);
  --(P_UBIGEO VARCHAR2,P_USU varchar2, P_MAQUINA varchar2);
 Procedure sp_cr_cuenta_coincidencias(P_BUSQUEDA in varchar2,P_USU in varchar2, P_MAQUINA in varchar2,P_TOT_CON out number);
  Procedure sp_cr_limpia_direccion(P_DEPT NUMBER);
  Procedure sp_cr_limpia_direccion_JOBS;
  Procedure sp_cr_limpia_registros(P_USU in varchar2, P_MAQUINA in varchar2);
  Procedure sp_cr_nro_medidor(P_T_MED in varchar2,P_NRO_MED in varchar2,P_UBIGEO in VARCHAR2,P_USU in varchar2,
                             P_MAQUINA in varchar2,P_TOT_CON out number);
  Procedure sp_limpia_medidor_direccion(P_DIRECCION IN varchar2,P_R_DIRECCION out varchar);                             
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end  PQ_CR_BUSQUEDA_DIRECCION_2;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_BUSQUEDA_DIRECCION_2 is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_limpia_direccion_trigger(P_PAIS  in  number,
                                      P_TDOC  in number,
                                      P_NDOC  in varchar2,
                                      P_DOCOD  in number,
                                      P_CORR in number,
                                      P_UGEO   in varchar2,
                                      P_DPTO   in NUMBER,
                                      P_PROV   in NUMBER,
                                      P_DIST  in NUMBER,
                                      P_DIRECCION in varchar2,
                                      P_EST in char)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_limpia_direccion_trigger
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - SFERNANDEM
  -- Uso                        : SE LE LLAMA AL MOMENTO DEL INSERT O UPDATE A LA TABLA SNGC13 DESDE LOS TRIGGERS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_PAIS ,P_TDOC,P_NDOC,P_DOCOD,P_CORR,P_UGEO
  --                            : P_DPTO,P_PROV,P_DIST,P_DIRECCION
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************


   LN_FLAG NUMBER(1);
   CONT NUMBER(2);

   LC_NOM VARCHAR2(140);
   LC_CAD VARCHAR2(100);
   LC_MED_AGUA VARCHAR2(100);
   LC_MED_LUZ VARCHAR2(100);
   LC_INI_CONS VARCHAR2(5000);
   LC_MID_CONS VARCHAR(5000);
   LC_MID_CONS_2 VARCHAR(5000);
   LC_ndoc CHAR(12);
   type tpy_txt is table of jaqy735.jaqy735txt1%type index by binary_integer;
   LC_array tpy_txt;
   I NUMBER(10):=1; 
   LN_POSMED NUMBER(10);
   
begin
 if(P_DOCOD in (1,3) and P_PAIS <> 0 and P_TDOC <> 0) then

   --BUSCO MEDIDOR AGUA
   SELECT INSTR(P_DIRECCION,'MEDIDOR AGUA') INTO LN_POSMED FROM DUAL; 
   LC_NOM:=substr(P_DIRECCION,LN_POSMED);
   IF(LN_POSMED>0) THEN  
       LC_MED_AGUA:=TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, 3));     
   END IF; 
   
   --BUSCO MEDIDOR LUZ
   SELECT INSTR(P_DIRECCION,'MEDIDOR LUZ') INTO LN_POSMED FROM DUAL; 
   LC_NOM:=substr(P_DIRECCION,LN_POSMED);
   IF(LN_POSMED>0) THEN
       LC_MED_LUZ:=TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, 3));  
   END IF;
   
   LC_NOM:=REPLACE(P_DIRECCION,'MEDIDOR AGUA','');
   LC_NOM:=REPLACE(LC_NOM,'MEDIDOR LUZ','');
   LC_NOM:=REPLACE(LC_NOM,LC_MED_AGUA,'');
   LC_NOM:=REPLACE(LC_NOM,LC_MED_LUZ,'');
   --LIMPIANDO LA DIRECCION  DE CARACTERES EXTRAÑOS
   LC_NOM:= UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LC_NOM),'.',' '),'-',' '),'''',' '),',',' '),')',' '),'(',' '),'=',' '),'#',' '),'°',' '));   
   LC_NOM:=REPLACE(LC_NOM,';',' ');
   CONT:=0;
   --LIMPIANDO LA MEDIDORES  DE CARACTERES EXTRAÑOS
   LC_MED_AGUA:=(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LC_MED_AGUA),'.',''),'-',''),'''',''),',',''),')',''),'(',''),'=',''),'#',''),'°',''));
   LC_MED_LUZ:=(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LC_MED_LUZ),'.',''),'-',''),'''',''),',',''),')',''),'(',''),'=',''),'#',''),'°',''));   

   WHILE  I<=15 LOOP 
         LC_CAD:= TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, I));
         IF(LENGTH(LC_CAD)>0) THEN
               BEGIN
                    SELECT  1  INTO LN_FLAG FROM fst098 WHERE  pgcod=1 AND tpcod=7688  AND TRIM(TPDESC)=TRIM(LC_CAD);
               EXCEPTION
               WHEN no_data_found THEN
                       CONT:=CONT+1;
                       LC_array(CONT):=LC_CAD;
               END;            
           ELSE
             EXIT;
           END IF;
           I:=I+1;
   END LOOP;

   LC_ndoc := trim(P_NDOC);


      BEGIN
            delete from jaqy735
            where JAQY735CORR = P_CORR
               and jaqy735pais = P_PAIS
               and jaqy735tdoc = P_TDOC
               and jaqy735ndoc = LC_ndoc
               and jaqy735docod = P_DOCOD;
            -- COMMIT;

            LC_INI_CONS:='INSERT INTO  JAQY735(';

            FOR J IN 1..CONT-1 LOOP
                 LC_MID_CONS:=TRIM(LC_MID_CONS)||' jaqy735TXT'||TO_CHAR(J)||',' ;
                 LC_MID_CONS_2:=TRIM(LC_MID_CONS_2)||''''||trim(LC_array(J))||''''||',' ;
            END LOOP;


            LC_MID_CONS:=TRIM(LC_MID_CONS)||' jaqy735TXT'||TO_CHAR(CONT);
            LC_MID_CONS_2:=TRIM(LC_MID_CONS_2)||''''||trim(LC_array(CONT))||'''';

  
            IF(LENGTH(LC_MED_AGUA)>0) THEN
              LC_MID_CONS:=TRIM(LC_MID_CONS)||', jaqy735medagua';
              LC_MID_CONS_2:= trim(LC_MID_CONS_2)||','||''''||LC_MED_AGUA||'''';
            END IF;
            IF(LENGTH(LC_MED_LUZ)>0) THEN
              LC_MID_CONS:=TRIM(LC_MID_CONS)||', jaqy735medluz';
              LC_MID_CONS_2:= trim(LC_MID_CONS_2)||','||''''||LC_MED_LUZ||'''';
            END IF;         


             LC_INI_CONS:=TRIM(LC_INI_CONS)||
            ' jaqy735pais, jaqy735tdoc,jaqy735ndoc,jaqy735docod,JAQY735CORR,JAQY735UGEO,JAQY735DPTO,JAQY735PROV,JAQY735DIST,JAQY735DIR,JAQY735EST'||','||LC_MID_CONS||') VALUES('||
              TRIM(TO_CHAR(P_PAIS))||','
              ||TRIM(TO_CHAR(P_TDOC))||','
              ||''''||TRIM(P_NDOC)||''''||','
              ||TRIM(TO_CHAR(P_DOCOD))||','
              ||TRIM(TO_CHAR(P_CORR))||','
              ||''''||TRIM(P_UGEO)||''''||','
              ||TRIM(TO_CHAR(P_DPTO))||','||
              TRIM(TO_CHAR(P_PROV))||','
              ||TRIM(TO_CHAR(P_DIST))||','
              ||''''||TRIM(LC_NOM)||''''||','
              ||''''||TRIM(P_EST)||''''||','
              ||LC_MID_CONS_2||')' ;
              
             if (P_EST='H') then
                execute immediate LC_INI_CONS;
             end if;
             --COMMIT;
      EXCEPTION
       WHEN others THEN
              LC_INI_CONS :=null;
      END;
 end if;
END sp_cr_limpia_direccion_trigger;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Procedure sp_cr_volcado_palabras( P_BUSQUEDA in varchar2,
                                  P_PAIS in NUMBER,
                                  P_DPTO in NUMBER,
                                  P_PROVINCIA in NUMBER,
                                  P_UBIGEO in VARCHAR2,
                                  P_USU in varchar2,
                                  P_MAQUINA in varchar2,
                                  P_TOT_CON2 out number)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_volcado_palabras
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - SFERNANDEM
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE DIRECCIONES DE ACUERDO A UBIGEO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_UBIGEO,P_USU,P_MAQUINA
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
 UBIGEO Char(6);
 LC_SQL varchar2(1000);
 
 TYPE TP_jaqy735 IS TABLE OF jaqy735%ROWTYPE;
 l_jaqy735     TP_jaqy735;
 l_cursor  SYS_REFCURSOR;
 
 v_query     VARCHAR2(500);
 pais NUMBER(3);
 P_TOT_CON NUMBER(10):=0;
 ------
 
 LN_FLAG NUMBER(1);
 CONT NUMBER(2);
 CANT_COIN NUMBER(10);
 CANT_REP_PAL NUMBER(10);
   
 LIM NUMBER(10);
 LC_NOMBRE CHAR(30);
 LC_CAD_BUSQUEDA VARCHAR2(500);
 LC_CAD VARCHAR2(100);

  type tpy_txt is table of jaqy733.jaqy733txt1%type index by binary_integer;
  LC_array tpy_txt;
  l_tpnro number(10);
begin
   UBIGEO:=trim(P_UBIGEO);
--   execute immediate 'DELETE FROM JAQY734 WHERE JAQY734USU ='||''''||TRIM(P_USU)||''''||' AND JAQY734MAQ='||''''||TRIM(P_MAQUINA)||'''';
   execute immediate 'TRUNCATE TABLE JAQY734';
--   commit;
   
   v_query:='SELECT * FROM JAQY735 PARTITION (JAQY735_'||TO_CHAR(P_DPTO)||')'||
--   v_query:='SELECT * FROM JAQY735 '||
    ' WHERE JAQY735DPTO='||TRIM(TO_CHAR(P_DPTO))||' AND JAQY735PROV='||TRIM(TO_CHAR(P_PROVINCIA))||
    ' AND JAQY735UGEO='||''''||UBIGEO||''''||'AND JAQY735EST='||''''||'H'||'''';
   
   
   --SE LIMPIA LA CADENA INICIAL
   select tpnro into l_tpnro from fst098 where  pgcod=1 and  tpcod=7689 and tpcorr=1;
     LC_CAD_BUSQUEDA:=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(P_BUSQUEDA),'-',' '),'''',' '),',',' '),')',' '),'(',' '),'=',' '),'#',' '),'°',' '),'.','');
     CONT:=0;

     FOR I IN 1..15 LOOP
           LC_CAD:= TRIM(REGEXP_SUBSTR(LC_CAD_BUSQUEDA, '[^ ]+', 1, I));
           IF(LENGTH(LC_CAD)>0) THEN
             BEGIN
                  SELECT  1  INTO LN_FLAG FROM fst098 WHERE  pgcod=1 AND tpcod=7688  AND TRIM(TPDESC)=TRIM(LC_CAD);
                   exception
             WHEN no_data_found THEN
                     CONT:=CONT+1;
                     LC_array(CONT):=LC_CAD;
             END;
           ELSE
            EXIT;
           END IF;
     END LOOP;   
     
     
  ----comparacion     
  OPEN l_cursor FOR v_query;
  
  FETCH l_cursor BULK COLLECT INTO l_jaqy735;
    IF l_jaqy735.COUNT > 0 THEN
        FOR II IN l_jaqy735.FIRST .. l_jaqy735.LAST LOOP
            CANT_COIN:=0;
            CANT_REP_PAL:=0;
          --BEGIN  
            FOR CB IN 1..CONT LOOP
               CANT_REP_PAL:=0;
--               IF(TRIM(l_jaqy735(II).jaqy735txt1)=TRIM(LC_array(CB))) AND (LENGTH(l_jaqy735(II).jaqy735txt1)>0) AND (CANT_REP_PAL<1) THEN
               IF(LENGTH(l_jaqy735(II).jaqy735txt1)>0) AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt1)=TRIM(LC_array(CB))) THEN 
                    CANT_COIN:=CANT_COIN+1;
                    CANT_REP_PAL:=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt2)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt2)=TRIM(LC_array(CB))) THEN
                       CANT_COIN:=CANT_COIN+1;
                       CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt3)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt3)=TRIM(LC_array(CB))) THEN
                       CANT_COIN:=CANT_COIN+1;
                       CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
              END IF ;

              IF(LENGTH(l_jaqy735(II).jaqy735txt4)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt4)=TRIM(LC_array(CB))) THEN
                      CANT_COIN:=CANT_COIN+1;
                      CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
              END IF ;
              IF(LENGTH(l_jaqy735(II).jaqy735txt5)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt5)=TRIM(LC_array(CB)))THEN
                      CANT_COIN:=CANT_COIN+1;
                      CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
              END IF ;
              IF(LENGTH(l_jaqy735(II).jaqy735txt6)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt6)=TRIM(LC_array(CB)))THEN
                       CANT_COIN:=CANT_COIN+1;
                       CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt7)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt7)=TRIM(LC_array(CB))) THEN
                        CANT_COIN:=CANT_COIN+1;
                        CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt8)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt8)=TRIM(LC_array(CB)))THEN
                       CANT_COIN:=CANT_COIN+1;
                       CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt9)>0) AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt9)=TRIM(LC_array(CB)))THEN
                        CANT_COIN:=CANT_COIN+1;
                        CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt10)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt10)=TRIM(LC_array(CB)))THEN
                        CANT_COIN:=CANT_COIN+1;
                        CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt11)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt11)=TRIM(LC_array(CB)))THEN
                         CANT_COIN:=CANT_COIN+1;
                         CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt12)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt12)=TRIM(LC_array(CB))) THEN
                         CANT_COIN:=CANT_COIN+1;
                         CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt13)>0) AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt13)=TRIM(LC_array(CB))) THEN
                          CANT_COIN:=CANT_COIN+1;
                          CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt14)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt14)=TRIM(LC_array(CB))) THEN
                          CANT_COIN:=CANT_COIN+1;
                          CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
               END IF ;
               IF(LENGTH(l_jaqy735(II).jaqy735txt15)>0)  AND (CANT_REP_PAL<1) AND (TRIM(l_jaqy735(II).jaqy735txt15)=TRIM(LC_array(CB))) THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL :=CANT_REP_PAL+1;
                    continue;
                END IF ;
          END LOOP;

          LIM:=FLOOR((CONT/2))+3;--+2;
          IF(LIM>CONT) THEN
                 LIM:=CONT;
          END IF ;
--          IF(CANT_COIN>=LIM)  AND (CANT_REP_PAL<=1)THEN
          IF(CANT_COIN>=LIM) THEN
            BEGIN
               SELECT PENOM INTO LC_NOMBRE FROM FSD001 WHERE  PEPAIS=l_jaqy735(II).jaqy735pais AND PETDOC=l_jaqy735(II).jaqy735tdoc AND PENDOC=l_jaqy735(II).jaqy735ndoc;
               INSERT INTO JAQY734 ( JAQY734PAI,JAQY734TDOC,JAQY734NDOC,JAQY734DOCOD,JAQY734CORR,JAQY734USU,JAQY734MAQ,JAQY734DIR, JAQY734NOM)
               VALUES(l_jaqy735(II).jaqy735pais ,l_jaqy735(II).jaqy735tdoc,l_jaqy735(II).jaqy735ndoc,l_jaqy735(II).Jaqy735docod,l_jaqy735(II).Jaqy735corr,TRIM(P_USU),TRIM(P_MAQUINA)
               ,l_jaqy735(II).JAQY735DIR,LC_NOMBRE);
               
               
insert into jaqy733
  (jaqy733pais,
   jaqy733tdoc,
   jaqy733ndoc,
   jaqy733docod,
   jaqy733corr,
   jaqy733usu,
   jaqy733txt1,
   jaqy733txt2,
   jaqy733txt3,
   jaqy733txt4,
   jaqy733txt5)
values
  (l_jaqy735(II).jaqy735pais,
   l_jaqy735(II).jaqy735tdoc,
   l_jaqy735(II).jaqy735ndoc,
   l_jaqy735(II).Jaqy735docod,
   l_jaqy735(II).Jaqy735corr,
   SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 30),
   P_BUSQUEDA,
   P_PAIS,
   P_DPTO,
   P_PROVINCIA,
   P_UBIGEO);

               
                         
                P_TOT_CON:=P_TOT_CON+1;
                IF(P_TOT_CON=l_tpnro) THEN
                    P_TOT_CON2:=P_TOT_CON;
                    rollback;
                 RETURN;
                 END IF;
           EXCEPTION
            WHEN OTHERS THEN
             LC_NOMBRE:=NULL;
            END;
           END IF;
        END LOOP; --fin cursor dinamico
    END IF; 
   COMMIT;
  CLOSE l_cursor;
   P_TOT_CON2:=P_TOT_CON;

  END sp_cr_volcado_palabras;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Procedure sp_cr_cuenta_coincidencias(P_BUSQUEDA in varchar2,P_USU in varchar2, P_MAQUINA in varchar2,P_TOT_CON out number)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_cuenta_coincidencias
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - SFERNANDEM
  -- Uso                        : BUSCA LAS COINCIDENCIAS Y LAS ALMACENA EN JAQY734
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_BUSQUEDA ( DIRECCION DE BUSQUEDA)
  --                            : P_USU ( USUARIO ),P_MAQUINA(MAQUINA)
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
  USUARIO CHAR(30);
  MAQUINA CHAR(20);
 cursor DIRE is
     select
       j.jaqy733pais,
       j.jaqy733tdoc,
       j.jaqy733ndoc,
       j.jaqy733docod,
       j.jaqy733corr,
       j.jaqy733usu,
       j.jaqy733maq,
       j.jaqy733dir,
       j.jaqy733txt1,
       j.jaqy733txt2,
       j.jaqy733txt3,
       j.jaqy733txt4,
       j.jaqy733txt5,
       j.jaqy733txt6,
       j.jaqy733txt7,
       j.jaqy733txt8,
       j.jaqy733txt9,
       j.jaqy733txt10,
       j.jaqy733txt11,
       j.jaqy733txt12,
       j.jaqy733txt13,
       j.jaqy733txt14,
       j.jaqy733txt15
       from jaqy733 j
        where --jaqy733pais=604
         j.jaqy733usu=USUARIO
        and j.jaqy733maq=MAQUINA;




    TYPE Tp_jaqy733pais IS TABLE OF jaqy733.jaqy733pais%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733tdoc IS TABLE OF jaqy733.jaqy733tdoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733ndoc IS TABLE OF jaqy733.jaqy733ndoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733docod IS TABLE OF jaqy733.jaqy733docod %TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733corr IS TABLE OF jaqy733.jaqy733corr%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733usu IS TABLE OF jaqy733.jaqy733usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733maq IS TABLE OF jaqy733.jaqy733maq%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt1  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt2  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt3  IS TABLE OF jaqy733.Jaqy733txt1 %TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt4  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt5  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt6  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt7  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt8  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt9  IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt10 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt11 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt12 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt13 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt14 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733_txt15 IS TABLE OF jaqy733.Jaqy733txt1%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy733dir IS TABLE OF jaqy733.jaqy733dir%TYPE INDEX BY PLS_INTEGER;


    jaqy733pais  Tp_jaqy733pais;
    jaqy733tdoc  Tp_jaqy733tdoc;
    jaqy733ndoc  Tp_jaqy733ndoc;
    jaqy733docod Tp_jaqy733docod;
    jaqy733corr  Tp_jaqy733corr;
    jaqy733usu   Tp_jaqy733usu;
    jaqy733maq   Tp_jaqy733maq;
    JAQY733DIR     Tp_jaqy733dir;
    jaqy733txt1  Tp_jaqy733_txt1;
    jaqy733txt2  Tp_jaqy733_txt2;
    jaqy733txt3  Tp_jaqy733_txt3;
    jaqy733txt4  Tp_jaqy733_txt4;
    jaqy733txt5  Tp_jaqy733_txt5;
    jaqy733txt6  Tp_jaqy733_txt6;
    jaqy733txt7  Tp_jaqy733_txt7;
    jaqy733txt8  Tp_jaqy733_txt8;
    jaqy733txt9  Tp_jaqy733_txt9;
    jaqy733txt10 Tp_jaqy733_txt10;
    jaqy733txt11 Tp_jaqy733_txt11;
    jaqy733txt12 Tp_jaqy733_txt12;
    jaqy733txt13 Tp_jaqy733_txt13;
    jaqy733txt14 Tp_jaqy733_txt14;
    jaqy733txt15 Tp_jaqy733_txt15;

   
   LN_FLAG NUMBER(1);
   CONT NUMBER(2);
   CANT_COIN NUMBER(10);
   CANT_REP_PAL NUMBER(10);
   
   LIM NUMBER(10);
   LC_NOMBRE CHAR(30);
   LC_CAD_BUSQUEDA VARCHAR2(500);
   LC_CAD VARCHAR2(100);

    type tpy_txt is table of jaqy733.jaqy733txt1%type index by binary_integer;
    LC_array tpy_txt;
    l_tpnro number(10);
begin
    P_TOT_CON:=0;
    USUARIO:=TRIM(P_USU);
    MAQUINA:=TRIM(P_MAQUINA);

    execute immediate 'DELETE FROM jaqy734 WHERE jaqy734usu='||''''||TRIM(P_USU)||''''||' AND jaqy734maq='||''''||TRIM(P_MAQUINA)||'''';
    COMMIT;
   --SE LIMPIA LA CADENA INICIAL
   select tpnro into l_tpnro from fst098 where  pgcod=1 and  tpcod=7689 and tpcorr=1;
     LC_CAD_BUSQUEDA:=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(P_BUSQUEDA,'-',' '),'''',' '),',',' '),')',' '),'(',' '),'=',' '),'#',' '),'°',' '),'.','');
     CONT:=0;

     FOR I IN 1..15 LOOP
           LC_CAD:= TRIM(REGEXP_SUBSTR(LC_CAD_BUSQUEDA, '[^ ]+', 1, I));
           IF(LENGTH(LC_CAD)>0) THEN
             BEGIN
                  SELECT  1  INTO LN_FLAG FROM fst098 WHERE  pgcod=1 AND tpcod=7688  AND TRIM(TPDESC)=TRIM(LC_CAD);
                   exception
             WHEN no_data_found THEN
                     CONT:=CONT+1;
                     LC_array(CONT):=LC_CAD;
             END;
           ELSE
            EXIT;
           END IF;
     END LOOP;


  --COMPARACION CON CADENA INICIAL
   OPEN DIRE;
    LOOP
      FETCH DIRE BULK COLLECT INTO jaqy733pais,jaqy733tdoc,jaqy733ndoc,jaqy733docod, jaqy733corr,
                                   jaqy733usu,jaqy733maq,JAQY733DIR,jaqy733txt1,jaqy733txt2, jaqy733txt3,
                                   jaqy733txt4,jaqy733txt5, jaqy733txt6, jaqy733txt7,
                                   jaqy733txt8,jaqy733txt9, jaqy733txt10,jaqy733txt11,
                                   jaqy733txt12,jaqy733txt13,jaqy733txt14,jaqy733txt15;

        IF jaqy733ndoc.COUNT > 0 THEN

                   FOR II IN jaqy733ndoc.FIRST .. jaqy733ndoc.LAST LOOP
                     CANT_COIN:=0;
                     CANT_REP_PAL:=0;
                     FOR CB IN 1..CONT LOOP
                       CANT_REP_PAL:=0;
                        IF(TRIM(jaqy733txt1(II))=TRIM(LC_array(CB))) AND (LENGTH(jaqy733txt1(II))>0) AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL:=CANT_REP_PAL+1;
                        END IF ;
                        IF(TRIM(jaqy733txt2(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt2(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                        IF(TRIM(jaqy733txt3(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt3(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;

                       IF(TRIM(jaqy733txt4(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt4(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt5(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt5(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt6(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt6(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt7(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt7(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                      IF(TRIM(jaqy733txt8(II))=TRIM(LC_array(CB))) AND (LENGTH(jaqy733txt8(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt9(II))=TRIM(LC_array(CB)))   AND (LENGTH(jaqy733txt9(II))>0) AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt10(II))=TRIM(LC_array(CB))) AND (LENGTH(jaqy733txt10(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                      IF(TRIM(jaqy733txt11(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt11(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                      IF(TRIM(jaqy733txt12(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt12(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt13(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt13(II))>0) AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt14(II))=TRIM(LC_array(CB))) AND (LENGTH(jaqy733txt14(II))>0)  AND (CANT_REP_PAL<1) THEN
                              CANT_COIN:=CANT_COIN+1;
                              CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                       IF(TRIM(jaqy733txt15(II))=TRIM(LC_array(CB)))  AND (LENGTH(jaqy733txt15(II))>0)  AND (CANT_REP_PAL<1)  THEN
                              CANT_COIN:=CANT_COIN+1;
                             CANT_REP_PAL :=CANT_REP_PAL+1;
                        END IF ;
                     END LOOP;

                     LIM:=FLOOR((CONT/2))+3;--+2;
                       IF(LIM>CONT) THEN
                            LIM:=CONT;
                       END IF ;
                       IF(CANT_COIN>=LIM)  AND (CANT_REP_PAL<=1)THEN
                       BEGIN
                         SELECT PENOM INTO LC_NOMBRE FROM FSD001 WHERE  PEPAIS=jaqy733pais(II) AND PETDOC=jaqy733tdoc(II) AND PENDOC=jaqy733ndoc(II);
                         INSERT INTO JAQY734 ( JAQY734PAI,JAQY734TDOC,JAQY734NDOC,JAQY734DOCOD,JAQY734CORR,JAQY734USU,JAQY734MAQ,JAQY734DIR, JAQY734NOM)
                         VALUES(jaqy733pais(II),jaqy733tdoc(II),jaqy733ndoc(II),Jaqy733docod(II),Jaqy733corr(II),jaqy733usu(II),jaqy733maq(II),JAQY733DIR(II),LC_NOMBRE);
                         
                         P_TOT_CON:=P_TOT_CON+1;
                         IF(P_TOT_CON=l_tpnro) THEN
                                rollback;
                                RETURN;
                         END IF;
                        EXCEPTION
                         WHEN OTHERS THEN
                          LC_NOMBRE:=NULL;
                        END;
                        
                      END IF;

                   END LOOP;
                  COMMIT;

       END IF;
      EXIT WHEN DIRE%NOTFOUND;
    END LOOP;
    COMMIT;

  END sp_cr_cuenta_coincidencias;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_limpia_direccion(P_DEPT NUMBER)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_res_endeudam_entidad
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - APACHECO
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
  --                            : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
 cursor DIRE is
    select
       j.jaqy735pais,
       j.jaqy735tdoc,
       j.jaqy735ndoc,
       J.JAQY735DOCOD,
       J.JAQY735CORR,
       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(jaqy735dir),'.',' '),'-',' '),'''',' '),',',' '),')',' '),'(',' '),'=',' '),'#',' '),'°',' ')
       from jaqy735 j
       where J.JAQY735DOCOD in (1,3)
       and J.JAQY735DPTO=P_DEPT
       order by
       j.jaqy735pais,
       j.jaqy735tdoc,
       j.jaqy735ndoc,
       J.JAQY735DOCOD,
       J.JAQY735CORR;



    TYPE Tp_jaqy735pais IS TABLE OF jaqy735.jaqy735pais%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735tdoc IS TABLE OF jaqy735.jaqy735tdoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735ndoc IS TABLE OF jaqy735.jaqy735ndoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735corr IS TABLE OF jaqy735.jaqy735corr%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735docod IS TABLE OF jaqy735.jaqy735corr%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735dir IS TABLE OF jaqy735.jaqy735dir%TYPE INDEX BY PLS_INTEGER;


    jaqy735pais  Tp_jaqy735pais;
    jaqy735tdoc  Tp_jaqy735tdoc;
    jaqy735ndoc  Tp_jaqy735ndoc;
    JAQY735DOCOD  Tp_jaqy735docod;
    jaqy735corr  Tp_jaqy735corr;
    jaqy735dir   Tp_jaqy735dir;

   /*Cursor C_ZONAS IS
   select TPDESC from fst098 where tpcod=7688 and pgcod=1;*/
   LN_FLAG NUMBER(1);
   CONT NUMBER(2);

   LC_NOM VARCHAR2(140);
   LC_CAD VARCHAR2(100);
   LC_INI_CONS VARCHAR2(5000);



    type tpy_txt is table of jaqy735.jaqy735txt1%type index by binary_integer;
    LC_array tpy_txt;
begin


   OPEN DIRE;
    LOOP
      FETCH DIRE BULK COLLECT INTO  jaqy735pais, jaqy735tdoc,jaqy735ndoc,JAQY735DOCOD,jaqy735corr,jaqy735dir;


        IF jaqy735ndoc.COUNT > 0 THEN

         FOR II IN jaqy735ndoc.FIRST .. jaqy735ndoc.LAST LOOP
                 LC_NOM:= jaqy735dir(II);

                 CONT:=0;

                 FOR I IN 1..15 LOOP
                       LC_CAD:= TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, I));
                       IF(LENGTH(LC_CAD)>0) THEN
                         BEGIN
                              SELECT  1  INTO LN_FLAG FROM fst098 WHERE  pgcod=1 AND tpcod=7688  AND TRIM(TPDESC)=TRIM(LC_CAD);
                               exception
                         WHEN no_data_found THEN
                                 CONT:=CONT+1;
                                 LC_array(CONT):=LC_CAD;
                         END;
                      ELSE
                       EXIT;
                      END IF;
                 END LOOP;

                IF(CONT>=1)THEN
                      LC_INI_CONS:='UPDATE JAQY735 SET  ';

                      FOR J IN 1..CONT-1 LOOP
                           LC_INI_CONS:=TRIM(LC_INI_CONS)||' jaqy735TXT'||TO_CHAR(J)||'='
                                        ||''''||TRIM(LC_array(J))||''''||','  ;
                      END LOOP;
                            LC_INI_CONS:=TRIM(LC_INI_CONS)||' jaqy735TXT'||TO_CHAR(CONT)||'='
                                        ||''''||TRIM(LC_array(CONT))||''''  ;

                      LC_INI_CONS:=TRIM(LC_INI_CONS)||' WHERE  jaqy735pais ='||jaqy735pais(II)||
                                     ' AND jaqy735tdoc ='||jaqy735tdoc(II)||
                                     ' AND jaqy735ndoc ='||''''||TRIM(jaqy735ndoc(II))||''''||
                                     ' AND JAQY735DOCOD ='||JAQY735DOCOD(II)||
                                     ' AND jaqy735corr ='||jaqy735corr(II) ;

                       --   INSERT INTO ERROR_JOB (MSG,DNI,DOCOD) VALUES (trim(LC_INI_CONS),TRIM(jaqy735ndoc(II)),JAQY735DOCOD(II));
                          COMMIT;

                      execute immediate LC_INI_CONS;
                END IF;


              --   commit;
         END LOOP;
      END IF;
      EXIT WHEN DIRE%NOTFOUND;
    END LOOP;
    COMMIT;

  END sp_cr_limpia_direccion;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_limpia_direccion_JOBS
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_res_endeudam_entidad
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - APACHECO
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
  --                            : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
 cursor C_DEPARTAMENTOS_JOBS is
        select DEPCOD from fst068;
 lc_variable   varchar2(4000);
 ln_job        number:= 0;
 lc_hostname varchar2(64);
 begin
     begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
     for job in C_DEPARTAMENTOS_JOBS loop

         lc_variable := ' begin '||
              ' PQ_CR_BUSQUEDA_DIRECCION.sp_cr_limpia_direccion(to_number('''||JOB.DEPCOD||'''))'||';'||
              ' End; ';

              ln_job := ln_job +1;
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
dbms_output.put_line(lc_variable);
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,
                      force => false
                      );
else
  dbms_output.put_line(lc_variable);
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        commit;

     end loop;

END sp_cr_limpia_direccion_JOBS;
  
Procedure sp_cr_limpia_registros(P_USU in varchar2, P_MAQUINA in varchar2)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_volcado_palabras
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - SFERNANDEM
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE DIRECCIONES DE ACUERDO A UBIGEO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_UBIGEO,P_USU,P_MAQUINA
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
 
 LC_SQL varchar2(1000);

begin
   
   execute immediate 'DELETE FROM JAQY733 WHERE JAQY733USU ='||''''||TRIM(P_USU)||''''||' AND JAQY733MAQ='||''''||TRIM(P_MAQUINA)||'''';
   commit;
   execute immediate 'DELETE FROM JAQY734 WHERE JAQY734USU ='||''''||TRIM(P_USU)||''''||' AND JAQY734MAQ='||''''||TRIM(P_MAQUINA)||'''';
   commit;
end sp_cr_limpia_registros;
--------------------------------------------------------------------------------------------------
Procedure sp_cr_nro_medidor(P_T_MED in varchar2,P_NRO_MED in varchar2,P_UBIGEO in VARCHAR2,P_USU in varchar2,
                             P_MAQUINA in varchar2,P_TOT_CON out number)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_cuenta_coincidencias
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC - SFERNANDEM
  -- Uso                        : BUSCA LAS COINCIDENCIAS Y LAS ALMACENA EN JAQY734
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_BUSQUEDA ( DIRECCION DE BUSQUEDA)
  --                            : P_USU ( USUARIO ),P_MAQUINA(MAQUINA)
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
  USUARIO CHAR(30);
  MAQUINA CHAR(20);
  LC_MEDIDOR char(100);
  Lc_ubigeo number(10);--jaqy735.jaqy735ugeo%type;
  cursor M_AGUA is
       select
         j.jaqy735pais,
         j.jaqy735tdoc,
         j.jaqy735ndoc,
         j.jaqy735docod,
         j.jaqy735corr,
         j.jaqy735dir
         from jaqy735 j
          where j.jaqy735medagua=LC_MEDIDOR
          and j.jaqy735dpto=Lc_ubigeo
          and j.jaqy735est='H';
   cursor M_LUZ is
       select
         j.jaqy735pais,
         j.jaqy735tdoc,
         j.jaqy735ndoc,
         j.jaqy735docod,
         j.jaqy735corr,
         j.jaqy735dir
         from jaqy735 j
          where j.jaqy735medluz=LC_MEDIDOR
          and j.jaqy735dpto=Lc_ubigeo
          and j.jaqy735est='H'
          ;
        
    TYPE Tp_jaqy735pais IS TABLE OF jaqy735.jaqy735pais%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735tdoc IS TABLE OF jaqy735.jaqy735tdoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735ndoc IS TABLE OF jaqy735.jaqy735ndoc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735docod IS TABLE OF jaqy735.jaqy735docod %TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735corr IS TABLE OF jaqy735.jaqy735corr%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaqy735dir IS TABLE OF jaqy735.jaqy735dir%TYPE INDEX BY PLS_INTEGER;


    jaqy735pais  Tp_jaqy735pais;
    jaqy735tdoc  Tp_jaqy735tdoc;
    jaqy735ndoc  Tp_jaqy735ndoc;
    jaqy735docod Tp_jaqy735docod;
    jaqy735corr  Tp_jaqy735corr;
    JAQY735DIR   Tp_jaqy735dir;   
    LC_NOMBRE  CHAR(30);
    
  begin
  Lc_ubigeo:=to_number(substr(trim(P_UBIGEO),1,2));
  LC_MEDIDOR:=UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(P_NRO_MED),'.',''),'-',''),'''',''),',',''),')',''),'(',''),'=',''),'#',''),'°',''));
  LC_MEDIDOR:=trim(LC_MEDIDOR);
  execute immediate 'DELETE FROM jaqy734 WHERE jaqy734usu='||''''||TRIM(P_USU)||''''||' AND jaqy734maq='||''''||TRIM(P_MAQUINA)||'''';
   COMMIT;
  IF(trim(P_T_MED))='A' THEN
    OPEN M_AGUA;
    LOOP
      FETCH M_AGUA BULK COLLECT INTO jaqy735pais,jaqy735tdoc,jaqy735ndoc,jaqy735docod, jaqy735corr,JAQY735DIR;
           IF jaqy735ndoc.COUNT > 0 THEN   
             FOR II IN jaqy735ndoc.FIRST .. jaqy735ndoc.LAST LOOP 
             SELECT PENOM INTO LC_NOMBRE FROM FSD001 WHERE  PEPAIS=jaqy735pais(II) AND PETDOC=jaqy735tdoc(II) AND PENDOC=jaqy735ndoc(II);                               
               INSERT INTO JAQY734 ( JAQY734PAI,JAQY734TDOC,JAQY734NDOC,JAQY734DOCOD,JAQY734CORR,JAQY734USU,JAQY734MAQ,JAQY734DIR,JAQY734NOM)
                 VALUES(jaqy735pais(II),jaqy735tdoc(II),jaqy735ndoc(II),Jaqy735docod(II),Jaqy735corr(II),P_USU,P_MAQUINA,JAQY735DIR(II),LC_NOMBRE);
                COMMIT; 
             END LOOP;
            ELSE 
            EXIT;
           END IF;
      END LOOP;                                                  
  END IF;
  if(trim(P_T_MED))='L' THEN
    OPEN M_LUZ;
    LOOP
      FETCH M_LUZ BULK COLLECT INTO jaqy735pais,jaqy735tdoc,jaqy735ndoc,jaqy735docod, jaqy735corr,JAQY735DIR;
           IF jaqy735ndoc.COUNT > 0 THEN   
             FOR II IN jaqy735ndoc.FIRST .. jaqy735ndoc.LAST LOOP 
             SELECT PENOM INTO LC_NOMBRE FROM FSD001 WHERE  PEPAIS=jaqy735pais(II) AND PETDOC=jaqy735tdoc(II) AND PENDOC=jaqy735ndoc(II);                               
               INSERT INTO JAQY734 ( JAQY734PAI,JAQY734TDOC,JAQY734NDOC,JAQY734DOCOD,JAQY734CORR,JAQY734USU,JAQY734MAQ,JAQY734DIR,JAQY734NOM)
                 VALUES(jaqy735pais(II),jaqy735tdoc(II),jaqy735ndoc(II),Jaqy735docod(II),Jaqy735corr(II),P_USU,P_MAQUINA,JAQY735DIR(II),LC_NOMBRE);
                COMMIT; 
             END LOOP;
           ELSE 
            EXIT;               
           END IF;
      END LOOP;   
  ELSE
    RETURN;
  END IF;
  EXCEPTION 
  WHEN others then
       return;
  
  END sp_cr_nro_medidor;
-----------------------------------------------------------------------------------------------  
-----------------------------------------------------------------------------------------------------------------
Procedure sp_limpia_medidor_direccion(P_DIRECCION IN varchar2,P_R_DIRECCION out varchar)
is
  -- ******************************************************************************************************
  -- Nombre                     : fn_limpia_direccion
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Calcula la cantidad de avales
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1, pn_inst: instancia
  -- Par¿metros de Salida       : ln_cant_av: cantidad de avales
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

 LC_NOM VARCHAR2(140);
 LC_CAD VARCHAR2(100);
 LC_MED_AGUA VARCHAR2(100);
 LC_MED_LUZ VARCHAR2(100);
 LN_POSMED NUMBER(10);
 lc_error varchar2(100);
 
begin
  --BUSCO MEDIDOR AGUA
   SELECT INSTR(P_DIRECCION,'MEDIDOR AGUA') INTO LN_POSMED FROM DUAL; 
   LC_NOM:=substr(P_DIRECCION,LN_POSMED);
   IF(LN_POSMED>0) THEN  
       LC_MED_AGUA:=TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, 3));     
   END IF; 
   
   --BUSCO MEDIDOR LUZ
   SELECT INSTR(P_DIRECCION,'MEDIDOR LUZ') INTO LN_POSMED FROM DUAL; 
   LC_NOM:=substr(P_DIRECCION,LN_POSMED);
   IF(LN_POSMED>0) THEN
       LC_MED_LUZ:=TRIM(REGEXP_SUBSTR(LC_NOM, '[^ ]+', 1, 3));  
   END IF;
   
   LC_NOM:=REPLACE(P_DIRECCION,'MEDIDOR AGUA','');
   LC_NOM:=REPLACE(LC_NOM,'MEDIDOR LUZ','');
   LC_NOM:=REPLACE(LC_NOM,LC_MED_AGUA,'');
   LC_NOM:=REPLACE(LC_NOM,LC_MED_LUZ,'');
   --LIMPIANDO LA DIRECCION  DE CARACTERES EXTRAÑOS
   LC_NOM:= UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LC_NOM),'.',' '),'-',' '),'''',' '),',',' '),')',' '),'(',' '),'=',' '),'#',' '),'°',' '));   
   LC_NOM:=REPLACE(LC_NOM,';',' ');
   P_R_DIRECCION:=LC_NOM;
exception
    when no_data_found then
     lc_error:= sqlcode;
    when others then
     lc_error:= sqlcode;
--     lc_coderr:=sqlerrm;
end sp_limpia_medidor_direccion;



end   PQ_CR_BUSQUEDA_DIRECCION_2;
/

