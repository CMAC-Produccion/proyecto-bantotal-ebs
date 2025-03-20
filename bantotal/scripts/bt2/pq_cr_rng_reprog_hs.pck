create or replace package PQ_CR_RNG_REPROG_HS is

  -- Author  : HSUAREZ
  -- Created : 22/04/2021 20:13:10
  -- Purpose : RNG para el Panel de Reprogramados
  -- Author  : HSUAREZ
  -- Created : 22/04/2024 20:13:10
  -- Purpose : Modificaciones de los controles de Gradiente,Plazo y gracia en Reprogramados Caja MEMO18-2024
  
  procedure sp_cr_plazo_matriz(ve_instancia in int,
                               vo_plazo out int);
  procedure sp_cr_plazo_matriz_sj(ve_instancia in int,
                               vo_plazo out int);                               
                               
  procedure sp_cr_plazo_crd_caj(ve_instancia in int,
                                vo_plazo out int); 
  procedure sp_cr_plazo_crd_caj_sj(ve_instancia in int,
                                    vo_plazo out int);                                              
  procedure sp_cr_valida_covit(ve_instancia in int,
                               vo_rpta out varchar);
  procedure sp_cr_gracia_caj(ve_instancia in int,
                                 vo_gracia out int,
                                 vo_monto out number);
  procedure sp_cr_gradiente_caj(ve_instancia in int,
                                 vo_gradiente out int);
  procedure sp_cr_plazo_residual(ve_instancia in int,
                                      vo_plazo_re out int);
  PROCEDURE SP_CR_GRADIENTE_CAJ_SJ(
                                        ve_instancia number,
                                        ve_rpta out varchar
                                      );
  procedure sp_cr_plazo_residual_2024(ve_instancia in int,
                                         vo_plazo_re out int);                                      
end PQ_CR_RNG_REPROG_HS;
/

create or replace package body PQ_CR_RNG_REPROG_HS is

  procedure sp_cr_plazo_matriz(ve_instancia in int,
                               vo_plazo out int) is
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
    vi_fecactual date;
    vi_plzo_res number(4);
    vi_scsdo number(17,2);
    FEC_PAGO DATE;
    FLAG_PAGOS varchar2(1);
    vi_fecpagmin date;
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
                      AND D.PPFPAG > FEC_PAGO;
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
               SELECT F.SCSDO*-1
                 INTO vi_scsdo
                 FROM FSD011 F
                WHERE F.PGCOD = vi_pgcod
                  AND F.SCMOD = vi_aomod
                  AND F.SCSUC = vi_aosuc
                  AND F.SCMDA = vi_aomda
                  AND F.SCPAP = vi_aopap
                  AND F.SCCTA = vi_aocta
                  AND F.SCOPER = vi_aooper
                  AND F.SCSBOP = vi_aosbop
                  AND F.SCTOPE = vi_aotope;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;          
            end;   
            BEGIN
              select a.aqpb260pla
                INTO vo_plazo
                from AQPB260 a
              where vi_scsdo > a.aqpb260sdi
                 and vi_scsdo <= a.aqpb260sdf
                 and vi_plzo_res >= a.aqpb260cui
                 and vi_plzo_res <= a.aqpb260cuf
                 and a.aqpb260est = 'S';
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;     
            END;
      end;
   
  procedure sp_cr_plazo_matriz_sj(ve_instancia in int,
                               vo_plazo out int) is
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
    vi_fecactual date;
    vi_plzo_res number(4);
    vi_scsdo number(17,2);
    FEC_PAGO DATE;
    FLAG_PAGOS varchar2(1);
    vi_fecpagmin date;
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
                      AND D.PPFPAG > FEC_PAGO;
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
               SELECT F.SCSDO*-1
                 INTO vi_scsdo
                 FROM FSD011 F
                WHERE F.PGCOD = vi_pgcod
                  AND F.SCMOD = vi_aomod
                  AND F.SCSUC = vi_aosuc
                  AND F.SCMDA = vi_aomda
                  AND F.SCPAP = vi_aopap
                  AND F.SCCTA = vi_aocta
                  AND F.SCOPER = vi_aooper
                  AND F.SCSBOP = vi_aosbop
                  AND F.SCTOPE = vi_aotope;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;          
            end;   
            BEGIN
              select a.aqpb260bpla
                INTO vo_plazo
                from AQPB260b a
              where vi_scsdo > a.aqpb260bsdi
                 and vi_scsdo <= a.aqpb260bsdf
                 and vi_plzo_res >= a.aqpb260bcui
                 and vi_plzo_res <= a.aqpb260bcuf
                 and a.aqpb260best = 'S';
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;     
            END;
      end;
        
   procedure sp_cr_plazo_crd_caj(ve_instancia in int,
                                 vo_plazo out int) is
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
         
         begin
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
         vo_plazo := round(vo_plazo/30);  
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
                    AND D.PPSBOP = 609--vi_aosbop --609
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
                    AND D.PPSBOP = 609--vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
            END;
            BEGIN
             SELECT  MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual)
               INTO  vo_plazo
               FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;
              END;
         END IF;
     end;
     
   procedure sp_cr_plazo_crd_caj_sj(ve_instancia in int,
                                    vo_plazo out int) is
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
         
         begin
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
         vo_plazo := round(vo_plazo/30);  
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
                    AND D.PPSBOP = 609--vi_aosbop --609
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
                    AND D.PPSBOP = 609--vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
            END;
            BEGIN
             SELECT  MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual)
               INTO  vo_plazo
               FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;
              END;
         END IF;
     end;
     
     procedure sp_cr_valida_covit(ve_instancia in int,
                               vo_rpta out varchar) is
     vi_tpgcovit varchar(1); 
     vi_estado varchar(2);
     vi_pgcod xwf700.xwfempresa%type;
     vi_aomod xwf700.xwfmodulo%type;
     vi_aosuc xwf700.xwfsucursal%type;
     vi_aomda xwf700.xwfmoneda%type;
     vi_aopap xwf700.xwfpapel%type;
     vi_aocta xwf700.xwfcuenta%type;
     vi_aooper xwf700.xwfoperacion%type;
     vi_aosbop xwf700.xwfsubope%type;
     vi_aotope xwf700.xwftipope%type;   
     CUOTAREST NUMBER(17,2);
                          
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
                  into vi_pgcod ,
                       vi_aomod ,
                       vi_aosuc ,
                       vi_aomda ,
                       vi_aopap ,
                       vi_aocta ,
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
                SELECT F.ESTADOSOLICITUD
                  INTO vi_estado 
                FROM V_REPROG F 
                 WHERE SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = vi_aocta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99)     = vi_aooper
                AND F.ESTADOSOLICITUD IN('BT','AP');
          EXCEPTION
            WHEN OTHERS THEN
                 vi_estado:='PE';   
          END;
          vo_rpta := 'S';
          IF vi_estado = 'BT' or vi_estado = 'AP' THEN
             BEGIN
               SELECT J.JAQA400AC1
                   INTO vi_tpgcovit
                   FROM JAQA400 J
                  WHERE J.JAQA400EMP = vi_pgcod 
                    AND J.JAQA400MOD = vi_aomod 
                    AND J.JAQA400SUC = vi_aosuc 
                    AND J.JAQA400MDA = vi_aomda 
                    AND J.JAQA400PAP = vi_aopap 
                    AND J.JAQA400CTA = vi_aocta 
                    AND J.JAQA400OPE = vi_aooper
                    AND J.JAQA400SBO = vi_aosbop
                    AND J.JAQA400TOP = vi_aotope
                    AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                          FROM JAQA400 D
                                         WHERE D.JAQA400EMP = vi_pgcod 
                                           AND D.JAQA400MOD = vi_aomod 
                                           AND D.JAQA400SUC = vi_aosuc 
                                           AND D.JAQA400MDA = vi_aomda 
                                           AND D.JAQA400PAP = vi_aopap 
                                           AND D.JAQA400CTA = vi_aocta 
                                           AND D.JAQA400OPE = vi_aooper
                                           AND D.JAQA400SBO = vi_aosbop
                                           AND D.JAQA400TOP = vi_aotope
                                         );
             EXCEPTION
               WHEN OTHERS THEN
                 vi_tpgcovit := 'E';
             END;
             IF vi_tpgcovit = 'C' or vi_tpgcovit = 'U' then
               vo_rpta := 'S';
             ELSE
               vo_rpta := 'N';
             END IF; 
          END IF;  
       end;
       procedure sp_cr_gracia_caj(ve_instancia in int,
                                 vo_gracia out int,
                                 vo_monto out number) is
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
                 and x.xllaosbop= 609
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
      
       procedure sp_cr_gradiente_caj(ve_instancia in int,
                                 vo_gradiente out int) is
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
       vi_cant_cuot  number(6);
       vi_cuotas  number(5);
       contador number(10);
       vi_fecha_pago date;
       vi_cuota_fija number(17,2);
       vi_temporal number(17,2);
       vi_controlcuota NUMBER(10);       
       val_cuota7 number(17,2);
       val_flgCuoIgu varchar2(1);
       val_cuotMin6priCuot number(17,2);
       val_aux6primCuot number(17,2);
       vi_fecpagmax DATE;
       val_cuotMax  number(17,2);
       val_cuotMin number(17,2);
       val_fecha6cuot DATE;
       
       CURSOR CRONOGRAMA_PRP(v_pgcod number,
                            v_aomod number,              
                            v_aosuc number,
                            v_aomda number,
                            v_aopap number,
                            v_aocta number,
                            v_aooper number,
                            v_aosbop number,
                            v_aotope number
                           ) IS 
      SELECT (d.ppcap+d.ppint
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0))) cuota
                  ,D.*
        FROM FSD601 D left join FSD611 D2 on 
              D.pgcod =  d2.pgcod
          and D.ppmod =  d2.ppmod 
          and D.ppsuc =  d2.ppsuc
          and D.ppmda =  d2.ppmda 
          and D.pppap =  d2.pppap
          and D.ppcta =  d2.ppcta
          and D.ppoper = d2.ppoper
          and D.ppsbop = d2.ppsbop
          and D.pptope = d2.pptope
          and D.ppfpag = d2.ppfpag
        WHERE D.PGCOD = v_pgcod
          AND D.PPMOD = v_aomod
          AND D.PPSUC = v_aosuc
          AND D.PPMDA = v_aomda
          AND D.PPPAP = v_aopap
          AND D.PPCTA = v_aocta
          AND D.PPOPER= v_aooper
          AND D.PPSBOP= 609--v_aosbop
          AND D.PPTOPE= v_aotope          
          and D.PPTIPO = 'M' --AGREGADO HASL 
          ORDER BY D.PPFPAG ASC;           
       
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
         
         vi_aosbop := 609; --reprogramaciones
         
         -- tiene menos de 6 cuotas no aplica gradiente
           BEGIN
             SELECT COUNT(*) 
             INTO vi_cuotas
             FROM FSD601 D
             WHERE D.PGCOD = vi_pgcod
               AND D.PPMOD = vi_aomod
               AND D.PPSUC = vi_aosuc
               AND D.PPMDA = vi_aomda
               AND D.PPPAP = vi_aopap
               AND D.PPCTA = vi_aocta
               AND D.PPOPER= vi_aooper
               AND D.PPSBOP= 609--vi_aosbop
               AND D.PPTOPE= vi_aotope
               and D.PPTIPO = 'M'; --AGREGADO HASL
           EXCEPTION
             WHEN OTHERS THEN
                  vi_cuotas := 0; 
           END;
           --GUIA ESPECIAL 
           BEGIN
             SELECT TP1IMP1 
             INTO vi_controlcuota
             FROM FST198 
             WHERE TP1COD  = 1
             AND   TP1COD1 = 108999
             AND  TP1CORR1 = 400000
             AND  TP1CORR2 = 301
             AND  TP1CORR3 = 1
             AND  TP1NRO1  = 1;
           EXCEPTION
             WHEN OTHERS THEN
               null;            
           END;
           vi_controlcuota := nvl(vi_controlcuota, 0);                      
           
           
           val_flgCuoIgu := 'S';
           val_cuotMin6priCuot := 0;
           val_fecha6cuot := '';
           IF vi_cuotas >= vi_controlcuota  THEN  ---mayor o igual a 7 cuotas
              --Sólo aplica para frecuencias mensuales (no aplica para créditos con flujo de caja).
              contador := 1;
              val_cuota7 := 0;
              BEGIN
                     for j in CRONOGRAMA_PRP(
                                              vi_pgcod,
                                              vi_aomod,
                                              vi_aosuc,
                                              vi_aomda,
                                              vi_aopap,
                                              vi_aocta,
                                              vi_aooper,
                                              vi_aosbop,
                                              vi_aotope
                                            ) loop  
                    
                        BEGIN                                                
                           if contador = 7 then
                              val_fecha6cuot := j.ppfpag;
                              --cuota
                              vi_cuota_fija := j.cuota; 
                              val_cuota7 := vi_cuota_fija;                             
                           end if;
                                                                        
                           --El monto de las cuotas a partir de la cuota 7 serán iguales solo hasta la penultima cuota.
                           if contador >= vi_controlcuota AND contador <= (vi_cuotas-1) THEN                            
                              --SUMAR CAPITAL + INTERES + SEGURO
                              if vi_cuota_fija <> j.cuota then --EN CASO DE QUE LA CUOTA A PARTIR DE LA 7 CUOTA SEA DIFERENTE NO APLICA CONTROL
                                 val_flgCuoIgu := 'N'; --no controlamos.
                                 val_cuota7 := 0;
                                 exit;
                              end if;  
                           end if;  
                        END;
                        contador := contador + 1;
                    end loop;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;                                                        
               END;            
               
               IF val_flgCuoIgu = 'S' THEN
                  BEGIN
                   SELECT MIN((d.ppcap+d.ppint
                          + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                          INTO val_cuotMin6priCuot 
                    FROM FSD601 D left join FSD611 D2
                      on  D.pgcod =  d2.pgcod
                      and D.ppmod =  d2.ppmod 
                      and D.ppsuc =  d2.ppsuc
                      and D.ppmda =  d2.ppmda 
                      and D.pppap =  d2.pppap
                      and D.ppcta =  d2.ppcta
                      and D.ppoper = d2.ppoper
                      and D.ppsbop = d2.ppsbop
                      and D.pptope = d2.pptope
                      and D.ppfpag = d2.ppfpag
                    WHERE D.PGCOD = vi_pgcod
                      AND D.PPMOD = vi_aomod
                      AND D.PPSUC = vi_aosuc
                      AND D.PPMDA = vi_aomda
                      AND D.PPPAP = vi_aopap
                      AND D.PPCTA = vi_aocta
                      AND D.PPOPER= vi_aooper
                      AND D.PPSBOP= 609--vi_aosbop
                      AND D.PPTOPE= vi_aotope                      
                      and D.ppfpag < val_fecha6cuot
                      and D.PPTIPO = 'M' --AGREGADO HASL
                      ORDER BY D.PPFPAG ASC;   
                   EXCEPTION 
                     WHEN OTHERS THEN
                       val_cuotMin6priCuot := 0;
                   END; 
                   val_cuotMin6priCuot := nvl(val_cuotMin6priCuot, 0);  
                   
                   --calculo de gradiente
                   IF val_cuota7 <> 0 THEN
                      BEGIN
                        SELECT (1 - (val_cuotMin6priCuot/val_cuota7))* 100 INTO vo_gradiente FROM DUAL;
                      EXCEPTION 
                       WHEN OTHERS THEN   
                         vo_gradiente := 0;                 
                      END;
                    END IF;
                    
               END IF;               
               vo_gradiente := NVL(vo_gradiente, 0);                                  
               
           ELSE --menor o igual a 6 cuotas
             BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
                SELECT MAX(D.PPFPAG)
                INTO vi_fecpagmax     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER =vi_aooper
                    AND D.PPSBOP = 609--vi_aosbop
                    AND D.PPTOPE =vi_aotope
                    and D.PPTIPO = 'M'; --AGREGADO HASL;
             EXCEPTION
               WHEN OTHERS THEN
                  vi_fecpagmax := NULL; 
             END;
             
             val_cuotMax := 0;
             BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
               SELECT MAX((d.ppcap+d.ppint
                      + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                      INTO val_cuotMax 
                FROM FSD601 D left join FSD611 D2
                  on  D.pgcod =  d2.pgcod
                  and D.ppmod =  d2.ppmod 
                  and D.ppsuc =  d2.ppsuc
                  and D.ppmda =  d2.ppmda 
                  and D.pppap =  d2.pppap
                  and D.ppcta =  d2.ppcta
                  and D.ppoper = d2.ppoper
                  and D.ppsbop = d2.ppsbop
                  and D.pptope = d2.pptope
                  and D.ppfpag = d2.ppfpag
                WHERE D.PGCOD = vi_pgcod
                  AND D.PPMOD = vi_aomod
                  AND D.PPSUC = vi_aosuc
                  AND D.PPMDA = vi_aomda
                  AND D.PPPAP = vi_aopap
                  AND D.PPCTA = vi_aocta
                  AND D.PPOPER= vi_aooper
                  AND D.PPSBOP= 609--vi_aosbop
                  AND D.PPTOPE= vi_aotope
                  and D.ppfpag < vi_fecpagmax
                  and D.PPTIPO = 'M' --AGREGADO HASL
                  ORDER BY D.PPFPAG ASC;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   val_cuotMax := 0;
               END; 
               val_cuotMax := nvl(val_cuotMax, 0);  
               
              val_cuotMin := 0;
               BEGIN --obtener la cuota mayor de todas las cuotas excepto la ultima cuota.
               SELECT Min((d.ppcap+d.ppint
                      + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)))) cuota
                      INTO val_cuotMin 
                FROM FSD601 D left join FSD611 D2
                  on  D.pgcod =  d2.pgcod
                  and D.ppmod =  d2.ppmod 
                  and D.ppsuc =  d2.ppsuc
                  and D.ppmda =  d2.ppmda 
                  and D.pppap =  d2.pppap
                  and D.ppcta =  d2.ppcta
                  and D.ppoper = d2.ppoper
                  and D.ppsbop = d2.ppsbop
                  and D.pptope = d2.pptope
                  and D.ppfpag = d2.ppfpag
                WHERE D.PGCOD = vi_pgcod
                  AND D.PPMOD = vi_aomod
                  AND D.PPSUC = vi_aosuc
                  AND D.PPMDA = vi_aomda
                  AND D.PPPAP = vi_aopap
                  AND D.PPCTA = vi_aocta
                  AND D.PPOPER= vi_aooper
                  AND D.PPSBOP= 609--vi_aosbop
                  AND D.PPTOPE= vi_aotope                   
                  and D.ppfpag < vi_fecpagmax
                  and D.PPTIPO = 'M' --AGREGADO HASL
                  ORDER BY D.PPFPAG ASC;   
               EXCEPTION 
                 WHEN OTHERS THEN
                   val_cuotMin := 0;
               END; 
               val_cuotMin := nvl(val_cuotMin, 0);                          
              
              --calcular gradiente
              IF val_cuotMax <> 0 THEN           
                BEGIN
                  SELECT (1-(val_cuotMin/val_cuotMax))*100 INTO vo_gradiente FROM DUAL;
                EXCEPTION 
                 WHEN OTHERS THEN   
                   vo_gradiente := 0;                 
                END;
              END IF;
                 
              vo_gradiente := NVL(vo_gradiente, 0);
           END IF;                        
         vo_gradiente := NVL(vo_gradiente, 0);         
       END;
       
    procedure sp_cr_plazo_residual(ve_instancia in int,
                                      vo_plazo_re out int) is
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
    vi_fecactual date;
    vi_plzo_res number(4);
    vi_scsdo number(17,2);
    FEC_PAGO DATE;
    FLAG_PAGOS varchar2(1);
    vi_fecpagmin date;
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
                      AND D.PPFPAG > FEC_PAGO;
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
      
      PROCEDURE SP_CR_GRADIENTE_CAJ_SJ(
                                        ve_instancia number,
                                        ve_rpta out varchar
                                      ) IS
      vi_pgcod xwf700.xwfempresa%type;
      vi_aomod xwf700.xwfmodulo%type;
      vi_aosuc xwf700.xwfsucursal%type;
      vi_aomda xwf700.xwfmoneda%type;
      vi_aopap xwf700.xwfpapel%type;
      vi_aocta xwf700.xwfcuenta%type;
      vi_aooper xwf700.xwfoperacion%type;
      vi_aosbop xwf700.xwfsubope%type;
      vi_aotope xwf700.xwftipope%type;
      vi_cuotas number(17,2);
      contador number(10);
      vi_fecha_pago date;
      vi_cuota_fija number(17,2);
      vi_temporal number(17,2);
      vi_controlcuota NUMBER(10);
      
      CURSOR CRONOGRAMA_PRP(v_pgcod number,
                            v_aomod number,              
                            v_aosuc number,
                            v_aomda number,
                            v_aopap number,
                            v_aocta number,
                            v_aooper number,
                            v_aotope number
                           ) IS 
      SELECT (d.ppcap+d.ppint
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0))) cuota
                  ,D.*
        FROM FSD601 D, FSD611 D2
        WHERE D.PGCOD = v_pgcod
          AND D.PPMOD = v_aomod
          AND D.PPSUC = v_aosuc
          AND D.PPMDA = v_aomda
          AND D.PPPAP = v_aopap
          AND D.PPCTA = v_aocta
          AND D.PPOPER= v_aooper
          AND D.PPSBOP= 609
          AND D.PPTOPE= v_aotope
          AND D.pgcod =  d2.pgcod
          and D.ppmod =  d2.ppmod 
          and D.ppsuc =  d2.ppsuc
          and D.ppmda =  d2.ppmda 
          and D.pppap =  d2.pppap
          and D.ppcta =  d2.ppcta
          and D.ppoper = d2.ppoper
          and D.ppsbop = d2.ppsbop
          and D.pptope = d2.pptope
          and D.ppfpag = d2.ppfpag
           ORDER BY D.PPFPAG ASC;                                  
      BEGIN
        --OBTENER LA CLAVE DEL CREDITO
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
           EXCEPTION
              when others then
                null;                                  
           END;
           -- tiene menos de 6 cuotas no aplica gradiente
           BEGIN
             SELECT COUNT(*) 
             INTO vi_cuotas
             FROM FSD601 D
             WHERE D.PGCOD = vi_pgcod
               AND D.PPMOD = vi_aomod
               AND D.PPSUC = vi_aosuc
               AND D.PPMDA = vi_aomda
               AND D.PPPAP = vi_aopap
               AND D.PPCTA = vi_aocta
               AND D.PPOPER= vi_aooper
               AND D.PPSBOP= 609
               AND D.PPTOPE= vi_aotope;
           EXCEPTION
             WHEN OTHERS THEN
                  vi_cuotas := 0; 
           END;
           --GUIA ESPECIAL 
           BEGIN
             SELECT TP1IMP1 
             INTO vi_controlcuota
             FROM FST198 
             WHERE TP1COD  = 1
             AND   TP1COD1 = 108999
             AND  TP1CORR1 = 400000
             AND  TP1CORR2 = 301
             AND  TP1CORR3 = 1
             AND  TP1NRO1  = 1;
           END;
           
           
           
           
           
           ve_rpta := 'S';
           IF vi_cuotas >= vi_controlcuota  THEN
              --Sólo aplica para frecuencias mensuales (no aplica para créditos con flujo de caja).
              contador := 1;
              BEGIN
                     for j in CRONOGRAMA_PRP(
                                              vi_pgcod,
                                              vi_aomod,
                                              vi_aosuc,
                                              vi_aomda,
                                              vi_aopap,
                                              vi_aocta,
                                              vi_aooper,
                                              vi_aotope
                                            ) loop  
                    
                        BEGIN
                           if contador = vi_controlcuota then
                              vi_fecha_pago := j.ppfpag;
                              --cuota
                              vi_cuota_fija := j.cuota;
                           end if;
                           --El monto de las cuotas a partir de la cuota 7 serán iguales.
                           if contador >= vi_controlcuota AND contador < (vi_cuotas-1) THEN
                              --SUMAR CAPITAL + INTERES + SEGURO
                              if vi_cuota_fija <> j.cuota then --EN CASO DE QUE LA CUOTA A PARTIR DE LA 7 CUOTA SEA DIFERENTE NO APLICA CONTROL
                                 ve_rpta := 'S'; --no controlamos.
                                 exit;
                              end if;  
                           end if;  
                        END;
                        contador := contador + 1;
                    end loop;                        
              END;
              --El control se realizará en función a la comparación individual del monto de las primeras 6 cuotas con la cuota 7 del nuevo cronograma: 
              --no deberá disminuir más del 80% indicado en el memorando. Es decir, que el monto de ninguna de las 6 primeras cuotas deberá ser menor al 20% 
              --de la cuota 7.
              BEGIN
                  for jj in CRONOGRAMA_PRP(
                                              vi_pgcod,
                                              vi_aomod,
                                              vi_aosuc,
                                              vi_aomda,
                                              vi_aopap,
                                              vi_aocta,
                                              vi_aooper,
                                              vi_aotope
                                            ) loop 
                  BEGIN
                       --validando que la nuva cuota no sea menor al 0.2 de la cuota 7
                       if jj.cuota >= vi_cuota_fija*0.2 then
                         ve_rpta := 'S';
                       else
                         ve_rpta := 'N';
                         exit;   
                       end if;
                  END;
                  END LOOP;                              
              END;
           ELSE
             --No aplica para créditos con menos de 7 cuotas (parametrizable).
             ve_rpta := 'S' ; 
           END IF;

      END;
     procedure sp_cr_plazo_residual_2024(ve_instancia in int,
                                         vo_plazo_re out int) is
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
     vi_fecactual date;
     vi_plzo_res number(4);
     vi_scsdo number(17,2);
     FEC_PAGO DATE;
     FLAG_PAGOS varchar2(1);
     vi_fecpagmin date;
     vi_fecvencpro date;
     vi_cantcuopr number(17,2);
     VALIDAR_PZORSD number(9);
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
                    AND D.PPFPAG > FEC_PAGO;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            IF vi_fecpagmin IS NULL THEN
               BEGIN
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
                        AND D.PPTOPE = vi_aotope;  
                /*SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;*/
              END;
            END IF;
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
          
          --OBTENGO EL PLAZO RESIDUAL DEL CREDITO VIGENTE                 
          BEGIN
            SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecactual) 
              INTO vi_plzo_res
            FROM DUAL;
          EXCEPTION 
            WHEN OTHERS THEN
              vi_plzo_res:= 0;  
          END;
          --OBTENGO EL PLAZO RESIDUAL DEL CREDITO EN VUELO. SUB. 609
          BEGIN
            SELECT TP1NRO1 
              INTO VALIDAR_PZORSD
              FROM FST198
             WHERE TP1COD   = 1
               AND TP1COD1  = 11161
               AND TP1CORR1 = 400000
               AND TP1CORR2 = 64
               AND TP1CORR3 = 1;
          EXCEPTION
            WHEN OTHERS THEN
              VALIDAR_PZORSD := 1;  
          END;
          IF VALIDAR_PZORSD <> 1 THEN
              BEGIN
                SELECT MAX(D.PPFPAG)
                  INTO vi_fecvencpro   
                  FROM FSD601 D
                 WHERE D.PGCOD  = vi_pgcod
                   AND D.PPMOD  = vi_aomod
                   AND D.PPSUC  = vi_aosuc
                   AND D.PPMDA  = vi_aomda
                   AND D.PPPAP  = vi_aopap
                   AND D.PPCTA  = vi_aocta
                   AND D.PPOPER = vi_aooper
                   AND D.PPSBOP = 609
                   AND D.PPTOPE = vi_aotope; 
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --OBTENGO EL PLAZO RESIDUAL DEL VENCIMIENTO CREDITO VIGENTE VS CREDITO PROPUESTO.                
              BEGIN
                SELECT MONTHS_BETWEEN(vi_fecpagmax,vi_fecvencpro) 
                  INTO vi_plzo_res
                FROM DUAL;
              EXCEPTION 
                WHEN OTHERS THEN
                  vi_plzo_res:= 0;  
              END;
          ELSE
              BEGIN
                SELECT COUNT(*)
                  INTO vi_cantcuopr
                  FROM FSD601 D
                 WHERE D.PGCOD  = vi_pgcod
                   AND D.PPMOD  = vi_aomod
                   AND D.PPSUC  = vi_aosuc
                   AND D.PPMDA  = vi_aomda
                   AND D.PPPAP  = vi_aopap
                   AND D.PPCTA  = vi_aocta
                   AND D.PPOPER = vi_aooper
                   AND D.PPSBOP = 609
                   AND D.PPTOPE = vi_aotope; 
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              vi_plzo_res:= vi_cantcuopr - vi_plzo_res;
              IF vi_plzo_res < 0 then
                vi_plzo_res := 0;
              end if;    
          END IF;
          vo_plazo_re:=  vi_plzo_res;
     exception
        when others then
           null;
     end;
end PQ_CR_RNG_REPROG_HS;
/

