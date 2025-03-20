create or replace package PQ_CR_ALINEAMIENTO is

  -- Author  : HSUAREZ
  -- Created : 9/11/2022 15:48:43
  -- Purpose : 
  
  procedure SP_INS_ALIN_INTERNO( ve_pgcod  number,
                                 ve_itsuc  number,
                                 ve_itmod  number,
                                 ve_ittran number,
                                 ve_itnrel number,
                                 
                                 ve_sucor  number,
                                 ve_modul  number,
                                 ve_ctnro  number,
                                 ve_oper   number,
                                 ve_moneda number,
                                 ve_papel  number,
                                 ve_tipop  number,
                                 ve_subop  number,
                                 ve_ubuser varchar,
                                 ve_pgfape date,
                                 ve_hora   varchar,
                                 
                                 vo_coderr number,
                                 vo_msgerr varchar                                 
                               );
                               
                               
   procedure SP_CR_OBT_FVFIRST_MRA(ln_empresa number,
                                  ln_modulo number,
                                  ln_sucursal number,
                                  ln_moneda number,
                                  ln_papel number,
                                  ln_cuenta number,
                                  ln_operacion number,
                                  ln_suboperacion number,
                                  ln_tipope number,
                                  vo_fec_vcto out date);
   PROCEDURE SP_VALIDA_SALDO( ve_pgcod in number,
                               ve_itsuc in number,
                               ve_itmod in number,
                               ve_ittran in number,
                               ve_itnrel in number,
                               vo_rptaSaldo out varchar,
                               vo_Mensaje out varchar
                             );
   PROCEDURE SP_OBTENER_MENSAJE(ve_codigo in number,vo_mensaje out varchar);                          
                             
end PQ_CR_ALINEAMIENTO;
/

create or replace package body PQ_CR_ALINEAMIENTO is

  procedure SP_INS_ALIN_INTERNO( ve_pgcod  number,
                                 ve_itsuc  number,
                                 ve_itmod  number,
                                 ve_ittran number,
                                 ve_itnrel number,
                                 
                                 ve_sucor  number,
                                 ve_modul  number,
                                 ve_ctnro  number,
                                 ve_oper   number,
                                 ve_moneda number,
                                 ve_papel  number,
                                 ve_tipop  number,
                                 ve_subop  number,
                                 ve_ubuser varchar,
                                 ve_pgfape date,
                                 ve_hora   varchar,
                                 
                                 vo_coderr number,
                                 vo_msgerr varchar                                 
                               ) IS 
                               
  vi_instancia xwf700.xwfprcins%type;
  vi_capital xwf700.xwfmonto1%type;
  vi_pepais fsr008.pepais%type;
  vi_petdoc fsr008.petdoc%type;
  vi_pendoc fsr008.pendoc%type;
  vi_pendocv varchar(12);
  VI_MORA AQPB934.AQPB934MORA%type;
  VI_PENA AQPB934.AQPB934PENA%type;
  VI_ICV  AQPB934.AQPB934ICV%type;
  VI_TASA AQPB934.AQPB934TASA%type;
  
  BEGIN
      --LOG
      /*
      BEGIN
        INSERT INTO PRUEBA_LOG L(PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE,MSG, INSTANCIA) VALUES(
        ve_pgcod , 
        ve_modul ,
        ve_itsuc , 
        ve_moneda,
        ve_papel ,
        ve_ctnro ,
        ve_oper  ,
        ve_subop ,
        ve_tipop ,
        TO_CHAR(ve_itmod)||'-'||TO_CHAR(ve_ittran)||'-'||TO_CHAR(ve_itnrel)||'-'||TO_CHAR(ve_sucor),
        999999
        );
      EXCEPTION
        WHEN OTHERS THEN
          NULL;  
      END;
      */
      --OBTENER CAPITAL E INSTANCIA
      BEGIN
        SELECT XWFPRCINS,X.XWFMONTO1
        INTO vi_instancia,vi_capital
        FROM XWF700 X
        WHERE X.XWFEMPRESA   = ve_pgcod
          AND X.XWFSUCURSAL  = ve_sucor
          AND X.XWFMODULO    = ve_modul
          AND X.XWFMONEDA    = ve_moneda
          AND X.XWFPAPEL     = ve_papel
          AND X.XWFCUENTA    = ve_ctnro
          AND X.XWFOPERACION = ve_oper
          AND X.XWFSUBOPE    = ve_subop
          AND X.XWFTIPOPE    = ve_tipop
          AND XWFCAR3='1';
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      --OBTENER DOCUMENTO DEL CLIENTE
      BEGIN
           SELECT PEPAIS,PETDOC,PENDOC
           INTO vi_pepais,vi_petdoc,vi_pendoc
           FROM FSR008 F WHERE CTNRO = ve_ctnro and F.TTCOD=1 and F.CTTFIR='T';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      vi_pendocv := trim(vi_pendoc);
      --OBTENER TASA Y MORA
      BEGIN
          SELECT sum(A.AQPB934MORA) mora,sum(A.AQPB934PENA) pena,sum(A.AQPB934ICV) icv
          INTO VI_MORA,VI_PENA,VI_ICV
          FROM AQPB934 A
          WHERE aqpb934pais = vi_pepais 
            AND aqpb934tdoc = vi_petdoc
            AND aqpb934ndoc = vi_pendocv
            AND AQPB934EST='H'
            AND AQPB934VIN='V'
            AND AQPB934ACEP='G';   
      EXCEPTION
        WHEN OTHERS THEN
         ----PARA FLUJO EXPRESS TABLA DE BI
          BEGIN
            SELECT sum(NVL(A.AQPC701MOR,0)) mora,sum(NVL(A.AQPC701PEN,0)) pena,sum(NVL(A.AQPC701ICV,0)) icv
            INTO VI_MORA,VI_PENA,VI_ICV
            FROM AQPC701 A
            WHERE A.AQPC701PEPAIS = vi_pepais
              AND A.AQPC701TDOC   = vi_petdoc
              AND A.AQPC701NDOC   = vi_pendocv
              AND A.AQPC701EST    IN ('H','S');
          exception
              WHEN OTHERS THEN
                NULL;
          END;
      END;
     IF VI_MORA IS NULL OR NVL(VI_MORA,0) = 0 THEN     
        BEGIN
          SELECT sum(A.AQPC701MOR) mora,sum(A.AQPC701PEN) pena,sum(A.AQPC701ICV) icv
          INTO VI_MORA,VI_PENA,VI_ICV
          FROM AQPC701 A
          WHERE A.AQPC701PEPAIS = vi_pepais
            AND A.AQPC701TDOC   = vi_petdoc
            AND A.AQPC701NDOC   = vi_pendocv
            AND A.AQPC701EST    IN ('H','S');
        exception
            WHEN OTHERS THEN
              NULL;
        END;
      END IF;
      --
      BEGIN
          SELECT a.aqpb934tasp
            INTO VI_TASA
           FROM AQPB934 A
          WHERE aqpb934pais = vi_pepais 
            AND aqpb934tdoc = vi_petdoc
            AND aqpb934ndoc = vi_pendocv
            AND AQPB934EST='H'
            AND AQPB934VIN='V'
            AND AQPB934ACEP='G'
            AND ROWNUM = 1;   
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
       
      --INSERTAR REGISTRO
      BEGIN
        INSERT INTO AQPB999(
                            aqpb999emp,
                            aqpb999mod,
                            aqpb999suc,
                            aqpb999mda,
                            aqpb999pap,
                            aqpb999cta,
                            aqpb999ope,
                            aqpb999sbo,
                            aqpb999top,
                            
                            aqpb999fecr,
                            aqpb999tip,
                            
                            aqpb999ins,
                            aqpb999est,
                            aqpb999ehab,
                            aqpb999usrg,
                            
                            aqpb999itcod,
                            aqpb999itmod,
                            aqpb999itsuc,
                            aqpb999ittran,
                            aqpb999itnrel,
                            aqpb999itfcon,
                            aqpb999ithor,
                            
                            aqpb999capital,
                            aqpb999tasa,
                            aqpb999mora,
                            aqpb999pena,
                            aqpb999icv
                            )
                            VALUES(
                            ve_pgcod,
                            ve_modul,
                            ve_sucor,
                            ve_moneda,
                            ve_papel,
                            ve_ctnro, 
                            ve_oper,
                            ve_subop,
                            ve_tipop,
                            
                            ve_pgfape,
                            1, --TIPO DE DESEMBOLSO - 1 DESEMBOLSO DE ALINEAMIENTO INTERNO CAMPAÑA
                            
                            vi_instancia,
                            'C',
                            'H',
                            ve_ubuser,
                            
                            ve_pgcod,
                            ve_itmod,
                            ve_itsuc, 
                            ve_ittran,
                            ve_itnrel,
                            ve_pgfape,
                            ve_hora,
                            
                            vi_capital,
                            vi_tasa,
                            vi_mora,
                            vi_pena,
                            vi_icv
                            );
      EXCEPTION
          WHEN OTHERS THEN
            NULL;  
      END;
      
      
      
      
  END;
  procedure SP_CR_OBT_FVFIRST_MRA(ln_empresa number,
                                  ln_modulo number,
                                  ln_sucursal number,
                                  ln_moneda number,
                                  ln_papel number,
                                  ln_cuenta number,
                                  ln_operacion number,
                                  ln_suboperacion number,
                                  ln_tipope number,
                                  vo_fec_vcto out date) is

    ln_primer_cuota     fsd601.ppfpag%type;
    ln_primer_cuota_cap fsd601.ppfpag%type;
    ln_primer_cuot_pag fsd601.ppfpag%type;
    
  begin
    
    
    ln_primer_cuot_pag := to_date('01/01/2001','dd/mm/yyyy');
    --ln_suboperacion0 := ln_suboperacion -1;
    begin
      select max(f.ppfpag)
        into ln_primer_cuot_pag
        from fsd602 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_suboperacion
         and f.pptope = ln_tipope
         and f.d602co ='S' --contabilizada
         and f.pp1stat='T'; --totalmente pagada
    exception 
         when no_data_found then
           ln_primer_cuot_pag := to_date('01/01/2001','dd/mm/yyyy');
         when others then
           ln_primer_cuot_pag := to_date('01/01/2001','dd/mm/yyyy');
           
    end;
    if ln_primer_cuot_pag is null then
       ln_primer_cuot_pag := to_date('01/01/2001','dd/mm/yyyy');
    end if; 
    --CREDITO VIGENTE 
    --obtenerr la primera Cuota Impaga
    begin
      select min(ppfpag)
        into ln_primer_cuota
        from fsd601 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_suboperacion
         and pptope = ln_tipope
         and ppfpag > ln_primer_cuot_pag;
    exception
      when others then
        begin
         select min(ppfpag)
        into ln_primer_cuota
        from fsd601 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_suboperacion
         and pptope = ln_tipope;
        exception
          when others then
            null;
        end;    
    end;
    if ln_primer_cuota is null then
      begin
        select min(ppfpag)
        into ln_primer_cuota
        from fsd601 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_suboperacion
         and pptope = ln_tipope;
      exception 
        when others then
          null;
      end;   
    end if;  
    vo_fec_vcto := ln_primer_cuota;
end SP_CR_OBT_FVFIRST_MRA;
    PROCEDURE SP_VALIDA_SALDO( ve_pgcod in number,
                               ve_itsuc in number,
                               ve_itmod in number,
                               ve_ittran in number,
                               ve_itnrel in number,
                               vo_rptaSaldo out varchar,
                               vo_Mensaje out varchar
                             )
    IS
    vi_cuenta fsd016.ctnro%type;
    vi_oper fsd016.itoper%type;
    vi_mora fsd011.scsdo%type;
    vi_icv fsd011.scsdo%type;
    BEGIN
         BEGIN
              --CUENTA OPERACION Y RUBRO PGCOD.
              BEGIN
                SELECT d.ctnro, d.itoper
                  INTO vi_cuenta,vi_oper     
                  FROM FSD016 D
                 WHERE D.PGCOD = ve_pgcod
                   AND D.ITSUC = ve_itsuc
                   AND D.ITMOD = ve_itmod
                   AND D.ITTRAN = ve_ittran
                   AND D.ITNREL = ve_itnrel
                   AND D.ITORD = 10;
              EXCEPTION
                WHEN OTHERS THEN
                  vi_cuenta :=0;
                  vi_oper   :=0;     
              END;     
              --RUBRO Y SALDO DE LA FSD011 VALIDAR
              vo_Mensaje:='';
              vi_mora:=0;
              vi_icv:=0;
              --RUBRO SALDO MORA
              BEGIN
                SELECT F.SCSDO
                INTO vi_mora
                FROM FSD011 F
                WHERE F.PGCOD  = ve_pgcod 
                  AND F.SCCTA  = vi_cuenta
                  AND F.SCOPER = vi_oper
                  AND F.SCRUB  = '9500092000000'; --PONERLO EN GUIA
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;  
              END;
              --RUBRO SALDO ICV
              BEGIN
                SELECT F.SCSDO
                INTO vi_icv
                FROM FSD011 F
                WHERE F.PGCOD  = ve_pgcod 
                  AND F.SCCTA  = vi_cuenta
                  AND F.SCOPER = vi_oper
                  AND F.SCRUB  = '9500094000000'; --PONERLO EN GUIA
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;  
              END;
              
              --VALIDAR SI HAY SALDO
              IF vi_mora <> 0 or vi_icv <> 0 THEN
                 vo_rptaSaldo := 'S';
                 begin
                   PQ_CR_ALINEAMIENTO.SP_OBTENER_MENSAJE(1,vo_Mensaje);                
                 end;
              ELSE
                 vo_rptaSaldo := 'N';  
              END IF;
         EXCEPTION
           WHEN OTHERS THEN
             NULL;  
         END;
    END;
    PROCEDURE SP_OBTENER_MENSAJE(ve_codigo in number,vo_mensaje out varchar)
    IS 
    CURSOR LISTA IS
    SELECT *
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11165
       AND TP1CORR1 = 11
       AND TP1CORR2 = 1
       AND TP1CORR3 > 0;
    BEGIN
         BEGIN
            vo_mensaje := ''; 
           FOR X IN LISTA LOOP
             vo_mensaje := vo_mensaje || TRIM(X.TP1DESC)||' ';
           END LOOP;
          
         EXCEPTION
           WHEN OTHERS THEN
             VO_MENSAJE:= 'Falta pagar la MORA E ICV de los creditos cancelados de la ampliacion';
         END;
    END;
end PQ_CR_ALINEAMIENTO;
/

