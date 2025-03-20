create or replace package pq_cr_cambios_creditos is
    -- *****************************************************************
    -- Nombre                     : pq_cr_cambios_creditos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.06
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Calculo de cambios detallados del credito en consulta  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 29/06/2024 YYAMPI se modifico sp_cambios_historia
    --
    -- *****************************************************************
 procedure sp_cambios_historia(
                       pc_usuario in char,
                       pn_pgcod in number,
                       pn_aomod in number,
                       pn_aosuc in number,
                       pn_aomda in number,
                       pn_aopap in number,
                       pn_aocta in number,
                       pn_aooper in number,
                       pn_aosbop in number,
                       pn_aotope in number,
                       pn_coderr out number,
                       pv_deserr out varchar
                       ) ;
                        
  procedure sp_insercion(
                       pn_pgcod1 in number,
                       pn_aomod1 in number,
                       pn_aosuc1 in number,
                       pn_aomda1 in number,
                       pn_aopap1 in number,
                       pn_aocta1 in number,
                       pn_aooper1 in number,
                       pn_aosbop1 in number,
                       pn_aotope1 in number,
                       pn_relcod in number,
                       pn_pgcod2 in number,
                       pn_aomod2 in number,
                       pn_aosuc2 in number,
                       pn_aomda2 in number,
                       pn_aopap2 in number,
                       pn_aocta2 in number,
                       pn_aooper2 in number,
                       pn_aosbop2 in number,
                       pn_aotope2 in number,                       
                       pn_cd in number,
                       pn_mo in number,
                       pn_su in number,
                       pn_tr in number,
                       pn_re in number,
                       pd_fc in date,
                       pc_co in char,                      
                       pc_USU in char,
                       pv_CRED in varchar2,
                       pn_CORR in number,
                       pd_FECC in date,
                       pc_HORC in char,                                                              
                       pn_coderr out number,
                       pv_deserr out varchar
                       );                     
 -----------------------------------------------------------------------------
 procedure SP_CR_ALTA_REFI_REPRO( pn_pgcod in number,
                                                  pn_aomod in number,
                                                  pn_aosuc in number, 
                                                  pn_aomda in number,
                                                  pn_aopap in number,
                                                  pn_aocta in number, 
                                                  pn_aooper in number,
                                                  pn_aosbop in number,
                                                  pn_aotope in number,
                                                  pc_numcre in varchar2,
                                                  pc_usuario in char,
                                                  pn_numcor in out number
                                                  ) ;                                                                                                                                                                                       
end pq_cr_cambios_creditos;
/

create or replace package body pq_cr_cambios_creditos is
   -- *****************************************************************
    -- Nombre                     : pq_cr_cambios_creditos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.06
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Calculo de cambio detallado en creditos  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 29/06/2024 YYAMPI se modifico sp_cambios_historia
    --
    -- *****************************************************************

  procedure sp_cambios_historia(
                       pc_usuario in char,
                       pn_pgcod in number,
                       pn_aomod in number,
                       pn_aosuc in number,
                       pn_aomda in number,
                       pn_aopap in number,
                       pn_aocta in number,
                       pn_aooper in number,
                       pn_aosbop in number,
                       pn_aotope in number,
                       pn_coderr out number,
                       pv_deserr out varchar
                       ) is
  
  /******************************************************************
    -- Nombre                     : sp_cambios_historia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA CAMBIOS DE ESTADO DEL CREDITO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :  
                                    pc_usuario (usuario)
                                    pn_pgcod (empresa)
                                    pn_aomod (modulo)
                                    pn_aosuc (susursal)
                                    pn_aomda (moneda)
                                    pn_aopap (papel)
                                    pn_aocta (cuenta)
                                    pn_aooper (operacion)
                                    pn_aosbop (suboperacion)
                                    pn_aotope (tipo de operacion)
                                    
    -- Parámetros de Salida       : 
                                    pn_coderr (codigo de error)
                                    pv_deserr (descripcion de error)
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 29/06/2024 YYAMPI se agrego casos de solo masivos e individuales
    --  
    -- *****************************************************************/
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
    lv_credito varchar(40):= '';
    ln_correlativo number(10) := 0;
    ln_coderr number(10) := 0;
    lv_deserr varchar2(40) := '';
    ln_numcor number(10) := 0;
    
    cursor hist_ant( lc_usuario char , lv_cred varchar2 ) is     
                select /*+ ALL_ROWS*/
                 *
                  from (select /*+ ALL_ROWS*/
                         max(PGCOD1) PGCOD1,
                         max(HMODUL1) HMODUL1,
                         max(HSUCUR1) HSUCUR1,
                         max(HMDA1) HMDA1,
                         max(HPAP1) HPAP1,
                         max(HCTA1) HCTA1,
                         max(HOPER1) HOPER1,
                         max(HSUBOP1) HSUBOP1,
                         max(HTOPER1) HTOPER1,
                         (select t.tp1nro3 
                          from fst198 t 
                          where t.tp1cod = 1 and t.tp1cod1 = 11172 and t.tp1corr1 = 99  and t.tp1corr2 in (1, 2)
                          and t.tp1nro1 = dat.HCMOD
                          and t.tp1nro2 = dat.HTRAN) relcod,
                         max(PGCOD2) PGCOD2,
                         max(HMODUL2) HMODUL2,
                         max(HSUCUR2) HSUCUR2,
                         max(HMDA2) HMDA2,
                         max(HPAP2) HPAP2,
                         max(HCTA2) HCTA2,
                         max(HOPER2) HOPER2,
                         max(HSUBOP2) HSUBOP2,
                         max(HTOPER2) HTOPER2,
                         dat.PGCOD,
                         dat.HCMOD,
                         dat.HSUCOR,
                         dat.HTRAN,
                         dat.HNREL,
                         dat.HFCON,
                         'S' CON,
                         lc_usuario, --'SCRE0204' USUARIO,
                         DAT.CRED,
                         --ROWNUM CORRELATIVO,   
                         DAT.FECHA,
                         DAT.HORA--,
                         --DAT.ESTADO,
                         --DAT.GRUPO,
                         --DAT.SUBGRUPO
                          from (select /*+ all_rows */
                                DISTINCT CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.PGCOD
                                         END PGCOD1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HMODUL
                                         END HMODUL1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HSUCUR
                                         END HSUCUR1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HMDA
                                         END HMDA1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HPAP
                                         END HPAP1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HCTA
                                         END HCTA1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HOPER
                                         END HOPER1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HSUBOP
                                         END HSUBOP1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp1 THEN
                                            D.HTOPER
                                         END HTOPER1,
                                         1,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.PGCOD
                                         END PGCOD2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HMODUL
                                         END HMODUL2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HSUCUR
                                         END HSUCUR2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HMDA
                                         END HMDA2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HPAP
                                         END HPAP2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HCTA
                                         END HCTA2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HOPER
                                         END HOPER2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HSUBOP
                                         END HSUBOP2,
                                         CASE
                                           WHEN d.hcord = t.tp1imp2 THEN
                                            D.HTOPER
                                         END HTOPER2,
                                         D.PGCOD,
                                         D.HCMOD,
                                         D.HSUCOR,
                                         D.HTRAN,
                                         D.HNREL,
                                         D.HFCON,
                                         'S',
                                         C.HUSING,
                                         lv_cred CRED,
                                         rownum CORRELATIVO,
                                         TRUNC(SYSDATE) FECHA,
                                         TO_CHAR(SYSDATE, 'hh24:mi:ss') hora,
                                         TO_CHAR(c.hccorr, '99') ESTADO,
                                         'INDIVIDUAL' GRUPO,
                                         'CONTABLE' SUBGRUPO
                                
                                  from fsh015 c, fsh016 d, fst198 t
                                 where c.pgcod = d.pgcod
                                   and c.hcmod = d.hcmod
                                   and c.hsucor = d.hsucor
                                   and c.htran = d.htran
                                   and c.hnrel = d.hnrel
                                   and c.hfcon = d.hfcon
                                   and d.hcmod = t.tp1nro1
                                   and d.htran = t.tp1nro2
                                   and (d.hcord = t.tp1imp2 or d.hcord = t.tp1imp1)
                                   and t.tp1cod = 1
                                   and t.tp1cod1 = 11172
                                   and t.tp1corr1 = 1
                                   and t.tp1corr2 in (1, 2)
                                   and c.hccorr = 0
                                   and d.hcta = pn_aocta--118884 --pn_aocta--118884 --1953784--1914790 --2690636  
                                   and d.hoper = pn_aooper--2659688 --pn_aooper --2659688
                                   ) dat
                         group by dat.PGCOD,
                                  dat.HCMOD,
                                  dat.HSUCOR,
                                  dat.HTRAN,
                                  dat.HNREL,
                                  dat.HFCON,
                                  'S',
                                  'SCRE0204',
                                  DAT.CRED,
                                  DAT.FECHA,
                                  DAT.HORA--,
                                  --DAT.ESTADO,
                                  --DAT.GRUPO,
                                  --DAT.SUBGRUPO
                                  
                                  union 
                            /*no contable */      
                                  
                            select /*+ all_rows */ 
                            jaqz698emp PGCOD1,
                            jaqz698mod HMODUL1,
                            jaqz698suc HSUCUR1,
                            jaqz698mda HMDA1,
                            jaqz698pap HPAP1,
                            jaqz698cta HCTA1,
                            jaqz698ope HOPER1,
                            jaqz698sbo HSUBOP1,
                            jaqz698top HTOPER1,
                            (select t.tp1corr3 
                              from fst198 t 
                              where t.tp1cod = 1 and t.tp1cod1 = 11172 and t.tp1corr1 = 99  and t.tp1corr2 in (1, 2)
                               and t.tp1nro1 = ind) relcod, 
                            jaqz698emp PGCOD2,
                            jaqz698mod HMODUL2,
                            jaqz698suc HSUCUR2,
                            jaqz698mda HMDA2,
                            jaqz698pap HPAP2,
                            jaqz698cta HCTA2,
                            jaqz698ope HOPER2,
                            jaqz698sbo HSUBOP2,
                            jaqz698top HTOPER2,
                            null PGCOD,
                            null HCMOD,
                            null HSUCOR,
                            null HTRAN,
                            null HNREL,
                            jaqz698fep HFCON,
                            'S' CON,
                            'SCRE0204' USUARIO,
                            '012345789012345789012345789012345789' CRED,
                               --ROWNUM CORRELATIVO,   
                            trunc(sysdate) FECHA,
                            to_char(sysdate,'hh24:mi:ss') HORA
                             from (
                            select j.jaqz698emp,
                                   j.jaqz698pap,
                                   j.jaqz698fep,
                                   j.jaqz698cta,
                                   j.jaqz698ope,
                                   j.jaqz698sbo,
                                   j.jaqz698mod,
                                   j.jaqz698suc,
                                   j.jaqz698mda,
                                   j.jaqz698top,
                                   j.jaqz698cor,
                                   j.jaqz698est, 
                                   '998' ind,
                                   'MASIVA' grupo, 
                                   'NO CONTABLE' subgrupo
                              from jaqz698 j
                             where j.jaqz698cta = pn_aocta--28051 --1953784--1914790 --2690636
                                and j.jaqz698ope = pn_aooper--5820201 --8847853 -- 8420481
                               and j.jaqz698est <> 'V'
                            union
                            select 
                                   j.jaqa400emp,
                                   j.jaqa400pap,
                                   j.jaqa400fec,
                                   j.jaqa400cta,
                                   j.jaqa400ope,
                                   j.jaqa400sbo,
                                   j.jaqa400mod,
                                   j.jaqa400suc,
                                   j.jaqa400mda,
                                   j.jaqa400top,
                                   0000,
                                   j.jaqa400est, 
                                   '999' ind,
                                   'INDIVIDUAL' modo,
                                   'NO CONTABLE'
                              from jaqa400 j
                             where j.jaqa400cta = pn_aocta --28051 --1953784  --1914790
                             and j.jaqa400ope = pn_aooper --5820201 --8847853 --8420481--2690636
                             and j.jaqa400est = 'C' --
                             )
               )     
                                         
                 ORDER BY HFCON DESC;
                 
   
  
    cursor hist( lc_usuario char , lv_cred varchar2 ) is     
               
    
                 
                            select t.aqpb838ccod1 PGCOD1,
                                   t.aqpb838cmod1 HMODUL1,
                                   t.aqpb838csuc1 HSUCUR1,
                                   t.aqpb838cmda1 HMDA1,
                                   t.aqpb838cpap1 HPAP1,
                                   t.aqpb838ccta1 HCTA1,
                                   t.aqpb838coper1 HOPER1,
                                   t.aqpb838csbop1 HSUBOP1,
                                   t.aqpb838ctope1 HTOPER1,
                                   (select t.tp1nro3 
                                      from fst198 t 
                                      where t.tp1cod = 1 and t.tp1cod1 = 11172 and t.tp1corr1 = 99  and t.tp1corr2 in (1, 2)
                                      and t.tp1nro1 = T.aqpb838cmo
                                      and t.tp1nro2 = T.aqpb838ctr) relcod,
                                   t.aqpb838ccod2 PGCOD2,
                                   t.aqpb838cmod2 HMODUL2,
                                   t.aqpb838csuc2 HSUCUR2,
                                   t.aqpb838cmda2 HMDA2,
                                   t.aqpb838cpap2 HPAP2,
                                   t.aqpb838ccta2 HCTA2,
                                   t.aqpb838coper2 HOPER2,
                                   t.aqpb838csbop2 HSUBOP2,
                                   t.aqpb838ctope2 HTOPER2,
                                   t.aqpb838ccd PGCOD,
                                   t.aqpb838cmo HCMOD,
                                   t.aqpb838csu HSUCOR,
                                   t.aqpb838ctr HTRAN,
                                   t.aqpb838cre HNREL,
                                   t.aqpb838cfc HFCON,
                                    'S' conf,
                                   --'SCRE0204' USUARIO,
                                   --'012345789012345789012345789012345789' CRED,
                                   trunc(sysdate) FECHA,
                                   to_char(sysdate, 'hh24:mi:ss') HORA
                            
                              from AQPB838C t
                             where t.aqpb838cusu = lc_usuario
                               and t.aqpb838ccred = lv_cred
                               
                             /*creditos originales*/
                             union all
                                  select /*+ all_rows */
                                   d.aqpb838ccod2,
                                   d.aqpb838cmod2,
                                   d.aqpb838csuc2,
                                   d.aqpb838cmda2,
                                   d.aqpb838cpap2,
                                   d.aqpb838ccta2,
                                   d.aqpb838coper2,
                                   d.aqpb838csbop2,
                                   d.aqpb838ctope2,
                                   (select t.tp1nro3
                                      from fst198 t
                                     where t.tp1cod = 1
                                       and t.tp1cod1 = 11172
                                       and t.tp1corr1 = 99
                                       and t.tp1corr2 in (1, 2)
                                       and t.tp1nro1 = 997) relcod,
                                   d.aqpb838ccod2,
                                   d.aqpb838cmod2,
                                   d.aqpb838csuc2,
                                   d.aqpb838cmda2,
                                   d.aqpb838cpap2,
                                   d.aqpb838ccta2,
                                   d.aqpb838coper2,
                                   d.aqpb838csbop2,
                                   d.aqpb838ctope2,
                                   null PGCOD,
                                   null HCMOD,
                                   null HSUCOR,
                                   null HTRAN,
                                   null HNREL,
                                   c.aofval HFCON,
                                   'S' conf,
                                   --'SCRE0204' USUARIO,
                                   --'012345789012345789012345789012345789' CRED,
                                   trunc(sysdate) FECHA,
                                   to_char(sysdate, 'hh24:mi:ss') HORA
                                  
                                    from (select f.aqpb838ccod2,
                                                 f.aqpb838cmod2,
                                                 f.aqpb838csuc2,
                                                 f.aqpb838cmda2,
                                                 f.aqpb838cpap2,
                                                 f.aqpb838ccta2,
                                                 f.aqpb838coper2,
                                                 f.aqpb838csbop2,
                                                 f.aqpb838ctope2
                                            from aqpb838c f
                                           where f.aqpb838cusu = lc_usuario
                                             and f.aqpb838ccred = lv_cred
                                          minus
                                          select f.aqpb838ccod1,
                                                 f.aqpb838cmod1,
                                                 f.aqpb838csuc1,
                                                 f.aqpb838cmda1,
                                                 f.aqpb838cpap1,
                                                 f.aqpb838ccta1,
                                                 f.aqpb838coper1,
                                                 f.aqpb838csbop1,
                                                 f.aqpb838ctope1
                                            from aqpb838c f
                                           where f.aqpb838cusu = lc_usuario
                                             and f.aqpb838ccred = lv_cred) d,
                                         fsd010 c
                                   where d.aqpb838ccod2 = c.pgcod
                                     and d.aqpb838cmod2 = c.aomod
                                     and d.aqpb838csuc2 = c.aosuc
                                     and d.aqpb838cmda2 = c.aomda
                                     and d.aqpb838cpap2 = c.aopap
                                     and d.aqpb838ccta2 = c.aocta
                                     and d.aqpb838coper2 = c.aooper
                                     and d.aqpb838csbop2 = c.aosbop
                                     and d.aqpb838ctope2 = c.aotope
                                                    
                             union all 
                            /*no contable */      
                                  
                            select /*+ all_rows */ 
                            jaqz698emp PGCOD1,
                            jaqz698mod HMODUL1,
                            jaqz698suc HSUCUR1,
                            jaqz698mda HMDA1,
                            jaqz698pap HPAP1,
                            jaqz698cta HCTA1,
                            jaqz698ope HOPER1,
                            jaqz698sbo HSUBOP1,
                            jaqz698top HTOPER1,
                            (select t.tp1nro3 
                              from fst198 t 
                              where t.tp1cod = 1 and t.tp1cod1 = 11172 and t.tp1corr1 = 99  and t.tp1corr2 in (1, 2)
                               and t.tp1nro1 = ind) relcod, 
                            jaqz698emp PGCOD2,
                            jaqz698mod HMODUL2,
                            jaqz698suc HSUCUR2,
                            jaqz698mda HMDA2,
                            jaqz698pap HPAP2,
                            jaqz698cta HCTA2,
                            jaqz698ope HOPER2,
                            jaqz698sbo HSUBOP2,
                            jaqz698top HTOPER2,
                            null PGCOD,
                            null HCMOD,
                            null HSUCOR,
                            null HTRAN,
                            null HNREL,
                            jaqz698fep HFCON,
                            'S' CON,
                            --'SCRE0204' USUARIO,
                            --'012345789012345789012345789012345789' CRED,
                            trunc(sysdate) FECHA,
                            to_char(sysdate,'hh24:mi:ss') HORA
                             from (
                            select j.jaqz698emp,
                                   j.jaqz698pap,
                                   j.jaqz698fep,
                                   j.jaqz698cta,
                                   j.jaqz698ope,
                                   j.jaqz698sbo,
                                   j.jaqz698mod,
                                   j.jaqz698suc,
                                   j.jaqz698mda,
                                   j.jaqz698top,
                                   j.jaqz698cor,
                                   j.jaqz698est, 
                                   '998' ind,
                                   'MASIVA' grupo, 
                                   'NO CONTABLE' subgrupo
                              from jaqz698 j,aqpb838c k 
                             where j.jaqz698cta = k.aqpb838ccta1(+) --29/06/2024 YYAMPI--pn_aocta--28051 --1953784--1914790 --2690636
                                and j.jaqz698ope = k.aqpb838coper1(+) --29/06/2024 YYAMPI--pn_aooper--5820201 --8847853 -- 8420481
                               and j.jaqz698est <> 'V'
                               and k.aqpb838cusu(+) = lc_usuario --29/06/2024 YYAMPI
                               and k.aqpb838ccred(+) = lv_cred --29/06/2024 YYAMPI
                               and j.jaqz698cta = pn_aocta --29/06/2024 YYAMPI
                               and j.jaqz698ope = pn_aooper --29/06/2024 YYAMPI
                            union
                            select 
                                   j.jaqa400emp,
                                   j.jaqa400pap,
                                   j.jaqa400fec,
                                   j.jaqa400cta,
                                   j.jaqa400ope,
                                   j.jaqa400sbo,
                                   j.jaqa400mod,
                                   j.jaqa400suc,
                                   j.jaqa400mda,
                                   j.jaqa400top,
                                   0000,
                                   j.jaqa400est, 
                                   '999' ind,
                                   'INDIVIDUAL' modo,
                                   'NO CONTABLE'
                              from jaqa400 j, aqpb838c k 
                             where j.jaqa400cta = k.aqpb838ccta1(+)--29/06/2024 YYAMPI --pn_aocta --28051 --1953784  --1914790
                             and j.jaqa400ope = k.aqpb838coper1(+) --29/06/2024 YYAMPI --pn_aooper --5820201 --8847853 --8420481--2690636
                             and j.jaqa400est = 'C'
                             and k.aqpb838cusu(+) = lc_usuario --29/06/2024 YYAMPI
                             and k.aqpb838ccred(+) = lv_cred --29/06/2024 YYAMPI
                             and j.jaqa400cta = pn_aocta --29/06/2024 YYAMPI
                             and j.jaqa400ope = pn_aooper --29/06/2024 YYAMPI
                             )
                   
                                         
                 ORDER BY HFCON DESC;
  
  
  
                
  begin
    
    /* calcular el cred   */
    lv_credito := trim(to_char(pn_pgcod,'000'))||
    trim(to_char(pn_aomod,'000'))||
    trim(to_char(pn_aosuc,'000'))||
    trim(to_char(pn_aomda,'000'))||
    trim(to_char(pn_aopap,'0000'))||
    trim(to_char(pn_aocta,'000000000'))||
    trim(to_char(pn_aooper,'000000000'))||
    trim(to_char(pn_aosbop,'000'))||
    trim(to_char(pn_aotope,'000')); 
    
    /*borrado de la tabla */
    begin 
        delete from AQPB838 t where t.aqpb838usu = pc_usuario and t.aqpb838cred = lv_credito;
        --dbms_output.put_line('borrado exitoso...');
        commit;
    exception when others then 
       null;
       --dbms_output.put_line('error en borrado');
    end;  
    
    
    begin 
       
     delete from AQPB838C t where t.aqpb838cusu = pc_usuario and t.aqpb838ccred = lv_credito;
        --dbms_output.put_line('borrado temp exitoso...');
        commit;
      
    exception when others then 
        null;
       --dbms_output.put_line('error en borrado temp');
    end;
  
    /*llenar tabla temporal */
    begin       
    
             -- Call the procedure
      pq_cr_cambios_creditos.SP_CR_ALTA_REFI_REPRO(pn_pgcod => pn_pgcod,
                                                              pn_aomod => pn_aomod,
                                                              pn_aosuc => pn_aosuc,
                                                              pn_aomda => pn_aomda,
                                                              pn_aopap => pn_aopap,
                                                              pn_aocta => pn_aocta,
                                                              pn_aooper => pn_aooper,
                                                              pn_aosbop => pn_aosbop,
                                                              pn_aotope => pn_aotope,
                                                              pc_numcre => lv_credito,
                                                              pc_usuario => pc_usuario,
                                                              pn_numcor => ln_numcor);

        exception when others then 
          null;
        end;
    
    
    /*insertar historia*/
    for h in hist(pc_usuario,lv_credito)   loop
    
    ln_correlativo := ln_correlativo +1 ;
       
    sp_insercion(pn_pgcod1  => h.PGCOD1,
                 pn_aomod1  => h.HMODUL1,
                 pn_aosuc1  => h.HSUCUR1,
                 pn_aomda1  => h.HMDA1,
                 pn_aopap1  => h.HPAP1,
                 pn_aocta1  => h.HCTA1,
                 pn_aooper1 => h.HOPER1,
                 pn_aosbop1 => h.HSUBOP1,
                 pn_aotope1 => h.HTOPER1,
                 pn_relcod  => h.RELCOD,
                 pn_pgcod2  => h.PGCOD2,
                 pn_aomod2  => h.HMODUL2,
                 pn_aosuc2  => h.HSUCUR2,
                 pn_aomda2  => h.HMDA2,
                 pn_aopap2  => h.HPAP2,
                 pn_aocta2  => h.HCTA2,
                 pn_aooper2 => h.HOPER2,
                 pn_aosbop2 => h.HSUBOP2,
                 pn_aotope2 => h.HTOPER2,
                 pn_cd      => h.PGCOD,
                 pn_mo      => h.HCMOD,
                 pn_su      => h.HSUCOR,
                 pn_tr      => h.HTRAN,
                 pn_re      => h.HNREL,
                 pd_fc      => h.HFCON,
                 pc_co      => 'S',
                 pc_USU     => pc_usuario,
                 pv_CRED    => lv_credito,
                 pn_CORR    => ln_correlativo,
                 pd_FECC    => trunc(sysdate),
                 pc_HORC    => to_char(sysdate,'HH24:MI:SS'),
                 pn_coderr  => ln_coderr,
                 pv_deserr  => lv_deserr); 
      
    end loop ;
    
   
    --dbms_output.put_line('proceso exitoso...');
     commit;  
     
     begin
  -- Call the procedure
  PQ_CR_DETALLEPAGOS.sp_cr_inicio(lc_usuario => pc_usuario,
                                  lc_Credito => lv_credito);
                                  
      exception   when others then
        null;                             
   end;

     
    exception
      when others then
    --  dbms_output.put_line('error en insercion: '||sqlerrm);  
      null;
     
  end sp_cambios_historia;
-----------------------------------------------------------------------------
  
 procedure sp_insercion(
                       pn_pgcod1 in number,
                       pn_aomod1 in number,
                       pn_aosuc1 in number,
                       pn_aomda1 in number,
                       pn_aopap1 in number,
                       pn_aocta1 in number,
                       pn_aooper1 in number,
                       pn_aosbop1 in number,
                       pn_aotope1 in number,
                       pn_relcod in number,
                       pn_pgcod2 in number,
                       pn_aomod2 in number,
                       pn_aosuc2 in number,
                       pn_aomda2 in number,
                       pn_aopap2 in number,
                       pn_aocta2 in number,
                       pn_aooper2 in number,
                       pn_aosbop2 in number,
                       pn_aotope2 in number,                       
                       pn_cd in number,
                       pn_mo in number,
                       pn_su in number,
                       pn_tr in number,
                       pn_re in number,
                       pd_fc in date,
                       pc_co in char,                      
                       pc_USU in char,
                       pv_CRED in varchar2,
                       pn_CORR in number,
                       pd_FECC in date,
                       pc_HORC in char,                                                              
                       pn_coderr out number,
                       pv_deserr out varchar
                       ) is
  
  /******************************************************************
    -- Nombre                     : sp_cambios_historia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA CAMBIOS DE ESTADO DEL CREDITO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :  
                                   pn_pgcod1 (empresa destino)
                                   pn_aomod1 (modulo destino)
                                   pn_aosuc1 (sucursal destino)
                                   pn_aomda1 (moneda destino)
                                   pn_aopap1 (papel destino)
                                   pn_aocta1 (cuenta destino)
                                   pn_aooper1 (operacion destino)
                                   pn_aosbop1 (suboperacion destino)
                                   pn_aotope1 (tipo operacion destino)
                                   pn_relcod (relacion)
                                   pn_pgcod2 (empresa origen)
                                   pn_aomod2 (modulo origen)
                                   pn_aosuc2 (sucursal origen)
                                   pn_aomda2 (moneda origen)
                                   pn_aopap2 (papel origen)
                                   pn_aocta2 (cuenta origen)
                                   pn_aooper2 (operacion origen)
                                   pn_aosbop2 (suboperacion origen)
                                   pn_aotope2 (tipo operacion origen)                       
                                   pn_cd (empresa transaccion)
                                   pn_mo (modulo transaccion)
                                   pn_su (sucursal transaccion)
                                   pn_tr (transaccion)
                                   pn_re (relacion transaccion)
                                   pd_fc (fecha transaccion)
                                   pc_co (indicador)                     
                                   pc_USU (usuario)
                                   pv_CRED (credito)
                                   pn_CORR (correlativo)
                                   pd_FECC (fecha ultimo cambio)
                                   pc_HORC (hora ultimo cambio)
                                    
    -- Parámetros de Salida       : 
                                    pn_coderr (codigo de error)
                                    pv_deserr (descripcion de error)
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/
                       
   
    
  begin
  
insert into AQPB838
  (AQPB838COD1,
   AQPB838MOD1,
   AQPB838SUC1,
   AQPB838MDA1,
   AQPB838PAP1,
   AQPB838CTA1,
   AQPB838OPER1,
   AQPB838SBOP1,
   AQPB838TOPE1,
   AQPB838REL,
   AQPB838COD2,
   AQPB838MOD2,
   AQPB838SUC2,
   AQPB838MDA2,
   AQPB838PAP2,   
   AQPB838CTA2,
   AQPB838OPER2,
   AQPB838SBOP2,    
   AQPB838TOPE2,   
   AQPB838CD,
   AQPB838MO,
   AQPB838SU,
   AQPB838TR,
   AQPB838RE,
   AQPB838FC,
   AQPB838CO,   
   AQPB838USU,
   AQPB838CRED,
   AQPB838CORR,
   AQPB838FECC,
   AQPB838HORC)
values
  (
   pn_pgcod1 ,
   pn_aomod1 ,
   pn_aosuc1 ,
   pn_aomda1 ,
   pn_aopap1 ,
   pn_aocta1 ,
   pn_aooper1 ,
   pn_aosbop1 ,
   pn_aotope1 ,
   pn_relcod ,
   pn_pgcod2 ,
   pn_aomod2 ,
   pn_aosuc2 ,
   pn_aomda2 ,
   pn_aopap2 ,
   pn_aocta2 ,
   pn_aooper2 ,
   pn_aosbop2 ,
   pn_aotope2 ,                       
   pn_cd ,
   pn_mo ,
   pn_su ,
   pn_tr ,
   pn_re ,
   pd_fc ,
   pc_co ,                      
   pc_USU ,
   pv_CRED ,
   pn_CORR ,
   pd_FECC ,
   pc_HORC    
   );
   
   pn_coderr := 0;
   pv_deserr := 'OK';
    
    exception
      when others then
      pn_coderr := sqlcode;
      pv_deserr := substr(SQLERRM,40); 
      dbms_output.put_line('ERROR INSERT:'||pv_deserr);
  end sp_insercion;
-----------------------------------------------------------------------------
 procedure SP_CR_ALTA_REFI_REPRO( pn_pgcod in number,
                                pn_aomod in number,
                                pn_aosuc in number, 
                                pn_aomda in number,
                                pn_aopap in number,
                                pn_aocta in number, 
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                pc_numcre in varchar2,
                                pc_usuario in char,
                                pn_numcor in out number
                                ) is
  /******************************************************************
    -- Nombre                     : SP_CR_DET_REFINANCIA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.17
    -- Autor de Creación          : YYAMPI/DCASTRO
    -- Uso                        : RETORNA DETALLE DE CREDITOS REPROGRAMADOS/REFINANCIADOS POR FLUJO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :  
                                    pc_usuario (usuario)
                                    pn_pgcod (empresa)
                                    pn_aomod (modulo)
                                    pn_aosuc (susursal)
                                    pn_aomda (moneda)
                                    pn_aopap (papel)
                                    pn_aocta (cuenta)
                                    pn_aooper (operacion)
                                    pn_aosbop (suboperacion)
                                    pn_aotope (tipo de operacion)
                                    pc_numcre (numero credito concatenado)
                                    pc_usuario (usuario)
                                    pn_numcor  (correlativo)
                                    
                                    
    -- Parámetros de Salida       : 
                                    pn_numcor  (correlativo)
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/
  

ln_existe number;
ln_PGCODH number;
ln_HCMOD number;
ln_HSUCOR number;
ln_HTRAN number;
ln_HNREL number; 
ld_HFCON date;

vn_pgcod number := pn_pgcod; 
vn_aomod number := pn_aomod;
vn_aomda number := pn_aomda;
vn_aopap number := pn_aopap;
vn_aocta number := pn_aocta;
vn_aooper number:= pn_aooper;
vn_aosbop number:= pn_aosbop;
vn_aosuc  number:= pn_aosuc;
vn_aotope number:= pn_aotope;



cursor creditos2 (ln_pgcod in number ,ln_aomod in number, ln_aosuc in number ,ln_tran in number ,ln_rel in number, ld_fcon in date) is
          select h.pgcod, h.HMDA, h.HPAP, h.HCTA, h.HOPER, h.HSUBOP, h.HMODUL, h.HTOPER, h.HSUCUR, h.hfcon, 
           h.HCMOD, h.HSUCOR, h.HTRAN, h.HNREL
            from fsh016 h
           inner join fsh015 s
              on s.pgcod = h.pgcod
             and s.hcmod = h.hcmod
             and s.hsucor = h.hsucor
             and s.htran = h.htran
             and s.hnrel = h.hnrel
             and s.hfcon = h.hfcon
           where s.pgcod = ln_pgcod
             and s.hcmod = ln_aomod
             and s.hsucor = ln_aosuc
             and s.htran = ln_tran
             and s.hnrel = ln_rel
             and s.hfcon = ld_fcon
             and (h.HCMOD, h.HTRAN, h.HCORD) in
                 (select tp1nro1, tp1nro2, tp1imp2
                    from fst198
                   where tp1cod1 = 11172 and tp1corr1 = 1 and tp1corr2 in (1,2) and tp1corr3 > 0) -- refinanciacion y reprogramacion
             and s.hccorr = 0 ;--debe estar contabilizado  

BEGIN
  
      
          --verificar transaccion
          --verifica si existe transasaccion con esa clave con el credito de alta
       begin
          select 1, h.PGCOD, h.HCMOD, h.HSUCOR, h.HTRAN, h.HNREL, h.HFCON
            into ln_existe, ln_PGCODH, ln_HCMOD, ln_HSUCOR, ln_HTRAN, ln_HNREL, ld_HFCON
            from fsh016 h
           inner join fsh015 s
              on s.pgcod = h.pgcod
             and s.hcmod = h.hcmod
             and s.hsucor = h.hsucor
             and s.htran = h.htran
             and s.hnrel = h.hnrel
             and s.hfcon = h.hfcon
           where h.PGCOD =  vn_pgcod
             and h.HMODUL = vn_aomod
             and h.HMDA =   vn_aomda
             and h.HPAP =   vn_aopap
             and h.HCTA =   vn_aocta
             and h.HOPER =  vn_aooper
             and h.HSUBOP = vn_aosbop
             and h.HTOPER = vn_aotope
             --and h.HFCON = ld_fecha
             and (h.HCMOD, h.HTRAN, h.HCORD) in
                 (select tp1nro1, tp1nro2, tp1imp1
                    from fst198
                   where tp1cod1 = 11172
                     and tp1corr1 = 1
                     and tp1corr2 in (1,2) --and tp1corr2 = 1
                     and tp1corr3 > 0) --
             and s.hccorr = 0 --debe estar contabilizado  
           order by h.PGCOD, h.HCTA;
        exception when others then
          ln_existe := 0;
        end;  
        
        if ln_existe = 1 then --se guarda los datos de credito 1 

           for i in creditos2(ln_PGCODH, ln_HCMOD, ln_HSUCOR, ln_HTRAN, ln_HNREL, ld_HFCON) loop        
              pn_numcor := pn_numcor + 1;
              insert into AQPB838C (aqpb838ccod1, aqpb838cmod1, aqpb838csuc1, aqpb838cmda1, aqpb838cpap1, aqpb838ccta1, aqpb838coper1, aqpb838csbop1, aqpb838ctope1, 
                                    aqpb838ccod2, aqpb838cmod2, aqpb838csuc2, aqpb838cmda2, aqpb838cpap2, aqpb838ccta2, aqpb838coper2, aqpb838csbop2, aqpb838ctope2 
                                    ,aqpb838cfc,  aqpb838ccred, aqpb838cusu, AQPB838CCORR, 
                                     aqpb838ccd, aqpb838cmo, aqpb838csu, aqpb838ctr, aqpb838cre/*, aqpb838cfc, aqpb838cfecc, aqpb838chorc*/)
               values (   vn_pgcod, vn_aomod, vn_aosuc, vn_aomda, vn_aopap, vn_aocta, vn_aooper ,vn_aosbop, vn_aotope,
                          i.pgcod, i.HMODUL, i.HSUCUR, i.HMDA, i.HPAP, i.HCTA, i.HOPER, i.HSUBOP,  i.HTOPER , i.hfcon, pc_numcre, pc_usuario, pn_numcor, 
                          ln_PGCODH, ln_HCMOD, ln_HSUCOR, ln_HTRAN, ln_HNREL
                      );
               commit;
               
               begin
                 SP_CR_ALTA_REFI_REPRO(pn_pgcod => i.pgcod,         
                                      pn_aomod => i.HMODUL,
                                      pn_aosuc => i.HSUCUR,
                                      pn_aomda => i.HMDA,
                                      pn_aopap => i.HPAP,
                                      pn_aocta => i.HCTA,
                                      pn_aooper => i.HOPER,
                                      pn_aosbop => i.HSUBOP,
                                      pn_aotope => i.HTOPER,
                                      pc_numcre => pc_numcre, 
                                      pc_usuario => pc_usuario,
                                      pn_numcor => pn_numcor
                                      );
              end;
           
           end loop;
           
        else
          return;
        end if;


end SP_CR_ALTA_REFI_REPRO;  

-----------------------------------------------------------------------------------
end pq_cr_cambios_creditos;
/

