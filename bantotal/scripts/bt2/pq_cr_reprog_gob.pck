create or replace package pq_cr_reprog_gob is

  -- *****************************************************************
  -- Nombre                     : pq_cr_reprog_gob
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 11/02/2021 16:50:06
  -- Autor de Creación          : HSUAREZ
  -- Uso                        : Paquete para proceasr creditos de reprogramacion gobierno
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 05/09/2024
  -- Autor de la Modificación   : eninah
  -- Descripción de Modificación: Se modificó el sp_grabar_transac. Se le agregó un commit en el update.
  -- *****************************************************************
  
  procedure sp_validar_rpg_gob(ve_instancia number,vo_rest out varchar);
  procedure sp_calcular_monto(ve_instancia number,
                            ve_pgcod number,
                            ve_scmod number,
                            ve_scsuc  number,
                            ve_scmda  number,
                            ve_scpap  number,
                            ve_sccta  number,
                            ve_scoper number,
                            ve_scsbop number,
                            ve_sctope number,
                            dif_int out number,msg out varchar2);

  PROCEDURE sp_grabartasa(v_instancia in number,
                          v_Pgcod  in number,
                          v_Scmod  in number,
                          v_Scsuc  in number,
                          v_Scmda  in number,
                          v_Scpap  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_Scsbop in number,
                          v_Sctope in number,
                          --v_fecha  in number, 
                          vo_msg  out varchar);
                          
  PROCEDURE sp_grabar_transac(ve_instancia in number,
                            ve_codigo in number,
                            ve_emp    in number,
                            ve_itmod  in number,
                            ve_itsuc  in number,
                            ve_ttran  in number,
                            ve_itnrel in number,
                            ve_fvc    in date,
                            ve_fcont  in date
                           );  
  PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number);
  
 PROCEDURE SP_OBTENER_MONTO(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           vo_saldo out number);
                                                   
end pq_cr_reprog_gob;
/

create or replace package body pq_cr_reprog_gob is
  -- *****************************************************************
  -- Nombre                     : pq_cr_reprog_gob
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 11/02/2021 16:50:06
  -- Autor de Creación          : HSUAREZ
  -- Uso                        : Paquete para proceasr creditos de reprogramacion gobierno
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 05/09/2024
  -- Autor de la Modificación   : eninah
  -- Descripción de Modificación: Se modificó el sp_grabar_transac. Se le agregó un commit en el update.
  -- *****************************************************************
procedure sp_validar_rpg_gob(ve_instancia number,vo_rest out varchar)is
  vi_emp  xwf700.xwfempresa%type;
  vi_mod  xwf700.xwfmodulo%type;
  vi_suc  xwf700.xwfsucursal%type;
  vi_mda  xwf700.xwfmoneda%type;
  vi_pap  xwf700.xwfpapel%type;
  vi_cta  xwf700.xwfcuenta%type;
  vi_oper xwf700.xwfoperacion%type;
  vi_sbop xwf700.xwfsubope%type;
  vi_tope xwf700.xwftipope%type;
  
  begin
    vo_rest:='N';
          begin
               select
               x.xwfempresa,
               x.xwfmodulo,
               x.xwfsucursal,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,               
               x.xwfsubope,
               x.xwftipope
               into 
               vi_emp,
               vi_mod,
               vi_suc,
               vi_mda,
               vi_pap,
               vi_cta,
               vi_oper,
               vi_sbop,
               vi_tope
               from xwf700 x
               where x.xwfprcins=ve_instancia
                 and x.xwfcar3='1'
                 and rownum=1;
            end;
          begin
            select 'S'
              into vo_rest
            from aqpa840 t 
            where t.AQPA840EMP = vi_emp 
              and t.AQPA840MOD = vi_mod
              and t.AQPA840SUC = vi_suc
              and t.AQPA840MDA = vi_mda
              and t.AQPA840PAP = vi_pap
              and t.AQPA840CTA = vi_cta
              and t.AQPA840OPE = vi_oper
              and t.AQPA840SBO = vi_sbop
              and t.AQPA840TOP = vi_tope
              and t.aqpa840tip = '2';
          exception
            when others then
                vo_rest:='N';
          end;
    end;

procedure sp_calcular_monto(ve_instancia number,
                            ve_pgcod number,
                            ve_scmod number,
                            ve_scsuc  number,
                            ve_scmda  number,
                            ve_scpap  number,
                            ve_sccta  number,
                            ve_scoper number,
                            ve_scsbop number,
                            ve_sctope number,
                            dif_int out number,msg out varchar2) is
  vi_tea number(10,6);
  vi_tsa_per number(16,6);
  vi_interes number(17,6);
  
  vi_tea_r number(10,6);
  vi_tsa_per_r number(16,6);
  vi_interes_r number(17,6);
  
  vi_capital number(17,6);
  dias_transc number(5);
  --dif_int number(17,6); 
  
  vi_fec_hoy date;
  VI_FEC_IMP date;
  vi_fec_original date;
  --variablñedel credito 
  v_pgcod  fsd010.pgcod%type;
  v_scmod  fsd010.aomod%type;
  v_scsuc  fsd010.aosuc%type;
  v_scmda  fsd010.aomda%type;
  v_scpap  fsd010.aopap%type;
  v_sccta fsd010.aocta%type;
  v_scoper fsd010.aooper%type;
  v_scsbop fsd010.aosbop%type;
  v_sctope fsd010.aotope%type;
  v_ttas   number(17,6);
  vi_gob   varchar2(1);
  
  flag_pago varchar(1);
begin
          --obtener la clave del credito
          /*
          begin
              select x.xwfempresa,
                     x.xwfmodulo,
                     x.xwfsucursal,
                     x.xwfmoneda,
                     x.xwfpapel,
                     x.xwfcuenta,
                     x.xwfoperacion,
                     x.xwfsubope,
                     x.xwftipope
                into      
                     v_pgcod,
                     v_scmod,
                     v_scsuc,
                     v_scmda,
                     v_scpap,
                     v_sccta,
                     v_scoper,
                     v_scsbop,
                     v_sctope
                from xwf700 x
               where x.xwfprcins = ve_instancia
                 and x.xwfcar3='1';
          end; 
          */
          v_pgcod :=  ve_pgcod;
          v_scmod :=  ve_scmod;
          v_scsuc :=  ve_scsuc;
          v_scmda :=  ve_scmda;
          v_scpap :=  ve_scpap;
          v_sccta :=  ve_sccta;
          v_scoper := ve_scoper;
          v_scsbop := ve_scsbop;
          v_sctope := ve_sctope;
       --OBTENER LA TASA CREDITO VIGENTE
       /*
       pq_cr_jaqa257.sp_cr_tasa(v_pgcod => v_pgcod,
                           v_scmod => v_scmod,
                           v_scsuc => v_scsuc,
                           v_scmda => v_scmda,
                           v_scpap => v_scpap,
                           v_sccta => v_sccta,
                           v_scoper => v_scoper,
                           v_scsbop => v_scsbop,
                           v_sctope => v_sctope,
                           pn_tasa => vi_tea);
       */
       BEGIN
           SELECT AQPB556TSAA
           INTO vi_tea
           FROM AQPB556 A
           WHERE A.AQPB556INST = ve_instancia
            AND A.AQPB556EMP  = v_Pgcod  
            AND A.AQPB556MOD  = v_Scmod  
            AND A.AQPB556SUC  = v_Scsuc  
            AND A.AQPB556MDA  = v_Scmda  
            AND A.AQPB556PAP  = v_Scpap  
            AND A.AQPB556CTA  = v_Sccta  
            AND A.AQPB556OPER = v_Scoper 
            AND A.AQPB556SBOP = v_Scsbop 
            AND A.AQPB556TOP = v_Sctope 
            --AND A.AQPB556EST  = 'P'
            AND A.AQPB556EHAB = 'H'
            AND ROWNUM=1;
         EXCEPTION
            WHEN OTHERS THEN
              NULL;   
         END;   
       --DIAS TRANSCURRIDOS
              --OBTENER FECHA DE PRIMERA CUOTA IMPAGA.
              flag_pago := 'S';
              BEGIN
                    select max(ppfpag),'N'
                      into vi_fec_original,flag_pago
                      from fsd602 f
                     where f.pgcod = v_pgcod
                       and f.ppmod = v_scmod
                       and f.ppsuc = v_scsuc
                       and f.ppmda = v_scmda
                       and f.pppap = v_scpap
                       and f.ppcta = v_sccta
                       and f.ppoper = v_scoper
                       and f.ppsbop = v_scsbop
                       and f.pptope = v_sctope
                       and D602CO = 'S';
                exception
                  when no_data_found then  
                    flag_pago:='S';
                  when others then
                    null;
                  
                END;
                IF vi_fec_original IS NULL THEN
                  flag_pago:='S';
                  BEGIN
                    select min(ppfpag)
                      into vi_fec_original
                      from fsd601 f
                     where f.pgcod = v_pgcod
                       and f.ppmod = v_scmod
                       and f.ppsuc = v_scsuc
                       and f.ppmda = v_scmda
                       and f.pppap = v_scpap
                       and f.ppcta = v_sccta
                       and f.ppoper = v_scoper
                       and f.ppsbop = v_scsbop
                       and f.pptope = v_sctope;
                  END;
                END IF;
                --OBTENER FECHA IMPAGA
                if flag_pago = 'S' then
                  BEGIN
                     select max(f.ppfval)
                        into VI_FEC_IMP
                        from fsd601 f
                       where f.pgcod  = v_pgcod
                         and f.ppmod  = v_scmod
                         and f.ppsuc  = v_scsuc
                         and f.ppmda  = v_scmda
                         and f.pppap  = v_scpap
                         and f.ppcta  = v_sccta
                         and f.ppoper = v_scoper
                         and f.ppsbop = v_scsbop
                         and f.pptope = v_sctope
                         and f.ppfpag = vi_fec_original;
                    END;
                 else
                     VI_FEC_IMP := vi_fec_original; 
                 end if;  
              --OBTENER FECHA DE HOY.
              BEGIN
                SELECT f.pgfape
                  INTO vi_fec_hoy
                  FROM fst017 f
                  WHERE f.pgcod = v_pgcod;
                END;
              --DIFERENCIA DIA
              SELECT vi_fec_hoy - VI_FEC_IMP
              INTO dias_transc
              FROM DUAL; 
              
       --TASA DEL PERIODO CREDITO VIGENTE
        vi_tsa_per := (power((1+(vi_tea/100)),(dias_transc/360)))-1;
       --CAPITAL 
       BEGIN
         SELECT d.scsdo
         INTO vi_capital
         FROM FSD011 D
         WHERE D.PGCOD  =  v_pgcod
            AND D.SCMOD =  v_scmod
            AND D.SCSUC =  v_scsuc
            AND D.SCMDA =  v_scmda
            AND D.SCPAP =  v_scpap
            AND D.SCCTA =  v_sccta
            AND D.SCOPER=  v_scoper
            AND D.SCSBOP=  v_scsbop
            AND D.SCTOPE=  v_sctope;
        EXCEPTION WHEN OTHERS THEN
          NULL;
         END;
  
       --CALCULO INTERES  CREDITO VIGENTE      
       vi_interes := vi_capital*vi_tsa_per;
       
       -------------------------------------------------
       -------------------------------------------------
       -------------------------------------------------
       pq_cr_funciones_cho.sp_Tipo_Repro(pn_emp => v_pgcod,
                                         pn_mod => v_scmod,
                                         pn_suc => v_scsuc,
                                         pn_mda => v_scmda,
                                         pn_pap => v_scpap,
                                         pn_cta => v_sccta,
                                         pn_ope => v_scoper,
                                         pn_sbo => v_scsbop,
                                         pn_top => v_sctope,
                                         pc_tip => vi_gob,
                                         pn_tas => vi_tea_r);
       --TASA DEL PERIODO DEL CREDITO VIGENTE.
       vi_tsa_per_r := (power((1+(vi_tea_r/100)),(dias_transc/360)))-1;
       --CALCULO INTERES  CREDITO REBAJADO
       vi_interes_r := vi_capital*vi_tsa_per_r;
       
       
       dif_int := vi_interes - vi_interes_r;
       dif_int := abs(dif_int);
       if dif_int is null then
         dif_int := 0;
         msg := 'No se realizo correctamente el calculo, revisar los datos usados en el calculo';
       end if;
       if dif_int = 0 then
         msg := 'Las tasas son iguales, revisar si hay cambio de tasa';
       end if;
       --log de datos utilizados para el calculo
       BEGIN
             update AQPA840 t
             set T.AQPA840DIAST   = dias_transc,
                 T.AQPA840CAPITAL = vi_capital,
                 T.AQPA840TASAN   = vi_tea_r,
                 T.AQPA840TASAPR  = vi_tsa_per,
                 T.AQPA840INTR    = vi_interes_r,
                 T.AQPA840TASAV   = vi_tea,
                 T.AQPA840TASAPV  = vi_tsa_per,
                 T.AQPA840INTV    = vi_interes,
                 T.aqpa840difint   = dif_int
             where T.AQPA840EMP   =  v_pgcod
               and T.AQPA840MOD =  v_scmod
               and T.AQPA840SUC   =  v_scsuc
               and T.AQPA840MDA   =  v_scmda
               and T.AQPA840PAP   =  v_scpap
               and T.AQPA840CTA   =  v_sccta
               and T.AQPA840OPE   =  v_scoper
               and T.AQPA840SBO  =  v_scsbop
               and T.AQPA840TOP   =  v_sctope
               and T.AQPA840FECR  =  vi_fec_hoy;
       END;    
       commit;
       
       --dif_int := 350;
    end;

PROCEDURE sp_grabartasa(v_instancia in number,
                        v_Pgcod  in number,
                        v_Scmod  in number,
                        v_Scsuc  in number,
                        v_Scmda  in number,
                        v_Scpap  in number,
                        v_Sccta  in number,
                        v_Scoper in number,
                        v_Scsbop in number,
                        v_Sctope in number,
                        --v_fecha  in number, 
                        vo_msg  out varchar) is
  vi_tea number(10,6);
  begin
    --LIMPIAR TASAS DE LA TRANSACCION 98-579
  /*  
    BEGIN
          UPDATE FSD012 D
            SET  D.D012CO= 'E'
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            AND  D.D012FC= (SELECT PGFAPE FROM FST017 WHERE PGCOD=1 AND ROWNUM=1)
            AND  D.D012MO= 98
            AND  D.D012TR= 579
            AND  D.EVTIPO= 3;            
      END;
*/    
     
    BEGIN
      --OBTENER LA TASA CREDITO VIGENTE
       pq_cr_reprog_gob.sp_cr_tasa(v_pgcod => v_pgcod,
                                v_scmod => v_scmod,
                                v_scsuc => v_scsuc,
                                v_scmda => v_scmda,
                                v_scpap => v_scpap,
                                v_sccta => v_sccta,
                                v_scoper => v_scoper,
                                v_scsbop => v_scsbop,
                                v_sctope => v_sctope,
                                pn_tasa => vi_tea);
    END;
    
    BEGIN
      UPDATE AQPB556 A
      SET A.AQPB556TSAA   = vi_tea
      WHERE A.AQPB556INST = v_instancia
        AND A.AQPB556EMP  = v_Pgcod  
        AND A.AQPB556MOD  = v_Scmod  
        AND A.AQPB556SUC  = v_Scsuc  
        AND A.AQPB556MDA  = v_Scmda  
        AND A.AQPB556PAP  = v_Scpap  
        AND A.AQPB556CTA  = v_Sccta  
        AND A.AQPB556OPER = v_Scoper 
        AND A.AQPB556SBOP = v_Scsbop 
        AND A.AQPB556TOP = v_Sctope 
        --AND AQPB556EST  = 'P'
        AND A.AQPB556EHAB = 'H'
        AND A.AQPB556COD = (SELECT MAX(T.AQPB556COD) FROM  AQPB556 T 
                                                        WHERE T.AQPB556INST = v_instancia
                                                          AND T.AQPB556EMP  = v_Pgcod  
                                                          AND T.AQPB556MOD  = v_Scmod  
                                                          AND T.AQPB556SUC  = v_Scsuc  
                                                          AND T.AQPB556MDA  = v_Scmda  
                                                          AND T.AQPB556PAP  = v_Scpap  
                                                          AND T.AQPB556CTA  = v_Sccta  
                                                          AND T.AQPB556OPER = v_Scoper 
                                                          AND T.AQPB556SBOP = v_Scsbop 
                                                          AND T.AQPB556TOP  = v_Sctope
                                                          AND T.AQPB556EHAB = 'H')
        AND ROWNUM=1;
      END;
  
  end sp_grabartasa;

PROCEDURE sp_grabar_transac(ve_instancia in number,
                            ve_codigo in number,
                            ve_emp    in number,
                            ve_itmod  in number,
                            ve_itsuc  in number,
                            ve_ttran  in number,
                            ve_itnrel in number,
                            ve_fvc    in date,
                            ve_fcont  in date
                           ) is
BEGIN                           
          --ACTUALIZA LA TRANSACCION DEL INTERES EN LA AQPB556
          begin
            UPDATE AQPB556
            SET AQPB556TEMP = ve_emp,
                AQPB556TSUC  = ve_itsuc,
                AQPB556TMOD  = ve_itmod,
                AQPB556TTRAN = ve_ttran,
                AQPB556TNREL = ve_itnrel,
                AQPB556TFVC  = ve_fvc,
                AQPB556TFCON = ve_fcont
            WHERE AQPB556COD  = ve_codigo
              AND AQPB556INST = ve_instancia 
              AND AQPB556EHAB = 'H';
              commit; -- eninah 05/09/2024
         exception
           when others then
            null;    
         end;
end; 


PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.06.27
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna TASA
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  LN_EVCORR NUMBER;  

  BEGIN

    BEGIN
          select MIN(D.EVCORR)-1
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            AND  D.D012FC= (SELECT PGFAPE FROM FST017 WHERE PGCOD=1 AND ROWNUM=1)
            AND  D.D012MO= 98
            AND  D.D012TR= 579
            AND  D.EVTIPO= 3;
    EXCEPTION WHEN OTHERS THEN
       BEGIN
        select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            and  D.evtipo = 3
            and  D.d012co = 'S';
       EXCEPTION WHEN OTHERS THEN
              LN_EVCORR := 0;                          
       END;
    END;

    IF LN_EVCORR IS NULL THEN -- 08.07.2021 NO RECONOCE EL EXCEPTION SE FORZA LA CONSULTA. PARA OBTENER EL CORRELATIVO.
       BEGIN
          select MAX(D.EVCORR)
            INTO LN_EVCORR
            FROM FSD012 D
          WHERE  D.PGCOD = v_pgcod
            AND  D.AOMOD = v_scmod
            AND  D.AOSUC = v_scsuc
            AND  D.AOMDA = v_scmda
            AND  D.AOPAP = v_scpap
            AND  D.AOCTA = v_sccta
            AND  D.AOOPER= v_scoper
            AND  D.AOSBOP= v_scsbop
            AND  D.AOTOPE= v_sctope
            and  D.evtipo = 3
            and  D.d012co = 'S';
        EXCEPTION WHEN OTHERS THEN
              LN_EVCORR := 0;                          
        END;
    END IF;
    
    begin
      select f1.evtasa
        into pn_tasa
        from fsd012 f1
       where f1.pgcod = v_Pgcod
         and f1.aomod = v_Scmod
         and f1.aosuc = v_Scsuc
         and f1.aomda = v_Scmda
         and f1.aopap = v_Scpap
         and f1.aocta = v_Sccta
         and f1.aooper = v_Scoper
         and f1.aosbop = v_Scsbop
         and f1.aotope = v_Sctope
         and f1.evtipo = 3
         and f1.d012co = 'S'
         and f1.evcorr in (select MAX(D.EVCORR)
                             FROM FSD012 D
                            WHERE D.PGCOD = v_pgcod
                              AND D.AOMOD = v_scmod
                              AND D.AOSUC = v_scsuc
                              AND D.AOMDA = v_scmda
                              AND D.AOPAP = v_scpap
                              AND D.AOCTA = v_sccta
                              AND D.AOOPER = v_scoper
                              AND D.AOSBOP = v_scsbop
                              AND D.AOTOPE = v_sctope
                              and D.evtipo = 3
                              and D.d012co = 'S'
                              and d.evcorr <= LN_EVCORR);
    exception
      when others then
        begin
          select f1.aotasa
            into pn_tasa
            from fsd010 f1
           where f1.pgcod = v_Pgcod
             and f1.aomod = v_Scmod
             and f1.aosuc = v_Scsuc
             and f1.aomda = v_Scmda
             and f1.aopap = v_Scpap
             and f1.aocta = v_Sccta
             and f1.aooper = v_Scoper
             and f1.aosbop = v_Scsbop
             and f1.aotope = v_Sctope;
        exception
          when others then
            pn_tasa := 0;
        end;
    end;
  
    if pn_tasa = 0 then
      begin
        select f1.aotasa
          into pn_tasa
          from fsd010 f1
         where f1.pgcod = v_Pgcod
           and f1.aomod = v_Scmod
           and f1.aosuc = v_Scsuc
           and f1.aomda = v_Scmda
           and f1.aopap = v_Scpap
           and f1.aocta = v_Sccta
           and f1.aooper = v_Scoper
           and f1.aosbop = v_Scsbop
           and f1.aotope = v_Sctope;
      exception
        when others then
          pn_tasa := 0;
      end;
    
    end if;
  
  end sp_cr_tasa;
  -------------------------------------------------------------------------
  PROCEDURE SP_OBTENER_MONTO(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           vo_saldo out number) is 
  BEGIN
      vo_saldo := 0;
      BEGIN --CONSULTAR TABLA 
        SELECT F.AQPA840DIFINT
        INTO vo_saldo
        FROM AQPA840 F
        WHERE F.AQPA840EMP = v_Pgcod
          AND F.AQPA840MOD = v_Scmod
          AND F.AQPA840SUC = v_Scsuc
          AND F.AQPA840MDA = v_Scmda
          AND F.AQPA840PAP = v_Scpap
          AND F.AQPA840CTA = v_Sccta
          AND F.AQPA840OPE = v_Scoper
          AND F.AQPA840SBO = v_Scsbop
          AND F.AQPA840TOP = v_sctope
          AND F.AQPA840EST = 'C' --CONTABILIZADO
          AND F.AQPA840TIP = 2;   --TIPO DE REPROGRAMACION GOBIERNO
        -- caja
       EXCEPTION
         WHEN OTHERS THEN
           vo_saldo:=0; 
        END;
  END;
end pq_cr_reprog_gob;
/

