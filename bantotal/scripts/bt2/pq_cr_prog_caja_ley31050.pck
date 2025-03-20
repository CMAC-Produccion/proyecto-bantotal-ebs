create or replace package PQ_CR_PROG_CAJA_LEY31050 is
  -- *****************************************************************
  -- Nombre                     : PROGRAMA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.08.05
  -- Autor de Creación          : EFUENTES
  -- Uso                        : OBTENER DATOS PROGRAMA CAJA
  -- Estado                     : Activo
  -- Acceso                     : Público
  --
  -- ****************************************************************

  ------------------------------------------------------------------
  procedure sp_cr_val_progra_caja(pn_pgcodc in number,
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number,
                                  pn_ctac   in number,
                                  pn_opec   in number,
                                  pn_sopec  in number,
                                  pn_topec  in number,
                                  pv_flag   out varchar2);

  ------------------------------------------------------------------
  procedure sp_cr_facilidad_progra_caja(pn_pgcodc    in number,
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number,
                                        pn_ctac      in number,
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_facilidad out varchar2);

  ------------------------------------------------------------------
  procedure sp_cr_mnt_desembolso(pn_pgcodc in number,
                                 pn_modc   in number,
                                 pn_succ   in number,
                                 pn_monc   in number,
                                 pn_papc   in number,
                                 pn_ctac   in number,
                                 pn_opec   in number,
                                 pn_topec  in number,
                                 pn_sopec  in number,
                                 pn_MonDes out number);

  ------------------------------------------------------------------
  procedure sp_cr_periodo(pn_pgcodc  in number,
                          pn_modc    in number,
                          pn_succ    in number,
                          pn_monc    in number,
                          pn_papc    in number,
                          pn_ctac    in number,
                          pn_opec    in number,
                          pn_sopec   in number,
                          pn_topec   in number,
                          pn_Frecuen out number);

  ------------------------------------------------------------------
  procedure sp_cr_estado_rep(pn_pgcodc in number,
                             pn_modc   in number,
                             pn_succ   in number,
                             pn_monc   in number,
                             pn_papc   in number,
                             pn_ctac   in number,
                             pn_opec   in number,
                             pn_sopec  in number,
                             pn_topec  in number,
                             pv_estado out varchar2,
                             pv_flgest   out varchar2);

  ------------------------------------------------------------------
  procedure sp_cr_fecha_rep(pn_pgcodc in number,
                            pn_modc   in number,
                            pn_succ   in number,
                            pn_monc   in number,
                            pn_papc   in number,
                            pn_ctac   in number,
                            pn_opec   in number,
                            pn_sopec  in number,
                            pn_topec  in number,
                            pn_FecRep out date);

  ------------------------------------------------------------------
  procedure sp_cr_fecha_rep_Caja(pn_pgcodc  in number, 
                                 pn_modc    in number,
                                 pn_succ    in number,
                                 pn_monc    in number,
                                 pn_papc    in number, 
                                 pn_ctac    in number, 
                                 pn_opec    in number,
                                 pn_sopec   in number,
                                 pn_topec   in number,
                                 pv_estado  in varchar2,
                                 pv_facili  in varchar2,
                                 pn_FecRep  out date);
                                 
  ------------------------------------------------------------------
  procedure sp_cr_max_dscto_progra_caja(pn_pgcodc    in number,
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number,
                                        pn_ctac      in number,
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_max_dscto out number);
                                        
/*  ------------------------------------------------------------------
  procedure sp_cr_max_dscto_progra_caja_AQPB561DCAR(pn_pgcodc    in number, 
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number, 
                                        pn_ctac      in number, 
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_max_dscto out number);*/
end PQ_CR_PROG_CAJA_LEY31050;
/

create or replace package body PQ_CR_PROG_CAJA_LEY31050 is
  procedure sp_cr_val_progra_caja(pn_pgcodc in number, 
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number, 
                                  pn_ctac   in number, 
                                  pn_opec   in number,
                                  pn_sopec  in number,
                                  pn_topec  in number,
                                  pv_flag   out varchar2)is

  ln_Contador NUMBER;
          
  BEGIN
    ln_Contador := 0;

    begin 
      SELECT COUNT(L.IDLEY31050)
        INTO ln_Contador
        FROM LEY31050 L --LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD IN ('BT', 'AP', 'CE')
         AND L.TIPOFACILIDAD = 'CAJA'
         AND F.facilidad in (select a.aqpb619des 
                               from fst198 f, aqpb619 a
                              where f.tp1cod1  = 10899
                                and f.tp1corr1 = 400000
                                and f.tp1corr2 = 600
                                and f.TP1NRO1  = 1
                                and f.tp1corr3 = a.aqpb619cor)
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_ctac
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_opec
         AND F.EMPRESA = pn_pgcodc
         AND F.SUCURSAL = pn_succ
         AND F.MODULO = pn_modc
         AND F.MONEDA = pn_monc
         AND F.PAPEL = pn_papc
         AND F.SUBOPERACION = pn_sopec
         AND F.TIPOOPERACION = pn_topec;
      /*SELECT COUNT(L.IDLEY31050) INTO ln_Contador
      FROM LEY31050 L --LEY31050 L
      INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
      WHERE L.ESTADOSOLICITUD IN( 'BT', 'AP', 'CE')
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.facilidad in
         ('Exoneracion de capitalizacion', 
          'Exoneración de capitalización',
          'Condonacion por cancelacion', 
          'Condonación por cancelación',
          'Reducción de tasa', 
          'Reduccion de tasa') -- REVISAR SI FACILIDAD ES;
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = pn_ctac
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = pn_opec
        AND F.EMPRESA = pn_pgcodc 
        AND F.SUCURSAL = pn_succ 
        AND F.MODULO =  pn_modc
        AND F.MONEDA = pn_monc
        AND F.PAPEL = pn_papc
        AND F.SUBOPERACION = pn_sopec
        AND F.TIPOOPERACION = pn_topec;*/
        
        IF ln_Contador > 0 THEN 
          pv_flag := 'SI';
        ELSE
          pv_flag := 'NO';
        END IF;
        
    EXCEPTION          
       when others then
         pv_flag := 'NO';
    end;
  END sp_cr_val_progra_caja;

------------------------------------------------------------------
  procedure sp_cr_facilidad_progra_caja(pn_pgcodc    in number, 
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number, 
                                        pn_ctac      in number, 
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_facilidad out varchar2)is
  BEGIN
    begin 
      SELECT F.FACILIDAD
        INTO pv_facilidad
        FROM LEY31050 L --LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD IN ('BT', 'AP', 'CE')
         AND L.TIPOFACILIDAD = 'CAJA'
         AND F.facilidad in (select a.aqpb619des 
                               from fst198 f, aqpb619 a
                              where f.tp1cod1  = 10899
                                and f.tp1corr1 = 400000
                                and f.tp1corr2 = 600
                                and f.TP1NRO1  = 1
                                and f.tp1corr3 = a.aqpb619cor)
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_ctac
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_opec
         AND F.EMPRESA = pn_pgcodc
         AND F.SUCURSAL = pn_succ
         AND F.MODULO = pn_modc
         AND F.MONEDA = pn_monc
         AND F.PAPEL = pn_papc
         AND F.SUBOPERACION = pn_sopec
         AND F.TIPOOPERACION = pn_topec;
      /*SELECT F.FACILIDAD
        INTO pv_facilidad
      FROM LEY31050 L --LEY31050 L
      INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
      WHERE L.ESTADOSOLICITUD IN( 'BT', 'AP', 'CE')
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.facilidad  in
         ('Exoneracion de capitalizacion', 'Exoneración de capitalización','Condonacion por cancelacion', 'Condonación por cancelación','Reducción de tasa', 'Reduccion de tasa') -- REVISAR SI FACILIDAD ES;
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = pn_ctac
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = pn_opec
        AND F.EMPRESA = pn_pgcodc 
        AND F.SUCURSAL = pn_succ
        AND F.MODULO =  pn_modc
        AND F.MONEDA = pn_monc
        AND F.PAPEL = pn_papc 
        AND F.SUBOPERACION = pn_sopec
        AND F.TIPOOPERACION = pn_topec;*/
        
    EXCEPTION          
       when others then
         pv_facilidad := '';
    end;
  END sp_cr_facilidad_progra_caja;
  
------------------------------------------------------------------
  procedure sp_cr_mnt_desembolso(pn_pgcodc    in number, 
                                 pn_modc      in number,
                                 pn_succ      in number,
                                 pn_monc      in number,
                                 pn_papc      in number, 
                                 pn_ctac      in number, 
                                 pn_opec      in number,
                                 pn_topec     in number,
                                 pn_sopec     in number,
                                 pn_MonDes    out number)is
  BEGIN
    begin 
      SELECT Aoimp
       INTO pn_MonDes
      FROM fsd010
      Where Pgcod  = pn_pgcodc
        AND Aomod  = pn_modc
        AND Aosuc  = pn_succ
        AND Aomda  = pn_monc
        AND Aopap  = pn_papc
        AND Aocta  = pn_ctac
        AND Aooper = pn_opec
        AND Aotope = pn_topec
        AND Aosbop = 0;
    EXCEPTION          
       when others then
         pn_MonDes := 0.00;
    end;
  END sp_cr_mnt_desembolso;
  
------------------------------------------------------------------
  procedure sp_cr_periodo(pn_pgcodc    in number, 
                          pn_modc      in number,
                          pn_succ      in number,
                          pn_monc      in number,
                          pn_papc      in number, 
                          pn_ctac      in number, 
                          pn_opec      in number,
                          pn_sopec     in number,
                          pn_topec     in number,
                          pn_Frecuen   out number) is
  BEGIN
    begin
      SELECT XllPeriodo
        INTO pn_Frecuen
        FROM x054023
       Where XllPgcod  = pn_pgcodc
         AND XllAomod  = pn_modc
         AND XllAosuc  = pn_succ
         AND XllAomda  = pn_monc
         AND XllAopap  = pn_papc
         AND XllAocta  = pn_ctac
         AND XllAooper = pn_opec
         AND XllAosbop = pn_sopec
         AND XllAotop  = pn_topec;
    EXCEPTION          
       when others then
         pn_Frecuen := 0;
    end;
  END sp_cr_periodo;
  
------------------------------------------------------------------
  procedure sp_cr_estado_rep(pn_pgcodc   in number, 
                             pn_modc     in number,
                             pn_succ     in number,
                             pn_monc     in number,
                             pn_papc     in number, 
                             pn_ctac     in number, 
                             pn_opec     in number,
                             pn_sopec    in number,
                             pn_topec    in number,
                             pv_estado   out varchar2,
                             pv_flgest   out varchar2) is
  BEGIN
    begin
      SELECT CASE WHEN L.ESTADOSOLICITUD = 'BT' THEN '' else 'Reprogra.' end case, 
      L.ESTADOSOLICITUD
        INTO pv_estado, pv_flgest
      FROM LEY31050 L --LEY31050 L
      INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
      WHERE L.ESTADOSOLICITUD IN( 'BT', 'AP', 'CE')
        AND L.TIPOFACILIDAD = 'CAJA'
         AND F.facilidad in (select a.aqpb619des 
                               from fst198 f, aqpb619 a
                              where f.tp1cod1  = 10899
                                and f.tp1corr1 = 400000
                                and f.tp1corr2 = 600
                                and f.TP1NRO1  = 1
                                and f.tp1corr3 = a.aqpb619cor)
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = pn_ctac
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = pn_opec
        AND F.EMPRESA = pn_pgcodc 
        AND F.MODULO =  pn_modc
        AND F.SUCURSAL = pn_succ 
        AND F.MONEDA = pn_monc
        AND F.PAPEL = pn_papc
        AND F.SUBOPERACION = pn_sopec
        AND F.TIPOOPERACION = pn_topec;
      /*SELECT CASE WHEN L.ESTADOSOLICITUD = 'AP' THEN 'Reprogra.' else '' end case
        INTO pv_estado
      FROM LEY31050 L --LEY31050 L
      INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
      WHERE L.ESTADOSOLICITUD IN( 'BT', 'AP')
        AND L.TIPOFACILIDAD = 'CAJA'
        AND F.facilidad  in 
         ('Exoneracion de capitalizacion', 'Exoneración de capitalización','Condonacion por cancelacion', 'Condonación por cancelación','Reducción de tasa', 'Reduccion de tasa') -- REVISAR SI FACILIDAD ES;
        AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = pn_ctac
        AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = pn_opec
        AND F.EMPRESA = pn_pgcodc 
        AND F.MODULO =  pn_modc
        AND F.SUCURSAL = pn_succ 
        AND F.MONEDA = pn_monc
        AND F.PAPEL = pn_papc
        AND F.SUBOPERACION = pn_sopec
        AND F.TIPOOPERACION = pn_topec;*/
    EXCEPTION          
       when others then
         pv_estado := '';
    end;
  END sp_cr_estado_rep;
  
------------------------------------------------------------------
  procedure sp_cr_fecha_rep(pn_pgcodc  in number, 
                            pn_modc    in number,
                            pn_succ    in number,
                            pn_monc    in number,
                            pn_papc    in number, 
                            pn_ctac    in number, 
                            pn_opec    in number,
                            pn_sopec   in number,
                            pn_topec   in number,
                            pn_FecRep  out date) is
  BEGIN
    begin
      select max(trunc(a.aqpb556fecr))
      into pn_FecRep
      from aqpb556 a 
      where a.aqpb556emp = pn_pgcodc
        AND a.aqpb556mod = pn_modc
        AND a.aqpb556suc = pn_succ
        AND a.aqpb556mda = pn_monc
        AND a.aqpb556pap = pn_papc
        AND a.aqpb556cta = pn_ctac
        AND a.aqpb556oper = pn_opec
        AND a.aqpb556sbop = pn_sopec
        AND a.aqpb556top = pn_topec
        --and a.aqpb556tprg = 1 
        and a.aqpb556est = 'A'
        and a.aqpb556ehab = 'H';
    EXCEPTION          
       when others then
         pn_FecRep := null;
    end;
  END sp_cr_fecha_rep;

------------------------------------------------------------------
  procedure sp_cr_fecha_rep_Caja(pn_pgcodc  in number, 
                                 pn_modc    in number,
                                 pn_succ    in number,
                                 pn_monc    in number,
                                 pn_papc    in number, 
                                 pn_ctac    in number, 
                                 pn_opec    in number,
                                 pn_sopec   in number,
                                 pn_topec   in number,
                                 pv_estado  in varchar2,
                                 pv_facili  in varchar2,
                                 pn_FecRep  out date) is
  ln_cont1 number(5);
  ln_cont2 number(5);
  BEGIN
    ln_cont1 := 0;
    ln_cont2 := 0;
    pn_FecRep := null;
    --SI ESTAN EN ESTADO AP Y CE
    IF pv_estado = 'AP' or pv_estado = 'CE' then
      
      --EXONERACION CAPITACION, AMORTIZACION ANTICIAPDA - > AQPB411
      -- > i PERDIO BENEFICIO - > P MANTIENE EL BENEFICIO **para futuras validaciones
      select count(*) into ln_cont1
      from fst198 f, aqpb619 a
      where f.tp1cod1 = 10899 and f.tp1corr1 = 400000 and f.tp1corr2 = 600 and f.TP1NRO1 = 1
      and f.tp1corr3 = a.aqpb619cor and a.aqpb619cor in (1, 3, 4, 5)
      and a.aqpb619des = pv_facili;
      
      --REDUCCION DE TASA O TASA JUN -> AQPA840
      --> C  **para futuras validaciones
      select count(*) into ln_cont2
      from fst198 f, aqpb619 a
      where f.tp1cod1 = 10899 and f.tp1corr1 = 400000 and f.tp1corr2 = 600 and f.TP1NRO1 = 1
      and f.tp1corr3 = a.aqpb619cor and a.aqpb619cor in (6, 7, 8, 9)
      and a.aqpb619des = pv_facili;
      
    
      IF ln_cont1 > 0 then
        begin
          SELECT MAX(A.AQPB411FECACT)
            into pn_FecRep
            FROM AQPB411 A
           WHERE A.AQPB411COD = pn_pgcodc
             AND A.AQPB411MOD = pn_modc
             AND A.AQPB411SUC = pn_succ
             AND A.AQPB411MDA = pn_monc
             AND A.AQPB411PAP = pn_papc
             AND A.AQPB411CTA = pn_ctac
             AND A.AQPB411OPE = pn_opec
             AND A.AQPB411SBO = pn_sopec
             AND A.AQPB411TPO = pn_topec;
             ---AND A.AQPB411EST IN ('I', 'P');
        EXCEPTION
          when others then
            pn_FecRep := null;
        end;
       end if;
       
       IF ln_cont2 > 0 then        
        begin          
          SELECT MAX(B.AQPA840FECR)
            into pn_FecRep
            FROM AQPA840 B
           WHERE B.AQPA840EMP = pn_pgcodc
             AND B.AQPA840MOD = pn_modc
             AND B.AQPA840SUC = pn_succ
             AND B.AQPA840MDA = pn_monc
             AND B.AQPA840PAP = pn_papc
             AND B.AQPA840CTA = pn_ctac
             AND B.AQPA840OPE = pn_opec
             AND B.AQPA840SBO = pn_sopec
             AND B.AQPA840TOP = pn_topec;
             --AND B.AQPA840EST = 'C';
          EXCEPTION 
            when others then 
              pn_FecRep := null; 
          end;
       end if;    
    end if;
  END sp_cr_fecha_rep_Caja;
  
------------------------------------------------------------------
  procedure sp_cr_max_dscto_progra_caja(pn_pgcodc    in number, 
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number, 
                                        pn_ctac      in number, 
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_max_dscto out number)is
  BEGIN
    
    begin
      SELECT CASE
               WHEN F.facilidad IN
                    (select a.aqpb619des
                       from fst198 f, aqpb619 a
                      where f.tp1cod1 = 10899
                        and f.tp1corr1 = 400000
                        and f.tp1corr2 = 600
                        and f.TP1NRO1 = 1
                        and f.tp1corr3 = a.aqpb619cor
                        and a.aqpb619cor in (1)) then
                F.DESCUENTOSOLICITADO
               else
                F.MONTOCAPITALIZACION
             end
        INTO pv_max_dscto
        FROM LEY31050 L --LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD IN ('BT', 'AP', 'CE')
         AND L.TIPOFACILIDAD = 'CAJA'
         AND F.facilidad in
             (select a.aqpb619des
                from fst198 f, aqpb619 a
               where f.tp1cod1 = 10899
                 and f.tp1corr1 = 400000
                 and f.tp1corr2 = 600
                 and f.TP1NRO1 = 1
                 and f.tp1corr3 = a.aqpb619cor)
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_ctac
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_opec
         AND F.EMPRESA = pn_pgcodc
         AND F.SUCURSAL = pn_succ
         AND F.MODULO = pn_modc
         AND F.MONEDA = pn_monc
         AND F.PAPEL = pn_papc
         AND F.SUBOPERACION = pn_sopec
         AND F.TIPOOPERACION = pn_topec;
    
    EXCEPTION
      when others then
        pv_max_dscto := 0.00;
    end;
  END sp_cr_max_dscto_progra_caja;
  
/*------------------------------------------------------------------
  procedure sp_cr_max_dscto_progra_caja_AQPB561DCAR(pn_pgcodc    in number, 
                                        pn_modc      in number,
                                        pn_succ      in number,
                                        pn_monc      in number,
                                        pn_papc      in number, 
                                        pn_ctac      in number, 
                                        pn_opec      in number,
                                        pn_sopec     in number,
                                        pn_topec     in number,
                                        pv_max_dscto out number)is
  ln_instancia number;
  err_num NUMBER;
  err_msg VARCHAR2(255);
  BEGIN
    
    begin 
      select f700.xwfprcins
        into ln_instancia
      from xwf700 f700
      where f700.xwfempresa = pn_pgcodc
        and f700.xwfsucursal = pn_succ
        and f700.xwfmodulo = pn_modc
        and f700.xwfmoneda = pn_monc
        and f700.xwfpapel = pn_papc
        and f700.xwfcuenta = pn_ctac
        and f700.xwfoperacion = pn_opec
        and f700.xwfsubope = pn_sopec 
        and f700.xwftipope = pn_topec
        and f700.xwfcar3 = '1';        
    EXCEPTION          
       when others then
         err_num := SQLCODE;
         err_msg := SQLERRM;
         DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
         DBMS_OUTPUT.put_line(err_msg);
         return;
    end;
    
    begin 
      SELECT B.AQPB561DCAR 
      into pv_max_dscto
      FROM AQPB561 B                                      
      WHERE B.AQPB561EMP = pn_pgcodc
        AND B.AQPB561MOD = pn_modc
        AND B.AQPB561SUC = pn_succ
        AND B.AQPB561MDA = pn_monc
        AND B.AQPB561PAP = pn_papc
        AND B.AQPB561CTA = pn_ctac
        AND B.AQPB561OPER= pn_opec
        AND B.AQPB561SBOP= pn_sopec
        AND B.AQPB561TOP = pn_topec
        AND B.AQPB561INST= ln_instancia
        AND B.AQPB561EST = 'A'
        AND B.AQPB561EHAB= 'H'
        AND B.AQPB561FECR=(SELECT MAX(AQPB561FECR)
                            FROM AQPB561 C
                           WHERE C.AQPB561EMP = pn_pgcodc
                             AND C.AQPB561MOD = pn_modc
                             AND C.AQPB561SUC = pn_succ
                             AND C.AQPB561MDA = pn_monc
                             AND C.AQPB561PAP = pn_papc
                             AND C.AQPB561CTA = pn_ctac
                             AND C.AQPB561OPER= pn_opec
                             AND C.AQPB561SBOP= pn_sopec
                             AND C.AQPB561TOP = pn_topec
                             AND C.AQPB561INST= ln_instancia
                             AND C.AQPB561EST = 'A'
                             AND C.AQPB561EHAB= 'H');
        
    EXCEPTION          
       when others then
         pv_max_dscto := 0.00;
    end;
  END sp_cr_max_dscto_progra_caja_AQPB561DCAR;*/
      
end PQ_CR_PROG_CAJA_LEY31050;
/

