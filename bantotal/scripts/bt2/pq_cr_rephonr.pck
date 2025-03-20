CREATE OR REPLACE PACKAGE PQ_CR_REPHONR
    -- *****************************************************************
    -- Nombre                     : PQ_CR_REPHONR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/02/2022
    -- Autor de Creación          : ALDO MAMANI
    -- Uso                        : UNIFICAR COMPONENTES PARA LA GENERACIÓN
    --                              DEL REPORTE DE CRÉDITOS HONRADOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificación      : 03/10/2022
    -- Autor de la Modificación   : Rcastro
    -- Descripción de Modificación: Mejoras de reporte de honramiento.
    -- Fecha de Modificación      : 16/11/2022
    -- Autor de la Modificación   : Rcastro
    -- Descripción de Modificación: Se adiciona campo Interes compensatorio Honrado.
    -- *****************************************************************************
IS
------------------------------------------------------
PROCEDURE SP_CR_REPHONRDR(p_usr IN char,
                          p_fec IN date);
------------------------------------------------------
PROCEDURE SP_CR_REPHONRHS(p_usr IN char,
                          p_fecIni in date, 
                          p_fecFin  IN date,
                          suc_job in number);
------------------------------------------------------
PROCEDURE SP_CR_LIMPIAREPHONR(p_usr IN char);
------------------------------------------------------
PROCEDURE SP_CR_REPHONRLOG(p_pgm IN varchar2,
                           p_usr IN varchar2,
                           p_fec IN date,
                           p_hri IN varchar2,
                           p_hrf IN varchar2);
---------------------------------------------------------- 
PROCEDURE SP_CR_REPHONRDIARIO(p_usr IN char,p_fec IN date);
----------------------------------------------------------

PROCEDURE SP_CR_BUSCARTEMP152(pUbuser char, fechaApert date, p_fecIni in date, 
                              p_fecFin  IN date, flgExisteReg out varchar2);
------------------------------------------------------------
                             
-----------------------------------------------------------
PROCEDURE sp_validar_extorn_dia(p_usr char, p_fecapertura date);  
-------------------------------------------------------------
PROCEDURE SP_JOBS_CARG_AQPC152(PC_USR varchar2, fechaIni in date, fechaFin in date);   

                         
                          
END PQ_CR_REPHONR;
/

create or replace package body PQ_CR_REPHONR is

  --------------------------------------------
  PROCEDURE SP_CR_REPHONRDR(p_usr IN char,p_fec IN date)
  IS
  cursor c_obtiene_trx is         
           select distinct h.pgcod, -- OBTIENE TRANSACCIONES A RECORRER, LEYENDO LA TABLA BASE434 
                     h.moneda,
                     h.papel,
                     h.ctnro,
                     h.itoper,
                     h.itmod,
                     h.ittran,
                     h.itsuc,
                     h.itnrel
               from  fsd016 h , fst198 g, fsd015 f, AQPB434 e
               
               WHERE 
                      g.tp1cod = 1
                      and g.tp1cod1 = 11123
                      and g.tp1corr1 = 10
                      and g.tp1corr2 = 4
                      
                      and f.pgcod = g.tp1cod
                      and f.itmod = g.tp1nro1
                      and f.ittran = g.tp1nro2    
                      and f.itcont = 'S'            
                      and f.itfcon = p_fec                                 
               
                      and h.pgcod = e.aqpb434cod
                      and h.ctnro = e.aqpb434cta
                      and h.itoper = e.aqpb434ope
                      and h.moneda = e.aqpb434mda
                      and e.aqpb434est = 'C'
               
                      and h.pgcod = f.pgcod
                      and h.itsuc = f.itsuc
                      and h.itmod = f.itmod
                      and h.ittran = f.ittran
                      and h.itnrel = f.itnrel 
                      and h.itord in (g.tp1imp1,g.tp1imp2,g.tp1imp3);
                
                                      
  cursor c_obtiene_importes(p_pgcod in number, p_itmod in number,p_ittran in number,p_itsuc in number,p_itnrel in number)
            is
               select  f_pag,itmod,ittran,itsuc,itnrel,
              sum(decode(tp1nro3,1,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) capital,
              sum(decode(tp1nro3,2,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) interes,
              sum(decode(tp1nro3,3,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) icv, 
              sum(decode(tp1nro3,4,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mora,   
              sum(decode(tp1nro3,5,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) penalidad,
              sum(decode(tp1nro3,6,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) oro,
              sum(decode(tp1nro3,7,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) seguro,
              sum(decode(tp1nro3,8,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) gasto,
              sum(decode(tp1nro3,9,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntHonr,
              sum(decode(tp1nro3,10,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) intMont,
              sum(decode(tp1nro3,11,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntRec,
              sum(decode(tp1nro3,11,(rubrorec/cont),0)) rubrorc,
              sum(decode(tp1nro3,12,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntICH --rcastro 16/11/2022
              from
              (select g.tp1nro3,h.itmod,g.tp1imp2,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
              sum(h.itimp1) monto, sum(h.itimp2) monto2, sum(h.itimp3) monto3, sum(h.itimp4) monto4, sum(h.itimp5) monto5, sum(h.rubro) rubrorec,count(*) cont
              from
              fsd016 h
              inner join fst198 g ON
              g.tp1cod = 1
              and g.tp1cod1 = 11123
              and g.tp1corr1 = 10
              and g.tp1corr2 = 1                 
              and  h.itmod = g.tp1nro1
              and h.ittran = g.tp1nro2
              and h.itord = g.tp1imp1 
     
              inner join fsd015 f
              on  f.pgcod = h.pgcod
              and f.itsuc = h.itsuc
              and f.itmod = h.itmod
              and f.ittran = h.ittran
              and f.itnrel = h.itnrel            
              where f.pgcod = p_pgcod
              and f.itmod = p_itmod
              and f.ittran = p_ittran
              and f.itsuc = p_itsuc
              and f.itnrel = p_itnrel
              and f.itcont = 'S'
              and h.itanu = 'N'
              group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp2)
              group by f_pag,itmod,ittran,itsuc,itnrel;
                  
    ln_corr NUMBER(9);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_cap  NUMBER(17,2);
    ln_itp  NUMBER(17,2);
    ln_icv  NUMBER(17,2);
    ln_mor  NUMBER(17,2);
    ln_pen  NUMBER(17,2);
    ln_oro  NUMBER(17,2);
    ln_seg  NUMBER(17,2);
    ln_gst  NUMBER(17,2);
    ln_mth  NUMBER(17,2);
    ln_itm  NUMBER(17,2);
    ln_mtr  NUMBER(17,2);
    ln_rubro NUMBER(16); 
    ln_prog CHAR(2);
    ln_fecH DATE;
    ln_tipP CHAR(1);
    ln_pais NUMBER(3);
    ln_tipD NUMBER(2);
    ln_numD CHAR(12);
    ln_nom  CHAR(30);
    ln_ape1 CHAR(30);
    ln_ape2 CHAR(30);  
    ln_raz CHAR(70);
    ln_itc NUMBER(5);
    ln_ext CHAR(2);
    ln_estp CHAR(30);
    lc_coderr VARCHAR2(500);
    lc_msgerr VARCHAR2(500);
    ln_fpag DATE;
    ln_ich number(17,2);                                                                                                                                                                                                                                                                              
  BEGIN           
    BEGIN           
        
        FOR c in c_obtiene_trx LOOP
            FOR y in c_obtiene_importes(c.pgcod,c.itmod,c.ittran,c.itsuc,c.itnrel) LOOP
                ln_cta := c.ctnro; 
                ln_ope := c.itoper;
                ln_cap := y.capital;
                ln_itp := y.interes;
                ln_icv := y.icv;
                ln_mor := y.mora;
                ln_pen := y.penalidad;
                ln_oro := y.oro;
                ln_seg := y.seguro;
                ln_gst := y.gasto;
                ln_mth := y.mntHonr;
                ln_itm := y.intMont;
                ln_mtr := y.mntRec;
                ln_rubro := y.rubrorc;
                ln_fpag := y.f_pag;
                ln_ich  := y.mntich;
            END LOOP;
                BEGIN
                   --obtener Correlativo por usuario 
                   BEGIN
                     SELECT nvl(max(t.aqpc151corr),0)--nvl(max(t.aqpc151corr),0) + 1  -- BUSCAR EL MAX para complemnt del día
                     INTO ln_corr
                     FROM aqpc151 t
                     WHERE aqpc151usr = p_usr;
                   EXCEPTION
                        WHEN no_data_found THEN
                        ln_corr := 0;
                   END;
                   
                   --Obtiene Fecha Honramiento y Programa
                   BEGIN
                     SELECT a.aqpb434tip,a.aqpb434itfcon INTO ln_prog,ln_fecH                  
                     FROM AQPB434 a                 
                     WHERE a.aqpb434cod = c.pgcod              
                     and a.aqpb434mda = c.moneda
                     and a.aqpb434cta = ln_cta
                     and a.aqpb434ope = ln_ope                 
                     and a.aqpb434est = 'C';
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_prog:= '';
                          ln_fecH := '';
                   END;
                   
                   --Inicializa Variables
                   ln_tipP := null;
                   ln_nom  := null;
                   ln_pais := null;
                   ln_tipD := null;
                   ln_numD := null;
                   ln_ape1 := null;
                   ln_ape2 := null;
                   ln_raz  := null;
                   ln_itc  := null;                 
                   ln_estp := null;
                   ln_ext := null;
                   
                   --Obtiene Datos de la Persona
                   BEGIN
                     SELECT p.Tdtval,g.penom,b.pepais,b.petdoc,b.pendoc INTO ln_tipP,ln_nom,ln_pais,ln_tipD,ln_numD 
                     FROM FSR008 b
                     INNER JOIN FST014 p
                     ON p.tdocum = b.petdoc
                     INNER JOIN FSD001 g 
                     ON g.Pepais = b.Pepais
                     and g.Petdoc = b.Petdoc
                     and g.Pendoc = b.Pendoc                            
                     WHERE b.Pgcod = c.pgcod 
                     and b.ctnro = ln_cta
                     and b.Cttfir = 'T';
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_tipP := '';
                          ln_nom  := '';
                          ln_pais  := 0;
                          ln_tipD  := 0;
                          ln_numD  := '';
                   END;
                   
                   IF ln_tipP = 'F' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT e.Pfape1,e.Pfape2,e.pfnom1 INTO ln_ape1,ln_ape2,ln_nom
                      FROM FSD002 e
                      WHERE e.pfpais = ln_pais                       
                      and e.pftdoc = ln_tipD
                      and e.pfndoc = ln_numD;                                     
                      EXCEPTION
                        WHEN no_data_found THEN
                          ln_ape1 := '';
                          ln_ape2 := '';
                          ln_nom := '';
                      END;
                   END IF;
                   
                   IF ln_tipP = 'J' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT r.pjrazs INTO ln_raz
                      FROM FSD003 r
                      WHERE r.pjpais = ln_pais
                      and r.pjtdoc = ln_tipD
                      and r.pjndoc = ln_numD;
                     EXCEPTION
                        WHEN no_data_found THEN
                          ln_raz := '';
                     END;
                   END IF; 
                   
                   --Obtiene Extorno
                   BEGIN 
                     SELECT n.Itcorr INTO ln_itc
                     FROM FSD015 n
                     WHERE n.pgcod = c.pgcod
                     and n.itsuc = c.itsuc
                     and n.itmod = c.itmod
                     and n.ittran = c.ittran
                     and n.itnrel = c.itnrel;
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_itc := 0;
                   END;
                   
                   IF ln_itc = 99 THEN
                     ln_ext := 'SI';
                   ELSE
                     ln_ext := null;
                   END IF;
                    
                   --Obtiene Estado
                   BEGIN 
                     SELECT u.tp1desc INTO ln_estp
                     FROM FST198 u
                     WHERE u.tp1cod = c.pgcod
                     and u.tp1cod1 = 11123
                     and u.tp1corr1 = 10
                     and u.tp1corr2 = 2
                     and u.tp1nro1 = c.itmod
                     and u.tp1nro2 = c.ittran;
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_estp := '';
                   END;
                   BEGIN                                                                                                                                                                                                                          
                     INSERT INTO aqpc151(
                      aqpc151usr  ,-- Usuario
                      aqpc151corr ,-- Correlativo
                      aqpc151cta  ,-- Cuenta
                      aqpc151ope  ,-- Operación
                      aqpc151feh  ,-- Fecha de Honramiento
                      aqpc151pro  ,-- Programa
                      aqpc151mda  ,-- Moneda
                      aqpc151tdc  ,-- Tipo de Documento
                      aqpc151ndc  ,-- Número de Documento
                      aqpc151rzs  ,-- Razón Social
                      aqpc151apt  ,-- Apellido Paterno
                      aqpc151amt  ,-- Apellido Materno
                      aqpc151nom  ,-- Nombre 
                      aqpc151ext  ,-- Extorno
                      aqpc151est  ,-- Estado de Pago
                      aqpc151fep  ,-- Fecha de Pago
                      aqpc151cap  ,-- Capital Pagado
                      aqpc151itp  ,-- Interés Pagado
                      aqpc151icv  ,-- ICV Pagado
                      aqpc151mor  ,-- Mora Pagada
                      aqpc151pen  ,-- Penalidad Pagada
                      aqpc151oro  ,-- Otros Rubros de la Obligación
                      aqpc151seg  ,-- Seguro Pagado
                      aqpc151gst  ,-- Gasto RL Honramiento
                      aqpc151mth  ,-- Monto Honrado Pagado
                      aqpc151itm  ,-- Interés Moratorio
                      aqpc151rub  ,-- Rubro Recaudadora para Cofide
                      aqpc151mtr  ,-- Monto Recaudado Cofide
                      aqpc151ich
                     ) VALUES(
                        p_usr,   -- Usuario
                        ln_corr, -- Correlativo
                        ln_cta,  -- Cuenta
                        ln_ope,  -- Operación
                        ln_fecH, -- Fecha de Honramiento
                        ln_prog, -- Programa
                        c.moneda,-- Moneda
                        ln_tipD, -- Tipo de Documento
                        ln_numD, -- Número de Documento
                        ln_raz,  -- Razón Social
                        ln_ape1, -- Apellido Paterno
                        ln_ape2, -- Apellido Materno
                        ln_nom,  -- Nombre
                        ln_ext,  -- Extorno
                        ln_estp, -- Estado de Pago
                        ln_fpag, -- Fecha de Pago 
                        ln_cap,  -- Capital Pagado
                        ln_itp,  -- Interés Pagado
                        ln_icv,  -- ICV Pagado
                        ln_mor,  -- Mora Pagada
                        ln_pen,  -- Penalidad Pagada
                        ln_oro,  -- Otros Rubros de la Obligación
                        ln_seg,  -- Seguro Pagado
                        ln_gst,  -- Gasto RL Honramiento
                        ln_mth,  -- Monto Honrado Pagado
                        ln_itm,  -- Interés Moratorio
                        ln_rubro,-- Rubro Recaudadora para Cofide
                        ln_mtr  , -- Monto Recaudado Cofide
                        ln_ich
                     );
                     COMMIT;
                   EXCEPTION 
                   WHEN OTHERS THEN
                    NULL;
                   END;  
                   
                EXCEPTION
                  WHEN no_data_found THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                  WHEN OTHERS THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;             
                END;                      
        END LOOP;
     END;  
  END SP_CR_REPHONRDR;  
  ------------------------------------------------
   PROCEDURE SP_CR_REPHONRHS(p_usr IN char,p_fecIni in date, p_fecFin  IN date, suc_job in number) --rcastro
  IS
  cursor c_obtiene_trx(auxFecIni date, auxFecFin date) is                                                                                                        
            select  /*+ all_rows index(f SYS_C00977884)*/ distinct f.pgcod, -- OBTIENE TRANSACCIONES A RECORRER 
                     f.hcmod,
                     f.htran,
                     f.hsucor,
                     f.hnrel,
                     f.hfcon
               from fsh016 h, fst198 g , fsh015 f 
               where      g.tp1cod = 1                          
                          and g.tp1cod1 = 11123
                          and g.tp1corr1 = 10
                          and g.tp1corr2 = 2

                          and h.pgcod = f.pgcod
                          and h.hcmod = f.hcmod
                          and h.hsucor = f.hsucor                               
                          and h.htran = f.htran
                          and h.hnrel = f.hnrel
                          and h.hfcon = f.hfcon               

                          and f.pgcod = g.tp1cod
                          AND f.hcmod = g.tp1nro1
                          AND f.hsucor = suc_job --add
                          and f.htran = g.tp1nro2  
                          and f.hnrel = h.hnrel                                                             
                       
                    and   f.hfcon > auxFecIni AND f.HFCON < auxFecFin;                                                     
       -------------                                 
                                      
       cursor c_obtiene_importes(p_pgcod in number, p_itmod in number,p_ittran in number,p_itsuc in number,p_itnrel in number, p_fcon in date)--rcastro 03/10/2022
            is
              select  /*+ all_rows index_ss(l) */  f_pag, hcmod, htran, hsucor, hnrel,
              sum(decode(tp1nro3,1,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) capital,
              sum(decode(tp1nro3,2,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) interes,
              sum(decode(tp1nro3,3,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) icv, 
              sum(decode(tp1nro3,4,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mora,   
              sum(decode(tp1nro3,5,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) penalidad,
              sum(decode(tp1nro3,6,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) oro,
              sum(decode(tp1nro3,7,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) seguro,
              sum(decode(tp1nro3,8,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) gasto,
              sum(decode(tp1nro3,9,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntHonr,
              sum(decode(tp1nro3,10,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) intMont,
              sum(decode(tp1nro3,11,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntRec,
              sum(decode(tp1nro3,11,(rubrorec/cont),0)) rubrorc,
              sum(decode(tp1nro3,12,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntICH --rcastro 16/11/2022
              from
              (select g.tp1nro3,h.hcmod,g.tp1imp2,h.htran,h.hsucor,h.hnrel,f.hfcon as f_pag,
              sum(h.hcimp1) monto, sum(h.hcimp2) monto2, sum(h.hcimp3) monto3, sum(h.hcimp4) monto4, sum(h.hcimp5) monto5, sum(h.hrubro) rubrorec,count(*) cont
              from 
              fsh016 h,  fsh015 f, fst198 g
              where  g.tp1cod = 1
                     and g.tp1cod1 = 11123
                     and g.tp1corr1 = 10
                     and g.tp1corr2 = 1 

                     and g.tp1nro1 = f.hcmod  
                     and g.tp1nro2 = f.htran 
                     
                     and h.pgcod = f.pgcod
                     and h.hcmod = f.hcmod
                     and h.hsucor = f.hsucor              
                     and h.htran = f.htran
                     and h.hnrel = f.hnrel
                     and h.hfcon = f.hfcon
                     and h.hcord = g.tp1imp1 
                     
                     and f.pgcod = p_pgcod
                     and f.hcmod = p_itmod
                     and f.hsucor = p_itsuc              
                     and f.htran = p_ittran
                     and f.hnrel = p_itnrel
                     and f.hfcon =  p_fcon      
              group by g.tp1nro3,h.hcmod,g.tp1imp2,h.htran,h.hsucor,h.hnrel,f.hfcon)
              group by f_pag,hcmod,htran,hsucor,hnrel;
                                   
                  
    ln_corr NUMBER(9);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_mda  NUMBER(4);
    ln_cap  NUMBER(17,2);
    ln_itp  NUMBER(17,2);
    ln_icv  NUMBER(17,2);
    ln_mor  NUMBER(17,2);
    ln_pen  NUMBER(17,2);
    ln_oro  NUMBER(17,2);
    ln_seg  NUMBER(17,2);
    ln_gst  NUMBER(17,2);
    ln_mth  NUMBER(17,2);
    ln_itm  NUMBER(17,2);
    ln_mtr  NUMBER(17,2);
    ln_rubro NUMBER(16); 
    ln_prog CHAR(2);
    ln_fecH DATE;
    ln_tipP CHAR(1);
    ln_pais NUMBER(3);
    ln_tipD NUMBER(2);
    ln_numD CHAR(12);
    ln_nom  CHAR(30);
    ln_ape1 CHAR(30);
    ln_ape2 CHAR(30);  
    ln_raz CHAR(70);
    ln_itc NUMBER(5);
    ln_ext CHAR(2);
    ln_estp CHAR(30);
    lc_coderr VARCHAR2(500);
    lc_msgerr VARCHAR2(500);
    ln_fpag DATE;   
    auxFecIni date;
    auxFecFin date;  
    ln_estasi VARCHAR2(1);
    ln_fechactual date;
    ln_ICH number(17,2);--RCASTRO 16/11/2022                                                                                                                                                                                                                                                                           
  BEGIN           
    BEGIN            
        auxFecIni := p_fecIni - 1; -- rcastro 3/10
        auxFecFin := p_fecFin + 1;
        ln_fechactual := to_date(sysdate, 'DD/MM/RRRR');
        
        FOR c in c_obtiene_trx(auxFecIni, auxFecFin) LOOP
            FOR y in c_obtiene_importes(c.pgcod,c.hcmod,c.htran,c.hsucor,c.hnrel, c.hfcon) LOOP
              
                ln_cap := y.capital;
                ln_itp := y.interes;
                ln_icv := y.icv;
                ln_mor := y.mora;
                ln_pen := y.penalidad;
                ln_oro := y.oro;
                ln_seg := y.seguro;
                ln_gst := y.gasto;
                ln_mth := y.mntHonr;
                ln_itm := y.intMont;
                ln_mtr := y.mntRec;
                ln_rubro := y.rubrorc;
                ln_fpag := y.f_pag;
                ln_ICH  := y.mntICH; --Rcastro 16/11/2022
                
                   --Inicializa Variables
                   ln_cta := null; 
                   ln_ope := null;
                   ln_mda := null;
                   ln_itc := null;
                   ln_ext := null;
                   
                   --Obtener Crédito y Extorno
                   BEGIN
                       SELECT /*+all_rows index_ss(l)*/ t.hcta, t.hoper, t.hmda, p.hccorr INTO ln_cta,ln_ope,ln_mda,ln_itc
                       FROM FSH015 p, FSH016 t, fst198 g 
                       
                       WHERE      g.tp1cod = 1
                                  and g.tp1cod1 = 11123
                                  and g.tp1corr1 = 10
                                  and g.tp1corr2 = 4
                                  
                                  and p.pgcod = g.tp1cod
                                  and p.hcmod = g.tp1nro1                  
                                  and p.htran = g.tp1nro2
                                  
                                  and t.pgcod = p.pgcod
                                  and t.hcmod = p.hcmod
                                  and t.hsucor = p.hsucor
                                  and t.htran = p.htran
                                  and t.hnrel = p.hnrel
                                  and t.hfcon = p.hfcon
                                  and t.hcord in (g.tp1imp1,g.tp1imp2,g.tp1imp3)
                                  
                                  and p.pgcod = c.pgcod
                                  and p.hcmod = c.hcmod
                                  and p.hsucor = c.hsucor
                                  and p.htran = c.htran
                                  and p.hnrel = c.hnrel
                                  and p.hfcon = c.hfcon;   
                   EXCEPTION
                      WHEN no_data_found THEN   
                        ln_cta := 0;
                        ln_ope := 0;
                        ln_mda := 0;
                        ln_itc := 0;            
                   END;                      
                   IF ln_itc = 99 THEN
                     ln_ext := 'SI';
                     ln_estasi := 'E';
                   ELSE
                     ln_ext := null;
                     ln_estasi := 'S';
                   END IF;                                                                                  
            END LOOP;
                BEGIN
                   --Genera Correlativo por usuario
                   /*BEGIN
                     SELECT nvl(max(t.aqpc151corr),0) + 1
                     INTO ln_corr
                     FROM aqpc151 t
                     WHERE aqpc151usr = p_usr;
                   EXCEPTION
                   WHEN no_data_found THEN
                        ln_corr := 0;
                   END; */
                   
                   --Obtiene Fecha Honramiento y Programa
                   BEGIN
                     SELECT a.aqpb434tip,a.aqpb434itfcon INTO ln_prog,ln_fecH                  
                     FROM  AQPB434 a                 
                     WHERE a.aqpb434cod = c.pgcod              
                     and a.aqpb434cta = ln_cta
                     and a.aqpb434ope = ln_ope
                     and a.aqpb434mda = ln_mda                                                       
                     and a.aqpb434est = 'C';
                   EXCEPTION
                   WHEN no_data_found THEN
                        ln_prog := '';
                        ln_fecH := '';
                   END;
                   
                   --Inicializa Variables
                   ln_tipP := null;
                   ln_nom  := null;
                   ln_pais := null;
                   ln_tipD := null;
                   ln_numD := null;
                   ln_ape1 := null;
                   ln_ape2 := null;
                   ln_raz  := null;              
                   ln_estp := null;
                   
                   --Obtiene Datos de la Persona
                   BEGIN 
                     SELECT p.Tdtval,g.penom,b.pepais,b.petdoc,b.pendoc INTO ln_tipP,ln_nom,ln_pais,ln_tipD,ln_numD 
                     FROM FSR008 b
                     INNER JOIN FST014 p
                     ON p.tdocum = b.petdoc
                     INNER JOIN FSD001 g 
                     ON g.Pepais = b.Pepais
                     and g.Petdoc = b.Petdoc
                     and g.Pendoc = b.Pendoc                            
                     WHERE b.Pgcod = c.pgcod 
                     and b.ctnro = ln_cta
                     and b.Cttfir = 'T';
                   EXCEPTION
                   WHEN no_data_found THEN
                        ln_tipP := '';
                        ln_nom := '';
                        ln_pais:= 0;
                        ln_tipD := 0;
                        ln_numD := 0;
                   END;
                   
                   IF ln_tipP = 'F' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT e.Pfape1,e.Pfape2 INTO ln_ape1,ln_ape2
                      FROM FSD002 e
                      WHERE e.pfpais = ln_pais                       
                      and e.pftdoc = ln_tipD
                      and e.pfndoc = ln_numD; 
                     EXCEPTION
                        WHEN no_data_found THEN
                          ln_ape1 := '';
                          ln_ape2 := '';
                     END;                                    
                   END IF;
                   
                   IF ln_tipP = 'J' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT r.pjrazs INTO ln_raz
                      FROM FSD003 r
                      WHERE r.pjpais = ln_pais
                      and r.pjtdoc = ln_tipD
                      and r.pjndoc = ln_numD;
                     EXCEPTION
                        WHEN no_data_found THEN
                          ln_raz:= '';
                     END;
                   END IF;                  
                                                     
                   --Obtiene Estado
                   BEGIN
                     SELECT u.tp1desc INTO ln_estp
                     FROM FST198 u
                     WHERE u.tp1cod = c.pgcod
                     and u.tp1cod1 = 11123
                     and u.tp1corr1 = 10
                     and u.tp1corr2 = 2
                     and u.tp1nro1 = c.hcmod
                     and u.tp1nro2 = c.htran;
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_estp := '';
                   END;
                   
                   
                    BEGIN                                                                                                                                                                                                                      
                   INSERT INTO aqpc152(
                    aqpc152pgcod,
                    aqpc152suc  ,
                    aqpc152mod  ,
                    aqpc152tran  ,
                    aqpc152nrel ,
                    aqpc152fcont,
                    aqpc152fec,
                    aqpc152cta  ,-- Cuenta
                    aqpc152ope  ,-- Operación
                    aqpc152feh  ,-- Fecha de Honramiento
                    aqpc152pro  ,-- Programa
                    aqpc152mda  ,-- Moneda
                    aqpc152tdc  ,-- Tipo de Documento
                    aqpc152ndc  ,-- Número de Documento
                    aqpc152rzs  ,-- Razón Social
                    aqpc152apt  ,-- Apellido Paterno
                    aqpc152amt  ,-- Apellido Materno
                    aqpc152nom  ,-- Nombre 
                    aqpc152ext  ,-- Extorno
                    aqpc152est  ,-- Estado de Pago
                    aqpc152fep  ,-- Fecha de Pago
                    aqpc152cap  ,-- Capital Pagado
                    aqpc152itp  ,-- Interés Pagado
                    aqpc152icv  ,-- ICV Pagado
                    aqpc152mor  ,-- Mora Pagada
                    aqpc152pen  ,-- Penalidad Pagada
                    aqpc152oro  ,-- Otros Rubros de la Obligación
                    aqpc152seg  ,-- Seguro Pagado
                    aqpc152gst  ,-- Gasto RL Honramiento
                    aqpc152mth  ,-- Monto Honrado Pagado
                    aqpc152itm  ,-- Interés Moratorio
                    aqpc152rub  ,-- Rubro Recaudadora para Cofide
                    aqpc152mtr  , -- Monto Recaudado Cofide   
                    AQPC152ESTASI,
                    AQPC152USRACT,
                    AQPC152FECACT,
                    AQPC152ICH  --Interés compensario de Honramiento  --RCASTRO 16/11/2022                                                                                             
                   ) VALUES(
                      c.pgcod,
                      c.hsucor,
                      c.hcmod,
                      c.htran,
                      c.hnrel,
                      c.hfcon,
                      ln_fechactual,                                  
                      ln_cta,  -- Cuenta                                              
                      ln_ope,  -- Operación
                      ln_fecH, -- Fecha de Honramiento                           
                      ln_prog, -- Programa
                      ln_mda,  -- Moneda
                      ln_tipD, -- Tipo de Documento
                      ln_numD, -- Número de Documento
                      ln_raz,  -- Razón Social
                      ln_ape1, -- Apellido Paterno
                      ln_ape2, -- Apellido Materno
                      ln_nom,  -- Nombre
                      ln_ext,  -- Extorno
                      ln_estp, -- Estado de Pago
                      ln_fpag, -- Fecha de Pago 
                      ln_cap,  -- Capital Pagado
                      ln_itp,  -- Interés Pagado
                      ln_icv,  -- ICV Pagado
                      ln_mor,  -- Mora Pagada
                      ln_pen,  -- Penalidad Pagada
                      ln_oro,  -- Otros Rubros de la Obligación
                      ln_seg,  -- Seguro Pagado
                      ln_gst,  -- Gasto RL Honramiento
                      ln_mth,  -- Monto Honrado Pagado
                      ln_itm,  -- Interés Moratorio
                      ln_rubro,-- Rubro Recaudadora para Cofide
                      ln_mtr,   -- Monto Recaudado Cofide
                      ln_estasi,
                      p_usr,
                      ln_fechactual,
                      ln_ICH--RCASTRO 16/11/2022
                   );
                   COMMIT;
                EXCEPTION 
                WHEN OTHERS THEN
                   NULL;
                END;  
                        
                EXCEPTION
                  WHEN no_data_found THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                  WHEN OTHERS THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;             
                END;                      
        END LOOP;
     END;  
  END SP_CR_REPHONRHS;
  -------------------------------------------------------------
  PROCEDURE SP_CR_LIMPIAREPHONR(p_usr IN char)
  IS                                                                                                                                                                                                                                                                                
  BEGIN
    DELETE FROM aqpc151 a WHERE a.aqpc151usr = p_usr;
    COMMIT; 
  END SP_CR_LIMPIAREPHONR;  
  -------------------------------------------------------------
  PROCEDURE SP_CR_REPHONRLOG(p_pgm IN varchar2,p_usr IN varchar2,p_fec IN date,p_hri IN varchar2,p_hrf IN varchar2)
  IS                                                                                                                                                                                                                                                                                
  BEGIN
    BEGIN
        PQ_CR_JAQL975_LogReporte.fn_cr_inserta(p_pgm,p_usr,p_fec,p_hri,p_hrf);
    END; 
  END SP_CR_REPHONRLOG;
  -------------------------------------------------------------     
  
  PROCEDURE SP_CR_REPHONRDIARIO(p_usr IN char,p_fec IN date)  IS
  cursor c_obtiene_trx is         
           select distinct h.pgcod, -- OBTIENE TRANSACCIONES A RECORRER, LEYENDO LA TABLA BASE434 
                     h.moneda,
                     h.papel,
                     h.ctnro,
                     h.itoper,
                     h.itmod,
                     h.ittran,
                     h.itsuc,
                     h.itnrel,
                     f.itfcon,
                     f.itcont
               from  fsd016 h , fst198 g, fsd015 f, AQPB434 e
               
               WHERE 
                      g.tp1cod = 1
                      and g.tp1cod1 = 11123
                      and g.tp1corr1 = 10
                      and g.tp1corr2 = 4
                      
                      and f.pgcod = g.tp1cod
                      and f.itmod = g.tp1nro1
                      and f.ittran = g.tp1nro2    
                      and f.itcont = 'S'            
                      and f.itfcon = p_fec                                 
               
                      and h.pgcod = e.aqpb434cod
                      and h.ctnro = e.aqpb434cta
                      and h.itoper = e.aqpb434ope
                      and h.moneda = e.aqpb434mda
                      and e.aqpb434est = 'C'
               
                      and h.pgcod = f.pgcod
                      and h.itsuc = f.itsuc
                      and h.itmod = f.itmod
                      and h.ittran = f.ittran
                      and h.itnrel = f.itnrel 
                      and h.itord in (g.tp1imp1,g.tp1imp2,g.tp1imp3);
                
                                      
  cursor c_obtiene_importes(p_pgcod in number, p_itmod in number,p_ittran in number,p_itsuc in number,p_itnrel in number)
            is
               select  f_pag,itmod,ittran,itsuc,itnrel,
              sum(decode(tp1nro3,1,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) capital,
              sum(decode(tp1nro3,2,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) interes,
              sum(decode(tp1nro3,3,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) icv, 
              sum(decode(tp1nro3,4,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mora,   
              sum(decode(tp1nro3,5,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) penalidad,
              sum(decode(tp1nro3,6,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) oro,
              sum(decode(tp1nro3,7,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) seguro,
              sum(decode(tp1nro3,8,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) gasto,
              sum(decode(tp1nro3,9,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntHonr,
              sum(decode(tp1nro3,10,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) intMont,
              sum(decode(tp1nro3,11,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntRec,
              sum(decode(tp1nro3,11,(rubrorec/cont),0)) rubrorc,
              sum(decode(tp1nro3,12,decode(tp1imp2,1,(monto/cont),0),2,decode(tp1imp2,2,(monto2/cont),0),3,decode(tp1imp2,3,(monto3/cont),0),4,decode(tp1imp2,4,(monto4/cont),0),5,decode(tp1imp2,5,(monto5/cont),0))) mntICH --rcastro 16/11/2022
              from
              (select g.tp1nro3,h.itmod,g.tp1imp2,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
              sum(h.itimp1) monto, sum(h.itimp2) monto2, sum(h.itimp3) monto3, sum(h.itimp4) monto4, sum(h.itimp5) monto5, sum(h.rubro) rubrorec,count(*) cont
              from
              fsd016 h
              inner join fst198 g ON
              g.tp1cod = 1
              and g.tp1cod1 = 11123
              and g.tp1corr1 = 10
              and g.tp1corr2 = 1                 
              and  h.itmod = g.tp1nro1
              and h.ittran = g.tp1nro2
              and h.itord = g.tp1imp1 
     
              inner join fsd015 f
              on  f.pgcod = h.pgcod
              and f.itsuc = h.itsuc
              and f.itmod = h.itmod
              and f.ittran = h.ittran
              and f.itnrel = h.itnrel            
              where f.pgcod = p_pgcod
              and f.itmod = p_itmod
              and f.ittran = p_ittran
              and f.itsuc = p_itsuc
              and f.itnrel = p_itnrel
              and f.itcont = 'S'
              and h.itanu = 'N'
              group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp2)
              group by f_pag,itmod,ittran,itsuc,itnrel;
                  
    ln_corr NUMBER(9);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_cap  NUMBER(17,2);
    ln_itp  NUMBER(17,2);
    ln_icv  NUMBER(17,2);
    ln_mor  NUMBER(17,2);
    ln_pen  NUMBER(17,2);
    ln_oro  NUMBER(17,2);
    ln_seg  NUMBER(17,2);
    ln_gst  NUMBER(17,2);
    ln_mth  NUMBER(17,2);
    ln_itm  NUMBER(17,2);
    ln_mtr  NUMBER(17,2);
    ln_rubro NUMBER(16); 
    ln_prog CHAR(2);
    ln_fecH DATE;
    ln_tipP CHAR(1);
    ln_pais NUMBER(3);
    ln_tipD NUMBER(2);
    ln_numD CHAR(12);
    ln_nom  CHAR(30);
    ln_ape1 CHAR(30);
    ln_ape2 CHAR(30);  
    ln_raz CHAR(70);
    ln_itc NUMBER(5);
    ln_ext CHAR(2);
    ln_estp CHAR(30);
    lc_coderr VARCHAR2(500);
    lc_msgerr VARCHAR2(500);
    ln_fpag DATE;      
    ln_estasi VARCHAR2(1); 
    ln_ICH number(17,2); --RCASTRO 16/11/2022                                                                                                                                                                                                                                                                       
  BEGIN           
    BEGIN           
        
        FOR c in c_obtiene_trx LOOP
            FOR y in c_obtiene_importes(c.pgcod,c.itmod,c.ittran,c.itsuc,c.itnrel) LOOP
                ln_cta := c.ctnro; 
                ln_ope := c.itoper;
                ln_cap := y.capital;
                ln_itp := y.interes;
                ln_icv := y.icv;
                ln_mor := y.mora;
                ln_pen := y.penalidad;
                ln_oro := y.oro;
                ln_seg := y.seguro;
                ln_gst := y.gasto;
                ln_mth := y.mntHonr;
                ln_itm := y.intMont;
                ln_mtr := y.mntRec;
                ln_rubro := y.rubrorc;
                ln_fpag := y.f_pag;
                ln_ICH  := Y.MNTICH; --RCASTRO 16/11/2022 
            END LOOP;
                BEGIN
                   --Genera Correlativo por usuario
                   /*BEGIN
                     SELECT nvl(max(t.aqpc151corr),0) + 1
                     INTO ln_corr
                     FROM aqpc151 t
                     WHERE aqpc151usr = p_usr;
                   EXCEPTION
                        WHEN no_data_found THEN
                        ln_corr := 0;
                   END;*/
                   
                   --Obtiene Fecha Honramiento y Programa
                   BEGIN
                     SELECT a.aqpb434tip,a.aqpb434itfcon INTO ln_prog,ln_fecH                  
                     FROM AQPB434 a                 
                     WHERE a.aqpb434cod = c.pgcod              
                     and a.aqpb434mda = c.moneda
                     and a.aqpb434cta = ln_cta
                     and a.aqpb434ope = ln_ope                 
                     and a.aqpb434est = 'C';
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_prog:= '';
                          ln_fecH := '';
                   END;
                   
                   --Inicializa Variables
                   ln_tipP := null;
                   ln_nom  := null;
                   ln_pais := null;
                   ln_tipD := null;
                   ln_numD := null;
                   ln_ape1 := null;
                   ln_ape2 := null;
                   ln_raz  := null;
                   ln_itc  := null;                 
                   ln_estp := null;
                   ln_ext := null;
                   
                   --Obtiene Datos de la Persona
                   BEGIN
                     SELECT p.Tdtval,g.penom,b.pepais,b.petdoc,b.pendoc INTO ln_tipP,ln_nom,ln_pais,ln_tipD,ln_numD 
                     FROM FSR008 b
                     INNER JOIN FST014 p
                     ON p.tdocum = b.petdoc
                     INNER JOIN FSD001 g 
                     ON g.Pepais = b.Pepais
                     and g.Petdoc = b.Petdoc
                     and g.Pendoc = b.Pendoc                            
                     WHERE b.Pgcod = c.pgcod 
                     and b.ctnro = ln_cta
                     and b.Cttfir = 'T';
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_tipP := '';
                          ln_nom  := '';
                          ln_pais  := 0;
                          ln_tipD  := 0;
                          ln_numD  := '';
                   END;
                   
                   IF ln_tipP = 'F' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT e.Pfape1,e.Pfape2,e.pfnom1 INTO ln_ape1,ln_ape2,ln_nom
                      FROM FSD002 e
                      WHERE e.pfpais = ln_pais                       
                      and e.pftdoc = ln_tipD
                      and e.pfndoc = ln_numD;                                     
                      EXCEPTION
                        WHEN no_data_found THEN
                          ln_ape1 := '';
                          ln_ape2 := '';
                          ln_nom := '';
                      END;
                   END IF;
                   
                   IF ln_tipP = 'J' OR ln_tipP = 'A' THEN
                     BEGIN
                      SELECT r.pjrazs INTO ln_raz
                      FROM FSD003 r
                      WHERE r.pjpais = ln_pais
                      and r.pjtdoc = ln_tipD
                      and r.pjndoc = ln_numD;
                     EXCEPTION
                        WHEN no_data_found THEN
                          ln_raz := '';
                     END;
                   END IF; 
                   
                   --Obtiene Extorno
                   BEGIN 
                     SELECT  n.Itcorr INTO ln_itc
                     FROM FSD015 n
                     WHERE n.pgcod = c.pgcod
                     and n.itsuc = c.itsuc
                     and n.itmod = c.itmod
                     and n.ittran = c.ittran
                     and n.itnrel = c.itnrel;
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_itc := 0;
                   END;
                   
                   IF ln_itc = 99 THEN
                     ln_ext := 'SI';
                     ln_estasi := 'E';
                   ELSE
                     ln_ext := null;
                     ln_estasi := c.itcont;
                   END IF;
                    
                   --Obtiene Estado
                   BEGIN 
                     SELECT u.tp1desc INTO ln_estp
                     FROM FST198 u
                     WHERE u.tp1cod = c.pgcod
                     and u.tp1cod1 = 11123
                     and u.tp1corr1 = 10
                     and u.tp1corr2 = 2
                     and u.tp1nro1 = c.itmod
                     and u.tp1nro2 = c.ittran;
                   EXCEPTION
                        WHEN no_data_found THEN
                          ln_estp := '';
                   END;                  
                   
                   
                 BEGIN                                                                                                                                                                                                                      
                   INSERT INTO aqpc152(
                    aqpc152pgcod,
                    aqpc152suc  ,
                    aqpc152mod  ,
                    aqpc152tran  ,
                    aqpc152nrel ,
                    aqpc152fcont,
                    aqpc152fec,
                    aqpc152cta  ,-- Cuenta
                    aqpc152ope  ,-- Operación
                    aqpc152feh  ,-- Fecha de Honramiento
                    aqpc152pro  ,-- Programa
                    aqpc152mda  ,-- Moneda
                    aqpc152tdc  ,-- Tipo de Documento
                    aqpc152ndc  ,-- Número de Documento
                    aqpc152rzs  ,-- Razón Social
                    aqpc152apt  ,-- Apellido Paterno
                    aqpc152amt  ,-- Apellido Materno
                    aqpc152nom  ,-- Nombre 
                    aqpc152ext  ,-- Extorno
                    aqpc152est  ,-- Estado de Pago
                    aqpc152fep  ,-- Fecha de Pago
                    aqpc152cap  ,-- Capital Pagado
                    aqpc152itp  ,-- Interés Pagado
                    aqpc152icv  ,-- ICV Pagado
                    aqpc152mor  ,-- Mora Pagada
                    aqpc152pen  ,-- Penalidad Pagada
                    aqpc152oro  ,-- Otros Rubros de la Obligación
                    aqpc152seg  ,-- Seguro Pagado
                    aqpc152gst  ,-- Gasto RL Honramiento
                    aqpc152mth  ,-- Monto Honrado Pagado
                    aqpc152itm  ,-- Interés Moratorio
                    aqpc152rub  ,-- Rubro Recaudadora para Cofide
                    aqpc152mtr  , -- Monto Recaudado Cofide   
                    AQPC152ESTASI,
                    AQPC152USRACT,
                    AQPC152FECACT,   
                    AQPC152ICH --Interés compensatorio Honrado RCASTRO 16/11/2022                                                                      
                   ) VALUES(
                      c.pgcod,
                      c.itsuc,
                      c.itmod,
                      c.ittran,
                      c.itnrel,
                      c.itfcon,
                      p_fec,
                      ln_cta,  -- Cuenta
                      ln_ope,  -- Operación
                      ln_fecH, -- Fecha de Honramiento
                      ln_prog, -- Programa
                      c.moneda,-- Moneda
                      ln_tipD, -- Tipo de Documento
                      ln_numD, -- Número de Documento
                      ln_raz,  -- Razón Social
                      ln_ape1, -- Apellido Paterno
                      ln_ape2, -- Apellido Materno
                      ln_nom,  -- Nombre
                      ln_ext,  -- Extorno
                      ln_estp, -- Estado de Pago
                      ln_fpag, -- Fecha de Pago 
                      ln_cap,  -- Capital Pagado
                      ln_itp,  -- Interés Pagado
                      ln_icv,  -- ICV Pagado
                      ln_mor,  -- Mora Pagada
                      ln_pen,  -- Penalidad Pagada
                      ln_oro,  -- Otros Rubros de la Obligación
                      ln_seg,  -- Seguro Pagado
                      ln_gst,  -- Gasto RL Honramiento
                      ln_mth,  -- Monto Honrado Pagado
                      ln_itm,  -- Interés Moratorio
                      ln_rubro,-- Rubro Recaudadora para Cofide
                      ln_mtr , -- Monto Recaudado Cofide
                      ln_estasi,--c.itcont
                      p_usr,
                      p_fec,
                      ln_ICH  -- RCASTRO 16/11/2022
                   );
                   COMMIT;
                EXCEPTION 
                WHEN OTHERS THEN
                   NULL;
                END;  
                EXCEPTION
                  WHEN no_data_found THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                  WHEN OTHERS THEN
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;             
                END;                      
        END LOOP;
        
      
        --rc
       BEGIN
        pq_cr_rephonr.sp_validar_extorn_dia(p_usr => p_usr,
                                            p_fecapertura => p_fec );
        END;
        
        
        
     END;  
     
    
     
  END SP_CR_REPHONRDIARIO;      
  ---------------------- 
  
  PROCEDURE SP_CR_BUSCARTEMP152(pUbuser char, fechaApert date, p_fecIni in date, 
                                p_fecFin  IN date, flgExisteReg out varchar2) IS
  CURSOR DATOS IS
  SELECT * FROM AQPC152 WHERE AQPC152FCONT >= p_fecIni AND AQPC152FCONT <= p_fecFin; --AND AQPC152ESTASI = 'S' ; --'S' contabilizado E extornado       
    
                       
  ln_corr NUMBER; 
  lc_coderr NUMBER;   
  lc_msgerr varchar2(200);  
  auxfec varchar2(10); 
  fechpro date; 
  flgx varchar2(1);                        
  BEGIN
     auxfec := '19/02/2022';
     fechpro := TO_DATE(auxfec,'dd/mm/RRRR');   
    
  
   --- Validar honramiento en el mismo día del generado de reporte
   -- BEGIN
     --  PQ_CR_REPHONR.SP_CR_REPHONRDIARIO( pUbuser,  fechaApert);
        pq_cr_rephonr.sp_cr_rephonrdiario(p_usr =>pUbuser,
                                          p_fec => fechaApert); 
    --END;                      
  
    --- validar extorno existe en aqpc152 antes de generar reporte
   -- BEGIN
      -- PQ_CR_REPHONR.sp_validar_extorn_dia(pUbuser, fechaApert );
     --   pq_cr_rephonr.sp_validar_extorn_dia(p_usr => pUbuser,
              --                              p_fecapertura => fechpro );
   -- END;
  
  
    flgExisteReg := 'N';    
     
     FOR rows IN DATOS LOOP
        flgExisteReg := 'S'; 
        BEGIN
          SELECT nvl(max(t.aqpc151corr),0) + 1
          INTO ln_corr
          FROM aqpc151 t
          WHERE aqpc151usr = pUbuser;
        EXCEPTION
        WHEN no_data_found THEN
        ln_corr := 0;
        END;          
        
        
       --BEGIN 
        INSERT INTO aqpc151(
                    aqpc151usr  ,-- Usuario
                    aqpc151corr ,-- Correlativo
                    aqpc151cta  ,-- Cuenta
                    aqpc151ope  ,-- Operación
                    aqpc151feh  ,-- Fecha de Honramiento
                    aqpc151pro  ,-- Programa
                    aqpc151mda  ,-- Moneda
                    aqpc151tdc  ,-- Tipo de Documento
                    aqpc151ndc  ,-- Número de Documento
                    aqpc151rzs  ,-- Razón Social
                    aqpc151apt  ,-- Apellido Paterno
                    aqpc151amt  ,-- Apellido Materno
                    aqpc151nom  ,-- Nombre 
                    aqpc151ext  ,-- Extorno
                    aqpc151est  ,-- Estado de Pago
                    aqpc151fep  ,-- Fecha de Pago
                    aqpc151cap  ,-- Capital Pagado
                    aqpc151itp  ,-- Interés Pagado
                    aqpc151icv  ,-- ICV Pagado
                    aqpc151mor  ,-- Mora Pagada
                    aqpc151pen  ,-- Penalidad Pagada
                    aqpc151oro  ,-- Otros Rubros de la Obligación
                    aqpc151seg  ,-- Seguro Pagado
                    aqpc151gst  ,-- Gasto RL Honramiento
                    aqpc151mth  ,-- Monto Honrado Pagado
                    aqpc151itm  ,-- Interés Moratorio
                    aqpc151rub  ,-- Rubro Recaudadora para Cofide
                    aqpc151mtr  ,-- Monto Recaudado Cofide
                    AQPC151ICH   -- Interés compensatorio Honramiento RCASTRO 16/11/2022
                   ) VALUES(
                      pUbuser,   -- Usuario
                      ln_corr, -- Correlativo                      
                      rows.aqpc152cta,  -- Cuenta
                      rows.aqpc152ope,  -- Operación
                      rows.AQPC152FEH, -- Fecha de Honramiento
                      rows.AQPC152PRO, -- Programa
                      rows.AQPC152MDA,-- Moneda
                      rows.aqpc152tdc, -- Tipo de Documento
                      rows.AQPC152NDC, -- Número de Documento
                      rows.AQPC152RZS,  -- Razón Social
                      rows.AQPC152APT, -- Apellido Paterno
                      rows.AQPC152AMT, -- Apellido Materno
                      rows.AQPC152NOM,  -- Nombre
                      rows.AQPC152EXT,  -- Extorno
                      rows.AQPC152EST, -- Estado de Pago
                      rows.AQPC152FEP, -- Fecha de Pago 
                      rows.AQPC152CAP,  -- Capital Pagado
                      rows.AQPC152ITP,  -- Interés Pagado
                      rows.AQPC152ICV,  -- ICV Pagado
                      rows.AQPC152MOR,  -- Mora Pagada
                      rows.AQPC152PEN,  -- Penalidad Pagada
                      rows.AQPC152ORO,  -- Otros Rubros de la Obligación
                      rows.AQPC152SEG,  -- Seguro Pagado
                      rows.AQPC152GST,  -- Gasto RL Honramiento
                      rows.AQPC152MTH,  -- Monto Honrado Pagado
                      rows.AQPC152ITM,  -- Interés Moratorio
                      rows.AQPC152RUB,-- Rubro Recaudadora para Cofide
                      rows.AQPC152MTR,   -- Monto Recaudado Cofide
                      rows.aqpc152ich  -- Interés compensatorio Honramiento RCASTRO 16/11/2022
                   );
                   COMMIT;  
         /*EXCEPTION 
           WHEN OTHERS THEN
              NULL;
         END;  */
    END LOOP;
            
    
      
  END SP_CR_BUSCARTEMP152;                                             
  
  ---------------------------------------------
  PROCEDURE sp_validar_extorn_dia(p_usr char, p_fecapertura date) IS
  CURSOR DAT_EXTORNO IS
      select /*+ ALL_ROWS index_ss(l) */distinct f.pgcod, f.itsuc, f.itmod, f.ittran, f.itnrel, f.itfcon, f.ituing   
      from  fsd015 f, fst198 g               
      WHERE 
          g.tp1cod = 1
          and g.tp1cod1 = 11123
          and g.tp1corr1 = 10
          and g.tp1corr2 = 4
                                                  
          and f.pgcod = g.tp1cod
          and f.itmod = (g.tp1nro1 + 500)
      
          and f.ittran = g.tp1nro2    
          and f.itcont = 'S'         
          and f.itfcon = p_fecapertura;--to_date(p_fecapertura, 'dd/MM/yyyy');-- p_fecapertura;                
   
  RelOri NUMBER(4);
  FContOrig DATE;
  i number(9);
  v_user varchar2(10);
  v_fcon date;
  xItcorr number(5);
  flgExtor varchar2(1);  
  fecAct date;
  BEGIN
     --rc        
  
  
     FOR i in DAT_EXTORNO loop                   
         BEGIN
           SELECT /*+index(FSD015 FSX01501_UK)*/ TO_NUMBER(TRIM(Txtext)) INTO RelOri FROM FSX015 WHERE 
            Pgcod  = I.PGCOD AND
            Hcmod  = i.itmod and
            Hsucor = i.itsuc and
            Htran  = i.ittran and
            Hnrel  = i.itnrel and
            Hfcon  = i.itfcon and
            Txcod  = 0  AND
            Txreng = 1 ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RelOri := 0;  
            WHEN OTHERS THEN
                NULL;        
           END; 
           
          BEGIN
           SELECT  TO_DATE(TRIM(Txtext),'dd/MM/yyyy') INTO FContOrig FROM FSX015 WHERE 
            Pgcod  = I.PGCOD AND
            Hcmod  = i.itmod and
            Hsucor = i.itsuc and
            Htran  = i.ittran and
            Hnrel  = i.itnrel and
            Hfcon  = i.itfcon and
            Txcod  = 0  AND
            Txreng = 2 ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                FContOrig := '';  
            WHEN OTHERS THEN
                NULL;        
           END;  
         -- obtener asiento original
        /* IF FContOrig = p_fecapertura THEN
              BEGIN
                 SELECT /*+index(FSD015 FSX01501_UK) ITUING, ITFCON, Itcorr INTO v_user, v_fcon, xItcorr  FROM FSD015 WHERE
                 PGCOD = I.PGCOD and 
                 ITSUC = i.itsuc and
                 ITMOD = (i.itmod - 500) and 
                 ITTRAN = i.ittran and
                 ITNREL = RelOri and
                 ITFCON = FContOrig ;         
              EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_user := '';
                    v_fcon := '';
                    xItcorr := 0;
                    FContOrig := '';  
                WHEN OTHERS THEN
                    NULL;    
              END;
          ELSE 
              IF FContOrig < p_fecapertura THEN
                xItcorr := 0;
              END IF;          
          END IF;
          
          IF xItcorr = 99 THEN 
             flgExtor := 'E';
          END IF; */
                     
           -- ACTUALIZAR AQPC152 
          -- BEGIN 
              UPDATE AQPC152
              SET AQPC152ESTASI = 'E', 
                  AQPC152USRACT = i.ituing,
                  AQPC152FECACT = p_fecapertura, --to_date(p_fecapertura,'dd/MM/yyyy'),--p_fecapertura, 
                  AQPC152EXT = 'SI',
                  AQPC152FECEXT = i.itfcon--to_date(p_fecapertura, 'dd/MM/yyyy')               
              WHERE 
                  aqpc152pgcod = i.pgcod and--i.pgcod and 
                  aqpc152suc =  i.itsuc and--i.itsuc and
                  aqpc152mod =  (i.itmod - 500) and --(i.itmod - 500) and
                  aqpc152tran = i.ittran and--i.ittran and
                  aqpc152nrel = RelOri and --RelOri and
                  aqpc152fcont = to_date(FContOrig, 'dd/MM/RRRR');--to_date('18/02/2022', 'dd/MM/yyyy');--FContOrig;
              commit;
          /* EXCEPTION
             WHEN OTHERS THEN
                NULL;
           END; */           
           
     end loop;                 

  END SP_VALIDAR_EXTORN_DIA;
  
  ---------------------------------------------
  PROCEDURE SP_JOBS_CARG_AQPC152(PC_USR varchar2, fechaIni in date, fechaFin in date) IS
  
  Cursor all_sucurs is
  select /*+ ALL_ROWS */ b.oficod from FST198 a, fst811 b
    Where a.Tp1cod = 1
          AND a.Tp1cod1 = 10872
          AND a.Tp1corr1 = 11 
                                    
          and b.Pgcod = a.Tp1cod
          and b.RegCod = Tp1nro2    
          and b.regcod < 100;
  
   
  lc_fecproIni   varchar2(10);
  lc_fecproFin   varchar2(10);
  lc_variable varchar2(4000);
  ln_job      number := 0;
  lc_hostname varchar2(64); 
  ln_cont number(2) := 0;
  ln_inst number(1) := 1;  
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    end;
   
    lc_fecproIni := to_char(fechaIni, 'RRRR.MM.DD');  
    lc_fecproFin := to_char(fechaFin, 'RRRR.MM.DD');      
   
    for i in all_sucurs loop
        
      lc_variable := ' begin ' || ' pq_cr_rephonr.sp_cr_rephonrhs(''' || PC_USR || ''', TO_DATE(''' || lc_fecproIni || ''',''RRRR.MM.DD''), TO_DATE(''' || lc_fecproFin || ''',''RRRR.MM.DD''),''' || i.oficod || ''');' || ' End; ';
                           
      ln_job := ln_job + 1;

      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        --                     instance => ln_inst,
                        instance => 2, 
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  
  END SP_JOBS_CARG_AQPC152;   
  
    
  
  
  
END PQ_CR_REPHONR;
/

