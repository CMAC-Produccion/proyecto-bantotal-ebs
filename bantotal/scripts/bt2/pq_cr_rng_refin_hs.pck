create or replace package PQ_CR_RNG_REFIN_HS is

  -- Author  : HSUAREZ
  -- Created : 22/04/2021 20:13:10
  -- Purpose : RNG para el Panel de Reprogramados
  
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

end PQ_CR_RNG_REFIN_HS;
/

create or replace package body PQ_CR_RNG_REFIN_HS is

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
      execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';  
      vo_plazo:= 0;
            BEGIN
                select f.xwfempresa,
                       f.xwfmodulo,
                       f.xwfsucursal,
                       f.xwfmoneda,
                       f.xwfpapel,
                       f.xwfcuenta,
                       f.xwfoperacion,
                       f.xwfsubope,
                       f.xwftipope
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700 f
                where xwfprcins= ve_instancia                  
                  and f.xwfcar3 = 'R'
                  and f.xwffec1 = (select max(d.xwffec1)
                                     from xwf700 d
                                    where d.xwfprcins = f.xwfprcins
                                      and d.xwfcar3 = 'R');
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
              SELECT /*+index(D SYS_C00977150) index(D2 SYS_C00978743)*/ MAX(D.PPFPAG),'N'
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
                BEGIN
                  select x.xllcapital
                    into vi_scsdo
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
               EXCEPTION
                 WHEN OTHERS THEN
                   NULL;
               END;                 
            end;   
            BEGIN
              select a.aqpb260epla
                INTO vo_plazo
                from AQPB260E a
              where vi_scsdo > a.aqpb260esdi
                 and vi_scsdo <= a.aqpb260esdf
                 and vi_plzo_res >= a.aqpb260ecui
                 and vi_plzo_res <= a.aqpb260ecuf
                 and a.aqpb260eest = 'S';
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
      execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';  
      vo_plazo:= 0;
            BEGIN
                select f.xwfempresa,
                       f.xwfmodulo,
                       f.xwfsucursal,
                       f.xwfmoneda,
                       f.xwfpapel,
                       f.xwfcuenta,
                       f.xwfoperacion,
                       f.xwfsubope,
                       f.xwftipope
                  into vi_pgcod,
                       vi_aomod,
                       vi_aosuc,
                       vi_aomda,
                       vi_aopap,
                       vi_aocta,
                       vi_aooper,
                       vi_aosbop,
                       vi_aotope     
                from xwf700 f
                where xwfprcins= ve_instancia                  
                  and f.xwfcar3 = 'R'
                  and f.xwffec1 = (select max(d.xwffec1)
                                     from xwf700 d
                                    where d.xwfprcins = f.xwfprcins
                                      and d.xwfcar3 = 'R');
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
              SELECT /*+index(D SYS_C00977150) index(D2 SYS_C00978743)*/ MAX(D.PPFPAG),'N'
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
                BEGIN
                  select x.xllcapital
                    into vi_scsdo
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
               EXCEPTION
                 WHEN OTHERS THEN
                   NULL;
               END;                 
            end;   
            BEGIN
              select a.aqpb260fpla
                INTO vo_plazo
                from AQPB260F a
              where vi_scsdo > a.aqpb260fsdi
                 and vi_scsdo <= a.aqpb260fsdf
                 and vi_plzo_res >= a.aqpb260fcui
                 and vi_plzo_res <= a.aqpb260fcuf
                 and a.aqpb260fest = 'S';
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
     vo_plazo:= 0;
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
                    AND D.PPSBOP = vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            
            begin               
              SELECT MIN(D.PPFVAL)              
                INTO vi_fecvalmin     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
            END;
            BEGIN
             SELECT  NVL(MONTHS_BETWEEN(vi_fecpagmax,vi_fecvalmin),0)
               INTO  vo_plazo
               FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;
                   vo_plazo:=0;
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
     vo_plazo:= 0;
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
                    AND D.PPSBOP = vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            
            begin               
              SELECT MIN(D.PPFVAL)              
                INTO vi_fecvalmin     
                   FROM FSD601 D
                  WHERE D.PGCOD = vi_pgcod
                    AND D.PPMOD = vi_aomod
                    AND D.PPSUC = vi_aosuc
                    AND D.PPMDA = vi_aomda
                    AND D.PPPAP = vi_aopap
                    AND D.PPCTA = vi_aocta
                    AND D.PPOPER = vi_aooper
                    AND D.PPSBOP = vi_aosbop --609
                    AND D.PPTOPE = vi_aotope;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;      
            end;
            BEGIN
              SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD=1;
            END;
            BEGIN
             SELECT  NVL(MONTHS_BETWEEN(vi_fecpagmax,vi_fecvalmin),0)
               INTO  vo_plazo
               FROM DUAL;
            EXCEPTION 
              WHEN OTHERS THEN
                   NULL;
                   vo_plazo:=0;
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
                 and x.xllaosbop= 609
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
                    AND F.PPSBOP=609
                    AND F.PPTOPE= vi_aotope;
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
                              AND F.PPSBOP=609
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
                      AND F.PPSBOP=609
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
                      AND F.PPSBOP= 609
                      AND F.PPTOPE= vi_aotope
                      AND F.PPFPAG > vi_fecpag3;
                  END;
                  BEGIN
                    SELECT (1-(CUOTA3/CUOTAREST))*100 INTO vo_gradiente FROM DUAL;
                    END;                 
             END IF;
             
             
         END IF;    
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
      execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
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
              SELECT /*+index(D SYS_C00977150) index(D2 SYS_C00978743)*/ MAX(D.PPFPAG),'N'
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
  
end PQ_CR_RNG_REFIN_HS;
/

