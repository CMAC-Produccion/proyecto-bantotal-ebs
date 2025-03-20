create or replace package PQ_CR_SEGURO_SG is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos_INI( pd_fecpro in date);   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_selecciona_SD/*( pd_fecpro in date)*/; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos_bc( pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_SEGURO_SG;
/

create or replace package body PQ_CR_SEGURO_SG is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_SEGURO_SG
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.31
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.08.06
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: sp_cr_carga_datos, sp_cr_carga_datos_ini
    --                            : 2014.12.01 DCASTRO Se modifico sp_cr_inserta_tabla,  
    --                            : 2014.12.10 DCASTRO SE modifico sp_cr_carga_datos, sp_cr_inserta_tabla
    --                            :            SFERNANDEM Se modifico sp_cr_inserta_tabla
    --                            : 2016.04.25 DCASTRO Se modifico proceso sp_cr_carga_datos_bc           
    -- Autor Modificacion         : SMARQUEZ
    -- Fecha y Motivo Modificación; 03/05/2024 Considerar a los seguros de Multiriesgo en ls FPP080
    -- *****************************************************************
      

  procedure sp_cr_carga_datos_INI( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos_BC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.03.24
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS DE TABLA FPP080
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: DCASTRO  2018.11.28 se modifico nombre de procedimiento sp_cr_carga_datos_INI
    -- *****************************************************************


cursor creditos( ld_fecpro date) is

 select 
   FPP080EMP JAQL986EMP,
   FPP080CIA JAQL986CIA,
   FPP080TSE JAQL986TSE,
   FPP080SEG JAQL986SEG,
   FPP080MOD JAQL986MOD,
   FPP080SUC JAQL986SUC,
   FPP080MDA JAQL986MDA,
   FPP080PAP JAQL986PAP,
   FPP080CTA JAQL986CTA,
   FPP080OPE JAQL986OPE,
   FPP080SBO JAQL986SBO,
   FPP080TOP JAQL986TOP,
   FPP080FPA JAQL986FPA,
   FPP080TIP JAQL986TIP,
   FPP080FEC JAQL986FEC,
   FPP080IMP JAQL986IMP,
   FPP080AU1 JAQL986AU1,
   FPP080AU2 JAQL986AU2,
   FPP080AU3 JAQL986AU3,
   FPP080AU4 JAQL986AU4,
   FPP080AU5 JAQL986AU5,
   FPP080AU6 JAQL986AU6,
   FPP080AU7 JAQL986AU7,
   FPP080AU8 JAQL986AU8,
   FPP080AU9 JAQL986AU9,
   FPP080A10 JAQL986A10,
   FPP080A12 JAQL986A12,
   FPP080A11 JAQL986A11 
    from FPP080 a 
  where fpp080emp = 1 and  FPP080FEC = pd_fecpro and a.fpp080cia = 723198 and fpp080tse = 5  ; -- SMA 03/05/2024

 
  TYPE Tp_JAQL986EMP  IS TABLE OF JAQL986.JAQL986EMP%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL986CIA  IS TABLE OF JAQL986.JAQL986CIA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986TSE  IS TABLE OF JAQL986.JAQL986TSE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986SEG  IS TABLE OF JAQL986.JAQL986SEG%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986MOD  IS TABLE OF JAQL986.JAQL986MOD%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986SUC  IS TABLE OF JAQL986.JAQL986SUC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986MDA  IS TABLE OF JAQL986.JAQL986MDA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986PAP  IS TABLE OF JAQL986.JAQL986PAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986CTA  IS TABLE OF JAQL986.JAQL986CTA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986OPE  IS TABLE OF JAQL986.JAQL986OPE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986SBO  IS TABLE OF JAQL986.JAQL986SBO%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986TOP  IS TABLE OF JAQL986.JAQL986TOP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986FPA  IS TABLE OF JAQL986.JAQL986FPA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986TIP  IS TABLE OF JAQL986.JAQL986TIP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986FEC  IS TABLE OF JAQL986.JAQL986FEC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986IMP  IS TABLE OF JAQL986.JAQL986IMP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986AU1  IS TABLE OF JAQL986.JAQL986AU1%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986AU2  IS TABLE OF JAQL986.JAQL986AU2%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986AU3  IS TABLE OF JAQL986.JAQL986AU3%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986AU4  IS TABLE OF JAQL986.JAQL986AU4%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL986AU5  IS TABLE OF JAQL986.JAQL986AU5%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL986AU6  IS TABLE OF JAQL986.JAQL986AU6%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986AU7  IS TABLE OF JAQL986.JAQL986AU7%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL986AU8  IS TABLE OF JAQL986.JAQL986AU8%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL986AU9  IS TABLE OF JAQL986.JAQL986AU9%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL986A10  IS TABLE OF JAQL986.JAQL986A10%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986A12  IS TABLE OF JAQL986.JAQL986A12%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL986A11  IS TABLE OF JAQL986.JAQL986A11%TYPE INDEX BY PLS_INTEGER;
 

  JAQL986EMP  Tp_JAQL986EMP; 
  JAQL986CIA  Tp_JAQL986CIA;
  JAQL986TSE  Tp_JAQL986TSE;
  JAQL986SEG  Tp_JAQL986SEG;
  JAQL986MOD  Tp_JAQL986MOD;
  JAQL986SUC  Tp_JAQL986SUC;
  JAQL986MDA  Tp_JAQL986MDA;
  JAQL986PAP  Tp_JAQL986PAP;
  JAQL986CTA  Tp_JAQL986CTA;
  JAQL986OPE  Tp_JAQL986OPE;
  JAQL986SBO  Tp_JAQL986SBO;
  JAQL986TOP  Tp_JAQL986TOP;
  JAQL986FPA  Tp_JAQL986FPA;
  JAQL986TIP  Tp_JAQL986TIP;
  JAQL986FEC  Tp_JAQL986FEC;
  JAQL986IMP  Tp_JAQL986IMP;
  JAQL986AU1  Tp_JAQL986AU1;
  JAQL986AU2  Tp_JAQL986AU2;
  JAQL986AU3  Tp_JAQL986AU3;
  JAQL986AU4  Tp_JAQL986AU4;
  JAQL986AU5  Tp_JAQL986AU5;
  JAQL986AU6  Tp_JAQL986AU6;
  JAQL986AU7  Tp_JAQL986AU7;
  JAQL986AU8  Tp_JAQL986AU8;
  JAQL986AU9  Tp_JAQL986AU9;
  JAQL986A10  Tp_JAQL986A10;
  JAQL986A12  Tp_JAQL986A12;
  JAQL986A11  Tp_JAQL986A11;
  
   
  
begin

--ELIMINAR REGISTROS DE FECHA YA PROCESADA
   DELETE FROM JAQL986 WHERE JAQL986FEC = pd_fecpro;
   commit; 
 

   OPEN creditos( pd_fecpro );
    LOOP
      FETCH creditos BULK COLLECT
        INTO JAQL986EMP,JAQL986CIA,JAQL986TSE,JAQL986SEG,JAQL986MOD,JAQL986SUC,JAQL986MDA,JAQL986PAP,JAQL986CTA,
            JAQL986OPE,JAQL986SBO,JAQL986TOP,JAQL986FPA,JAQL986TIP,JAQL986FEC,JAQL986IMP,JAQL986AU1,JAQL986AU2,
            JAQL986AU3,JAQL986AU4,JAQL986AU5,JAQL986AU6,JAQL986AU7,JAQL986AU8,JAQL986AU9,JAQL986A10,JAQL986A12,
            JAQL986A11;
              
          IF JAQL986EMP.COUNT > 0 THEN
             FOR i IN JAQL986EMP.FIRST .. JAQL986EMP.LAST LOOP
       
               insert into JAQL986 (JAQL986EMP,JAQL986CIA,JAQL986TSE,JAQL986SEG,JAQL986MOD,JAQL986SUC,JAQL986MDA,JAQL986PAP,JAQL986CTA,
                                    JAQL986OPE,JAQL986SBO,JAQL986TOP,JAQL986FPA,JAQL986TIP,JAQL986FEC,JAQL986IMP,JAQL986AU1,JAQL986AU2,
                                    JAQL986AU3,JAQL986AU4,JAQL986AU5,JAQL986AU6,JAQL986AU7,JAQL986AU8,JAQL986AU9,JAQL986A10,JAQL986A12,
                                    JAQL986A11
                                   ) 
                   
               values (JAQL986EMP(i),JAQL986CIA(i),JAQL986TSE(i),JAQL986SEG(i),JAQL986MOD(i),JAQL986SUC(i),JAQL986MDA(i),JAQL986PAP(i),JAQL986CTA(i),
                      JAQL986OPE(i),JAQL986SBO(i),JAQL986TOP(i),JAQL986FPA(i),JAQL986TIP(i),JAQL986FEC(i),JAQL986IMP(i),JAQL986AU1(i),JAQL986AU2(i),
                      JAQL986AU3(i),JAQL986AU4(i),JAQL986AU5(i),JAQL986AU6(i),JAQL986AU7(i),JAQL986AU8(i),JAQL986AU9(i),JAQL986A10(i),JAQL986A12(i),
                      JAQL986A11(i)                     
                      );
        
               
              
             END LOOP;
             commit; ---2015
          END IF;    
        
        
         
        
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
   
   --commit;  

  --trunca tabla
  --execute immediate 'truncate table FPP080';  2016.04.25 se comento eliminacion de tabla
 
 
 end sp_cr_carga_datos_INI;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_selecciona_SD/*( pd_fecpro in date)*/ is
    -- *****************************************************************
    -- Nombre                     : sp_cr_selecciona_SD
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.03.24
    -- Autor de Creación          : DCASTRO
    -- Uso                        : DEPURA DATOS DE TABLA FPP080 - solo mantiene creditos con SD.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

--ln_CtaCia number;  
  
begin
  /* se comento guia 28112019
  begin        
    select tp1nro1 
      into ln_CtaCia
      from fst198 
     where tp1cod1 = 10898 and tp1corr1=9;
  exception when no_data_found then
      ln_CtaCia := 0;            
  end;    
  */
  
   --ELIMINAR REGISTROS DE FECHA YA PROCESADA
  
  DELETE FROM FPP080 f where f.fpp080emp = 1 and f.fpp080tse  not in (5,3) /*--fpp080cia <> ln_CtaCia*/; 
  --sma 03/05/2024
   commit; 
   
  DELETE FPP080 f where f.fpp080emp = 1 and f.fpp080tse  = 3  AND f.fpp080imp < 5.1 
     and f.fpp080seg in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875 
     and tp1corr1 =9);

    commit; 
 end sp_cr_selecciona_SD;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_carga_datos_bc( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos_BC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2018.11.28
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS DE TABLA FPP080
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 20/08/2019
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modificó insercion de la tabla  FPP080 inserta solo desgravamen.
    -- *****************************************************************

begin 
  

   --ELIMINAR REGISTROS DE FECHA YA PROCESADA
   DELETE FROM JAQL986 WHERE JAQL986FEC = pd_fecpro;
   commit; 


   insert into JAQL986
   (JAQL986EMP,JAQL986CIA,JAQL986TSE,JAQL986SEG,JAQL986MOD,JAQL986SUC,JAQL986MDA,JAQL986PAP,JAQL986CTA,
    JAQL986OPE,JAQL986SBO,JAQL986TOP,JAQL986FPA,JAQL986TIP,JAQL986FEC,JAQL986IMP,JAQL986AU1,JAQL986AU2,
    JAQL986AU3,JAQL986AU4,JAQL986AU5,JAQL986AU6,JAQL986AU7,JAQL986AU8,JAQL986AU9,JAQL986A10,JAQL986A12,
    JAQL986A11
   ) 
    select /*+parallel(a,10)*/
       a.FPP080EMP JAQL986EMP,
       a.FPP080CIA JAQL986CIA,
       a.FPP080TSE JAQL986TSE,
       a.FPP080SEG JAQL986SEG,
       a.FPP080MOD JAQL986MOD,
       a.FPP080SUC JAQL986SUC,
       a.FPP080MDA JAQL986MDA,
       a.FPP080PAP JAQL986PAP,
       a.FPP080CTA JAQL986CTA,
       a.FPP080OPE JAQL986OPE,
       a.FPP080SBO JAQL986SBO,
       a.FPP080TOP JAQL986TOP,
       a.FPP080FPA JAQL986FPA,
       a.FPP080TIP JAQL986TIP,
       a.FPP080FEC JAQL986FEC,
       a.FPP080IMP JAQL986IMP,
       a.FPP080AU1 JAQL986AU1,
       a.FPP080AU2 JAQL986AU2,
       a.FPP080AU3 JAQL986AU3,
       a.FPP080AU4 JAQL986AU4,
       a.FPP080AU5 JAQL986AU5,
       a.FPP080AU6 JAQL986AU6,
       a.FPP080AU7 JAQL986AU7,
       a.FPP080AU8 JAQL986AU8,
       a.FPP080AU9 JAQL986AU9,
       a.FPP080A10 JAQL986A10,
       a.FPP080A12 JAQL986A12,
       a.FPP080A11 JAQL986A11
     from FPP080 a  ---FPP080EMP, FPP080FEC, FPP080CIA, FPP080TSE, FPP080SEG
     where a.fpp080emp = 1  --fecha del mes a procesar
       and a.FPP080FEC = pd_fecpro 
       and a.fpp080cia = 723198 --sma 03/05/2024
       and a.fpp080tse = 5 ; --se agrego condición para filtrar antes de cargar tabla para tramas desgravamen
   
   commit;  

  --trunca tabla
  --execute immediate 'truncate table FPP080';  2016.04.25 se comento eliminacion de tabla
 
 
 end sp_cr_carga_datos_bc;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_SEGURO_SG;
/

