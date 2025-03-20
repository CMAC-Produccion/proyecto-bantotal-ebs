create or replace package PQ_CR_DIASATRASO_COV19 is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_DIASATRASO_COV19 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.04.04
  -- Autor de Creación          : DCASTOR
  -- Uso                        : PARA GENERACION DIAS DE ATRASO POR EMERGENCIA COV19
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2021.04.25
  -- Autor de Modificación      : DCASTRO
  -- Descripción de Modificación: se agrego funcion fn_dias_atraso_cvd19
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_cr_job_actualiza_dia_cov19(P_D_FECPRO in date);
  ----------------------------------------------------------------------------------------
 Procedure sp_cr_actualiza_dias_bulk(P_D_FECPRO in date,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER);
                                          
  ---------------------------------------------------------------------------------------------
Procedure sp_cr_actualiza_dias(P_D_FECPRO in date,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER);

  ----------------------------------------------------------------------------------------
 Procedure sp_cr_jaql114_dias(
                              pn_cta in NUMBER,
                              pn_oper in NUMBER,
                              pn_sbop in NUMBER,                              
                              pn_tope in NUMBER,
                              pn_mod  in NUMBER,
                              pn_dias out number);
  ----------------------------------------------------------------------------------------                              
  
 Procedure sp_cr_dias_cov19(
                              pn_cta in NUMBER,
                              pn_oper in NUMBER,
                              pn_sbop in NUMBER,                              
                              pn_tope in NUMBER,
                              pn_mod  in NUMBER,
                              pn_dias out number);
  ----------------------------------------------------------------------------------------                                                                        

 function fn_cr_diasatraso_mes(
                             v_Pgfape in date, 
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
                             v_fecven in date
                                         )return number;
                                         
 ----------------------------------------------------------------------------------------                                           
FUNCTION FN_DIAS_ATRASO_CVD19( V_PGFAPE IN DATE, --FECHA DE PROCESO
                                                     V_PGCOD  IN NUMBER,
                                                     V_SCMOD  IN NUMBER,
                                                     V_SCSUC  IN NUMBER,
                                                     V_SCMDA  IN NUMBER,
                                                     V_SCPAP  IN NUMBER,
                                                     V_SCCTA  IN NUMBER,
                                                     V_SCOPER IN NUMBER,
                                                     V_SCSBOP IN NUMBER,
                                                     V_SCTOPE IN NUMBER,
                                                     V_SCSTAT IN NUMBER,
                                                     V_FECVEN IN DATE
                                                   )
  RETURN NUMBER ;
 ----------------------------------------------------------------------------------------                                           

end PQ_CR_DIASATRASO_COV19;
/

create or replace package body PQ_CR_DIASATRASO_COV19 is


 ----------------------------------------------------------------------
  procedure sp_cr_job_actualiza_dia_cov19(P_D_FECPRO in date) is
  --2023.11.07 dcastro se comentó proceso de jobs se actualizó el campo jaql964nr4 = 1
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 8000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);
    ln_cov19    number;
  
  begin
  
/*   2023.11.08 se comento
 begin
      select host_name into lc_hostname from v$instance;
    end;
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    
    begin
      select f.tp1nro1
        into ln_cov19
        from fst198 f
       where f.tp1cod1 = 10872
         and f.tp1corr1 = 100
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception when others then
      ln_cov19 := 0;
    end;

    if  ln_cov19 = 1 then --si flag esta habilitado
      
      begin
        select ceil(count(*) / ln_divisor) into ln_contador from jaql964;
      end;
    
      ln_ini := 1;
      ln_fin := 8000;
      WHILE ln_num <= ln_contador LOOP
      
\*        lc_variable := 'begin ' ||
                       '  PQ_CR_DIASATRASO_COV19.sp_cr_actualiza_dias_bulk(' ||
                       'TO_DATE(''' || lc_fecpro || ''',''RRRR.MM.DD'')' || ',' ||
                       ln_ini || ',' || ln_fin || ' );' || ' End;';
  *\                     
        lc_variable := 'begin ' ||
                       '  PQ_CR_DIASATRASO_COV19.sp_cr_actualiza_dias(' ||
                       'TO_DATE(''' || lc_fecpro || ''',''RRRR.MM.DD'')' || ',' ||
                       ln_ini || ',' || ln_fin || ' );' || ' End;';

                       
        ln_job      := ln_job + 1;
        IF SYS.FN_BD_ISRAC='TRUE' THEN
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (60 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 2,
                          force     => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (60 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
      
        ln_ini := ln_fin + 1;
        ln_fin := ln_ini + ln_divisor - 1;
      
        ln_num := ln_num + 1;
        commit;
      END LOOP;
      
    end if;     
*/   
    ---2023.11.08
    update jaql964 j
       set j.jaql964nr4 = 1;
    commit;   
    ---2023.11.08

  end sp_cr_job_actualiza_dia_cov19;
  ----------------------------------------------------------------------------------------
 Procedure sp_cr_actualiza_dias_bulk(P_D_FECPRO in date,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_dias_bulk
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.04
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : 
    -- Descripci¿n de Modificaci¿n: 
    --                              
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in number, P_N_FIN in number) is
      select /*+parallel (j,2,1)*/ 
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       j.jaql964csb,
       j.jaql964cor,
       j.jaql964pap,
       j.jaql964est,
       j.jaql964pgcod
        from jaql964 j /* where j.jaql964cta=159078;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
    TYPE Tp_jaql964mod IS TABLE OF jaql964.jaql964mod%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cta IS TABLE OF jaql964.jaql964cta%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964ope IS TABLE OF jaql964.jaql964ope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964sob IS TABLE OF jaql964.jaql964sob%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964top IS TABLE OF jaql964.jaql964top%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964suc IS TABLE OF jaql964.jaql964suc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964mda IS TABLE OF jaql964.jaql964mda%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964usu IS TABLE OF jaql964.jaql964usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964doc IS TABLE OF jaql964.jaql964doc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964csb IS TABLE OF jaql964.jaql964csb%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cor IS TABLE OF jaql964.jaql964cor%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pap IS TABLE OF jaql964.jaql964pap%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964est IS TABLE OF jaql964.jaql964est%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pgcod IS TABLE OF jaql964.jaql964pgcod%TYPE INDEX BY PLS_INTEGER;    
  
    jaql964mod Tp_jaql964mod;
    jaql964cta Tp_jaql964cta;
    jaql964ope Tp_jaql964ope;
    jaql964sob Tp_jaql964sob;
    jaql964top Tp_jaql964top;
    jaql964suc Tp_jaql964suc;
    jaql964mda Tp_jaql964mda;
    jaql964usu Tp_jaql964usu;
    jaql964doc Tp_jaql964doc;
    jaql964csb Tp_jaql964csb;
    jaql964cor Tp_jaql964cor;
    jaql964pap Tp_jaql964pap;
    jaql964est Tp_jaql964est;
    jaql964pgcod Tp_jaql964pgcod;
  
    ln_corr      number := 0;
     
    
    ln_dias number;
    ld_fvto date;
    
  begin
  
    OPEN cartera(P_N_INI, P_N_FIN);
    LOOP
      FETCH cartera BULK COLLECT
        INTO jaql964cta, jaql964mod, jaql964ope, jaql964sob, jaql964top, jaql964suc, jaql964mda, jaql964usu, jaql964doc, jaql964csb, jaql964cor, jaql964pap, jaql964est, jaql964pgcod;
      IF jaql964cta.COUNT > 0 THEN
        FOR i IN jaql964cta.FIRST .. jaql964cta.LAST LOOP
    
    
          begin
             select f.aofvto
               into ld_fvto
               from fsd010 f
              where f.pgcod = jaql964pgcod(i) 
                and f.aomod = jaql964mod(i)
                and f.aosuc = jaql964suc(i)
                and f.aomda = jaql964mda(i)
                and f.aopap = jaql964pap(i)
                and f.aocta = jaql964cta(i)
                and f.aooper = jaql964ope(i)
                and f.aosbop = jaql964sob(i)
                and f.aotope = jaql964top(i);
          exception when others then
              ld_fvto := null;
          end;
 
          /*
          verificar si tiene menos de 15 dias de atraso no deberia invocar a la funcion de dias de atraso
          */           
        
          begin
            ln_dias := fn_dias_atraso(v_pgfape => P_D_FECPRO,
                                      v_pgcod => jaql964pgcod(i),
                                      v_scmod => jaql964mod(i),
                                      v_scsuc => jaql964suc(i),
                                      v_scmda => jaql964mda(i),
                                      v_scpap => jaql964pap(i),
                                      v_sccta =>  jaql964cta(i),
                                      v_scoper => jaql964ope(i),
                                      v_scsbop => jaql964sob(i),
                                      v_sctope => jaql964top(i),
                                      v_scstat => jaql964est(i),
                                      v_fecven => ld_fvto);
          end;

        
        
          update jaql964 j
             set j.jaql964nr4 = j.jaql964dia,  --dias de atraso por proceso PJAQL969
                 j.jaql964dia = ln_dias 
           where jaql964cor = jaql964cor(i);

          ln_corr   := ln_corr + 1;
          if ln_corr = 10000 then
            commit;
            ln_corr := 0;
          end if;
        
        END LOOP;
      END IF;
      EXIT WHEN cartera%NOTFOUND;
    END LOOP;
    COMMIT;
  
  end sp_cr_actualiza_dias_bulk;

  ---------------------------------------------------------------------------------------------
Procedure sp_cr_actualiza_dias(P_D_FECPRO in date,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_dias_bulk
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.04
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2020.04.25
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: se cambio campo de dias de atraso por jaql964nr4  fn_dias_atraso_cvd19
    --                              
    -- ***************************************************************** 
  
    cursor cartera is
      select /*+parallel (j,2,1)*/ 
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       j.jaql964csb,
       j.jaql964cor,
       j.jaql964pap,
       j.jaql964est,
       j.jaql964pgcod
        from jaql964 j /* where j.jaql964cta=159078;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
  
    ln_corr      number := 0;
     
    
    ln_dias number;
    ld_fvto date;
    
  begin
  
  for i in cartera loop    
    
          begin
             select f.aofvto
               into ld_fvto
               from fsd010 f
              where f.pgcod = i.jaql964pgcod 
                and f.aomod = i.jaql964mod
                and f.aosuc = i.jaql964suc
                and f.aomda = i.jaql964mda
                and f.aopap = i.jaql964pap
                and f.aocta = i.jaql964cta
                and f.aooper = i.jaql964ope
                and f.aosbop = i.jaql964sob
                and f.aotope = i.jaql964top;
          exception when others then
              ld_fvto := null;
          end;
            
        /*  2021.04.25 dcastro
          begin
            ln_dias := fn_dias_atraso(v_pgfape => P_D_FECPRO,
                                      v_pgcod => i.jaql964pgcod,
                                      v_scmod => i.jaql964mod,
                                      v_scsuc => i.jaql964suc,
                                      v_scmda => i.jaql964mda,
                                      v_scpap => i.jaql964pap,
                                      v_sccta =>  i.jaql964cta,
                                      v_scoper => i.jaql964ope,
                                      v_scsbop => i.jaql964sob,
                                      v_sctope => i.jaql964top,
                                      v_scstat => i.jaql964est,
                                      v_fecven => ld_fvto);
          end;
                                     */ 
          begin
             ln_dias :=  pq_cr_diasatraso_cov19.fn_dias_atraso_cvd19(v_pgfape => P_D_FECPRO,
                                                  v_pgcod => i.jaql964pgcod,
                                                  v_scmod => i.jaql964mod,
                                                  v_scsuc => i.jaql964suc,
                                                  v_scmda => i.jaql964mda,
                                                  v_scpap => i.jaql964pap,
                                                  v_sccta =>  i.jaql964cta,
                                                  v_scoper => i.jaql964ope,
                                                  v_scsbop => i.jaql964sob,
                                                  v_sctope => i.jaql964top,
                                                  v_scstat => i.jaql964est,
                                                  v_fecven => ld_fvto);
          end;

        
        
          update jaql964 j
             set j.jaql964nr4 = ln_dias,  --2020.04.17
                 j.jaql964po4 = 99 -- indicador covid
           where j.jaql964cor = i.jaql964cor;

          ln_corr   := ln_corr + 1;
          /*if ln_corr = 5000 then
            commit;
            ln_corr := 0;
          end if;
          */
          commit;
        END LOOP;

      

    COMMIT;
  
  end sp_cr_actualiza_dias;
  

  ----------------------------------------------------------------------------------------
 Procedure sp_cr_jaql114_dias(
                              pn_cta in NUMBER,
                              pn_oper in NUMBER,
                              pn_sbop in NUMBER,                              
                              pn_tope in NUMBER,
                              pn_mod  in NUMBER,
                              pn_dias out number) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_jaql114_dias
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.04
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna dias de atraso de JAQL114
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2020.04.13
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se cambio tabla JAQL114 por AQPB003
    --                              
    -- ***************************************************************** 
  Begin

     BEGIN
/*      SELECT NVL(X.JAQL114DATR,-1) 
      INTO pn_dias
     FROM JAQL114 X
      WHERE X.JAQL114CTA  = pn_cta
        AND X.JAQL114OPER = pn_oper
        AND X.JAQL114SBOP = pn_sbop
        AND X.JAQL114TOP =  pn_tope
        AND X.JAQL114MOD =  pn_mod
        AND X.JAQL114FECH = TO_DATE('20200229','YYYYMMDD')
        and rownum = 1;*/
     SELECT NVL(X.AQPB003DATR,-1) 
       INTO pn_dias
       FROM AQPB003 X
      WHERE X.AQPB003HCTA = pn_cta
        AND X.AQPB003HOPER = pn_oper
        AND X.AQPB003HSUBOP = pn_sbop
        AND X.AQPB003HTOPER = pn_tope
        AND X.AQPB003HMODUL = pn_mod
        AND X.AQPB003FECH = TO_DATE('20200229','YYYYMMDD')
        and rownum = 1;

    EXCEPTION
      WHEN OTHERS THEN
        pn_dias := -1;
    END;


end sp_cr_jaql114_dias;
  ----------------------------------------------------------------------------------------
 Procedure sp_cr_dias_cov19(
                              pn_cta in NUMBER,
                              pn_oper in NUMBER,
                              pn_sbop in NUMBER,                              
                              pn_tope in NUMBER,
                              pn_mod  in NUMBER,
                              pn_dias out number) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_dias_cov19
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.04
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna dias de atraso de JAQL114
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2020.04.13
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se cambio tabla JAQL114 por AQPB003
    --                              
    -- ***************************************************************** 

    --2020.04.04 Dcastro Modificacion por emergencia covid19
    ATR_FEB number;
    LN_DIATR_CNGLD number;
    ln_cov19 number;
    ln_cant number;
    --
  Begin
  
  pn_dias := -1;

  begin
    select f.tp1nro1
      into ln_cov19
      from fst198 f
     where f.tp1cod = 1
       and f.tp1cod1 = 10872
       and f.tp1corr1 = 100
       and f.tp1corr2 = 1
       and f.tp1corr3 = 1;
  exception when others then
    ln_cov19 := 0;
  end;

  if  ln_cov19 = 1 then --si flag esta habilitado
    
    IF  pn_mod = 33 then  -- si es castigo
       ATR_FEB := -1;
    ELSE
      
        BEGIN
          /*SELECT NVL(X.JAQL114DATR,-1) 
          INTO ATR_FEB
         FROM JAQL114 X
          WHERE X.JAQL114CTA = pn_cta
            AND X.JAQL114OPER = pn_oper
            AND X.JAQL114SBOP = pn_sbop
            AND X.JAQL114TOP = pn_tope
            AND X.JAQL114MOD = pn_mod
            AND X.JAQL114FECH = TO_DATE('20200229','YYYYMMDD')
            and rownum = 1;*/
            
         SELECT NVL(X.AQPB003DATR,-1) 
           INTO ATR_FEB
           FROM AQPB003 X
          WHERE X.AQPB003HCTA = pn_cta
            AND X.AQPB003HOPER = pn_oper
            /* 07/04/2021 dcastro se comento
            AND X.AQPB003HSUBOP = pn_sbop
            AND X.AQPB003HTOPER = pn_tope
            AND X.AQPB003HMODUL = pn_mod
            */
            AND X.AQPB003FECH = TO_DATE('20200229','YYYYMMDD')
            and rownum = 1;
             
        EXCEPTION
          WHEN OTHERS THEN
            ATR_FEB := -1;
        END;
          
        IF(ATR_FEB > 15) THEN 
        /* se comento a solicitud de BI 2020.04.04
          BEGIN   
            SELECT MAX(F.RI105AUX2) 
            INTO LN_DIATR_CNGLD 
            FROM FRI105 F 
            WHERE F.RI105CTA = pn_cta 
              AND F.RI105OPER = pn_oper
              AND F.RI105SBOP = pn_sbop
              AND F.RI105TOPE = pn_tope
              AND F.RI105MOD  = pn_mod;
            EXCEPTION
          WHEN OTHERS THEN
            LN_DIATR_CNGLD := -1;    
          END; 
          
        */
        
          --valida si credito fue reprogramado
         begin 
           select count(*) 
             into ln_cant
             from aqpb090 a 
            where a.aqpb090cta = pn_cta
             and a.aqpb090oper = pn_oper
             and a.aqpb090ext = 'NO';
         exception when others then
           ln_cant := 0;
         end;            
          
         if ln_cant = 0 then --no fue reprogramado
             LN_DIATR_CNGLD := ATR_FEB;
         else
             LN_DIATR_CNGLD := -1;
         end if;
       
      ELSE
           LN_DIATR_CNGLD := -1;
        
      END IF;
    
    END IF; --fin castigos
    
    pn_dias := LN_DIATR_CNGLD;    
      
  end if;


end sp_cr_dias_cov19;
-----------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------
 function fn_cr_diasatraso_mes(
                             v_Pgfape in date, --fecha de proceso
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
                             v_fecven in date
                                         ) return number is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_dias_cov19
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.04
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna dias de atraso de JAQL114
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2020.04.13
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se cambio tabla JAQL114 por AQPB003
    --                              
    -- ***************************************************************** 


    LN_DIATR_CNGLD number;
    LN_DIATR number;
    ATR_FEB number;
    --
  Begin
  

  begin
    LN_DIATR := fn_dias_atraso(v_pgfape,
                              v_pgcod,
                              v_scmod,
                              v_scsuc,
                              v_scmda,
                              v_scpap,
                              v_sccta,
                              v_scoper,
                              v_scsbop,
                              v_sctope,
                              v_scstat,
                              v_fecven);
  end;

  ---no validamos guia proceso      similar a sp_cr_dias_cov19
  BEGIN
   SELECT NVL(X.AQPB003DATR,-1) 
     INTO ATR_FEB
     FROM AQPB003 X
    WHERE X.AQPB003HCTA = v_sccta
      AND X.AQPB003HOPER = v_scoper
      AND X.AQPB003HSUBOP = v_scsbop
      AND X.AQPB003HTOPER = v_sctope
      AND X.AQPB003HMODUL = v_scmod
      AND X.AQPB003FECH = TO_DATE('20200229','YYYYMMDD')
      and rownum = 1;
  EXCEPTION
    WHEN OTHERS THEN
      ATR_FEB := -1;
  END;
  
  IF  v_scmod = 33 then  -- si es castigo
     ATR_FEB := -1;
  ELSE
      
    IF(ATR_FEB > 15) THEN 
       LN_DIATR_CNGLD := ATR_FEB;
    ELSE
       LN_DIATR_CNGLD := -1;
    END IF;
    ---no validamos guia proceso
        
    IF(LN_DIATR_CNGLD < LN_DIATR) and LN_DIATR_CNGLD <> -1  THEN
          LN_DIATR := LN_DIATR_CNGLD;
    END IF;  
  
  END IF;  --fin castigo
  
  return LN_DIATR;

end fn_cr_diasatraso_mes;
-----------------------------------------------------------------------------------

FUNCTION FN_DIAS_ATRASO_CVD19( V_PGFAPE IN DATE, --FECHA DE PROCESO
                                                     V_PGCOD  IN NUMBER,
                                                     V_SCMOD  IN NUMBER,
                                                     V_SCSUC  IN NUMBER,
                                                     V_SCMDA  IN NUMBER,
                                                     V_SCPAP  IN NUMBER,
                                                     V_SCCTA  IN NUMBER,
                                                     V_SCOPER IN NUMBER,
                                                     V_SCSBOP IN NUMBER,
                                                     V_SCTOPE IN NUMBER,
                                                     V_SCSTAT IN NUMBER,
                                                     V_FECVEN IN DATE
                                                   )
  RETURN NUMBER 
  IS
    LN_DIATR NUMBER;
    ATR_FEB NUMBER;
    LN_DIATR_FINAL NUMBER;    
    DIAS_1SEP NUMBER;
    AL_DIA NUMBER;
    FECVAL DATE;
  BEGIN
    
    BEGIN
      SELECT A.AQPB261HDIA
      INTO LN_DIATR
      FROM AQPB261H A
      WHERE A.AQPB261HFEC = V_PGFAPE
        AND A.AQPB261HCTA = V_SCCTA
        AND A.AQPB261HOPE = V_SCOPER;
      RETURN LN_DIATR;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
  
    --IF V_SCSTAT IN (64,90) THEN
    IF V_SCMOD IN (200,33,141) THEN   --SE AGREGO CARTA FIANZA

       LN_DIATR := V_PGFAPE - V_FECVEN;

       IF LN_DIATR < 0 THEN
          LN_DIATR := 0 ;
       END IF;

    ELSE
        BEGIN
          --VIGENTE Y REFINANCIADO
          SELECT (V_PGFAPE - MIN(A.PPFPAG))
            INTO LN_DIATR
            FROM FSD601 A
            LEFT JOIN FSD602 B ON B.PGCOD = A.PGCOD
                              AND B.PPMOD = A.PPMOD
                              AND B.PPSUC = A.PPSUC
                              AND B.PPMDA = A.PPMDA
                              AND B.PPPAP = A.PPPAP
                              AND B.PPCTA = A.PPCTA
                              AND B.PPOPER = A.PPOPER
                              AND B.PPSBOP = A.PPSBOP
                              AND B.PPTOPE = A.PPTOPE
                              AND B.PPFPAG = A.PPFPAG
                              AND B.PPTIPO = A.PPTIPO
                              AND B.PP1STAT = 'T'
                              AND B.D602CO = 'S'
                                 --AND B.PPTIPO  <> 'K'
                              AND B.PP1FECH <= V_PGFAPE
           WHERE A.PGCOD = V_PGCOD
             AND A.PPMOD = V_SCMOD
             AND A.PPSUC = V_SCSUC
             AND A.PPMDA = V_SCMDA
             AND A.PPPAP = V_SCPAP
             AND A.PPCTA = V_SCCTA
             AND A.PPOPER = V_SCOPER
             AND A.PPSBOP = V_SCSBOP
             AND A.PPTOPE = V_SCTOPE
             AND A.PPFPAG <= V_PGFAPE
             AND A.D601CO = 'S'
             AND (A.PPCAP + A.PPINT) > 0 --SE AGREGO POR CUOTAS DE GRACIA 2013.09.06
             AND B.D602CO IS NULL;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN

            BEGIN
              SELECT (V_PGFAPE - MIN(D.PPFPAG))
                INTO LN_DIATR
                FROM FSD601 D
               WHERE D.PGCOD = V_PGCOD
                 AND D.PPMOD = V_SCMOD
                 AND D.PPSUC = V_SCSUC
                 AND D.PPMDA = V_SCMDA
                 AND D.PPPAP = V_SCPAP
                 AND D.PPCTA = V_SCCTA
                 AND D.PPOPER = V_SCOPER
                 AND D.PPSBOP = V_SCSBOP
                 AND D.PPTOPE = V_SCTOPE
                 AND D.PPFPAG <= V_PGFAPE
                 AND (D.PPCAP + D.PPINT) > 0;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     LN_DIATR := NULL;
            END;

            --END;
        END;
    END IF;

  BEGIN
      SELECT NVL(X.JAQL114FDATR,-1)
      INTO ATR_FEB
      FROM JAQL114F X
      WHERE X.JAQL114FCTA = V_SCCTA
        AND X.JAQL114FOPER = V_SCOPER
        AND X.JAQL114FSBOP = V_SCSBOP
        AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        ATR_FEB := -1;
    END;

    SELECT COUNT(9)
    INTO AL_DIA
    FROM AQPB261H A
    WHERE A.AQPB261HOPE = V_SCCTA
      AND A.AQPB261HOPE = V_SCOPER
      AND (A.AQPB261HFEC = LAST_DAY(A.AQPB261HFEC) OR A.AQPB261HFEC = (SELECT MAX(C.AQPB261HFEC) FROM AQPB261H C) )
      AND A.AQPB261HDIA = 0;

    LN_DIATR := NVL(LN_DIATR,0);
    LN_DIATR_FINAL := LN_DIATR;

    IF(ATR_FEB > 15 AND AL_DIA = 0) THEN
      DIAS_1SEP := V_PGFAPE - TO_DATE('20200901','YYYYMMDD') + 1;
      IF(LN_DIATR < ATR_FEB + DIAS_1SEP) THEN
        LN_DIATR_FINAL := LN_DIATR;
      ELSE
        LN_DIATR_FINAL := ATR_FEB + DIAS_1SEP;
      END IF;
    END IF;

    RETURN(NVL(LN_DIATR_FINAL, 0));
  
END;

------------------------------------------------------------------------------------

end PQ_CR_DIASATRASO_COV19;
/

