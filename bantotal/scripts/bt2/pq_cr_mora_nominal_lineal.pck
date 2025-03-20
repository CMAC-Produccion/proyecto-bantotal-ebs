create or replace package PQ_CR_MORA_NOMINAL_LINEAL is

  -- *****************************************************************
  -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.06
  -- Autor de Creación          : DCASTRO 
  -- Uso                        : PROCESO PARA CAMBIO TASA MORATORIA LINEAL A NOMINAL
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   :  DCASTRO
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- Modif   : EFUENES
  --         : 16/03/2022
  --         : Creación del paquete 
  --           sp_cr_valida_fsd012_v2
  --           sp_cr_insert_fsd012_v2
  --           sp_cr_tasmor_cre_v2
  --           sp_cr_tasmor_cre_v3
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_region_zona(lc_codsuc in number,
                              ln_codreg out number,
                              lc_nomreg out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pn_regcod number, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_job_carga(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_actualiza_tasa(ve_cta  in number,
                                 ve_ope  in number,
                                 ve_emp  in number,
                                 ve_mod  in number,
                                 ve_suc  in number,
                                 ve_mda  in number,
                                 ve_pap  in number,
                                 ve_sbo  in number,
                                 ve_top  in number,
                                 vo_tas  in number,
                                 vo_ind  out varchar2,
                                 vo_corr out number,
                                 vo_fvto out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_insert_fsd012(pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                ld_f601 in date,
                                ln_tasa in number,
                                lc_flag out char,
                                ln_corr out number,
                                lc_cerr out varchar2,
                                lc_merr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_fecha_ven(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f601 out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_tasa_mora(pn_mda in number, pn_taslin in number)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_valida_fsd012(pn_emp in number,
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                -- ld_f601 in date,
                                ln_tasa out number,
                                lc_flag out char /*,
                                                                                                                                                                                            ln_corr out number*/);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_existe_TasaMora(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number) return char;

  -------------------------------------------------------------- 
  procedure sp_cr_job_carga_117(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_117(pn_regcod in number, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_tasmor_cre(pn_emp   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pd_fec   in date,
                             pn_sis   in varchar,
                             PN_error out varchar);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_JOB_CARG_ANU_MASIVA(pd_fecpro DATE, pn_usuario in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_CARGA_MAS_CRD(VE_SUC number, VE_FECPRO date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_valida_fsd012_v2(pn_emp  in number,
                                   pn_mod  in number,
                                   pn_suc  in number,
                                   pn_mda  in number,
                                   pn_pap  in number,
                                   pn_cta  in number,
                                   pn_ope  in number,
                                   pn_sbo  in number,
                                   pn_top  in number,
                                   ln_tasa out number,
                                   lc_flag out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_insert_fsd012_v2(pn_emp  in number,
                                   pn_mod  in number,
                                   pn_suc  in number,
                                   pn_mda  in number,
                                   pn_pap  in number,
                                   pn_cta  in number,
                                   pn_ope  in number,
                                   pn_sbo  in number,
                                   pn_top  in number,
                                   ld_f601 in date,
                                   ln_tasa in number,
                                   lc_flag out char,
                                   ln_corr out number,
                                   lc_cerr out varchar2,
                                   lc_merr out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_tasmor_cre_v2(pn_emp in number, --clv original del credito
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                
                                p_empNew in number,
                                p_modNew in number,
                                p_sucNew in number,
                                p_mdaNew in number,
                                p_papNew in number,
                                p_ctaNew in number,
                                p_opeNew in number,
                                p_sboNew in number,
                                p_topNew in number,
                                
                                pd_fec   in date,
                                pn_sis   in varchar,
                                PN_error out varchar);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_tasmor_cre_v3(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pd_fec   in date,
                                pn_sis   in varchar,
                                PN_error out varchar);
  ------------
  procedure sp_cr_tasa_nominal_300400(
                                      vi_pgcod number,
                                      vi_suc number,
                                      vi_mod number,
                                      vi_tra number,
                                      vi_nrel number,
                                      vi_fcon date,
                                      vi_RTE VARCHAR,
                                      vo_ERROR out varchar
    
    );                                
end PQ_CR_MORA_NOMINAL_LINEAL;
/

create or replace package body PQ_CR_MORA_NOMINAL_LINEAL is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_MORA_NOMINAL_LINEAL
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.03.06
  -- Autor de Creación          : DCASTRO
  -- Uso                        : PROCESO PARA CAMBIO TASA MORATORIA LINEAL A NOMINAL
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --                             
  --                             
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_region_zona(lc_codsuc in number,
                              ln_codreg out number,
                              lc_nomreg out varchar2) is
  
  begin
    begin
    
      select distinct f.tp1desc, f.tp1nro1
        into lc_nomreg, ln_codreg
        from fst810 t81, fst811 t80, fst198 f
       where t80.pgcod = t81.pgcod
         and t80.regcod = t81.regcod
         and t81.regcod = f.tp1nro2
         and tp1cod = 1
         and tp1cod1 = 10872
         and tp1corr1 = 11
         and t81.regcod < 100
         and t80.regcod < 100
         and t80.oficod = lc_codsuc;
    exception
      when others then
        ln_codreg := 0;
    end;
  
  end sp_cr_region_zona;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pn_regcod in number, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.07
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor creditos(pn_regcod number /*, ld_fecpro date*/) is
    
      select /*+ALL_ROWS*/
      -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod AQPB272REG,
       upper(r2.RegNOM) AQPB272REN,
       b.aosuc AQPB272SUC,
       b.aomda AQPB272MDA,
       b.aocta AQPB272CTA,
       b.aooper AQPB272OPE,
       b.pgcod AQPB272COD,
       b.aomod AQPB272MOD,
       b.aopap AQPB272PAP,
       b.aosbop AQPB272SBOP,
       b.aotope AQPB272TOPE,
       b.aotmor AQPB272TASL,
       b.aostat AQPB272STAT
        from fst811 r, FST001 age, fst810 r2, FSD010 b, fst111 f
       where b.PGCOD = 1
         and b.aomod = f.modulo
         and r.pgcod = 1
         and r.oficod = b.aosuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = b.aosuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         AND r.oficod = age.Sucurs
         and b.aostat not in (99, 27)
         and b.aomod not in (29, 120)
         and r.regcod = pn_regcod
         and b.aosuc <> 904
         and f.dscod = 50
      --   and b.aocta =218764 and b.aooper = 2843290
      --  and b.aocta =580462 and b.aooper = 9898354   
      --  and b.aocta =1234383 and b.aooper =  9995207     
      
      --   and b.aomod not in (33,200,117) -----QUITAR LINEA SOLO PARA PRUEBAS
      --   and b.aocta in ( 592,711,1235, 2110, 2480)
      
      --and b.aotmor > 0 -- -tasa mayor a 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ; --and age.Sucurs = lc_sucurs;
  
    TYPE Tp_AQPB272COD IS TABLE OF AQPB272.AQPB272COD%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272REG IS TABLE OF AQPB272.AQPB272REG%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272REN IS TABLE OF AQPB272.AQPB272REN%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272SUC IS TABLE OF AQPB272.AQPB272SUC%TYPE INDEX BY PLS_INTEGER;
  
    TYPE Tp_AQPB272MDA IS TABLE OF AQPB272.AQPB272MDA%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272CTA IS TABLE OF AQPB272.AQPB272CTA%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272OPE IS TABLE OF AQPB272.AQPB272OPE%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272TASL IS TABLE OF AQPB272.AQPB272TASL%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272MOD IS TABLE OF fsd011.SCMOD%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272PAP IS TABLE OF fsd011.SCPAP%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272SBOP IS TABLE OF fsd011.SCSBOP%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272FVTO IS TABLE OF fsd011.SCFVTO%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272TOPE IS TABLE OF fsd011.Sctope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272STAT IS TABLE OF fsd011.scstat%TYPE INDEX BY PLS_INTEGER;
  
    ld_Fecpro date;
  
    AQPB272COD Tp_AQPB272COD;
    AQPB272REG Tp_AQPB272REG;
    AQPB272REN Tp_AQPB272REN;
    AQPB272SUC Tp_AQPB272SUC;
    AQPB272MDA Tp_AQPB272MDA;
    AQPB272CTA Tp_AQPB272CTA;
    AQPB272OPE Tp_AQPB272OPE;
  
    AQPB272MOD  Tp_AQPB272MOD;
    AQPB272PAP  Tp_AQPB272PAP;
    AQPB272SBOP Tp_AQPB272SBOP;
  
    AQPB272TOPE Tp_AQPB272TOPE;
    AQPB272TASL Tp_AQPB272TASL;
    AQPB272FVTO Tp_AQPB272FVTO;
    AQPB272STAT Tp_AQPB272STAT;
  
    ln_numero NUMBER;
    --ld_feccon date;
  
    lc_coderr varchar2(50);
    lc_msgerr varchar2(250);
    lc_error  char(1);
  
    ln_tasanom number(10, 6);
    ln_tasa    number(10, 6);
  
    ld_f601 date;
  
    lc_flag     char(1);
    ln_corr     number;
    lc_indMora  char(1);
    ln_cantidad number;
  
  begin
  
    --ld_feccon := to_Date('15/03/2022','DD/MM/YYYY');
    --
    begin
      select count(*) into ln_numero from AQPB272;
    exception
      when no_data_found then
        ln_numero := 0;
    end;
  
    ld_fecpro := pd_fecpro;
  
    OPEN creditos(pn_regcod /*, pd_fecpro */);
    LOOP
      FETCH creditos BULK COLLECT
        INTO AQPB272REG,
             AQPB272REN,
             AQPB272SUC,
             AQPB272MDA,
             AQPB272CTA,
             AQPB272OPE,
             AQPB272COD,
             AQPB272MOD,
             AQPB272PAP,
             AQPB272SBOP,
             AQPB272TOPE,
             AQPB272TASL,
             AQPB272STAT;
    
      IF AQPB272REG.COUNT > 0 THEN
        FOR i IN AQPB272REG.FIRST .. AQPB272REG.LAST LOOP
        
          ln_numero := ln_numero + 1;
          lc_error  := 'N';
        
          lc_indMora := null;
        
          begin
            ---verifica si tiene tasa Mora en X054023 indicador I
            lc_indMora := pq_cr_mora_nominal_lineal.fn_cr_existe_tasamora(pn_emp => AQPB272COD(i),
                                                                          pn_mod => AQPB272MOD(i),
                                                                          pn_suc => AQPB272SUC(i),
                                                                          pn_mda => AQPB272MDA(i),
                                                                          pn_pap => AQPB272PAP(i),
                                                                          pn_cta => AQPB272CTA(i),
                                                                          pn_ope => AQPB272OPE(i),
                                                                          pn_sbo => AQPB272SBOP(i),
                                                                          pn_top => AQPB272TOPE(i));
          end;
        
          ----si es linea, mod 116 verificar en caso que no exista valor
          if AQPB272MOD(i) = 116 and nvl(lc_indMora, 'N') = 'N' then
            begin
              select 'I' --distinct f.r1cod, f.r2mda, f.r2pap, f.r2mod,f.r2cta, f.r2oper, f.r2sbop, f.r2tope
                into lc_indMora
                from fsr011 f, x054021 x
               where x.pgcod = f.r1cod
                 and x.xlloaomda = f.r2mda
                 and x.xlloaopap = f.r2pap
                 and x.xlloaomod = f.r2mod
                 and x.xlloaocta = f.r2cta
                 and x.xlloaooper = f.r2oper
                 and x.xlloaosbop = f.r2sbop
                 and x.xlloaotope = f.r2tope
                 and x.xllotxtcod = 250
                 and x.xllotexto = 'I'
                 and f.r1cod = AQPB272COD(i)
                 and f.r1mod = AQPB272MOD(i)
                 and f.r1mda = AQPB272MDA(i)
                 and f.r1pap = AQPB272PAP(i)
                 and f.r1cta = AQPB272CTA(i)
                 and f.r1oper = AQPB272OPE(i)
                 and f.r1sbop = AQPB272SBOP(i)
                 and f.r1tope = AQPB272TOPE(i)
                 and f.relcod = 46;
            exception
              when others then
                lc_indMora := null;
            end;
          
          end if;
          --- fin si no existe  mod = 116
        
          ---obtener tasa moratoria equivalente
          begin
            ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => AQPB272MDA(i),
                                                                    pn_taslin => AQPB272TASL(i));
          end;
        
          IF nvl(ln_tasanom, 0) > 0 then
            ---si tasa >0
          
            --castigado, judicial, estado 550 si aotmor > 0
            --117 verificar que tenga I actualizar en la fsd010 
            --se actualiza por defecto.
            if AQPB272MOD(i) in (200, 33, 117) or AQPB272TOPE(i) = 550 then
              lc_indMora := 'I'; --se asigna por defecto el valor I
            end if;
          
            if lc_indMora = 'I' then
              --verifica indicador mora x054021
            
              --1--actualizar FSD010
              begin
                update fsd010 f
                   set f.aotmor = ln_tasanom
                 where f.pgcod = AQPB272COD(i)
                   and f.aomod = AQPB272MOD(i)
                   and f.aosuc = AQPB272SUC(i)
                   and f.aomda = AQPB272MDA(i)
                   and f.aopap = AQPB272PAP(i)
                   and f.aocta = AQPB272CTA(i)
                   and f.aooper = AQPB272OPE(i)
                   and f.aosbop = AQPB272SBOP(i)
                   and f.aotope = AQPB272TOPE(i);
                commit;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                  lc_error  := 'S';
              end;
              ---actualizar tabla log
            
              if lc_error = 'N' then
                begin
                
                  insert into AQPB272
                    (AQPB272reg,
                     AQPB272ren,
                     AQPB272suc,
                     AQPB272mda,
                     AQPB272cta,
                     AQPB272ope,
                     AQPB272cod,
                     AQPB272mod,
                     AQPB272pap,
                     AQPB272sbop,
                     AQPB272tope,
                     AQPB272fvto,
                     aqpb272tasl,
                     aqpb272tasn,
                     AQPB272fec,
                     aqpb272est,
                     AQPB272FREG,
                     AQPB272HRA)
                  
                  values
                    (AQPB272REG(i),
                     AQPB272REN(i),
                     AQPB272SUC(i),
                     AQPB272MDA(i),
                     AQPB272CTA(i),
                     AQPB272OPE(i),
                     AQPB272COD(i),
                     AQPB272MOD(i),
                     AQPB272PAP(i),
                     AQPB272SBOP(i),
                     AQPB272TOPE(i),
                     ld_fecpro,
                     AQPB272TASL(i),
                     ln_tasanom,
                     ld_fecpro,
                     AQPB272STAT(i),
                     trunc(sysdate),
                     to_char(sysdate, 'HH:MM:SS'));
                  COMMIT;
                exception
                  when others then
                    null;
                end;
              
              else
                --si existe error
              
                begin
                  insert into AQPB272E
                    (AQPB272ereg,
                     AQPB272eren,
                     AQPB272esuc,
                     AQPB272emda,
                     AQPB272ecta,
                     AQPB272eope,
                     AQPB272ecod,
                     AQPB272emod,
                     AQPB272epap,
                     AQPB272esbop,
                     AQPB272etope,
                     AQPB272efvto,
                     aqpb272etasl,
                     aqpb272etasn,
                     AQPB272efec,
                     aqpb272eest,
                     AQPB272ecode,
                     AQPB272emsge,
                     AQPB272EFREG,
                     AQPB272EHRA)
                  values
                    (AQPB272REG(i),
                     AQPB272REN(i),
                     AQPB272SUC(i),
                     AQPB272MDA(i),
                     AQPB272CTA(i),
                     AQPB272OPE(i),
                     AQPB272COD(i),
                     AQPB272MOD(i),
                     AQPB272PAP(i),
                     AQPB272SBOP(i),
                     AQPB272TOPE(i),
                     ld_fecpro,
                     AQPB272TASL(i),
                     ln_tasanom,
                     ld_fecpro,
                     AQPB272STAT(i),
                     lc_coderr,
                     lc_msgerr,
                     trunc(sysdate),
                     to_char(sysdate, 'HH:MM:SS'));
                  COMMIT;
                exception
                  when others then
                    null;
                end;
              
              end if; --fin de error   lc_error = 'N'             
            
            end if; ---- fin indicador I then       
          ELSE
            begin
              insert into AQPB272E
                (AQPB272ereg,
                 AQPB272eren,
                 AQPB272esuc,
                 AQPB272emda,
                 AQPB272ecta,
                 AQPB272eope,
                 AQPB272ecod,
                 AQPB272emod,
                 AQPB272epap,
                 AQPB272esbop,
                 AQPB272etope,
                 AQPB272efvto,
                 aqpb272etasl,
                 aqpb272etasn,
                 AQPB272efec,
                 aqpb272eest,
                 AQPB272ecode,
                 AQPB272emsge,
                 AQPB272EFREG,
                 AQPB272EHRA)
              values
                (AQPB272REG(i),
                 AQPB272REN(i),
                 AQPB272SUC(i),
                 AQPB272MDA(i),
                 AQPB272CTA(i),
                 AQPB272OPE(i),
                 AQPB272COD(i),
                 AQPB272MOD(i),
                 AQPB272PAP(i),
                 AQPB272SBOP(i),
                 AQPB272TOPE(i),
                 ld_fecpro,
                 AQPB272TASL(i),
                 ln_tasanom,
                 ld_fecpro,
                 AQPB272STAT(i),
                 lc_coderr,
                 lc_msgerr,
                 trunc(sysdate),
                 to_char(sysdate, 'HH:MM:SS'));
            exception
              when others then
                null;
            end;
          END IF; ---- AQPB272TASL(i) > 0 then ---si tasa >0          
        
          --2-- actualiza FSD012
          if AQPB272STAT(i) in (99, 64, 90, 27) or
             AQPB272MOD(i) in (200, 33, 117) or AQPB272TOPE(i) = 550 then
            null; -- No actualiza FSD012
          
          else
            --obtener fecha minima de cronograma
            begin
              pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => AQPB272COD(i),
                                                        pn_mod  => AQPB272MOD(i),
                                                        pn_suc  => AQPB272SUC(i),
                                                        pn_mda  => AQPB272MDA(i),
                                                        pn_pap  => AQPB272PAP(i),
                                                        pn_cta  => AQPB272CTA(i),
                                                        pn_ope  => AQPB272OPE(i),
                                                        pn_sbo  => AQPB272SBOP(i),
                                                        pn_top  => AQPB272TOPE(i),
                                                        ld_f601 => ld_f601);
            end;
          
            ---actualiza FSD012 pgcod = 3 de los creditos con evtipo  = 4 y pgcod =1
            begin
              pq_cr_mora_nominal_lineal.sp_cr_valida_fsd012(pn_emp  => AQPB272COD(i),
                                                            pn_mod  => AQPB272MOD(i),
                                                            pn_suc  => AQPB272SUC(i),
                                                            pn_mda  => AQPB272MDA(i),
                                                            pn_pap  => AQPB272PAP(i),
                                                            pn_cta  => AQPB272CTA(i),
                                                            pn_ope  => AQPB272OPE(i),
                                                            pn_sbo  => AQPB272SBOP(i),
                                                            pn_top  => AQPB272TOPE(i),
                                                            ln_tasa => ln_tasa,
                                                            lc_flag => lc_flag);
            end;
          
            ---obtener tasa moratoria equivalente
            begin
              ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => AQPB272MDA(i),
                                                                      pn_taslin => ln_tasa);
            end;
          
            if nvl(ln_tasanom, 0) > 0 then
              --si tasa es nula
            
              begin
                pq_cr_mora_nominal_lineal.sp_cr_insert_fsd012(pn_emp  => AQPB272COD(i),
                                                              pn_mod  => AQPB272MOD(i),
                                                              pn_suc  => AQPB272SUC(i),
                                                              pn_mda  => AQPB272MDA(i),
                                                              pn_pap  => AQPB272PAP(i),
                                                              pn_cta  => AQPB272CTA(i),
                                                              pn_ope  => AQPB272OPE(i),
                                                              pn_sbo  => AQPB272SBOP(i),
                                                              pn_top  => AQPB272TOPE(i),
                                                              ld_f601 => ld_f601,
                                                              ln_tasa => ln_tasanom,
                                                              lc_flag => lc_flag,
                                                              ln_corr => ln_corr,
                                                              lc_cerr => lc_coderr,
                                                              lc_merr => lc_msgerr);
              end;
            
              --si existe en la aqpb272 actualiza sino INSERTA                                                
              begin
                select count(*)
                  into ln_cantidad
                  from AQPB272 f
                 where f.AQPB272cod = AQPB272COD(i)
                   and f.AQPB272mod = AQPB272MOD(i)
                   and f.AQPB272suc = AQPB272SUC(i)
                   and f.AQPB272mda = AQPB272MDA(i)
                   and f.AQPB272pap = AQPB272PAP(i)
                   and f.AQPB272cta = AQPB272CTA(i)
                   and f.AQPB272ope = AQPB272OPE(i)
                   and f.AQPB272sbop = AQPB272SBOP(i)
                   and f.AQPB272tope = AQPB272TOPE(i);
              exception
                when others then
                  ln_cantidad := 0;
              end;
            
              if ln_cantidad = 0 then
                --inserta
                if lc_flag = 'S' then
                  --si no hay error , insercion en fsd012 correcta
                  begin
                  
                    insert into AQPB272
                      (AQPB272reg,
                       AQPB272ren,
                       AQPB272suc,
                       AQPB272mda,
                       AQPB272cta,
                       AQPB272ope,
                       AQPB272cod,
                       AQPB272mod,
                       AQPB272pap,
                       AQPB272sbop,
                       AQPB272tope,
                       AQPB272fvto,
                       aqpb272tali,
                       aqpb272tano,
                       AQPB272fec,
                       aqpb272est,
                       aqpb272corr,
                       AQPB272FREG,
                       AQPB272HRA)
                    
                    values
                      (AQPB272REG(i),
                       AQPB272REN(i),
                       AQPB272SUC(i),
                       AQPB272MDA(i),
                       AQPB272CTA(i),
                       AQPB272OPE(i),
                       AQPB272COD(i),
                       AQPB272MOD(i),
                       AQPB272PAP(i),
                       AQPB272SBOP(i),
                       AQPB272TOPE(i),
                       ld_f601,
                       ln_tasa,
                       ln_tasanom,
                       ld_fecpro,
                       AQPB272STAT(i),
                       ln_corr,
                       trunc(sysdate),
                       to_char(sysdate, 'HH:MM:SS'));
                    COMMIT;
                  exception
                    when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
                  end;
                
                else
                  --si existe error
                
                  begin
                    insert into AQPB272E
                      (AQPB272ereg,
                       AQPB272eren,
                       AQPB272esuc,
                       AQPB272emda,
                       AQPB272ecta,
                       AQPB272eope,
                       AQPB272ecod,
                       AQPB272emod,
                       AQPB272epap,
                       AQPB272esbop,
                       AQPB272etope,
                       AQPB272efvto,
                       aqpb272etali,
                       aqpb272etano,
                       AQPB272efec,
                       aqpb272eest,
                       AQPB272ecode,
                       AQPB272emsge,
                       AQPB272EFREG,
                       AQPB272EHRA)
                    values
                      (AQPB272REG(i),
                       AQPB272REN(i),
                       AQPB272SUC(i),
                       AQPB272MDA(i),
                       AQPB272CTA(i),
                       AQPB272OPE(i),
                       AQPB272COD(i),
                       AQPB272MOD(i),
                       AQPB272PAP(i),
                       AQPB272SBOP(i),
                       AQPB272TOPE(i),
                       ld_f601,
                       ln_tasa,
                       ln_tasanom,
                       ld_fecpro,
                       AQPB272STAT(i),
                       lc_coderr,
                       lc_msgerr,
                       trunc(sysdate),
                       to_char(sysdate, 'HH:MM:SS'));
                    COMMIT;
                  exception
                    when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
                  end;
                
                end if; --fin de error   lc_error = 'N'             
              
              else
                --actualiza
                begin
                  update AQPB272 f
                     set f.aqpb272corr = ln_corr,
                         f.aqpb272fvto = ld_f601,
                         f.aqpb272tali = ln_tasa,
                         f.aqpb272tano = ln_tasanom
                   where f.AQPB272cod = AQPB272COD(i)
                     and f.AQPB272mod = AQPB272MOD(i)
                     and f.AQPB272suc = AQPB272SUC(i)
                     and f.AQPB272mda = AQPB272MDA(i)
                     and f.AQPB272pap = AQPB272PAP(i)
                     and f.AQPB272cta = AQPB272CTA(i)
                     and f.AQPB272ope = AQPB272OPE(i)
                     and f.AQPB272sbop = AQPB272SBOP(i)
                     and f.AQPB272tope = AQPB272TOPE(i);
                  commit;
                exception
                  when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                    lc_error  := 'S';
                    begin
                      insert into AQPB272E
                        (AQPB272ereg,
                         AQPB272eren,
                         AQPB272esuc,
                         AQPB272emda,
                         AQPB272ecta,
                         AQPB272eope,
                         AQPB272ecod,
                         AQPB272emod,
                         AQPB272epap,
                         AQPB272esbop,
                         AQPB272etope,
                         AQPB272efvto,
                         aqpb272etasl,
                         aqpb272etasn,
                         AQPB272efec,
                         aqpb272eest,
                         AQPB272ecode,
                         AQPB272emsge,
                         AQPB272EFREG,
                         AQPB272EHRA)
                      values
                        (AQPB272REG(i),
                         AQPB272REN(i),
                         AQPB272SUC(i),
                         AQPB272MDA(i),
                         AQPB272CTA(i),
                         AQPB272OPE(i),
                         AQPB272COD(i),
                         AQPB272MOD(i),
                         AQPB272PAP(i),
                         AQPB272SBOP(i),
                         AQPB272TOPE(i),
                         ld_fecpro,
                         AQPB272TASL(i),
                         ln_tasanom,
                         ld_fecpro,
                         AQPB272STAT(i),
                         lc_coderr,
                         lc_msgerr,
                         trunc(sysdate),
                         to_char(sysdate, 'HH:MM:SS'));
                    exception
                      when others then
                        null;
                    end;
                end;
              
              end if;
            else
              begin
                insert into AQPB272E
                  (AQPB272ereg,
                   AQPB272eren,
                   AQPB272esuc,
                   AQPB272emda,
                   AQPB272ecta,
                   AQPB272eope,
                   AQPB272ecod,
                   AQPB272emod,
                   AQPB272epap,
                   AQPB272esbop,
                   AQPB272etope,
                   AQPB272efvto,
                   aqpb272etasl,
                   aqpb272etasn,
                   AQPB272efec,
                   aqpb272eest,
                   AQPB272ecode,
                   AQPB272emsge,
                   AQPB272EFREG,
                   AQPB272EHRA)
                values
                  (AQPB272REG(i),
                   AQPB272REN(i),
                   AQPB272SUC(i),
                   AQPB272MDA(i),
                   AQPB272CTA(i),
                   AQPB272OPE(i),
                   AQPB272COD(i),
                   AQPB272MOD(i),
                   AQPB272PAP(i),
                   AQPB272SBOP(i),
                   AQPB272TOPE(i),
                   ld_fecpro,
                   AQPB272TASL(i),
                   ln_tasanom,
                   ld_fecpro,
                   AQPB272STAT(i),
                   lc_coderr,
                   lc_msgerr,
                   trunc(sysdate),
                   to_char(sysdate, 'HH:MM:SS'));
              exception
                when others then
                  null;
              end;
            end if; -- fin si tasa es nula    
          
          end if;
          ---fin 2---
        
        END LOOP;
      
      END IF;
    
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
  
  end sp_cr_carga_datos;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_job_carga(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     :   sp_cr_job_carga
    -- *****************************************************************
  
    ln_ini    number;
    ln_job    number := 0;
    lc_fecpro char(10);
    lc_nomusr varchar2(20);
  
    lc_hostname varchar2(64);
  
    lc_variable varchar2(100) := 'PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_carga_datos';
  
    /*  cursor sucursal is 
    select * from fst001 where pgcod =1  and   sucurs < 800 \*or sucurs >= 900*\;*/
  
    cursor region is
      select * from fst810 where regcod < 100;
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999;
    exception
      when others then
        lc_nomusr := 'BANTPROD';
    end;
  
    --trunca tabla
    execute immediate 'truncate table AQPB272';
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --  for i in sucursal loop    
    for i in region loop
      ln_ini      := i.regcod;
      lc_variable := 'begin ' ||
                     '  PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_carga_datos(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        --                                    instance => 1,
                        force => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      end if;
      --ln_varjob:= ln_varjob +1;
    end loop;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => lc_nomusr, --', /*'BANTPROD',*/
                                    tabname          => 'AQPB272',
                                    degree           => 1,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    COMMIT;
  
  end sp_cr_job_carga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_actualiza_tasa(ve_cta  in number,
                                 ve_ope  in number,
                                 ve_emp  in number,
                                 ve_mod  in number,
                                 ve_suc  in number,
                                 ve_mda  in number,
                                 ve_pap  in number,
                                 ve_sbo  in number,
                                 ve_top  in number,
                                 vo_tas  in number,
                                 vo_ind  out varchar2,
                                 vo_corr out number,
                                 vo_fvto out date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_tasa
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2021.06.05
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Inserta nueva tasa
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : la Clave del Crédito y la fecha de proceso a consultar en tabla historica.
    -- Fecha                      : 
    -- Modificado                 :                            
    -- Descripcion                : 
    --                              
    -- ***************************************************************** 
    ln_evcorr number;
    ld_fecvto date;
  
    lc_cerr varchar2(50);
    lc_merr varchar2(250);
  
  BEGIN
  
    vo_ind := 'N';
  
    --obtener fecha de vencimiento
    begin
      PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_fecha_ven(pn_emp  => ve_emp,
                                                pn_mod  => ve_mod,
                                                pn_suc  => ve_suc,
                                                pn_mda  => ve_mda,
                                                pn_pap  => ve_pap,
                                                pn_cta  => ve_cta,
                                                pn_ope  => ve_ope,
                                                pn_sbo  => ve_sbo,
                                                pn_top  => ve_top,
                                                ld_f601 => ld_fecvto);
    end;
  
    --insertar tasa
    begin
      PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_insert_fsd012(pn_emp  => ve_emp,
                                                    pn_mod  => ve_mod,
                                                    pn_suc  => ve_suc,
                                                    pn_mda  => ve_mda,
                                                    pn_pap  => ve_pap,
                                                    pn_cta  => ve_cta,
                                                    pn_ope  => ve_ope,
                                                    pn_sbo  => ve_sbo,
                                                    pn_top  => ve_top,
                                                    ld_f601 => ld_fecvto,
                                                    ln_tasa => vo_tas,
                                                    lc_flag => vo_ind,
                                                    ln_corr => ln_evcorr,
                                                    lc_cerr => lc_cerr,
                                                    lc_merr => lc_merr);
    end;
  
    vo_corr := ln_evcorr;
    vo_fvto := ld_fecvto;
    vo_ind  := 'S';
    --insertar en fsd012
  
  END sp_cr_actualiza_tasa;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_insert_fsd012(pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                ld_f601 in date,
                                ln_tasa in number,
                                lc_flag out char,
                                ln_corr out number,
                                lc_cerr out varchar2,
                                lc_merr out varchar2) is
  
    ln_cor012 number := 0;
  
  begin
  
    lc_flag := 'N';
  
    begin
      select /*+index(F FSD01204)*/
       max(f.evcorr)
        into ln_cor012
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
      /*and f.d012co = 'S'*/
      ; --2022.03.07 se comento para que obtenga maximo correlativo 
    exception
      when others then
        ln_cor012 := 0;
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
    ln_corr   := ln_cor012 + 1;
    begin
    
      begin
        insert into fsd012
          (pgcod,
           aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope,
           evcorr,
           evtipo,
           evfval,
           evfvto,
           evimp,
           evttas,
           evtasa,
           evcap,
           evint,
           evmor,
           evscap,
           evsint,
           evsmor,
           evintc,
           evmorc,
           evcd01,
           evcd02,
           evinv,
           evper,
           evtcbi,
           evtcbi1,
           evarb,
           evarb1,
           evmd,
           evmd1,
           evpre,
           evpre1,
           d012cd,
           d012mo,
           d012su,
           d012tr,
           d012re,
           d012fc,
           d012or,
           d012sb,
           d012co)
        
        values
          (pn_emp,
           pn_mod,
           pn_suc,
           pn_mda,
           pn_pap,
           pn_cta,
           pn_ope,
           pn_sbo,
           pn_top,
           ln_corr, --correlativo
           4, --NUEVA tasa moratoria NOMINAL
           ld_f601,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0.00,
           2, -- TIPO TASA LINEAL
           ln_tasa,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0,
           null,
           0,
           0,
           0.00000000,
           0.00000000,
           0.00000000,
           0.00000000,
           null,
           null,
           0.00000000,
           0.00000000,
           0,
           0,
           0,
           0,
           0,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0,
           0,
           'S');
      
        lc_flag := 'S';
        commit;
      exception
        when others then
          lc_flag := 'N';
          lc_cerr := sqlcode;
          lc_merr := sqlerrm;
      end;
    
    end;
  
  end sp_cr_insert_fsd012;
  ---------------------------------------------------------------
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_fecha_ven(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f601 out date) is
  
  BEGIN
    -- Verificamos la minima fecha de la fsd601
  
    begin
      select min(f.ppfpag)
        into ld_f601
        from fsd601 f
       where f.pgcod = pn_emp
         and f.ppmod = pn_mod
         and f.ppsuc = pn_suc
         and f.ppmda = pn_mda
         and f.pppap = pn_pap
         and f.ppcta = pn_cta
         and f.ppoper = pn_ope
         and f.ppsbop = pn_sbo
         and f.pptope = pn_top
         and f.d601co = 'S';
    end;
  
  end sp_cr_fecha_ven;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*
  procedure sp_cr_penalidad_mora
     is
  -- 2021.08.30 dcastro regulariza penalidad e inserta tasa moratoria
  
  CURSOR LISTADO IS
  
   select AQPB272cod PGCOD, AQPB272mod AOMOD, AQPB272suc AOSUC, AQPB272pap AOPAP, 
     AQPB272mda AOMDA, AQPB272cta AOCTA,
     AQPB272ope AOOPER, AQPB272sbop AOSBOP, AQPB272tope AOTOPE, f.AQPB272GRUI , f.AQPB272fec
    from AQPB272 f
   where f.AQPB272est is null
    AND f.AQPB272GRUI NOT IN 
      (SELECT F.TP1NRO1
                 FROM FST198 F
                WHERE TP1COD = 1
                  AND TP1COD1 = 10899
                  AND TP1CORR1 = 1500
                  AND TP1CORR2 = 1
                  AND TP1CORR3 > 0);
   
  pn_emp number;
  pn_mod number;
  pn_suc number;
  pn_mda number;
  pn_pap number;
  pn_cta number;
  pn_ope number;
  pn_sbo number;
  pn_top number;
  ln_cor012 number;
  ln_corr number;
  ln_tasa number;
  ld_f601 date;
  lc_flag  char(1);
  ln_sbopX number;
  ln_sbopY number;
  ln_sbop number;
  ln_sbo number;
  ld_fecdes date;
  ln_tasmor number;
  ln_texto char(1);
  ln_linea number;
  pd_fecha date;
  ld_fvto date;
  
  BEGIN
    
      for i in LISTADO loop
        
        pn_emp := i.PGCOD;
        pn_mod := i.AOMOD;
        pn_suc := i.AOSUC;
        pn_mda := i.AOMDA;
        pn_pap := i.AOPAP;
        pn_cta := i.AOCTA;
        pn_ope := i.AOOPER;
        pn_sbo := i.AOSBOP;
        pn_top := i.AOTOPE;
        pd_fecha := i.AQPB272fec;
        
        --obtener suboperacion, fecha desembolso credito vigente
        begin
          select f.AOSBOP, f.AOFVAL
            into ln_sbop, ld_f601
            from fsd010 f
           where f.pgcod =  pn_emp
             and f.aomod =  pn_mod
             and f.aosuc =  pn_suc
             and f.aomda =  pn_mda
             and f.aopap =  pn_pap
             and f.aocta =  pn_cta
             and f.aooper = pn_ope
             and f.aotope = pn_top
             and f.AOSTAT <> 99;
        exception when others then
           ln_sbop := null;
           ld_f601 := null;
        end;
  
        --obtener fecha de desembolso de suboperacion 0
        begin
          select f.AOFVAL, f.AOTMOR
            into ld_fecdes, ln_tasmor
            from fsd010 f
           where f.pgcod =  pn_emp
             and f.aomod =  pn_mod
             and f.aosuc =  pn_suc
             and f.aomda =  pn_mda
             and f.aopap =  pn_pap
             and f.aocta =  pn_cta
             and f.aooper = pn_ope
             and f.aotope = pn_top
             and f.AOSBOP = 0;
        exception when others then
           ld_fecdes := null;
        end;
       -- dbms_output.put_line('ln_sbop '||ln_sbop ||' ld_fecdes '||ld_fecdes );
       --dbms_output.put_line('pn_cta '||pn_cta||' pn_ope '||pn_ope||' ld_f601 '||ld_f601);
  
        --buscar en x054021
        begin
            select max(x.xlloaosbop)
              into ln_sbopX  
              from X054021 x 
               WHERE x.pgcod     = pn_emp
                 AND x.xlloaomod = pn_mod
                 AND x.xlloaosuc = pn_suc
                 AND x.xlloaomda = pn_mda
                 AND x.xlloaopap = pn_pap
                 AND x.xlloaocta = pn_cta
                 AND x.xlloaooper= pn_ope
                 AND x.xlloaotope= pn_top
                 AND x.xllotxtcod= 250;
        exception when others then
           ln_sbopX := null;
        end;
        
        if ln_sbopX < ln_sbop then  --ln_sbop
          
        begin
            select trim(x.xllotexto)
              into ln_texto
              from X054021 x 
               WHERE x.pgcod     = pn_emp
                 AND x.xlloaomod = pn_mod
                 AND x.xlloaosuc = pn_suc
                 AND x.xlloaomda = pn_mda
                 AND x.xlloaopap = pn_pap
                 AND x.xlloaocta = pn_cta
                 AND x.xlloaooper= pn_ope
                 AND x.xlloaotope= pn_top
                 and x.xlloaosbop= ln_sbopX
                 AND x.xllotxtcod= 250;
        exception when others then
           ln_texto := null;
        end;
  
  
  
      -- dbms_output.put_line('pn_cta '||pn_cta||' pn_ope '||pn_ope||' ln_sob12 '||ln_sob12||' ld_f601 '||ld_f601|| ' ln_tasa '||ln_tasa);
      --dbms_output.put_line('ln_texto '||ln_texto);
                  
        if ln_texto = 'P' then   
  
            -- dbms_output.put_line('pn_cta '||pn_cta||' pn_ope '||pn_ope||' ld_f601 '||ld_f601|| ' ln_tasa '||ln_tasa||' ln_sbopX '||ln_sbopX);          
            ----obtener tasa x054021
            lc_flag := 'N';
            begin
              -- Call the procedure
              PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_actualiza_tasa(ve_cta =>pn_cta, 
                                                        ve_ope => pn_ope, 
                                                        ve_emp => pn_emp,
                                                        ve_mod => pn_mod,
                                                        ve_suc => pn_suc,
                                                        ve_mda => pn_mda,
                                                        ve_pap => pn_pap,
                                                        ve_sbo => ln_sbop,
                                                        ve_top => pn_top,
                                                        vo_ind => lc_flag,
                                                        vo_tas => ln_tasa,
                                                        vo_corr => ln_corr,
                                                        vo_fvto => ld_fvto);
              end;
                 --------------------
              if lc_flag <> 'S' then       
                 rollback;
              else            
              --insertar en fsd012 ultima operacion
              --en x054021 
                ln_sbopY := ln_sbopX + 1;
                for z in ln_sbopY..ln_Sbop-1 loop
  
                   --obtener fecha desembolso de credito y suboperacion a procesar
                    begin
                    select f.AOFVAL
                      into ld_fecdes
                      from fsd010 f
                     where f.pgcod =  pn_emp
                       and f.aomod =  pn_mod
                       and f.aosuc =  pn_suc
                       and f.aomda =  pn_mda
                       and f.aopap =  pn_pap
                       and f.aocta =  pn_cta
                       and f.aooper = pn_ope
                       and f.aotope = pn_top
                       and f.AOSBOP = z;
                  exception when others then
                     ld_fecdes := null;
                  end;
                
                  --insertar en x054021 para todas las suboperaciones faltantes.
                  insert into x054021 x (pgcod,xlloaomod, xlloaosuc, xlloaomda, xlloaopap, xlloaocta, xlloaooper, 
                                         xlloaosbop, xlloaotope, xllousts, xllotxtcod, xllotxtlin, xllotexto, xllotxtfch)
                  values( pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_cta, pn_ope, z, pn_top, 0, 250, 1,'P', ld_fecdes);
                  --commit;
                
                end loop;
  
  
                --insertar en x054021 TASA MORATORIA para la suboperacion vigente
                insert into x054021 x (pgcod,xlloaomod, xlloaosuc, xlloaomda, xlloaopap, xlloaocta, xlloaooper, 
                                       xlloaosbop, xlloaotope, xllousts, xllotxtcod, xllotxtlin, xllotexto, xllotxtfch)
                values( pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_cta, pn_ope, ln_sbop, pn_top, 0, 250, 1,'I', ld_f601);
                --commit;
  
                BEGIN
                       UPDATE AQPB272 A
                       SET A.AQPB272EST   = 'S',
                           A.AQPB272TASAI = ln_tasa,
                           A.AQPB272CORRI = ln_corr,
                           A.AQPB272FVTOI = ld_fvto,
                           a.AQPB272aux1  = 2, 
                           a.AQPB272CAUX1 = 'Reg. Tasa Moratoria'
                       WHERE A.AQPB272COD = pn_emp 
                         AND A.AQPB272SUC = pn_suc 
                         AND A.AQPB272MOD = pn_mod 
                         AND A.AQPB272MDA = pn_mda 
                         AND A.AQPB272PAP = pn_pap 
                         AND A.AQPB272CTA = pn_cta 
                         AND A.AQPB272OPE = pn_ope 
                         AND A.AQPB272SBOP= pn_sbo
                         AND A.AQPB272TOPE= pn_top
                         AND A.AQPB272FEC = pd_fecha;                
                         commit;
                exception when others then
                   null;         
                END;         
                
             end if; -- lc_flag            
  
          end if; --- ln_texto = P    
        
        end if; -- ln_sbop    
        
      end loop;
  
  END sp_cr_penalidad_mora;
  */

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_tasa_mora(pn_mda in number, pn_taslin in number)
    return number is
  
    pn_tasmor number;
  
  begin
  
    begin
      select a.aqpb271tasn --Tasa Nominal 
        into pn_tasmor
        from aqpb271 a --Tabla Tasa Moratoria Lineal a Nominal
       where a.aqpb271mda = pn_mda --moneda
         and a.aqpb271tasl = pn_taslin --Tasa lineal
         and a.aqpb271est = 'S';
    exception
      when others then
        pn_tasmor := null;
    end;
  
    return pn_tasmor;
  
  end fn_cr_tasa_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_valida_fsd012(pn_emp in number,
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                --                            ld_f601 in date,
                                ln_tasa out number,
                                lc_flag out char --,
                                --                            ln_corr out number*/
                                ) is
  
    --ln_cor012   number := 0;
  
    lc_coderr varchar2(250);
    lc_msgerr varchar2(250);
  
  begin
  
    lc_flag := 'N';
  
    begin
      select f.evtasa /*+index(F FSD01204)*/
        into ln_tasa
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
         and f.evtipo = 4
         and f.d012co = 'S'
         and f.evcorr in (select /*+index(F FSD01204)*/
                           max(f.evcorr)
                            from fsd012 f
                           where f.pgcod = pn_emp
                             and f.aomod = pn_mod
                             and f.aosuc = pn_suc
                             and f.aomda = pn_mda
                             and f.aopap = pn_pap
                             and f.aocta = pn_cta
                             and f.aooper = pn_ope
                             and f.aosbop = pn_sbo
                             and f.aotope = pn_top
                             and f.evtipo = 4
                             and f.d012co = 'S'); --2022.03.07 se comento para que obtenga maximo correlativo 
    
      lc_flag := 'S';
    
    exception
      when others then
        lc_flag   := 'N';
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
    end;
  
    begin
      update fsd012 f
         set f.pgcod = 3
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
         and f.evtipo = 4
      /*and f.d012co = 'S'*/
      ; --2022.03.07 se comento para que obtenga maximo correlativo 
      lc_flag := 'S';
      -- COMMIT;
    exception
      when others then
        lc_flag   := 'N';
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
    end;
  
  end sp_cr_valida_fsd012;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_existe_TasaMora(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number) return char is
  
    lc_ind char(1) := null;
  
  begin
  
    begin
      select trim(x.xllotexto)
        into lc_ind
        from X054021 x
       WHERE x.pgcod = pn_emp
         AND x.xlloaomod = pn_mod
         AND x.xlloaosuc = pn_suc
         AND x.xlloaomda = pn_mda
         AND x.xlloaopap = pn_pap
         AND x.xlloaocta = pn_cta
         AND x.xlloaooper = pn_ope
         and x.xlloaosbop = pn_sbo
         AND x.xlloaotope = pn_top
         AND x.xllotxtcod = 250;
    exception
      when others then
        lc_ind := null;
    end;
  
    return lc_ind;
  
  end fn_cr_existe_TasaMora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_117(pn_regcod in number, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.07
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor creditos(pn_regcod number /*, ld_fecpro date*/) is
    
      select /*+ALL_ROWS*/
      -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod AQPB272REG,
       upper(r2.RegNOM) AQPB272REN,
       b.aosuc AQPB272SUC,
       b.aomda AQPB272MDA,
       b.aocta AQPB272CTA,
       b.aooper AQPB272OPE,
       b.pgcod AQPB272COD,
       b.aomod AQPB272MOD,
       b.aopap AQPB272PAP,
       b.aosbop AQPB272SBOP,
       b.aotope AQPB272TOPE,
       b.aotmor AQPB272TASL,
       b.aostat AQPB272STAT
        from fst811 r, FST001 age, fst810 r2, FSD010 b /*,
                                     fst111 f*/
       where b.PGCOD = 1
         and b.aomod = 117 /* f.modulo*/
         and r.pgcod = 1
         and r.oficod = b.aosuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = b.aosuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         AND r.oficod = age.Sucurs
         and b.aostat not in (99, 27)
         and b.aomod not in (29, 120)
         and r.regcod = pn_regcod
         and b.aosuc <> 904
      --   and f.dscod = 50
      --   and b.aomod not in (33,200,117) -----QUITAR LINEA SOLO PARA PRUEBAS
      --   and b.aocta in ( 592,711,1235, 2110, 2480)
      
      --and b.aotmor > 0 -- -tasa mayor a 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ; --and age.Sucurs = lc_sucurs;
  
    TYPE Tp_AQPB272COD IS TABLE OF AQPB272.AQPB272COD%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272REG IS TABLE OF AQPB272.AQPB272REG%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272REN IS TABLE OF AQPB272.AQPB272REN%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272SUC IS TABLE OF AQPB272.AQPB272SUC%TYPE INDEX BY PLS_INTEGER;
  
    TYPE Tp_AQPB272MDA IS TABLE OF AQPB272.AQPB272MDA%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272CTA IS TABLE OF AQPB272.AQPB272CTA%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272OPE IS TABLE OF AQPB272.AQPB272OPE%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272TASL IS TABLE OF AQPB272.AQPB272TASL%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272MOD IS TABLE OF fsd011.SCMOD%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272PAP IS TABLE OF fsd011.SCPAP%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272SBOP IS TABLE OF fsd011.SCSBOP%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272FVTO IS TABLE OF fsd011.SCFVTO%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272TOPE IS TABLE OF fsd011.Sctope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_AQPB272STAT IS TABLE OF fsd011.scstat%TYPE INDEX BY PLS_INTEGER;
  
    ld_Fecpro date;
  
    AQPB272COD Tp_AQPB272COD;
    AQPB272REG Tp_AQPB272REG;
    AQPB272REN Tp_AQPB272REN;
    AQPB272SUC Tp_AQPB272SUC;
    AQPB272MDA Tp_AQPB272MDA;
    AQPB272CTA Tp_AQPB272CTA;
    AQPB272OPE Tp_AQPB272OPE;
  
    AQPB272MOD  Tp_AQPB272MOD;
    AQPB272PAP  Tp_AQPB272PAP;
    AQPB272SBOP Tp_AQPB272SBOP;
  
    AQPB272TOPE Tp_AQPB272TOPE;
    AQPB272TASL Tp_AQPB272TASL;
    AQPB272FVTO Tp_AQPB272FVTO;
    AQPB272STAT Tp_AQPB272STAT;
  
    ln_numero NUMBER;
    --ld_feccon date;
  
    lc_coderr varchar2(50);
    lc_msgerr varchar2(250);
    lc_error  char(1);
  
    ln_tasanom number(10, 6);
    ln_tasa    number(10, 6);
  
    ld_f601 date;
  
    lc_flag     char(1);
    ln_corr     number;
    lc_indMora  char(1);
    ln_cantidad number;
  
  begin
  
    --ld_feccon := to_Date('15/03/2022','DD/MM/YYYY');
    --
    begin
      select count(*) into ln_numero from AQPB272;
    exception
      when no_data_found then
        ln_numero := 0;
    end;
  
    ld_fecpro := pd_fecpro;
  
    ---LINEAS 117 solo actualiza FSD010 , NO inserta en FSD012
  
    OPEN creditos(pn_regcod /*, pd_fecpro */);
    LOOP
      FETCH creditos BULK COLLECT
        INTO AQPB272REG,
             AQPB272REN,
             AQPB272SUC,
             AQPB272MDA,
             AQPB272CTA,
             AQPB272OPE,
             AQPB272COD,
             AQPB272MOD,
             AQPB272PAP,
             AQPB272SBOP,
             AQPB272TOPE,
             AQPB272TASL,
             AQPB272STAT;
    
      IF AQPB272REG.COUNT > 0 THEN
        FOR i IN AQPB272REG.FIRST .. AQPB272REG.LAST LOOP
        
          ln_numero := ln_numero + 1;
          lc_error  := 'N';
        
          lc_indMora := null;
        
          begin
            ---verifica si tiene tasa Mora en X054023 indicador I
            lc_indMora := pq_cr_mora_nominal_lineal.fn_cr_existe_tasamora(pn_emp => AQPB272COD(i),
                                                                          pn_mod => AQPB272MOD(i),
                                                                          pn_suc => AQPB272SUC(i),
                                                                          pn_mda => AQPB272MDA(i),
                                                                          pn_pap => AQPB272PAP(i),
                                                                          pn_cta => AQPB272CTA(i),
                                                                          pn_ope => AQPB272OPE(i),
                                                                          pn_sbo => AQPB272SBOP(i),
                                                                          pn_top => AQPB272TOPE(i));
          end;
          ---obtener tasa moratoria equivalente
          begin
            ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => AQPB272MDA(i),
                                                                    pn_taslin => AQPB272TASL(i));
          end;
        
          IF nvl(ln_tasanom, 0) > 0 then
            ---si tasa >0
          
            --castigado, judicial, estado 550 si aotmor > 0
            --117 verificar que tenga I actualizar en la fsd010 
            --se actualiza por defecto.
            if AQPB272MOD(i) in (200, 33, 117) then
              lc_indMora := 'I'; --se asigna por defecto el valor I
            end if;
          
            if lc_indMora = 'I' then
              --verifica indicador mora x054021
              lc_error := 'N';
              --1--actualizar FSD010
              begin
                update fsd010 f
                   set f.aotmor = ln_tasanom
                 where f.pgcod = AQPB272COD(i)
                   and f.aomod = AQPB272MOD(i)
                   and f.aosuc = AQPB272SUC(i)
                   and f.aomda = AQPB272MDA(i)
                   and f.aopap = AQPB272PAP(i)
                   and f.aocta = AQPB272CTA(i)
                   and f.aooper = AQPB272OPE(i)
                   and f.aosbop = AQPB272SBOP(i)
                   and f.aotope = AQPB272TOPE(i);
                commit;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                  lc_error  := 'S';
              end;
              ---actualizar tabla log
            
              if lc_error = 'N' then
                begin
                
                  insert into AQPB272
                    (AQPB272reg,
                     AQPB272ren,
                     AQPB272suc,
                     AQPB272mda,
                     AQPB272cta,
                     AQPB272ope,
                     AQPB272cod,
                     AQPB272mod,
                     AQPB272pap,
                     AQPB272sbop,
                     AQPB272tope,
                     AQPB272fvto,
                     aqpb272tasl,
                     aqpb272tasn,
                     AQPB272fec,
                     aqpb272est)
                  
                  values
                    (AQPB272REG(i),
                     AQPB272REN(i),
                     AQPB272SUC(i),
                     AQPB272MDA(i),
                     AQPB272CTA(i),
                     AQPB272OPE(i),
                     AQPB272COD(i),
                     AQPB272MOD(i),
                     AQPB272PAP(i),
                     AQPB272SBOP(i),
                     AQPB272TOPE(i),
                     ld_fecpro,
                     AQPB272TASL(i),
                     ln_tasanom,
                     ld_fecpro,
                     AQPB272STAT(i));
                  COMMIT;
                exception
                  when others then
                    null;
                end;
              
              else
                --si existe error
              
                begin
                  insert into AQPB272E
                    (AQPB272ereg,
                     AQPB272eren,
                     AQPB272esuc,
                     AQPB272emda,
                     AQPB272ecta,
                     AQPB272eope,
                     AQPB272ecod,
                     AQPB272emod,
                     AQPB272epap,
                     AQPB272esbop,
                     AQPB272etope,
                     AQPB272efvto,
                     aqpb272etasl,
                     aqpb272etasn,
                     AQPB272efec,
                     aqpb272eest,
                     AQPB272ecode,
                     AQPB272emsge)
                  values
                    (AQPB272REG(i),
                     AQPB272REN(i),
                     AQPB272SUC(i),
                     AQPB272MDA(i),
                     AQPB272CTA(i),
                     AQPB272OPE(i),
                     AQPB272COD(i),
                     AQPB272MOD(i),
                     AQPB272PAP(i),
                     AQPB272SBOP(i),
                     AQPB272TOPE(i),
                     ld_fecpro,
                     AQPB272TASL(i),
                     ln_tasanom,
                     ld_fecpro,
                     AQPB272STAT(i),
                     lc_coderr,
                     lc_msgerr);
                  COMMIT;
                exception
                  when others then
                    null;
                end;
              
              end if; --fin de error   lc_error = 'N'             
            
            end if; ---- fin indicador I then       
          
          END IF; ---- AQPB272TASL(i) > 0 then ---si tasa >0          
        
        END LOOP;
      
      END IF;
    
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
  
  end sp_cr_carga_117;
  -------------------------------------------------------------- 
  procedure sp_cr_job_carga_117(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     :   sp_cr_job_carga
    -- *****************************************************************
  
    ln_ini    number;
    ln_job    number := 0;
    lc_fecpro char(10);
    lc_nomusr varchar2(20);
  
    lc_hostname varchar2(64);
  
    lc_variable varchar2(100) := 'PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_carga_117';
  
    /*  cursor sucursal is 
    select * from fst001 where pgcod =1  and   sucurs < 800 \*or sucurs >= 900*\;*/
  
    cursor region is
      select * from fst810 where regcod < 100;
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999;
    exception
      when others then
        lc_nomusr := 'BANTPROD';
    end;
  
    --trunca tabla
    ---  execute immediate 'truncate table AQPB272'; -- NO ELIMINAR REGISTROS YA INSERTADOS
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --  for i in sucursal loop    
    for i in region loop
      ln_ini      := i.regcod;
      lc_variable := 'begin ' ||
                     '  PQ_CR_MORA_NOMINAL_LINEAL.sp_cr_carga_117(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        --                                    instance => 1,
                        force => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      end if;
      --ln_varjob:= ln_varjob +1;
    end loop;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => lc_nomusr, --', /*'BANTPROD',*/
                                    tabname          => 'AQPB272',
                                    degree           => 1,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    COMMIT;
  
  end sp_cr_job_carga_117;
  -------------------------------------------------------------------------------

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_tasmor_cre(pn_emp   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pd_fec   in date,
                             pn_sis   in varchar,
                             PN_error out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.07
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor creditos is
    
      select /*+ALL_ROWS*/
      -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod AQPB272REG,
       upper(r2.RegNOM) AQPB272REN,
       b.aosuc AQPB272SUC,
       b.aomda AQPB272MDA,
       b.aocta AQPB272CTA,
       b.aooper AQPB272OPE,
       b.pgcod AQPB272COD,
       b.aomod AQPB272MOD,
       b.aopap AQPB272PAP,
       b.aosbop AQPB272SBOP,
       b.aotope AQPB272TOPE,
       b.aotmor AQPB272TASL,
       b.aostat AQPB272STAT,
       b.aofvto AQPB272FVTO
        from fst811 r, FST001 age, fst810 r2, FSD010 b
       where b.PGCOD = 1
         and r.pgcod = 1
         and r.oficod = b.aosuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = b.aosuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         AND r.oficod = age.Sucurs
         and b.pgcod = pn_emp
         and b.aomod = pn_mod
         and b.aosuc = pn_suc
         and b.aomda = pn_mda
         and b.aopap = pn_pap
         and b.aocta = pn_cta
         and b.aooper = pn_ope
         and b.aosbop = pn_sbo
         and b.aotope = pn_top;
  
    ld_Fecpro date;
  
    ln_numero NUMBER;
    --ld_feccon date;
  
    lc_coderr varchar2(50);
    lc_msgerr varchar2(250);
    lc_error  char(1);
  
    ln_tasanom number(10, 6);
    ln_tasa    number(10, 6);
  
    ld_f601 date;
  
    lc_flag     char(1);
    ln_corr     number;
    lc_indMora  char(1);
    ln_cantidad number;
    ln_punto    number(3);
    ln_existe   varchar(1);
    contar_tnm  number(3);
  begin
  
    --ld_feccon := to_Date('15/03/2022','DD/MM/YYYY');
    --
    begin
      select count(*) into ln_numero from AQPB272;
    exception
      when no_data_found then
        ln_numero := 0;
    end;
  
    ld_fecpro := pd_fec;
  
    ln_numero := ln_numero + 1;
    lc_error  := 'N';
    ln_existe := 'N';
  
    lc_indMora := null;
  
    for i in creditos loop
      --validar si existe la tasa nominal en la fsd012 --10.03.2022 HSUAREZ  
      contar_tnm := 0;
      ln_existe := 'N'; --2022.03.14 HSUAREZ. inicializar variable.      --EFUENTES SE VOLVIO AGREGAR 2022.03.22
      BEGIN
        select COUNT(*) /*+index(F FSD01204)*/
          into contar_tnm
          from fsd012 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top
           and f.evtipo = 4
           and f.evttas = 2
           and f.d012co = 'S'
           and f.evcorr in (select /*+index(F FSD01204)*/
                             max(f.evcorr)
                              from fsd012 f
                             where f.pgcod = pn_emp
                               and f.aomod = pn_mod
                               and f.aosuc = pn_suc
                               and f.aomda = pn_mda
                               and f.aopap = pn_pap
                               and f.aocta = pn_cta
                               and f.aooper = pn_ope
                               and f.aosbop = pn_sbo
                               and f.aotope = pn_top
                               and f.evtipo = 4
                               and f.evttas = 2
                               and f.d012co = 'S'); --10.03.2022 HSUAREZ - SE AGREGO VALIDACION DE TNM
        IF contar_tnm > 0 then
          ln_existe := 'S';
        END IF;
      exception
        when others then
          ln_existe := 'N';
      end;
    
      if ln_existe = 'N' then
        --10.03.2022 HSUAREZ SI NO EXISTE SE PROCESA                                    
        begin
          ---verifica si tiene tasa Mora en X054023 indicador I
          lc_indMora := pq_cr_mora_nominal_lineal.fn_cr_existe_tasamora(i.AQPB272COD,
                                                                        i.AQPB272MOD,
                                                                        i.AQPB272SUC,
                                                                        i.AQPB272MDA,
                                                                        i.AQPB272PAP,
                                                                        i.AQPB272CTA,
                                                                        i.AQPB272OPE,
                                                                        i.AQPB272SBOP,
                                                                        i.AQPB272TOPE);
        end;
        ---obtener tasa moratoria equivalente
        begin
          ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                  pn_taslin => i.AQPB272TASL);
        end;
      
        IF /*i.AQPB272TASL > 0 and*/
         nvl(ln_tasanom, 0) > 0 then
          ---si tasa >0
        
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          --castigado, judicial, estado 550 si aotmor > 0
          --117 verificar que tenga I actualizar en la fsd010 
          --se actualiza por defecto.
          if i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
            lc_indMora := 'I'; --se asigna por defecto el valor I
          end if;
        
          if lc_indMora = 'I' then
            --verifica indicador mora x054021
            lc_error := 'N';
            --1--actualizar FSD010
            begin
              update fsd010 f
                 set f.aotmor = ln_tasanom
               where f.pgcod = i.AQPB272COD
                 and f.aomod = i.AQPB272MOD
                 and f.aosuc = i.AQPB272SUC
                 and f.aomda = i.AQPB272MDA
                 and f.aopap = i.AQPB272PAP
                 and f.aocta = i.AQPB272CTA
                 and f.aooper = i.AQPB272OPE
                 and f.aosbop = i.AQPB272SBOP
                 and f.aotope = i.AQPB272TOPE;
              --  commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
                lc_error  := 'S';
            end;
            ---actualizar tabla log
          
            if lc_error = 'N' then
              begin
              
                insert into AQPB272
                  (AQPB272reg,
                   AQPB272ren,
                   AQPB272suc,
                   AQPB272mda,
                   AQPB272cta,
                   AQPB272ope,
                   AQPB272cod,
                   AQPB272mod,
                   AQPB272pap,
                   AQPB272sbop,
                   AQPB272tope,
                   AQPB272fvto,
                   aqpb272tasl,
                   aqpb272tasn,
                   AQPB272fec,
                   aqpb272est,
                   AQPB272SIS,
                   AQPB272FREG,
                   AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   i.AQPB272SUC,
                   i.AQPB272MDA,
                   i.AQPB272CTA,
                   i.AQPB272OPE,
                   i.AQPB272COD,
                   i.AQPB272MOD,
                   i.AQPB272PAP,
                   i.AQPB272SBOP,
                   i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   
                   );
              exception
                when others then
                  null;
              end;
            
            else
              --si existe error
            
              begin
                insert into AQPB272E
                  (AQPB272ereg,
                   AQPB272eren,
                   AQPB272esuc,
                   AQPB272emda,
                   AQPB272ecta,
                   AQPB272eope,
                   AQPB272ecod,
                   AQPB272emod,
                   AQPB272epap,
                   AQPB272esbop,
                   AQPB272etope,
                   AQPB272efvto,
                   aqpb272etasl,
                   aqpb272etasn,
                   AQPB272efec,
                   aqpb272eest,
                   AQPB272ecode,
                   AQPB272emsge,
                   AQPB272ESIS,
                   AQPB272EFREG,
                   AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   i.AQPB272SUC,
                   i.AQPB272MDA,
                   i.AQPB272CTA,
                   i.AQPB272OPE,
                   i.AQPB272COD,
                   i.AQPB272MOD,
                   i.AQPB272PAP,
                   i.AQPB272SBOP,
                   i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   lc_coderr,
                   lc_msgerr,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   );
                --                          COMMIT;
              exception
                when others then
                  null;
              end;
            
            end if; --fin de error   lc_error = 'N'             
          
          end if; ---- fin indicador I then       
        
        END IF; ---- AQPB272TASL(i) > 0 then ---si tasa >0          
      
        --2-- actualiza FSD012
        if /*i.AQPB272STAT in (99,64,90,27) or */
         i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
          null; -- No actualiza FSD012
        
        else
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          ---actualiza FSD012 pgcod = 3 de los creditos con evtipo  = 4 y pgcod =1
          begin
            pq_cr_mora_nominal_lineal.sp_cr_valida_fsd012(pn_emp  => i.AQPB272COD,
                                                          pn_mod  => i.AQPB272MOD,
                                                          pn_suc  => i.AQPB272SUC,
                                                          pn_mda  => i.AQPB272MDA,
                                                          pn_pap  => i.AQPB272PAP,
                                                          pn_cta  => i.AQPB272CTA,
                                                          pn_ope  => i.AQPB272OPE,
                                                          pn_sbo  => i.AQPB272SBOP,
                                                          pn_top  => i.AQPB272TOPE,
                                                          ln_tasa => ln_tasa,
                                                          lc_flag => lc_flag);
          end;
        
          ---obtener tasa moratoria equivalente
          begin
            ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                    pn_taslin => ln_tasa);
          end;
        
          if nvl(ln_tasanom, 0) > 0 then
            --si tasa es nula
          
            begin
              pq_cr_mora_nominal_lineal.sp_cr_insert_fsd012(pn_emp  => i.AQPB272COD,
                                                            pn_mod  => i.AQPB272MOD,
                                                            pn_suc  => i.AQPB272SUC,
                                                            pn_mda  => i.AQPB272MDA,
                                                            pn_pap  => i.AQPB272PAP,
                                                            pn_cta  => i.AQPB272CTA,
                                                            pn_ope  => i.AQPB272OPE,
                                                            pn_sbo  => i.AQPB272SBOP,
                                                            pn_top  => i.AQPB272TOPE,
                                                            ld_f601 => ld_f601,
                                                            ln_tasa => ln_tasanom,
                                                            lc_flag => lc_flag,
                                                            ln_corr => ln_corr,
                                                            lc_cerr => lc_coderr,
                                                            lc_merr => lc_msgerr);
            end;
          
            --si existe en la aqpb272 actualiza sino INSERTA                                                
            begin
              select count(*)
                into ln_cantidad
                from AQPB272 f
               where f.AQPB272cod = i.AQPB272COD
                 and f.AQPB272mod = i.AQPB272MOD
                 and f.AQPB272suc = i.AQPB272SUC
                 and f.AQPB272mda = i.AQPB272MDA
                 and f.AQPB272pap = i.AQPB272PAP
                 and f.AQPB272cta = i.AQPB272CTA
                 and f.AQPB272ope = i.AQPB272OPE
                 and f.AQPB272sbop = i.AQPB272SBOP
                 and f.AQPB272tope = i.AQPB272TOPE;
            exception
              when others then
                ln_cantidad := 0;
            end;
          
            if nvl(ln_cantidad, 0) = 0 then
              --inserta
              if lc_flag = 'S' then
                --si no hay error , insercion en fsd012 correcta
                begin
                
                  insert into AQPB272
                    (AQPB272reg,
                     AQPB272ren,
                     AQPB272suc,
                     AQPB272mda,
                     AQPB272cta,
                     AQPB272ope,
                     AQPB272cod,
                     AQPB272mod,
                     AQPB272pap,
                     AQPB272sbop,
                     AQPB272tope,
                     AQPB272fvto,
                     aqpb272tali,
                     aqpb272tano,
                     AQPB272fec,
                     aqpb272est,
                     aqpb272corr,
                     AQPB272SIS,
                     AQPB272FREG,
                     AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES 
                     )
                  
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     i.AQPB272SUC,
                     i.AQPB272MDA,
                     i.AQPB272CTA,
                     i.AQPB272OPE,
                     i.AQPB272COD,
                     i.AQPB272MOD,
                     i.AQPB272PAP,
                     i.AQPB272SBOP,
                     i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     ln_corr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
                
                exception
                  when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                end;
              
              else
                --si existe error
              
                begin
                  insert into AQPB272E
                    (AQPB272ereg,
                     AQPB272eren,
                     AQPB272esuc,
                     AQPB272emda,
                     AQPB272ecta,
                     AQPB272eope,
                     AQPB272ecod,
                     AQPB272emod,
                     AQPB272epap,
                     AQPB272esbop,
                     AQPB272etope,
                     AQPB272efvto,
                     aqpb272etali,
                     aqpb272etano,
                     AQPB272efec,
                     aqpb272eest,
                     AQPB272ecode,
                     AQPB272emsge,
                     AQPB272ESIS,
                     AQPB272EFREG,
                     AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     )
                  
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     i.AQPB272SUC,
                     i.AQPB272MDA,
                     i.AQPB272CTA,
                     i.AQPB272OPE,
                     i.AQPB272COD,
                     i.AQPB272MOD,
                     i.AQPB272PAP,
                     i.AQPB272SBOP,
                     i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     lc_coderr,
                     lc_msgerr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
                
                exception
                  when others then
                    null;
                end;
              
              end if; --fin de error   lc_error = 'N'             
            
            else
              --actualiza
              begin
                update AQPB272 f
                   set f.aqpb272corr = ln_corr,
                       f.aqpb272fvto = ld_f601,
                       f.aqpb272tali = ln_tasa,
                       f.aqpb272tano = ln_tasanom,
                       AQPB272SIS    = pn_sis,
                       AQPB272FREG   = TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       AQPB272HRA    = to_char(sysdate, 'HH24:MI:SS')
                 where f.AQPB272cod = i.AQPB272COD
                   and f.AQPB272mod = i.AQPB272MOD
                   and f.AQPB272suc = i.AQPB272SUC
                   and f.AQPB272mda = i.AQPB272MDA
                   and f.AQPB272pap = i.AQPB272PAP
                   and f.AQPB272cta = i.AQPB272CTA
                   and f.AQPB272ope = i.AQPB272OPE
                   and f.AQPB272sbop = i.AQPB272SBOP
                   and f.AQPB272tope = i.AQPB272TOPE;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                  lc_error  := 'S';
                  begin
                    insert into AQPB272E
                      (AQPB272ereg,
                       AQPB272eren,
                       AQPB272esuc,
                       AQPB272emda,
                       AQPB272ecta,
                       AQPB272eope,
                       AQPB272ecod,
                       AQPB272emod,
                       AQPB272epap,
                       AQPB272esbop,
                       AQPB272etope,
                       AQPB272efvto,
                       aqpb272etali,
                       aqpb272etano,
                       AQPB272efec,
                       aqpb272eest,
                       AQPB272ecode,
                       AQPB272emsge,
                       AQPB272ESIS,
                       AQPB272EFREG,
                       AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       )
                    
                    values
                      (i.AQPB272REG,
                       i.AQPB272REN,
                       i.AQPB272SUC,
                       i.AQPB272MDA,
                       i.AQPB272CTA,
                       i.AQPB272OPE,
                       i.AQPB272COD,
                       i.AQPB272MOD,
                       i.AQPB272PAP,
                       i.AQPB272SBOP,
                       i.AQPB272TOPE,
                       ld_f601,
                       ln_tasa,
                       ln_tasanom,
                       ld_fecpro,
                       i.AQPB272STAT,
                       lc_coderr,
                       lc_msgerr,
                       pn_sis,
                       TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       );
                  
                  exception
                    when others then
                      null;
                  end;
                
              end;
            
            end if;
          else
            begin
              insert into AQPB272E
                (AQPB272ereg,
                 AQPB272eren,
                 AQPB272esuc,
                 AQPB272emda,
                 AQPB272ecta,
                 AQPB272eope,
                 AQPB272ecod,
                 AQPB272emod,
                 AQPB272epap,
                 AQPB272esbop,
                 AQPB272etope,
                 AQPB272efvto,
                 aqpb272etali,
                 aqpb272etano,
                 AQPB272efec,
                 aqpb272eest,
                 AQPB272ecode,
                 AQPB272emsge,
                 AQPB272ESIS,
                 AQPB272EFREG,
                 AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 )
              
              values
                (i.AQPB272REG,
                 i.AQPB272REN,
                 i.AQPB272SUC,
                 i.AQPB272MDA,
                 i.AQPB272CTA,
                 i.AQPB272OPE,
                 i.AQPB272COD,
                 i.AQPB272MOD,
                 i.AQPB272PAP,
                 i.AQPB272SBOP,
                 i.AQPB272TOPE,
                 ld_f601,
                 ln_tasa,
                 ln_tasanom,
                 ld_fecpro,
                 i.AQPB272STAT,
                 lc_coderr,
                 'Tasa Nominal no es mayor a 0',
                 pn_sis,
                 TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 );
            
            exception
              when others then
                null;
            end;
          end if; -- fin si tasa es nula    
        
        end if;
        ---fin 2---
      end if;
    END LOOP;
  
  end sp_cr_tasmor_cre;

  -----------------------------------------------------------------
  ---- 10.03.2022 HSUAREZ SE AGREGO JOPBS DE CARGA MASIVA
  ----------------------------------------------------------------- 
  PROCEDURE SP_JOB_CARG_ANU_MASIVA(pd_fecpro DATE, pn_usuario in varchar2) IS
  
    --CREACION DE VARIABLES
    ln_ini number;
  
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    lc_pac_nombre varchar2(100);
    lc_prefijo    varchar(10);
    x             number;
    lb_njobs      number(3);
    ln_numjob     number(9) := 0;
  
    Lc_user     varchar(5);
    ln_job      number := 0;
    lc_nomusr   varchar2(20);
    lc_variable varchar2(1000) := 'PQ_CR_MORA_NOMINAL_LINEAL.SP_CR_CARGA_MAS_CRD';
  
    --INICIALIZANDO CURSORES
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800 /*or sucurs >= 900*/
      ;
    cursor region is
      select * from fst810 where regcod < 100;
  
  begin
  
    --INICIALIZCION DE VARIABLES
    lc_fecpro  := to_char(pd_fecpro, 'RRRR.MM.DD');
    lc_user    := substr(pn_usuario, 1, 5);
    lc_prefijo := 'TNM' || lc_user;
  
    lc_paquete    := 'PQ_CR_MORA_NOMINAL_LINEAL';
    lc_proceso    := 'SP_CR_CARGA_MAS_CRD';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
    --HOSTNAME
    begin
      select host_name into lc_hostname from v$instance;
    end;
    BEGIN
      select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 3;
    END;
    --USUARIO DE BD
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999;
    exception
      when others then
        lc_nomusr := 'BANTPROD';
    end;
  
    --  for i in sucursal loop    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_MORA_NOMINAL_LINEAL.SP_CR_CARGA_MAS_CRD(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
    
      --ln_ini := i.sucurs;
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        --                                    instance => 1,
                        force => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      end if;
      --ln_varjob:= ln_varjob +1;
      --GENERANDO CONTADOR PARA LA EJECUCION DE JOBS SE IGUAL DE ACUERDO A GUIA ES DECIR PARA LIMITAR DE ACUERDO A GUIA CUANTO JOBS PODEMOS LANZAR
    
      SELECT count(*)
        INTO x
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
      while x = lb_njobs loop
        --- Parametrizar              BANTPROD
        SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
           AND x.what LIKE '%' || trim(pn_usuario) || '%';
      
      end loop;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob) --VARCHAR(10),NUMBER,VARCHAR(500)
      VALUES
      --('REA_REP_1', ln_ini, lc_variable);
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    end loop;
    /*
        begin
            DBMS_STATS.gather_table_stats(ownname          => lc_nomusr,--', --BANTPROD',
                                          tabname          => 'AQPB272CM',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
        end;
    */
    --tarea continuar jobs validar 
    ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                            lc_hostname,
                                                            lc_paquete,
                                                            lc_proceso,
                                                            pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                              lc_hostname,
                                                              lc_paquete,
                                                              lc_proceso,
                                                              pn_usuario);
    End loop;
    COMMIT;
  END;
  -----------------------------------------------------------------------------------------
  --- 10.03.2022 HSUAREZ SE AGREGO PROCESO  COMPLEMENTARIO PARA LA CARGA MASIVA
  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_CARGA_MAS_CRD(VE_SUC number, VE_FECPRO date) IS
    --CARGAR TRANSACCIONES
    CURSOR LISTA_TRANSACCION IS
      SELECT *
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11156
         AND TP1CORR1 = 1
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         and TP1IMP1 = 2;
    --CARGAR MOVIMIENTOS  
    CURSOR MOVIMIENTOS(VI_MOD NUMBER,
                       VI_TRN NUMBER,
                       VI_ORD NUMBER,
                       VI_FEC DATE,
                       VI_SUC NUMBER) IS
      SELECT *
        FROM FSH016
       WHERE PGCOD = 1
         AND HCMOD = VI_MOD
         AND HTRAN = VI_TRN
         AND HSUCOR = VI_SUC
         AND HFCON = VI_FEC
         AND HCORD = VI_ORD;
    ----VARIABLES
    VS_ERROR  VARCHAR(250);
    VI_FECPRO date;
  BEGIN
    VI_FECPRO := VE_FECPRO;
    --CARGAR TRANSACCIONES 
    FOR X IN LISTA_TRANSACCION LOOP
      --CARGAR MOVIMIENTOS
      FOR Y IN MOVIMIENTOS(X.TP1NRO1,
                           X.TP1NRO2,
                           X.TP1NRO3,
                           VI_FECPRO,
                           VE_SUC) LOOP
        --CAGRA TASA_NOMINAL
        PQ_CR_MORA_NOMINAL_LINEAL.SP_CR_TASMOR_CRE(Y.PGCOD,
                                                   Y.HMODUL,
                                                   Y.HSUCUR,
                                                   Y.HMDA,
                                                   Y.HPAP,
                                                   Y.HCTA,
                                                   Y.HOPER,
                                                   Y.HSUBOP,
                                                   Y.HTOPER,
                                                   VE_FECPRO,
                                                   'PRC_MASIVO',
                                                   VS_ERROR);
      
      END LOOP;
    END LOOP;
  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_valida_fsd012_v2(pn_emp  in number,
                                   pn_mod  in number,
                                   pn_suc  in number,
                                   pn_mda  in number,
                                   pn_pap  in number,
                                   pn_cta  in number,
                                   pn_ope  in number,
                                   pn_sbo  in number,
                                   pn_top  in number,
                                   ln_tasa out number,
                                   lc_flag out char) is
  
    --ln_cor012   number := 0;
  
    lc_coderr varchar2(250);
    lc_msgerr varchar2(250);
  
  begin
  
    lc_flag := 'N';
  
    begin
      select f.evtasa /*+index(F FSD01204)*/
        into ln_tasa
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
         and f.evtipo = 4
         and f.d012co = 'S'
         and f.evcorr in (select /*+index(F FSD01204)*/
                           max(f.evcorr)
                            from fsd012 f
                           where f.pgcod = pn_emp
                             and f.aomod = pn_mod
                             and f.aosuc = pn_suc
                             and f.aomda = pn_mda
                             and f.aopap = pn_pap
                             and f.aocta = pn_cta
                             and f.aooper = pn_ope
                             and f.aosbop = pn_sbo
                             and f.aotope = pn_top
                             and f.evtipo = 4
                             and f.d012co = 'S'); --2022.03.07 se comento para que obtenga maximo correlativo 
      lc_flag := 'S';
    exception
      when others then
        lc_flag   := 'N';
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
    end;
  end sp_cr_valida_fsd012_v2;

  --------------------------------------------------------------------------------- 
  procedure sp_cr_insert_fsd012_v2(pn_emp  in number,
                                   pn_mod  in number,
                                   pn_suc  in number,
                                   pn_mda  in number,
                                   pn_pap  in number,
                                   pn_cta  in number,
                                   pn_ope  in number,
                                   pn_sbo  in number,
                                   pn_top  in number,
                                   ld_f601 in date,
                                   ln_tasa in number,
                                   lc_flag out char,
                                   ln_corr out number,
                                   lc_cerr out varchar2,
                                   lc_merr out varchar2) is
    ln_cor012 number := 0;
    ln_evttas number(1);
  begin
  
    begin
      select f.tattas
        into ln_evttas
        from fsd025 f
       where f.tpizar = 3
         and f.tamod = pn_mod
         and f.tamda = pn_mda
         and f.tafdes = (select max(f.tafdes)
                           from fsd025 f
                          where f.tpizar = 3
                            and f.tamod = pn_mod
                            and f.tamda = pn_mda);
    exception
      when others then
        null;
    end;
  
    lc_flag := 'N';
    begin
      select /*+index(F FSD01204)*/
       max(f.evcorr)
        into ln_cor012
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
      /*and f.d012co = 'S'*/
      ; --2022.03.07 se comento para que obtenga maximo correlativo 
    exception
      when others then
        ln_cor012 := 0;
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
    ln_corr   := ln_cor012 + 1;
    begin
      begin
        /*
        insert into fsd012
          (pgcod,
           aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope,
           evcorr,
           evtipo,
           evfval,
           evfvto,
           evimp,
           evttas,
           evtasa,
           evcap,
           evint,
           evmor,
           evscap,
           evsint,
           evsmor,
           evintc,
           evmorc,
           evcd01,
           evcd02,
           evinv,
           evper,
           evtcbi,
           evtcbi1,
           evarb,
           evarb1,
           evmd,
           evmd1,
           evpre,
           evpre1,
           d012cd,
           d012mo,
           d012su,
           d012tr,
           d012re,
           d012fc,
           d012or,
           d012sb,
           d012co)
        values
          (pn_emp,
           pn_mod,
           pn_suc,
           pn_mda,
           pn_pap,
           pn_cta,
           pn_ope,
           pn_sbo,
           pn_top,
           ln_corr, --correlativo
           4, --NUEVA tasa moratoria NOMINAL
           ld_f601,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0.00,
           ln_evttas, --2, -- TIPO TASA LINEAL
           ln_tasa,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0,
           null,
           0,
           0,
           0.00000000,
           0.00000000,
           0.00000000,
           0.00000000,
           null,
           null,
           0.00000000,
           0.00000000,
           0,
           0,
           0,
           0,
           0,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0,
           0,
           'S');
           */
              update fsd012 d set d.evttas = ln_evttas, d.evtasa = ln_tasa
               where d.pgcod = pn_emp and d.aomod=pn_mod and d.aosuc=pn_suc and d.aomda=pn_mda and d.aopap = pn_pap and d.aocta= pn_cta and d.aooper= pn_ope and d.aosbop = pn_sbo and d.aotope = pn_top  and evtipo=4
                 and evcorr =  ln_cor012; 
                 
              lc_flag := 'S';
              /*insert into prueba_log
              (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
               ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
              (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
               null, null, null, ln_tasa, null, lc_flag, null, 'prb 1 - 010 ef', null);
               */
        commit;
      exception
        when others then
          lc_flag := 'N';
          lc_cerr := sqlcode;
          lc_merr := sqlerrm;
          /*
              insert into prueba_log
              (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
               ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
              (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
               null, null, null, ln_tasa, null, lc_flag, null, 'prb 1 - 010 ef 1', null);
               commit;
          */     
                         
      end;
    
    end;
  
  end sp_cr_insert_fsd012_v2;

  --------------------------------------------------------------------------------- 
  procedure sp_cr_tasmor_cre_v2(pn_emp in number, --clv original del credito
                                pn_mod in number,
                                pn_suc in number,
                                pn_mda in number,
                                pn_pap in number,
                                pn_cta in number,
                                pn_ope in number,
                                pn_sbo in number,
                                pn_top in number,
                                
                                p_empNew in number,
                                p_modNew in number,
                                p_sucNew in number,
                                p_mdaNew in number,
                                p_papNew in number,
                                p_ctaNew in number,
                                p_opeNew in number,
                                p_sboNew in number,
                                p_topNew in number,
                                
                                pd_fec   in date,
                                pn_sis   in varchar,
                                PN_error out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.07
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor creditos is
    
      select /*+ALL_ROWS*/
      -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod AQPB272REG,
       upper(r2.RegNOM) AQPB272REN,
       b.pgcod AQPB272COD,
       b.aomod AQPB272MOD,
       b.aosuc AQPB272SUC,
       b.aomda AQPB272MDA,
       b.aopap AQPB272PAP,
       b.aocta AQPB272CTA,
       b.aooper AQPB272OPE,
       b.aosbop AQPB272SBOP,
       b.aotope AQPB272TOPE,
       b.aotmor AQPB272TASL,
       b.aostat AQPB272STAT,
       b.aofvto AQPB272FVTO,
       b.aofval AQPB272FVAL --EFUENTES AUMENTADO 2022.03.17
        from fst811 r, FST001 age, fst810 r2, FSD010 b
       where b.PGCOD = 1
         and r.pgcod = 1
         and r.oficod = b.aosuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = b.aosuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         AND r.oficod = age.Sucurs
         and b.pgcod = pn_emp
         and b.aomod = pn_mod
         and b.aosuc = pn_suc
         and b.aomda = pn_mda
         and b.aopap = pn_pap
         and b.aocta = pn_cta
         and b.aooper = pn_ope
         and b.aosbop = pn_sbo
         and b.aotope = pn_top;
  
    ld_Fecpro date;
  
    ln_numero NUMBER;
    --ld_feccon date;
  
    lc_coderr varchar2(50);
    lc_msgerr varchar2(250);
    lc_error  char(1);
  
    ln_tasanom number(10, 6);
    ln_tasa    number(10, 6);
  
    ld_f601 date;
  
    lc_flag     char(1);
    ln_corr     number;
    lc_indMora  char(1);
    ln_cantidad number;
    ln_punto    number(3);
    ln_existe   varchar(1);
    contar_tnm  number(3);
  begin
  
    --ld_feccon := to_Date('15/03/2022','DD/MM/YYYY');
    --
    begin
      select count(*) into ln_numero from AQPB272;
    exception
      when no_data_found then
        ln_numero := 0;
    end;
  
    ld_fecpro := pd_fec;
  
    ln_numero := ln_numero + 1;
    lc_error  := 'N';
    ln_existe := 'N';
      
    lc_indMora := null;
  
    for i in creditos loop
      --validar si existe la tasa nominal en la fsd012 --10.03.2022 HSUAREZ  
      contar_tnm := 0;
      ln_existe := 'N'; --2022.03.14 HSUAREZ. inicializar variable.      --EFUENTES SE VOLVIO AGREGAR 2022.03.22
      /*
      insert into prueba_log
      (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
       ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
      (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
       null, null, null, null, null, null, contar_tnm, 'prb 1 - 002 ef', null);
      */
      BEGIN
        select COUNT(*) /*+index(F FSD01204)*/
          into contar_tnm
          from fsd012 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top
           and f.evtipo = 4
           and f.evttas = 2
           and f.d012co = 'S'
           and f.evcorr in (select /*+index(F FSD01204)*/
                             max(f.evcorr)
                              from fsd012 f
                             where f.pgcod = pn_emp
                               and f.aomod = pn_mod
                               and f.aosuc = pn_suc
                               and f.aomda = pn_mda
                               and f.aopap = pn_pap
                               and f.aocta = pn_cta
                               and f.aooper = pn_ope
                               and f.aosbop = pn_sbo
                               and f.aotope = pn_top
                               and f.evtipo = 4
                               and f.evttas = 2
                               and f.d012co = 'S'); --10.03.2022 HSUAREZ - SE AGREGO VALIDACION DE TNM
        IF contar_tnm > 0 then
          ln_existe := 'S';
        END IF;
      exception
        when others then
          ln_existe := 'N';
      end;
      /*
      insert into prueba_log
      (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
       ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
      (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
       null, null, null, null, null, ln_existe, contar_tnm, 'prb 1 - 003 ef', null);
      */
      if ln_existe = 'N' then
        --10.03.2022 HSUAREZ SI NO EXISTE SE PROCESA                                    
        begin
          ---verifica si tiene tasa Mora en X054021 indicador I
          --MODIFICADO
          lc_indMora := pq_cr_mora_nominal_lineal.fn_cr_existe_tasamora(i.AQPB272COD,
                                                                        i.AQPB272MOD,
                                                                        i.AQPB272SUC,
                                                                        i.AQPB272MDA,
                                                                        i.AQPB272PAP,
                                                                        i.AQPB272CTA,
                                                                        i.AQPB272OPE,
                                                                        i.AQPB272SBOP,
                                                                        i.AQPB272TOPE);
        end;
        ---obtener tasa moratoria equivalente
        begin
          ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                  pn_taslin => i.AQPB272TASL);
        end;
      /*
      insert into prueba_log
      (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
       ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
      (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
       null, null, lc_indMora, ln_tasanom, null, ln_existe, contar_tnm, 'prb 1 - 004 ef', null);
      */
        IF nvl(ln_tasanom, 0) > 0 and
           i.aqpb272fval < to_date('15/03/2022', 'dd/mm/yyyy') then
          ---si tasa >0
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          --castigado, judicial, estado 550 si aotmor > 0
          --117 verificar que tenga I actualizar en la fsd010 
          --se actualiza por defecto.
          if i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
            lc_indMora := 'I'; --se asigna por defecto el valor I
          end if;
        
          if lc_indMora = 'I' then
            --verifica indicador mora x054021
            lc_error := 'N';
            --1--actualizar FSD010
            begin
              update fsd010 f
                 set f.aotmor = ln_tasanom
               where f.pgcod = p_empNew --i.AQPB272COD
                 and f.aomod = p_modNew --i.AQPB272MOD
                 and f.aosuc = p_sucNew --i.AQPB272SUC
                 and f.aomda = p_mdaNew --i.AQPB272MDA
                 and f.aopap = p_papNew --i.AQPB272PAP
                 and f.aocta = p_ctaNew --i.AQPB272CTA
                 and f.aooper = p_opeNew --i.AQPB272OPE
                 and f.aosbop = p_sboNew --i.AQPB272SBOP
                 and f.aotope = p_topNew; --i.AQPB272TOPE;
              --  commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
                lc_error  := 'S';
            end;
            ---actualizar tabla log
          /*  
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, i.AQPB272TASL, lc_error, contar_tnm, 'prb 1 - 005 ef'||SUBSTR(lc_msgerr,1,200), null);
          */
            if lc_error = 'N' then
              begin
                insert into AQPB272
                  (AQPB272reg,
                   AQPB272ren,
                   AQPB272suc,
                   AQPB272mda,
                   AQPB272cta,
                   AQPB272ope,
                   AQPB272cod,
                   AQPB272mod,
                   AQPB272pap,
                   AQPB272sbop,
                   AQPB272tope,
                   AQPB272fvto,
                   aqpb272tasl,
                   aqpb272tasn,
                   AQPB272fec,
                   aqpb272est,
                   AQPB272SIS,
                   AQPB272FREG,
                   AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   p_sucNew, --i.AQPB272SUC,
                   p_mdaNew, --i.AQPB272MDA,
                   p_ctaNew, --i.AQPB272CTA,
                   p_opeNew, --i.AQPB272OPE,
                   p_empNew, --i.AQPB272COD,
                   p_modNew, --i.AQPB272MOD,
                   p_papNew, --i.AQPB272PAP,
                   p_sboNew, --i.AQPB272SBOP,
                   p_topNew, --i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   );
              exception
                when others then
                  null;
              end;
            
            else
              /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, i.AQPB272TASL, lc_error, contar_tnm, 'prb 1 - 006 ef'||SUBSTR(lc_msgerr,1,200), null);
           */
              --si existe error
              begin
                insert into AQPB272E
                  (AQPB272ereg,
                   AQPB272eren,
                   AQPB272esuc,
                   AQPB272emda,
                   AQPB272ecta,
                   AQPB272eope,
                   AQPB272ecod,
                   AQPB272emod,
                   AQPB272epap,
                   AQPB272esbop,
                   AQPB272etope,
                   AQPB272efvto,
                   aqpb272etasl,
                   aqpb272etasn,
                   AQPB272efec,
                   aqpb272eest,
                   AQPB272ecode,
                   AQPB272emsge,
                   AQPB272ESIS,
                   AQPB272EFREG,
                   AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   p_sucNew, --i.AQPB272SUC,
                   p_mdaNew, --i.AQPB272MDA,
                   p_ctaNew, --i.AQPB272CTA,
                   p_opeNew, --i.AQPB272OPE,
                   p_empNew, --i.AQPB272COD,
                   p_modNew, --i.AQPB272MOD,
                   p_papNew, --i.AQPB272PAP,
                   p_sboNew, --i.AQPB272SBOP,
                   p_topNew, --i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   lc_coderr,
                   lc_msgerr,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   );
                --                          COMMIT;
              exception
                when others then
                  null;
              end;
            
            end if; --fin de error   lc_error = 'N'             
          end if; ---- fin indicador I then       
        
        END IF; ---- AQPB272TASL(i) > 0 then ---si tasa >0          
      
        --2-- actualiza FSD012
        if i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
          null; -- No actualiza FSD012
        else
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          ---actualiza FSD012 pgcod = 3 de los creditos con evtipo  = 4 y pgcod =1
          begin
            pq_cr_mora_nominal_lineal.sp_cr_valida_fsd012_v2(pn_emp  => i.AQPB272COD,
                                                             pn_mod  => i.AQPB272MOD,
                                                             pn_suc  => i.AQPB272SUC,
                                                             pn_mda  => i.AQPB272MDA,
                                                             pn_pap  => i.AQPB272PAP,
                                                             pn_cta  => i.AQPB272CTA,
                                                             pn_ope  => i.AQPB272OPE,
                                                             pn_sbo  => i.AQPB272SBOP,
                                                             pn_top  => i.AQPB272TOPE,
                                                             ln_tasa => ln_tasa,
                                                             lc_flag => lc_flag);
                                                             
              /*
              insert into prueba_log
              (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
               ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
              (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
               null, null, lc_indMora, ln_tasa, i.AQPB272TASL, lc_flag, contar_tnm, 'prb 1 - 007 ef', null);
              */
           if nvl(ln_tasa,0) = 0 then
             ln_tasa := i.AQPB272TASL;
              /*   
              insert into prueba_log
              (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
               ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
              (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
               null, null, lc_indMora, ln_tasa, i.AQPB272TASL, lc_flag, contar_tnm, 'prb 1 - 007 ef**', null);
              */ 
           end if;
          end;
        
          ---obtener tasa moratoria equivalente
          begin
            ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                    pn_taslin => ln_tasa);
          end;
          /*
            insert into prueba_log
            (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
             ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
            (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
             null, null, lc_indMora, ln_tasanom, i.AQPB272TASL, lc_flag, contar_tnm, 'prb 1 - 008 ef', i.aqpb272fval);
          */ 
           
          if nvl(ln_tasanom, 0) > 0 and
             i.aqpb272fval < to_date('15/03/2022', 'dd/mm/yyyy') then
            --si tasa es nula
            begin
              pq_cr_mora_nominal_lineal.sp_cr_insert_fsd012_v2(pn_emp  => p_empNew, --i.AQPB272COD,
                                                               pn_mod  => p_modNew, --i.AQPB272MOD,
                                                               pn_suc  => p_sucNew, --i.AQPB272SUC,
                                                               pn_mda  => p_mdaNew, --i.AQPB272MDA,
                                                               pn_pap  => p_papNew, --i.AQPB272PAP,
                                                               pn_cta  => p_ctaNew, --i.AQPB272CTA,
                                                               pn_ope  => p_opeNew, --i.AQPB272OPE,
                                                               pn_sbo  => p_sboNew, --i.AQPB272SBOP,
                                                               pn_top  => p_topNew, --i.AQPB272TOPE,
                                                               ld_f601 => ld_f601,
                                                               ln_tasa => ln_tasanom,
                                                               lc_flag => lc_flag,
                                                               ln_corr => ln_corr,
                                                               lc_cerr => lc_coderr,
                                                               lc_merr => lc_msgerr);
            end;
          
            --si existe en la aqpb272 actualiza sino INSERTA                                                
            begin
              select count(*)
                into ln_cantidad
                from AQPB272 f
               where f.AQPB272cod = i.AQPB272COD
                 and f.AQPB272mod = i.AQPB272MOD
                 and f.AQPB272suc = i.AQPB272SUC
                 and f.AQPB272mda = i.AQPB272MDA
                 and f.AQPB272pap = i.AQPB272PAP
                 and f.AQPB272cta = i.AQPB272CTA
                 and f.AQPB272ope = i.AQPB272OPE
                 and f.AQPB272sbop = i.AQPB272SBOP
                 and f.AQPB272tope = i.AQPB272TOPE;
            exception
              when others then
                ln_cantidad := 0;
            end;
          /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, i.AQPB272TASL, lc_flag, ln_cantidad, 'prb 1 - 009 ef', i.aqpb272fval);
          */
            if nvl(ln_cantidad, 0) = 0 then
              --inserta
              if lc_flag = 'S' then
                --si no hay error , insercion en fsd012 correcta
                begin
                
                  insert into AQPB272
                    (AQPB272reg,
                     AQPB272ren,
                     AQPB272suc,
                     AQPB272mda,
                     AQPB272cta,
                     AQPB272ope,
                     AQPB272cod,
                     AQPB272mod,
                     AQPB272pap,
                     AQPB272sbop,
                     AQPB272tope,
                     AQPB272fvto,
                     aqpb272tali,
                     aqpb272tano,
                     AQPB272fec,
                     aqpb272est,
                     aqpb272corr,
                     AQPB272SIS,
                     AQPB272FREG,
                     AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES 
                     )
                  
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     p_sucNew, --i.AQPB272SUC,
                     p_mdaNew, --i.AQPB272MDA,
                     p_ctaNew, --i.AQPB272CTA,
                     p_opeNew, --i.AQPB272OPE,
                     p_empNew, --i.AQPB272COD,
                     p_modNew, --i.AQPB272MOD,
                     p_papNew, --i.AQPB272PAP,
                     p_sboNew, --i.AQPB272SBOP,
                     p_topNew, --i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     ln_corr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
          /*          
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_flag, ln_cantidad, 'prb 1 - 010 ef*', pn_sis);
           */     
                exception
                  when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
          /*          
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_flag, ln_cantidad, 'prb 1 - 011 ef'||substr(lc_msgerr,1,200), pn_sis);
           */
                end;
              
              else
                --si existe error
                begin
                  insert into AQPB272E
                    (AQPB272ereg,
                     AQPB272eren,
                     AQPB272esuc,
                     AQPB272emda,
                     AQPB272ecta,
                     AQPB272eope,
                     AQPB272ecod,
                     AQPB272emod,
                     AQPB272epap,
                     AQPB272esbop,
                     AQPB272etope,
                     AQPB272efvto,
                     aqpb272etali,
                     aqpb272etano,
                     AQPB272efec,
                     aqpb272eest,
                     AQPB272ecode,
                     AQPB272emsge,
                     AQPB272ESIS,
                     AQPB272EFREG,
                     AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     )
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     p_sucNew, --i.AQPB272SUC,
                     p_mdaNew, --i.AQPB272MDA,
                     p_ctaNew, --i.AQPB272CTA,
                     p_opeNew, --i.AQPB272OPE,
                     p_empNew, --i.AQPB272COD,
                     p_modNew, --i.AQPB272MOD,
                     p_papNew, --i.AQPB272PAP,
                     p_sboNew, --i.AQPB272SBOP,
                     p_topNew, --i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     lc_coderr,
                     lc_msgerr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
          /*           
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_flag, ln_cantidad, 'prb 1 - 012 ef', pn_sis);
           */     
                exception
                  when others then
                    null;
                    
                    
                                           lc_msgerr := sqlerrm;--borra
          /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_flag, ln_cantidad, 'prb 1 - 013 ef'||substr(lc_msgerr,1,200), null);
           */
                end;
              
              end if; --fin de error   lc_error = 'N'             
            
            else
              --actualiza
              begin
                update AQPB272 f
                   set f.aqpb272corr = ln_corr,
                       f.aqpb272fvto = ld_f601,
                       f.aqpb272tali = ln_tasa,
                       f.aqpb272tano = ln_tasanom,
                       AQPB272SIS    = pn_sis,
                       AQPB272FREG   = TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       AQPB272HRA    = to_char(sysdate, 'HH24:MI:SS')
                 where f.AQPB272cod = p_empNew --i.AQPB272COD
                   and f.AQPB272mod = p_modNew --i.AQPB272MOD
                   and f.AQPB272suc = p_sucNew --i.AQPB272SUC
                   and f.AQPB272mda = p_mdaNew --i.AQPB272MDA
                   and f.AQPB272pap = p_papNew --i.AQPB272PAP
                   and f.AQPB272cta = p_ctaNew --i.AQPB272CTA
                   and f.AQPB272ope = p_opeNew --i.AQPB272OPE
                   and f.AQPB272sbop = p_sboNew --i.AQPB272SBOP
                   and f.AQPB272tope = p_topNew; --i.AQPB272TOPE;
          /*         
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_flag, ln_cantidad, 'prb 1 - 014 ef', null);
          */ 
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                  lc_error  := 'S';
                  begin
                    insert into AQPB272E
                      (AQPB272ereg,
                       AQPB272eren,
                       AQPB272esuc,
                       AQPB272emda,
                       AQPB272ecta,
                       AQPB272eope,
                       AQPB272ecod,
                       AQPB272emod,
                       AQPB272epap,
                       AQPB272esbop,
                       AQPB272etope,
                       AQPB272efvto,
                       aqpb272etali,
                       aqpb272etano,
                       AQPB272efec,
                       aqpb272eest,
                       AQPB272ecode,
                       AQPB272emsge,
                       AQPB272ESIS,
                       AQPB272EFREG,
                       AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       )
                    values
                      (i.AQPB272REG,
                       i.AQPB272REN,
                       p_sucNew, --i.AQPB272SUC,
                       p_mdaNew, --i.AQPB272MDA,
                       p_ctaNew, --i.AQPB272CTA,
                       p_opeNew, --i.AQPB272OPE,
                       p_empNew, --i.AQPB272COD,
                       p_modNew, --i.AQPB272MOD,
                       p_papNew, --i.AQPB272PAP,
                       p_sboNew, --i.AQPB272SBOP,
                       p_topNew, --i.AQPB272TOPE,
                       ld_f601,
                       ln_tasa,
                       ln_tasanom,
                       ld_fecpro,
                       i.AQPB272STAT,
                       lc_coderr,
                       lc_msgerr,
                       pn_sis,
                       TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       );

                                           lc_msgerr := sqlerrm;--borra
          /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_error, ln_cantidad, 'prb 1 - 015 ef'||substr(lc_msgerr,1,200), null);
           */
                  exception
                    when others then
                      null;
          /*            
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_error, ln_cantidad, 'prb 1 - 016 ef'||substr(lc_msgerr,1,200), null);
           */
           
                  end;
              end;
            end if;
          else
            begin
              insert into AQPB272E
                (AQPB272ereg,
                 AQPB272eren,
                 AQPB272esuc,
                 AQPB272emda,
                 AQPB272ecta,
                 AQPB272eope,
                 AQPB272ecod,
                 AQPB272emod,
                 AQPB272epap,
                 AQPB272esbop,
                 AQPB272etope,
                 AQPB272efvto,
                 aqpb272etali,
                 aqpb272etano,
                 AQPB272efec,
                 aqpb272eest,
                 AQPB272ecode,
                 AQPB272emsge,
                 AQPB272ESIS,
                 AQPB272EFREG,
                 AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 )
              values
                (i.AQPB272REG,
                 i.AQPB272REN,
                 p_sucNew, --i.AQPB272SUC,
                 p_mdaNew, --i.AQPB272MDA,
                 p_ctaNew, --i.AQPB272CTA,
                 p_opeNew, --i.AQPB272OPE,
                 p_empNew, --i.AQPB272COD,
                 p_modNew, --i.AQPB272MOD,
                 p_papNew, --i.AQPB272PAP,
                 p_sboNew, --i.AQPB272SBOP,
                 p_topNew, --i.AQPB272TOPE,
                 ld_f601,
                 ln_tasa,
                 ln_tasanom,
                 ld_fecpro,
                 i.AQPB272STAT,
                 lc_coderr,
                 'Tasa Nominal no es mayor a 0',
                 pn_sis,
                 TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 );
            
                                           lc_msgerr := sqlerrm;--borra
          /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_error, ln_cantidad, 'prb 1 - 017 ef', null);
           */
           
            exception
              when others then
                null;
                
                                           lc_msgerr := sqlerrm;--borra
          /*
          insert into prueba_log
          (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,
           ESTADO,TOPE,INDMORA,TASANOMINAL,AQPB272TASL,FLAG,PUNTO,MSG,FECHA) values
          (pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top,
           null, null, lc_indMora, ln_tasanom, ln_tasa, lc_error, ln_cantidad, 'prb 1 - 018 ef'||substr(lc_msgerr,1,200), null);
           */
           
            end;
          end if; -- fin si tasa es nula    
        
        end if;
        ---fin 2---
      end if;
    END LOOP;
  
  end sp_cr_tasmor_cre_v2;

  --------------------------------------------------------------------------------- 
  procedure sp_cr_tasmor_cre_v3(pn_emp   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pd_fec   in date,
                                pn_sis   in varchar,
                                PN_error out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.07
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor creditos is
    
      select /*+ALL_ROWS*/
      -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod AQPB272REG,
       upper(r2.RegNOM) AQPB272REN,
       b.aosuc AQPB272SUC,
       b.aomda AQPB272MDA,
       b.aocta AQPB272CTA,
       b.aooper AQPB272OPE,
       b.pgcod AQPB272COD,
       b.aomod AQPB272MOD,
       b.aopap AQPB272PAP,
       b.aosbop AQPB272SBOP,
       b.aotope AQPB272TOPE,
       b.aotmor AQPB272TASL,
       b.aostat AQPB272STAT,
       b.aofvto AQPB272FVTO
        from fst811 r, FST001 age, fst810 r2, FSD010 b
       where b.PGCOD = 1
         and r.pgcod = 1
         and r.oficod = b.aosuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = b.aosuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         AND r.oficod = age.Sucurs
         and b.pgcod = pn_emp
         and b.aomod = pn_mod
         and b.aosuc = pn_suc
         and b.aomda = pn_mda
         and b.aopap = pn_pap
         and b.aocta = pn_cta
         and b.aooper = pn_ope
         and b.aosbop = pn_sbo
         and b.aotope = pn_top;
  
    ld_Fecpro date;
  
    ln_numero NUMBER;
    --ld_feccon date;
  
    lc_coderr varchar2(50);
    lc_msgerr varchar2(250);
    lc_error  char(1);
  
    ln_tasanom number(10, 6);
    ln_tasa    number(10, 6);
  
    ld_f601 date;
  
    lc_flag     char(1);
    ln_corr     number;
    lc_indMora  char(1);
    ln_cantidad number;
    ln_punto    number(3);
    ln_existe   varchar(1);
    contar_tnm  number(3);
  begin
  
    --ld_feccon := to_Date('15/03/2022','DD/MM/YYYY');
    --
    begin
      select count(*) into ln_numero from AQPB272;
    exception
      when no_data_found then
        ln_numero := 0;
    end;
  
    ld_fecpro := pd_fec;
  
    ln_numero := ln_numero + 1;
    lc_error  := 'N';
  
    lc_indMora := null;
  
    for i in creditos loop
      --validar si existe la tasa nominal en la fsd012 --10.03.2022 HSUAREZ  
      contar_tnm := 0;
      ln_existe := 'N'; --2022.03.14 HSUAREZ. inicializar variable.      --EFUENTES SE VOLVIO AGREGAR 2022.03.22
      BEGIN
        select COUNT(*) /*+index(F FSD01204)*/
          into contar_tnm
          from fsd012 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top
           and f.evtipo = 4
           and f.evttas = 2
           and f.d012co = 'S'
           and f.evcorr in (select /*+index(F FSD01204)*/
                             max(f.evcorr)
                              from fsd012 f
                             where f.pgcod = pn_emp
                               and f.aomod = pn_mod
                               and f.aosuc = pn_suc
                               and f.aomda = pn_mda
                               and f.aopap = pn_pap
                               and f.aocta = pn_cta
                               and f.aooper = pn_ope
                               and f.aosbop = pn_sbo
                               and f.aotope = pn_top
                               and f.evtipo = 4
                               and f.evttas = 2
                               and f.d012co = 'S'); --10.03.2022 HSUAREZ - SE AGREGO VALIDACION DE TNM
        IF contar_tnm > 0 then
          ln_existe := 'S';
        END IF;
      exception
        when others then
          ln_existe := 'N';
      end;
    
      if ln_existe = 'N' then
        --10.03.2022 HSUAREZ SI NO EXISTE SE PROCESA                                    
        begin
          ---verifica si tiene tasa Mora en X054023 indicador I
          lc_indMora := pq_cr_mora_nominal_lineal.fn_cr_existe_tasamora(i.AQPB272COD,
                                                                        i.AQPB272MOD,
                                                                        i.AQPB272SUC,
                                                                        i.AQPB272MDA,
                                                                        i.AQPB272PAP,
                                                                        i.AQPB272CTA,
                                                                        i.AQPB272OPE,
                                                                        i.AQPB272SBOP,
                                                                        i.AQPB272TOPE);
        end;
      
        ---obtener tasa moratoria equivalente
        begin
          ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                  pn_taslin => i.AQPB272TASL);
        end;
      
        IF /*i.AQPB272TASL > 0 and*/
         nvl(ln_tasanom, 0) > 0 then
          ---si tasa >0
        
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          --castigado, judicial, estado 550 si aotmor > 0
          --117 verificar que tenga I actualizar en la fsd010 
          --se actualiza por defecto.
          if i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
            lc_indMora := 'I'; --se asigna por defecto el valor I
          end if;
        
          if lc_indMora = 'I' then
            --verifica indicador mora x054021
            lc_error := 'N';
            --1--actualizar FSD010
            begin
              update fsd010 f
                 set f.aotmor = ln_tasanom
               where f.pgcod = i.AQPB272COD
                 and f.aomod = i.AQPB272MOD
                 and f.aosuc = i.AQPB272SUC
                 and f.aomda = i.AQPB272MDA
                 and f.aopap = i.AQPB272PAP
                 and f.aocta = i.AQPB272CTA
                 and f.aooper = i.AQPB272OPE
                 and f.aosbop = i.AQPB272SBOP
                 and f.aotope = i.AQPB272TOPE;
              --  commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
                lc_error  := 'S';
            end;
            ---actualizar tabla log
          
            if lc_error = 'N' then
              begin
                insert into AQPB272
                  (AQPB272reg,
                   AQPB272ren,
                   AQPB272suc,
                   AQPB272mda,
                   AQPB272cta,
                   AQPB272ope,
                   AQPB272cod,
                   AQPB272mod,
                   AQPB272pap,
                   AQPB272sbop,
                   AQPB272tope,
                   AQPB272fvto,
                   aqpb272tasl,
                   aqpb272tasn,
                   AQPB272fec,
                   aqpb272est,
                   AQPB272SIS,
                   AQPB272FREG,
                   AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   i.AQPB272SUC,
                   i.AQPB272MDA,
                   i.AQPB272CTA,
                   i.AQPB272OPE,
                   i.AQPB272COD,
                   i.AQPB272MOD,
                   i.AQPB272PAP,
                   i.AQPB272SBOP,
                   i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   
                   );
              exception
                when others then
                  null;
              end;
            
            else
              --si existe error            
              begin
                insert into AQPB272E
                  (AQPB272ereg,
                   AQPB272eren,
                   AQPB272esuc,
                   AQPB272emda,
                   AQPB272ecta,
                   AQPB272eope,
                   AQPB272ecod,
                   AQPB272emod,
                   AQPB272epap,
                   AQPB272esbop,
                   AQPB272etope,
                   AQPB272efvto,
                   aqpb272etasl,
                   aqpb272etasn,
                   AQPB272efec,
                   aqpb272eest,
                   AQPB272ecode,
                   AQPB272emsge,
                   AQPB272ESIS,
                   AQPB272EFREG,
                   AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   )
                values
                  (i.AQPB272REG,
                   i.AQPB272REN,
                   i.AQPB272SUC,
                   i.AQPB272MDA,
                   i.AQPB272CTA,
                   i.AQPB272OPE,
                   i.AQPB272COD,
                   i.AQPB272MOD,
                   i.AQPB272PAP,
                   i.AQPB272SBOP,
                   i.AQPB272TOPE,
                   ld_f601,
                   i.AQPB272TASL,
                   ln_tasanom,
                   ld_fecpro,
                   i.AQPB272STAT,
                   lc_coderr,
                   lc_msgerr,
                   pn_sis,
                   TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                   to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                   );
                --                          COMMIT;
              exception
                when others then
                  null;
              end;
            
            end if; --fin de error   lc_error = 'N'             
          
          end if; ---- fin indicador I then       
        
        END IF; ---- AQPB272TASL(i) > 0 then ---si tasa >0          
      
        --2-- actualiza FSD012
        /*
        if i.AQPB272MOD in (200, 33, 117) or i.AQPB272TOPE = 550 then
          null; -- No actualiza FSD012        
        else
          --obtener fecha minima de cronograma
          begin
            pq_cr_mora_nominal_lineal.sp_cr_fecha_ven(pn_emp  => i.AQPB272COD,
                                                      pn_mod  => i.AQPB272MOD,
                                                      pn_suc  => i.AQPB272SUC,
                                                      pn_mda  => i.AQPB272MDA,
                                                      pn_pap  => i.AQPB272PAP,
                                                      pn_cta  => i.AQPB272CTA,
                                                      pn_ope  => i.AQPB272OPE,
                                                      pn_sbo  => i.AQPB272SBOP,
                                                      pn_top  => i.AQPB272TOPE,
                                                      ld_f601 => ld_f601);
          end;
        
          ---actualiza FSD012 pgcod = 3 de los creditos con evtipo  = 4 y pgcod =1
          begin
            pq_cr_mora_nominal_lineal.sp_cr_valida_fsd012(pn_emp  => i.AQPB272COD,
                                                          pn_mod  => i.AQPB272MOD,
                                                          pn_suc  => i.AQPB272SUC,
                                                          pn_mda  => i.AQPB272MDA,
                                                          pn_pap  => i.AQPB272PAP,
                                                          pn_cta  => i.AQPB272CTA,
                                                          pn_ope  => i.AQPB272OPE,
                                                          pn_sbo  => i.AQPB272SBOP,
                                                          pn_top  => i.AQPB272TOPE,
                                                          ln_tasa => ln_tasa,
                                                          lc_flag => lc_flag);
          end;
        
          ---obtener tasa moratoria equivalente
          begin
            ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => i.AQPB272MDA,
                                                                    pn_taslin => ln_tasa);
          end;
        
          if nvl(ln_tasanom, 0) > 0 then
            --si tasa es nula
          
            begin
              pq_cr_mora_nominal_lineal.sp_cr_insert_fsd012(pn_emp  => i.AQPB272COD,
                                                            pn_mod  => i.AQPB272MOD,
                                                            pn_suc  => i.AQPB272SUC,
                                                            pn_mda  => i.AQPB272MDA,
                                                            pn_pap  => i.AQPB272PAP,
                                                            pn_cta  => i.AQPB272CTA,
                                                            pn_ope  => i.AQPB272OPE,
                                                            pn_sbo  => i.AQPB272SBOP,
                                                            pn_top  => i.AQPB272TOPE,
                                                            ld_f601 => ld_f601,
                                                            ln_tasa => ln_tasanom,
                                                            lc_flag => lc_flag,
                                                            ln_corr => ln_corr,
                                                            lc_cerr => lc_coderr,
                                                            lc_merr => lc_msgerr);
            end;
          
            --si existe en la aqpb272 actualiza sino INSERTA                                                
            begin
              select count(*)
                into ln_cantidad
                from AQPB272 f
               where f.AQPB272cod = i.AQPB272COD
                 and f.AQPB272mod = i.AQPB272MOD
                 and f.AQPB272suc = i.AQPB272SUC
                 and f.AQPB272mda = i.AQPB272MDA
                 and f.AQPB272pap = i.AQPB272PAP
                 and f.AQPB272cta = i.AQPB272CTA
                 and f.AQPB272ope = i.AQPB272OPE
                 and f.AQPB272sbop = i.AQPB272SBOP
                 and f.AQPB272tope = i.AQPB272TOPE;
            exception
              when others then
                ln_cantidad := 0;
            end;
          
            if nvl(ln_cantidad, 0) = 0 then
              --inserta
              if lc_flag = 'S' then
                --si no hay error , insercion en fsd012 correcta
                begin
                  insert into AQPB272
                    (AQPB272reg,
                     AQPB272ren,
                     AQPB272suc,
                     AQPB272mda,
                     AQPB272cta,
                     AQPB272ope,
                     AQPB272cod,
                     AQPB272mod,
                     AQPB272pap,
                     AQPB272sbop,
                     AQPB272tope,
                     AQPB272fvto,
                     aqpb272tali,
                     aqpb272tano,
                     AQPB272fec,
                     aqpb272est,
                     aqpb272corr,
                     AQPB272SIS,
                     AQPB272FREG,
                     AQPB272HRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES 
                     )
                  
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     i.AQPB272SUC,
                     i.AQPB272MDA,
                     i.AQPB272CTA,
                     i.AQPB272OPE,
                     i.AQPB272COD,
                     i.AQPB272MOD,
                     i.AQPB272PAP,
                     i.AQPB272SBOP,
                     i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     ln_corr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
                exception
                  when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                end;
              
              else
                --si existe error
                begin
                  insert into AQPB272E
                    (AQPB272ereg,
                     AQPB272eren,
                     AQPB272esuc,
                     AQPB272emda,
                     AQPB272ecta,
                     AQPB272eope,
                     AQPB272ecod,
                     AQPB272emod,
                     AQPB272epap,
                     AQPB272esbop,
                     AQPB272etope,
                     AQPB272efvto,
                     aqpb272etali,
                     aqpb272etano,
                     AQPB272efec,
                     aqpb272eest,
                     AQPB272ecode,
                     AQPB272emsge,
                     AQPB272ESIS,
                     AQPB272EFREG,
                     AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     )
                  values
                    (i.AQPB272REG,
                     i.AQPB272REN,
                     i.AQPB272SUC,
                     i.AQPB272MDA,
                     i.AQPB272CTA,
                     i.AQPB272OPE,
                     i.AQPB272COD,
                     i.AQPB272MOD,
                     i.AQPB272PAP,
                     i.AQPB272SBOP,
                     i.AQPB272TOPE,
                     ld_f601,
                     ln_tasa,
                     ln_tasanom,
                     ld_fecpro,
                     i.AQPB272STAT,
                     lc_coderr,
                     lc_msgerr,
                     pn_sis,
                     TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                     to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                     );
                exception
                  when others then
                    null;
                end;
              
              end if; --fin de error   lc_error = 'N'             
            
            else
              --actualiza
              begin
                update AQPB272 f
                   set f.aqpb272corr = ln_corr,
                       f.aqpb272fvto = ld_f601,
                       f.aqpb272tali = ln_tasa,
                       f.aqpb272tano = ln_tasanom,
                       AQPB272SIS    = pn_sis,
                       AQPB272FREG   = TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       AQPB272HRA    = to_char(sysdate, 'HH24:MI:SS')
                 where f.AQPB272cod = i.AQPB272COD
                   and f.AQPB272mod = i.AQPB272MOD
                   and f.AQPB272suc = i.AQPB272SUC
                   and f.AQPB272mda = i.AQPB272MDA
                   and f.AQPB272pap = i.AQPB272PAP
                   and f.AQPB272cta = i.AQPB272CTA
                   and f.AQPB272ope = i.AQPB272OPE
                   and f.AQPB272sbop = i.AQPB272SBOP
                   and f.AQPB272tope = i.AQPB272TOPE;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                  lc_error  := 'S';
                  begin
                    insert into AQPB272E
                      (AQPB272ereg,
                       AQPB272eren,
                       AQPB272esuc,
                       AQPB272emda,
                       AQPB272ecta,
                       AQPB272eope,
                       AQPB272ecod,
                       AQPB272emod,
                       AQPB272epap,
                       AQPB272esbop,
                       AQPB272etope,
                       AQPB272efvto,
                       aqpb272etali,
                       aqpb272etano,
                       AQPB272efec,
                       aqpb272eest,
                       AQPB272ecode,
                       AQPB272emsge,
                       AQPB272ESIS,
                       AQPB272EFREG,
                       AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       )
                    values
                      (i.AQPB272REG,
                       i.AQPB272REN,
                       i.AQPB272SUC,
                       i.AQPB272MDA,
                       i.AQPB272CTA,
                       i.AQPB272OPE,
                       i.AQPB272COD,
                       i.AQPB272MOD,
                       i.AQPB272PAP,
                       i.AQPB272SBOP,
                       i.AQPB272TOPE,
                       ld_f601,
                       ln_tasa,
                       ln_tasanom,
                       ld_fecpro,
                       i.AQPB272STAT,
                       lc_coderr,
                       lc_msgerr,
                       pn_sis,
                       TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                       to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                       );
                  exception
                    when others then
                      null;
                  end;
              end;
            end if;
          else
            begin
              insert into AQPB272E
                (AQPB272ereg,
                 AQPB272eren,
                 AQPB272esuc,
                 AQPB272emda,
                 AQPB272ecta,
                 AQPB272eope,
                 AQPB272ecod,
                 AQPB272emod,
                 AQPB272epap,
                 AQPB272esbop,
                 AQPB272etope,
                 AQPB272efvto,
                 aqpb272etali,
                 aqpb272etano,
                 AQPB272efec,
                 aqpb272eest,
                 AQPB272ecode,
                 AQPB272emsge,
                 AQPB272ESIS,
                 AQPB272EFREG,
                 AQPB272EHRA --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 )
              values
                (i.AQPB272REG,
                 i.AQPB272REN,
                 i.AQPB272SUC,
                 i.AQPB272MDA,
                 i.AQPB272CTA,
                 i.AQPB272OPE,
                 i.AQPB272COD,
                 i.AQPB272MOD,
                 i.AQPB272PAP,
                 i.AQPB272SBOP,
                 i.AQPB272TOPE,
                 ld_f601,
                 ln_tasa,
                 ln_tasanom,
                 ld_fecpro,
                 i.AQPB272STAT,
                 lc_coderr,
                 'Tasa Nominal no es mayor a 0',
                 pn_sis,
                 TO_DATE(SYSDATE, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS') --10.03.2022 HSUAREZ - SE AGREGARON PARAMETROS ADICIONALES
                 );
            exception
              when others then
                null;
            end;
          end if; -- fin si tasa es nula            
        end if;
        */
        ---fin 2---
      end if;
    END LOOP;
  
  end sp_cr_tasmor_cre_v3;
  procedure sp_cr_tasa_nominal_300400(
                                      vi_pgcod number,
                                      vi_suc number,
                                      vi_mod number,
                                      vi_tra number,
                                      vi_nrel number,
                                      vi_fcon date,
                                      vi_RTE VARCHAR,
                                      vo_ERROR out varchar
    
    )is
  vi_OrdOri number(2); 
  vi_OrdDst number(2);
  vi_modulo number(3);
  vi_tope   number(3);
  vi_sucur  number(3);
  vi_moneda number(4);
  vi_papel  number(4);
  vi_ctnro  number(9);
  vi_oper   number(9);
  vi_subope number(3);
  vi_fecha_corte date;
  vi_tasa_mora   number(17,6);
  vi_tipotasa    number(3);
  vi_fecha_valor date;
  ln_tasanom number(17,6);
  cursor listado_creditos(v_pgcod number,v_suc number,v_mod number,v_tra number,v_nrel number,v_ord number) is
         select d.modulo   vi_modulo,
                d.ittope   vi_tope,  
                d.itsucd   vi_sucur, 
                d.moneda   vi_moneda,
                d.papel    vi_papel, 
                d.ctnro    vi_ctnro, 
                d.itoper   vi_oper , 
                d.itsubo   vi_subope
           from fsd016 d
          where d.pgcod = vi_pgcod
            and d.itsuc = vi_suc
            and d.itmod = vi_mod
            and d.ittran = vi_tra
            and d.itnrel = vi_nrel
            and d.itord = vi_OrdOri;
  begin
       --validar guia_transaccion_ordinal_consulta
       --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,vi_mod,vi_tra,vi_tasa_mora,'S','OBTENIENDO clave -'||vi_RTE||'ord:'||vi_OrdOri);
       --commit;
       begin
          select tp1imp2,tp1imp3
          into  vi_OrdOri,vi_OrdDst
          from  fst198
          where tp1cod  = 1
            and tp1cod1 = 11156 
            and tp1corr1= 2
            and tp1corr2= 1
            and tp1corr3> 0
            and tp1imp1 = 1
            and tp1nro1 = vi_mod
            and tp1nro2 = vi_tra;
       end;       
       --buscar en la transaccion en vuelo fsd016 Ordinal Credito Origen
       /*
       begin
         select d.modulo,
                d.ittope,
                d.itsucd,
                d.moneda,
                d.papel,
                d.ctnro,
                d.itoper,
                d.itsubo
           into vi_modulo,
                vi_tope,
                vi_sucur,
                vi_moneda,
                vi_papel,
                vi_ctnro,
                vi_oper,
                vi_subope
           from fsd016 d
          where d.pgcod = vi_pgcod
            and d.itsuc = vi_suc
            and d.itmod = vi_mod
            and d.ittran = vi_tra
            and d.itnrel = vi_nrel
            and d.itord = vi_OrdOri;
       exception
         when others then
             vi_modulo := 0;
             vi_tope   := 0;
             vi_sucur  := 0;
             vi_moneda := 0;
             vi_papel  := 0;
             vi_ctnro  := 0;
             vi_oper   := 0;
             vi_subope := 0;
       end;
       */
       FOR X IN listado_creditos(
                                   vi_pgcod,   
                                   vi_suc,
                                   vi_mod,
                                   vi_tra,
                                   vi_nrel,
                                   vi_OrdOri
                                ) LOOP
               --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,VI_CTNRO,vi_oper,vi_tasa_mora,'S','OBTENIENDO clave -'||vi_RTE||'ord:'||vi_OrdOri);
               --commit;
               --buscar la tasa que tiene asignado y la fecha valor en la fsd010
                vi_tasa_mora:= 0;
                vi_tipotasa := 0;
                vi_fecha_valor := to_date('01/01/2001','dd/mm/yyyy');
               begin
                 select a.aotmor,a.aottas,a.aofval
                   into vi_tasa_mora,vi_tipotasa,vi_fecha_valor 
                   from fsd010 a
                  where a.pgcod = vi_pgcod
                    and a.aomod = x.vi_modulo
                    and a.aosuc = x.vi_sucur
                    and a.aomda = x.vi_moneda
                    and a.aopap = x.vi_papel
                    and a.aocta = x.vi_ctnro
                    and a.aooper= x.vi_oper
                    and a.aosbop= x.vi_subope
                    and a.aotope= x.vi_tope;
               exception
                 when others then   
                      vi_tasa_mora  := 0;
                      vi_tipotasa   := 0;
                      vi_fecha_valor:= to_date('01/01/2001','dd/mm/yyyy');
               end;
               --Validamos la fecha
               begin 
                 select to_date(tp1desc,'dd.mm.yyyy')
                   into vi_fecha_corte
                   from fst198
                  where tp1cod  = 1
                    and tp1cod1 = 11156 
                    and tp1corr1= 1
                    and tp1corr2= 2
                    and tp1corr3= 1
                    and tp1nro1 = 1;
               end;
               --comparar fechas
               if vi_fecha_valor > vi_fecha_corte then
                  null;
                  --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,x.VI_CTNRO,x.vi_oper,vi_tasa_mora,'N','LA FECHA VALOR ES MAYOR -'||vi_RTE);
               else
                  if vi_tasa_mora > 0 then
                     --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,x.VI_CTNRO,x.vi_oper,vi_tasa_mora,'S','OBTENIENDO TASA MORA -'||vi_RTE);
                     begin
                        ln_tasanom := 0;
                         begin
                              ln_tasanom := pq_cr_mora_nominal_lineal.fn_cr_tasa_mora(pn_mda    => x.vi_moneda,
                                                                                      pn_taslin => vi_tasa_mora);
                         end;
                         
                         begin
                           if ln_tasanom > 0 then
                             
                             update fsd010 d
                               set d.aotmor= ln_tasanom
                             where d.pgcod = vi_pgcod
                               and d.aomod = x.vi_modulo
                               and d.aosuc = x.vi_sucur
                               and d.aomda = x.vi_moneda
                               and d.aopap = x.vi_papel
                               and d.aocta = x.vi_ctnro
                               and d.aooper= x.vi_oper
                               and d.aosbop= x.vi_subope
                               and d.aotope= x.vi_tope;
                               
                               --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,x.VI_CTNRO,x.vi_oper,ln_tasanom,'S','SE INSERTO TASANOMINAL -'||vi_RTE);
                            --else
                               --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,x.VI_CTNRO,x.vi_oper,ln_tasanom,'S','NO SE INSERTO TASANOMINAL -'||vi_RTE);                             
                            end if;
                            
                         end;
                     end;
                  ELSE
                    null;
                    --INSERT INTO PRUEBA_LOG(PGCOD,AOCTA,AOOPER,TASANOMINAL,FLAG,MSG) VALUES(120,x.VI_CTNRO,x.vi_oper,ln_tasanom,'S','NO SE ENCONTRO TASA -'||vi_RTE);   
                  end if;  
               end if;  
       END LOOP;
  end;

end PQ_CR_MORA_NOMINAL_LINEAL;
/

