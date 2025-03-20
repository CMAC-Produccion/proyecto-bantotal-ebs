create or replace package PQ_CR_REACTIVACION_LINEA is

  -- Author  : HSUAREZ
  -- Created : 15/11/2022 10:22:56
  -- Purpose : 
  PROCEDURE sp_validar_pago_cuotas(ve_Instance in number,
                                   ve_emp      in number,
                                   ve_suc      in number,
                                   ve_mod      in number,
                                   ve_mda      in number,
                                   ve_pap      in number,
                                   ve_cta      in number,
                                   ve_ope      in number,
                                   ve_sbo      in number,
                                   ve_top      in number,
                                   vo_rpta     out varchar,
                                   vo_ErrCod   out number,
                                   vo_ErrDsc   out varchar);

end PQ_CR_REACTIVACION_LINEA;
/

create or replace package body PQ_CR_REACTIVACION_LINEA is

  -- Author  : HSUAREZ
  -- Created : 15/11/2022 10:22:56
  -- Purpose : 

  PROCEDURE sp_validar_pago_cuotas(ve_Instance in number,
                                   ve_emp      in number,
                                   ve_suc      in number,
                                   ve_mod      in number,
                                   ve_mda      in number,
                                   ve_pap      in number,
                                   ve_cta      in number,
                                   ve_ope      in number,
                                   ve_sbo      in number,
                                   ve_top      in number,
                                   vo_rpta     out varchar,
                                   vo_ErrCod   out number,
                                   vo_ErrDsc   out varchar) IS
  
    VI_CTA      XWF700.XWFCUENTA%TYPE;
    VI_PEPAIS   FSR008.PEPAIS%TYPE;
    VI_PETDOC   FSR008.PETDOC%TYPE;
    VI_PENDOC   FSR008.PENDOC%TYPE;
    vi_existe   number(9);
    VI_PAGO_ULT NUMBER(9);
  
    CURSOR LISTA_CREDITOS(VI_CTA IN NUMBER) IS
      SELECT *
        FROM FSD010 D
       WHERE D.AOMOD in (select g.modulo from fst111 g where g.dscod = 50)
         and d.AOSTAT not in (99, 27)
         and aocta = vi_cta;
  
    CURSOR LISTA_CUENTAS(vi_pepais in number,
                         vi_petdoc in number,
                         VI_PENDOC in char) IS
      SELECT *
        FROM FSR008 F
       WHERE F.PEPAIS = vi_pepais
         AND F.PETDOC = vi_petdoc
         AND F.PENDOC = vi_pendoc
         and ttcod = 1
         and cttfir = 'T';
  
  BEGIN
  
    vo_rpta := 'N';
  
    BEGIN
      --CONETRAR CLAVE DEL DOCUMENTO DEL CLIENTE
      BEGIN
        SELECT XWFCUENTA
          INTO VI_CTA
          FROM XWF700
         WHERE XWFPRCINS = ve_Instance
           AND XWFCAR3 = '1'
           and ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT pepais, petdoc, pendoc
          into vi_pepais, vi_petdoc, vi_pendoc
          from fsr008 r
         where r.ctnro = VI_CTA
           and r.ttcod = 1
           and r.cttfir = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --ENCONTRAR CREDITOS VIGENTES
      FOR X IN LISTA_CUENTAS(vi_pepais, vi_petdoc, vi_pendoc) LOOP
        FOR Y IN LISTA_CREDITOS(x.ctnro) LOOP
          --VALIDAR SI ALGUNO FUE REPROGRAMADO
          --JAQA400 - REPROGRAMACION SIN CAPITALIZACION
          BEGIN
            SELECT count(*)
              INTO vi_existe
              FROM JAQA400 j
             WHERE j.JAQA400EMP = y.pgcod
               AND j.jaqa400mod = y.aomod
               and j.jaqa400suc = y.aosuc
               and j.jaqa400mda = y.aomda
               and j.jaqa400pap = y.aopap
               and j.JAQA400CTA = y.aocta
               AND j.JAQA400OPE = y.aooper
               AND j.JAQA400SBO = y.aosbop
               AND j.jaqa400top = y.aotope
               and j.jaqa400est = 'C';
          EXCEPTION
            WHEN OTHERS THEN
              vi_existe := 0;
          END;
        
          --FLUJO NORMAL
          if vi_existe = 0 then
          
            BEGIN
              SELECT count(*)
                INTO vi_existe
                FROM xwf700 j, SNG001 S
               WHERE j.xwfprcins = s.sng001inst
                 and s.sng001ori in (13, 14, 16) -- mpostigoc, verifica si el credito fue reprogramado 
                 AND j.XWFEMPRESA = y.pgcod
                 AND j.XWFMODULO = y.aomod
                 and j.XWFSUCURSAL = y.aosuc
                 and j.XWFMONEDA = y.aomda
                 and j.XWFPAPEL = y.aopap
                 and j.XWFCUENTA = y.aocta
                 AND j.XWFOPERACION = y.aooper
                 AND j.XWFSUBOPE = y.aosbop
                 AND j.XWFTIPOPE = y.aotope
                 and J.XWFCAR3 = '1';
            EXCEPTION
              WHEN OTHERS THEN
                vi_existe := 0;
            END;
          
          end if;
        
          --VALIDAR EN ODOS LOS CREDITOS SI SE PAGARON LAS ULTIMAS 3 CUOTAS A LA FECHA DE PROCESO.
          if vi_existe > 0 then
          
            BEGIN
              SELECT COUNT(*)
                INTO VI_PAGO_ULT
                FROM FSD602 D
               WHERE D.PGCOD = y.pgcod
                 AND D.PPMOD = y.aomod
                 AND D.PPSUC = y.aosuc
                 AND D.PPMDA = y.aomda
                 AND D.PPPAP = y.aopap
                 AND D.PPCTA = y.aocta
                 AND D.PPOPER = y.aooper
                 AND D.PPSBOP = y.aosbop
                 AND D.PPTOPE = y.aotope
                 AND D.PPFPAG > (SELECT ADD_MONTHS(PGFAPE, -3)
                                   FROM FST017
                                  WHERE PGCOD = 1); --cuotas mensuales
            
            EXCEPTION
              WHEN OTHERS THEN
                VI_PAGO_ULT := 0;
            END;
          end if;
        
        END LOOP;
      
      END LOOP;
      vo_rpta := 'N';
    
      IF VI_PAGO_ULT < 3 and vi_existe > 0 THEN
        vo_rpta := 'S';
      end if;
    
      if vi_existe = 0 then
        vo_rpta := 'N';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

end PQ_CR_REACTIVACION_LINEA;
/

