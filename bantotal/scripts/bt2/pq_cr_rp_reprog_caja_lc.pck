create or replace package PQ_CR_RP_REPROG_CAJA_LC is
 /* ************************************************************************************************************
    -- Nombre                     : PQ_CR_RP_REPROG_CAJA_LC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ACTIVAS
    -- Descripción                : Politicas para Reprogramados Caja Fase 3
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.15
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -- 
    -- Autor de la Modificación   : -- 
    -- Descripción de Modificación: --
 * *************************************************************************************************************/
  procedure sp_cr_plazo_matriz_lc(ve_instancia in int, vo_plazo out int);                 
                               
  procedure sp_cr_plazo_crd_caja_lc(ve_instancia in int, vo_plazo out int);  
  
  procedure sp_cr_gracia_caja_lc(ve_instancia in int, vo_gracia out int, vo_monto out number);
  
  procedure sp_cr_gradiente_caja_lc(ve_instancia in int, vo_gradiente out int);
  
  procedure sp_cr_plazo_residual_lc(ve_instancia in int, vo_plazo_re out int);
  
  procedure sp_crd_arbol_aprobacion_lc(instancia in number, vo_ind_error out varchar2, vo_tip_error out varchar2, vo_cargo out varchar2);
    
  
end PQ_CR_RP_REPROG_CAJA_LC;
/

create or replace package body PQ_CR_RP_REPROG_CAJA_LC is

  procedure sp_cr_plazo_matriz_lc(ve_instancia in int, vo_plazo out int) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_plazo_matriz_lc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.04.21
    -- Autor de Creación          : Henry Suarez Lazarte
    -- Uso                        : Resolutor Politica que devuelve el plazo maximo permitido
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_plazo ( Resultado int )
    -- Fecha de Modificación      : 2021.12.15
    -- Autor de la Modificación   : Alonso Pacheco Huachaca
    -- Descripción de Modificación: Cambio para ser aplicado a Reprograma Caja
    -- Fecha de Modificación      : 2025.03.11
    -- Autor de la Modificación   : eninah
    -- Descripción de Modificación: Modificacion procedimiento sp_cr_plazo_matriz_lc, se agregó J.JAQY800VINC = 'S';
    -- ******************************************************************                              
                               
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;
    
    vi_aqpb904acod xwf700.xwfempresa%type;
    vi_aqpb904amod xwf700.xwfmodulo%type;
    vi_aqpb904asuc xwf700.xwfsucursal%type;
    vi_aqpb904amda xwf700.xwfmoneda%type;
    vi_aqpb904apap xwf700.xwfpapel%type;
    vi_aqpb904acta xwf700.xwfcuenta%type;
    vi_aqpb904aoper xwf700.xwfoperacion%type;
    vi_aqpb904asbop xwf700.xwfsubope%type;
    vi_aqpb904atope xwf700.xwftipope%type;
      
    vi_fecpagmax date;
    vi_fecactual date;
    vi_plzo_res number(4);
    vi_scsdo number(17,2);
    FEC_PAGO DATE;
    FLAG_PAGOS varchar2(1);
    vi_fecpagmin date;
    begin
            --BUSCAR LA LINEA DE CREDITO PRINCIPAL VINCULADA 
            BEGIN
              SELECT J.JAQY800PGCD,J.JAQY800MOD,J.JAQY800SUC,J.JAQY800MDA,
                     J.JAQY800PAP,J.JAQY800CTA,J.JAQY800OPE,J.JAQY800SBOP,J.JAQY800TOPE
               INTO vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                    vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                    vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
               FROM JAQY800 J 
               WHERE J.JAQY800INS=ve_instancia
                 AND J.JAQY800TPC = 'P'
                 AND J.JAQY800VINC = 'S'; -- eninah 11/03/2025
            EXCEPTION
              WHEN OTHERS THEN
                NULL;  
              END;            
            pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(
                                                                 vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                 vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                 vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                 vi_pgcod , vi_aomod, vi_aosuc, vi_aomda ,
                                                                 vi_aopap , vi_aocta, vi_aooper,vi_aosbop, vi_aotope
                                                                      
                   );  
              /*
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
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
                  
            exception
              when others then
                null;                                  
              END;
              */
            begin               
              SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmax     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            --Cuantas cuotas faltan pagar
            FLAG_PAGOS:='S';
            BEGIN 
              SELECT MAX(D.PPFPAG),'N'
              INTO FEC_PAGO, FLAG_PAGOS 
              FROM FSD601 D,FSD602 D2
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope
                    AND D2.PGCOD  = D.PGCOD
                    AND D2.PPMOD  = D.PPMOD
                    AND D2.PPSUC  = D.PPSUC
                    AND D2.PPMDA  = D.PPMDA
                    AND D2.PPPAP  = D.PPPAP
                    AND D2.PPCTA  = D.PPCTA
                    AND D2.PPOPER = D.PPOPER
                    AND D2.PPSBOP = D.PPSBOP
                    AND D2.PPTOPE = D.PPTOPE
                    and d2.pp1stat='T'
                    AND D2.PPFPAG = D.PPFPAG;
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                FLAG_PAGOS:='S';
            END;
            --OBTENER LA FECHA MINIMA DE PAGO
            IF FLAG_PAGOS = 'N' AND FEC_PAGO IS NOT NULL THEN
              begin               
                SELECT MIN(D.PPFPAG)
                  INTO vi_fecpagmin    
                     FROM FSD601 D
                    WHERE D.PGCOD = vi_pgcod
                      AND D.PPMOD = vi_aomod
                      AND D.PPSUC = vi_aosuc
                      AND D.PPMDA = vi_aomda
                      AND D.PPPAP = vi_aopap
                      AND D.PPCTA = vi_aocta
                      AND D.PPOPER = vi_aooper
                      AND D.PPSBOP = vi_aosbop
                      AND D.PPTOPE = vi_aotope
                      AND D.PPFPAG >= FEC_PAGO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;      
              end;
              vi_fecactual:= vi_fecpagmin;
            ELSE
              BEGIN
                  SELECT MIN(D.PPFPAG)
                      INTO vi_fecactual    
                         FROM FSD601 D
                        WHERE D.PGCOD = vi_pgcod
                          AND D.PPMOD = vi_aomod
                          AND D.PPSUC = vi_aosuc
                          AND D.PPMDA = vi_aomda
                          AND D.PPPAP = vi_aopap
                          AND D.PPCTA = vi_aocta
                          AND D.PPOPER = vi_aooper
                          AND D.PPSBOP = vi_aosbop
                          AND D.PPTOPE = vi_aotope;  
              /*SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;*/
              END;
            END IF;  
            --OBTENGO EL PLAZO RESIDUAL                        
            BEGIN
              SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual) 
                INTO vi_plzo_res
              FROM DUAL;
              END;
            begin
               SELECT F.XLLCAPITAL
                 INTO vi_scsdo
                 FROM X054023 F
                WHERE F.XLLPGCOD = vi_pgcod
                  AND F.XLLAOMOD = vi_aomod
                  AND F.XLLAOSUC = vi_aosuc
                  AND F.XLLAOMDA = vi_aomda
                  AND F.XLLAOPAP = vi_aopap
                  AND F.XLLAOCTA = vi_aocta
                  AND F.XLLAOOPER = vi_aooper
                  AND F.XLLAOSBOP = vi_aosbop
                  AND F.XLLAOTOP = vi_aotope;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;          
            end;   
            BEGIN
              select a.aqpb260cpla
                INTO vo_plazo
                from AQPB260C a
              where vi_scsdo > a.aqpb260csdi
                 and vi_scsdo <= a.aqpb260csdf
                 and vi_plzo_res >= a.aqpb260ccui
                 and vi_plzo_res <= a.aqpb260ccuf
                 and a.aqpb260cest = 'S';
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;     
            END;
      end;
      
   procedure sp_cr_plazo_crd_caja_lc(ve_instancia in int, vo_plazo out int) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_plazo_crd_caja_lc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.04.21
    -- Autor de Creación          : Henry Suarez Lazarte
    -- Uso                        : Resolutor Politica que devuelve el plazo credito en vuelo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_plazo ( Resultado int )
    -- Fecha de Modificación      : 2021.12.15
    -- Autor de la Modificación   : Alonso Pacheco Huachaca
    -- Descripción de Modificación: Cambio para ser aplicado a Reprograma Caja
    -- ******************************************************************
    vi_pgcod xwf700.xwfempresa%type;
    vi_aomod xwf700.xwfmodulo%type;
    vi_aosuc xwf700.xwfsucursal%type;
    vi_aomda xwf700.xwfmoneda%type;
    vi_aopap xwf700.xwfpapel%type;
    vi_aocta xwf700.xwfcuenta%type;
    vi_aooper xwf700.xwfoperacion%type;
    vi_aosbop xwf700.xwfsubope%type;
    vi_aotope xwf700.xwftipope%type;                                 
    vi_fecpagmax date;
    vi_fecvalmin date;
    vi_fecactual date;
    begin
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
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
         exception
              when others then
                null;                                  
         END;
         
         vo_plazo:=0;
         /*begin           
           select x.xllplazo
           into   vo_plazo
           from x054023 x 
           where x.xllpgcod = vi_pgcod  
             and x.xllaomod = vi_aomod 
             and x.xllaosuc = vi_aosuc 
             and x.xllaomda = vi_aomda 
             and x.xllaopap = vi_aopap 
             and x.xllaocta = vi_aocta 
             and x.xllaooper= vi_aooper 
             and x.xllaosbop= vi_aosbop
             and x.xllaotop = vi_aotope;             
         Exception 
           when others then
             vo_plazo:=0;
           end;
         vo_plazo := round(vo_plazo/30); */ 
         IF vo_plazo = 0 THEN
           begin               
              SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmax     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            
            begin               
              SELECT MIN(D.PPFPAG)              
                INTO vi_fecvalmin     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop 
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
            END;
            BEGIN
             SELECT  (vi_fecpagmax-vi_fecvalmin)/30
               INTO  vo_plazo
               FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;
              END;
         END IF;
     end;
     
  procedure sp_cr_gracia_caja_lc(ve_instancia in int, vo_gracia out int, vo_monto out number) is
       -- *****************************************************************
       -- Nombre                     : sp_cr_gracia_caja_lc
       -- Sistema                    : BANTOTAL
       -- Módulo                     : Créditos - Activas
       -- Versión                    : 1.0
       -- Fecha de Creación          : 2021.04.21
       -- Autor de Creación          : Henry Suarez Lazarte
       -- Uso                        : Resolutor Politica que devuelve la gracia de la solicitud en vuelo
       -- Estado                     : Activo
       -- Acceso                     : Público
       -- Parámetros de Entrada      : ve_instancia ( Instancia )
       -- Parámetros de Salida       : vo_gracia ( Resultado int )
       --                            : vo_monto ( Monto credito )
       -- Fecha de Modificación      : 2021.12.15
       -- Autor de la Modificación   : Alonso Pacheco Huachaca
       -- Descripción de Modificación: Cambio para ser aplicado a Reprograma Caja
       -- ******************************************************************                                                                                              
       vi_pgcod xwf700.xwfempresa%type;
       vi_aomod xwf700.xwfmodulo%type;
       vi_aosuc xwf700.xwfsucursal%type;
       vi_aomda xwf700.xwfmoneda%type;
       vi_aopap xwf700.xwfpapel%type;
       vi_aocta xwf700.xwfcuenta%type;
       vi_aooper xwf700.xwfoperacion%type;
       vi_aosbop xwf700.xwfsubope%type;
       vi_aotope xwf700.xwftipope%type;
       vi_fprpago date;
       vi_fecactual DATE;
       begin
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
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
         exception
              when others then
                null;                                  
         END;
         BEGIN
               select x.XLLFPRIMPA,x.xllcapital
               into   vi_fprpago,vo_monto
               from x054023 x 
               where x.xllpgcod = vi_pgcod  
                 and x.xllaomod = vi_aomod 
                 and x.xllaosuc = vi_aosuc 
                 and x.xllaomda = vi_aomda 
                 and x.xllaopap = vi_aopap 
                 and x.xllaocta = vi_aocta 
                 and x.xllaooper= vi_aooper 
                 and x.xllaosbop= vi_aosbop
                 and x.xllaotop = vi_aotope;             
         Exception 
           when others then
             null;--vo_fprpago:=0;
         END;
         BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
              END;
         begin
           SELECT vi_fprpago - vi_fecactual  into  vo_gracia  FROM DUAL;
           end;
       end;                          
      
  procedure sp_cr_gradiente_caja_lc(ve_instancia in int, vo_gradiente out int) is
       -- *****************************************************************
       -- Nombre                     : sp_cr_gradiente_caja_lc
       -- Sistema                    : BANTOTAL
       -- Módulo                     : Créditos - Activas
       -- Versión                    : 1.0
       -- Fecha de Creación          : 2021.04.21
       -- Autor de Creación          : Henry Suarez Lazarte
       -- Uso                        : Resolutor Politica que devuelve la gradiente de la solicitud en vuelo
       -- Estado                     : Activo
       -- Acceso                     : Público
       -- Parámetros de Entrada      : ve_instancia ( Instancia )
       -- Parámetros de Salida       : vo_gradiente ( Resultado int )
       -- Fecha de Modificación      : 2021.12.15
       -- Autor de la Modificación   : Alonso Pacheco Huachaca
       -- Descripción de Modificación: Cambio para ser aplicado a Reprograma Caja
       -- ******************************************************************   
       vi_PERIODO INT;
       vi_cantcuo INT;
       vi_fecpag3 date;
       
       vi_pgcod xwf700.xwfempresa%type;
       vi_aomod xwf700.xwfmodulo%type;
       vi_aosuc xwf700.xwfsucursal%type;
       vi_aomda xwf700.xwfmoneda%type;
       vi_aopap xwf700.xwfpapel%type;
       vi_aocta xwf700.xwfcuenta%type;
       vi_aooper xwf700.xwfoperacion%type;
       vi_aosbop xwf700.xwfsubope%type;
       vi_aotope xwf700.xwftipope%type;
       
       CUOTA3 NUMBER(17,2);
       CUOTAREST NUMBER(17,2);
       
       BEGIN
         ---VALIDAR FRECUENCIA SEA MENSUAL O MENOR
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
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
         exception
              when others then
                null;                                  
         END;
         begin
           SELECT X.XLLPERIODO
             into vi_PERIODO
               from x054023 x 
               where x.xllpgcod = vi_pgcod  
                 and x.xllaomod = vi_aomod 
                 and x.xllaosuc = vi_aosuc 
                 and x.xllaomda = vi_aomda 
                 and x.xllaopap = vi_aopap 
                 and x.xllaocta = vi_aocta 
                 and x.xllaooper= vi_aooper 
                 and x.xllaosbop= vi_aosbop
                 and x.xllaotop = vi_aotope;
         exception 
           when others then
             vi_periodo := 0;        
         end;
         IF vi_periodo <= 30 THEN
             BEGIN
                  SELECT COUNT(*)
                    INTO vi_cantcuo
                  FROM FSD601 F
                  WHERE F.PGCOD =vi_pgcod 
                    AND F.PPMOD =vi_aomod 
                    AND F.PPSUC =vi_aosuc 
                    AND F.PPMDA =vi_aomda 
                    AND F.PPPAP =vi_aopap 
                    AND F.PPCTA =vi_aocta 
                    AND F.PPOPER=vi_aooper
                    AND F.PPSBOP=vi_aosbop
                    AND F.PPTOPE=vi_aotope;
             EXCEPTION 
               WHEN OTHERS THEN
                 NULL;
             END; 
             --VALIDAR SI ES MAYOR O IGUAL A 5 CUOTAS CONTINUAR EL FLUJO CASO CONTRARIO DEVOLVER 0
             IF vi_cantcuo >= 5 then
                --Obtener la fecha de pago
                BEGIN
                  SELECT PPFPAG
                    INTO vi_fecpag3
                    FROM (
                            SELECT *   
                            FROM FSD601 F
                            WHERE F.PGCOD =vi_pgcod 
                              AND F.PPMOD =vi_aomod 
                              AND F.PPSUC =vi_aosuc 
                              AND F.PPMDA =vi_aomda 
                              AND F.PPPAP =vi_aopap 
                              AND F.PPCTA =vi_aocta 
                              AND F.PPOPER=vi_aooper
                              AND F.PPSBOP=vi_aosbop
                              AND F.PPTOPE= vi_aotope
                              and ROWNUM <= 3
                              ORDER BY PPFPAG ASC
                        )
                     WHERE ROWNUM = 1 ORDER BY PPFPAG DESC;
                EXCEPTION 
                   WHEN OTHERS THEN
                     NULL;
                END;
                --Obtener el promedio de las 3 primeras cuotas
                
                BEGIN
                  SELECT avg(F.PPCAP+F.PPINT)
                    INTO CUOTA3
                    FROM FSD601 F                    
                    WHERE F.PGCOD =vi_pgcod 
                      AND F.PPMOD =vi_aomod 
                      AND F.PPSUC =vi_aosuc 
                      AND F.PPMDA =vi_aomda 
                      AND F.PPPAP =vi_aopap 
                      AND F.PPCTA =vi_aocta 
                      AND F.PPOPER=vi_aooper
                      AND F.PPSBOP=vi_aosbop
                      AND F.PPTOPE= vi_aotope
                      AND F.PPFPAG <= vi_fecpag3;
                  END;
                
                --Obtener el promedio ed las siguietnes cuotas 
                BEGIN
                  SELECT avg(F.PPCAP+F.PPINT)
                    INTO CUOTAREST
                    FROM FSD601 F                    
                    WHERE F.PGCOD = vi_pgcod 
                      AND F.PPMOD = vi_aomod 
                      AND F.PPSUC = vi_aosuc 
                      AND F.PPMDA = vi_aomda 
                      AND F.PPPAP = vi_aopap 
                      AND F.PPCTA = vi_aocta 
                      AND F.PPOPER= vi_aooper
                      AND F.PPSBOP= vi_aosbop
                      AND F.PPTOPE= vi_aotope
                      AND F.PPFPAG > vi_fecpag3;
                  END;
                  BEGIN
                    SELECT (1-(CUOTA3/CUOTAREST))*100 INTO vo_gradiente FROM DUAL;
                    END;                 
             END IF;
         END IF;    
       END;
       
  procedure sp_cr_plazo_residual_lc(ve_instancia in int, vo_plazo_re out int) is
      -- *****************************************************************
      -- Nombre                     : sp_cr_plazo_residual_lc
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Créditos - Activas
      -- Versión                    : 1.0
      -- Fecha de Creación          : 2021.04.21
      -- Autor de Creación          : Henry Suarez Lazarte
      -- Uso                        : Resolutor Politica que devuelve la gradiente de la solicitud en vuelo
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Parámetros de Entrada      : ve_instancia ( Instancia )
      -- Parámetros de Salida       : vo_gradiente ( Resultado int )
      -- Fecha de Modificación      : 2021.12.vo_plazo_re
      -- Autor de la Modificación   : Alonso Pacheco Huachaca
      -- Descripción de Modificación: Cambio para ser aplicado a Reprograma Caja
      -- ******************************************************************   
      vi_pgcod xwf700.xwfempresa%type;
      vi_aomod xwf700.xwfmodulo%type;
      vi_aosuc xwf700.xwfsucursal%type;
      vi_aomda xwf700.xwfmoneda%type;
      vi_aopap xwf700.xwfpapel%type;
      vi_aocta xwf700.xwfcuenta%type;
      vi_aooper xwf700.xwfoperacion%type;
      vi_aosbop xwf700.xwfsubope%type;
      vi_aotope xwf700.xwftipope%type;
      
      vi_aqpb904acod xwf700.xwfempresa%type;
      vi_aqpb904amod xwf700.xwfmodulo%type;
      vi_aqpb904asuc xwf700.xwfsucursal%type;
      vi_aqpb904amda xwf700.xwfmoneda%type;
      vi_aqpb904apap xwf700.xwfpapel%type;
      vi_aqpb904acta xwf700.xwfcuenta%type;
      vi_aqpb904aoper xwf700.xwfoperacion%type;
      vi_aqpb904asbop xwf700.xwfsubope%type;
      vi_aqpb904atope xwf700.xwftipope%type;

     vi_fecpagmax date;
     vi_fecactual date;
     vi_plzo_res number(4);
     vi_scsdo number(17,2);
     FEC_PAGO DATE;
     FLAG_PAGOS varchar2(1);
     vi_fecpagmin date;
    begin   
            --BUSCAR LA LINEA DE CREDITO PRINCIPAL VINCULADA 
            BEGIN
              SELECT J.JAQY800PGCD,J.JAQY800MOD,J.JAQY800SUC,J.JAQY800MDA,
                     J.JAQY800PAP,J.JAQY800CTA,J.JAQY800OPE,J.JAQY800SBOP,J.JAQY800TOPE
               INTO vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                    vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                    vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope
               FROM JAQY800 J 
               WHERE J.JAQY800INS=ve_instancia
                 AND J.JAQY800TPC = 'P';
            EXCEPTION
              WHEN OTHERS THEN
                NULL;  
              END;
            
            pq_cr_lineas_rcaja_hs.OBTENER_CLAVE_LINEA_UTILIZADA(
                                                                 vi_aqpb904acod,vi_aqpb904amod,vi_aqpb904asuc,
                                                                 vi_aqpb904amda,vi_aqpb904apap,vi_aqpb904acta,
                                                                 vi_aqpb904aoper,vi_aqpb904asbop,vi_aqpb904atope,
                                                                 vi_pgcod , vi_aomod, vi_aosuc, vi_aomda ,
                                                                 vi_aopap , vi_aocta, vi_aooper,vi_aosbop, vi_aotope
                                                                      
                   );  
              /*
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
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700
                where xwfprcins= ve_instancia
                  and xwfcar3 = '1';
                  
            exception
              when others then
                null;                                  
              END;
              */
            begin               
              SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmax     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            --Cuantas cuotas faltan pagar
            FLAG_PAGOS:='S';
            BEGIN 
              SELECT MAX(D.PPFPAG),'N'
              INTO FEC_PAGO, FLAG_PAGOS 
              FROM FSD601 D,FSD602 D2
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop
                    AND D.PPTOPE = vi_aotope
                    AND D2.PGCOD  = D.PGCOD
                    AND D2.PPMOD  = D.PPMOD
                    AND D2.PPSUC  = D.PPSUC
                    AND D2.PPMDA  = D.PPMDA
                    AND D2.PPPAP  = D.PPPAP
                    AND D2.PPCTA  = D.PPCTA
                    AND D2.PPOPER = D.PPOPER
                    AND D2.PPSBOP = D.PPSBOP
                    AND D2.PPTOPE = D.PPTOPE
                    and d2.pp1stat='T'
                    AND D2.PPFPAG = D.PPFPAG;
            EXCEPTION 
              WHEN NO_DATA_FOUND THEN
                FLAG_PAGOS:='S';
            END;
            --OBTENER LA FECHA MINIMA DE PAGO
            IF FLAG_PAGOS = 'N' AND FEC_PAGO IS NOT NULL THEN
              begin               
                SELECT MIN(D.PPFPAG)
                  INTO vi_fecpagmin    
                     FROM FSD601 D
                    WHERE D.PGCOD = vi_pgcod
                      AND D.PPMOD = vi_aomod
                      AND D.PPSUC = vi_aosuc
                      AND D.PPMDA = vi_aomda
                      AND D.PPPAP = vi_aopap
                      AND D.PPCTA = vi_aocta
                      AND D.PPOPER = vi_aooper
                      AND D.PPSBOP = vi_aosbop
                      AND D.PPTOPE = vi_aotope
                      AND D.PPFPAG >= FEC_PAGO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;      
              end;
              vi_fecactual:= vi_fecpagmin;
            ELSE
              BEGIN
                  SELECT MIN(D.PPFPAG)
                      INTO vi_fecactual    
                         FROM FSD601 D
                        WHERE D.PGCOD = vi_pgcod
                          AND D.PPMOD = vi_aomod
                          AND D.PPSUC = vi_aosuc
                          AND D.PPMDA = vi_aomda
                          AND D.PPPAP = vi_aopap
                          AND D.PPCTA = vi_aocta
                          AND D.PPOPER = vi_aooper
                          AND D.PPSBOP = vi_aosbop
                          AND D.PPTOPE = vi_aotope;  
              /*SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;*/
              END;
            END IF;  
            --OBTENGO EL PLAZO RESIDUAL                        
            BEGIN
              SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual) 
                INTO vi_plzo_res
              FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                vi_plzo_res:= 0;  
            END;
            vo_plazo_re:=  vi_plzo_res;
      end;
      
 PROCEDURE sp_crd_arbol_aprobacion_lc(instancia in number,vo_ind_error out varchar2,vo_tip_error out varchar2, vo_cargo out varchar2)is 
    vo_plazoh number(4);
    vo_plazoc number(4);
    vo_gracia number(4);
    vo_plazor number(4);
    vo_monto  number(17,2);
    vo_tasa number(17,6);
    
    vo_gradiente number(3);
    vi_SaldoCap number(17,2);
    vi_cargo_mont number(4);
    vi_cargo_pzo_r number(4);
    vi_cargo_grac number(4);
    vi_cargo_grad number(4);
    vi_cargo_tasa number(4);
    vi_cargo_plaz number(4);
    vi_cuenta number(9);
    vi_flag_l31050 number(3);
    vi_operacion number(9);
    vi_situacion varchar(50);
    vi_codigo_monto number(4);
    
    vi_emp fsd010.pgcod%type;
    vi_mod fsd010.aomod%type;
    vi_suc fsd010.aosuc%type;
    vi_mda fsd010.aomda%type;
    vi_pap fsd010.aopap%type;
    vi_cta fsd010.aocta%type;
    vi_ope fsd010.aooper%type;
    vi_sbo fsd010.aosbop%type;
    vi_top fsd010.aotope%type;
  BEGIN
      vo_ind_error := 'S';
      vo_tip_error := '';

      /*
      vo_ind_error := 'S';
      vo_tip_error := ''; 
      RETURN;
      */
      --MONTO
      BEGIN
          select     x.xwfempresa,
                     x.xwfmodulo,
                     x.xwfsucursal,
                     x.xwfmoneda,
                     x.xwfpapel,
                     x.xwfcuenta,
                     x.xwfoperacion,
                     x.xwfsubope,
                     x.xwftipope
                into vi_emp,
                     vi_mod,
                     vi_suc,
                     vi_mda,
                     vi_pap,
                     vi_cta,
                     vi_ope,
                     vi_sbo,
                     vi_top        
                from xwf700 x
               where x.xwfprcins = instancia
                 and x.xwfcar3 = '1';
      EXCEPTION 
        WHEN OTHERS THEN
            vo_ind_error := 'N';
            vo_tip_error := 'CREDITO';
      END;
      BEGIN
        SELECT F.XLLCAPITAL
             INTO vi_SaldoCap
             FROM X054023 F
            WHERE F.XLLPGCOD = vi_emp
              AND F.XLLAOMOD = vi_mod
              AND F.XLLAOSUC = vi_suc
              AND F.XLLAOMDA = vi_mda
              AND F.XLLAOPAP = vi_pap
              AND F.XLLAOCTA = vi_cta
              AND F.XLLAOOPER = vi_ope
              AND F.XLLAOSBOP = vi_sbo
              AND F.XLLAOTOP = vi_top                 
              AND ROWNUM = 1;
      EXCEPTION 
        WHEN OTHERS THEN
             vo_ind_error := 'N';
             vo_tip_error := 'SALDO';
        END;
        
      BEGIN
        SELECT F.TP1NRO1,F.TP1CORR3
          INTO vi_cargo_mont,vi_codigo_monto
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 506
           AND TP1IMP1 <= vi_SaldoCap
           AND TP1IMP2 >= vi_SaldoCap;
        EXCEPTION WHEN OTHERS THEN
             vo_ind_error := 'N';
             vo_tip_error := 'MONTO';
        END;   
      --VALIDAR PRIMERO PLAZO RESIDUAL
      PQ_CR_RP_REPROG_CAJA_LC.sp_cr_plazo_matriz_lc(instancia,
                                                    vo_plazoh );
      PQ_CR_RP_REPROG_CAJA_LC.sp_cr_plazo_crd_caja_lc(instancia,
                                                      vo_plazoc );
      IF vo_plazoh<vo_plazoc THEN
          PQ_CR_RP_REPROG_CAJA_LC.sp_cr_plazo_residual_lc(instancia,
                                                          vo_plazor );
          BEGIN
            SELECT F.TP1NRO1
              INTO vi_cargo_pzo_r
              FROM FST198 F
             WHERE F.TP1COD = 1
               AND F.TP1COD1 = 10899
               AND F.TP1CORR1 = 400000
               AND F.TP1CORR2 = 509
               AND F.TP1IMP1 <= vo_plazor
               AND F.TP1IMP2 >= vo_plazor
               AND F.tp1nro2 = vi_codigo_monto;
            EXCEPTION 
              WHEN OTHERS THEN
                  vi_cargo_pzo_r:= 0; 
                  vo_ind_error := 'N';
                  vo_tip_error := 'PLAZO';
            END;  
      END IF;
       
      --------------------------------------------------
      --VALIDAR SEGUNDO GRACIA
      PQ_CR_RP_REPROG_CAJA_LC.sp_cr_gracia_caja_lc(instancia,
                                                   vo_gracia,
                                                   vo_monto );
      BEGIN
        SELECT F.TP1NRO1
          INTO vi_cargo_grac
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 507
           AND F.TP1IMP1 <= vo_gracia
           AND F.TP1IMP2 >= vo_gracia           
           AND F.tp1nro2 = vi_codigo_monto;
      exception
           when no_data_found then 
             BEGIN
                 SELECT min(F.TP1NRO1)
                  INTO vi_cargo_grac
                  FROM FST198 F
                 WHERE F.TP1COD = 1
                   AND F.TP1COD1 = 10899
                   AND F.TP1CORR1 = 400000
                   AND F.TP1CORR2 = 507
                   AND F.TP1IMP1 <= vo_gracia
                   AND F.TP1IMP2 >= vo_gracia;
             EXCEPTION
               WHEN OTHERS THEN      
                 vo_ind_error := 'N';
                 vo_tip_error := 'GRACIA';                 
                 RETURN;
             END;    
        END;                                     
      --------------------------------------------------                                     
      --VALIDAR GRADIENTE
      PQ_CR_RP_REPROG_CAJA_LC.sp_cr_gradiente_caja_lc(instancia,
                                                      vo_gradiente);
      BEGIN
        SELECT F.TP1NRO1
          INTO vi_cargo_grad
          FROM FST198 F
         WHERE F.TP1COD   = 1
           AND F.TP1COD1  = 10899
           AND F.TP1CORR1 = 400000
           AND F.TP1CORR2 = 508
           AND F.TP1IMP1 <= vo_gradiente
           AND F.TP1IMP2 >= vo_gradiente
           AND F.tp1nro2 = vi_codigo_monto;
        exception
           when no_data_found then 
             BEGIN
             SELECT min(F.TP1NRO1)
              INTO vi_cargo_grad
              FROM FST198 F
             WHERE F.TP1COD   = 1
               AND F.TP1COD1  = 10899
               AND F.TP1CORR1 = 400000
               AND F.TP1CORR2 = 508
               AND F.TP1IMP1 <= vo_gradiente
               AND F.TP1IMP2 >= vo_gradiente;
             EXCEPTION
               WHEN OTHERS THEN  
                 vo_ind_error := 'N';
                 vo_tip_error := 'GRADIENTE';
                 RETURN;
             END;    
        END;                    
      
      ---VALIDAR EL MAXIMO CARGO
      vo_cargo := vi_cargo_mont;
      IF vo_cargo < vi_cargo_pzo_r THEN
        vo_cargo:= vi_cargo_pzo_r;
      END IF;
      IF vo_cargo < vi_cargo_grac THEN
        vo_cargo:= vi_cargo_grac;
      END IF;
      IF vo_cargo < vi_cargo_grad THEN
        vo_cargo:= vi_cargo_grad;
      END IF;
      IF vo_cargo < vi_cargo_tasa THEN
        vo_cargo:= vi_cargo_tasa;
      END IF;
      
  END;
  
end PQ_CR_RP_REPROG_CAJA_LC;
/

