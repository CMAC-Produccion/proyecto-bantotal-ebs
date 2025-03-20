create or replace package pq_rep_vent_cartera is

 /* ************************************************************************************************************
  -- Author  : IGS_RCASTRO
  -- Created : 20/06/2022 10:12:28
  -- Purpose : Proceso para venta de cartera 
  
  --Fecha Modificación : 28/09/2022
  --Usuario Modificación: Rcastro
  --Descripción: Adición en eliminación de usuario y nro. propuesta de la AQPC177.
  * *************************************************************************************************************/
    
   procedure sp_obte_calificacion( 
                               empresa in numeric,
                               cuenta in numeric,           
                               operacion in numeric,
                               moneda in numeric,  
                               modulo in numeric,
                               sucursal in numeric,
                               suboperacion in numeric,
                               tipooperacion in numeric,  
                               papel in numeric,
                               calificacion out varchar2,
                               diasatraso out number,
                               analista out varchar2,
                               abogado out varchar2
                             );
   procedure sp_obte_dat_jaqy711(empresa in numeric,
                                 cuenta in numeric,
                                 operacion in numeric,
                                 moneda in numeric, 
                                 modulo in numeric,
                                 sucursal in numeric,
                                 suboperacion in numeric,
                                 tipooperacion in numeric,  
                                 papel in numeric,
                                 fechaUltPago out varchar2);
                                 
   procedure validarModulo(xmodulo in numeric,
                          flagEsValido out varchar2);
                          
   procedure sp_obtener_provision(   pd_FecUltCierre in date,
                                     pn_saldo in number, 
                                     pn_cod  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     ln_Provision out number) ;   
                                            
   procedure sp_obtener_fecha_demanda( 
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     fechademanda out varchar2) ;
   procedure sp_delete_aqpc175(pn_modo in varchar2);                                     
   procedure sp_insert_aqpc175(pn_modo in varchar2,
                               pn_empresa in number, 
                               pn_mod in number,
                               pn_suc in number,
                               pn_moned in number,                   
                               pn_papel in number,
                               pn_cuenta in number,
                               pn_operacion in number,
                               pn_suboper in number,
                               pn_tipooper in number,
                               pn_dni in varchar2,
                               pn_titrep in varchar2,
                               pn_titu  in varchar2,
                               pn_aval in varchar2,
                               pn_scmo in number,
                               pn_montodeuda in number,
                               pn_scnm in number,
                               pn_dtmn in number,
                               pn_provision in number,
                               pn_calif in varchar,
                               pn_diasmora in number,
                               pn_estdcontable in varchar2,
                               pn_estcredito in varchar2,
                               pn_analista in varchar2,
                               pn_abogdo in varchar2,
                               pn_fechdemanda in date,
                               pn_nroprop in number,
                               pn_nrogrupo in number,
                               pn_tienegaran in varchar2,
                               pn_garantias in varchar2,
                               pn_tipofondo in varchar2,
                               pn_eshonrado in varchar2,
                               pn_fechaHoy in date,
                               pn_fechaultmpag in date);  
    PROCEDURE sp_actualizar_fst198 (nroprop in number, usuario in varchar2); -- rcastro 29/09/2022
    -----------subrutines
    PROCEDURE sp_titularepr(p_cuenta number, titutep out varchar2, titulsecun out varchar2, nrodoctitu out varchar2) ;
    procedure sp_avales(p_pgcod number,
                      p_mod number,
                      p_suc number,
                      p_mon number,
                      p_pap  number,
                      p_cuent number,
                      p_operc number,
                      p_sbop number,
                      p_tipoop number,
                      flgaval out varchar2);   
    PROCEDURE garantiasinscrreales(
                      p_pgcod number,
                      p_mod number,
                      p_suc number,
                      p_mon number,
                      p_pap  number,
                      p_cuent number,
                      p_operc number,
                      p_sbop number,
                      p_tipoop number,
                      flgagarntreales out varchar2,
                      listagarant out varchar2); 

    -----------provisión
    function fn_provision(  pd_FecUltCierre date,
                            pn_saldo number, 
                             pn_cod  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_ope  in number,
                             pn_sbo  in number,
                             pn_top  in number) return number ;    

    ------------------------------------------------------
    PROCEDURE SP_CR_REPLOGS(p_pgm IN varchar2,
                               p_usr IN varchar2,
                               p_fec IN date,
                               p_hri IN varchar2,
                               p_hrf IN varchar2);
    ------------------------------------------------------                                                                                                                                                                                                                                                                                                                           
end pq_rep_vent_cartera;
/

create or replace package body pq_rep_vent_cartera is
    procedure sp_obte_calificacion( 
                               empresa in numeric,
                               cuenta in numeric,           
                               operacion in numeric,
                               moneda in numeric,  
                               modulo in numeric,
                               sucursal in numeric,
                               suboperacion in numeric,
                               tipooperacion in numeric,  
                               papel in numeric,
                               calificacion out varchar2,
                               diasatraso out number,
                               analista out varchar2,
                               abogado out varchar2
                             )  as                                                            
     begin   
       BEGIN                                    
           select JAQL964DCALF, JAQL964DIA, JAQL964USU, JAQL964ABO INTO calificacion,diasatraso, analista, abogado from jaqL964
           where JAQL964PGCOD = empresa AND
           JAQL964CTA = cuenta AND
           JAQL964OPE = operacion AND
           JAQL964MOD = modulo AND 
           JAQL964MDA = moneda AND
           JAQL964SOB = suboperacion AND 
           JAQL964TOP = tipooperacion AND
           JAQL964SUC = sucursal AND
           JAQL964PAP = papel ;  
      EXCEPTION
      WHEN no_data_found THEN                    
           calificacion := '';
           diasatraso  := 0;
           analista    := '';
           abogado     := '';           
      END;           
                             
     end sp_obte_calificacion;
    
    ----
    PROCEDURE sp_obte_dat_jaqy711(empresa in numeric,
                                 cuenta in numeric,
                                 operacion in numeric,
                                 moneda in numeric, 
                                 modulo in numeric,
                                 sucursal in numeric,
                                 suboperacion in numeric,
                                 tipooperacion in numeric,  
                                 papel in numeric,
                                 fechaUltPago out varchar2) IS
    BEGIN
      BEGIN
         select MAX(JAQY711FPRO) INTO fechaUltPago from jaqy711 WHERE JAQY711COD = empresa AND JAQY711MOD = modulo AND JAQY711SUC = sucursal
                                      AND JAQY711MDA = moneda AND JAQY711PAP = papel AND JAQY711CTA = cuenta AND JAQY711OPE = operacion AND
                                      JAQY711SBO = suboperacion AND JAQY711TOP = tipooperacion;
      EXCEPTION
        WHEN no_data_found THEN
          fechaUltPago := '';
          END;
    END sp_obte_dat_jaqy711;
    
   PROCEDURE validarModulo(xmodulo in numeric,
                          flagEsValido out varchar2) IS
   auxMod number;                          
   BEGIN       
       BEGIN
       select modulo INTO auxMod from fst111 where dscod=50 and modulo = xmodulo;
       IF auxMod IS NOT NULL THEN
          flagEsValido := 'S'; 
       ELSE
            flagEsValido := 'N';
       END IF;         
       EXCEPTION 
          WHEN NO_DATA_FOUND THEN
               flagEsValido := 'N';
            END;
   END validarModulo ;
  
  PROCEDURE sp_obtener_provision(pd_FecUltCierre in date,
                              pn_saldo in number, 
                               pn_cod  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                         ln_Provision out number) IS                         
   
  begin
    ln_Provision :=0;
        ln_Provision := pq_cr_ventacarteras.fn_provision(--pq_rep_vent_cartera.fn_provision(-- RCASTRO 29/09/2022
                                              pd_FecUltCierre,
                                              pn_saldo,
                                              pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);        
       
  END sp_obtener_provision; 
   
  procedure sp_obtener_fecha_demanda( 
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 fechademanda out varchar2) IS
  auxjaqm33cor number;                           
  BEGIN
    
     BEGIN                                                                 
            select max(JAQM33COR) into auxjaqm33cor from jaqm27 where jaqm27cta = pn_cta and jaqm27oper = pn_ope and JAQM27MOD = pn_mod 
            and JAQM27SUC = pn_suc and JAQM27MDA = pn_mda and JAQM27PAP = pn_pap and JAQM27SBOP = pn_sbo and JAQM27TOPE = pn_top ;

            select jaqm33fint into fechademanda from jaqm33 where jaqm33cor = auxjaqm33cor;
     EXCEPTION
      WHEN no_data_found THEN                    
        fechademanda := '';       
     END;    
  
  END sp_obtener_fecha_demanda;
  
  procedure sp_delete_aqpc175(pn_modo in varchar2)is
  BEGIN
      IF pn_modo = 'DLT' THEN
         BEGIN
              Execute immediate ('truncate table AQPC175');     
              COMMIT;    
            EXCEPTION
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Nose pudo Truncar AQPC175 ');
         END;     
      END IF;
  END sp_delete_aqpc175;  
  
  procedure sp_insert_aqpc175( pn_modo in varchar2,
                               pn_empresa in number, 
                               pn_mod in number,
                               pn_suc in number,
                               pn_moned in number,                   
                               pn_papel in number,
                               pn_cuenta in number,
                               pn_operacion in number,
                               pn_suboper in number,
                               pn_tipooper in number,
                               pn_dni in varchar2,
                               pn_titrep in varchar2,
                               pn_titu  in varchar2,
                               pn_aval in varchar2,
                               pn_scmo in number,
                               pn_montodeuda in number,
                               pn_scnm in number,
                               pn_dtmn in number,
                               pn_provision in number,
                               pn_calif in varchar,
                               pn_diasmora in number,
                               pn_estdcontable in varchar2,
                               pn_estcredito in varchar2,
                               pn_analista in varchar2,
                               pn_abogdo in varchar2,
                               pn_fechdemanda in date,
                               pn_nroprop in number,
                               pn_nrogrupo in number,
                               pn_tienegaran in varchar2,
                               pn_garantias in varchar2,
                               pn_tipofondo in varchar2,
                               pn_eshonrado in varchar2,
                               pn_fechaHoy in date,
                               pn_fechaultmpag in date) IS
   BEGIN
       IF pn_modo = 'INS' THEN
         INSERT INTO AQPC175(AQPC175EMP, AQPC175MOD, AQPC175SUC, AQPC175MDA, AQPC175PAP, AQPC175CTA, AQPC175OPE, AQPC175SBP, AQPC175TOP, AQPC175DNI, AQPC175TREP, AQPC175TITU, AQPC175AVAL, AQPC175SCMO, AQPC175DTMO, AQPC175SCMN, AQPC175DTMN, AQPC175PPRO, AQPC175CAL, AQPC175DMOR, AQPC175ECON, AQPC175ECRE, AQPC175ANL, AQPC175ABO, AQPC175FDEM, AQPC175NPRO, AQPC175NGRU, AQPC175TGAR, AQPC175GINS, AQPC175TFON, AQPC175HON, AQPC175FEM, AQPC175FULT) VALUES(pn_empresa, pn_mod, pn_suc, pn_moned, pn_papel, pn_cuenta, pn_operacion, pn_suboper, pn_tipooper, pn_dni,
         pn_titrep, pn_titu, pn_aval, pn_scmo, pn_montodeuda, pn_scnm, pn_dtmn, pn_provision, pn_calif, pn_diasmora, pn_estdcontable,
         pn_estcredito, pn_analista, pn_abogdo, pn_fechdemanda, pn_nroprop, pn_nrogrupo, pn_tienegaran, pn_garantias, pn_tipofondo, pn_eshonrado,
         pn_fechaHoy, pn_fechaultmpag);
         COMMIT;      
       END IF;
   END sp_insert_aqpc175;
   
  -- //theards
  PROCEDURE sp_actualizar_fst198 (nroprop in number, usuario in varchar2) is
    NROGRUP NUMBER(10);
    BEGIN
            --1 limpiar aqpqc177
            /*BEGIN 
              SELECT MAX(JAQY952GRU) INTO NROGRUP FROM jaqy952 A WHERE A.JAQY952NRO = nroprop;  --RCASTRO 28/09/2022
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NROGRUP := 0;
            END;*/ 
            
            
            BEGIN
              --RCASTRO 29/09/2022
              DELETE FROM AQPC177 A WHERE UPPER(A.AQPC177USUEJEC) = UPPER(TRIM(usuario)) AND A.AQPC177NROPROP = nroprop;-- AND A.AQPC177NROGRP = NROGRUP; RCASTRO 28/09/2022
              --Execute immediate ('truncate table AQPC177');     
              COMMIT;    
            EXCEPTION
            WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('Nose pudo Truncar AQPC177 ');
            END;    
            
            UPDATE FST198 a 
            SET TP1NRO1 = nroprop
            WHERE  a.tp1cod1 = 11152 and a.tp1cod = 1 and a.tp1corr1= 6 and a.tp1corr2 = 2 and a.tp1corr3 = 1;
            commit;
      END sp_actualizar_fst198;
   ------------------subrutines
   PROCEDURE sp_titularepr(p_cuenta number, titutep out varchar2, titulsecun out varchar2, nrodoctitu out varchar2) as
   CURSOR titulrepr is
   select * from fsr008 a where a.ctnro = p_cuenta ;--and a.cttfir = 'T'; 
   x number:=0;
   W NUMBER := 0;   
   v_penom varchar2(50);        
   BEGIN
      --titular
      x := 0;
      W:= 0;
      FOR Y IN titulrepr LOOP
           IF y.cttfir = 'T' THEN
             x := x + 1;    
           END IF;
           
           if y.cttfir <> 'T' or  y.cttfir is null THEN
              W :=  W +1;
           END IF;
      
          BEGIN
            SELECT B.PENOM INTO v_penom FROM  fsd001 b where
            B.pepais =  Y.PEPAIS and
            B.petdoc =  Y.PETDOC and
            B.pendoc =   Y.PENDOC;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN
              v_penom := '';
          END;
          IF y.cttfir = 'T' THEN
             nrodoctitu := trim(y.pendoc);
          END IF;
          
          if x = 1 then
              if y.cttfir = 'T' THEN
                 titutep := trim(v_penom);
              END IF;
          ELSE
                if y.cttfir = 'T' THEN 
                    titutep := titutep || '-' || trim(v_penom);
                END IF;
          END IF;      
            
          if W = 1 then
              if y.cttfir  <> 'T' OR y.cttfir is null  THEN 
                titulsecun :=  trim(v_penom);
              END IF;
          else           
              if (y.cttfir <> 'T' OR y.cttfir is null) THEN             
                 titulsecun := titulsecun || '-' || trim(v_penom);
              end if;
          end if;
          
          
          
      END LOOP;                   
   END sp_titularepr;
   
   --avales
    procedure sp_avales(p_pgcod number,
                      p_mod number,
                      p_suc number,
                      p_mon number,
                      p_pap  number,
                      p_cuent number,
                      p_operc number,
                      p_sbop number,
                      p_tipoop number,
                      flgaval out varchar2) as
     begin
          BEGIN
          SELECT 'SI' INTO flgaval FROM XWF700 C INNER JOIN SNG003 B ON
          C.XWFEMPRESA = B.SNG003PGC AND
          C.XWFPRCINS  = B.SNG001INST 
          WHERE C.XWFEMPRESA = p_pgcod AND 
          C.XWFMODULO = p_mod AND 
          C.XWFSUCURSAL = p_suc AND
          C.XWFMONEDA  = p_mon AND
          C.XWFPAPEL   = p_pap AND
          C.XWFCUENTA  = p_cuent AND
          C.XWFOPERACION =  p_operc AND
          C.XWFSUBOPE   = p_sbop AND
          C.XWFTIPOPE  =  p_tipoop AND
          C.XWFCAR3  = '1' AND ROWNUM = 1;
       EXCEPTION
        when no_data_found then
          flgaval := 'NO';                
        END;
       
       IF p_mod = 200 OR p_tipoop = 550 THEN
          BEGIN
            SELECT 'SI' INTO flgaval FROM Fsr011 A INNER JOIN XWF700 B ON
            A.R1cod = B.XWfEmpresa AND
            A.R1mod = B.XWFMODULO  AND
            A.R1suc = B.XWFSUCURSAL AND
            A.R1mda = B.XWFMONEDA AND
            A.R1pap = B.XWFPAPEL AND
            A.R1cta =  B.XWFCUENTA AND
            A.R1oper = B.XWFOPERACION AND          
            A.R1sbop = B.XWFSUBOPE AND
            A.R1tope = B.XWFTIPOPE    
            INNER JOIN SNG003 C ON 
            B.XWFEMPRESA = C.SNG003PGC AND
            B.XWFPRCINS = C.SNG001INST                 
            WHERE B.XWFCar3 = '1' AND
            A.R2cod =   p_pgcod AND
            A.R2mod =  p_mod AND
            A.R2suc =   p_suc AND
            A.R2mda =   p_mon  AND
            A.R2pap =  p_pap  AND
            A.R2cta =   p_cuent  AND
            A.R2oper =  p_operc AND
            A.R2sbop =  p_sbop  AND
            A.R2tope =  p_tipoop AND                  
            A.Relcod = 52 AND 
            ROWNUM = 1;
          EXCEPTION
          when no_data_found then
               flgaval := 'NO';                                             
          END;
          
       END IF;
     end sp_avales;  
     
     --garatias reales
      PROCEDURE garantiasinscrreales(
                      p_pgcod number,
                      p_mod number,
                      p_suc number,
                      p_mon number,
                      p_pap  number,
                      p_cuent number,
                      p_operc number,
                      p_sbop number,
                      p_tipoop number,
                      flgagarntreales out varchar2,
                      listagarant out varchar2)  as
    cursor garantrealesfsr011 is
     select 'SI' as tienegaran, b.tp1nro2 ||  ' - ' || trim(b.tp1desc) as garantiasreales  from Fsr011 a inner join fst198 b on
          a.R2mod = b.Tp1nro1 and
          a.r2tope = b.Tp1nro2                  
          where
          a.R1cod = p_pgcod and 
          a.R1mod = p_mod and 
          a.R1suc = p_suc and 
          a.R1mda = p_mon and 
          a.R1pap = p_pap and 
          a.R1cta = p_cuent and 
          a.R1oper = p_operc and 
          a.R1sbop = p_sbop and 
          a.R1tope = p_tipoop and 
          a.Relcod = 50  and
          
          b.tp1cod = 1 and
          b.tp1cod1 =  10897 and
          b.Tp1corr1= 500 and
          b.Tp1corr2= 1;                      
     CURSOR garantrealesII is
     select 'SI' as tienegaran,  b.tp1nro2 ||  ' - ' || trim(b.tp1desc) as garantiasreales from xwf700 j inner join SNG122 k
     on j.xwfprcins = k.sng122inst inner join fst198 b
     on k.sng122mod = b.tp1nro1 and k.sng122tope = b.tp1nro2        
     where     
      j.XWfEmpresa   = p_pgcod and 
      j.XWfSucursal  = p_suc and
      j.XWfModulo    = p_mod and
      j.XWfMoneda    = p_mon and 
      j.XWfPapel     = p_pap and 
      j.XWfCuenta    = p_cuent and 
      j.XWfOperacion = p_operc and 
      j.XWfSubope    = p_sbop and
      j.XWfTipOpe    = p_tipoop and
      j.XWFCar3 = '1' and
      
      b.tp1cod = 1 and
      b.tp1cod1 =  10897 and
      b.Tp1corr1= 500 and
      b.Tp1corr2= 1;  
                           
          
    --flgtienegarnreal varchar2(2);
    --listagarant  varchar(500);
    y number:= 0;
    w number:= 0;
    flgrepetido char(1):= 'N';    
    begin
       y := 0;
       w := 0;
       flgagarntreales := 'NO';
       for x in garantrealesfsr011  loop 
          flgrepetido := 'N'; 
          flgagarntreales := x.tienegaran;
          begin
            select 'S' into flgrepetido from dual where listagarant like '%' || trim(x.garantiasreales) || '%' ;
          exception 
            when no_data_found then
              flgrepetido := 'N';
          end;
          
          If flgrepetido = 'N' then
                y := y + 1 ;
                if y = 1 then
                   listagarant :=  x.garantiasreales;
                else
                   listagarant := listagarant || ', ' || x.garantiasreales; 
                end if; 
          end if;
        end loop;       
        
        for j in garantrealesII  loop 
          flgrepetido := 'N'; 
          flgagarntreales := j.tienegaran;
          
          begin
            select 'S' into flgrepetido from dual where listagarant like '%' || trim(j.garantiasreales) || '%' ;
          exception 
            when no_data_found then
              flgrepetido := 'N';
          end;
          
          
          If flgrepetido = 'N' then
              w := w + 1 ;
              if w = 1 and (listagarant is null or listagarant = '') then
                 listagarant :=  trim(j.garantiasreales);
              else
                 listagarant := listagarant || ', ' || trim(j.garantiasreales); 
              end if; 
          end if;
        end loop;                           

    end garantiasinscrreales;  
   
   -- provision
   function fn_provision(  pd_FecUltCierre date,
                        pn_saldo number, 
                         pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number) return number is
   ln_provision number;
   ln_ProvConstituida number;
   ln_PProvision number;   
  begin
       ln_provision:=0;
        begin
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_provision ---BCEMP, BCFECH, BCRUBR, BCCTA
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro from fsd014 where pcnivc in (404)) 
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda;
            -- and bcmod  = 404; 
        exception
          when no_data_found then
            ln_provision :=0;
        end;
        begin
        ln_ProvConstituida :=0;
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_ProvConstituida 
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in(419))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda; 
             --and bcmod  = 419; 
        exception
          when no_data_found then
            ln_ProvConstituida :=0;
        end;
        if ( ln_provision is null ) then
           ln_provision :=0;
        end if;
        if ( ln_ProvConstituida is null ) then
           ln_ProvConstituida :=0;
        end if;
        if ((pn_saldo-ln_ProvConstituida)>0) then 
         ln_PProvision := round(( ln_provision / (pn_saldo-ln_ProvConstituida) ) * 100 ,2);                      
        else
          ln_PProvision :=0;
        end if;
    return ln_PProvision;
end fn_provision;   
   
  -------------------------------------------------------------
  PROCEDURE SP_CR_REPLOGS(p_pgm IN varchar2,p_usr IN varchar2,p_fec IN date,p_hri IN varchar2,p_hrf IN varchar2)
  IS                                                                                                                                                                                                                                                                                
  BEGIN
    BEGIN
        PQ_CR_JAQL975_LogReporte.fn_cr_inserta(p_pgm,p_usr,p_fec,p_hri,p_hrf);
    END; 
  END SP_CR_REPLOGS;
  -------------------------------------------------------------  

end pq_rep_vent_cartera;
/

