create or replace package PQ_CR_CARGA_JAQN870 is
 
    -- *****************************************************************
    -- Nombre                     : CARGAR DATA REFINANCIACION - JAQN870
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.09.23
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2020.10.28
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego control para creditos cancelados y nueva tabla REFINANCIADOSHISTORICO@CMR
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_VALIDA(
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     v_Scstat in number,
                     v_dias   in number,
                     v_situa  in varchar2,
                     v_fecini in date,
                     v_fecfin in date,
                     v_flag   in varchar2,  ------------- 20211028 dcastro se agrego variable   
                     v_repro  in varchar2 -- 2022.03.16 dcsatro indicador reprogramacion                                      
                     );                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_CARGA(
                       v_fecpro in date
                       ); 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_CARGA_CUENTA(
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_fecha  in date
                     ) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_CARGA_JAQN870;
/

create or replace package body PQ_CR_CARGA_JAQN870 is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_CARGA_JAQN870
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.09.23
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA INFORMACION PARA REFINANCIACION - JAQN870 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 2021.04.21 DCASTRO se agrego script para guia de proceso especial11140,4,3 de DIAS
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_VALIDA(
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     v_Scstat in number,
                     v_dias   in number,
                     v_situa  in varchar2,
                     v_fecini in date,
                     v_fecfin in date,
                     v_flag   in varchar2,
                     v_repro  in varchar2
                     )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_VALIDA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.09.23
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 

ln_tipoexo number;
ln_cantidad number;
ln_estado number;
lc_estado char(1) := 'N';
ld_fecval date;

BEGIN

  begin
    select j.aostat, j.aofval
       into ln_estado, ld_fecval
       from fsd010 j    
      where j.PGCOD = v_Pgcod 
        and j.AOMOD = v_Scmod 
        and j.AOSUC = v_Scsuc 
        and j.AOMDA = v_Scmda 
        and j.AOPAP = v_Scpap 
        and j.AOCTA = v_Sccta 
        and j.AOOPER = v_Scoper
        and j.AOSBOP = v_Scsbop
        and j.AOTOPE = v_Sctope;
  exception when others then
    ln_estado := 99; 
    ld_fecval := null;           
  end;
  
  if  ln_estado <> 99 then--valida si esta cancelado

   --  if ld_fecval <= to_date('29/02/2020','DD/MM/YYYY') then ---valida fecha valor  2020.04.20 dcastro se comento filtro fecha

           --si estado diferente   de 0 y 61 no considerar.
           begin
             select 'S'
               into lc_estado
               from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1 = 11140
                and f.tp1corr1 = 4
                and f.tp1corr2 = 1
                and f.tp1corr3 > 0
                and f.tp1nro1 = ln_estado; --v_Scstat;
           exception when others then
             lc_estado := 'N';
           end;
           
           if lc_estado = 'S' then
                  
              --existe en tabla
                begin
                   select count(*)
                     into ln_cantidad        
                     from jaqn870 j,
                          fst198 k
                    where j.jaqn870emp = v_Pgcod 
                      and j.jaqn870mod = v_Scmod 
                      and j.jaqn870suc = v_Scsuc 
                      and j.jaqn870mda = v_Scmda 
                      and j.jaqn870pap = v_Scpap 
                      and j.jaqn870cta = v_Sccta 
                      and j.jaqn870ope = v_Scoper
                      and j.jaqn870sbo = v_Scsbop
                      and j.jaqn870top = v_Sctope
                      and k.tp1cod = j.jaqn870emp
                      and k.tp1cod1 = 11140 
                      and k.tp1corr1 = 4 
                      and k.tp1corr2 = 2 
                      and k.tp1corr3 > 0
                      and j.jaqn870est = trim(k.tp1desc);  --G-En proceso/ C-Contabilizado
                      
                exception when others then
                  ln_cantidad := 0;
                end;     

              --si NO existe se carga nuevamente
              if ln_cantidad = 0 then
                 --obtener tipo exoneracion
                begin
                 select j.jaqz465tip
                   into ln_tipoexo 
                   from jaqz465 j 
                  where v_dias >= j.jaqz465dini 
                    and v_dias <= j.jaqz465dfin 
                    and j.jaqz465sit = v_situa
                    and j.jaqz465rep = v_repro  -- 2022.03.17 se agrego condicion reprogramacion
                    and j.jaqz465est = 'S';
                exception when others then
                    ln_tipoexo := 0;
                end;    
              
              
                if ln_tipoexo <> 0 then --valida tipo exoneracion
                    --insertar cuentas
                    begin
                      insert into jaqn870
                        (jaqn870emp, 
                         jaqn870mod,
                         jaqn870suc,
                         jaqn870mda,
                         jaqn870pap,
                         jaqn870cta,
                         jaqn870ope,
                         jaqn870sbo,
                         jaqn870top,
                         jaqn870fec,
                         jaqn870est,
                         jaqn870ces,
                         jaqn870fin,
                         jaqn870ffi,
                         jaqn870tip,
                         jaqn870dac,
                         jaqn870sit,
                         jaqn870ac1, --- 20211028 dcastro se agrego nuevo campo flag
                         jaqn870ac2  --- 2022.03.16 dcastro indicador reprogramacion
                         )
                      values
                        (v_Pgcod,
                         v_Scmod,
                         v_Scsuc,
                         v_Scmda,
                         v_Scpap,
                         v_Sccta,
                         v_Scoper,
                         v_Scsbop,
                         v_Sctope,
                         v_fecini, 
                         'I',
                         ln_estado, --v_Scstat,  obtiene estado de FSD010
                         v_fecini,
                         v_fecfin,
                         ln_tipoexo,
                         v_dias,
                         v_situa,
                         v_flag, --- 20211028 dcastro se agrego nuevo campo flag
                         v_repro --- 2022.03.16 dcastro indicador reprogramacion
                         );
                         commit;
                     exception when DUP_VAL_ON_INDEX then
                         null;    
                     end;    
                     
                end if;--valida tipo exoneracion 
                                   
              end if;   

           end if;    ---valida estado       

--    end if;    ---valida fecha valor      2020.04.20 dcastro se comento filtro fecha
   
  end if; -- fin valida cancelados
insert into AQPB876 values (user,sysdate,'PQ_CR_CARGA_JAQN870.SP_CR_VALIDA',
substr(v_Pgcod||'-'||v_Scmod||'-'|| v_Scsuc||'-'||v_Scmda||'-'|| v_Scpap||'-'|| v_Sccta||'-'|| v_Scoper||'-'||
v_Scsbop||'-'||v_Sctope||'-'||v_Scstat||'-'||v_dias||'-'||  v_situa||'-'|| to_char(v_fecini,'RRRR/MM/DD')||'-'||
to_char(v_fecfin,'RRRR/MM/DD')||'-'||v_flag||'-'||v_repro,1,2000));
commit;  
 end SP_CR_VALIDA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_CARGA(
                       v_fecpro in date
                       )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_CARGA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.09.23
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Carga data en JAQN870
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Fecha de Modificación      : 2020.11.19 DCASTRO Se comento condicion de dias de atraso maximo.
    --                              2021.10.28 DCASTRO SE AGREGO FLAG NUEVO CAMPAÑA       
    -- ***************************************************************** 

cursor listado is 
select  
    R.FECHA v_fecha, 
    R.DNICLIENTE v_dni, 
    SUBSTR(R.CUENTAOPERACION,0,INSTR(R.CUENTAOPERACION,'-')-1) V_SCCTA,
    SUBSTR(R.CUENTAOPERACION,INSTR(R.CUENTAOPERACION,'-')+1,99) V_SCOPE,
    R.DIASATRASOFEBRERO V_DIAS, 
    R.CONDICIONNEGOCIO V_SITUA,
    decode( R.MONEDA, 'PEN', 0,'USD',101) V_SCMDA,
    R.EMPRESA V_PGCOD, 
    R.MODULO V_SCMOD, 
    R.SUCURSAL V_SCSUC, 
    R.PAPEL V_SCPAP, 
    R.SUBOPERACION V_SCSBOP, 
    R.TIPOOPERACION V_SCTOP, 
    R.ESTADOCREDITO V_SCSTAT,
    R.FLAG_410  V_FLAG ,------------------------------- > CAMBIAR CAMPO FLAG CREADO POR BI          20211028
    R.FLAG_MEMO90 V_REPRO --- 2022.03.16 dcastro indicador reprogramacion    
--from REFINANCIADOSHISTORICO@CMR R
from REFINANCIADOSHISTORICO R--RFC 
WHERE 
--G.ACEPTAREFINANCIACION = 'S' se comento por solicitud de negocio
R.DIASATRASOFEBRERO >= --16;
--AND R.DIASATRASOFEBRERO <= 90;  2020.11.19 DCASTRO Se comento condicion de dias maximo.
  (select k.tp1nro1
   from fst198 k
  where k.tp1cod = 1
  and k.tp1cod1 = 11140 
  and k.tp1corr1 = 4 
  and k.tp1corr2 = 3
  and k.tp1corr3 > 0);  --2021.04.21 DCASTRO se agrego script para guia de proceso especial11140,4,3 de DIAS


/*
SELECT
  trunc(G.FECHA) V_FECINI,
  SUBSTR(R.CUENTAOPERACION,0,INSTR(R.CUENTAOPERACION,'-')-1) V_SCCTA,
  SUBSTR(R.CUENTAOPERACION,INSTR(R.CUENTAOPERACION,'-')+1,99) V_SCOPE,
  R.DIASATRASOFEBRERO  V_DIAS,
  G.CONDICIONNEGOCIO,
    CASE G.CONDICIONNEGOCIO
    WHEN 'Independiente: Negocio activo en la misma actividad' THEN 'NA'
    WHEN 'Independiente: Negocio activo reorientado a otra actividad' THEN 'NN'
    WHEN 'Independiente: Negocio no activo (por abrir)' THEN 'SN'
    WHEN 'Dependiente: Con el mismo trabajo' THEN 'TA'
    WHEN 'Dependiente: Con ingresos reducidos temporalmente' THEN 'TR'
    WHEN 'Dependiente: Sin trabajo' THEN 'ST'
    WHEN 'Dependiente: Con nuevo trabajo' THEN 'TN'
  END V_SITUA,
  decode( R.MONEDA, 'PEN', 0,'USD',101) V_SCMDA,
  R.EMPRESA V_PGCOD,
  R.MODULO V_SCMOD,
  R.SUCURSAL V_SCSUC,
  R.PAPEL V_SCPAP,
  R.SUBOPERACION V_SCSBOP,
  R.TIPOOPERACION V_SCTOP,
  R.ESTADOCREDITO V_SCSTAT
FROM REFINANCIADOS@CMR R
INNER JOIN REFINANCIADOSGESTION@CMR G ON R.DNICLIENTE = G.DNICLIENTE AND R.CUENTAOPERACION = G.CUENTAOPERACION
WHERE G.DNICLIENTE IS NOT NULL 
--AND G.ACEPTAREFINANCIACION = 'S' se comento por solicitud de negocio
AND R.DIASATRASOFEBRERO >= 16
AND R.DIASATRASOFEBRERO <= 90
AND trunc(G.FECHA)  <= v_fecpro;
*/              



ln_tipoexo number;
ln_cantidad number;

BEGIN
  


---LEER CURSOR DE CRM PARA INSERTAR EN TABLA
   for i in listado loop        
   
       begin
        pq_cr_carga_jaqn870.sp_cr_valida(v_pgcod => i.v_pgcod,
                                         v_scmod => i.v_scmod,
                                         v_scsuc => i.v_scsuc,
                                         v_scmda => i.v_scmda,
                                         v_scpap => i.v_scpap,
                                         v_sccta => to_number(i.v_sccta),
                                         v_scoper => to_number(i.v_scope),
                                         v_scsbop => i.v_scsbop,
                                         v_sctope => i.v_sctop,
                                         v_scstat => i.v_scstat,
                                         v_dias => i.v_dias,
                                         v_situa => i.v_situa,
                                         v_fecini => v_fecpro+1,  --cambio fecha
                                         v_fecfin => v_fecpro+1,
                                         v_flag => i.v_flag,  --- 20211028 dcastro se agrego
                                         v_repro => i.v_repro -- 2022.03.16 dcsatro indicador reprogramacion                                         
                                         );
       end;
   
   end loop;
 
insert into AQPB876 values (user,sysdate,'PQ_CR_CARGA_JAQN870.SP_CR_CARGA',to_char(v_fecpro,'RRRR/MM/DD'));
commit;  

 end SP_CR_CARGA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_CARGA_CUENTA(
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_fecha  in date
                     )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_CARGA_CUENTA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2021.12.07
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 


cursor listado is 
select v_fecha, v_dni, V_SCCTA, V_SCOPE,V_DIAS, V_SITUA, V_SCMDA, V_PGCOD,V_SCMOD, V_SCSUC,V_SCPAP ,V_SCSBOP ,V_SCTOP,V_SCSTAT, V_FLAG
,   v_FMEMO90 v_REPRO --- indicador de reprogramacion 2022.03.16 dcastro
from V_refinanciados v  ---
where v.V_SCCTA = v_Sccta
  and v.V_SCOPE = v_Scoper;

ln_tipoexo number;
ln_cantidad number;
ln_estado number;
lc_estado char(1) := 'N';
ld_fecval date;

ld_FECHA date:= v_fecha; ---COLOCAR FECHA ACTUAL

BEGIN
  
---LEER CURSOR DE VISTA CRM PARA INSERTAR EN TABLA
   for i in listado loop        
   
  begin
    select j.aostat, j.aofval
       into ln_estado, ld_fecval
       from fsd010 j    
      where j.PGCOD = i.v_Pgcod 
        and j.AOMOD = i.v_Scmod 
        and j.AOSUC = i.v_Scsuc 
        and j.AOMDA = i.v_Scmda 
        and j.AOPAP = i.v_Scpap 
        and j.AOCTA = i.v_Sccta 
        and j.AOOPER = i.v_Scope
        and j.AOSBOP = i.v_Scsbop
        and j.AOTOPE = i.v_Sctop;
  exception when others then
    ln_estado := 99; 
    ld_fecval := null;           
  end;
  
  if  ln_estado <> 99 then--valida si esta cancelado

           --si estado diferente   de 0 y 61 no considerar.
           begin
             select 'S'
               into lc_estado
               from fst198 f
              where f.tp1cod = 1
                and f.tp1cod1 = 11140
                and f.tp1corr1 = 4
               and f.tp1corr2 = 1
                and f.tp1corr3 > 0
                and f.tp1nro1 = ln_estado; --v_Scstat;
           exception when others then
             lc_estado := 'N';
           end;
           
           --dbms_output.put_line ('paso lc_estado ' || lc_estado);
           
           if lc_estado = 'S' then
                  
              --existe en tabla
                begin
                   select count(*)
                     into ln_cantidad        
                     from jaqn870 j,
                          fst198 k
                    where j.jaqn870emp = i.v_Pgcod 
                      and j.jaqn870mod = i.v_Scmod 
                      and j.jaqn870suc = i.v_Scsuc 
                      and j.jaqn870mda = i.v_Scmda 
                      and j.jaqn870pap = i.v_Scpap 
                      and j.jaqn870cta = i.v_Sccta 
                      and j.jaqn870ope = i.v_Scope
                      and j.jaqn870sbo = i.v_Scsbop
                      and j.jaqn870top = i.v_Sctop
                      and k.tp1cod = j.jaqn870emp
                      and k.tp1cod1 = 11140 
                      and k.tp1corr1 = 4 
                      and k.tp1corr2 = 2 
                      and k.tp1corr3 > 0
                      and j.jaqn870est = trim(k.tp1desc);  --G-En proceso/ C-Contabilizado
                      
                exception when others then
                  ln_cantidad := 0;
                end;     


               -- dbms_output.put_line ('paso ln_cantidad ' || ln_cantidad);
           
           
              --si NO existe se carga nuevamente
              if ln_cantidad = 0 then
                 --obtener tipo exoneracion
                begin
                 select j.jaqz465tip
                   into ln_tipoexo 
                   from jaqz465 j 
                  where i.v_dias >= j.jaqz465dini 
                    and i.v_dias <= j.jaqz465dfin 
                    and j.jaqz465sit = i.v_situa
                    and j.jaqz465rep = i.v_repro --- 2022.03.16 dcastro indicador de reprogramacion                    
                    and j.jaqz465est = 'S';
                exception when others then
                    ln_tipoexo := 0;
                end;    
              
              
                if ln_tipoexo <> 0 then --valida tipo exoneracion
                    --insertar cuentas
                    begin
                      
                     --dbms_output.put_line ('paso tipoexo' || ln_tipoexo);
                     
                      
                      insert into jaqn870
                        (jaqn870emp, 
                         jaqn870mod,
                         jaqn870suc,
                         jaqn870mda,
                         jaqn870pap,
                         jaqn870cta,
                         jaqn870ope,
                         jaqn870sbo,
                         jaqn870top,
                         jaqn870fec,
                         jaqn870est,
                         jaqn870ces,
                         jaqn870fin,
                         jaqn870ffi,
                         jaqn870tip,
                         jaqn870dac,
                         jaqn870sit,
                         jaqn870ac1,
                         jaqn870ac2  --- 2022.03.16 dcastro indicador reprogramacion                         
                         )
                      values
                        (i.v_Pgcod,
                         i.v_Scmod,
                         i.v_Scsuc,
                         i.v_Scmda,
                         i.v_Scpap,
                         i.v_Sccta,
                         i.v_Scope,
                         i.v_Scsbop,
                         i.v_Sctop,
                         ld_FECHA,--to_date('26/08/2021','DD/MM/YYYY'), 
                         'I',
                         ln_estado, --v_Scstat,  obtiene estado de FSD010
                         ld_FECHA,--to_date('26/08/2021','DD/MM/YYYY'),
                         ld_FECHA,--to_date('26/08/2021','DD/MM/YYYY'),
                         ln_tipoexo,
                         i.v_dias,
                         i.v_situa,
                         i.v_flag,
                         i.v_repro --- 2022.03.16 dcastro indicador reprogramacion                         
                         );
                         commit;
                     exception when DUP_VAL_ON_INDEX then
                         null;    
                     end;    
                     
                end if;--valida tipo exoneracion 
                                   
              end if;   

           end if;    ---valida estado       
   
  end if; -- fin valida cancelados
  
 end loop;
   ---dbms_output.put_line ('error 2 ' || sqlcode || ' ' ||sqlerrm);

insert into AQPB876 values (user,sysdate,'PQ_CR_CARGA_JAQN870.SP_CR_CARGA_CUENTA',
v_Sccta||'-'|| v_Scoper||'-'||to_char(v_fecha,'RRRR/MM/DD'));
commit; 
 end SP_CR_CARGA_CUENTA;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CARGA_JAQN870;
/

