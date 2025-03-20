create or replace package pq_cred_rep_reprog_seguros is

  -- Author  : IGS_RCASTRO
  -- Created : 15/08/2022 23:24:54
  -- Purpose : Reporte de reprogramaciones Seguro vida caja y desgravamen
  
  procedure obtenerformatocorreo(paisx number, tipodoc number, nrodoc varchar, correo out varchar);
  procedure formatonrocta(cuenta number,operacion number, suboper number, nrocuenta out varchar2);
  
  ---
  procedure obtenertasaneta(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                             xsbop number, xtope number, tasa_neta out number);

  procedure obtenerPlan(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                        xsbop number, xtope number, lc_plan out varchar);
                        
  procedure obtenerPrimaTotal(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                              xsbop number, xtope number, ln_monto_tot out number);
                              
  procedure sp_cargadat_repro(fechaInicio date, fechaFin date);
  
  Function Fn_cr_dni(xcta number) return char;
  
  FUNCTION fn_mont_prima (pn_emp    in number, 
                          pn_suc    in number,
                          pn_mod    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number, 
                          pn_ope    in number, 
                          pn_sbo    in number, 
                          pn_top    in number) return number ;
   FUNCTION fn_prim_acumulad(pn_emp    in number,
                              pn_suc    in number,
                              pn_mod    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,             
                              fn_reprog in date) return number;
    FUNCTION fn_fecha_Primr_Pag(pn_emp    in number,
                              pn_suc    in number,
                              pn_mod    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,             
                              fn_reprog in date) return date;   

     FUNCTION Fn_desgv_primtotsegag(    pn_emp    in number,
                                        pn_suc    in number,
                                        pn_mod    in number,
                                        pn_mda    in number,
                                        pn_pap    in number,
                                        pn_cta    in number,
                                        pn_ope    in number,
                                        pn_sbo    in number,
                                        pn_top    in number,             
                                        fn_reprog in date) return number;    
     PROCEDURE sp_carga_desgrav(fechaInicio date, fechaFin date);  
     PROCEDURE carga_aqpa833(fechaInicio date, fechaFin date);                                                                                                               

end pq_cred_rep_reprog_seguros;
/

create or replace package body pq_cred_rep_reprog_seguros is
   


   procedure obtenerformatocorreo(paisx number, tipodoc number, nrodoc varchar, correo out varchar) as
     doc char(12);

     CURSOR CORREOS IS
     SELECT PEXTXT  FROM fsx001  where Pepais = paisx and Petdoc = tipodoc and Pendoc = doc;
   begin     
     doc := trim(nrodoc);
     FOR REG IN CORREOS LOOP
         correo := replace(trim(REG.PEXTXT), '\','');          
         IF CORREO IS NOT NULL THEN
           EXIT;
           END IF;
     END LOOP;

   end obtenerformatocorreo;  
   procedure formatonrocta(cuenta number,operacion number, suboper number, nrocuenta out varchar2)as
     begin
       nrocuenta := to_char(LPAD(cuenta,9,'0')||LPAD(operacion,9,'0')||LPAD(suboper,3,'0'));
       end;
 ------------------
   PROCEDURE obtenertasaneta(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                             xsbop number, xtope number, tasa_neta out number) AS
   ln_instancia NUMBER;  
   ln_mtoapr NUMBER; 
   ln_parcial NUMBER; 
   ln_montopar NUMBER;  
   ln_montoxtasa NUMBER;  
   ln_tasa NUMBER(17,6);  
   ln_aoimp     number(17, 2);                  
   BEGIN               
          BEGIN
            SELECT W.XWFPRCINS INTO ln_instancia FROM XWF700 W WHERE 
            W.XWFEMPRESA = xpgcod AND
            W.XWFMODULO  = xmod  AND
            W.XWFSUCURSAL = xsucurs AND
            W.XWFMONEDA   =  xmoned AND
            W.XWFPAPEL = xpapel AND
            W.XWFCUENTA = xcta AND 
            W.XWFOPERACION = xoper AND 
            W.XWFSUBOPE = xsbop AND 
            W.XWFTIPOPE = xtope AND
            W.XWFCAR3 = '1' AND
            ROWNUM = 1; 
         exception
            when no_data_found then
              ln_instancia   := null;   
         END; 
         
          begin
            select aoimp
              into ln_aoimp
              from fsd010 a
             where a.pgcod = xpgcod
               and a.aomod = xmod
               and a.aosuc = xsucurs 
               and a.aomda = xmoned
               and a.aopap = xpapel
               and a.aocta = xcta
               and a.aooper = xoper
               and a.aosbop = xsbop
               and a.aotope = xtope;

          exception
            when no_data_found then
              begin
                select aoimp
                  into ln_aoimp
                  from fsd010 a
                 where a.pgcod = xpgcod
                   and a.aomod = xmod
                 
                   and a.aomda = xmoned
                   and a.aopap = xpapel
                   and a.aocta = xcta
                   and a.aooper = xoper
                   and a.aosbop = xsbop
                   and a.aotope = xtope;

              exception
                when no_data_found then
                  ln_aoimp   := null; 
              END;             
          end;                    
     
          --monto aprobado
          ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);

          ---verificar si es desembolso parcial sma04/10/2018
          begin
            select 1, sum(sng017mto) into ln_parcial, ln_montopar from sng001 Where SNG001Inst = ln_instancia and sng001ori = 7;
            exception 
            when no_data_found then
            ln_parcial := 0;
          end;
          if ln_parcial = 1 and ((ln_montopar is not null) and ln_montopar <> 0) then
               ln_montoxtasa := ln_montopar;
          else
                if ln_mtoapr <> 0 or ln_mtoapr is not null then
                   ln_montoxtasa := ln_mtoapr;
                ELSE
                ln_mtoapr := ln_aoimp;
                 ln_montoxtasa := ln_mtoapr;
                END IF;
          end if;
          --tasa
          --aqui con los datos de entrada se obtine la tasa ln_tasa 
          ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(xpgcod,
                                                              xmod,
                                                              xsucurs,
                                                              xmoned,
                                                              xpapel,
                                                              xcta,
                                                              xoper,
                                                              xsbop,
                                                              xtope,
                                                              ln_montoxtasa);
         tasa_neta := ln_tasa;
       
   END;
   
   procedure obtenerPlan(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                      xsbop number, xtope number, lc_plan out varchar) as
   ln_grupo     number(2);                                          
   BEGIN
          --grupo
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(xpgcod,
                                                  xmod,
                                                  xsucurs,
                                                  xmoned,
                                                  xpapel,
                                                  xcta,
                                                  xoper,
                                                  xsbop,
                                                  xtope);


          if ln_grupo is null then
            ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(xpgcod,
                                                        xmod,
                                                        xsucurs,
                                                        xmoned,
                                                        xpapel,
                                                        xcta,
                                                        xoper,
                                                        xsbop,
                                                        xtope);
          end if;

          --plan
          case
            when ln_grupo in (2, 12, 13) then
              lc_plan := 'PYME';
            when ln_grupo = 3 then
              lc_plan := 'CONSUMO';
            when ln_grupo = 4 then
              lc_plan := 'HIPOTECARIO';
            else
              null;
          end case;

   END obtenerPlan;
 
   procedure obtenerPrimaTotal(xpgcod number, xmod number, xsucurs number, xpapel number, xmoned number, xcta number, xoper number, 
                              xsbop number, xtope number,  ln_monto_tot out number) as
   begin
        --monto de la prima total
        ln_monto_tot := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(xpgcod,
                                                                xmod,
                                                                xsucurs,
                                                                xmoned,
                                                                xpapel,
                                                                xcta,
                                                                xoper,
                                                                xsbop,
                                                                xtope);                                                                                 
   end obtenerPrimaTotal;

   --- Rep. Seguro Vida Caja
   procedure sp_cargadat_repro(fechaInicio date, fechaFin date) as
    CURSOR datos_tabl2 is
    select * --count(*) 
    from USRREPBI.REP_TOT_REPRO_2020  where  fecha_reprogramacion   between fechaInicio and fechaFin  
    and   extorno ='NO'  and  con_cptlzcn = '-'  ;
    ln_nrodoc char(12) := '';
    ln_monto_prima number := '';
    ln_pgcod number  ;
    ln_cuenta number;
    ln_modulo number;
    ln_sucursal number;
    ln_moneda number;
    ln_papel number;
    ln_operac number;
    ln_subope number;
    ln_tipope number;   
    ln_prima_acumuld number;  
    ln_fech_primer_pag date;
    fn_reprog date;
    ln_mosign varchar2(30);
    ln_perid_grc number;
    flgExitXw700 varchar2(1);
    
    begin  
        FOR xrow IN datos_tabl2 LOOP
            
         flgExitXw700 := 'N';
          fn_reprog := XROW.FECHA_REPROGRAMACION;  
        
          BEGIN   
           SELECT  W.XWFEMPRESA, 
                   W.XWFMODULO,  
                   W.XWFSUCURSAL,
                   W.XWFMONEDA ,
                   W.XWFPAPEL,             
                   W.XWFCUENTA,
                   W.XWFOPERACION,
                   W.XWFSUBOPE, 
                   W.XWFTIPOPE,
                   'S'                  
                   INTO ln_pgcod, 
                        ln_modulo,
                        ln_sucursal,
                        ln_moneda, 
                        ln_papel,
                        ln_cuenta,
                        ln_operac,
                        ln_subope,
                        ln_tipope,
                        flgExitXw700                    
                    FROM XWF700 W, USRREPBI.REP_TOT_REPRO_2020 Y
                    WHERE 
                      ROWNUM = 1
                      AND W.XWFEMPRESA = 1                     
                      AND W.XWFCUENTA = xrow.bccta
                      AND W.XWFOPERACION = xrow.bcoper
                      AND W.XWFSUBOPE = xrow.bcsbop
                      AND W.XWFCAR3 = '1';
           EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
                ln_pgcod := 0;
                ln_modulo := 0;
                ln_sucursal := 0;
                ln_moneda := 0; 
                ln_papel := 0;
                ln_cuenta := 0;
                ln_operac := 0;
                ln_subope := 0;
                ln_tipope := 0;                                   
           END;        
       IF flgExitXw700 = 'S' THEN                        
          --nrodni
           ln_nrodoc := pq_cred_rep_reprog_seguros.Fn_cr_dni(xrow.bccta);
          -- monto prima
           ln_monto_prima :=  pq_cred_rep_reprog_seguros.fn_mont_prima(ln_pgcod,
                                                                       ln_sucursal,
                                                                       ln_modulo,
                                                                       ln_moneda,
                                                                       ln_papel,
                                                                       ln_cuenta,
                                                                       ln_operac,
                                                                       ln_subope,
                                                                       ln_tipope
                                                                       );
                IF ln_monto_prima > 0 THEN                                                                                                                                                
                        -- prima acumulado                                                                                   
                        ln_prima_acumuld  := pq_cred_rep_reprog_seguros.fn_prim_acumulad(ln_pgcod,
                                                                                         ln_sucursal,
                                                                                         ln_modulo,
                                                                                         ln_moneda,
                                                                                         ln_papel,
                                                                                         ln_cuenta,
                                                                                         ln_operac,
                                                                                         ln_subope,
                                                                                         ln_tipope,                
                                                                                         fn_reprog);
                        -- fecha primer pago
                         ln_fech_primer_pag := pq_cred_rep_reprog_seguros.fn_fecha_Primr_Pag(ln_pgcod,
                                                                                               ln_sucursal,
                                                                                               ln_modulo,
                                                                                               ln_moneda,
                                                                                               ln_papel,
                                                                                               ln_cuenta,
                                                                                               ln_operac,
                                                                                               ln_subope,
                                                                                               ln_tipope,        
                                                                                               fn_reprog); 
                        --periodo de gracia
                         if xrow.fecha_reprogramacion is not null and ln_fech_primer_pag is not null then
                            ln_perid_grc := xrow.fecha_reprogramacion - ln_fech_primer_pag  ;
                            if ln_perid_grc < 0 then
                              ln_perid_grc := ln_perid_grc * (-1);
                              end if;           
                         else 
                            ln_perid_grc := 0;
                         end if;               
                         
                         -- tipo moneda
                         
                         BEGIN
                           SELECT mosign into ln_mosign FROM FST005 WHERE MONEDA = ln_moneda;
                         EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                             ln_mosign := '';               
                         END;                                                                                                                                                                             
                         BEGIN            
                             INSERT INTO AQPC185(
                                  AQPC185EMP,
                                  AQPC185MOD,
                                  AQPC185SUC,
                                  AQPC185CTA,
                                  AQPC185OPE,
                                  AQPC185MDA,
                                  AQPC185PAP,
                                  AQPC185SBOP,
                                  AQPC185TOPE,
                                  AQPC185FECRPRG,
                                  AQPC185DNI,
                                  AQPC185MNTPRIM,
                                  AQPC185PRMCUM,
                                  AQPC185TIPMON,
                                  AQPC185FECPRPAG,
                                  AQPC185PERIDGR) VALUES(
                                  ln_pgcod,
                                  ln_modulo,
                                  ln_sucursal,
                                  ln_cuenta,
                                  ln_operac,
                                  ln_moneda,
                                  ln_papel,
                                  ln_subope,
                                  ln_tipope, 
                                  fn_reprog,
                                  ln_nrodoc,
                                  ln_monto_prima,
                                  ln_prima_acumuld,
                                  ln_mosign,
                                  ln_fech_primer_pag,
                                  ln_perid_grc            
                                  );
                                  COMMIT;
                          exception
                            when dup_val_on_index then
                              null;
                          end ;                                    
              END IF;   
          END IF;                                                           
        END LOOP;
          
    end sp_cargadat_repro;
    
    --- Rep. Seguro Desgravamen    
    PROCEDURE sp_carga_desgrav(fechaInicio date, fechaFin date) is
    ------------------------------------      
      CURSOR datos_tabl3(fechaInicio date, fechaFin date) is
      select * --count(*) 
      from USRREPBI.REP_TOT_REPRO_2020  where  fecha_reprogramacion   between fechaInicio and fechaFin  
      and   extorno ='NO'  and  con_cptlzcn = '-';  
      
      
       cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';
      
    ------------------------------------
    fn_reprog date;
    ln_pgcod number;
    ln_modulo number;
    ln_sucursal number;
    ln_moneda number; 
    ln_papel number;
    ln_cuenta number;
    ln_operac number;
    ln_subope number;
    ln_tipope number; 
    
    ln_numpol NUMBER;
    ln_nrocredito char(30);
    ln_vig_ini date;
    ln_vig_fin date;
    ln_sum_asegurda number(17,6);
    ln_tasa NUMBER; 
    ln_prim_tot number;
    ln_plan char(20);
    
    ln_nrodoc CHAR(12);
    ln_pepais numeric;
    ln_petdoc numeric;
 

    ln_tip_pers varchar2(2); 
    ln_Tdnom varchar2(30);
    ln_fec_nac date;
    ln_ape_pat varchar2(30);
    ln_ape_mat varchar2(30);
    ln_nombres varchar2(52);
    Ln_mont_desem numeric;
    ln_fec_desm date;
    ln_periodic number;
    ln_fec_cuota date;
    ln_estd_cred number;
    ln_razsoc varchar2(70);
    ln_sex varchar2(2);
    ln_fech_primer_pag date;
    ln_perid_grc number;
    
    lc_telefono varchar2(100);
    lc_correo varchar2(200);
    ln_cont number;
    ln_cont1 number;
    ln_mosign varchar2(30);
    esreprog VARCHAR2(2);
    
    xExisteDesg varchar(1);
    ln_primtotsegur number;
    ln_scnom varchar2(30);
    ln_tipdoc_desc varchar2(40);
    flgexisxw700 VARCHAR2(1):= 'N';
------------------------------------
    BEGIN
      Execute immediate ('truncate table AQPC186');             
      commit;
      ----aqpa833
      pq_cred_rep_reprog_seguros.carga_aqpa833(fechaInicio, fechaFin) ; 
    
      -----
      FOR i in datos_tabl3(fechaInicio, fechaFin ) loop
          flgexisxw700 := 'N';
          fn_reprog := i.FECHA_REPROGRAMACION;  
        
          BEGIN   
           SELECT  W.XWFEMPRESA, 
                   W.XWFMODULO,  
                   W.XWFSUCURSAL,
                   W.XWFMONEDA ,
                   W.XWFPAPEL,             
                   W.XWFCUENTA,
                   W.XWFOPERACION,
                   W.XWFSUBOPE, 
                   W.XWFTIPOPE,
                   'S'                  
                   INTO ln_pgcod, 
                        ln_modulo,
                        ln_sucursal,
                        ln_moneda, 
                        ln_papel,
                        ln_cuenta,
                        ln_operac,
                        ln_subope,
                        ln_tipope,
                        flgexisxw700                    
                    FROM XWF700 W, USRREPBI.REP_TOT_REPRO_2020 Y
                    WHERE                      
                      W.XWFEMPRESA = 1                  
                      AND W.XWFCUENTA = i.bccta
                      AND W.XWFOPERACION = i.bcoper
                      AND W.XWFSUBOPE = i.bcsbop
                      AND W.XWFCAR3 = '1'
                      AND ROWNUM = 1;
           EXCEPTION 
             WHEN NO_DATA_FOUND THEN
               NULL;
           END;  
     IF flgexisxw700 = 'S' THEN
        --Prima tot_seguro
        BEGIN
            SELECT 'S' INTO xExisteDesg FROM fpp001 a 
            WHERE (a.SGCOD IN (select TP1NRO3 from fst198 where TP1COD = 1 AND tp1cod1 =10884 and tp1corr1 = 61 and tp1nro1 in (1,2)) 
            OR  a.SGCOD IN (select j.SGCOD from fst300 j where j.SGSN02 = 5)) 
                        
            and a.pgcod = ln_pgcod and a.aomod = ln_modulo and a.aosuc = ln_sucursal and a.aomda = ln_moneda and a.aocta = ln_cuenta and
            a.aooper = ln_operac and  a.aosbop = ln_subope and a.aotope = ln_tipope and rownum = 1;
            --GROUP BY a.AOCTA;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN    
            xExisteDesg := 'N'; 
        END;
        ln_primtotsegur   := pq_cred_rep_reprog_seguros.Fn_desgv_primtotsegag(ln_pgcod, 
                                                                             ln_sucursal,
                                                                             ln_modulo,
                                                                             ln_moneda, 
                                                                             ln_papel,
                                                                             ln_cuenta,
                                                                             ln_operac,
                                                                             ln_subope,
                                                                             ln_tipope,
                                                                             fn_reprog);    
       -- ln_primtotsegur := round(ln_primtotsegur,6);                                                                              
                                     
      IF xExisteDesg = 'S' and ln_primtotsegur > 0 THEN       
        -- Numero de poliza
          if ln_moneda = 0 then
            ln_numpol := 235901;
          else
            ln_numpol := 235899;
          end if;
          
        -- Numero credito
           ln_nrocredito := to_char(LPAD(i.bccta,9,'0')||LPAD(i.bcoper,9,'0')||LPAD(i.bcsbop,3,'0')) ;
        -- Vig-inicial
           ln_vig_ini := fechaInicio;
        -- vig-fin
           ln_vig_fin := fechaFin;
        -- Sum asegurda
           ln_sum_asegurda := round(i.monto,2);
        -- tasa_neta
           ln_tasa:= null;
           pq_cred_rep_reprog_seguros.obtenertasaneta(ln_pgcod, 
                                                      ln_modulo,
                                                      ln_sucursal,
                                                      ln_papel,
                                                      ln_moneda,                      
                                                      ln_cuenta,
                                                      ln_operac,
                                                      ln_subope,
                                                      ln_tipope,
                                                      ln_tasa);
            ln_tasa := round(ln_tasa,6);                                          
         -- prima_total
           ln_prim_tot := null;
           pq_cred_rep_reprog_seguros.obtenerPrimaTotal(ln_pgcod, 
                                                        ln_modulo,
                                                        ln_sucursal,
                                                        ln_papel,
                                                        ln_moneda,                      
                                                        ln_cuenta,
                                                        ln_operac,
                                                        ln_subope,
                                                        ln_tipope,
                                                        ln_prim_tot);
            ln_prim_tot := round(ln_prim_tot,6);                                                                                                                                                                                
         -- Fec ini -recibi
           ln_vig_ini := fechaInicio ;
         -- Fec fin -recibi
           ln_vig_fin := fechaFin;    
         -- Plan 
           ln_plan := null;
           pq_cred_rep_reprog_seguros.obtenerPlan(ln_pgcod, 
                                                  ln_modulo,
                                                  ln_sucursal,
                                                  ln_papel,
                                                  ln_moneda,                      
                                                  ln_cuenta,
                                                  ln_operac,
                                                  ln_subope,
                                                  ln_tipope,
                                                  ln_plan);    
          --nrodni  
          ln_nrodoc := null;
          ln_pepais := null;
          ln_petdoc := null;   
          BEGIN
             SELECT PEPAIS, PETDOC, PENDOC INTO ln_pepais, ln_petdoc, ln_nrodoc   FROM FSR008 WHERE CTNRO = i.bccta and CTTFIR  ='T' ;
          EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                    NULL;
          END;
          --tip person 
          ln_tip_pers :=null;  
          ln_Tdnom :=null;
          ln_fec_nac :=null;
          ln_ape_pat :=null;
          ln_ape_mat :=null;
          ln_nombres :=null;
          ln_sex := null;
          BEGIN
            SELECT PETIPO INTO ln_tip_pers FROM FSD001 where Pepais = ln_pepais AND Petdoc = ln_petdoc AND Pendoc = ln_nrodoc;                     
          EXCEPTION  
          WHEN NO_DATA_FOUND THEN
            ln_tip_pers := '';  
          END;  
          
          BEGIN
            --tipo doc
            SELECT Tdnom INTO ln_Tdnom FROM FST014 WHERE Tdocum = ln_petdoc;
           EXCEPTION 
           WHEN NO_DATA_FOUND THEN
            ln_Tdnom := '';   
          END;  
          
          BEGIN
            SELECT Pfcant, Pffnac, Pfape1, Pfape2, trim(pfnom1) || ' ' || trim(pfnom2)  into ln_sex, ln_fec_nac, ln_ape_pat,
               ln_ape_mat, ln_nombres  FROM FSD002 WHERE PFPAIS = ln_pepais AND PFTDOC = ln_petdoc AND PFNDOC = ln_nrodoc;       EXCEPTION 
          WHEN NO_DATA_FOUND THEN
            ln_sex:= '';   
            ln_fec_nac := '';
            ln_ape_pat := '';  
            ln_ape_mat := '';   
            ln_nombres := '';                                                                                                                         
          END;                                              
          
          --razon social
          ln_razsoc := null;
          BEGIN
            SELECT Pjrazs INTO ln_razsoc FROM Fsd003  WHERE pjpais = ln_pepais AND
                                        Pjtdoc = ln_petdoc AND
                                        Pjndoc = ln_nrodoc;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
          
          ---antes prima --  
          -- Mont desem
          Ln_mont_desem := round(i.monto,2);
         -- fec primer pag
         ln_fech_primer_pag := pq_cred_rep_reprog_seguros.fn_fecha_Primr_Pag(ln_pgcod, 
                                                                             ln_sucursal,
                                                                             ln_modulo,
                                                                             ln_moneda, 
                                                                             ln_papel,
                                                                             ln_cuenta,
                                                                             ln_operac,
                                                                             ln_subope,
                                                                             ln_tipope,
                                                                             fn_reprog);                                                                                                                                                   
                                                                         
          --periodo de gracia
         if i.fecha_reprogramacion is not null and ln_fech_primer_pag is not null then
            ln_perid_grc := i.fecha_reprogramacion - ln_fech_primer_pag  ;
            if ln_perid_grc < 0 then
              ln_perid_grc := ln_perid_grc * (-1);
              end if;           
         else 
            ln_perid_grc := 0;
         end if;   
         --fec desem
          ln_fec_desm := fn_reprog ;
         -- frec- pago
         ln_periodic := 0;
         ln_estd_cred := 0 ;
         BEGIN
           SELECT Aoperiod, aostat INTO  ln_periodic, ln_estd_cred FROM FSD010 WHERE PGCOD = ln_pgcod AND AOMOD = ln_modulo AND
            AOSUC = ln_sucursal AND AOMDA = ln_moneda AND AOPAP = ln_papel AND AOCTA = ln_cuenta AND AOOPER = ln_operac AND
            AOSBOP = ln_subope AND  AOTOPE = ln_tipope;
         EXCEPTION 
          WHEN NO_DATA_FOUND THEN
            NULL;   
         END;
         -- fec_cuota
         ln_fec_cuota := ln_fech_primer_pag ;
         
         -- telefono y correo 
        lc_telefono := null;
        lc_correo := null;
        ln_cont := 0;
        For t in telefono(ln_pepais ,ln_petdoc, ln_nrodoc)loop
          if ln_cont = 0 then
            lc_telefono := trim(t.fono);
          else
            lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
          end if;
           ln_cont := ln_cont + 1;
        end loop;

        ln_cont1 := 0;
         For c in correo(ln_pepais ,ln_petdoc, ln_nrodoc)loop
          if ln_cont1 = 0 then
            lc_correo := trim(c.mail);
          else
            lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
          end if;
           ln_cont1 := ln_cont1 + 1;
        end loop; 
        --tipo moned
        ln_mosign := null;
        BEGIN
          SELECT MONOM into ln_mosign FROM FST005 WHERE MONEDA = ln_moneda;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          ln_mosign := '';               
        END;   
        
        ln_scnom:=null;
        begin
          select scnom into ln_scnom from fst001 where SUCURS = ln_sucursal;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          ln_scnom := '';               
        end;
        ln_tipdoc_desc := null;
        begin
         select tdnom into ln_tipdoc_desc from fst014 where tdocum = ln_petdoc;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          ln_tipdoc_desc := '';               
        end;
        
        
        
        esreprog := 'S';
          
        --insert
         BEGIN            
               INSERT INTO AQPC186(                              
                AQPC186EMP,  
                AQPC186MOD,  
                AQPC186SUC,  
                AQPC186MDA,  
                AQPC186PAP,  
                AQPC186CTA,  
                AQPC186OPE,  
                AQPC186SBO,  
                AQPC186TOP,  
                AQPC186FEC,                   
                AQPC186MAP,
                AQPC186FEI,
                AQPC186FEF,
                AQPC186NUM,
                AQPC186TAS,
                AQPC186MPR,   
                AQPC186PLA,
                AQPC186PAI,
                AQPC186TDO,
                AQPC186NDO,
                AQPC186TPE,
                AQPC186SEX,
                AQPC186FNA,
                AQPC186APT,
                AQPC186APM,
                AQPC186NOM,
                AQPC186RZO,   
                AQPC186IMP,
                AQPC186FVA,
                AQPC186DGA,                                          
                AQPC186PER,  
                AQPC186MCA,  
                AQPC186FVE,
                AQPC186EST,
                AQPC186FPR,
                AQPC186TLF,
                AQPC186MAIL,
                AQPC186AGE,
                AQPC186NOMSUC,
                AQPC186TIPMND,  
                AQPC186ESREPG,
                AQPC186TIPDOC,
                AQPC186FECREC)
                VALUES(
                              ln_pgcod,
                              ln_modulo,
                              ln_sucursal,
                              ln_moneda, 
                              ln_papel,
                              ln_cuenta,
                              ln_operac,                                                  
                              ln_subope,
                              ln_tipope,
                              fn_reprog,
                              ln_primtotsegur,
                              fechaInicio,
                              fechaFin,
                              ln_numpol,
                              ln_tasa,
                              ln_prim_tot,
                              ln_plan,
                              ln_pepais,
                              ln_petdoc,
                              ln_nrodoc,
                              ln_tip_pers,
                              ln_sex,
                              ln_fec_nac,
                              ln_ape_pat,
                              ln_ape_mat,
                              ln_nombres,
                              ln_razsoc,
                              ln_sum_asegurda,
                              fn_reprog,
                              ln_perid_grc,
                              ln_periodic,
                              ln_prim_tot,
                              ln_fech_primer_pag,
                              ln_estd_cred,
                              ln_fech_primer_pag,
                              lc_telefono,
                              lc_correo,
                              ln_sucursal,
                              ln_scnom,
                              ln_mosign,
                              esreprog,
                              ln_tipdoc_desc,
                              fechaFin);
                              COMMIT;
                      exception
                        when dup_val_on_index then
                          null;
                      end ;       
        
            END IF;      
   END IF;       
      END LOOP;           
    END SP_CARGA_DESGRAV;
    
    
    
    Function Fn_cr_dni(xcta number) return char is
    nrodni  char(12) := '';
    begin
      BEGIN 
        SELECT PENDOC INTO nrodni FROM FSR008 WHERE PGCOD = 1 AND CTNRO = xcta and CTTFIR = 'T';
      EXCEPTION 
        WHEN NO_DATA_FoUND THEN
          nrodni :='';
      END;

    return nrodni;

    end Fn_cr_dni;
    
    FUNCTION fn_mont_prima (pn_emp    in number, 
                            pn_suc    in number,
                            pn_mod    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number, 
                            pn_ope    in number, 
                            pn_sbo    in number, 
                            pn_top    in number) return number is
      mont_prima number := 0;
      xcuenta number := 0;
    BEGIN
      BEGIN 
          SELECT SUM(Pp001Imp) AS IMPORTE INTO mont_prima FROM fpp001 a 
         -- INNER JOIN aqpa833 b on
         -- a.aocta = b.bccta and a.aooper = b.bcoper and a.aosbop = b.bcsbop
          WHERE a.SGCOD IN (122,124,125) and
          --FECHA_REPROGRAMACION >= fechaInicio AND FECHA_REPROGRAMACION <= fechaFin and
          a.aocta = pn_cta and a.aooper = pn_ope and a.aosuc = pn_suc and a.aosbop = pn_sbo and a.aotope = pn_top
          GROUP BY a.AOCTA;
      EXCEPTION 
      WHEN NO_DATA_FOUND THEN
          mont_prima := 0;
      END;
        
      RETURN mont_prima;
    END fn_mont_prima;
    
    FUNCTION fn_prim_acumulad(pn_emp    in number,
                              pn_suc    in number,
                              pn_mod    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,             
                              fn_reprog in date) return number is

    ln_prim_acum number(17,6) := 0;                              
    BEGIN
      BEGIN
         SELECT sum(PPIMP11) INTO ln_prim_acum FROM FSD611 WHERE PGCOD = pn_emp AND PPSUC = pn_suc AND PPMOD = pn_mod
         AND PPCTA  = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo
         AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
         order by ppfpag asc;        
      EXCEPTION 
      WHEN NO_DATA_FOUND THEN
            ln_prim_acum := 0;   
      END;
      
      RETURN ln_prim_acum;
    END;
    
    FUNCTION fn_fecha_Primr_Pag(pn_emp    in number,
                              pn_suc    in number,
                              pn_mod    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,             
                              fn_reprog in date) return date IS
    Fn_primerPag date := '';                         
    BEGIN
        BEGIN
              SELECT MIN(PPFPAG) into Fn_primerPag FROM FSD611 WHERE PGCOD = pn_emp AND PPSUC = pn_suc AND PPMOD = pn_mod 
              AND PPMDA = pn_mda AND PPCTA = pn_cta AND PPOPER = pn_ope   
              AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG >= fn_reprog --AND ROWNUM <2--last_day(fn_reprog)           
              ORDER BY PPFPAG ASC;
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN
          Fn_primerPag := '';  
        END;
    
        RETURN Fn_primerPag;
    END;
    
    --- PRIM TOTAL SEG
    FUNCTION Fn_desgv_primtotsegag( pn_emp    in number,
                                    pn_suc    in number,
                                    pn_mod    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,             
                                    fn_reprog in date) return number is
    xExiste varchar2(1) := 'N';  
    xcount  number;        
    xprim_tot_seg numeric(17,6);                    
    BEGIN
               
    BEGIN
        SELECT 'S' INTO xExiste FROM fpp001 a 
        WHERE (a.SGCOD IN (select TP1NRO3 from fst198 where TP1COD = 1 AND tp1cod1 =10884 and tp1corr1 = 61 and tp1nro1 in (1,2)) 
        OR a.SGCOD IN (select j.SGCOD from fst300 j where j.SGSN02 = 5))       
        
        and a.pgcod = pn_emp and a.aomod = pn_mod and a.aosuc = pn_suc and a.aomda = pn_mda and a.aocta = pn_cta and
        a.aooper = pn_ope and  a.aosbop = pn_sbo and a.aotope = pn_top and rownum = 1;
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN    
        xExiste := 'N'; 
    END;
        
    BEGIN
        SELECT COUNT(1) INTO xcount FROM fpp001 a 
        WHERE a.pgcod = pn_emp and a.aomod = pn_mod and a.aosuc = pn_suc and a.aomda = pn_mda and a.aocta = pn_cta and
        a.aooper = pn_ope and  a.aosbop = pn_sbo and a.aotope = pn_top;
    EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
       xcount := 0;  
    END; 
                       
    IF xExiste = 'S' THEN
       --CASE xcount
        IF xcount = 1 THEN --WHEN 1 THEN 
           BEGIN 
             SELECT sum(PPIMP11) INTO xprim_tot_seg FROM FSD611 WHERE PGCOD = pn_emp AND PPMOD = pn_mod AND PPSUC = pn_suc AND PPMDA = pn_mda  
             AND PPCTA = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
             order by ppfpag asc;
           EXCEPTION 
           WHEN NO_DATA_FOUND THEN    
                xprim_tot_seg := 0; 
           END;
         ELSIF xcount = 2 THEN--  WHEN 2 THEN             
                 BEGIN 
                   SELECT sum(PPIMP12) INTO xprim_tot_seg FROM FSD611 WHERE PGCOD = pn_emp AND PPMOD = pn_mod AND PPSUC = pn_suc AND PPMDA = pn_mda  
                   AND PPCTA = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
                   order by ppfpag asc;
                 EXCEPTION 
                 WHEN NO_DATA_FOUND THEN    
                      xprim_tot_seg := 0; 
                 END;
          ELSIF xcount = 3 THEN-- WHEN 3 THEN 
                 BEGIN 
                   SELECT sum(PPIMP13) INTO xprim_tot_seg FROM FSD611 WHERE PGCOD = pn_emp AND PPMOD = pn_mod AND PPSUC = pn_suc AND PPMDA = pn_mda  
                   AND PPCTA = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
                   order by ppfpag asc;
                 EXCEPTION 
                 WHEN NO_DATA_FOUND THEN    
                      xprim_tot_seg := 0; 
                 END;
           ELSIF xcount = 4 THEN--  WHEN 4 THEN 
                 BEGIN 
                   SELECT sum(PPIMP14) INTO xprim_tot_seg FROM FSD611 WHERE PGCOD = pn_emp AND PPMOD = pn_mod AND PPSUC = pn_suc AND PPMDA = pn_mda  
                   AND PPCTA = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
                   order by ppfpag asc;
                 EXCEPTION 
                 WHEN NO_DATA_FOUND THEN    
                      xprim_tot_seg := 0; 
                 END;
           ELSIF xcount = 5 THEN-- WHEN  5 THEN 
                   BEGIN 
                     SELECT sum(PPIMP15) INTO xprim_tot_seg FROM FSD611 WHERE PGCOD = pn_emp AND PPMOD = pn_mod AND PPSUC = pn_suc AND PPMDA = pn_mda  
                     AND PPCTA = pn_cta AND PPOPER = pn_ope  AND PPSBOP = pn_sbo AND PPTOPE = pn_top AND PPFPAG > last_day(fn_reprog)
                     order by ppfpag asc;
                   EXCEPTION 
                   WHEN NO_DATA_FOUND THEN    
                        xprim_tot_seg := 0; 
                   END;
           ELSE
                   xprim_tot_seg := 0; 
           END IF; 
    END IF;
                                             
    RETURN xprim_tot_seg;

    END Fn_desgv_primtotsegag;

    PROCEDURE carga_aqpa833(fechaInicio date, fechaFin date) is
     ------------------------------------      
      CURSOR datos_tabl2(fechaInicio date, fechaFin date) is
      SELECT * FROM aqpa833 where FECHA_REPROGRAMACION between fechaInicio and fechaFin  ;  
      
      
       cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';
      
    ------------------------------------
    fn_reprog date;
    ln_pgcod number;
    ln_modulo number;
    ln_sucursal number;
    ln_moneda number; 
    ln_papel number;
    ln_cuenta number;
    ln_operac number;
    ln_subope number;
    ln_tipope number; 
    
    ln_numpol NUMBER;
    ln_nrocredito char(30);
    ln_vig_ini date;
    ln_vig_fin date;
    ln_sum_asegurda number(17,6);
    ln_tasa NUMBEr; 
    ln_prim_tot number;
    ln_plan char(20);
    
    ln_nrodoc CHAR(12);
    ln_pepais numeric;
    ln_petdoc numeric;
 

    ln_tip_pers varchar2(2); 
    ln_Tdnom varchar2(30);
    ln_fec_nac date;
    ln_ape_pat varchar2(30);
    ln_ape_mat varchar2(30);
    ln_nombres varchar2(52);
    Ln_mont_desem numeric;
    ln_fec_desm date;
    ln_periodic number;
    ln_fec_cuota date;
    ln_estd_cred number;
    ln_razsoc varchar2(70);
    ln_sex varchar2(2);
    ln_fech_primer_pag date;
    ln_perid_grc number;
    
    lc_telefono varchar2(100);
    lc_correo varchar2(200);
    ln_cont number;
    ln_cont1 number;
    ln_mosign varchar2(30);
    esreprog VARCHAR2(2);
    
    xExisteDesg varchar(1);
    ln_primtotsegur number;
    ln_scnom varchar2(30);
    ln_tipdoc_desc varchar2(40);
    flgexisxw700 VARCHAR2(1):= 'N';
    auxnumerico varchar2(20) := '';
    
------------------------------------
    BEGIN
      FOR i in datos_tabl2(fechaInicio, fechaFin ) loop
                  flgexisxw700 := 'N';
                  fn_reprog := i.FECHA_REPROGRAMACION;  
                
                  BEGIN   
                   SELECT  W.XWFEMPRESA, 
                           W.XWFMODULO,  
                           W.XWFSUCURSAL,
                           W.XWFMONEDA ,
                           W.XWFPAPEL,             
                           W.XWFCUENTA,
                           W.XWFOPERACION,
                           W.XWFSUBOPE, 
                           W.XWFTIPOPE,
                           'S'                  
                           INTO ln_pgcod, 
                                ln_modulo,
                                ln_sucursal,
                                ln_moneda, 
                                ln_papel,
                                ln_cuenta,
                                ln_operac,
                                ln_subope,
                                ln_tipope,
                                flgexisxw700                    
                            FROM XWF700 W, aqpa833 Y--USRREPBI.REP_TOT_REPRO_2020 Y
                            WHERE                      
                              W.XWFEMPRESA = 1                  
                              AND W.XWFCUENTA = i.bccta
                              AND W.XWFOPERACION = i.bcoper
                              AND W.XWFSUBOPE = i.bcsbop
                              AND W.XWFCAR3 = '1'
                              AND ROWNUM = 1;
                   EXCEPTION 
                     WHEN NO_DATA_FOUND THEN
                       NULL;
                   END;  
             IF flgexisxw700 = 'S' THEN
                      --Prima tot_seguro
                      BEGIN
                          SELECT 'S' INTO xExisteDesg FROM fpp001 a 
                          WHERE (a.SGCOD IN (select TP1NRO3 from fst198 where TP1COD = 1 AND tp1cod1 =10884 and tp1corr1 = 61 and tp1nro1 in (1,2)) 
                          OR  a.SGCOD IN (select j.SGCOD from fst300 j where j.SGSN02 = 5)) --ADD                           
                          
                          and a.pgcod = ln_pgcod and a.aomod = ln_modulo and a.aosuc = ln_sucursal and a.aomda = ln_moneda and a.aocta = ln_cuenta and
                          a.aooper = ln_operac and  a.aosbop = ln_subope and a.aotope = ln_tipope and rownum = 1;
                          --GROUP BY a.AOCTA;
                      EXCEPTION 
                          WHEN NO_DATA_FOUND THEN    
                          xExisteDesg := 'N'; 
                      END;
                      ln_primtotsegur   := pq_cred_rep_reprog_seguros.Fn_desgv_primtotsegag(ln_pgcod, 
                                                                                           ln_sucursal,
                                                                                           ln_modulo,
                                                                                           ln_moneda, 
                                                                                           ln_papel,
                                                                                           ln_cuenta,
                                                                                           ln_operac,
                                                                                           ln_subope,
                                                                                           ln_tipope,
                                                                                           fn_reprog);    
                                                                                                    
                                                   
                    IF xExisteDesg = 'S' and ln_primtotsegur > 0 THEN       
                      -- Numero de poliza
                        if ln_moneda = 0 then
                          ln_numpol := 235901;
                        else
                          ln_numpol := 235899;
                        end if;
                        
                      -- Numero credito
                         ln_nrocredito := to_char(LPAD(i.bccta,9,'0')||LPAD(i.bcoper,9,'0')||LPAD(i.bcsbop,3,'0')) ;
                      -- Vig-inicial
                         ln_vig_ini := fechaInicio;
                      -- vig-fin
                         ln_vig_fin := fechaFin;
                      -- Sum asegurda
                         --auxnumerico := replace(to_char(i.monto),',','.');  
                         ln_sum_asegurda := round(i.monto,2);
                      -- tasa_neta
                         ln_tasa:= null;
                         pq_cred_rep_reprog_seguros.obtenertasaneta(ln_pgcod, 
                                                                    ln_modulo,
                                                                    ln_sucursal,
                                                                    ln_papel,
                                                                    ln_moneda,                      
                                                                    ln_cuenta,
                                                                    ln_operac,
                                                                    ln_subope,
                                                                    ln_tipope,
                                                                    ln_tasa);
                        ln_tasa := round(ln_tasa,6);                                                                  
                       -- prima_total
                         ln_prim_tot := null;
                         pq_cred_rep_reprog_seguros.obtenerPrimaTotal(ln_pgcod, 
                                                                      ln_modulo,
                                                                      ln_sucursal,
                                                                      ln_papel,
                                                                      ln_moneda,                      
                                                                      ln_cuenta,
                                                                      ln_operac,
                                                                      ln_subope,
                                                                      ln_tipope,
                                                                      ln_prim_tot);
                         ln_prim_tot := round(ln_prim_tot,6);                                             
                       -- Fec ini -recibi
                         ln_vig_ini := fechaInicio ;
                       -- Fec fin -recibi
                         ln_vig_fin := fechaFin;    
                       -- Plan 
                         ln_plan := null;
                         pq_cred_rep_reprog_seguros.obtenerPlan(ln_pgcod, 
                                                                ln_modulo,
                                                                ln_sucursal,
                                                                ln_papel,
                                                                ln_moneda,                      
                                                                ln_cuenta,
                                                                ln_operac,
                                                                ln_subope,
                                                                ln_tipope,
                                                                ln_plan);    
                        --nrodni  
                        ln_nrodoc := null;
                        ln_pepais := null;
                        ln_petdoc := null;   
                        BEGIN
                           SELECT PEPAIS, PETDOC, PENDOC INTO ln_pepais, ln_petdoc, ln_nrodoc   FROM FSR008 WHERE CTNRO = i.bccta and CTTFIR  ='T' ;
                        EXCEPTION 
                           WHEN NO_DATA_FOUND THEN
                                  NULL;
                        END;
                        --tip person 
                        ln_tip_pers :=null;  
                        ln_Tdnom :=null;
                        ln_fec_nac :=null;
                        ln_ape_pat :=null;
                        ln_ape_mat :=null;
                        ln_nombres :=null;
                        ln_sex := null;
                        BEGIN
                          SELECT PETIPO INTO ln_tip_pers FROM FSD001 where Pepais = ln_pepais AND Petdoc = ln_petdoc AND Pendoc = ln_nrodoc;                     
                        EXCEPTION  
                        WHEN NO_DATA_FOUND THEN
                          ln_tip_pers := '';  
                        END;  
                        
                        BEGIN
                          --tipo doc
                          SELECT Tdnom INTO ln_Tdnom FROM FST014 WHERE Tdocum = ln_petdoc;
                         EXCEPTION 
                         WHEN NO_DATA_FOUND THEN
                          ln_Tdnom := '';   
                        END;  
                        
                        BEGIN
                          SELECT Pfcant, Pffnac, Pfape1, Pfape2, trim(pfnom1) || ' ' || trim(pfnom2)  into ln_sex, ln_fec_nac, ln_ape_pat,
                             ln_ape_mat, ln_nombres  FROM FSD002 WHERE PFPAIS = ln_pepais AND PFTDOC = ln_petdoc AND PFNDOC = ln_nrodoc;       EXCEPTION 
                        WHEN NO_DATA_FOUND THEN
                          ln_sex:= '';   
                          ln_fec_nac := '';
                          ln_ape_pat := '';  
                          ln_ape_mat := '';   
                          ln_nombres := '';                                                                                                                         
                        END;                                              
                        
                        --razon social
                        ln_razsoc := null;
                        BEGIN
                          SELECT Pjrazs INTO ln_razsoc FROM Fsd003  WHERE pjpais = ln_pepais AND
                                                      Pjtdoc = ln_petdoc AND
                                                      Pjndoc = ln_nrodoc;
                        EXCEPTION 
                          WHEN NO_DATA_FOUND THEN
                            NULL;
                        END;
                        
                        ---antes prima --  
                        -- Mont desem
                        Ln_mont_desem := round(i.monto,2);
                       -- fec primer pag
                       ln_fech_primer_pag := pq_cred_rep_reprog_seguros.fn_fecha_Primr_Pag(ln_pgcod, 
                                                                                           ln_sucursal,
                                                                                           ln_modulo,
                                                                                           ln_moneda, 
                                                                                           ln_papel,
                                                                                           ln_cuenta,
                                                                                           ln_operac,
                                                                                           ln_subope,
                                                                                           ln_tipope,
                                                                                           fn_reprog);                                                                                                                                                   
                                                                                       
                        --periodo de gracia
                       if i.fecha_reprogramacion is not null and ln_fech_primer_pag is not null then
                          ln_perid_grc := i.fecha_reprogramacion - ln_fech_primer_pag  ;
                          if ln_perid_grc < 0 then
                            ln_perid_grc := ln_perid_grc * (-1);
                            end if;           
                       else 
                          ln_perid_grc := 0;
                       end if;   
                       --fec desem
                        ln_fec_desm := fn_reprog ;
                       -- frec- pago
                       ln_periodic := 0;
                       ln_estd_cred := 0 ;
                       BEGIN
                         SELECT Aoperiod, aostat INTO  ln_periodic, ln_estd_cred FROM FSD010 WHERE PGCOD = ln_pgcod AND AOMOD = ln_modulo AND
                          AOSUC = ln_sucursal AND AOMDA = ln_moneda AND AOPAP = ln_papel AND AOCTA = ln_cuenta AND AOOPER = ln_operac AND
                          AOSBOP = ln_subope AND  AOTOPE = ln_tipope;
                       EXCEPTION 
                        WHEN NO_DATA_FOUND THEN
                          NULL;   
                       END;
                       -- fec_cuota
                       ln_fec_cuota := ln_fech_primer_pag ;
                       
                       -- telefono y correo 
                      lc_telefono := null;
                      lc_correo := null;
                      ln_cont := 0;
                      For t in telefono(ln_pepais ,ln_petdoc, ln_nrodoc)loop
                        if ln_cont = 0 then
                          lc_telefono := trim(t.fono);
                        else
                          lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
                        end if;
                         ln_cont := ln_cont + 1;
                      end loop;

                      ln_cont1 := 0;
                       For c in correo(ln_pepais ,ln_petdoc, ln_nrodoc)loop
                        if ln_cont1 = 0 then
                          lc_correo := trim(c.mail);
                        else
                          lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
                        end if;
                         ln_cont1 := ln_cont1 + 1;
                      end loop; 
                      --tipo moned
                      ln_mosign := null;
                      BEGIN
                        SELECT MONOM into ln_mosign FROM FST005 WHERE MONEDA = ln_moneda;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        ln_mosign := '';               
                      END;   
                      
                      ln_scnom:=null;
                      begin
                        select scnom into ln_scnom from fst001 where SUCURS = ln_sucursal;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        ln_scnom := '';               
                      end;
                      ln_tipdoc_desc := null;
                      begin
                       select tdnom into ln_tipdoc_desc from fst014 where tdocum = ln_petdoc;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        ln_tipdoc_desc := '';               
                      end;
                      
                      
                      
                      esreprog := 'S';
                        
                      --insert
                       BEGIN            
                             INSERT INTO AQPC186(                              
                              AQPC186EMP,  
                              AQPC186MOD,  
                              AQPC186SUC,  
                              AQPC186MDA,  
                              AQPC186PAP,  
                              AQPC186CTA,  
                              AQPC186OPE,  
                              AQPC186SBO,  
                              AQPC186TOP,  
                              AQPC186FEC,                   
                              AQPC186MAP,
                              AQPC186FEI,
                              AQPC186FEF,
                              AQPC186NUM,
                              AQPC186TAS,
                              AQPC186MPR,   
                              AQPC186PLA,
                              AQPC186PAI,
                              AQPC186TDO,
                              AQPC186NDO,
                              AQPC186TPE,
                              AQPC186SEX,
                              AQPC186FNA,
                              AQPC186APT,
                              AQPC186APM,
                              AQPC186NOM,
                              AQPC186RZO,   
                              AQPC186IMP,
                              AQPC186FVA,
                              AQPC186DGA,                                          
                              AQPC186PER,  
                              AQPC186MCA,  
                              AQPC186FVE,
                              AQPC186EST,
                              AQPC186FPR,
                              AQPC186TLF,
                              AQPC186MAIL,
                              AQPC186AGE,
                              AQPC186NOMSUC,
                              AQPC186TIPMND,  
                              AQPC186ESREPG,
                              AQPC186TIPDOC,
                              AQPC186FECREC)
                              VALUES(
                                            ln_pgcod,
                                            ln_modulo,
                                            ln_sucursal,
                                            ln_moneda, 
                                            ln_papel,
                                            ln_cuenta,
                                            ln_operac,                                                  
                                            ln_subope,
                                            ln_tipope,
                                            fn_reprog,
                                            ln_primtotsegur,
                                            fechaInicio,
                                            fechaFin,
                                            ln_numpol,
                                            ln_tasa,
                                            ln_prim_tot,
                                            ln_plan,
                                            ln_pepais,
                                            ln_petdoc,
                                            ln_nrodoc,
                                            ln_tip_pers,
                                            ln_sex,
                                            ln_fec_nac,
                                            ln_ape_pat,
                                            ln_ape_mat,
                                            ln_nombres,
                                            ln_razsoc,
                                            ln_sum_asegurda,
                                            fn_reprog,
                                            ln_perid_grc,
                                            ln_periodic,
                                            ln_prim_tot,
                                            ln_fech_primer_pag,
                                            ln_estd_cred,
                                            ln_fech_primer_pag,
                                            lc_telefono,
                                            lc_correo,
                                            ln_sucursal,
                                            ln_scnom,
                                            ln_mosign,
                                            esreprog,
                                            ln_tipdoc_desc,
                                            fechaFin);
                                            COMMIT;
                                    exception
                                      when dup_val_on_index then
                                        null;
                                    end ;       
                      
                          END IF;      
                  END IF;       
      END LOOP;           
      
    END carga_aqpa833;

end pq_cred_rep_reprog_seguros;
/

