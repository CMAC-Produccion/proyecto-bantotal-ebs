create or replace package PQ_CR_SALDOS_LINEA is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2015.02.27
    -- Autor de la Modificación   :  DCASTRO
    -- Descripción de Modificación: Se agrego campo jaql982tcr, se agrego funcion fn_cr_tipo_credito_Desem
    --                              2016.04.13 DCASTRO se agrego condicion para eliminar JAQL583 fecha anterior a fecha proceso.
    --                              2016.06.14 DCASTRO se modifico sp_cr_job_carga, sp_cr_actualiza.
    --                              2017.11.08 DCASTRO se agrego estadisticas a tabla JAQL982 antes de invocar a procesos sp_cr_consolidad_sbs y sp_cr_consolida
    --                              2017.11.13 DCASTRO se modifico sp_cr_consolida_sbs se agrego condicion para ooptimizacion de cursor.
    --                              2018.02.02 DCASTRO sp_cr_job_carga_hi se redirecciono job a NODO 1.
    --                              2018.03.21 DCASTRO sp_cr_job_carga_hi se redirecciono job de NODOS.            
    --                              2018.04.17 DCASTRO sp_cr_consolida se modifico para evitar duplicidad de registros.
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_tipo_credito_desem(lc_pepais fsr008.pepais%type,
                                   lc_petdoc fsr008.petdoc%type,            
                                   lc_pendoc fsr008.pendoc%type,           
                                   ld_fecref date              
                                   )return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_region_zona(lc_codsuc in number,
                            ln_codreg out number,
                            lc_nomreg out varchar2
                           );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_consolida_sbs( pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_carga_datos_HI(pn_regcod number, pd_fecpro in date);   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_job_carga_HI(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- --ABR -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function Fn_TienePago(pn_emp in number, pn_cta in number, pn_ope in number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Mto_vto (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos_bc(pn_regcod number, pd_fecpro in date);   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_actualiza( pn_regcod number, pd_fecpro in date); 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_actualiza_hi(pn_regcod number, pd_fecpro in date);  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_consolida( pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_carga(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 function fn_Mto_vtoFM (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_cr_valida_registro(ld_fecha in date,
                               ln_tipo  in number,   
                               ln_codzon in number,    
                               ln_codreg in number,   
                               ln_codigo in number,   
                               ln_analista in char,   
                               ln_saldoj in number,   
                               ln_saldo in number    
                             )return number;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_SALDOS_LINEA;
/

create or replace package body PQ_CR_SALDOS_LINEA is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_SALDOS_LINEA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.31
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2015.02.23
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                            :   2015.03.13 se agrego tabla jaql983 para control jobs
    --                            :   2015.11.24 se modifico sp_cr_actualiza
    --                            :   2016.01.07 se modifico sp_Cr_actualiza, consumos y medianas.         
    --                            :   2016.01.12 se modifico sp_cr_actualiza para actualizar refinanciados.
    --                            :   2016.01.14 se modifico sp_cr_actualiza para actualizar refinanciados.    
    --                            :   2016.01.16 se modifico sp_cr_actualiza para actualizar refinanciados.
    --                            :   2016.01.20 se modifico sp_cr_actualiza para actualizar vencidos.    
    --                            :   2017.06.05 se modifico sp_cr_job_carga, sp_cr_job_carga_ini.
    --                            :   2017.07.21 se modifico sp_cr_job_carga, sp_cr_job_carga.        
    --                            :   2017.11.08 DCASTRO se agrego estadisticas a tabla JAQL982 antes de invocar a procesos sp_cr_consolidad_sbs y sp_cr_consolida
    --                            :   2017.11.13 DCASTRO se modifico sp_cr_consolida_sbs se agrego condicion para ooptimizacion de cursor.
    --                            :   2017.11.16 DCASTRO se modifico sp_cr_consolida_sbs se agrego condicion en cursor REGION_SBS
    --                            :   2018.02.02 DCASTRO sp_cr_job_carga_hi se redirecciono job a NODO 1.
    --                              2018.03.21 DCASTRO sp_cr_job_carga_hi se redirecciono job de NODOS.            
    -- *****************************************************************
      
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_cr_tipo_credito_desem(lc_pepais fsr008.pepais%type,
                                   lc_petdoc fsr008.petdoc%type,            
                                   lc_pendoc fsr008.pendoc%type,           
                                   ld_fecref date              
                                   )return number is

    -- *****************************************************************
    -- Nombre                     : fn_cr_tipo_credito_desem
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.02.27
    -- Autor de Creación          : 
    -- Uso                        : RETORNA Tipo Credito : 1 - NUEVO / 2 - RECURRENTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

    ln_tipcre number;

    ----retorna
    --1 'CREDITO NUEVO'    
    --2 'CREDITO RECURRENTE'  

  begin

      begin
        
        select (case 
                    when count(*)=0 then 1
                    else 2
               end)        
          into ln_tipcre        
          from fsd010 des
               inner join fsr008 pers
                      on pers.pgcod = des.pgcod
                     and pers.ctnro = des.aocta
                     and pers.ttcod = 1
                     and pers.CTTFIR = 'T'
         where 
               des.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120) union all select 117 from dual)
           and des.aomod <> 141
           and des.aomod <> 120 --prestamos pasivos        
           and pers.pepais = lc_pepais
           and pers.petdoc = lc_petdoc
           and pers.pendoc = lc_pendoc
           and des.aofval < ld_fecref;
        
        exception
          when no_data_found then
               ln_tipcre := null;
      end;

  return ln_tipcre;
  
end fn_cr_tipo_credito_desem;

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
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_consolida_sbs( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_consolida_sbs
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.05.15
    -- Autor de Creación          : 
    -- Uso                        : CONSOLIDA DATOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se consolida informacion. 
    --                              2017.11.13 DCASTRO se modifico condicion para obtimizacion de cursor.
    --                              2017.11.16 DCASTRO se agrego condicion jaql982sbs is not null en cursor REGION_SBS
    -- *****************************************************************


----///reemplazar JAQL968 por JAQL987

cursor REGION_SBS is
select  
jaql982sbs, jaql982coz, jaql982noz, jaql982gru ,
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
        k.jaql982sbs = j.jaql982sbs and
        k.jaql982coz = j.jaql982coz  AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982sbs = j.jaql982sbs and
       h.jaql982coz = j.jaql982coz  AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30
,sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
where 
--JAQL982MOD<>33 and jaql982sbs is not null
(JAQL982MOD < 33 OR JAQL982MOD > 33 + UID * 0)  --20171113 DCASTRO
and jaql982sbs is not null --2017.11.16 DCASTRO
group by jaql982sbs, jaql982coz, jaql982noz, jaql982gru 
order by jaql982sbs, jaql982coz;



cursor ZONA_SBS is
select 
jaql982sbs, jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982gru ,
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
        k.jaql982sbs = j.jaql982sbs and
        k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982sbs = j.jaql982sbs and
       h.jaql982coz = j.jaql982coz and H.JAQL982REG = J.JAQL982REG AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30
,sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
where --JAQL982MOD<>33  and jaql982sbs is not null
(JAQL982MOD < 33 OR JAQL982MOD > 33 + UID * 0)  --20171116 DCASTRO
and jaql982sbs is not null --2017.11.16 DCASTRO
group by jaql982sbs, jaql982coz, jaql982noz,jaql982reg, jaql982ren, jaql982gru
order by jaql982sbs, jaql982coz,jaql982reg;
       

CURSOR AGENCIA_SBS IS
select  jaql982sbs, jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982gru ,
 jaql982suc, jaql982age, 
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
 k.jaql982sbs = j.jaql982sbs and
 k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG AND K.JAQL982SUC = J.JAQL982SUC AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982sbs = j.jaql982sbs and
       h.jaql982coz = j.jaql982coz and 
       H.JAQL982REG = J.JAQL982REG AND H.JAQL982SUC = J.JAQL982SUC AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30
,sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
where --JAQL982MOD<>33  and jaql982sbs is not null
(JAQL982MOD < 33 OR JAQL982MOD > 33 + UID * 0)  --20171113 DCASTRO
and jaql982sbs is not null --2017.11.16 DCASTRO
group by jaql982sbs, jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age, jaql982gru 
order by jaql982sbs, jaql982coz,jaql982reg,jaql982suc;


CURSOR ANALISTA_SBS IS
select jaql982sbs, jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age,  jaql982ana, jaql982gru ,
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
 k.jaql982sbs = j.jaql982sbs and
 k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG 
AND K.JAQL982SUC = J.JAQL982SUC AND K.JAQL982ANA = J.JAQL982ANA AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982sbs = j.jaql982sbs and
       h.jaql982coz = j.jaql982coz and 
       H.JAQL982REG = J.JAQL982REG AND H.JAQL982SUC = J.JAQL982SUC AND H.JAQL982ANA = J.JAQL982ANA  AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj,  
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30
,sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1    
from jaql982 j
where --JAQL982MOD<>33  and jaql982sbs is not null
(JAQL982MOD < 33 OR JAQL982MOD > 33 + UID * 0)  --20171113 DCASTRO
and jaql982sbs is not null --2017.11.16 DCASTRO
group by jaql982sbs, jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age,  jaql982ana, jaql982gru 
order by jaql982sbs, jaql982coz,jaql982reg,jaql982suc,jaql982ana;




lc_analista varchar2(10);
ln_numero number:=0;
ln_por15 number:= 0;
ln_por30 number:= 0;
ln_porMC number:= 0; --mora contable
--pd_fecpro date:= to_date('2014.07.30','yyyy.mm.dd');

begin


/*aplicar estadisticas 2017.11.08*/
 begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD', 
                                          tabname          => 'JAQL982',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
  end; 
/*aplicar estadisticas 2017.11.08*/

   ---- Inserta PRODUCTO SBS
   --eliminar registros anteriores
    delete from jaql987 where jaql987fec = pd_fecpro and jaql987tip in (4,5,6,7);
    commit;

    --POR REGION  -- TIPO 4
    for i in region_sbs loop

       if i.jaql982scap = 0 then
            ln_porMC := 0;   
            ln_por15 := 0;  
            ln_por30 := 0;  
       else    
         ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
         ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
         ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );
       end if;  
    
     insert into JAQL987 (
                  JAQL987COR, JAQL987tip, JAQL987fec, JAQL987coz, JAQL987noz, JAQL987reg, JAQL987ren, JAQL987cod, JAQL987age, JAQL987ana, 
                  JAQL987salj, JAQL987sal, JAQL987sju, JAQL987SVE, JAQL987scvp, JAQL987scvn, JAQL987sre,
                  JAQL987scvr, JAQL987SCA, JAQL987S15, JAQL987S30, JAQL987P15, JAQL987p30,
                  JAQL987ncl, JAQL987ncr, JAQL987sbs, JAQL987gru , JAQL987pmr, jaql987scpv, jaql987scp1, jaql987scca 
                 )
         values ( ln_numero, 4, pd_fecpro, i.jaql982coz, i.jaql982noz, 0, '-', 0, '-', '-', 
                  (i.jaql982scap), (i.jaql982scan), (i.jaql982scaj), (i.jaql982scav)+ i.jaql982scp1,( i.jaql982scvp), (i.jaql982scvn)+ i.jaql982scp1, (i.jaql982scar),
                  (i.jaql982scvr), (i.jaql982scac), (i.jaql982s15), (i.jaql982s30), ln_por15, ln_por30,
                  i.clientes, i.creditos, i.jaql982sbs, i.jaql982gru , ln_porMC  , i.jaql982scpv, i.jaql982scp1 ,(i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                );
         ln_numero := ln_numero + 1;  
          


    end loop;
    commit; 
 

    --POR ZONA  -- TIPO 5
    for i in zona_sbs loop
       if i.jaql982scap = 0 then
            ln_porMC := 0;   
            ln_por15 := 0;  
            ln_por30 := 0;  
       else      
         ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
         ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
         ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );
       end if;
          
             
     insert into JAQL987 (
                  JAQL987COR, JAQL987tip, JAQL987fec, JAQL987reg, JAQL987ren, JAQL987cod, JAQL987age, JAQL987ana, 
                  JAQL987salj, JAQL987sal, JAQL987sju, JAQL987SVE, JAQL987scvp, JAQL987scvn, JAQL987sre,
                  JAQL987scvr, JAQL987SCA, JAQL987S15, JAQL987S30, JAQL987P15, JAQL987p30,
                  JAQL987ncl, JAQL987ncr, JAQL987sbs, JAQL987gru , JAQL987pmr, JAQL987coz, JAQL987noz, jaql987scpv,jaql987scp1, jaql987scca
                 )
         values ( ln_numero, 5, pd_fecpro, i.jaql982reg, i.jaql982ren, 0, '-', '-', 
                  (i.jaql982scap), (i.jaql982scan), (i.jaql982scaj), (i.jaql982scav)+ i.jaql982scp1,( i.jaql982scvp), (i.jaql982scvn)+ i.jaql982scp1, (i.jaql982scar),
                  (i.jaql982scvr), (i.jaql982scac), (i.jaql982s15), (i.jaql982s30), ln_por15, ln_por30,
                  i.clientes, i.creditos, i.jaql982sbs, i.jaql982gru , ln_porMC , i.jaql982coz, i.jaql982noz , i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                );
         ln_numero := ln_numero + 1;  
             

    end loop;
    commit;
         
    --POR AGENCIA  -- TIPO 6
    for i in agencia_sbs loop


       if i.jaql982scap = 0 then
            ln_porMC :=  0;     
       else
            ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav+ i.jaql982scp1)/i.jaql982scap)*100,2 );          
       end if;     
       if  i.jaql982s15 = 0 then
           ln_por15 := 0;
       else  
         if i.jaql982scap = 0 then
             ln_por15 :=  0;
         else  
             ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
         end if;
           
       end if;
       if i.jaql982s30 = 0 then    
           ln_por30 := 0;
       else
          if i.jaql982scap = 0 then
             ln_por30 := 0;
          else
             ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
          end if;   
       end if;     
         
     insert into JAQL987 (
                  JAQL987COR, JAQL987tip, JAQL987fec, JAQL987reg, JAQL987ren, JAQL987cod, JAQL987age, JAQL987ana, 
                  JAQL987salj, JAQL987sal, JAQL987sju, JAQL987SVE, JAQL987scvp, JAQL987scvn, JAQL987sre,
                  JAQL987scvr, JAQL987SCA, JAQL987S15, JAQL987S30, JAQL987P15, JAQL987p30,
                  JAQL987ncl, JAQL987ncr, JAQL987sbs, JAQL987gru , JAQL987pmr, JAQL987coz, JAQL987noz, jaql987scpv , jaql987scp1, jaql987scca
                 )
         values ( ln_numero, 6, pd_fecpro, i.jaql982reg, i.jaql982ren, i.jaql982suc, i.jaql982age,  '-', 
                  (i.jaql982scap), (i.jaql982scan), (i.jaql982scaj), (i.jaql982scav)+ i.jaql982scp1, (i.jaql982scvp), ( i.jaql982scvn)+ i.jaql982scp1, (i.jaql982scar),
                  (i.jaql982scvr), (i.jaql982scac), (i.jaql982s15), (i.jaql982s30), ln_por15, ln_por30,
                  i.clientes, i.creditos, i.jaql982sbs, i.jaql982gru , ln_porMC , i.jaql982coz, i.jaql982noz, i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                );
         ln_numero := ln_numero + 1;   
         
    end loop;
    commit; 
    
    --POR AGENCIA  -- TIPO 7
    for i in analista_sbs loop
    
     lc_analista := nvl(i.jaql982ana,'-');
     if i.jaql982scap = 0 then
          ln_porMC :=  0;     
     else
          ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );          
     end if;     
     
     if  i.jaql982s15 = 0 then
         ln_por15 := 0;
     else  
          if i.jaql982scap = 0 then
             ln_por15 :=  0;
         else  
             ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
         end if;    
     end if;
     if i.jaql982s30 = 0 then    
         ln_por30 := 0;
     else
         if i.jaql982scap = 0 then
             ln_por30 :=  0;
         else
             ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
         end if;    
     end if;     

          
     insert into JAQL987 (
                  JAQL987COR, JAQL987tip, JAQL987fec, JAQL987reg, JAQL987ren, JAQL987cod, JAQL987age, JAQL987ana, 
                  JAQL987salj, JAQL987sal, JAQL987sju, JAQL987SVE, JAQL987scvp, JAQL987scvn, JAQL987sre,
                  JAQL987scvr, JAQL987SCA, JAQL987S15, JAQL987S30, JAQL987P15, JAQL987p30,
                  JAQL987ncl, JAQL987ncr, JAQL987sbs, JAQL987gru, JAQL987pmr, JAQL987coz, JAQL987noz, jaql987scpv, jaql987scp1, jaql987scca
                 )
         values ( ln_numero, 7 , pd_fecpro, i.jaql982reg, i.jaql982ren, i.jaql982suc, i.jaql982age,  lc_analista, 
                  (i.jaql982scap), (i.jaql982scan), (i.jaql982scaj), (i.jaql982scav)+ i.jaql982scp1, (i.jaql982scvp), (i.jaql982scvn)+ i.jaql982scp1, (i.jaql982scar),
                  (i.jaql982scvr), (i.jaql982scac), (i.jaql982s15), (i.jaql982s30), ln_por15, ln_por30,
                  i.clientes, i.creditos, i.jaql982sbs, i.jaql982gru , ln_porMC , i.jaql982coz, i.jaql982noz, i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                );
         ln_numero := ln_numero + 1;   
         
    end loop;
    commit; 


   --Fin Producto SBS

 
 end sp_cr_consolida_sbs;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos_HI(pn_regcod in number , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos_HI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.05.13
    -- Autor de Creación          : 
    -- Uso                        : Carga Datos de Cierre 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación:  
    --                              
    -- *****************************************************************




cursor creditos(pn_regcod number, ld_fecpro date, ln_tipcam number) is

 select /*+ALL_ROWS*/ 
       -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod        JAQL982REG,
       upper(r2.RegNOM) JAQL982REN, 
       a.bcsuc JAQL982SUC,
       upper(age.scnom) JAQL982AGE,   
       a.bcmda JAQL982MDA,   
       --      fn_analista_credito(a.scmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.sctope) codana,
       ' ' JAQL982ANA,
       a.bccta JAQL982CTA, 
       a.bcoper JAQL982OPE,
       0 JAQL982DIA,
       a.bcemp JAQL982PCOD, a.bcmod JAQL982MOD, 
       a.bcpap JAQL982PAP,
       a.bcsbop JAQL982SBOP, 
       a.bctop JAQL982TOPE,  
       a.bcgpo JAQL982GRU,
       substr(a.bcrubr,12,2) JAQL982RUB,      
       --      fn_dias_atraso(ld_fecpro/*a.bcfech*/, a.bcemp, a.scmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper, a.bcsbop, a.bctop, 0, a.scfvto) dias,
       case when substr(a.bcrubr,1,4) not in (8113,8123,8119,8129) then nvl(a.bcsdmn,0) end JAQL982SCAP,
       case when substr(a.bcrubr,1,4) in (1411,1421) then  nvl(a.bcsdmn,0) end JAQL982SCAN,
       case when substr(a.bcrubr,1,4) in (1414,1424) then  nvl(a.bcsdmn,0) end JAQL982SCAR,
       case when substr(a.bcrubr,1,4) in (1415,1425) then  nvl(a.bcsdmn,0) end JAQL982SCAV,
       case when substr(a.bcrubr,1,4) in (1415,1425) and substr(a.bcrubr,7,2) = '13' then nvl(a.bcsdmn,0) end  JAQL982SCVP,
       case when substr(a.bcrubr,1,4) in (1415,1425) and substr(a.bcrubr,7,2) = '06' then nvl(a.bcsdmn,0) end  JAQL982SCVN,
       case when substr(a.bcrubr,1,4) in (1415,1425) and substr(a.bcrubr,7,2) = '19' then nvl(a.bcsdmn,0) end  JAQL982SCVR,
       case when substr(a.bcrubr,1,4) in (1416,1426) then  nvl(a.bcsdmn,0) end JAQL982SCAJ,       
       case when bcmod = 33 and substr(a.bcrubr,1,4) in (8113,8123,8119,8129) then  nvl(a.bcsdmn,0) end JAQL982SCAC,
       a.bcfvto JAQL982FVTO
  from fsh012 a,
       fst811 r,
       FST001 age,
       fst810 r2
 where a.bcemp = 1
   and a.bccta <> 999999999
   and substr(a.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426, 8113,8123,8119,8129)
   and a.bcmod not in (451,141)
   and r.pgcod = 1 
   and r.oficod = a.bcsuc 
   and r.RegCod < 100
   and age.pgcod  = 1 
   and age.Sucurs = a.bcsuc
   and r2.regcod = r.regcod
   and r2.regcod<100
   AND r.oficod = age.Sucurs   
   and a.bcprod <> 99
   and r.regcod = pn_regcod
   and a.bcsuc <> 904
   and a.bcfech = ld_fecpro;
   --and age.Sucurs = lc_sucurs;

 
  TYPE Tp_JAQL982COD IS TABLE OF JAQL982.JAQL982COD%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982REG IS TABLE OF JAQL982.JAQL982REG%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982REN IS TABLE OF JAQL982.JAQL982REN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SUC IS TABLE OF JAQL982.JAQL982SUC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982AGE IS TABLE OF JAQL982.JAQL982AGE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982MDA IS TABLE OF JAQL982.JAQL982MDA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982ANA IS TABLE OF JAQL982.JAQL982ANA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982CTA IS TABLE OF JAQL982.JAQL982CTA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982OPE IS TABLE OF JAQL982.JAQL982OPE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982DIA IS TABLE OF JAQL982.JAQL982DIA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAP IS TABLE OF JAQL982.JAQL982SCAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAN IS TABLE OF JAQL982.JAQL982SCAN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAR IS TABLE OF JAQL982.JAQL982SCAR%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAV IS TABLE OF JAQL982.JAQL982SCAV%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVP IS TABLE OF JAQL982.JAQL982SCVP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVN IS TABLE OF JAQL982.JAQL982SCVN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVR IS TABLE OF JAQL982.JAQL982SCVR%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAJ IS TABLE OF JAQL982.JAQL982SCAJ%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAC IS TABLE OF JAQL982.JAQL982SCAC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982PCOD IS TABLE OF JAQL982.JAQL982COD%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982MOD IS TABLE OF fsd011.SCMOD%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982PAP IS TABLE OF fsd011.SCPAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SBOP IS TABLE OF fsd011.SCSBOP%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982FVTO IS TABLE OF fsd011.SCFVTO%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982TOPE IS TABLE OF fsd011.Sctope%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982GRU IS TABLE OF JAQL982.JAQL982GRU%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982RUB IS TABLE OF JAQL982.JAQL982RUB%TYPE INDEX BY PLS_INTEGER;


  JAQL982COD   Tp_JAQL982COD; 
  JAQL982REG   Tp_JAQL982REG;
  JAQL982REN   Tp_JAQL982REN;
  JAQL982SUC   Tp_JAQL982SUC;
  JAQL982AGE   Tp_JAQL982AGE;
  JAQL982MDA   Tp_JAQL982MDA;
  JAQL982ANA   Tp_JAQL982ANA;
  JAQL982CTA   Tp_JAQL982CTA;
  JAQL982OPE   Tp_JAQL982OPE;
  JAQL982DIA   Tp_JAQL982DIA;
  JAQL982SCAP  Tp_JAQL982SCAP;
  JAQL982SCAN  Tp_JAQL982SCAN;
  JAQL982SCAR  Tp_JAQL982SCAR;
  JAQL982SCAV  Tp_JAQL982SCAV;
  JAQL982SCVP  Tp_JAQL982SCVP;
  JAQL982SCVN  Tp_JAQL982SCVN;
  JAQL982SCVR  Tp_JAQL982SCVR;
  JAQL982SCAJ  Tp_JAQL982SCAJ;
  JAQL982SCAC  Tp_JAQL982SCAC;
  JAQL982PCOD  Tp_JAQL982PCOD;
  JAQL982MOD   Tp_JAQL982MOD;
  JAQL982PAP   Tp_JAQL982PAP;
  JAQL982SBOP  Tp_JAQL982SBOP;
  JAQL982FVTO  Tp_JAQL982FVTO;
  JAQL982TOPE  Tp_JAQL982TOPE;
  JAQL982GRU   Tp_JAQL982GRU;
  JAQL982RUB   Tp_JAQL982RUB;
  
   
  ln_numero NUMBER;
  ln_conta NUMBER;
  ln_tipcam number(14,8);
  lc_variable varchar2(100):='PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_HI';
  ln_numjob NUMBER;
 
begin

  --
   begin      
       select count(*)   
         into ln_numero       
        from jaql982;
   exception when no_data_found then
       ln_numero := 0;              
   end;
 
    

   OPEN creditos(pn_regcod , pd_fecpro , ln_tipcam );
    LOOP
      FETCH creditos BULK COLLECT
        INTO  JAQL982REG, JAQL982REN, JAQL982SUC, JAQL982AGE, JAQL982MDA, JAQL982ANA, JAQL982CTA, JAQL982OPE, JAQL982DIA,
              JAQL982PCOD, JAQL982MOD, JAQL982PAP, JAQL982SBOP, JAQL982TOPE, 
              JAQL982GRU, JAQL982RUB, JAQL982SCAP, JAQL982SCAN, JAQL982SCAR, JAQL982SCAV,
              JAQL982SCVP, JAQL982SCVN, JAQL982SCVR, JAQL982SCAJ, JAQL982SCAC, JAQL982FVTO              
              ;
              
          IF JAQL982REG.COUNT > 0 THEN
             FOR i IN JAQL982REG.FIRST .. JAQL982REG.LAST LOOP
       
               ln_numero := ln_numero + 1; 
       
               insert into jaql982 (jaql982cod, jaql982reg, jaql982ren, jaql982suc, jaql982age, jaql982mda, jaql982ana, 
                                    jaql982cta, jaql982ope, jaql982dia, jaql982scap, jaql982scan, jaql982scar, jaql982scav,
                                    jaql982scvp, jaql982scvn, jaql982scvr, jaql982scaj, jaql982scac,
                                    jaql982pcod, jaql982mod, jaql982pap, jaql982sbop, jaql982tope, 
                                    jaql982gru, jaql982rub, jaql982fvto  
                                   ) 
                       
                   
               values (ln_numero,JAQL982REG(i),JAQL982REN(i),JAQL982SUC(i),JAQL982AGE(i),JAQL982MDA(i),JAQL982ANA(i),
                       JAQL982CTA(i),JAQL982OPE(i),JAQL982DIA(i),JAQL982SCAP(i)*-1,JAQL982SCAN(i)*-1,JAQL982SCAR(i)*-1,JAQL982SCAV(i)*-1,
                       JAQL982SCVP(i)*-1,JAQL982SCVN(i)*-1,JAQL982SCVR(i)*-1,JAQL982SCAJ(i)*-1, JAQL982SCAC(i)*-1,
                       JAQL982PCOD(i), JAQL982MOD(i), JAQL982PAP(i), JAQL982SBOP(i), JAQL982TOPE(i), 
                       JAQL982GRU(i), JAQL982RUB(i),  JAQL982FVTO(i)
                      );
        
               
               ln_conta  := ln_conta + 1;

               
             END LOOP;
             commit; ---2015
          END IF;    
        
        
           --actualiza analista, dias atraso
          begin
           pq_cr_saldos_linea.sp_cr_actualiza_hi(pn_regcod => pn_regcod, pd_fecpro => pd_fecpro);
          end; 
         
        
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
   
   --commit;  
  update JAQL983 
    set JAQL983FFI = sysdate
  where JAQL983COD = 'SLI' 
    and JAQL983NUM = pn_regcod
    and JAQL983DES = lc_variable;
  COMMIT;
  
 

 end sp_cr_carga_datos_HI;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_carga_HI(pd_fecpro in date) is
-- *****************************************************************
-- Nombre                     :   sp_cr_job_carga_hi
--                            :   2018.02.02 DCASTRO se redirecciono job a NODO 1
-- *****************************************************************

ln_ini number;
ln_job number:=0;
lc_fecpro char(10);
ln_varjob number:=0;
lc_variable varchar2(100):='PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_HI';
ln_numjob NUMBER;
lc_hostname varchar2(64);  

  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;
   
  cursor region is
  select * from fst810 where regcod <100; 



begin


 begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

  --trunca tabla
  execute immediate 'truncate table jaql982';
  execute immediate 'truncate table jaql983';  


  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
  begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL982',
                                    degree           => 1,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
  end;

   
 
  for i in region loop
        ln_ini := i.regcod;
        lc_variable := 'begin '||'  PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_HI('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
        ln_job := ln_job +1;
        if ln_varjob <5 then
--            if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
                   DBMS_JOB.SUBMIT(job => ln_job, 
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
--                                instance => 2,
                                instance => 1,
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
               ln_varjob:= ln_varjob +1;
        else
   

--            if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
                   DBMS_JOB.SUBMIT(job => ln_job, 
                                what => lc_variable,
                                next_date => sysdate+3/(24*60),--sysdate+3/(24*60),
                                interval => null,
                                no_parse => false,
--                                instance => 2,
                                instance => 1,
                                force => false
                                );
              else
                   DBMS_JOB.SUBMIT(job => ln_job, 
                                what => lc_variable,
                                next_date => sysdate+3/(24*60),--sysdate+3/(24*60),
                                interval => null,
                                no_parse => false,
                                force => false
                                );
                  
              end if;  
                        
               ln_varjob:= ln_varjob +1;                   

        end if;  

        
        --controlar jobs
        begin
           select count(*) 
             into ln_numjob  
             from jaql983;
        end;
        
        ln_numjob := ln_numjob + 1;
        INSERT INTO JAQL983 (JAQL983COR,JAQL983COD,JAQL983NUM, JAQL983DES, JAQL983FIN)
          VALUES(ln_numjob, 'SLI',ln_ini, 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_HI', sysdate);
        COMMIT;

  end loop;          


end sp_cr_job_carga_HI;
--------------------------------------ABR---------------------------------------------------------
Function Fn_TienePago(pn_emp in number, pn_cta in number, pn_ope in number) return char is
pc_flag char(2);
ln_emp number(3);
ln_suc number(3);
ln_mod number(3);
ln_trn number(3);
--ln_rel number(4);
begin
        begin
         /*select distinct a.pgcod,a.itsuc,a.itmod,a.ittran,\*a.itnrel,*\'S'
           into ln_emp,ln_suc,ln_mod,ln_trn,\*ln_rel,*\pc_flag
           from fsd016 a, \*bantprod.JAQL980A b, *\fst198 c, fsd015 d
          where a.pgcod  = pn_emp
            and a.ctnro  = pn_cta
            and a.itoper  = pn_ope
           \* and a.itmod  = b.jaql980amod
            and a.itsuc = b.jaql980asuc
            and a.ittran  = b.jaql980atran
            and a.itnrel = b.jaql980anrel
            and b.jaql980afcon = to_date(sysdate,'dd/mm/yy')*\
            and c.tp1cod = pn_emp
            and c.tp1cod1 = 10872
            and c.tp1corr1= 111
            and c.tp1nro1 = a.itmod
            and c.tp1nro2 = a.ittran
            and d.pgcod  = a.pgcod
            and d.itsuc  = a.itsuc
            and d.itmod  = a.itmod
            and d.ittran = a.ittran
            and d.itnrel = a.itnrel
            and d.itcorr <> 99;*/
         /*ccerpa*/
         select temp.jaqz719cod,temp.jaqz719suc,temp.jaqz719mod,temp.jaqz719tran,'S'
         into ln_emp,ln_suc,ln_mod,ln_trn,/*ln_rel,*/pc_flag
         from fst198 fst inner join  
        (select f3.jaqz719cod,f3.jaqz719suc,f3.jaqz719mod,f3.jaqz719tran,f3.jaqz719nrel,
                f3.jaqz719cta,f3.jaqz719oper ,f3.jaqz719ord,f3.jaqz719sbor  
         from jaqz719 f3 
         where  f3.jaqz719cod=pn_emp
         and f3.jaqz719cta=pn_cta  
         and f3.jaqz719oper=pn_ope) temp
         on  fst.tp1cod=pn_emp--ojito
         and fst.tp1cod1=10872 
         and fst.tp1corr1=111 
         and temp.jaqz719mod=fst.tp1nro1 
         and temp.jaqz719tran=fst.tp1nro2
         and rownum<2;
         /*ccerpa*/
         
         
           
       /*  select a.pgcod,a.itsuc,a.itmod,a.ittran,'S'
           into ln_emp,ln_suc,ln_mod,ln_trn,pc_flag
           from fsd016 a, fst198 c, fsd015 d
          where a.pgcod  = pn_emp
            and a.ctnro  = pn_cta
            and a.itoper  = pn_ope
            and c.tp1cod = pn_emp
            and c.tp1cod1 = 10872
            and c.tp1corr1= 111
            and c.tp1nro1 = a.itmod
            and c.tp1nro2 = a.ittran
            and d.pgcod  = a.pgcod
            and d.itsuc  = a.itsuc
            and d.itmod  = a.itmod
            and d.ittran = a.ittran
            and d.itnrel = a.itnrel
            and d.itcorr <> 99
            and rownum <2;
            */
        exception 
            when others then pc_flag := 'N';
                             
         
        end;
        return pc_flag;
end Fn_TienePago;
-----------------------------------------ABR-------------------------------------------------------
function fn_Mto_vto (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_monto number(17,2);
ln_pago number(17,2);
ld_fecpxv date;
begin
  begin
    select --/*+ parallel(n,2,1)*/  
           min(n.ppfpag) 
      into ld_fecpxv   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists 
                (select --/*+ parallel(o,2,1)*/  
                        ppmod, ppcta,ppoper, pptope,ppfpag 
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T' 
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  exception 
      when no_data_found then 
         ld_fecpxv := null;
      when too_many_rows then
         ld_fecpxv := null;
  end;   
  
   begin
         select --/*+ parallel(n,2,1)*/  
               sum(n.pp1cap)
          into ln_pago   
          from fsd602 n 
         where n.pgcod  = pn_emp     
           and n.ppcta  = pn_cta     
           and n.ppmda  = pn_mda    
           and n.ppsuc  = pn_suc    
           and n.pppap  = pn_pap    
           and n.ppoper = pn_oper  
           and n.ppsbop = pn_sbop  
           and n.pptope = pn_top  
           and n.ppmod  = pn_mod    
           and n.ppfpag >= ld_fecpxv
           and n.d602co = 'S';
  exception when others then
    ln_pago:=0;
  end;
  
  ln_pago := nvl(ln_pago,0);
  
  begin
/*         select \*+ parallel(n,2,1)*\  
               n.ppcap
          into ln_monto   
          from fsd601 n 
         where n.pgcod  = pn_emp     
           and n.ppcta  = pn_cta     
           and n.ppmda  = pn_mda    
           and n.ppsuc  = pn_suc    
           and n.pppap  = pn_pap    
           and n.ppoper = pn_oper  
           and n.ppsbop = pn_sbop  
           and n.pptope = pn_top  
           and n.ppmod  = pn_mod    
           and n.ppfpag = ld_fecpxv
           and n.d601co = 'S'
           and (n.ppcap+n.ppint)<>0;*/
           
           
        select --/*+ parallel(n,2,1)*/  
           sum( n.ppcap)
            into ln_monto   
                from fsd601 n 
               where n.pgcod  = pn_emp     
                 and n.ppcta  = pn_cta     
                 and n.ppmda  = pn_mda    
                 and n.ppsuc  = pn_suc    
                 and n.pppap  = pn_pap    
                 and n.ppoper = pn_oper  
                 and n.ppsbop = pn_sbop  
                 and n.pptope = pn_top  
                 and n.ppmod  = pn_mod    
                 and n.ppfpag >= ld_fecpxv 
                 and n.ppfpag < pd_fecpro
                 and pd_fecpro - n.ppfpag >= 31  
                 and n.d601co = 'S'
                 and (n.ppcap+n.ppint)<>0;         
           
  exception when others then
    ln_monto:=0;
  end;
  
  ln_monto :=  nvl(ln_monto,0);
   return (ln_monto- ln_pago);
end fn_Mto_vto;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_carga_datos_bc(pn_regcod in number , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.18
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: SE agrego condicion a.bcprod <> 99 para no considerar creditos vigentes sin saldo 
    --                              2015.03.12 DCASTRO Se agrego tabla JAQL983 para control de jobs.
    -- Fecha de Modificación      : 2015.06.09
    -- Autor de la Modificación   : ABERNEDO
    -- Descripción de Modificación: SE agrego el campo rubro como el campo saldo por vencer para Reclasificacion
    -- *****************************************************************


cursor creditos(pn_regcod number, ld_fecpro date, ln_tipcam number) is

 select /*+ALL_ROWS*/ 
       -- /*+parallel(a,2,@2) parallel(r,2,@2) parallel(age,2,@2) parallel(r2,2,@2) */
       r2.regcod        JAQL982REG,
       upper(r2.RegNOM) JAQL982REN, 
       a.scsuc JAQL982SUC,
       upper(age.scnom) JAQL982AGE,   
       a.scmda JAQL982MDA,   
       --      fn_analista_credito(a.scmod,a.scsuc,a.scmda,a.scpap,a.sccta,a.scoper,a.scsbop,a.sctope) codana,
       ' ' JAQL982ANA,
       a.sccta JAQL982CTA, 
       a.scoper JAQL982OPE,
       0 JAQL982DIA,
       a.pgcod JAQL982PCOD, a.scmod JAQL982MOD, 
       a.scpap JAQL982PAP,
       a.scsbop JAQL982SBOP, 
       a.sctope JAQL982TOPE,  
       a.scgru JAQL982GRU,
       substr(a.scrub,12,2) JAQL982RUB,      
       --      fn_dias_atraso(ld_fecpro/*a.bcfech*/, a.pgcod, a.scmod, a.scsuc, a.scmda, a.scpap, a.sccta, a.scoper, a.scsbop, a.sctope, 0, a.scfvto) dias,
       nvl((case when substr(a.scrub,1,4) not in (8113,8123,8119,8129) then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAP,
       nvl((case when substr(a.scrub,1,4) in (1411,1421) then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAN,
       nvl((case when substr(a.scrub,1,4) in (1414,1424) then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAR,
       nvl((case when substr(a.scrub,1,4) in (1415,1425) then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAV,
       nvl((case when substr(a.scrub,1,4) in (1415,1425) and substr(a.scrub,7,2) = '13' then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCVP,
       nvl((case when substr(a.scrub,1,4) in (1415,1425) and substr(a.scrub,7,2) = '06' then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCVN,
       nvl((case when substr(a.scrub,1,4) in (1415,1425) and substr(a.scrub,7,2) = '19' then decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCVR,
       nvl((case when substr(a.scrub,1,4) in (1416,1426) then  decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAJ,       
       nvl((case when scmod = 33 and substr(a.scrub,1,4) in (8113,8123,8119,8129) then  decode( a.scmda,0, a.scsdo, a.scsdo*ln_tipcam ) end),0) JAQL982SCAC,
        a.scfvto JAQL982FVTO,
        A.SCRUB JAQL982RUBR
  from fsd011 a,
       fst811 r,
       FST001 age,
       fst810 r2/*,
       fsd014 b*/
 where a.PGCOD = 1
   and a.sccta <> 999999999
   and substr(a.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426, 8113,8123,8119,8129)
/*   and a.scrub = b.rubro
   and substr(b.rubro,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426, 8113,8123,8119,8129)*/
   and a.scmod not in (451,/*33,*/141)
   and r.pgcod = 1 
   and r.oficod = a.scsuc 
   and r.RegCod < 100
   and age.Pgcod  = 1 
   and age.Sucurs = a.scsuc
   and r2.regcod = r.regcod
   and r2.regcod<100
   AND r.oficod = age.Sucurs   
   and a.scstat <> 99
   and r.regcod = pn_regcod
   and a.scsuc <> 904
   ;--and age.Sucurs = lc_sucurs;

 
  TYPE Tp_JAQL982COD IS TABLE OF JAQL982.JAQL982COD%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982REG IS TABLE OF JAQL982.JAQL982REG%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982REN IS TABLE OF JAQL982.JAQL982REN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SUC IS TABLE OF JAQL982.JAQL982SUC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982AGE IS TABLE OF JAQL982.JAQL982AGE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982MDA IS TABLE OF JAQL982.JAQL982MDA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982ANA IS TABLE OF JAQL982.JAQL982ANA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982CTA IS TABLE OF JAQL982.JAQL982CTA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982OPE IS TABLE OF JAQL982.JAQL982OPE%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982DIA IS TABLE OF JAQL982.JAQL982DIA%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAP IS TABLE OF JAQL982.JAQL982SCAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAN IS TABLE OF JAQL982.JAQL982SCAN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAR IS TABLE OF JAQL982.JAQL982SCAR%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAV IS TABLE OF JAQL982.JAQL982SCAV%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVP IS TABLE OF JAQL982.JAQL982SCVP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVN IS TABLE OF JAQL982.JAQL982SCVN%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCVR IS TABLE OF JAQL982.JAQL982SCVR%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAJ IS TABLE OF JAQL982.JAQL982SCAJ%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SCAC IS TABLE OF JAQL982.JAQL982SCAC%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982PCOD IS TABLE OF JAQL982.JAQL982COD%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982MOD IS TABLE OF fsd011.SCMOD%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982PAP IS TABLE OF fsd011.SCPAP%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982SBOP IS TABLE OF fsd011.SCSBOP%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982FVTO IS TABLE OF fsd011.SCFVTO%TYPE INDEX BY PLS_INTEGER;  
  TYPE Tp_JAQL982TOPE IS TABLE OF fsd011.Sctope%TYPE INDEX BY PLS_INTEGER; 
  TYPE Tp_JAQL982GRU IS TABLE OF JAQL982.JAQL982GRU%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982RUB IS TABLE OF JAQL982.JAQL982RUB%TYPE INDEX BY PLS_INTEGER;
  TYPE Tp_JAQL982RUBR IS TABLE OF JAQL982.JAQL982RUBR%TYPE INDEX BY PLS_INTEGER;
  


  JAQL982COD   Tp_JAQL982COD; 
  JAQL982REG   Tp_JAQL982REG;
  JAQL982REN   Tp_JAQL982REN;
  JAQL982SUC   Tp_JAQL982SUC;
  JAQL982AGE   Tp_JAQL982AGE;
  JAQL982MDA   Tp_JAQL982MDA;
  JAQL982ANA   Tp_JAQL982ANA;
  JAQL982CTA   Tp_JAQL982CTA;
  JAQL982OPE   Tp_JAQL982OPE;
  JAQL982DIA   Tp_JAQL982DIA;
  JAQL982SCAP  Tp_JAQL982SCAP;
  JAQL982SCAN  Tp_JAQL982SCAN;
  JAQL982SCAR  Tp_JAQL982SCAR;
  JAQL982SCAV  Tp_JAQL982SCAV;
  JAQL982SCVP  Tp_JAQL982SCVP;
  JAQL982SCVN  Tp_JAQL982SCVN;
  JAQL982SCVR  Tp_JAQL982SCVR;
  JAQL982SCAJ  Tp_JAQL982SCAJ;
  JAQL982SCAC  Tp_JAQL982SCAC;
  JAQL982PCOD  Tp_JAQL982PCOD;
  JAQL982MOD   Tp_JAQL982MOD;
  JAQL982PAP   Tp_JAQL982PAP;
  JAQL982SBOP  Tp_JAQL982SBOP;
  JAQL982FVTO  Tp_JAQL982FVTO;
  JAQL982TOPE  Tp_JAQL982TOPE;
  JAQL982GRU   Tp_JAQL982GRU;
  JAQL982RUB   Tp_JAQL982RUB;
  JAQL982RUBR  Tp_JAQL982RUBR;
  
  
  ln_numero NUMBER;
  ln_conta NUMBER;
  ln_tipcam number(14,8);
  lc_variable varchar2(100):='PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_bc';
 
begin

  begin
    select cotcbi
      into ln_tipcam
      from fsh005 f
     where cofdes in (select max(cofdes)
                       from fsh005 g
                      where g.cofdes <= pd_fecpro 
                        and moneda = 101)
       and moneda = 101;
  exception when no_data_found then
     ln_tipcam := 0;            
  end;


  --
   begin      
       select count(*)   
         into ln_numero       
        from jaql982;
   exception when no_data_found then
       ln_numero := 0;              
   end;
 
    

   OPEN creditos(pn_regcod , pd_fecpro , ln_tipcam );
    LOOP
      FETCH creditos BULK COLLECT
        INTO  JAQL982REG, JAQL982REN, JAQL982SUC, JAQL982AGE, JAQL982MDA, JAQL982ANA, JAQL982CTA, JAQL982OPE, JAQL982DIA,
              JAQL982PCOD, JAQL982MOD, JAQL982PAP, JAQL982SBOP, JAQL982TOPE, 
              JAQL982GRU, JAQL982RUB, JAQL982SCAP, JAQL982SCAN, JAQL982SCAR, JAQL982SCAV,
              JAQL982SCVP, JAQL982SCVN, JAQL982SCVR, JAQL982SCAJ, JAQL982SCAC, JAQL982FVTO,JAQL982RUBR              
              ;
              
          IF JAQL982REG.COUNT > 0 THEN
             FOR i IN JAQL982REG.FIRST .. JAQL982REG.LAST LOOP
       
               ln_numero := ln_numero + 1; 
       
               insert into jaql982 (jaql982cod, jaql982reg, jaql982ren, jaql982suc, jaql982age, jaql982mda, jaql982ana, 
                                    jaql982cta, jaql982ope, jaql982dia, jaql982scap, jaql982scan, jaql982scar, jaql982scav,
                                    jaql982scvp, jaql982scvn, jaql982scvr, jaql982scaj, jaql982scac,
                                    jaql982pcod, jaql982mod, jaql982pap, jaql982sbop, jaql982tope, 
                                    jaql982gru, jaql982rub, jaql982fvto, jaql982rubr  
                                   ) 
                       
                   
               values (ln_numero,JAQL982REG(i),JAQL982REN(i),JAQL982SUC(i),JAQL982AGE(i),JAQL982MDA(i),JAQL982ANA(i),
                       JAQL982CTA(i),JAQL982OPE(i),JAQL982DIA(i),nvl(JAQL982SCAP(i),0)*-1,nvl(JAQL982SCAN(i),0)*-1,nvl(JAQL982SCAR(i),0)*-1,nvl(JAQL982SCAV(i),0)*-1,
                       nvl(JAQL982SCVP(i),0)*-1,nvl(JAQL982SCVN(i),0)*-1,nvl(JAQL982SCVR(i),0)*-1,nvl(JAQL982SCAJ(i),0)*-1, nvl(JAQL982SCAC(i),0)*-1,
                       JAQL982PCOD(i), JAQL982MOD(i), JAQL982PAP(i), JAQL982SBOP(i), JAQL982TOPE(i), 
                       JAQL982GRU(i), JAQL982RUB(i),  JAQL982FVTO(i),JAQL982RUBR(i)
                      );
        
               
               ln_conta  := ln_conta + 1;

               /*if ln_conta = 80000  then
                  ln_conta := 0;
                  commit; 
               end if; */
               --COMMIT;
               
             END LOOP;
             commit; ---2015
          END IF;    
        
        
           --actualiza analista, dias atraso
          begin
           pq_cr_saldos_linea.sp_cr_actualiza(pn_regcod => pn_regcod, pd_fecpro => pd_fecpro);
          end; 
         
        
      EXIT WHEN creditos%NOTFOUND;
    END LOOP;
   
   --commit;  
  update JAQL983 
    set JAQL983FFI = sysdate
  where /*JAQL983COR = ln_numjob
    and */JAQL983COD = 'SLI' 
    and JAQL983NUM = pn_regcod
    and JAQL983DES = lc_variable;
  COMMIT;
  
  
  --consolida saldos de JAQL982 a JAQL968
  /*begin
    pq_cr_saldos_linea.sp_cr_consolida_INI(pd_fecpro => pd_fecpro);
  end;*/
  

 

 end sp_cr_carga_datos_bc;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_consolida( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.02.12
    -- Autor de Creación          : 
    -- Uso                        : CONSOLIDA DATOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se consolida informacion. 
    --                              2015.03.13 se agrego condicion para consolidar si tabla jaql983 de control jobs se encuentra culminada.
    --                              2015.05.05 se agrego region, zona
    --                              2018.04.16 se agrego funcion fn_cr_valida_registro  y se creo tabla jaql968d para insertar en caso de duplicidad.
    -- *****************************************************************


cursor REGION is
select 
jaql982coz, jaql982noz, 
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
        k.jaql982coz = j.jaql982coz  AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982coz = j.jaql982coz  AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30,
sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
group by jaql982coz, jaql982noz
order by jaql982coz;



cursor ZONA is
select 
jaql982coz, jaql982noz, jaql982reg, jaql982ren, 
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
        k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982coz = j.jaql982coz and H.JAQL982REG = J.JAQL982REG AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30,
sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
group by jaql982coz, jaql982noz,jaql982reg, jaql982ren
order by jaql982coz,jaql982reg;
       

CURSOR AGENCIA IS
select jaql982coz, jaql982noz, jaql982reg, jaql982ren, 
 jaql982suc, jaql982age, 
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
 k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG AND K.JAQL982SUC = J.JAQL982SUC AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982coz = j.jaql982coz and 
       H.JAQL982REG = J.JAQL982REG AND H.JAQL982SUC = J.JAQL982SUC AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj, 
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30,
sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
group by jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age
order by jaql982coz,jaql982reg,jaql982suc;


CURSOR ANALISTA IS
select jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age,  jaql982ana, 
(SELECT COUNT(DISTINCT K.jaql982tid||'-'||K.jaql982doc) FROM JAQL982 K WHERE 
 k.jaql982coz = j.jaql982coz and K.JAQL982REG = J.JAQL982REG 
AND K.JAQL982SUC = J.JAQL982SUC AND K.JAQL982ANA = J.JAQL982ANA AND K.JAQL982MOD<>33)clientes,
(SELECT count(distinct H.jaql982mod||'-'||H.jaql982suc||'-'||H.jaql982mda||'-'||H.jaql982pap||'-'||H.jaql982cta||'-'||H.jaql982ope||'-'||H.jaql982sbop||'-'||H.jaql982tope)
       FROM JAQL982 H WHERE h.jaql982coz = j.jaql982coz and 
       H.JAQL982REG = J.JAQL982REG AND H.JAQL982SUC = J.JAQL982SUC AND H.JAQL982ANA = J.JAQL982ANA  AND H.JAQL982MOD<>33) creditos, 
sum(jaql982scap) jaql982scap, sum(jaql982scan) jaql982scan, sum(jaql982scar) jaql982scar, 
sum(jaql982scav) jaql982scav, sum(jaql982scvp) jaql982scvp, sum(jaql982scvn) jaql982scvn, 
sum(jaql982scvr) jaql982scvr, sum(jaql982scaj) jaql982scaj,  
sum(jaql982scac) jaql982scac, sum(jaql982s15) jaql982s15, sum(jaql982s30) jaql982s30,
sum(jaql982scpv) jaql982scpv, sum(jaql982scp1) jaql982scp1
from jaql982 j
group by jaql982coz, jaql982noz, jaql982reg, jaql982ren, jaql982suc, jaql982age,  jaql982ana
order by jaql982coz,jaql982reg,jaql982suc,jaql982ana;



lc_analista varchar2(10);
ln_numero number:=0;
ln_por15 number:= 0;
ln_por30 number:= 0;
ln_porMC number:= 0; --mora contable
ln_contador number:= 0;
--pd_fecpro date:= to_date('2014.07.30','yyyy.mm.dd');

ld_fecini TIMESTAMP;
ld_fecfin TIMESTAMP;
ln_min number; ---frecuencia pago

ln_tipo number(4);
ln_contajob number; --2016.06.14
ln_fila number; --2018.03.21

begin

/*aplicar estadisticas 2017.11.08*/
 begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD', 
                                          tabname          => 'JAQL982',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
  end; 
/*aplicar estadisticas 2017.11.08*/


  --ld_fecini := sysdate - 1/1440; --menos 5 minutos
  begin
    select tp1nro1
      into ln_tipo 
      from fst198 
     where tp1cod= 1 
       and tp1cod1 = 10872
       and tp1corr1 = 112;
  end;   
  
  --2016.06.14
  begin
    select count(*) 
     into ln_contajob
    from fst198 
    where tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11; 
  end;     
  --2016.06.14

  if to_char(pd_fecpro, 'DD') <'16' then
    ln_min := 45; ---frecuencia pago
  else
    ln_min := 25; ---frecuencia pago
  end if;


  begin
    select count(*) into ln_numero 
      from jaql968;
  exception when no_data_found then
      ln_numero := 1;      
  end;          

  ln_numero := ln_numero + 1;  
  ---contar Jobs ...
  begin
     select count(*)
       into ln_contador
       from jaql983
      where jaql983cod = 'SLI'
        and jaql983des like 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_%';          
  exception when no_Data_found then
     ln_contador := 0;     
  end;
  ----  
  
  ---verificar si los jobs ya concluyeron...
--  if ln_contador >= 14 then --2015.04.28
--  if ln_contador >= 21 then --2016.06.08
  if ln_contador >= ln_contajob-1 then --2016.06.14 
    begin
       select count(*)
         into ln_contador
         from jaql983
        where jaql983cod = 'SLI'
          and jaql983des like 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_%'
          and jaql983ffi is null;          
    exception when no_Data_found then
       ln_contador := 0;     
    end;
  else
     ln_contador := 1;   --falta completar jobs -2015.04.28
  end if;   
  ----
  
  
  if nvl(ln_contador,0) = 0 then
  --obtener maxima fecha
    begin
       select min(jaql983fin), max(jaql983ffi)
         into ld_fecini, ld_fecfin
         from jaql983
        where jaql983cod = 'SLI'
          and jaql983des like 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_%';          
    exception when no_Data_found then
       ln_contador := 0;     
    end;
    
--    if sysdate > (ld_fecfin + ln_min/1440)  then  --2015.04.28     
       
        --insertar en tabla 
        --delete from jaql981A;
        delete from jaql981;
        ld_fecfin := ld_fecfin + ln_min/1440 ;

        --insert into jaql981A (jaql981Afini, jaql981Affin, jaql981Afmin)
        insert into jaql981 (jaql981fini, jaql981ffin, jaql981fmin)
        values(ld_fecini, ld_fecfin, ln_min);

        commit;
        
        
        ---insertar en tabla historica JAQL968A
        insert into jaql968A
        ( jaql968afec,jaql968atime, jaql968areg, jaql968acod, jaql968aana, jaql968acor, jaql968aren, jaql968aage, jaql968asal, jaql968asalj, 
          jaql968ancl, jaql968ancr, jaql968as15, jaql968ap15, jaql968as30, jaql968ap30, jaql968asju, jaql968asve, jaql968asre, jaql968acrju, 
          jaql968acrve, jaql968acrre, jaql968aclju, jaql968aclve, jaql968aclre, jaql968atip, jaql968asca, jaql968asvi, jaql968ascat, jaql968ascac, 
          jaql968ascvp, jaql968ascvn, jaql968ascvr, jaql968agru, jaql968asbs, jaql968acoz, jaql968anoz, jaql968apmr, jaql968ascpv, jaql968ascp1, jaql968ascca
        )
        select 
          jaql968fec, sysdate, jaql968reg, jaql968cod, jaql968ana, jaql968cor, jaql968ren, jaql968age, jaql968sal, jaql968salj, jaql968ncl, jaql968ncr, 
          jaql968s15, jaql968p15, jaql968s30, jaql968p30, jaql968sju, jaql968sve, jaql968sre, jaql968crju, jaql968crve, jaql968crre, jaql968clju, 
          jaql968clve, jaql968clre, jaql968tip, jaql968sca, jaql968svi, jaql968scat, jaql968scac, jaql968scvp, jaql968scvn, jaql968scvr, jaql968gru, 
          jaql968sbs,jaql968coz, jaql968noz, jaql968pmr, jaql968scpv, jaql968scp1, jaql968scca 
        from jaql968 where jaql968fec = pd_fecpro and jaql968tip in (4,5,6,7);

        
         --eliminar registros anteriores
        delete from jaql968 where jaql968fec = pd_fecpro and jaql968tip in (4,5,6,7);
        --SE SUMA 10 para no eliminar informacion existente y diaria
        --delete from jaql968 where jaql968fec = pd_fecpro and jaql968tip in (14,15,16,17);
        commit;
        
--ln_numero := ln_numero + 50000; 
    --POR REGION  -- TIPO 4
    for i in region loop
       if i.jaql982scap = 0 then
            ln_porMC := 0;   
            ln_por15 := 0;  
            ln_por30 := 0;  
       else
           ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );          
           ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
           ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
            
       end if;     
--DBMS_OUTPUT.PUT_LINE(pd_fecpro||'-'||'0-0- - -'||ln_numero||'-'||ln_tipo);
       
       --VALIDA SI EXISTE registro por tipo, region y saldo
              --VALIDA SI EXISTE registro por tipo, region y saldo
      
       
       begin

        ln_fila := pq_cr_saldos_linea.fn_cr_valida_registro(ld_fecha => pd_fecpro,
                                                            ln_tipo => ln_tipo+4,
                                                            ln_codzon => i.jaql982coz,
                                                            ln_codreg => 0,
                                                            ln_codigo => 0,
                                                            ln_analista => '-',
                                                            ln_saldoj => i.jaql982scap,
                                                            ln_saldo => i.jaql982scan);
      end;
       
       if ln_fila > 0 then
         --en caso de error
          insert into jaql968D (
                    JAQL968DCOR, jaql968Dtip, jaql968Dfec, jaql968Dreg, jaql968Dren, jaql968Dcod, jaql968Dage, jaql968Dana, 
                    jaql968Dsalj, jaql968Dsal, jaql968Dsju, JAQL968DSVE, jaql968Dscvp, jaql968Dscvn, jaql968Dsre,
                    jaql968Dscvr, JAQL968DSCA, JAQL968DS15, JAQL968DS30, jaql968DP15, jaql968Dp30,
                    jaql968Dncl, jaql968Dncr , jaql968Dpmr, jaql968Dcoz, jaql968Dnoz,jaql968Dscpv, jaql968Dscp1, jaql968Dscca
                   )
           values ( ln_numero, ln_tipo+4, pd_fecpro, 0, 'D', 0, '-', '-', 
                    /*trunc*/(i.jaql982scap), /*trunc*/(i.jaql982scan), /*trunc*/(i.jaql982scaj), /*trunc*/(i.jaql982scav)+i.jaql982scp1,/*trunc*/( i.jaql982scvp), /*trunc*/(i.jaql982scvn)+ i.jaql982scp1, /*trunc*/(i.jaql982scar),
                    /*trunc*/(i.jaql982scvr), /*trunc*/(i.jaql982scac), /*trunc*/(i.jaql982s15), /*trunc*/(i.jaql982s30), ln_por15, ln_por30,
                    i.clientes, i.creditos , ln_porMC , i.jaql982coz, i.jaql982noz, i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                  );
            ln_numero := ln_numero + 1; 
           commit;    
       
       else
       --VALIDA SI EXISTE registro por tipo, region y saldo 
                                             
         insert into jaql968 (
                    JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, 
                    jaql968salj, jaql968sal, jaql968sju, JAQL968SVE, jaql968scvp, jaql968scvn, jaql968sre,
                    jaql968scvr, JAQL968SCA, JAQL968S15, JAQL968S30, jaql968P15, jaql968p30,
                    jaql968ncl, jaql968ncr , jaql968pmr, jaql968coz, jaql968noz,jaql968scpv, jaql968scp1, jaql968scca
                   )
           values ( ln_numero, ln_tipo+4, pd_fecpro, 0, '-', 0, '-', '-', 
                    /*trunc*/(i.jaql982scap), /*trunc*/(i.jaql982scan), /*trunc*/(i.jaql982scaj), /*trunc*/(i.jaql982scav)+i.jaql982scp1,/*trunc*/( i.jaql982scvp), /*trunc*/(i.jaql982scvn)+ i.jaql982scp1, /*trunc*/(i.jaql982scar),
                    /*trunc*/(i.jaql982scvr), /*trunc*/(i.jaql982scac), /*trunc*/(i.jaql982s15), /*trunc*/(i.jaql982s30), ln_por15, ln_por30,
                    i.clientes, i.creditos , ln_porMC , i.jaql982coz, i.jaql982noz, i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                  );
            ln_numero := ln_numero + 1; 
           commit;    
        end if;
        
    end loop;  
    commit;  

    --POR ZONA  -- TIPO 4
    for i in Zona loop
       if i.jaql982scap = 0 then
            ln_porMC := 0;   
            ln_por15 := 0;  
            ln_por30 := 0;  
       else
           ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );          
           ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
           ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
            
       end if;     
    
       begin

        ln_fila := pq_cr_saldos_linea.fn_cr_valida_registro(ld_fecha => pd_fecpro,
                                                            ln_tipo => ln_tipo+5,
                                                            ln_codzon => i.jaql982coz,
                                                            ln_codreg => i.jaql982reg,
                                                            ln_codigo => 0,
                                                            ln_analista => '-',
                                                            ln_saldoj => i.jaql982scap,
                                                            ln_saldo => i.jaql982scan);
       end;
       
       if ln_fila > 0 then
          null;
       
       else
    
    
         insert into jaql968 (
                      JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, 
                      jaql968salj, jaql968sal, jaql968sju, JAQL968SVE, jaql968scvp, jaql968scvn, jaql968sre,
                      jaql968scvr, JAQL968SCA, JAQL968S15, JAQL968S30, jaql968P15, jaql968p30,
                      jaql968ncl, jaql968ncr , jaql968pmr, jaql968coz, jaql968noz, jaql968scpv, jaql968scp1, jaql968scca
                     )
             values ( ln_numero, ln_tipo+5, pd_fecpro, i.jaql982reg, i.jaql982ren, 0, '-', '-', 
                      /*trunc*/(i.jaql982scap), /*trunc*/(i.jaql982scan), /*trunc*/(i.jaql982scaj), /*trunc*/(i.jaql982scav)+ i.jaql982scp1,/*trunc*/( i.jaql982scvp), /*trunc*/(i.jaql982scvn)+ i.jaql982scp1, /*trunc*/(i.jaql982scar),
                      /*trunc*/(i.jaql982scvr), /*trunc*/(i.jaql982scac), /*trunc*/(i.jaql982s15), /*trunc*/(i.jaql982s30), ln_por15, ln_por30,
                      i.clientes, i.creditos , ln_porMC , i.jaql982coz, i.jaql982noz,i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                    );
             ln_numero := ln_numero + 1;  
             commit;    
             end if;
    end loop;
    commit;
           
    --POR AGENCIA  -- TIPO 5
    for i in agencia loop
    
       if i.jaql982scap = 0 then
            ln_porMC := 0;   
            ln_por15 := 0;  
            ln_por30 := 0;   
       else
            ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );          
             if  i.jaql982s15 = 0 then
                 ln_por15 := 0;
             else    
                 ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
             end if;
             if i.jaql982s30 = 0 then    
                 ln_por30 := 0;
             else
                  ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
             end if;    
            
       end if;     
    
        begin
  
          ln_fila := pq_cr_saldos_linea.fn_cr_valida_registro(ld_fecha => pd_fecpro,
                                                              ln_tipo => ln_tipo+6,
                                                              ln_codzon => i.jaql982coz,
                                                              ln_codreg => i.jaql982reg,
                                                              ln_codigo => i.jaql982suc,
                                                              ln_analista => '-',
                                                              ln_saldoj => i.jaql982scap,
                                                              ln_saldo => i.jaql982scan);
         end;
         
       if ln_fila > 0 then
          null;
       
       else 
         
         insert into jaql968 (
                      JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, 
                      jaql968salj, jaql968sal, jaql968sju, JAQL968SVE, jaql968scvp, jaql968scvn, jaql968sre,
                      jaql968scvr, JAQL968SCA, JAQL968S15, JAQL968S30, jaql968P15, jaql968p30,
                      jaql968ncl, jaql968ncr , jaql968pmr, jaql968coz, jaql968noz,jaql968scpv, jaql968scp1, jaql968scca
                     )
             values ( ln_numero, ln_tipo+6, pd_fecpro, i.jaql982reg, i.jaql982ren, i.jaql982suc, i.jaql982age,  '-', 
                      /*trunc*/(i.jaql982scap), /*trunc*/(i.jaql982scan), /*trunc*/(i.jaql982scaj), /*trunc*/(i.jaql982scav)+ i.jaql982scp1, /*trunc*/(i.jaql982scvp), /*trunc*/( i.jaql982scvn)+ i.jaql982scp1, /*trunc*/(i.jaql982scar),
                      /*trunc*/(i.jaql982scvr), /*trunc*/(i.jaql982scac), /*trunc*/(i.jaql982s15), /*trunc*/(i.jaql982s30), ln_por15, ln_por30,
                      i.clientes, i.creditos , ln_porMC, i.jaql982coz, i.jaql982noz,i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                    );
             ln_numero := ln_numero + 1;   
             
             commit;
             
       end if;      
    end loop;
    commit; 
    --POR AGENCIA  -- TIPO 6
    for i in analista loop
    
     lc_analista := nvl(i.jaql982ana,'-');
     if i.jaql982scap = 0 then
          ln_porMC :=  0;   
          ln_por15 := 0;  
          ln_por30 := 0;             
     else
          ln_porMC :=  round( ((i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)/i.jaql982scap)*100,2 );          
           if  i.jaql982s15 = 0 then
               ln_por15 := 0;
           else   
               ln_por15 :=  round( i.jaql982s15/i.jaql982scap*100, 2);
           end if;
            
           if i.jaql982s30 = 0 then    
               ln_por30 := 0;
           else
                ln_por30 :=  round( i.jaql982s30/i.jaql982scap*100, 2);
            end if;    
               
     
     end if;     
  
      begin

      ln_fila := pq_cr_saldos_linea.fn_cr_valida_registro(ld_fecha => pd_fecpro,
                                                          ln_tipo => ln_tipo+7,
                                                          ln_codzon => i.jaql982coz,
                                                          ln_codreg => i.jaql982reg,
                                                          ln_codigo => i.jaql982suc,
                                                          ln_analista => lc_analista,
                                                          ln_saldoj => i.jaql982scap,
                                                          ln_saldo => i.jaql982scan);
     end;
     
     if ln_fila > 0 then
        null;
     
     else 
          
         insert into jaql968 (
                      JAQL968COR, jaql968tip, jaql968fec, jaql968reg, jaql968ren, jaql968cod, jaql968age, jaql968ana, 
                      jaql968salj, jaql968sal, jaql968sju, JAQL968SVE, jaql968scvp, jaql968scvn, jaql968sre,
                      jaql968scvr, JAQL968SCA, JAQL968S15, JAQL968S30, jaql968P15, jaql968p30,
                      jaql968ncl, jaql968ncr , jaql968pmr, jaql968coz, jaql968noz,jaql968scpv, jaql968scp1, jaql968scca
                     )
             values ( ln_numero, ln_tipo+7 , pd_fecpro, i.jaql982reg, i.jaql982ren, i.jaql982suc, i.jaql982age,  lc_analista, 
                      /*trunc*/(i.jaql982scap), /*trunc*/(i.jaql982scan), /*trunc*/(i.jaql982scaj), /*trunc*/(i.jaql982scav)+ i.jaql982scp1, /*trunc*/(i.jaql982scvp), /*trunc*/(i.jaql982scvn)+ i.jaql982scp1, /*trunc*/(i.jaql982scar),
                      /*trunc*/(i.jaql982scvr), /*trunc*/(i.jaql982scac), /*trunc*/(i.jaql982s15), /*trunc*/(i.jaql982s30), ln_por15, ln_por30,
                      i.clientes, i.creditos , ln_porMC, i.jaql982coz, i.jaql982noz, i.jaql982scpv, i.jaql982scp1, (i.jaql982scaj +  i.jaql982scav + i.jaql982scp1)
                    );
             ln_numero := ln_numero + 1;   
             commit;
             
      end if;
             
    end loop;
    commit; 
--    end if;  


    -- comentar hasta habilitar reporte SBS
    begin
      -- Call the procedure
      pq_cr_saldos_linea.sp_cr_consolida_sbs(pd_fecpro => pd_fecpro);
    end;

  end if;  
  
 end sp_cr_consolida;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_actualiza(pn_regcod number, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.02.12
    -- Autor de Creación          : 
    -- Uso                        : ACTUALIZA ANALISTA, DIAS ATRASO, TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se consolida informacion. 
    --                              2015.05.05 se agrego region, zona
    -- Fecha de Modificación      : 10/06/2015
    -- Autor de la Modificación   : ABERNEDO
    -- Descripción de Modificación: Reclasificacion
    --                              2015.11.09 DCASTRO Se agrego condicion para dias 16,31,91 saldo vencido
    --                              2015.11.24 DCASTRO Se agrego condicion para no calcular proyeccion si credito se encuentra en judicial.
    --                              2016.01.12 DCASTRO se agrego condicion para actualizar refinanciados en creditos consumo e hipotecario
    --                              2016.01.12 DCASTRO se agrego condicion para actualizar refinanciados en creditos diferentes de consumo e hipotecario    
    --                              2016.01.16 DCASTRO se agrego condicion para actualizar refinanciados
    --                              2016.01.20 DCASTRO se agrego condicion para actualizar vencidos
    --                              2016.03.31 DCASTRO se agrego proyeccion mes.
    --                              2016.06.14 DCASTRO se agrego actualizacion de variables fecha desembolso, tipo doc, numdoc.
    -- *****************************************************************


cursor creditos is
    select --/*+parallel(j,4)*/
           * from jaql982 j 
          where j.jaql982reg = pn_regcod;
--          where jaql982cta in ( 417257, 154068 ) ;
 
             

       

lc_analista varchar2(10);
lc_analis   varchar2(10);
ln_dia number;
ln_conta NUMBER:=0;
lc_titular varchar2(100);
ln_tipcre number;
ld_fecdes date;
ln_pais fsr008.pepais%type;
ln_petdoc fsr008.petdoc%type;
ln_pendoc fsr008.pendoc%type;
ln_sal15 number;
ln_sal30 number;
lc_productosbs varchar2(30);
ln_codreg number;
lc_nomreg varchar2(50);

-------------------------------ABR----------------------------------------
pc_flag char(2);
pc_caracter char(2);
pc_vencido char(2);
pn_mtovencido number(17,2);
pn_mtovencidoPago number(17,2);
pn_mtovencido1 number(17,2);
pd_finmes date;
pn_dfinmes number(3);
pn_dfecpro number(3);
pn_difdias number(3);
ln_tipcam number(14,8);
ln_mtoref number(17,2); --2016.01.12
ln_refina number(17,2); --2016.01.16
ln_diacierre number; -- 2016.03.31
ln_proyeccion number; -- 2016.03.31

--------------------------------------------------------------------------
--pd_fecpro date:= to_date('2014.07.30','yyyy.mm.dd');

begin

 /* begin
      DBMS_STATS.gather_table_stats(ownname          => 'DESA01082014A', --'BANTPROD'
                                    tabname          => 'JAQL982',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
  end;

  begin
      DBMS_STATS.gather_table_stats(ownname          => 'DESA01082014A', --'BANTPROD'
                                    tabname          => 'JAQL964',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
  end;*/


 begin
    select cotcbi
      into ln_tipcam
      from fsh005 f
     where cofdes in (select max(cofdes)
                       from fsh005 g
                      where g.cofdes <= pd_fecpro 
                        and moneda = 101)
       and moneda = 101;
  exception when no_data_found then
     ln_tipcam := 0;            
  end;


  begin
    select tp1nro1
      into ln_proyeccion 
      from fst198 
     where tp1cod= 1 
       and tp1cod1 = 10872
       and tp1corr1 = 113;
  exception when no_data_found then
       ln_proyeccion := 0;          
  end;

  for i in creditos loop

      ln_refina := i.jaql982scar;  --2016.01.16
  
       begin
         select distinct jaql964tit, jaql964dia, jaql964usu, to_date(jaql964fdes,'yyyy.mm.dd'), jaql964tcr , jaql964doc, jaql964tid, jaql964pai
           into lc_titular, ln_dia, lc_analista, ld_fecdes , ln_tipcre, ln_pendoc, ln_petdoc, ln_pais
           from jaql964 j
          where jaql964cta = i.JAQL982CTA
            and jaql964ope = i.JAQL982OPE
            and jaql964mod = i.jaql982MOD;
--       exception when no_data_found then
       exception when others then
          lc_titular := null;
       end;
       
       --verificando si tuvo traslasdo de cartera
       begin
          select sng130asds
            into lc_analis
            from sng130 s1, sng131 s2, jaqy167 n
           where s2.sng130cor = s1.sng130cor
             and s2.sng131pgc = s1.sng130pgc
             and sng130fape = pd_fecpro 
             --and sng130fape = to_date('30.07.2014', 'dd.mm.yyyy')
             and ((s2.sng131con = 'S' and s2.sng131tmod > 0) or (sng131tmod = 0))
             and s2.sng130cor = n.sng130cor
             and s2.sng131pgc = n.sng131pgc
             and s2.sng131mod = n.sng131mod
             and s2.sng131suc = n.sng131suc
             and s2.sng131mda = n.sng131mda
             and s2.sng131pap = n.sng131pap
             and s2.sng131cta = n.sng131cta
             and s2.sng131ope = n.sng131ope
             and s2.sng131sbo = n.sng131sbo
             and s2.sng131top = n.sng131top
             and n.sng131cta = i.JAQL982CTA
             and n.sng131ope = i.JAQL982OPE;
       exception when others then
           lc_analis := null;       
       end;
     
       if lc_analis is not null then
          lc_analista := lc_analis;
       end if;       
              
        if lc_analista is null then
      
           lc_analista :=  fn_analista_credito(i.JAQL982MOD,i.JAQL982SUC,i.JAQL982MDA,i.JAQL982PAP,i.JAQL982CTA,i.JAQL982OPE,i.JAQL982SBOP,i.JAQL982TOPE) ;
           lc_analista :=  trim(lc_analista);
           --no se calcula porque al ser nuevo no se reflejara en listado detallado
           --ln_dia :=  fn_dias_atraso(pd_fecpro, i.JAQL982PCOD, i.JAQL982MOD, i.JAQL982SUC, i.JAQL982MDA,i.JAQL982PAP, i.JAQL982CTA, i.JAQL982OPE, i.JAQL982SBOP, i.JAQL982TOPE, 0, i.JAQL982FVTO) ;
           
           /*begin
             select g.penom, g.pendoc, g.petdoc
              into lc_titular, ln_pendoc, ln_petdoc
              from fsr008 f, fsd001 g
             where f.pgcod = 1
               and f.pepais = g.pepais
               and f.petdoc = g.petdoc
               and f.pendoc = g.pendoc
               and f.ctnro = i.JAQL982CTA
               and f.ttcod = 1
               and f.cttfir = 'T';
           exception when no_data_found then
               lc_titular := null;
           end;     */
        end if;
        
        if  ld_fecdes is null then  
            BEGIN
               select d010.aofval
                    into ld_fecdes
                    from fsd010 d010
               where d010.pgcod = 1
                 and d010.aomod = i.JAQL982MOD
                 and d010.aomda = i.JAQL982MDA
                 and d010.aocta = i.JAQL982CTA
                 and d010.aooper = i.JAQL982OPE
                 and d010.aosbop = i.JAQL982SBOP
                 and d010.aotope = i.JAQL982TOPE;
                         
             exception when others then 
                 NULL;
             END;

        end if;  
        
       if ln_tipcre is null 
          or ln_pais is null or ln_petdoc is null or ln_pendoc is null
       then 
          begin
               select f.pepais, f.petdoc, f.pendoc
                into ln_pais, ln_petdoc, ln_pendoc
                from fsr008 f
               where f.pgcod = 1
                 and f.ctnro = i.JAQL982CTA
                 and f.ttcod = 1
                 and f.cttfir = 'T';
             exception when no_data_found then
                 lc_titular := null;
             end;
          
          
          begin
            ln_tipcre := pq_cr_saldos_linea.fn_cr_tipo_credito_desem(lc_pepais => ln_pais,
                                                                   lc_petdoc => ln_petdoc,
                                                                   lc_pendoc => ln_pendoc,
                                                                   ld_fecref => ld_fecdes);
          end;
          
        end if;   
        if i.JAQL982MOD <> 33 THEN
          ln_dia :=  fn_dias_atraso(pd_fecpro, i.JAQL982PCOD, i.JAQL982MOD, i.JAQL982SUC, i.JAQL982MDA,i.JAQL982PAP, i.JAQL982CTA, i.JAQL982OPE, i.JAQL982SBOP, i.JAQL982TOPE, 0, i.JAQL982FVTO) ;
        END IF;  
        --saldo >15 y saldo >30
        ln_sal15 := 0;
        ln_sal30 := 0;
        if i.JAQL982MOD <> 33 and ln_dia > 15 then
           ln_sal15 := i.jaql982scap;
        end if;
           
        if i.JAQL982MOD <> 33 and ln_dia > 30 then
           ln_sal30 := i.jaql982scap;
        end if;

        --producto sbs
        
        case when i.jaql982gru = 2 then 
                  lc_productosbs:= 'MICROEMPRESAS';
             when i.jaql982gru = 3 and i.jaql982rub = 15 then 
                  lc_productosbs :='CONSUMO REVOLVENTE';
             when i.jaql982gru = 3 and i.jaql982rub <>15 then  
                  lc_productosbs :='CONSUMO NO REVOLVENTE';
             when i.jaql982gru = 4 then  
                  lc_productosbs := 'HIPOTECARIO';
             when i.jaql982gru = 11 then 
                  lc_productosbs := 'GRANDES EMPRESAS';
             when i.jaql982gru = 12 then 
                  lc_productosbs := 'MEDIANA EMPRESA';
             when i.jaql982gru = 13 then 
                  lc_productosbs := 'PEQUEÑA EMPRESA';
             when i.jaql982gru in ( 5,6,7,8,9,10) then 
                  lc_productosbs := 'CORPORATIVO';
             else
                  lc_productosbs := null;
        end case;
        -----
        --actualiza region-zona
         pq_cr_saldos_linea.sp_cr_region_zona(lc_codsuc => i.jaql982suc,
                                       ln_codreg => ln_codreg,
                                       lc_nomreg => lc_nomreg);
                                       
        -------------------RECLASIFICACION---------------------------------------------------------                                       
        --cambio ccerpa
        -------------------------------------------------------------------------------------------
        pc_flag := pq_cr_SALDOS_LINEA.Fn_TienePago(i.jaql982pcod,i.jaql982cta,i.jaql982ope);         
             If pc_flag = 'S' then
                pc_vencido  := substr(i.jaql982rubr ,4,1);
                pc_caracter := substr(i.jaql982rubr ,7,2);
                --normal vencido
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru not in (3,4,5,6,7,8,9,10,11,12) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scan = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvn = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                --2016.01.20
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru in (5,6,7,8,9,10,11,12) and
                   ln_dia <= 16 then
                   update jaql982
                      set jaql982scan = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvn = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                --2016.01.20
                             
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru in (3,4) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scav = 0,
                          jaql982scvn = 0,
                          jaql982scan = i.jaql982scap
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru in (3,4) and
                   ln_dia between 30 and 90 then
                   
                   pn_mtovencidoPago := pq_cr_SALDOS_LINEA.fn_Mto_vto(i.jaql982pcod,i.jaql982mod,
                                                                  i.jaql982suc,i.jaql982mda,
                                                                  i.jaql982pap,i.jaql982cta,
                                                                  i.jaql982ope,i.jaql982sbop,
                                                                  i.jaql982tope,pd_fecpro);
                   
                   pn_mtovencidoPago := nvl(pn_mtovencidoPago,0);
                   
                   update jaql982
                      set jaql982scav = pn_mtovencidoPago,
                          jaql982scvn = pn_mtovencidoPago,
                          jaql982scan = i.jaql982scap - pn_mtovencidoPago
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                ---refinanciado vencido
--                ln_refina :=  i.jaql982scap;
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru not in (3,4,5,6,7,8,9,10,11,12) and
                   ln_dia <= 30 then
                   ln_refina := i.jaql982scap;--2016.01.16
                   update jaql982
                      set jaql982scar = i.jaql982scap, --descomentando 2016.01.12
                          jaql982scav = 0,
                          jaql982scvr = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                
                --2016.01.07
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru  in (5,6,7,8,9,10,11,12) and
                   ln_dia <= 16 then
                   ln_refina :=  i.jaql982scap;--2016.01.16
                   update jaql982
                      set jaql982scar = i.jaql982scap, --se agrego  2016.01.12
                          jaql982scav = 0,
                          jaql982scvr = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;  
                --2016.01.07              
                
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru in (3,4) and
                   ln_dia <= 30 then
                   ln_refina :=  i.jaql982scap;--2016.01.16
                   update jaql982
                      set jaql982scav = 0,
                          jaql982scvr = 0,
                          jaql982scar = i.jaql982scap --2016.01.12 --descomentando
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru in (3,4) and
                   ln_dia between 30 and 90 then
                   
                   pn_mtovencidoPago := pq_cr_SALDOS_LINEA.fn_Mto_vto(i.jaql982pcod,i.jaql982mod,
                                                                  i.jaql982suc,i.jaql982mda,
                                                                  i.jaql982pap,i.jaql982cta,
                                                                  i.jaql982ope,i.jaql982sbop,
                                                                  i.jaql982tope,pd_fecpro);
                                                                  
                   pn_mtovencidoPago := nvl(pn_mtovencidoPago,0);
                   
                   update jaql982
                      set jaql982scav = pn_mtovencidoPago,
                          jaql982scvr = pn_mtovencidoPago ,
                          jaql982scar = i.jaql982scap - pn_mtovencidoPago --se descomento 2016.01.12
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                ------prendario vencido
                if pc_vencido = '5' and pc_caracter = '13' and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scan = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvp = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
          
             End If;
             
             --PROYECCION
             --determinar el saldo por vencer
             pd_finmes := last_day(trunc(pd_fecpro));
             pn_dfinmes := to_number(to_char(pd_finmes,'dd'))   ;
             pn_dfecpro := to_number(to_char(pd_fecpro,'dd'))   ;
             pn_difdias := (pn_dfinmes - pn_dfecpro) - 1 ;
             
             ln_diacierre := ln_dia + pn_difdias +1;-- 2016.03.31
             
             pn_mtovencido := 0;
             pn_mtovencido1 := 0;
             If pn_difdias < 0 then
                pn_difdias := 0;
             end if;
             
             --1--PROYECCION FIN MES
             if ln_proyeccion = 1 then
                 if substr(i.jaql982rubr,1,4) in (1416,1426) then
                    pn_mtovencido := 0;
                 
                 else
                     If ( ln_diacierre between 16 - pn_difdias and 16 and i.jaql982gru in (5,6,7,8,9,10,11,12) and substr(i.jaql982rubr,1,4) not in (1415,1425)) 
                        or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_diacierre >= 16 and  i.jaql982gru in (5,6,7,8,9,10,11,12) )
                       then
                        pn_mtovencido := i.jaql982scap;
                        
                     end if;
                     
                     If (ln_diacierre between 31 - pn_difdias and 31 and i.jaql982gru in (2,13) and substr(i.jaql982rubr,1,4) not in (1415,1425))
                     or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_diacierre >= 31 and  i.jaql982gru in (2,13) ) then
                        pn_mtovencido := i.jaql982scap;
                        
                        
                     end if;
                     
                   
                     If ln_diacierre >= 31 and  i.jaql982gru in (3,4) and substr(i.jaql982rubr,1,4) not in (1415,1425) then  --2016.01.06
                     
                        pn_mtovencido := pq_cr_SALDOS_LINEA.fn_Mto_vtoFM(i.jaql982pcod,i.jaql982mod,
                                                                          i.jaql982suc,i.jaql982mda,
                                                                          i.jaql982pap,i.jaql982cta,
                                                                          i.jaql982ope,i.jaql982sbop,
                                                                          i.jaql982tope,pd_fecpro);
                                                                          
                         if i.jaql982mda = 101 then
                            pn_mtovencido := pn_mtovencido * ln_tipcam;
                         end if;                                                                   
                                  
                                             
                     end if;         
                         
                     
                     If (ln_diacierre between 90 - pn_difdias and 90 and i.jaql982gru in (3,4) and substr(i.jaql982rubr,1,4) not in (1415,1425))
                     or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_diacierre > 91 and  i.jaql982gru in (3,4) ) then

                        pn_mtovencido := i.jaql982scap;
                       
                     end if;
                    

                 end if; 
                 
             end if;        
             --2016.03.31
             
             
            --2---PROYECCION DEL DIA
             
             --2015.11.24
             if substr(i.jaql982rubr,1,4) in (1416,1426) then
    
                pn_mtovencido1 := 0;
             
             else
             --2015.11.24
--                 If ( ln_dia between 15 - pn_difdias and 15 and i.jaql982gru in (5,6,7,8,9,10,11,12)) 
                 If ( ln_dia between 16 - pn_difdias and 16 and i.jaql982gru in (5,6,7,8,9,10,11,12) and substr(i.jaql982rubr,1,4) not in (1415,1425)) 
--                    or (substr(i.jaql982rubr,1,4) in (1411,1421) and ln_dia > 16 and  i.jaql982gru in (5,6,7,8,9,10,11,12) )
                    or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia >= 16 and  i.jaql982gru in (5,6,7,8,9,10,11,12) )
                   then
                    --pn_mtovencido := i.jaql982scap;
--                    if  ( ln_dia = 15 
                    if  ( (ln_dia = 16 and substr(i.jaql982rubr,1,4) not in (1415,1425))
                         or 
--                         (substr(i.jaql982rubr,1,4) in (1411,1421) and ln_dia > 16 and  i.jaql982gru in (5,6,7,8,9,10,11,12) )
                         (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia >= 16 and  i.jaql982gru in (5,6,7,8,9,10,11,12) )
                         )
                    then
                        pn_mtovencido1 := i.jaql982scap;
                    end if;    
                    
                    
                 end if;
                 
--                 If (ln_dia between 30 - pn_difdias and 30 and i.jaql982gru in (2,13))
                 If (ln_dia between 31 - pn_difdias and 31 and i.jaql982gru in (2,13) and substr(i.jaql982rubr,1,4) not in (1415,1425))
--                 or (substr(i.jaql982rubr,1,4) in (1411,1421) and ln_dia > 31 and  i.jaql982gru in (2,13) ) then
                 or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia >= 31 and  i.jaql982gru in (2,13) ) then
                    --pn_mtovencido := i.jaql982scap;
--                    if ( ln_dia = 30 
                    if ( (ln_dia = 31 and substr(i.jaql982rubr,1,4) not in (1415,1425))
--                       or (substr(i.jaql982rubr,1,4) in (1411,1421) and ln_dia > 31 and  i.jaql982gru in (2,13) )
                       or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia >= 31 and  i.jaql982gru in (2,13) )
                      )
                       then
                        pn_mtovencido1 := i.jaql982scap;
                    end if; 
                    
                    
                 end if;
                 
                --If ln_dia between 31 - pn_difdias and 31 and i.jaql982gru in (3,4) then
                 If ln_dia >= 31 and  i.jaql982gru in (3,4) and substr(i.jaql982rubr,1,4) not in (1415,1425) then  --2016.01.06

                 
                    pn_mtovencido1 /*pn_mtovencido*/ := pq_cr_SALDOS_LINEA.fn_Mto_vto(i.jaql982pcod,i.jaql982mod,
                                                                      i.jaql982suc,i.jaql982mda,
                                                                      i.jaql982pap,i.jaql982cta,
                                                                      i.jaql982ope,i.jaql982sbop,
                                                                      i.jaql982tope,pd_fecpro);
                                                                      
                     if i.jaql982mda = 101 then
                        --pn_mtovencido := pn_mtovencido * ln_tipcam;
                        pn_mtovencido1 := pn_mtovencido1 * ln_tipcam;
                     end if;                                                                   
                              
                     if ln_dia >= 31 then
                        --pn_mtovencido1 := pn_mtovencido;
                        pn_mtovencido1 := pn_mtovencido1;
                     end if;
                     
                     --2016.01.12   
                     ln_mtoref := 0;
                     if  substr(i.jaql982rubr,1,4) in (1414,1424) AND  i.jaql982gru in (3,4) then
                         ln_mtoref := pn_mtovencido1;
                     else    
                         ln_mtoref := 0;
                     end if;
                     --2016.01.12 
                                         
                 end if;         
                     
                 
                 If (ln_dia between 90 - pn_difdias and 90 and i.jaql982gru in (3,4) and substr(i.jaql982rubr,1,4) not in (1415,1425))
                 or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia > 91 and  i.jaql982gru in (3,4) ) then

                    --pn_mtovencido := i.jaql982scap;
                    if ( (ln_dia = 90 and substr(i.jaql982rubr,1,4) not in (1415,1425) )
                        or (substr(i.jaql982rubr,1,4) not in (1415,1425) and ln_dia > 91 and  i.jaql982gru in (3,4))
                        )
                    then
                        pn_mtovencido1 := i.jaql982scap;
                    end if;     
                    
                 end if;
                

                --2016.01.14   
                 ln_mtoref := 0;
                 if  substr(i.jaql982rubr,1,4) in (1414,1424) then
                     ln_mtoref := pn_mtovencido1;
                 else    
                     ln_mtoref := 0;
                 end if;
                 --2016.01.14 

                                      
            end if; -- 2015.11.24       
        ---   
        ---
 
         update jaql982
            set JAQL982ANA = lc_analista,
                JAQL982DIA = ln_dia, 
                JAQL982TIT = lc_titular,
                JAQL982TCR = ln_tipcre,
                JAQL982S15 = ln_sal15,
                JAQL982S30 = ln_sal30,
                JAQL982DOC = ln_pendoc,
                JAQL982TID = ln_petdoc,
                JAQL982SBS = lc_productosbs,
                JAQL982COZ = ln_codreg,
                JAQL982NOZ = lc_nomreg,
                jaql982flg = pc_flag,--ABR
                jaql982scpv = pn_mtovencido,--ABR
                jaql982scp1 = pn_mtovencido1, --monto vencido 1 dia
                jaql982scar = ln_refina - ln_mtoref, --2016.01.16
                                --jaql982scar = i.jaql982scar - ln_mtoref  --2016.01.12
                JAQL982PAIS = ln_pais, ----2016.06.14
                JAQL982FVAL = ld_fecdes --2016.06.14         
          where JAQL982CTA = i.JAQL982CTA
            and JAQL982OPE = i.JAQL982OPE
            and JAQL982GRU = i.jaql982gru
            and JAQL982RUBR = i.jaql982rubr;--2016.01.13

          ln_mtoref := 0; --2016.01.12
          ln_dia := null;
          lc_analista := null;
          lc_titular := null;
          lc_analis := null;
          ln_petdoc := null;
          ln_pendoc := null;
          pc_vencido := null;
          pc_caracter := null;
          pn_mtovencido := 0;
          pn_mtovencido1 := 0;
          ln_pais := null;
          ld_fecdes := null;
          --commit;    
           ln_conta  := ln_conta + 1;

          /* if ln_conta = 10000  then
              ln_conta := 0;
              commit; 
           end if;  */
           commit;
  end loop;
  /*commit; */   

 
 end sp_cr_actualiza;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_actualiza_hi(pn_regcod number, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.02.12
    -- Autor de Creación          : 
    -- Uso                        : ACTUALIZA ANALISTA, DIAS ATRASO, TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se consolida informacion. 
    --                              2015.05.05 se agrego region, zona
    -- Fecha de Modificación      : 10/06/2015
    -- Autor de la Modificación   : ABERNEDO
    -- Descripción de Modificación: Reclasificacion
    --                              2015.11.09 DCASTRO Se agrego condicion para dias 16,31,91 saldo vencido
    -- *****************************************************************


cursor creditos is
    select --/*+parallel(j,4)*/
           * from jaql982 j where j.jaql982reg = pn_regcod;
         
           

       

lc_analista varchar2(10);
lc_analis   varchar2(10);
ln_dia number;
ln_conta NUMBER:=0;
lc_titular varchar2(100);
ln_tipcre number;
ld_fecdes date;
ln_pais fsr008.pepais%type;
ln_petdoc fsr008.petdoc%type;
ln_pendoc fsr008.pendoc%type;
ln_sal15 number;
ln_sal30 number;
lc_productosbs varchar2(30);
ln_codreg number;
lc_nomreg varchar2(50);

-------------------------------ABR----------------------------------------
pc_flag char(2);
pc_caracter char(2);
pc_vencido char(2);
pn_mtovencido number(17,2);
pn_mtovencidoPago number(17,2);
pn_mtovencido1 number(17,2);
pd_finmes date;
ln_tipcam number(14,8);
--------------------------------------------------------------------------
--pd_fecpro date:= to_date('2014.07.30','yyyy.mm.dd');

begin




 begin
    select cotcbi
      into ln_tipcam
      from fsh005 f
     where cofdes in (select max(cofdes)
                       from fsh005 g
                      where g.cofdes <= pd_fecpro 
                        and moneda = 101)
       and moneda = 101;
  exception when no_data_found then
     ln_tipcam := 0;            
  end;


  for i in creditos loop

  
  
       begin
         select distinct jaql964tit, jaql964dia, jaql964usu, to_date(jaql964fdes,'yyyy.mm.dd'), jaql964tcr , jaql964doc, jaql964tid
           into lc_titular, ln_dia, lc_analista, ld_fecdes , ln_tipcre, ln_pendoc, ln_petdoc
           from jaql964 j
          where jaql964cta = i.JAQL982CTA
            and jaql964ope = i.JAQL982OPE
            and jaql964mod = i.jaql982MOD;
--       exception when no_data_found then
       exception when others then
          lc_titular := null;
       end;
       
       --verificando si tuvo traslasdo de cartera
       begin
          select sng130asds
            into lc_analis
            from sng130 s1, sng131 s2, jaqy167 n
           where s2.sng130cor = s1.sng130cor
             and s2.sng131pgc = s1.sng130pgc
             and sng130fape = pd_fecpro 
             --and sng130fape = to_date('30.07.2014', 'dd.mm.yyyy')
             and ((s2.sng131con = 'S' and s2.sng131tmod > 0) or (sng131tmod = 0))
             and s2.sng130cor = n.sng130cor
             and s2.sng131pgc = n.sng131pgc
             and s2.sng131mod = n.sng131mod
             and s2.sng131suc = n.sng131suc
             and s2.sng131mda = n.sng131mda
             and s2.sng131pap = n.sng131pap
             and s2.sng131cta = n.sng131cta
             and s2.sng131ope = n.sng131ope
             and s2.sng131sbo = n.sng131sbo
             and s2.sng131top = n.sng131top
             and n.sng131cta = i.JAQL982CTA
             and n.sng131ope = i.JAQL982OPE;
       exception when others then
           lc_analis := null;       
       end;
     
       if lc_analis is not null then
          lc_analista := lc_analis;
       end if;       
              
        if lc_analista is null then
      
           lc_analista :=  fn_analista_credito(i.JAQL982MOD,i.JAQL982SUC,i.JAQL982MDA,i.JAQL982PAP,i.JAQL982CTA,i.JAQL982OPE,i.JAQL982SBOP,i.JAQL982TOPE) ;
           lc_analista :=  trim(lc_analista);
           

           
            BEGIN
               select d010.aofval
                    into ld_fecdes
                    from fsd010 d010
               where d010.pgcod = 1
                 and d010.aomod = i.JAQL982MOD
                 and d010.aomda = i.JAQL982MDA
                 and d010.aocta = i.JAQL982CTA
                 and d010.aooper = i.JAQL982OPE
                 and d010.aosbop = i.JAQL982SBOP
                 and d010.aotope = i.JAQL982TOPE;
                         
             exception when others then 
                 NULL;
             END;

        end if;  
        
       if ln_tipcre is null or ln_pendoc is null then 
          begin
               select f.pepais, f.petdoc, f.pendoc
                into ln_pais, ln_petdoc, ln_pendoc
                from fsr008 f
               where f.pgcod = 1
                 and f.ctnro = i.JAQL982CTA
                 and f.ttcod = 1
                 and f.cttfir = 'T';
             exception when no_data_found then
                 lc_titular := null;
             end;
          
          
          begin
            ln_tipcre := pq_cr_saldos_linea.fn_cr_tipo_credito_desem(lc_pepais => ln_pais,
                                                                   lc_petdoc => ln_petdoc,
                                                                   lc_pendoc => ln_pendoc,
                                                                   ld_fecref => ld_fecdes);
          end;
          
        end if;   
        if i.JAQL982MOD <> 33 THEN
          ln_dia :=  fn_dias_atraso(pd_fecpro, i.JAQL982PCOD, i.JAQL982MOD, i.JAQL982SUC, i.JAQL982MDA,i.JAQL982PAP, i.JAQL982CTA, i.JAQL982OPE, i.JAQL982SBOP, i.JAQL982TOPE, 0, i.JAQL982FVTO) ;
        END IF;  
        --saldo >15 y saldo >30
        ln_sal15 := 0;
        ln_sal30 := 0;
        if i.JAQL982MOD <> 33 and ln_dia > 15 then
           ln_sal15 := i.jaql982scap;
        end if;
           
        if i.JAQL982MOD <> 33 and ln_dia > 30 then
           ln_sal30 := i.jaql982scap;
        end if;

        --producto sbs
        
        case when i.jaql982gru = 2 then 
                  lc_productosbs:= 'MICROEMPRESAS';
             when i.jaql982gru = 3 and i.jaql982rub = 15 then 
                  lc_productosbs :='CONSUMO REVOLVENTE';
             when i.jaql982gru = 3 and i.jaql982rub <>15 then  
                  lc_productosbs :='CONSUMO NO REVOLVENTE';
             when i.jaql982gru = 4 then  
                  lc_productosbs := 'HIPOTECARIO';
             when i.jaql982gru = 11 then 
                  lc_productosbs := 'GRANDES EMPRESAS';
             when i.jaql982gru = 12 then 
                  lc_productosbs := 'MEDIANA EMPRESA';
             when i.jaql982gru = 13 then 
                  lc_productosbs := 'PEQUEÑA EMPRESA';
             when i.jaql982gru in ( 5,6,7,8,9,10) then 
                  lc_productosbs := 'CORPORATIVO';
             else
                  lc_productosbs := null;
        end case;
        -----
        --actualiza region-zona
         pq_cr_saldos_linea.sp_cr_region_zona(lc_codsuc => i.jaql982suc,
                                       ln_codreg => ln_codreg,
                                       lc_nomreg => lc_nomreg);
                                       
        -------------------RECLASIFICACION---------------------------------------------------------                                       
        pc_flag := pq_cr_SALDOS_LINEA.Fn_TienePago(i.jaql982pcod,i.jaql982cta,i.jaql982ope);
         
             If pc_flag = 'S' then
                pc_vencido  := substr(i.jaql982rubr ,4,1);
                pc_caracter := substr(i.jaql982rubr ,7,2);
                --normal vencido
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru not in (3,4) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scan = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvn = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru in (3,4) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scav = 0,
                          jaql982scvn = 0,
                          jaql982scan = i.jaql982scap
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                if pc_vencido = '5' and pc_caracter = '06' and i.jaql982gru in (3,4) and
                   ln_dia between 30 and 90 then
                   
                   pn_mtovencidoPago := pq_cr_SALDOS_LINEA.fn_Mto_vto(i.jaql982pcod,i.jaql982mod,
                                                                  i.jaql982suc,i.jaql982mda,
                                                                  i.jaql982pap,i.jaql982cta,
                                                                  i.jaql982ope,i.jaql982sbop,
                                                                  i.jaql982tope,pd_fecpro);
                   update jaql982
                      set jaql982scav = pn_mtovencidoPago,
                          jaql982scvn = pn_mtovencidoPago,
                          jaql982scan = i.jaql982scap - pn_mtovencidoPago
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                ---refinanciado vencido
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru not in (3,4) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scar = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvr = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru in (3,4) and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scav = 0,
                          jaql982scvr = 0,
                          jaql982scar = i.jaql982scap
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                if pc_vencido = '5' and pc_caracter = '19' and i.jaql982gru in (3,4) and
                   ln_dia between 30 and 90 then
                   
                   pn_mtovencidoPago := pq_cr_SALDOS_LINEA.fn_Mto_vto(i.jaql982pcod,i.jaql982mod,
                                                                  i.jaql982suc,i.jaql982mda,
                                                                  i.jaql982pap,i.jaql982cta,
                                                                  i.jaql982ope,i.jaql982sbop,
                                                                  i.jaql982tope,pd_fecpro);
                   update jaql982
                      set jaql982scav = pn_mtovencidoPago,
                          jaql982scvr = pn_mtovencidoPago,
                          jaql982scar = i.jaql982scap - pn_mtovencidoPago
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                ------prendario vencido
                if pc_vencido = '5' and pc_caracter = '13' and
                   ln_dia <= 30 then
                   update jaql982
                      set jaql982scan = i.jaql982scav,
                          jaql982scav = 0,
                          jaql982scvp = 0
                    where jaql982suc  = i.jaql982suc
                      and jaql982mda  = i.jaql982mda
                      and jaql982cta  = i.jaql982cta
                      and jaql982ope  = i.jaql982ope
                      and jaql982pcod = i.jaql982pcod
                      and jaql982sbop = i.jaql982sbop
                      and jaql982pap  = i.jaql982pap
                      and jaql982mod  = i.jaql982mod
                      and jaql982tope = i.jaql982tope;
                      commit;
                end if;
                
                  
             End If;
             
   
             --no actualiza proyeccion porque son saldos FSH012
         update jaql982
            set JAQL982ANA = lc_analista,
                JAQL982DIA = ln_dia, 
                JAQL982TIT = lc_titular,
                JAQL982TCR = ln_tipcre,
                JAQL982S15 = ln_sal15,
                JAQL982S30 = ln_sal30,
                JAQL982DOC = ln_pendoc,
                JAQL982TID = ln_petdoc,
                JAQL982SBS = lc_productosbs,
                JAQL982COZ = ln_codreg,
                JAQL982NOZ = lc_nomreg,
                jaql982flg = pc_flag,--
                jaql982scpv = 0,--
                jaql982scp1 = 0 --monto vencido 1 dia
          where JAQL982CTA = i.JAQL982CTA
            and JAQL982OPE = i.JAQL982OPE
            and JAQL982GRU = i.jaql982gru;


          ln_dia := null;
          lc_analista := null;
          lc_titular := null;
          lc_analis := null;
          ln_petdoc := null;
          ln_pendoc := null;
          pc_vencido := null;
          pc_caracter := null;
          pn_mtovencido := 0;
          pn_mtovencido1 := 0;
          
          --commit;    
           ln_conta  := ln_conta + 1;

          
           commit;
  end loop;
  /*commit; */   

 
 end sp_cr_actualiza_HI;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
 
procedure sp_cr_job_carga(pd_fecpro in date) is
-- *****************************************************************
-- Nombre                     :   sp_cr_job_carga
--                            :   2016.04.19 DCASTRO se agrego validacion variable lc_hostname.    
--                            :   2016.06.14 DCASTRO se agrego variable que retorna numero de jobs que deben ejecutarse.
--                            :   2017.06.05 DCASTRO se modifico condicion para ejecucion hasta las 21 horas cuando es fin de mes
--                            :   2017.07.21 CCERPA se modifico condicion para ejecucion hasta las 10 horas cuando sea los ultimos 7
--                                                  dias del mes  , a la vez se acreao una guia de procesos para manejar las horas como las fechas,tambien 
--                                                  se creo latabla jaqz719 para almacenar el match de la fsd016 y fsd015 . 
-- *****************************************************************
  

ln_ini number;
ln_job number:=0;
lc_fecpro char(10);
ln_varjob number:=0;
ln_contador number:= 0;
lc_fechadia varchar2(10);
lc_hostname varchar2(64);
ln_contajob number; --2016.06.14

lc_variable varchar2(100):='PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_bc';
ln_numjob NUMBER;
ld_finmes date;
lc_hora char(2);
lc_hora_inicial NUMBER;
lc_hora_final NUMBER;
lc_hora_inicial_ultimos_dias NUMBER;
lc_hora_final_ultimos_dias NUMBER;
lc_margen_dias_fin_de_mes NUMBER;
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

  --2016.06.14
  begin
    select count(*) 
     into ln_contajob
    from fst198 
    where tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11; 
  end;     
  --2016.06.14

--2017.06.05  
ld_finmes := last_day(trunc(sysdate));
lc_hora := to_char(trunc(sysdate, 'HH24'), 'HH24');


select trim(TP1DESC) into lc_hora_inicial from fst198 f where f.tp1cod=1 and f.tp1cod1=10872  and f.tp1corr1=14  and f.tp1corr2=1; --hora inicial para las fechas menores a 7 dias del fin del mes( hora 07) (posion en guia es (10872,14,1))
select trim(TP1DESC) into lc_hora_final from fst198 f where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=2 ;--hora final para las fechas menores a 7 dias del fin del mes( hora 20) (posion en guia es (10872,14,2))
select trim(TP1DESC) into lc_hora_inicial_ultimos_dias  from fst198 f where f.tp1cod=1  and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=3; --hora inicial para los 7 ultimos dias del mes ( hora 07) (posion en guia es (10872,14,3))
select trim(TP1DESC) into lc_hora_final_ultimos_dias from fst198 f where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=4 ;--hora final para los 7 ultimos dias del mes ( hora 22) (posion en guia es (10872,14,4))
select to_number(trim(TP1DESC),'99') into lc_margen_dias_fin_de_mes from fst198 f where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=5 ;--dias antes del mes en el caso es (7) los 7 ultimos dias del mes (dias 07) (posion en guia es (10872,14,5))


/*
if ( 
   ld_finmes <> pd_fecpro and (lc_hora between '07' and '20') 
  or 
   ld_finmes = pd_fecpro and (lc_hora between '07' and '21')   
   )*/
/*if ( 
   pd_fecpro<(ld_finmes-lc_margen_dias_fin_de_mes)  and (lc_hora between lc_hora_inicial and lc_hora_final) 
  or 
   pd_fecpro>=(ld_finmes-lc_margen_dias_fin_de_mes) and pd_fecpro<=ld_finmes  and (lc_hora between lc_hora_inicial_ultimos_dias and lc_hora_final_ultimos_dias)   
   ) */  
   
--   ld_finmes <> pd_fecpro and (lc_hora between '00' and '23')
--   ld_finmes <> pd_fecpro and (lc_hora between '07' and '20') 
 if ( 
   pd_fecpro<(ld_finmes-lc_margen_dias_fin_de_mes)  and (lc_hora between lc_hora_inicial and lc_hora_final) 
  or 
   pd_fecpro>=(ld_finmes-lc_margen_dias_fin_de_mes) and pd_fecpro<=ld_finmes  and (lc_hora between lc_hora_inicial_ultimos_dias and lc_hora_final_ultimos_dias)   
   )   
     
   
then  --a partir de 7am
--2017.06.05

--if (to_char(trunc(sysdate, 'HH24'), 'HH24') between '07' and '21') then  --a partir de 7am
    /*ccerpa*/
  execute immediate 'truncate table jaqz719';
        
    INSERT INTO jaqz719
    (JAQZ719COD,
     JAQZ719SUC,
     JAQZ719MOD,
     JAQZ719TRAN,
     JAQZ719NREL,
     JAQZ719CTA,
     JAQZ719OPER,
     JAQZ719ORD,
     JAQZ719SBOR)
    /*select f1.pgcod,
           f1.itsuc,
           f1.itmod,
           f1.ittran,
           f1.itnrel,
           f2.ctnro,
           f2.itoper,
           f2.itord,
           f2.itsbor 
           from fsd015 f1 inner join fsd016 f2 
           on f1.pgcod=f2.pgcod 
           and f1.itsuc=f2.itsuc
           and f1.itmod=f2.itmod 
           and f1.ittran=f2.ittran 
           and f1.itnrel=f2.itnrel
           and f1.itcorr<>99*/
           
select /*+ INDEX_JOIN(F1) */ f1.pgcod,
       f1.itsuc,
       f1.itmod,
       f1.ittran,
       f1.itnrel,
       f2.ctnro,
       f2.itoper,
       f2.itord,
       f2.itsbor
  from fsd015 f1
inner join fsd016 f2
    on f1.pgcod = f2.pgcod
   and f1.itsuc = f2.itsuc
   and f1.itmod = f2.itmod
   and f1.ittran = f2.ittran
   and f1.itnrel = f2.itnrel
--   and f1.itcorr <> 99
WHERE f1.itcorr <> 99          
    ;  
  commit;
  
  
 begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--'BANTPROD', 
                                          tabname          => 'JAQZ719',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
  end;  
/*ccerpa*/


   --2016.04.13 verificar si fecha de jobs corresponde a dia anterior
   
   begin
     select to_char(min(jaql983fin),'yyyy.mm.dd')
       into lc_fechadia
       from jaql983 j
      where jaql983cod = 'SLI'
        and jaql983des like 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos%';
   exception when no_Data_found then     
        ln_contador := 0;        
   end; 
   
   if to_Date(lc_fechadia,'yyyy.mm.dd')< pd_fecpro then
   
      --insertar en historico de jobs 2016.06.14
      insert into jaql985(jaql985fec,jaql985cor,jaql985cod,jaql985num,jaql985des,jaql985fin,jaql985ffi,jaql985da1)
      select pd_fecpro,jaql983cor,jaql983cod,jaql983num,jaql983des,jaql983fin,jaql983ffi,jaql983da1
      from jaql983;
      --2016.06.14
   
      execute immediate 'truncate table jaql982';
      execute immediate 'truncate table jaql983'; 
   end if;
   --fin 2016.04.13

   --verificar si existen jobs ejecutandose
   Begin
    select count(*)
       into ln_contador
       from jaql983
      where jaql983cod = 'SLI'
        and jaql983des like 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos%'
        and jaql983ffi is null;
   exception when others then
       ln_contador := 1;           
   end;

   if nvl(ln_contador,0) = 0 then

        --insertar en historico de jobs 2016.06.14
        insert into jaql985(jaql985fec,jaql985cor,jaql985cod,jaql985num,jaql985des,jaql985fin,jaql985ffi,jaql985da1)
        select pd_fecpro,jaql983cor,jaql983cod,jaql983num,jaql983des,jaql983fin,jaql983ffi,jaql983da1
        from jaql983;
        --2016.06.14

        --trunca tabla
        execute immediate 'truncate table jaql982';
        execute immediate 'truncate table jaql983';  


        lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
        
        begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--', /*'BANTPROD',*/
--            DBMS_STATS.gather_table_stats(ownname          =>'BANTPROD', /* 'BANTPROD',*/
                                          tabname          => 'JAQL982',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
          end;
          
 begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--', /*'BANTPROD',*/
--            DBMS_STATS.gather_table_stats(ownname          =>'BANTPROD', /* 'BANTPROD',*/
                                          tabname          => 'JAQL983',
                                          degree           => 1,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
          end;          

         ln_contajob := round(ln_contajob/2,0);
         
       --  for i in sucursal loop    
         for i in region loop
              ln_ini := i.regcod;
              lc_variable := 'begin '||'  PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_bc('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
              ln_job := ln_job +1;
                               
              --if ln_varjob <11 then

              if ln_varjob <  ln_contajob then  --2016.06.14
              
--                  if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--                  if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
                       DBMS_JOB.SUBMIT(job => ln_job, 
                                    what => lc_variable,
                                    next_date => sysdate,
                                    interval => null,
                                    no_parse => false,
--                                    instance => 2,
                                    instance => 1,
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
              else
--                  if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
--                  if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
                     DBMS_JOB.SUBMIT(job => ln_job, 
                                  what => lc_variable,
                                  next_date =>  sysdate+2/(24*60),--sysdate+3/(24*60),
                                  interval => null,
                                  no_parse => false,
--                                  instance => 2,
                                  instance => 1,
                                  force => false
                                  );     
                  else
                     DBMS_JOB.SUBMIT(job => ln_job, 
                                  what => lc_variable,
                                  next_date =>  sysdate+2/(24*60),--sysdate+3/(24*60),
                                  interval => null,
                                  no_parse => false,
                                  force => false
                                  );     
                  end if;  
                  --ln_varjob:= ln_varjob +1;                   
              end if;
              ln_varjob:= ln_varjob +1;
              
              --controlar jobs
              begin
                 select count(*) 
                   into ln_numjob  
                   from jaql983;
              end;
              
              ln_numjob := ln_numjob + 1;
              INSERT INTO JAQL983 (JAQL983COR,JAQL983COD,JAQL983NUM, JAQL983DES, JAQL983FIN)
                VALUES(ln_numjob, 'SLI',ln_ini, 'PQ_CR_SALDOS_LINEA.sp_cr_carga_datos_bc', sysdate);
              COMMIT;

        end loop;          

        COMMIT;
        
    end if;  
      
end if;

end sp_cr_job_carga;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 function fn_Mto_vtoFM (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_monto number(17,2);
ln_pago number(17,2);
ld_fecpxv date;
begin
  begin
    select --/*+ parallel(n,2,1)*/  
           min(n.ppfpag) 
      into ld_fecpxv   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists 
                (select --/*+ parallel(o,2,1)*/  
                        ppmod, ppcta,ppoper, pptope,ppfpag 
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T' 
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  exception 
      when no_data_found then 
         ld_fecpxv := null;
      when too_many_rows then
         ld_fecpxv := null;
  end;   
  
   begin
         select --/*+ parallel(n,2,1)*/  
               sum(n.pp1cap)
          into ln_pago   
          from fsd602 n 
         where n.pgcod  = pn_emp     
           and n.ppcta  = pn_cta     
           and n.ppmda  = pn_mda    
           and n.ppsuc  = pn_suc    
           and n.pppap  = pn_pap    
           and n.ppoper = pn_oper  
           and n.ppsbop = pn_sbop  
           and n.pptope = pn_top  
           and n.ppmod  = pn_mod    
           and n.ppfpag >= ld_fecpxv
           and n.d602co = 'S';
  exception when others then
    ln_pago:=0;
  end;
  
  ln_pago := nvl(ln_pago,0);
  
  begin

           
           
        select --/*+ parallel(n,2,1)*/  
           sum( n.ppcap)
            into ln_monto   
                from fsd601 n 
               where n.pgcod  = pn_emp     
                 and n.ppcta  = pn_cta     
                 and n.ppmda  = pn_mda    
                 and n.ppsuc  = pn_suc    
                 and n.pppap  = pn_pap    
                 and n.ppoper = pn_oper  
                 and n.ppsbop = pn_sbop  
                 and n.pptope = pn_top  
                 and n.ppmod  = pn_mod    
                 and n.ppfpag >= ld_fecpxv 
                 and n.ppfpag < pd_fecpro
                 and last_day(pd_fecpro) - n.ppfpag >= 31  
                 and n.d601co = 'S'
                 and (n.ppcap+n.ppint)<>0;         
           
  exception when others then
    ln_monto:=0;
  end;
  
  ln_monto :=  nvl(ln_monto,0);
   return (ln_monto- ln_pago);
end fn_Mto_vtoFM;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function fn_cr_valida_registro(ld_fecha in date,
                               ln_tipo  in number,   
                               ln_codzon in number,    
                               ln_codreg in number,   
                               ln_codigo in number,   
                               ln_analista in char,   
                               ln_saldoj in number,   
                               ln_saldo in number    
                             )return number is

    -- *****************************************************************
    -- Nombre                     : fn_cr_valida_registro
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2018.03.21
    -- Autor de Creación          : 
    -- Uso                        : Valida que no se duplique registro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

    ln_fila number;


  begin

          begin
            select count(*) into ln_fila
            from jaql968 j 
          where j.JAQL968FEC =  ld_fecha
            and j.JAQL968TIP =  ln_tipo 
            and j.JAQL968COZ =  ln_codzon
            and j.JAQL968REG =  ln_codreg
            and j.JAQL968COD =  ln_codigo
            and j.JAQL968ANA =  ln_analista
            and j.jaql968salj = ln_saldoj
            and j.jaql968sal =  ln_saldo ;          
       exception 
         when no_data_found then 
             ln_fila := 0;    
         when others then    
             ln_fila := 0;             
       end;

  return ln_fila;
  
end fn_cr_valida_registro;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
end PQ_CR_SALDOS_LINEA;
/

