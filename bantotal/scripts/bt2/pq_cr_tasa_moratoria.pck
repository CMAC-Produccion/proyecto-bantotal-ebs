create or replace package PQ_CR_TASA_MORATORIA is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.06.06
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : PROCESO PARA TASA MORATORIA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_region_zona(lc_codsuc in number,
                            ln_codreg out number,
                            lc_nomreg out varchar2
                           );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos(pn_regcod number, pd_fecpro in date);   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_job_carga(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
PROCEDURE SP_CR_VALIDAR_RUBRO_FEC(
                                           ve_cta in number,
                                           ve_ope in number,
                                           ve_emp in number,
                                           ve_mod in number,
                                           ve_suc in number,
                                           ve_mda in number,
                                           ve_pap in number,
                                           ve_sbo in number,
                                           ve_top in number,
                                           ve_fecp in date,
                                           --CREDITO ANTES EN LA FECHA ANTERIOR
                                           
                                           vo_emp out number,
                                           vo_cta out number,
                                           vo_ope out number,
                                           vo_mod out number,
                                           vo_suc out number,
                                           vo_mda out number,
                                           vo_pap out number,
                                           vo_sbo out number,
                                           vo_top out number,
                                           vo_sbs out number,
                                           vo_tcr out number --0 mismo credito, 1 reprogramado, 2 refinanciado, 9 ninguno --
                                           );

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE sp_cr_actualiza_tasa(
                                     ve_cta in number,
                                     ve_ope in number,
                                     ve_emp in number,
                                     ve_mod in number,
                                     ve_suc in number,
                                     ve_mda in number,
                                     ve_pap in number,
                                     ve_sbo in number,
                                     ve_top in number,
                                     vo_ind out varchar2,
                                     vo_tas out number,
                                     vo_corr out number,
                                     vo_fvto out date)
                                     ;
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
                            ln_corr out number
                            );

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
                            ld_f601 out date
                            );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function fn_cr_obtiene_instancia(pn_emp  in number,
                                  pn_mod  in number,
                                  pn_suc  in number,
                                  pn_mda  in number,
                                  pn_pap  in number,
                                  pn_cta  in number,
                                  pn_ope  in number,
                                  pn_sbo  in number,
                                  pn_top  in number
                                  ) return number;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_tasa_extorno(pd_fec  in date
                            );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_tasa_extornoI(pd_fec  in date
                            );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
procedure sp_cr_actualiza_tasaext(pd_fec  in date
                            );                            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_penalidad_mora;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_CR_TASA_MORATORIA;
/

create or replace package body PQ_CR_TASA_MORATORIA is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TASA_MORATORIA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.06.06
    -- Autor de Creación          : DCASTRO
    -- Uso                        : PROCESO PARA TASA MORATORIA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2015.02.23
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                             2021.08.17 se agrego procedimiento sp_cr_tasa_extorno, sp_cr_Tasa_extornoI, sp_Cr_tasaext, sp_cr_penalidad_mora
    --                             
    -- *****************************************************************
      
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_region_zona(lc_codsuc in number,
                            ln_codreg out number,
                            lc_nomreg out varchar2
                           ) is

begin
   begin                        
        
    select distinct 
           f.tp1desc,
           f.tp1nro1  
           into  lc_nomreg , ln_codreg
      from fst810 t81 , fst811 t80, fst198 f 
      where t80.pgcod = t81.pgcod
      and t80.regcod = t81.regcod
      and t81.regcod = f.tp1nro2 
      and  tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
      and  t81.regcod < 100
      and  t80.regcod < 100      
      and  t80.oficod =  lc_codsuc;  
  exception when others then
           ln_codreg := 0; 
  end;                                                 

end sp_cr_region_zona;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_carga_datos(pn_regcod in number , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.06.05
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


cursor creditos(pn_regcod number/*, ld_fecpro date*/) is

 select /*+ALL_ROWS*/ 
       -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod        AQPB300REG,
       upper(r2.RegNOM) AQPB300REN, 
       a.scsuc AQPB300SUC,
       a.scmda AQPB300MDA,   
       a.sccta AQPB300CTA, 
       a.scoper AQPB300OPE,
       a.pgcod AQPB300COD, 
       a.scmod AQPB300MOD, 
       a.scpap AQPB300PAP,
       a.scsbop AQPB300SBOP, 
       a.sctope AQPB300TOPE,  
       a.scgru AQPB300GRU,
       substr(a.scrub,12,2) AQPB300RUB,      
       a.scsdo AQPB300SCAP,
       a.scfvto AQPB300FVTO
  from fsd011 a,
       fst811 r,
       FST001 age,
       fst810 r2
 where a.PGCOD = 1
   and a.sccta <> 999999999
   and substr(a.scrub,1,4) in (1411,1414,1415, 1421,1424,1425)
   and a.scmod not in (116,117,200,33,65, 108)
   and a.sctope <> 550
   and r.pgcod = 1 
   and r.oficod = a.scsuc 
   and r.RegCod < 100
   and age.Pgcod  = 1 
   and age.Sucurs = a.scsuc
   and r2.regcod = r.regcod
   and r2.regcod<100
   AND r.oficod = age.Sucurs   
   and a.scstat not in (23,64,90)
   and r.regcod = pn_regcod
   and a.scsuc <> 904
   ;--and age.Sucurs = lc_sucurs;

 
  TYPE Tp_AQPB300COD IS TABLE OF AQPB300.AQPB300COD%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_AQPB300REG IS TABLE OF AQPB300.AQPB300REG%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300REN IS TABLE OF AQPB300.AQPB300REN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300SUC IS TABLE OF AQPB300.AQPB300SUC%TYPE INDEX BY PLS_INTEGER;

  TYPE Tp_AQPB300MDA IS TABLE OF AQPB300.AQPB300MDA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300CTA IS TABLE OF AQPB300.AQPB300CTA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300OPE IS TABLE OF AQPB300.AQPB300OPE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300SCAP IS TABLE OF AQPB300.AQPB300SCAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300MOD IS TABLE OF fsd011.SCMOD%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_AQPB300PAP IS TABLE OF fsd011.SCPAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300SBOP IS TABLE OF fsd011.SCSBOP%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_AQPB300FVTO IS TABLE OF fsd011.SCFVTO%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_AQPB300TOPE IS TABLE OF fsd011.Sctope%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_AQPB300GRU IS TABLE OF AQPB300.AQPB300GRU%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_AQPB300RUB IS TABLE OF AQPB300.AQPB300RUB%TYPE INDEX BY PLS_INTEGER;
  
  ld_Fecpro date;

  AQPB300COD   Tp_AQPB300COD; 
  AQPB300REG   Tp_AQPB300REG;
  AQPB300REN   Tp_AQPB300REN;
  AQPB300SUC   Tp_AQPB300SUC;
  AQPB300MDA   Tp_AQPB300MDA;
  AQPB300CTA   Tp_AQPB300CTA;
  AQPB300OPE   Tp_AQPB300OPE;

  AQPB300MOD   Tp_AQPB300MOD;
  AQPB300PAP   Tp_AQPB300PAP;
  AQPB300SBOP  Tp_AQPB300SBOP;

  AQPB300TOPE  Tp_AQPB300TOPE;
  AQPB300GRU   Tp_AQPB300GRU;
  AQPB300RUB   Tp_AQPB300RUB;
  AQPB300SCAP  Tp_AQPB300SCAP;
  AQPB300FVTO  Tp_AQPB300FVTO;


  vo_emp   aqpb300.aqpb300codi%type;
  vo_cta   aqpb300.aqpb300ctai%type;
  vo_ope   aqpb300.aqpb300opei%type;
  vo_mod   aqpb300.aqpb300modi%type;
  vo_suc   aqpb300.aqpb300suci%type;
  vo_mda   aqpb300.aqpb300mdai%type;
  vo_pap   aqpb300.aqpb300papi%type;
  vo_sbo   aqpb300.aqpb300sbopi%type;
  vo_top   aqpb300.aqpb300topei%type;
  vo_sbs   aqpb300.aqpb300grui%type;
  vo_tcr   aqpb300.aqpb300tcr%type;
    
  ln_numero NUMBER;
  ld_feccon date;
  ln_instancia number;
  ld_Fecdes date;
 
begin

  ld_feccon := to_Date('28/02/2021','DD/MM/YYYY');
  --
   begin      
       select count(*)   
         into ln_numero       
        from AQPB300;
   exception when no_data_found then
       ln_numero := 0;              
   end;
 
   ld_fecpro := pd_fecpro;

   OPEN creditos(pn_regcod /*, pd_fecpro */ );
    LOOP
      FETCH creditos BULK COLLECT
        INTO  AQPB300REG, AQPB300REN, AQPB300SUC,  AQPB300MDA,  AQPB300CTA, AQPB300OPE, 
              AQPB300COD, AQPB300MOD, AQPB300PAP, AQPB300SBOP, AQPB300TOPE, 
              AQPB300GRU, AQPB300RUB, AQPB300SCAP, AQPB300FVTO  ;
              
        IF AQPB300REG.COUNT > 0 THEN
             FOR i IN AQPB300REG.FIRST .. AQPB300REG.LAST LOOP
       
               ln_numero := ln_numero + 1; 

          begin  
                     pq_cr_tasa_moratoria.sp_cr_validar_rubro_fec(ve_cta => AQPB300CTA(i),
                                                     ve_ope => AQPB300OPE(i),
                                                     ve_emp => AQPB300COD(i),
                                                     ve_mod => AQPB300MOD(i),
                                                     ve_suc => AQPB300SUC(i),
                                                     ve_mda => AQPB300MDA(i),
                                                     ve_pap => AQPB300PAP(i),
                                                     ve_sbo => AQPB300SBOP(i),
                                                     ve_top =>  AQPB300TOPE(i),
                                                     ve_fecp => ld_feccon,
                                                     vo_emp => vo_emp,
                                                     vo_cta => vo_cta,
                                                     vo_ope => vo_ope,
                                                     vo_mod => vo_mod,
                                                     vo_suc => vo_suc,
                                                     vo_mda => vo_mda,
                                                     vo_pap => vo_pap,
                                                     vo_sbo => vo_sbo,
                                                     vo_top => vo_top,
                                                     vo_sbs => vo_sbs,
                                                     vo_tcr => vo_tcr);
                 end;

         ld_fecdes :=  null;                
         ln_instancia := null;           
         
         if vo_cta is null then    --inicio de validacion posterior a 28/02/2021    

           begin
             select min(f.aofval)
              into ld_fecdes   --fecha desembolso
              from fsd010 f
             where f.pgcod = AQPB300COD(i)
               and f.aomod = AQPB300MOD(i)
               --and f.aosuc = AQPB300SUC(i)
               and f.aomda = AQPB300MDA(i)
               and f.aopap = AQPB300PAP(i)
               and f.aocta = AQPB300CTA(i)
               and f.aooper = AQPB300OPE(i)
               and f.aosbop = 0--AQPB300SBOP(i)
               ;--and f.aotope = AQPB300TOPE(i);
            exception when others then
                ld_fecdes :=  null;
           end;


              begin

              ln_instancia := pq_cr_tasa_moratoria.fn_cr_obtiene_instancia(pn_emp => AQPB300COD(i),
                                                                  pn_mod => AQPB300MOD(i),
                                                                  pn_suc => AQPB300SUC(i),
                                                                  pn_mda => AQPB300MDA(i),
                                                                  pn_pap => AQPB300PAP(i),
                                                                  pn_cta => AQPB300CTA(i),
                                                                  pn_ope => AQPB300OPE(i),
                                                                  pn_sbo => 0,--vo_sbo,
                                                                  pn_top => AQPB300TOPE(i));
              end; 
               
             if  ld_fecdes > to_date('28/02/2021') or vo_cta is null  then
               begin
                 select substr(wfattsval, 0, instr(wfattsval, ';', 1, 1) - 1) Tipificación
                   into vo_sbs
                   from wfattsvalues a
                  where a.wfinsprcid=ln_instancia
                    and wfattsid = 'TIPO_CREDITO';    
               exception when others then   
                    vo_sbs := null;       
               end;     
             end if;    

          end if;  --fin de validacion posterior a 28/02/2021
             
               begin

               insert into AQPB300 ( AQPB300reg, AQPB300ren, AQPB300suc,  AQPB300mda,  
                                    AQPB300cta, AQPB300ope,  AQPB300cod, AQPB300mod, AQPB300pap, 
                                    AQPB300sbop, AQPB300tope, 
                                    AQPB300gru, AQPB300rub, AQPB300scap, AQPB300fvto,
                                    AQPB300fec,
                                    AQPB300CODI, AQPB300CTAI, AQPB300OPEI, AQPB300MODI, AQPB300SUCI,
                                    AQPB300MDAI, AQPB300PAPI,AQPB300SBOPI, AQPB300TOPEI,
                                    AQPB300GRUI, AQPB300TCR, AQPB300FCON, AQPB300FDES, AQPB300INS
                                   ) 
                       
               values (AQPB300REG(i),AQPB300REN(i),AQPB300SUC(i),AQPB300MDA(i),
                       AQPB300CTA(i),AQPB300OPE(i),
                       AQPB300COD(i), AQPB300MOD(i), AQPB300PAP(i), AQPB300SBOP(i), AQPB300TOPE(i), 
                       AQPB300GRU(i), AQPB300RUB(i), nvl(AQPB300SCAP(i),0)*-1, AQPB300FVTO(i),
                       ld_fecpro,
                       vo_emp, vo_cta, vo_ope, vo_mod, vo_suc, vo_mda, vo_pap, vo_sbo, vo_top, 
                       vo_sbs, vo_tcr, ld_Feccon, ld_fecdes, ln_instancia
                      );
        
               
               COMMIT;
               exception when others then
                      null;
               end;
               
             END LOOP;
             commit; 
          END IF;    
        
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
   

 end sp_cr_carga_datos;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_job_carga(pd_fecpro in date) is
-- *****************************************************************
-- Nombre                     :   sp_cr_job_carga
-- *****************************************************************
  

ln_ini number;
ln_job number:=0;
lc_fecpro char(10);
lc_nomusr varchar2(20);


lc_hostname varchar2(64);

lc_variable varchar2(100):='PQ_CR_TASA_MORATORIA.sp_cr_carga_datos';


/*  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 \*or sucurs >= 900*\;*/
   
  cursor region is
  select * from fst810 where regcod <100; 

begin

  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

  begin
    select TRIM(TP1DESC)
      INTO lc_nomusr
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10847
       and tp1corr1 = 999;
  exception when others then
     lc_nomusr := 'BANTPROD';
  end;




    --trunca tabla
    execute immediate 'truncate table AQPB300';

    lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
        
          

        
   --  for i in sucursal loop    
     for i in region loop
          ln_ini := i.regcod;
          lc_variable := 'begin '||'  PQ_CR_TASA_MORATORIA.sp_cr_carga_datos('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
                               
              
             IF SYS.FN_BD_ISRAC='TRUE' THEN
                   DBMS_JOB.SUBMIT(job => ln_job, 
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                instance => 2,
--                                    instance => 1,
                                force => false
                                );
              else
                   DBMS_JOB.SUBMIT(job => ln_job, 
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                force => false
                                );
                      
              end if;    
              --ln_varjob:= ln_varjob +1;
    end loop;          

    begin
        DBMS_STATS.gather_table_stats(ownname          => lc_nomusr,--', /*'BANTPROD',*/
                                      tabname          => 'AQPB300',
                                      degree           => 1,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    COMMIT;
        

end sp_cr_job_carga;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE SP_CR_VALIDAR_RUBRO_FEC(
                                           ve_cta in number,
                                           ve_ope in number,
                                           ve_emp in number,
                                           ve_mod in number,
                                           ve_suc in number,
                                           ve_mda in number,
                                           ve_pap in number,
                                           ve_sbo in number,
                                           ve_top in number,
                                           ve_fecp in date,
                                           --CREDITO ANTES EN LA FECHA ANTERIOR
                                           
                                           vo_emp out number,
                                           vo_cta out number,
                                           vo_ope out number,
                                           vo_mod out number,
                                           vo_suc out number,
                                           vo_mda out number,
                                           vo_pap out number,
                                           vo_sbo out number,
                                           vo_top out number,
                                           vo_sbs out number,
                                           vo_tcr out number --0 mismo credito, 1 reprogramado, 2 refinanciado, 9 ninguno --
                                           ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_VALIDAR_RUBRO_FEC
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2021.06.05
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Valida Rubro en la fecha de proceso consultado devuelve el Rubro y el Credito a esa fecha de consulta en tabla historica.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      : la Clave dle Crédito y la fecha de proceso a consultar en tabla historica.
    -- Fecha                      : 
    -- Modificado                 :                            
    -- Descripcion                : 
    --                              
    -- ***************************************************************** 
 BEGIN
    
       vo_tcr := 9;
       begin
           select f.bcemp, f.bcmod, f.bcsuc, f.bcmda, f.bcpap, f.bccta, f.bcoper, f.bcsbop, f.bctop, f.bcgpo, 0
             into vo_emp, vo_mod, vo_suc, vo_mda, vo_pap, vo_cta, vo_ope, vo_sbo, vo_top, vo_sbs, vo_tcr
            from fsh012 f
            WHERE f.bcemp = ve_emp
             and  f.bcmod = ve_mod
             and  f.bcsuc = ve_suc
             and  f.bcmda = ve_mda
             and  f.bcpap = ve_pap
             and  f.bccta = ve_cta
             and  f.bcoper= ve_ope
             and  f.bcsbop= ve_sbo
             and  f.bctop = ve_top
             and  f.bcfech= ve_fecp;
      exception 
          when others then 
          --En caso de no encontrar registros con la clave del credito se busca sin considerar la suboperación.
          begin
               select f.bcemp, f.bcmod, f.bcsuc, f.bcmda, f.bcpap, f.bccta, f.bcoper, f.bcsbop, f.bctop, f.bcgpo, 1
                 into vo_emp, vo_mod, vo_suc, vo_mda, vo_pap, vo_cta, vo_ope, vo_sbo, vo_top, vo_sbs, vo_tcr
               from fsh012 f,fsd014 d
                WHERE f.bcemp = ve_emp
                 and  f.bcfech= ve_fecp
                 and  f.bcrubr = d.rubro
                 and  f.bccta = ve_cta
                 and  f.bcmod = ve_mod
                 --and  f.bcsuc = ve_suc
                 and  f.bcmda = ve_mda
                 and  f.bcpap = ve_pap                 
                 and  f.bcoper= ve_ope
                 and d.rubro = f.bcrubr
                 and d.pcimpu = 'S'
                 and d.pcnivc in (select modulo from fst111
                                where dscod = 50 and modulo not in (29, 120, 141, 144, 33)
                              )
                 and d.pmtit <> 9;
                 --and  f.bcsbop= ve_sbo
                 --and  f.bctop = ve_top;
          exception 
                 when others then
                 --En caso de no encontrar registros no considerar la operacion y suboperación 
                 begin
                       select f.bcemp, f.bcmod, f.bcsuc, f.bcmda, f.bcpap, f.bccta, f.bcoper, f.bcsbop, f.bctop, f.bcgpo, 1
                         into vo_emp, vo_mod, vo_suc, vo_mda, vo_pap, vo_cta, vo_ope, vo_sbo, vo_top, vo_sbs, vo_tcr
                       from fsh012 f,fsd014 d
                        WHERE f.bcemp = ve_emp
                         and  f.bcfech= ve_fecp
                         and  f.bcrubr = d.rubro
                         and  f.bccta = ve_cta
                         and  f.bcmod = ve_mod
                         --and  f.bcsuc = ve_suc
                         and  f.bcmda = ve_mda
                         and  f.bcpap = ve_pap                 
                         --and  f.bcoper= ve_ope
                         and d.rubro = f.bcrubr
                         and d.pcimpu = 'S'
                         and d.pcnivc in (select modulo from fst111
                                        where dscod = 50 and modulo not in (29, 120, 141, 144, 33)
                                      )
                         and d.pmtit <> 9;
                         --and  f.bcsbop= ve_sbo
                         --and  f.bctop = ve_top;          
                 exception
                   when others then
                     null;
                 end;     
          end;
      end;

  
 END SP_CR_VALIDAR_RUBRO_FEC;
 
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE sp_cr_actualiza_tasa(
                                     ve_cta in number,
                                     ve_ope in number,
                                     ve_emp in number,
                                     ve_mod in number,
                                     ve_suc in number,
                                     ve_mda in number,
                                     ve_pap in number,
                                     ve_sbo in number,
                                     ve_top in number,
                                     vo_ind out varchar2,
                                     vo_tas out number,
                                     vo_corr out number,
                                     vo_fvto out date
                                     ) is
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

 BEGIN

       vo_ind := 'N';
       
       --obtener tasa a aplicar
 
       begin
         SELECT f.tp1imp1 
          into vo_tas
          FROM FST198 f 
           WHERE F.TP1COD = 1
                     AND F.TP1COD1 = 11138
                     AND F.TP1CORR1 = 19
                     AND F.TP1CORR2 = 1
                     AND F.TP1CORR3 > 0
                     AND F.TP1NRO1 = ve_mda;
       exception when others then
            vo_tas := 0 ;              
       end;


        
        --obtener fecha de vencimiento
        begin
          pq_cr_tasa_moratoria.sp_cr_fecha_ven(pn_emp => ve_emp,
                                               pn_mod => ve_mod,
                                               pn_suc => ve_suc,
                                               pn_mda => ve_mda,
                                               pn_pap => ve_pap,
                                               pn_cta => ve_cta,
                                               pn_ope => ve_ope,
                                               pn_sbo => ve_sbo,
                                               pn_top => ve_top,
                                               ld_f601 => ld_fecvto);
        end;        
        
        --insertar tasa
        begin
          pq_cr_tasa_moratoria.sp_cr_insert_fsd012(pn_emp => ve_emp,
                                                   pn_mod => ve_mod,
                                                   pn_suc => ve_suc,
                                                   pn_mda => ve_mda,
                                                   pn_pap => ve_pap,
                                                   pn_cta => ve_cta,
                                                   pn_ope => ve_ope,
                                                   pn_sbo => ve_sbo,
                                                   pn_top => ve_top,
                                                   ld_f601 => ld_fecvto,
                                                   ln_tasa => vo_tas,
                                                   lc_flag => vo_ind,
                                                   ln_corr => ln_evcorr);
        end;

        
        vo_corr := ln_evcorr;
        vo_fvto := ld_fecvto;
        vo_ind := 'S';        
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
                            ln_corr out number
                            ) is
  
    ln_cor012   number := 0;
  
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
         /*and f.d012co = 'S'*/; --2021.08.17 se comento para que obtenga maximo correlativo 
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
    ln_corr := ln_cor012  + 1;
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
           4, --tasa moratoria
           ld_f601,
           '1/01/0001',
           0.00,
           1,
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
           '1/01/0001',
           0,
           0,
           'S');
           
           lc_flag := 'S';
           --commit;
      exception
        when others then
           lc_flag := 'N';
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
                            ld_f601 out date
                            ) is


 ld_fecha date;      
 ln_pp1nump number;               
 lc_estado VARCHAR2(1);       

 BEGIN                            
      -- Verificamos la ultima fecha de la fsd602
  begin
    select max(f.pp1nump)
      into ln_pp1nump
      from fsd602 f
     where f.pgcod = pn_emp
       and f.ppmod = pn_mod
       and f.ppsuc = pn_suc
       and f.ppmda = pn_mda
       and f.pppap = pn_pap
       and f.ppcta = pn_cta
       and f.ppoper = pn_ope
       and f.ppsbop = pn_sbo
       and f.pptope = pn_top
       and f.d602co = 'S';
  exception
    when others then
      ln_pp1nump := 0;
  end;

  if ln_pp1nump > 0 then
      --obtenemos la fecha de la misma cuota con el ppnump

      begin
        select f.pp1stat, f.ppfpag
          into lc_estado, ld_fecha
          from fsd602 f
       where f.pgcod = pn_emp
         and f.ppmod = pn_mod
         and f.ppsuc = pn_suc
         and f.ppmda = pn_mda
         and f.pppap = pn_pap
         and f.ppcta = pn_cta
         and f.ppoper = pn_ope
         and f.ppsbop = pn_sbo
         and f.pptope = pn_top
         and f.d602co = 'S'
         and f.pp1nump = ln_pp1nump;
      exception
        when others then
          lc_estado := null;
      end;
          
          
      if lc_estado = 'P' then 
        --obtenemos la fecha de la misma cuota con el ppnump
        ld_f601 := ld_fecha;
      elsif  lc_estado = 'T' then 

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
             and f.ppfpag > ld_fecha
             and f.d601co = 'S';
         end;
     elsif  lc_estado is null then  --no realizo pagos
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
     end if;        
  else
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
   
  end if;   
          
end sp_cr_fecha_ven;        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_cr_obtiene_instancia(pn_emp  in number,
                                  pn_mod  in number,
                                  pn_suc  in number,
                                  pn_mda  in number,
                                  pn_pap  in number,
                                  pn_cta  in number,
                                  pn_ope  in number,
                                  pn_sbo  in number,
                                  pn_top  in number
                                  ) return number is

ln_instancia number;

begin

   begin                               
      select min(x.xwfprcins)
        into ln_instancia 
        from xwf700 x 
       where x.xwfempresa =  pn_emp
         and x.xwfsucursal = pn_suc
         and x.xwfmodulo =   pn_mod
         and x.xwfmoneda =   pn_mda
         and x.xwfpapel =    pn_pap
         and x.xwfcuenta =   pn_cta
         and x.xwfoperacion = pn_ope
         and x.xwfsubope =    pn_sbo;
    exception when others then
         ln_instancia := null;     
    end;

    return ln_instancia;
    
end fn_cr_obtiene_instancia;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_tasa_extorno(pd_fec  in date
                            ) is


cursor creditos is
--validando creditos extornados
   select f.PGCOD AQPB300COD ,  f.AOMOD AQPB300MOD,   f.AOSUC AQPB300SUC,  
   f.AOMDA AQPB300MDA,   f.AOPAP AQPB300PAP,   f.AOCTA AQPB300CTA ,   f.AOOPER AQPB300OPE,   
   f.AOSBOP AQPB300SBOP, f.AOTOPE  AQPB300TOPE, f.AOSTAT, f.AOFVAL, a.AQPB300REG, a.AQPB300REN--, a.*
   from fsd010 f ,aqpb300 a
   where
       f.PGCOD = a.aqpb300cod
   and f.AOMOD = a.aqpb300mod
   and f.AOSUC = a.aqpb300suc
   and f.AOMDA = a.aqpb300mda
   and f.AOPAP = a.aqpb300pap
   and f.AOCTA = a.aqpb300cta
   and f.AOOPER = a.aqpb300ope
   and f.AOSBOP <> a.aqpb300sbop 
   and f.AOSTAT <> 99
   and a.aqpb300est = 'S' ;

  ld_Fecpro date;

  vo_emp   aqpb300.aqpb300codi%type;
  vo_cta   aqpb300.aqpb300ctai%type;
  vo_ope   aqpb300.aqpb300opei%type;
  vo_mod   aqpb300.aqpb300modi%type;
  vo_suc   aqpb300.aqpb300suci%type;
  vo_mda   aqpb300.aqpb300mdai%type;
  vo_pap   aqpb300.aqpb300papi%type;
  vo_sbo   aqpb300.aqpb300sbopi%type;
  vo_top   aqpb300.aqpb300topei%type;
  vo_sbs   aqpb300.aqpb300grui%type;
  vo_tcr   aqpb300.aqpb300tcr%type;
    
  ln_numero NUMBER;
  ld_feccon date;
  ln_instancia number;
  ld_Fecdes date;
 
begin

  ld_feccon := to_Date('28/02/2021','DD/MM/YYYY');
  --
  ld_fecpro := pd_fec;-- to_Date('21/07/2021','DD/MM/YYYY'); --actualizar fecha a la del proceso es decir a la de hoy

  for i in  creditos loop
      vo_cta := null;
      
      begin  
           pq_cr_tasa_moratoria.sp_cr_validar_rubro_fec(ve_cta => i.AQPB300CTA,
                                           ve_ope => i.AQPB300OPE,
                                           ve_emp => i.AQPB300COD,
                                           ve_mod => i.AQPB300MOD,
                                           ve_suc => i.AQPB300SUC,
                                           ve_mda => i.AQPB300MDA,
                                           ve_pap => i.AQPB300PAP,
                                           ve_sbo => i.AQPB300SBOP,
                                           ve_top => i.AQPB300TOPE,
                                           ve_fecp => ld_feccon,
                                           vo_emp => vo_emp,
                                           vo_cta => vo_cta,
                                           vo_ope => vo_ope,
                                           vo_mod => vo_mod,
                                           vo_suc => vo_suc,
                                           vo_mda => vo_mda,
                                           vo_pap => vo_pap,
                                           vo_sbo => vo_sbo,
                                           vo_top => vo_top,
                                           vo_sbs => vo_sbs,
                                           vo_tcr => vo_tcr);
      end;

     ld_fecdes :=  null;                
     ln_instancia := null;           
         
     if vo_cta is null then    --inicio de validacion posterior a 28/02/2021    

           begin
             select min(f.aofval)
              into ld_fecdes   --fecha desembolso
              from fsd010 f
             where f.pgcod = i.AQPB300COD
               and f.aomod = i.AQPB300MOD
               and f.aomda = i.AQPB300MDA
               and f.aopap = i.AQPB300PAP
               and f.aocta = i.AQPB300CTA
               and f.aooper = i.AQPB300OPE
               and f.aosbop = 0
               ;
            exception when others then
                ld_fecdes :=  null;
           end;


            begin

            ln_instancia := pq_cr_tasa_moratoria.fn_cr_obtiene_instancia(pn_emp => i.AQPB300COD,
                                                                pn_mod => i.AQPB300MOD,
                                                                pn_suc => i.AQPB300SUC,
                                                                pn_mda => i.AQPB300MDA,
                                                                pn_pap => i.AQPB300PAP,
                                                                pn_cta => i.AQPB300CTA,
                                                                pn_ope => i.AQPB300OPE,
                                                                pn_sbo => 0,--vo_sbo,
                                                                pn_top => i.AQPB300TOPE);
            end; 
               
           if  ld_fecdes > to_date('28/02/2021', 'DD/MM/YYYY') or vo_cta is null  then
             begin
               select substr(wfattsval, 0, instr(wfattsval, ';', 1, 1) - 1) Tipificacion
                 into vo_sbs
                 from wfattsvalues a
                where a.wfinsprcid=ln_instancia
                  and wfattsid = 'TIPO_CREDITO';    
             exception when others then   
                  vo_sbs := null;       
             end;     
           end if;    

    end if;  --fin de validacion posterior a 28/02/2021
             
     begin

       insert into AQPB300 ( AQPB300reg, AQPB300ren, AQPB300suc,  AQPB300mda,  
                            AQPB300cta, AQPB300ope,  AQPB300cod, AQPB300mod, AQPB300pap, 
                            AQPB300sbop, AQPB300tope, 
                            AQPB300fec,
                            AQPB300CODI, AQPB300CTAI, AQPB300OPEI, AQPB300MODI, AQPB300SUCI,
                            AQPB300MDAI, AQPB300PAPI,AQPB300SBOPI, AQPB300TOPEI,
                            AQPB300GRUI, AQPB300TCR, AQPB300FCON, AQPB300FDES, AQPB300INS,
                            aqpb300aux1, AQPB300CAUX1       
                           ) 
                         
       values (i.AQPB300REG,i.AQPB300REN,i.AQPB300SUC,i.AQPB300MDA,
               i.AQPB300CTA,i.AQPB300OPE,
               i.AQPB300COD, i.AQPB300MOD, i.AQPB300PAP, i.AQPB300SBOP, i.AQPB300TOPE, 
               ld_fecpro,
               vo_emp, vo_cta, vo_ope, vo_mod, vo_suc, vo_mda, vo_pap, vo_sbo, vo_top, 
               vo_sbs, vo_tcr, ld_Feccon, ld_fecdes, ln_instancia,
               1, --indicador de regularizacion
               'Extorno Reprogramacion'
              );
          
               
          COMMIT;
     exception when others then
            null;
     end;

    begin

      pq_cr_carga_tasa_reg.sp_cr_update_mora_indv(ve_emp => i.AQPB300COD,
                                                  ve_mod => i.AQPB300MOD,
                                                  ve_suc => i.AQPB300SUC,
                                                  ve_mda => i.AQPB300MDA,
                                                  ve_pap => i.AQPB300PAP,
                                                  ve_cta => i.AQPB300CTA,
                                                  ve_ope => i.AQPB300OPE,
                                                  ve_sbo => i.AQPB300SBOP,
                                                  ve_top => i.AQPB300TOPE,
                                                  ve_feccarg => ld_fecpro);
    end;
    
               
   END LOOP;

   
 end sp_cr_tasa_extorno;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

procedure sp_cr_tasa_extornoI(pd_fec  in date
                            ) is


CURSOR CREDITOS is
select  a.aqpb300cod pn_emp,  A.aqpb300mod pn_mod, a.aqpb300suc pn_suc, a.aqpb300mda pn_mda, a.aqpb300pap pn_pap, 
a.aqpb300cta pn_cta,a.aqpb300ope pn_ope , a.aqpb300sbop pn_sbo, a.aqpb300tope pn_top, A.AQPB300FVTOI ld_f601, A.AQPB300TASAI
ln_tasa, a.aqpb300corri pn_numcor
from aqpb300 a 
WHERE ( a.aqpb300cta, a.aqpb300ope, a.aqpb300sbop)
in
  (select a.aqpb300cta, a.aqpb300ope, a.aqpb300sbop from aqpb300 a  where  a.aqpb300est = 'S' and a.aqpb300fec =
  pd_fec--trunc(sysdate)--to_date('21/07/2021','DD/MM/YYYY') --actualizar fecha a la del proceso es decir a la de hoy
  minus
  select a.aqpb300cta, a.aqpb300ope, a.aqpb300sbop from aqpb300 a , fsd012 f
  where 
  f.pgcod = a.aqpb300cod
  and f.aomod = a.aqpb300mod
  and f.aosuc = a.aqpb300suc
  and f.aomda = a.aqpb300mda
  and f.aopap = a.aqpb300pap
  and f.aocta = a.aqpb300cta
  and f.aooper = a.aqpb300ope
  and f.aosbop = a.aqpb300sbop
  and f.aotope = a.aqpb300tope
  and f.evcorr = a.aqpb300corri
  and f.evtipo = 4
  and f.evfval = a.aqpb300fvtoi
  and a.aqpb300est = 'S' 
  and a.aqpb300fec = pd_fec); --trunc(sysdate));--to_date('21/07/2021','DD/MM/YYYY') );   --actualizar fecha a la del proceso es decir a la de hoy 

lc_flag varchar2(1);
ln_cor012 number;
ln_corr number;
lc_desc varchar2(50);

BEGIN
  
    FOR I IN CREDITOS LOOP
      
        --INSERTANDO 
       begin
        select /*+index(F FSD01204)*/
         max(f.evcorr)
          into ln_cor012
          from fsd012 f
         where f.pgcod = i.pn_emp
           and f.aomod = i.pn_mod
           and f.aosuc = i.pn_suc
           and f.aomda = i.pn_mda
           and f.aopap = i.pn_pap
           and f.aocta = i.pn_cta
           and f.aooper = i.pn_ope
           and f.aosbop = i.pn_sbo
           and f.aotope = i.pn_top;
    exception when others then
         ln_cor012 := 0;    
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
    ln_corr := ln_cor012  + 1;

    lc_flag := 'N';
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
          (i.pn_emp,
           i.pn_mod,
           i.pn_suc,
           i.pn_mda,
           i.pn_pap,
           i.pn_cta,
           i.pn_ope,
           i.pn_sbo,
           i.pn_top,
           ln_corr, --correlativo
           4, --tasa moratoria
           i.ld_f601,  
           '1/01/0001',
           0.00,
           1,
           i.ln_tasa,
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
           '1/01/0001',
           0,
           0,
           'S');

           COMMIT;
           lc_flag := 'S';

                    
      exception
        when others then
           lc_flag := 'N';
      end;
 

      lc_desc := 'EXT- FSD012 '||i.pn_numcor|| ' corfin '||ln_corr ;
      --lc_desc := 'FSD012 '||i.pn_numcor|| ' '||lc_flag||' '||i.pn_cta||'-'||i.pn_ope||' '||ln_corr ;
      --dbms_output.put_line(lc_desc);
      UPDATE AQPB300 A 
         SET A.AQPB300CORRI = ln_corr,
             A.AQPB300CAUX1 = lc_desc
       where a.aqpb300cta = i.pn_cta
         and a.aqpb300ope = i.pn_ope
         and a.aqpb300sbop = i.pn_sbo;
    
       commit;
    
    END LOOP;



END sp_cr_tasa_extornoI;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_actualiza_tasaext(pd_fec  in date
                            ) is
                            
begin
  
    begin
      pq_cr_tasa_moratoria.sp_cr_tasa_extorno(pd_fec);
    end;        

    begin
      pq_cr_tasa_moratoria.sp_cr_tasa_extornoI(pd_fec);
    end;  
                    
end sp_cr_actualiza_tasaext;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_penalidad_mora
   is
-- 2021.08.30 dcastro regulariza penalidad e inserta tasa moratoria

CURSOR LISTADO IS

 select aqpb300cod PGCOD, aqpb300mod AOMOD, aqpb300suc AOSUC, aqpb300pap AOPAP, 
   aqpb300mda AOMDA, aqpb300cta AOCTA,
   aqpb300ope AOOPER, aqpb300sbop AOSBOP, aqpb300tope AOTOPE, f.AQPB300GRUI , f.aqpb300fec
  from aqpb300 f
 where f.aqpb300est is null
  AND f.AQPB300GRUI NOT IN 
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
      pd_fecha := i.aqpb300fec;
      
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
            pq_cr_tasa_moratoria.sp_cr_actualiza_tasa(ve_cta =>pn_cta, 
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
                     UPDATE AQPB300 A
                     SET A.AQPB300EST   = 'S',
                         A.AQPB300TASAI = ln_tasa,
                         A.AQPB300CORRI = ln_corr,
                         A.AQPB300FVTOI = ld_fvto,
                         a.aqpb300aux1  = 2, 
                         a.AQPB300CAUX1 = 'Reg. Tasa Moratoria'
                     WHERE A.AQPB300COD = pn_emp 
                       AND A.AQPB300SUC = pn_suc 
                       AND A.AQPB300MOD = pn_mod 
                       AND A.AQPB300MDA = pn_mda 
                       AND A.AQPB300PAP = pn_pap 
                       AND A.AQPB300CTA = pn_cta 
                       AND A.AQPB300OPE = pn_ope 
                       AND A.AQPB300SBOP= pn_sbo
                       AND A.AQPB300TOPE= pn_top
                       AND A.AQPB300FEC = pd_fecha;                
                       commit;
              exception when others then
                 null;         
              END;         
              
           end if; -- lc_flag            

        end if; --- ln_texto = P    
      
      end if; -- ln_sbop    
      
    end loop;

END sp_cr_penalidad_mora;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_CR_TASA_MORATORIA;
/

