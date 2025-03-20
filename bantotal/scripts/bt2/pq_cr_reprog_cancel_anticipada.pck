CREATE OR REPLACE PACKAGE PQ_CR_REPROG_CANCEL_ANTICIPADA is

/* ************************************************************************************************************
    -- Nombre                     : AQPA012
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Reglas de cancelacion anticipada, Complemento al requerimiento 3202
    -- Descripción                : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/08/2021
    -- Autor de Creación          : BHERNARD S. BEISAGA ARENAS
    -- Versión                    : 2.0
    -- Fecha de Modificación      : 2024.09.05
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: sp_cr_valida_reprogramado y sp_cr_numero_cuotas_rpg_caja se agregó condición tp1cod = 1
    --
* *************************************************************************************************************/

  
  
  
  PROCEDURE sp_cr_codigo_credito(ve_instancia in int, 
                                         vo_pgcod out xwf700.xwfempresa%type,
                                         vo_aomod out xwf700.xwfmodulo%type,
                                         vo_aosuc out xwf700.xwfsucursal%type,
                                         vo_aomda out xwf700.xwfmoneda%type,
                                         vo_aopap out xwf700.xwfpapel%type,
                                         vo_aocta out xwf700.xwfcuenta%type,
                                         vo_aooper out xwf700.xwfoperacion%type,
                                         vo_aosbop out xwf700.xwfsubope%type,
                                         vo_aotope out xwf700.xwftipope%type,
                                         vo_rpta out char);
                                         
PROCEDURE sp_cr_codcre_coninstancia(ve_instancia in int, 
                                         vo_pgcod out xwf700.xwfempresa%type,
                                         vo_aomod out xwf700.xwfmodulo%type,
                                         vo_aosuc out xwf700.xwfsucursal%type,
                                         vo_aomda out xwf700.xwfmoneda%type,
                                         vo_aopap out xwf700.xwfpapel%type,
                                         vo_aocta out xwf700.xwfcuenta%type,
                                         vo_aooper out xwf700.xwfoperacion%type,
                                         vo_aosbop out xwf700.xwfsubope%type,
                                         vo_aotope out xwf700.xwftipope%type, 
                                         vo_prcins out xwf700.xwfprcins%type,                                          
                                         vo_rpta out char);
                                         
                                         
PROCEDURE sp_cr_crevigente_flujocaja(cod in xwf700.xwfempresa%type,
                                         modu in xwf700.xwfmodulo%type,
                                         suc in xwf700.xwfsucursal%type,
                                         mda in xwf700.xwfmoneda%type,
                                         pap in xwf700.xwfpapel%type,
                                         cta in xwf700.xwfcuenta%type,
                                         oper in xwf700.xwfoperacion%type,
                                         sbop in xwf700.xwfsubope%type,
                                         tope in xwf700.xwftipope%type, 
                                         vo_pactadovigente out number,
                                         vo_rpta out char);     
                                         

PROCEDURE sp_cr_crepropuesto_flujocaja(cod in xwf700.xwfempresa%type,
                                         modu in xwf700.xwfmodulo%type,
                                         suc in xwf700.xwfsucursal%type,
                                         mda in xwf700.xwfmoneda%type,
                                         pap in xwf700.xwfpapel%type,
                                         cta in xwf700.xwfcuenta%type,
                                         oper in xwf700.xwfoperacion%type,
                                         sbop in xwf700.xwfsubope%type,
                                         tope in xwf700.xwftipope%type, 
                                         vo_pactadopropuesto out number, 
                                         vo_rpta out char);                                                                         

 procedure sp_cr_valida_reprogramado(ve_instancia in int, vo_rpta out varchar);

 procedure sp_cr_valida_numero_cuotas(ve_instancia in int, vo_rpta out varchar);

 procedure sp_cr_porcentaje_primera_cuota(ve_instancia in int, vo_rpta out varchar);

 procedure sp_cr_ultima_cuota_al_capital(ve_instancia in int, vo_rpta out varchar);
  
 procedure sp_cr_fchvenc_primcuota(ve_instancia in int, vo_rpta out varchar);
 
 procedure sp_cr_cuotas_pndtes_antes(ve_instancia in int, vo_rpta out varchar); 
 
 procedure sp_cr_nuevacuota_menororiginal(ve_instancia in int, vo_rpta out varchar);
 
 procedure sp_cr_saldo_capital (pn_pgcod in number, pn_lcmod in number, pn_lcsuc in number, 
               pn_lcmda in number, pn_lcpap in number, pn_lccta in number, pn_lcoper in number,
               pn_lcsbop in number, pn_lctope in number, pn_sdocapital out number);
     
 procedure sp_cr_deuda_viva_credito (pn_pgcod in number, pn_lcmod in number, pn_lcsuc in number, 
               pn_lcmda in number, pn_lcpap in number, pn_lccta in number, pn_lcoper in number,
               pn_lcsbop in number, pn_lctope in number, pn_deudaviva out number, pv_rpta out varchar2);
               
 procedure sp_cr_instancia_vinculada (pn_instancia in number, pn_instancia2 out number);
 
 procedure sp_cr_fch_primcuota_rpg_caja(ve_instancia in int, vo_rpta out varchar);
   
 procedure sp_cr_primera_cuota_rpg_caja(ve_instancia in int, vo_rpta out varchar);
 
 procedure sp_cr_numero_cuotas_rpg_caja(ve_instancia in int, vo_rpta out varchar);
 
 procedure sp_cr_ultima_cuota_rpg_caja(ve_instancia in int, vo_rpta out varchar);
 
END PQ_CR_REPROG_CANCEL_ANTICIPADA;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_REPROG_CANCEL_ANTICIPADA is
  -- Autor    : BHERNARD S. BEISAGA ARENAS
  -- Creado   : 03/08/20212
  -- Objetivo : Reglas de cancelacion anticipada, Complemento al requerimiento 3202
  -- MOdificaicon de reglas requerimiento 3210
  
--1
     PROCEDURE sp_cr_codigo_credito(ve_instancia in int, 
                                         vo_pgcod out xwf700.xwfempresa%type,
                                         vo_aomod out xwf700.xwfmodulo%type,
                                         vo_aosuc out xwf700.xwfsucursal%type,
                                         vo_aomda out xwf700.xwfmoneda%type,
                                         vo_aopap out xwf700.xwfpapel%type,
                                         vo_aocta out xwf700.xwfcuenta%type,
                                         vo_aooper out xwf700.xwfoperacion%type,
                                         vo_aosbop out xwf700.xwfsubope%type,
                                         vo_aotope out xwf700.xwftipope%type, vo_rpta out char) is
     BEGIN
          BEGIN
                select xwfempresa,
                       xwfmodulo,
                       xwfsucursal,
                       xwfmoneda,
                       xwfpapel,
                       xwfcuenta,
                       xwfoperacion,
                       xwfsubope,
                       xwftipope
                  into vo_pgcod ,
                       vo_aomod ,
                       vo_aosuc ,
                       vo_aomda ,
                       vo_aopap ,
                       vo_aocta,
                       vo_aooper,
                       vo_aosbop,
                       vo_aotope
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';                  
                  vo_rpta :='S';                  
          EXCEPTION
              when others then
                  vo_rpta := 'N';
          END;

      END;   

-----BBA
PROCEDURE sp_cr_codcre_coninstancia(ve_instancia in int, 
                                         vo_pgcod out xwf700.xwfempresa%type,
                                         vo_aomod out xwf700.xwfmodulo%type,
                                         vo_aosuc out xwf700.xwfsucursal%type,
                                         vo_aomda out xwf700.xwfmoneda%type,
                                         vo_aopap out xwf700.xwfpapel%type,
                                         vo_aocta out xwf700.xwfcuenta%type,
                                         vo_aooper out xwf700.xwfoperacion%type,
                                         vo_aosbop out xwf700.xwfsubope%type,
                                         vo_aotope out xwf700.xwftipope%type, 
                                         vo_prcins out xwf700.xwfprcins%type,                                          
                                         vo_rpta out char) is
BEGIN
  BEGIN                      
          SELECT XWFEMPRESA, XWFMODULO,XWFSUCURSAL, XWFMONEDA , XWFPAPEL, XWFCUENTA, XWFOPERACION, XWFSUBOPE, XWFTIPOPE , xwfprcins
                    into vo_pgcod , vo_aomod ,vo_aosuc , vo_aomda , vo_aopap ,vo_aocta, vo_aooper, vo_aosbop, vo_aotope, vo_prcins          
          FROM XWF700 WHERE (XWFEMPRESA, XWFMODULO,XWFSUCURSAL, XWFMONEDA , XWFPAPEL, XWFCUENTA, XWFOPERACION, XWFSUBOPE, XWFTIPOPE)
          IN ( select xwfempresa,
                       xwfmodulo,
                       xwfsucursal,
                       xwfmoneda,
                       xwfpapel,
                       xwfcuenta,
                       xwfoperacion,
                       AOSBOP, --suboperacion de la fsd010(laque tomo)
                       --xwfsubope,  suboepracion de xwf700 no cuenta
                       xwftipope
                from xwf700, FSD010
                 WHERE XWFEMPRESA = PGCOD AND
                    XWFMODULO = AOMOD AND
                    XWFSUCURSAL = AOSUC AND
                    XWFMONEDA  = AOMDA AND
                    XWFPAPEL = AOPAP AND
                    XWFCUENTA = AOCTA AND
                    XWFOPERACION = AOOPER AND
                   -- XWFSUBOPE = AOSBOP AND
                    XWFTIPOPE = AOTOPE AND
                    xwfprcins = ve_instancia AND
                    AOSTAT <> 99 AND
                    xwfcar3 = '1')                                 
           AND xwfcar3 = '1'
           ORDER BY xwfprcins DESC;                  
           vo_rpta :='S';                  
   EXCEPTION
              when others then
                  vo_rpta := 'N';
   END;

 END;   

-----BBA



--2
PROCEDURE sp_cr_crevigente_flujocaja(cod in xwf700.xwfempresa%type,
                                         modu in xwf700.xwfmodulo%type,
                                         suc in xwf700.xwfsucursal%type,
                                         mda in xwf700.xwfmoneda%type,
                                         pap in xwf700.xwfpapel%type,
                                         cta in xwf700.xwfcuenta%type,
                                         oper in xwf700.xwfoperacion%type,
                                         sbop in xwf700.xwfsubope%type,
                                         tope in xwf700.xwftipope%type, 
                                         vo_pactadovigente out number,
                                         vo_rpta out char) is
 vi_cuotadiferente number:=0;
-- vi_pactado number(17,2);
 vi_valorcuota number(17,2):=0.0;
 vi_dif number(17,2);
 cursor cronograma is 
  SELECT --A.PGCOD, A.PPMOD, A.PPSUC, A.PPMDA, A.PPPAP, A.PPCTA, A.PPOPER, A.PPSBOP, A.PPTOPE, A.PPFPAG, A.PPTIPO,
        --PPCAP AS CAPPAC, 
        --PPINT AS INTPAC, 
        --(PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS SEGPAC,
        PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS TOTPAC
        --NVL(PP1CAP,0) AS CAPPAG, 
        --NVL(PP1INT,0) AS INTPAG, 
        --NVL((PP1IMP10 + PP1IMP11 + PP1IMP12 + PP1IMP13 + PP1IMP14 + PP1IMP15 + PP1IMP16 + PP1IMP17 + PP1IMP18 + PP1IMP19 + PP1IMP20),0) AS SEGPAG,
        --NVL(PP1CAP,0) + NVL(PP1INT,0)  + NVL((PP1IMP10 + PP1IMP11 + PP1IMP12 + PP1IMP13 + PP1IMP14 + PP1IMP15 + PP1IMP16 + PP1IMP17 + PP1IMP18 + PP1IMP19 + PP1IMP20),0) AS  TOTPAG
    FROM FSD601 A INNER JOIN FSD611 B
    ON A.PGCOD = B.PGCOD AND A.PPMOD =B.PPMOD AND 
       A.PPSUC =B.PPSUC AND A.PPMDA =B.PPMDA AND 
       A.PPPAP =B.PPPAP AND A.PPCTA =B.PPCTA AND 
       A.PPOPER =B.PPOPER AND A.PPSBOP =B.PPSBOP AND 
       A.PPTOPE =B.PPTOPE AND A.PPFPAG =B.PPFPAG AND 
       A.PPTIPO =B.PPTIPO
    LEFT JOIN FSD602 C
    ON A.PGCOD = C.PGCOD AND A.PPMOD =C.PPMOD AND 
       A.PPSUC =C.PPSUC AND A.PPMDA =C.PPMDA AND 
       A.PPPAP =C.PPPAP AND A.PPCTA =C.PPCTA AND 
       A.PPOPER =C.PPOPER AND A.PPSBOP =C.PPSBOP AND 
       A.PPTOPE =C.PPTOPE AND A.PPFPAG =C.PPFPAG AND 
       A.PPTIPO =C.PPTIPO
     LEFT JOIN FSD612 D
    ON A.PGCOD = D.PGCOD AND A.PPMOD =D.PPMOD AND 
       A.PPSUC =D.PPSUC AND A.PPMDA =D.PPMDA AND 
       A.PPPAP =D.PPPAP AND A.PPCTA =D.PPCTA AND 
       A.PPOPER =D.PPOPER AND A.PPSBOP =D.PPSBOP AND 
       A.PPTOPE =D.PPTOPE AND A.PPFPAG =D.PPFPAG AND 
       A.PPTIPO =D.PPTIPO    
       WHERE ((PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)) -
             (NVL(PP1CAP,0) + NVL(PP1INT,0)  + NVL((PP1IMP10 + PP1IMP11 + PP1IMP12 + PP1IMP13 + PP1IMP14 + PP1IMP15 + PP1IMP16 + PP1IMP17 + PP1IMP18 + PP1IMP19 + PP1IMP20),0))) > 0 AND
       A.PGCOD = cod AND
       A.PPMOD = modu AND
       A.PPSUC = suc AND
       A.PPMDA = mda AND
       A.PPPAP = pap AND
       A.PPCTA = cta AND
       A.PPOPER = oper AND
       A.PPSBOP = sbop AND
       A.PPTOPE = tope;    
       --- AQUI EMPIESA EL CUERPO DEL PROGRAMA                                                                                                                                 
     BEGIN
       BEGIN
          SELECT                  
                  PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS TOTPAC
                  INTO vo_pactadovigente
          FROM FSD601 A INNER JOIN FSD611 B
          ON A.PGCOD = B.PGCOD AND A.PPMOD =B.PPMOD AND 
             A.PPSUC =B.PPSUC AND A.PPMDA =B.PPMDA AND 
             A.PPPAP =B.PPPAP AND A.PPCTA =B.PPCTA AND 
             A.PPOPER =B.PPOPER AND A.PPSBOP =B.PPSBOP AND 
             A.PPTOPE =B.PPTOPE AND A.PPFPAG =B.PPFPAG AND 
             A.PPTIPO =B.PPTIPO
          LEFT JOIN FSD602 C
          ON A.PGCOD = C.PGCOD AND A.PPMOD =C.PPMOD AND 
             A.PPSUC =C.PPSUC AND A.PPMDA =C.PPMDA AND 
             A.PPPAP =C.PPPAP AND A.PPCTA =C.PPCTA AND 
             A.PPOPER =C.PPOPER AND A.PPSBOP =C.PPSBOP AND 
             A.PPTOPE =C.PPTOPE AND A.PPFPAG =C.PPFPAG AND 
             A.PPTIPO =C.PPTIPO
           LEFT JOIN FSD612 D
          ON A.PGCOD = D.PGCOD AND A.PPMOD =D.PPMOD AND 
             A.PPSUC =D.PPSUC AND A.PPMDA =D.PPMDA AND 
             A.PPPAP =D.PPPAP AND A.PPCTA =D.PPCTA AND 
             A.PPOPER =D.PPOPER AND A.PPSBOP =D.PPSBOP AND 
             A.PPTOPE =D.PPTOPE AND A.PPFPAG =D.PPFPAG AND 
             A.PPTIPO =D.PPTIPO 
           WHERE ROWNUM = 1 AND               
           ((PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)) -
           (NVL(PP1CAP,0) + NVL(PP1INT,0)  + NVL((PP1IMP10 + PP1IMP11 + PP1IMP12 + PP1IMP13 + PP1IMP14 + PP1IMP15 + PP1IMP16 + PP1IMP17 + PP1IMP18 + PP1IMP19 + PP1IMP20),0))) > 0 AND
            A.PGCOD = cod AND
            A.PPMOD = modu AND
            A.PPSUC = suc AND
            A.PPMDA = mda AND
            A.PPPAP = pap AND
            A.PPCTA = cta AND
            A.PPOPER = oper AND
            A.PPSBOP = sbop AND
            A.PPTOPE = tope;                                                                                   
            
            DBMS_OUTPUT.put_line('Cta:'||cta ||' Oper:'||oper || ' SubOpe:' ||sbop);                                                                                                                                                                                      
            DBMS_OUTPUT.put_line('Vi_pactado:'|| vo_pactadovigente );                                                                                                                                                                                   
       END;       
       FOR Y IN cronograma LOOP
         BEGIN
          IF (Y.TOTPAC <> vo_pactadovigente) THEN
             vi_cuotadiferente := vi_cuotadiferente + 1;  
             vi_valorcuota := vi_valorcuota + Y.TOTPAC;
          END IF;     
         END;
       END LOOP; 
       DBMS_OUTPUT.put_line('Cuotas diferentes:'|| vi_cuotadiferente );                            
       
       --guiia para saber monto soles de diferencia entre laq ultima cuota y las demas(NO FLUJO DE CAJA, CUOTAS UNIFORMES)
       select TP1NRO1 INTO vi_dif -- el monto es 10
       from fst198 where tp1cod = 1 and tp1cod1 = 10899 and tp1corr1 = 13 and tp1corr2 = 3;
       ----------------------------------------   
 --      IF (vi_cuotadiferente > 1 or (Abs((vo_pactadopropuesto - vi_valorcuota)) > vi_dif and vi_valorcuota > 0))then
       IF (vi_cuotadiferente > 1 or (Abs((vo_pactadovigente - vi_valorcuota)) > vi_dif and vi_valorcuota > 0))then         
          vo_rpta := 'S';
                 DBMS_OUTPUT.put_line('Flujo caja VIGENTE:'|| vo_rpta );                            
       ELSE
          vo_rpta := 'N';   
                 DBMS_OUTPUT.put_line('Flujo caja VIGENTE:'|| vo_rpta );                            
       END IF;                                                   
END sp_cr_crevigente_flujocaja; 



PROCEDURE sp_cr_crepropuesto_flujocaja(cod in xwf700.xwfempresa%type,
                                         modu in xwf700.xwfmodulo%type,
                                         suc in xwf700.xwfsucursal%type,
                                         mda in xwf700.xwfmoneda%type,
                                         pap in xwf700.xwfpapel%type,
                                         cta in xwf700.xwfcuenta%type,
                                         oper in xwf700.xwfoperacion%type,
                                         sbop in xwf700.xwfsubope%type,
                                         tope in xwf700.xwftipope%type, 
                                         vo_pactadopropuesto out number, 
                                         vo_rpta out char) is
 vi_cuotadiferente number:=0;
-- vi_pactado number(17,2);
 vi_nrocuotas number:=0;
 vi_cant number:=0;
 vi_controlcuotapropuesta number:=0;
 vi_valorcuota number(17,2):=0.0;
 vi_dif number(17,2);
 cursor cronograma is 
         SELECT 
                 --A.PGCOD, A.PPMOD, A.PPSUC, A.PPMDA, A.PPPAP, A.PPCTA, A.PPOPER, A.PPSBOP, A.PPTOPE, A.PPFPAG, A.PPTIPO,
                 -- PPCAP AS CAPPAC, 
                 -- PPINT AS INTPAC, 
                 -- (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS SEGPAC,
                  PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS TOTPAC
              FROM FSD601 A INNER JOIN FSD611 B
              ON A.PGCOD = B.PGCOD AND A.PPMOD =B.PPMOD AND 
                 A.PPSUC =B.PPSUC AND A.PPMDA =B.PPMDA AND 
                 A.PPPAP =B.PPPAP AND A.PPCTA =B.PPCTA AND 
                 A.PPOPER =B.PPOPER AND A.PPSBOP =B.PPSBOP AND 
                 A.PPTOPE =B.PPTOPE AND A.PPFPAG =B.PPFPAG AND 
                 A.PPTIPO =B.PPTIPO
                 WHERE A.PGCOD = cod AND
                    A.PPMOD = modu AND
                    A.PPSUC = suc AND
                    A.PPMDA = mda AND
                    A.PPPAP = pap AND
                    A.PPCTA = cta AND
                    A.PPOPER = oper AND
                    A.PPSBOP = 609 AND -- es 609
                    A.PPTOPE = tope;                                                                                                                               
     BEGIN -- aqui empiesa el cuerpo del programa
            -- esta guia sirve para indicar desde que cuota se controla el flujo de caja en el cronograma propuesto (apartir de la 7ma)
       BEGIN 
         SELECT TP1IMP1 INTO vi_controlcuotapropuesta 
         FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 10899 AND TP1CORR1=400000 AND TP1CORR2 = 301 AND TP1CORR3=1  AND TP1NRO1=1; 
       END;  
           --guiia para saber monto soles de diferencia entre laq ultima cuota y las demas(NO FLUJO DE CAJA, CUOTAS UNIFORMES)
       BEGIN    
              select TP1NRO1 INTO vi_dif -- el monto es 10
              from fst198 where tp1cod = 1 and tp1cod1 = 10899 and tp1corr1 = 13 and tp1corr2 = 3;
       END;
       BEGIN
         WITH CRONO_7MACUO AS (
          SELECT ROW_NUMBER() OVER (ORDER BY A.PPFPAG) AS CUOTA, 
--                 A.PGCOD, A.PPMOD, A.PPSUC, A.PPMDA, A.PPPAP, A.PPCTA, A.PPOPER, A.PPSBOP, A.PPTOPE, A.PPFPAG, A.PPTIPO,
--                 PPCAP AS CAPPAC, 
--                 PPINT AS INTPAC, 
--                 (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS SEGPAC,
                 PPCAP + PPINT + (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20) AS TOTPAC
              FROM FSD601 A INNER JOIN FSD611 B
              ON A.PGCOD = B.PGCOD AND A.PPMOD =B.PPMOD AND 
                 A.PPSUC =B.PPSUC AND A.PPMDA =B.PPMDA AND 
                 A.PPPAP =B.PPPAP AND A.PPCTA =B.PPCTA AND 
                 A.PPOPER =B.PPOPER AND A.PPSBOP =B.PPSBOP AND 
                 A.PPTOPE =B.PPTOPE AND A.PPFPAG =B.PPFPAG AND 
                 A.PPTIPO =B.PPTIPO
                 WHERE 
                    A.PGCOD = cod AND
                    A.PPMOD = modu AND
                    A.PPSUC = suc AND
                    A.PPMDA = mda AND
                    A.PPPAP = pap AND
                    A.PPCTA = cta AND
                    A.PPOPER = oper AND
                    A.PPSBOP = 609 AND -- es 609
                    A.PPTOPE = tope) 
                    
             SELECT NVL(SUM(NVL(TOTPAC,0)),0), COUNT(*)
                    INTO vo_pactadopropuesto, vi_cant
             FROM CRONO_7MACUO  where cuota =vi_controlcuotapropuesta;   -- aprtir de la cuota 7                                                                                                               
             DBMS_OUTPUT.put_line('--------------------------------------------' );    
             DBMS_OUTPUT.put_line('Cta:'||cta ||' Oper:'||oper || ' SubOpe:' ||609);                                                                                                                                                                                                                                                                                                                                                                                  
             DBMS_OUTPUT.put_line('Vi_propuesto:'|| vo_pactadopropuesto );                                                                                                                                                                                   
       END;
                           
       FOR Y IN cronograma LOOP
         BEGIN
           vi_nrocuotas := vi_nrocuotas + 1;
          IF (Y.TOTPAC <> vo_pactadopropuesto and vi_nrocuotas >= vi_controlcuotapropuesta) THEN            
             vi_cuotadiferente := vi_cuotadiferente + 1;  
             vi_valorcuota := vi_valorcuota + Y.TOTPAC;
          END IF;     
         END;
       END LOOP; 
       DBMS_OUTPUT.put_line('Cuotas diferentes PROPUESTO:'|| vi_cuotadiferente );                            
       DBMS_OUTPUT.put_line('vi_valorcuota:'|| vi_valorcuota );                            
       
   
                                                                                                                                                                      
       IF (vi_cuotadiferente > 1 or (Abs((vo_pactadopropuesto - vi_valorcuota)) > vi_dif and vi_valorcuota > 0))then
          vo_rpta := 'S';
          DBMS_OUTPUT.put_line('Flujo caja PROPUESTO:'|| vo_rpta );                            

       ELSE
          vo_rpta := 'N';
          DBMS_OUTPUT.put_line('Flujo caja PROPUESTO:'|| vo_rpta );                               
       END IF;                                                   
END sp_cr_crepropuesto_flujocaja; 


-- 2
     PROCEDURE sp_cr_valida_reprogramado(ve_instancia in int, vo_rpta out varchar) is
--     ln_tipo varchar(1);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN
         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta);          
         IF (vi_rpta= 'S') THEN 
                BEGIN
                  SELECT  'S'
                     into vo_rpta
                  FROM LEY31050 L --LEY31050 L
                  INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
                  WHERE L.ESTADOSOLICITUD = 'BT'
                      AND L.TIPOFACILIDAD = 'CAJA'
                      AND LOWER(F.facilidad)  = ('amortizacion anticipada') 
                      AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = vi_aocta
                      AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = vi_aooper
                      AND F.EMPRESA  = vi_pgcod
                      AND F.SUCURSAL = vi_aosuc
                      AND F.MODULO =  vi_aomod
                      AND F.MONEDA =  vi_aomda
                      AND F.PAPEL  =  vi_aopap
                      AND F.SUBOPERACION  = vi_aosbop
                      AND F.TIPOOPERACION = vi_aotope;
                      
                      DBMS_OUTPUT.put_line('Es reprogramado para amortizacion anticipada ');
                EXCEPTION
                      WHEN OTHERS THEN
                         vo_rpta := 'N';
                         DBMS_OUTPUT.put_line('NO ES reprogramado para amortizacion anticipada ');
                END;
          ELSE
             DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
              vo_rpta := 'N';
          END IF;          
      END;
      
--3
     PROCEDURE sp_cr_valida_numero_cuotas(ve_instancia in int, vo_rpta out varchar) IS
     numCuotas INT;
     cuotMin int;
     cuotMax int;
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN

         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
      IF(vi_rpta = 'S') THEN                                                                     
          BEGIN
            SELECT COUNT(*) INTO numCuotas FROM FSD601
            WHERE PPSBOP = 609 AND
            PGCOD = vi_pgcod AND
            PPMOD = vi_aomod AND
            PPSUC = vi_aosuc AND
            PPMDA = vi_aomda AND
            PPPAP = vi_aopap AND
            PPCTA = vi_aocta AND
            PPOPER = vi_aooper AND
          --  PPSBOP = vi_aosbop AND 
            PPTOPE = vi_aotope;
            
            DBMS_OUTPUT.put_line('numCuotas: ' || TO_CHAR(numCuotas));
           END;
           
           BEGIN -- tabla de guia 
             select TP1NRO1, TP1NRO2
             INTO cuotMin, cuotMax
             from fst198 
             where 
             tp1cod = 1 and ---2024.09.05 dcastro se agrego tp1cod =1
             tp1cod1 = 10899 and tp1corr1 = 40000  and tp1corr3 = 200;
             exception
               when others then 
                 cuotMin := 2;
                 cuotMax := 4;
           END;                      
            DBMS_OUTPUT.put_line('CuotaMin: ' || TO_CHAR(cuotMin));
            DBMS_OUTPUT.put_line('CuotaMax: ' || TO_CHAR(cuotMax));           
           IF numCuotas >= cuotMin AND numCuotas <= cuotMax  THEN
                 vo_rpta := 'S';
           ELSE 
                vo_rpta:='N';                
           END IF;
      ELSE 
             DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
             vo_rpta := 'N';
      END IF;
   END;
--3
   PROCEDURE sp_cr_porcentaje_primera_cuota(ve_instancia in int, vo_rpta out varchar) IS

     CAP_CUOTA NUMBER(17,2);
     CAP_SEGURO NUMBER(17,2);
     SALDO_CUARENTA_POR NUMBER(17,2);
     SALDO_TOT NUMBER(17,2);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN

         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
                                                                    
         IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
         END IF;
                                                                    
          BEGIN
              SELECT (PPCAP + PPINT)
              INTO CAP_CUOTA
              FROM FSD601 a
              WHERE a.PPSBOP = 609 AND
                  a.PGCOD = vi_pgcod AND
                  a.PPMOD = vi_aomod AND
                  a.PPSUC = vi_aosuc AND
                  a.PPMDA = vi_aomda AND
                  a.PPPAP = vi_aopap AND
                  a.PPCTA = vi_aocta AND
                  a.PPOPER = vi_aooper AND
--                  PPSBOP = vi_aosbop AND
                  a.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY a.PPFPAG ASC;
              DBMS_OUTPUT.put_line('CAP_CUOTA: ' || TO_CHAR(CAP_CUOTA));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               DBMS_OUTPUT.put_line('no 2: ');

          END;
          BEGIN
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)
              INTO CAP_SEGURO
              FROM FSD611 b
              WHERE 
                  b.PPSBOP = 609 AND
                  b.PGCOD = vi_pgcod AND
                  b.PPMOD = vi_aomod AND
                  b.PPSUC = vi_aosuc AND
                  b.PPMDA = vi_aomda AND
                  b.PPPAP = vi_aopap AND
                  b.PPCTA = vi_aocta AND
                  b.PPOPER = vi_aooper AND
--                  PPSBOP = vi_aosbop AND
                  b.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY b.PPFPAG ASC;
              DBMS_OUTPUT.put_line('SEGURO: ' || TO_CHAR(CAP_SEGURO));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               DBMS_OUTPUT.put_line('no 2: ');

          END;
          BEGIN
               SELECT ABS(SCSDO * 0.4), ABS(SCSDO) -- sacamos el 40% al saldo capital
               INTO SALDO_CUARENTA_POR, SALDO_TOT
               FROM FSD011
               WHERE
                      PGCOD = vi_pgcod AND
                      SCSUC = vi_aosuc AND
                      SCMDA = vi_aomda AND
                      SCPAP = vi_aopap AND
                      SCCTA = vi_aocta AND
                      SCOPER = vi_aooper AND
--                      SCSBOP = vi_aosbop AND
                      SCTOPE = vi_aotope AND
                      SCMOD = vi_aomod;


           EXCEPTION
              when others then
               NULL;

          END;
          IF (CAP_CUOTA + CAP_SEGURO)> SALDO_CUARENTA_POR THEN
            BEGIN
              vo_rpta := 'S';
            END;
           ELSE 
              vo_rpta := 'N';
          END IF;
           DBMS_OUTPUT.put_line('CUOTA: ' || (CAP_CUOTA + CAP_SEGURO) || ' DEBERIA SER MAYOR AL SALDO 40 %: ' || TO_CHAR(SALDO_CUARENTA_POR) || ' DE:'||TO_CHAR(SALDO_TOT));
      END;
--4
    PROCEDURE sp_cr_ultima_cuota_al_capital(ve_instancia in int, vo_rpta out varchar) IS

     MONTO_CAP NUMBER(17,2);
     CAP_CUOTA NUMBER(17,2);
     CAP_SEGURO NUMBER(17,2);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN
          PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
                                                                    
         IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
         END IF;
     
         BEGIN
            SELECT DESCUENTOSOLICITADO
               into MONTO_CAP
            FROM LEY31050 L --LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT'
                AND L.TIPOFACILIDAD = 'CAJA'
--               AND lower(F.facilidad)  in ('exoneración de capitalización','condonación por cancelación', 'cancelaciones anticipadas', 'amortizacion anticipada') 
                         AND LOWER(F.facilidad)  = ('amortizacion anticipada')
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = vi_aocta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = vi_aooper
                AND F.EMPRESA  = vi_pgcod
                AND F.SUCURSAL = vi_aosuc
                AND F.MODULO =  vi_aomod
                AND F.MONEDA =  vi_aomda
                AND F.PAPEL  =  vi_aopap
                AND F.SUBOPERACION  = vi_aosbop
                AND F.TIPOOPERACION = vi_aotope;
                                                         
              DBMS_OUTPUT.put_line('MONTO_CAPITALIZACION: ' || TO_CHAR(MONTO_CAP));
           EXCEPTION
              when others then
               vo_rpta := 'N';
          END;
          BEGIN
              SELECT (PPCAP + PPINT)
              INTO CAP_CUOTA 
              FROM FSD601 
              WHERE PPSBOP = 609 AND
                  PGCOD = vi_pgcod AND
                  PPMOD = vi_aomod AND
                  PPSUC = vi_aosuc AND
                  PPMDA = vi_aomda AND
                  PPPAP = vi_aopap AND
                  PPCTA = vi_aocta AND
                  PPOPER = vi_aooper AND
--                  PPSBOP = vi_aosbop AND
                  PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY PPFPAG DESC;
                   
               DBMS_OUTPUT.put_line('CAP_ULTIMA_CUOTA: ' || TO_CHAR(CAP_CUOTA));
           EXCEPTION
              when others then
               NULL;

          END;
          BEGIN
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)
              INTO CAP_SEGURO
              FROM FSD611 b
              WHERE 
                  b.PPSBOP = 609 AND
                  b.PGCOD = vi_pgcod AND
                  b.PPMOD = vi_aomod AND
                  b.PPSUC = vi_aosuc AND
                  b.PPMDA = vi_aomda AND
                  b.PPPAP = vi_aopap AND
                  b.PPCTA = vi_aocta AND
                  b.PPOPER = vi_aooper AND
--                  PPSBOP = vi_aosbop AND
                  b.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY b.PPFPAG DESC;
              DBMS_OUTPUT.put_line('SEGURO: ' || TO_CHAR(CAP_SEGURO));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               DBMS_OUTPUT.put_line('no 2: ');

          END;
          
          IF (CAP_CUOTA  +  CAP_SEGURO)<= MONTO_CAP THEN
            BEGIN
              vo_rpta := 'S';
            END;
           ELSE 
              vo_rpta := 'N';
          END IF;
      END;

procedure sp_cr_fchvenc_primcuota(ve_instancia in int, vo_rpta out varchar) IS
     FECHA_SISTEMA DATE;   
     FECHA_PAGO DATE; 
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
   BEGIN
     vo_rpta := 'N';     
     PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
                                                                    
     IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
     END IF;               
     
     BEGIN
       SELECT PGFAPE 
       INTO FECHA_SISTEMA
        FROM FST017
        WHERE ROWNUM = 1;
     END;        
     BEGIN 
         SELECT PPFPAG
         INTO FECHA_PAGO
         FROM FSD601
              WHERE PPSBOP = 609 AND
                  PGCOD = vi_pgcod AND
                  PPMOD = vi_aomod AND
                  PPSUC = vi_aosuc AND
                  PPMDA = vi_aomda AND
                  PPPAP = vi_aopap AND
                  PPCTA = vi_aocta AND
                  PPOPER = vi_aooper AND
--                  PPSBOP = vi_aosbop AND
                  PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY PPFPAG ASC;
     END;
     IF (FECHA_PAGO - FECHA_SISTEMA) = 1 THEN
               vo_rpta := 'S';       
     END IF;
      DBMS_OUTPUT.put_line('FECHA PRIMERA CUOTA: ' || TO_CHAR((FECHA_PAGO) || ' Y EL SISTEMA ' || TO_CHAR(FECHA_SISTEMA) || 'ES:' || TO_CHAR(FECHA_PAGO - FECHA_SISTEMA) ));            
   END;
   
   
   PROCEDURE sp_cr_cuotas_pndtes_antes(ve_instancia in int, vo_rpta out varchar) IS
      cod xwf700.xwfempresa%type;
      modu xwf700.xwfmodulo%type;
      suc xwf700.xwfsucursal%type;
      mda xwf700.xwfmoneda%type;
      pap xwf700.xwfpapel%type;
      cta xwf700.xwfcuenta%type;
      oper xwf700.xwfoperacion%type;
      sbop xwf700.xwfsubope%type;
      tope xwf700.xwftipope%type; 
      rpta char(1);
      num_cuot_pen int :=0;
      
     BEGIN
       PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito(ve_instancia ,
                                                           vo_pgcod     => cod,
                                                           vo_aomod     => modu,
                                                           vo_aosuc     => suc,
                                                           vo_aomda     => mda,
                                                           vo_aopap     => pap,
                                                           vo_aocta     => cta,
                                                           vo_aooper    => oper,
                                                           vo_aosbop    => sbop,
                                                           vo_aotope    => tope,
                                                           vo_rpta      => rpta);
       IF rpta = 'S' THEN
         BEGIN
              SELECT count(*)
              INTO num_cuot_pen
              FROM FSD601 A 
              LEFT JOIN FSD602 B
              ON  (A.PPSBOP = B.PPSBOP AND 
                  A.PGCOD = B.PGCOD AND
                  A.PPMOD = B.PPMOD AND
                  A.PPSUC = B.PPSUC AND
                  A.PPMDA = B.PPMDA AND
                  A.PPPAP = B.PPPAP AND
                  A.PPCTA = B.PPCTA AND
                  A.PPOPER = B.PPOPER AND
                  A.PPTOPE = B.PPTOPE AND
                  A.PPFPAG = B.PPFPAG AND
                  A.PPTIPO = B.PPTIPO)
              WHERE A.PPSBOP <> 609 AND
                  A.PGCOD = cod AND
                  A.PPMOD = modu AND
                  A.PPSUC = suc AND
                  A.PPMDA = mda AND
                  A.PPPAP = pap AND
                  A.PPCTA = cta AND
                  A.PPOPER = oper AND
                  A.PPTOPE = tope AND
                  (A.PPCAP - NVL(B.PP1CAP,0))>0;
                  
                  DBMS_OUTPUT.put_line('SDI HAY CREDITO');
                  DBMS_OUTPUT.put_line('CUOTAS PENDIENTES: ' || TO_CHAR(num_cuot_pen));                                         
          
                  IF num_cuot_pen <= 3 THEN 
                           vo_rpta := 'S'; 
                  ELSE
                           vo_rpta := 'N';             
                  END IF; 
          END;           
       ELSE 
        DBMS_OUTPUT.put_line('NO HAY CREDITO');
        DBMS_OUTPUT.put_line('CUOTAS PENDIENTES: ' || TO_CHAR(num_cuot_pen));       
        vo_rpta := 'N';
       END IF;              
     END;

   PROCEDURE sp_cr_nuevacuota_menororiginal(ve_instancia in int, vo_rpta out varchar) IS
      cod xwf700.xwfempresa%type;
      modu xwf700.xwfmodulo%type;
      suc xwf700.xwfsucursal%type;
      mda xwf700.xwfmoneda%type;
      pap xwf700.xwfpapel%type;
      cta xwf700.xwfcuenta%type;
      oper xwf700.xwfoperacion%type;
      sbop xwf700.xwfsubope%type;
      tope xwf700.xwftipope%type; 
      rpta char(1);
      pactado_vigente NUMBER(17,2);
      pactado_propuesto NUMBER(17,2);
      
     BEGIN
       PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito(ve_instancia ,
                                                           vo_pgcod     => cod,
                                                           vo_aomod     => modu,
                                                           vo_aosuc     => suc,
                                                           vo_aomda     => mda,
                                                           vo_aopap     => pap,
                                                           vo_aocta     => cta,
                                                           vo_aooper    => oper,
                                                           vo_aosbop    => sbop,
                                                           vo_aotope    => tope,
                                                           vo_rpta      => rpta);
                                                           
     IF rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
     END IF; 


     
     PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_crevigente_flujocaja(cod ,modu ,suc ,mda ,pap ,cta ,oper ,sbop ,tope , vo_pactadovigente => pactado_vigente,  vo_rpta => rpta);
     
     IF rpta = 'N' THEN 
         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_crepropuesto_flujocaja(cod ,modu ,suc ,mda ,pap ,cta ,oper ,sbop ,tope , vo_pactadopropuesto => pactado_propuesto,  vo_rpta => rpta);
         DBMS_OUTPUT.put_line('-------------------------------------');
         DBMS_OUTPUT.put_line('pACTADO VIGENTE - PROPUESTO: '|| pactado_vigente ||'-' ||pactado_propuesto);
             IF (rpta = 'N' and pactado_vigente > pactado_propuesto) THEN 
                         vo_rpta := 'S';   -- LA NUEVA CUOTA SI ES MENOR A LA ORIGINAL   
                         DBMS_OUTPUT.put_line('cuota menor: ' || vo_rpta);       
             ELSE IF rpta = 'S' THEN
                     vo_rpta := 'S';   -- LA NUEVA CUOTA NO ES MENOR A LA ORIGINAL            
                   ELSE 
                               vo_rpta := 'N';   -- LA NUEVA CUOTA NO ES MENOR A LA ORIGINAL          
                               DBMS_OUTPUT.put_line('cuota menorrrrrrrrrrrrr: ' || vo_rpta);       
                   END IF;
             END IF;
     ELSE
             vo_rpta := 'S';
     END IF;                                        
END sp_cr_nuevacuota_menororiginal;

    PROCEDURE sp_cr_saldo_capital (pn_pgcod in number, pn_lcmod in number, pn_lcsuc in number, 
               pn_lcmda in number, pn_lcpap in number, pn_lccta in number, pn_lcoper in number,
               pn_lcsbop in number, pn_lctope in number, pn_sdocapital out number) 
        -- *****************************************************************
        -- Nombre                     : sp_cr_saldo_capital
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Créditos - Activas
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2021.12.27
        -- Autor de Creación          : Alonso Pacheco Huachaca
        -- Uso                        : Devuelve el saldo capital del credito segun su clave
        -- Estado                     : Activo
        -- Acceso                     : Publico
        -- Parámetros de Entrada      : pn_pgcod ( Codigo Empresa )
        --                              pn_lcmod ( Modulo )
        --                              pn_lcsuc ( Sucursal )
        --                              pn_lcmda ( Moneda )
        --                              pn_lcpap ( Papel )
        --                              pn_lccta ( Cuenta )
        --                              pn_lcoper ( Operacion )
        --                              pn_lcsbop ( Sub Operacion )
        --                              pn_lctope ( Tipo Operacion )
        -- Parámetros de Salida       : pn_sdocapital ( Saldo Capital Credito )
        -- Fecha de Modificación      : --
        -- Autor de la Modificación   : --
        -- Descripción de Modificación: --
        -- ******************************************************************
      IS     
      BEGIN 
        begin
           SELECT D.SCSDO*-1
           INTO pn_sdocapital
           FROM FSD011 D
           WHERE D.PGCOD = pn_pgcod
             AND D.SCSUC = pn_lcsuc
             AND D.SCMOD = pn_lcmod
             AND D.SCMDA = pn_lcmda
             AND D.SCPAP = pn_lcpap
             AND D.SCCTA = pn_lccta
             AND D.SCOPER= pn_lcoper
             AND D.SCSBOP= pn_lcsbop
             AND D.SCTOPE= pn_lctope
             AND ROWNUM = 1;
        exception when others then
            null;
        end;      
    END sp_cr_saldo_capital; 
      
    PROCEDURE sp_cr_deuda_viva_credito (pn_pgcod in number, pn_lcmod in number, pn_lcsuc in number, 
               pn_lcmda in number, pn_lcpap in number, pn_lccta in number, pn_lcoper in number,
               pn_lcsbop in number, pn_lctope in number, pn_deudaviva out number, pv_rpta out varchar2) 
        -- *****************************************************************
        -- Nombre                     : sp_cr_deuda_viva_credito
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Créditos - Activas
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2021.12.09
        -- Autor de Creación          : Alonso Pacheco Huachaca
        -- Uso                        : Devuelve la deuda vida del credito segun su clave
        -- Estado                     : Activo
        -- Acceso                     : Publico
        -- Parámetros de Entrada      : pn_pgcod ( Codigo Empresa )
        --                              pn_lcmod ( Modulo )
        --                              pn_lcsuc ( Sucursal )
        --                              pn_lcmda ( Moneda )
        --                              pn_lcpap ( Papel )
        --                              pn_lccta ( Cuenta )
        --                              pn_lcoper ( Operacion )
        --                              pn_lcsbop ( Sub Operacion )
        --                              pn_lctope ( Tipo Operacion )
        -- Parámetros de Salida       : pn_deudaviva ( Deuda Viva Credito )
        -- Fecha de Modificación      : --
        -- Autor de la Modificación   : --
        -- Descripción de Modificación: --
        -- ******************************************************************
      IS
           ln_monto   NUMBER(17,2);
           ln_seguro  NUMBER(17,2);
           ln_interes NUMBER(17,2);
           ln_monto_pag   NUMBER(17,2);
           ln_seguro_pag  NUMBER(17,2);  
           ln_interes_pag NUMBER(17,2); 
           ln_guia NUMBER(5);       
      BEGIN 
            ln_monto   := 0;  
            ln_interes := 0;    
            ln_seguro  := 0;
            ln_monto_pag   := 0;
            ln_interes_pag := 0;   
            ln_seguro_pag  := 0;
            begin    
              --guia validar interes + seguro
              select tp1nro1 into ln_guia from fst198 
                     where tp1cod = 1 and tp1cod1 = 10899 and tp1corr1 = 400000 and
                           tp1corr2 = 511 and tp1corr3 = 0; 
              begin                     
                select nvl(sum(ppcap),0)
                       into ln_monto from fsd601 
                     where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                       and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope;
              exception
                   when others then  
                       ln_monto := 0;
                end;  
                
              begin                     
                select nvl(sum(ppint),0)
                       into ln_interes from fsd601 
                     where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                       and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope;
              exception
                   when others then  
                       ln_interes := 0;
              end; 
              if ln_monto <> 0 then
                begin
                  select nvl(sum(ppimp10 + ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15 + ppimp16 + ppimp17 + ppimp18 + ppimp19 + ppimp20),0)
                         into ln_seguro from fsd611  
                       where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                         and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope;                       
                     exception
                   when others then  
                       ln_seguro := 0;
                end;                  
                --encontrar diferencia con la fsd602  
                begin    
                   select nvl(sum(pp1cap),0)
                         into ln_monto_pag from fsd602 
                       where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                         and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope
                         and (d602mo, d602tr) not in(                         
                            select tp1nro1, tp1nro2 from fst198 
                                   where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 4 and tp1corr3 > 0 
                         );--apachecoh 2022.07.04 guia de transacciones de incrementos y lineas
                     exception
                   when others then  
                       ln_monto_pag := 0;
                end; 
                
                begin    
                   select nvl(sum(pp1int),0)
                         into ln_interes_pag from fsd602 
                       where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                         and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope
                         and (d602mo, d602tr) not in(                         
                            select tp1nro1, tp1nro2 from fst198 
                                   where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 4 and tp1corr3 > 0 
                         );--apachecoh 2022.07.04 guia de transacciones de incrementos y lineas
                     exception
                   when others then  
                       ln_interes_pag := 0;
                end; 
                  
                begin
                   select nvl(sum(pp1imp10 + pp1imp11 + pp1imp12 + pp1imp13 + pp1imp14 + pp1imp15 + pp1imp16 + pp1imp17 + pp1imp18 + pp1imp19 + pp1imp20),0) 
                         into ln_seguro_pag from fsd612  
                       where pgcod = pn_pgcod and ppmod = pn_lcmod and ppsuc = pn_lcsuc and ppmda = pn_lcmda and pppap = pn_lcpap 
                         and ppcta = pn_lccta and ppoper = pn_lcoper and ppsbop = pn_lcsbop and pptope = pn_lctope;
                    exception
                   when others then  
                       ln_seguro_pag := 0;
                end;     
                  
                   pv_rpta := 'S';
                   if ln_guia = 1 then
                           pn_deudaviva := (ln_monto + ln_interes + ln_seguro) - (ln_monto_pag + ln_interes_pag + ln_seguro_pag);
                   else
                           pn_deudaviva := (ln_monto) - (ln_monto_pag);
                   end if;
              else                
                   pv_rpta := 'E';
                   pn_deudaviva := -1;
              end if;
            exception
               when others then  
                   pv_rpta := 'E';
                   pn_deudaviva := -1;
            end;       
    END sp_cr_deuda_viva_credito; 
    
    PROCEDURE sp_cr_instancia_vinculada (pn_instancia in number, pn_instancia2 out number) 
        -- *****************************************************************
        -- Nombre                     : sp_instancia_vinculada
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Créditos - Activas
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2021.12.09
        -- Autor de Creación          : Alonso Pacheco Huachaca
        -- Uso                        : Devuelve la instancia de la linea de credito vinculada
        -- Estado                     : Activo
        -- Acceso                     : Privado
        -- Parámetros de Entrada      : pn_instancia ( Instancia )
        -- Parámetros de Salida       : pn_instancia2 ( Instancia Linea Credito )
        -- Fecha de Modificación      : --
        -- Autor de la Modificación   : --
        -- Descripción de Modificación: --
        -- ******************************************************************
      IS
      BEGIN         
            begin 
               select a.jaqy800ins2 into pn_instancia2
                      from jaqy800 a  
               where a.jaqy800ins = pn_instancia and a.jaqy800tpc = 'P';
            exception
               when others then
                   pn_instancia2 := 0;
            end;       
    END sp_cr_instancia_vinculada; 
    
    PROCEDURE sp_cr_fch_primcuota_rpg_caja(ve_instancia in int, vo_rpta out varchar) IS
     FECHA_SISTEMA DATE;   
     FECHA_PAGO DATE; 
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
   BEGIN
     vo_rpta := 'N';     
     PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                          vo_pgcod     => vi_pgcod,
                                                          vo_aomod     => vi_aomod,
                                                          vo_aosuc     => vi_aosuc,
                                                          vo_aomda     => vi_aomda,
                                                          vo_aopap     => vi_aopap,
                                                          vo_aocta     => vi_aocta,
                                                          vo_aooper    => vi_aooper,
                                                          vo_aosbop    => vi_aosbop,
                                                          vo_aotope    => vi_aotope,
                                                          vo_rpta      => vi_rpta); 
                                                                    
     IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
     END IF;               
     
     BEGIN
       SELECT PGFAPE 
       INTO FECHA_SISTEMA
        FROM FST017
        WHERE ROWNUM = 1;
     END;        
     BEGIN 
         SELECT PPFPAG
         INTO FECHA_PAGO
         FROM FSD601 
              WHERE 
                  PGCOD = vi_pgcod AND
                  PPMOD = vi_aomod AND
                  PPSUC = vi_aosuc AND
                  PPMDA = vi_aomda AND
                  PPPAP = vi_aopap AND
                  PPCTA = vi_aocta AND
                  PPOPER = vi_aooper AND
                  PPSBOP = vi_aosbop AND
                  PPTOPE = vi_aotope AND
                  ROWNUM = 1
                  ORDER BY PPFPAG ASC;
     EXCEPTION WHEN OTHERS THEN
         FECHA_PAGO := FECHA_SISTEMA; 
     END;
     IF (FECHA_PAGO - FECHA_SISTEMA) = 1 THEN
               vo_rpta := 'S';       
     END IF;
      DBMS_OUTPUT.put_line('FECHA PRIMERA CUOTA: ' || TO_CHAR((FECHA_PAGO) || ' Y EL SISTEMA ' || TO_CHAR(FECHA_SISTEMA) || 'ES:' || TO_CHAR(FECHA_PAGO - FECHA_SISTEMA) ));            
   END;
   
    PROCEDURE sp_cr_primera_cuota_rpg_caja(ve_instancia in int, vo_rpta out varchar) IS
     CAP_CUOTA NUMBER(17,2);
     CAP_SEGURO NUMBER(17,2);
     SALDO_CUARENTA_POR NUMBER(17,2);
     SALDO_TOT NUMBER(17,2);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN
         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
                                                                    
         IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
            vo_rpta := 'N';
           return;           
         END IF;
                                                                    
          BEGIN
              SELECT (PPCAP + PPINT)
              INTO CAP_CUOTA
              FROM FSD601 a
              WHERE 
                  a.PGCOD = vi_pgcod AND
                  a.PPMOD = vi_aomod AND
                  a.PPSUC = vi_aosuc AND
                  a.PPMDA = vi_aomda AND
                  a.PPPAP = vi_aopap AND
                  a.PPCTA = vi_aocta AND
                  a.PPOPER = vi_aooper AND
                  a.PPSBOP = vi_aosbop AND
                  a.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY a.PPFPAG ASC;
              DBMS_OUTPUT.put_line('CAP_CUOTA: ' || TO_CHAR(CAP_CUOTA));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               DBMS_OUTPUT.put_line('no 2: ');

          END;
          BEGIN
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)
              INTO CAP_SEGURO
              FROM FSD611 b
              WHERE 
                  b.PGCOD = vi_pgcod AND
                  b.PPMOD = vi_aomod AND
                  b.PPSUC = vi_aosuc AND
                  b.PPMDA = vi_aomda AND
                  b.PPPAP = vi_aopap AND
                  b.PPCTA = vi_aocta AND
                  b.PPOPER = vi_aooper AND
                  b.PPSBOP = vi_aosbop AND
                  b.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY b.PPFPAG ASC;
              DBMS_OUTPUT.put_line('SEGURO: ' || TO_CHAR(CAP_SEGURO));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               DBMS_OUTPUT.put_line('no 2: ');
          END;
          BEGIN
             SELECT ABS(F.XLLCAPITAL * 0.4),ABS(F.XLLCAPITAL) -- sacamos el 40% al saldo capital
               INTO SALDO_CUARENTA_POR, SALDO_TOT
             FROM X054023 F
            WHERE F.XLLPGCOD = vi_pgcod
              AND F.XLLAOMOD = vi_aomod
              AND F.XLLAOSUC = vi_aosuc
              AND F.XLLAOMDA = vi_aomda
              AND F.XLLAOPAP = vi_aopap
              AND F.XLLAOCTA = vi_aocta
              AND F.XLLAOOPER = vi_aooper
              AND F.XLLAOSBOP = vi_aosbop
              AND F.XLLAOTOP = vi_aotope                 
              AND ROWNUM = 1;              
           EXCEPTION
              when others then
               NULL;
          END;
          IF (CAP_CUOTA + CAP_SEGURO)> SALDO_CUARENTA_POR THEN
            BEGIN
              vo_rpta := 'S';
            END;
           ELSE 
              vo_rpta := 'N';
          END IF;
           DBMS_OUTPUT.put_line('CUOTA: ' || (CAP_CUOTA + CAP_SEGURO) || ' DEBERIA SER MAYOR AL SALDO 40 %: ' || TO_CHAR(SALDO_CUARENTA_POR) || ' DE:'||TO_CHAR(SALDO_TOT));
    END;
      
    PROCEDURE sp_cr_ultima_cuota_rpg_caja(ve_instancia in int, vo_rpta out varchar) IS
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.10
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutores modificados para Reprograma Caja
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( Resultado S/N )
    -- ******************************************************************
         
     MONTO_CAP NUMBER(17,2);
     CAP_CUOTA NUMBER(17,2);
     CAP_SEGURO NUMBER(17,2);
     le_instancia2 NUMBER(10);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN
          PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_instancia_vinculada(ve_instancia, le_instancia2); 
          PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
                                                                    
         IF vi_rpta = 'N' THEN 
            DBMS_OUTPUT.put_line('No existe la INSTANCIA');
            vo_rpta := 'N';
           return;           
         END IF;
     
         BEGIN
            SELECT AQPB904MNTD --MONTO DE DESCUENTO
                   into MONTO_CAP 
            FROM AQPB904 
            WHERE AQPB904INS = le_instancia2
              AND AQPB904ESTA = 'G' 
              AND AQPB904EHAB = 'H' 
              AND AQPB904CFACI = 7 -- AMORTIZACION ANTICIPADA
              /*
              AND AQPB904COD = vi_pgcod
              AND AQPB904SUC = vi_aosuc
              AND AQPB904MOD = vi_aomod
              AND AQPB904MDA = vi_aomda   
              AND AQPB904PAP = vi_aopap
              AND AQPB904CTA = vi_aocta    
              AND AQPB904OPER = vi_aooper   
              AND AQPB904SBOP = vi_aosbop
              AND AQPB904TOPE = vi_aotope
              */
              ;                                                                          
              DBMS_OUTPUT.put_line('MONTO_CAPITALIZACION: ' || TO_CHAR(MONTO_CAP));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               MONTO_CAP := 0;
          END;
          BEGIN
              SELECT (PPCAP + PPINT)
              INTO CAP_CUOTA 
              FROM FSD601 
              WHERE 
                  PGCOD = vi_pgcod AND
                  PPMOD = vi_aomod AND
                  PPSUC = vi_aosuc AND
                  PPMDA = vi_aomda AND
                  PPPAP = vi_aopap AND
                  PPCTA = vi_aocta AND
                  PPOPER = vi_aooper AND
                  PPSBOP = vi_aosbop AND
                  PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY PPFPAG DESC;
                   
               DBMS_OUTPUT.put_line('CAP_ULTIMA_CUOTA: ' || TO_CHAR(CAP_CUOTA));
           EXCEPTION
              when others then               
               CAP_CUOTA := 0;
          END;
          BEGIN
              SELECT (PPIMP10 + PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 + PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 + PPIMP19 + PPIMP20)
              INTO CAP_SEGURO
              FROM FSD611 b
              WHERE
                  b.PGCOD = vi_pgcod AND
                  b.PPMOD = vi_aomod AND
                  b.PPSUC = vi_aosuc AND
                  b.PPMDA = vi_aomda AND
                  b.PPPAP = vi_aopap AND
                  b.PPCTA = vi_aocta AND
                  b.PPOPER = vi_aooper AND
                  b.PPSBOP = vi_aosbop AND
                  b.PPTOPE = vi_aotope AND
                   ROWNUM = 1
                   ORDER BY b.PPFPAG DESC;
              DBMS_OUTPUT.put_line('SEGURO: ' || TO_CHAR(CAP_SEGURO));
           EXCEPTION
              when others then
               vo_rpta := 'N';
               CAP_SEGURO := 0;
               DBMS_OUTPUT.put_line('no 2: ');

          END;
          
          IF (CAP_CUOTA + CAP_SEGURO)<= MONTO_CAP THEN
            BEGIN
              vo_rpta := 'S';
            END;
           ELSE 
              vo_rpta := 'N';
          END IF;
      END;
            
  PROCEDURE sp_cr_numero_cuotas_rpg_caja(ve_instancia in int, vo_rpta out varchar) IS
     numCuotas INT;
     cuotMin int;
     cuotMax int;
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;
     vi_rpta char(1);
     BEGIN
         PQ_CR_REPROG_CANCEL_ANTICIPADA.sp_cr_codigo_credito (ve_instancia => ve_instancia,
                                                                    vo_pgcod     => vi_pgcod,
                                                                    vo_aomod     => vi_aomod,
                                                                    vo_aosuc     => vi_aosuc,
                                                                    vo_aomda     => vi_aomda,
                                                                    vo_aopap     => vi_aopap,
                                                                    vo_aocta     => vi_aocta,
                                                                    vo_aooper    => vi_aooper,
                                                                    vo_aosbop    => vi_aosbop,
                                                                    vo_aotope    => vi_aotope,
                                                                    vo_rpta      => vi_rpta); 
      IF(vi_rpta = 'S') THEN                                                                     
          BEGIN
            SELECT COUNT(*) INTO numCuotas FROM FSD601
            WHERE
            PGCOD = vi_pgcod AND
            PPMOD = vi_aomod AND
            PPSUC = vi_aosuc AND
            PPMDA = vi_aomda AND
            PPPAP = vi_aopap AND
            PPCTA = vi_aocta AND
            PPOPER = vi_aooper AND
            PPSBOP = vi_aosbop AND 
            PPTOPE = vi_aotope;
            
            DBMS_OUTPUT.put_line('numCuotas: ' || TO_CHAR(numCuotas));
           END;
           
           BEGIN -- tabla de guia 
             select TP1NRO1, TP1NRO2
             INTO cuotMin, cuotMax
             from fst198 
             where 
             tp1cod = 1 and --2024.09.05 dcastro se agrego tp1cod = 1
             tp1cod1 = 10899 and tp1corr1 = 40000  and tp1corr3 = 200;
           exception
               when others then 
                 cuotMin := 2;
                 cuotMax := 4;
           END;                      
            DBMS_OUTPUT.put_line('CuotaMin: ' || TO_CHAR(cuotMin));
            DBMS_OUTPUT.put_line('CuotaMax: ' || TO_CHAR(cuotMax));           
           IF numCuotas >= cuotMin AND numCuotas <= cuotMax  THEN
                 vo_rpta := 'S';
           ELSE 
                vo_rpta:='N';                
           END IF;
      ELSE 
             DBMS_OUTPUT.put_line('No existe la INSTANCIA ');
             vo_rpta := 'N';
      END IF;
   END;
  
END PQ_CR_REPROG_CANCEL_ANTICIPADA;
/

