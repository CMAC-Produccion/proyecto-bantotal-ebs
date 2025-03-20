create or replace package PQ_CR_SEGMENTACION_PYME is

-- *****************************************************************
    -- Nombre                     : paquete para calcular variables de segmentacion mype
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : paquete de rutinas para la segmentacion pyme - mejora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 16/06/2022 YYAMPI se agrego el procedimiento sp_cr_rcc_sow2
    -- *****************************************************************
  procedure sp_cr_rcc_inactivo(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pv_result out char);
                                
   procedure sp_cr_rcc_sow(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pn_result out number) ;                             
                      
  Procedure Sp_cr_variables(pn_pai   in number,
                            pn_tdo   in number,
                            pc_ndo   in char,
                            pc_var30 out char,
                            pc_var31 out char,
                            pc_var32 out char,
                            pc_var33 out char,
                            pc_var34 out char,
                            pc_var35 out char,
                            pc_var36 out char,
                            pc_var37 out char,
                            pc_var38 out char,
                            pc_var39 out char,
                            pc_var40 out char,
                            pc_var41 out char);
 
  procedure sp_cr_rcc_sow2(
                          pn_pgpais number,
                          pn_tipdoc number,
                          pv_numdoc char,
                          pn_instancia number,
                          pd_fecha date,
                          pn_result out number);                            

end PQ_CR_SEGMENTACION_PYME;
/

create or replace package body PQ_CR_SEGMENTACION_PYME is

  procedure sp_cr_rcc_inactivo(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pv_result out char) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_rcc_inactivo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna Indicador del inactivo RCC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    pn_result number; 
    
begin
  pn_result := 0.00; 
  pv_result := 'S';
  
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end; 
      
        
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = pn_pgpais
              and t.petdoc = pn_tipdoc
              and t.pendoc = pv_numdoc;
      exception when others then 
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  pn_tipdoc; 
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                 
      end;
      
      /*Obtencion del codigo SBS*/
      begin 
        if ln_petipo = 'F' then           
          select c.c_codsbs into lv_codSBS
          from CLDRCCI c
          Where D_FECPRE = ld_fecrcc
                and C_TDOCID = ln_tipdocSBS
                and C_DOCIDE = pv_numdoc;
        else   
          if ln_petipo = 'J' then
            select c.c_codsbs into lv_codSBS
            from CLDRCCI c
             Where D_FECPRE = ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc ;
           else      
               lv_codSBS := null;
          end if ;
        end if ;  
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
       
      
  
  /*Calculo de inactivo rcc*/
  
        begin  
            select sum(c.n_salcap) INACTIVO into pn_result  
             FROM CLDRCCS C
                    WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                      AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
                      --AND C.C_CODEMP='00104' --codigo de Caja Arequipa
                      AND C.C_CRETIP NOT IN ('13') --EXCLUYE HIPOTECARIOS 
                      AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3','4', '5', '6'))--CREDITOS DIRECTOS
                           OR
                           (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                           OR
                           (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS
                           OR
                           (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                           ); 
                   
                   if pn_result > 0 then
                     pv_result := 'N';
                   end if ;  
                          
                                       
         exception when others then 
                   pn_result :=0;
                   pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     pv_result :='S'; 
  
end sp_cr_rcc_inactivo;

--------------------------------------------------------------------------

procedure sp_cr_rcc_sow(
                          pn_pgpais number,
                          pn_tipdoc number,
                          pv_numdoc char,
                          pn_result out number) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_rcc_sow
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna Indicador del SOW
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    
begin
  pn_result := 0.00; 
  
  
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end; 
      
        
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = pn_pgpais
              and t.petdoc = pn_tipdoc
              and t.pendoc = pv_numdoc;
      exception when others then 
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  pn_tipdoc; 
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                 
      end;
      
      /*Obtencion del codigo SBS*/
      begin 
        if ln_petipo = 'F' then           
          select c.c_codsbs into lv_codSBS
          from CLDRCCI c
          Where D_FECPRE = ld_fecrcc
                and C_TDOCID = ln_tipdocSBS
                and C_DOCIDE = pv_numdoc;
        else   
          if ln_petipo = 'J' then
            select c.c_codsbs into lv_codSBS
            from CLDRCCI c
             Where D_FECPRE = ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc ;
           else      
               lv_codSBS := null;
          end if ;
        end if ;  
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
      
      
      
  
  /*Calculo de ratio de SOW*/
  select 
      nvl(ROUND(
      (
      select sum(c.n_salcap)  
       FROM CLDRCCS C
              WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
                AND C.C_CODEMP='00104'
                AND C.C_CRETIP NOT IN ('13') --EXCLUYE HIPOTECARIOS 
                AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3','4', '5', '6'))--CREDITOS DIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                     )
                     )
                     /
                     (
      select sum(c.n_salcap)  
       FROM CLDRCCS C
              WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
               -- AND C.C_CODEMP='00104'
                AND C.C_CRETIP NOT IN ('13') --EXCLUYE HIPOTECARIOS 
                AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3','4', '5', '6'))--CREDITOS DIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                     )
                     )*100 ,2),0)  SOW 
                     into pn_result
       from dual;   
       
       
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_cr_rcc_sow;

---------------------------------------------------------------------------------------------


  Procedure Sp_cr_variables(pn_pai   in number,
                            pn_tdo   in number,
                            pc_ndo   in char,
                            pc_var30 out char,
                            pc_var31 out char,
                            pc_var32 out char,
                            pc_var33 out char,
                            pc_var34 out char,
                            pc_var35 out char,
                            pc_var36 out char,
                            pc_var37 out char,
                            pc_var38 out char,
                            pc_var39 out char,
                            pc_var40 out char,
                            pc_var41 out char) is
                            
-- *****************************************************************
    -- Nombre                     : Sp_cr_variables
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/09/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna variables de permanencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
                         
    ln_meses_eva number(18,0) :=0;
    ln_meses_cal number(18,0) :=0;
    
    pn_var30 number(18) := 0;
    pn_var31 number(18) := 0;
    pn_var32 number(18) := 0;
    pn_var33 number(18) := 0;
    pn_var34 number(18) := 0;
    pn_var35 number(18) := 0;
    pn_var36 number(18) := 0;
    pn_var37 number(18) := 0;
    pn_var38 number(18) := 0;
    pn_var39 number(18) := 0;
    pn_var40 number(18) := 0;
    pn_var41 number(18) := 0;
        
  begin
    pc_var30 := 'N';
    pc_var31 := 'N';
    pc_var32 := 'N';
    pc_var33 := 'N';
    pc_var34 := 'N';
    pc_var35 := 'N';
    pc_var36 := 'N';
    pc_var37 := 'N';
    pc_var38 := 'N';
    pc_var39 := 'N';
    pc_var40 := 'N';
    pc_var41 := 'N';
    
       
    /*numero de meses de calificacion*/
    begin 
      select t.tp1nro1 into ln_meses_cal
         from fst198 t
        where t.tp1cod = 1
          and t.tp1cod1 = 11149
          and t.tp1corr1 = 1;
    exception when  others then 
              ln_meses_eva := -1;
      end;
      
     /*numero de meses de evaluacion */
    begin 
      select t.tp1nro1 into ln_meses_eva
         from fst198 t
        where t.tp1cod = 1
          and t.tp1cod1 = 11149
          and t.tp1corr1 = 2;
    exception when  others then 
              ln_meses_eva := -1;
      end;
     

    
      
   begin 
      
    select /*+ all_rows */ 
              --t.jaqy066paic, t.jaqy066tdoc, t.jaqy066tndoc, 
              sum(case when t.jaqy066calf = 30 then 1 else 0 end ) var30, 
              sum(case when t.jaqy066calf = 31 then 1 else 0 end ) var31, 
              sum(case when t.jaqy066calf = 32 then 1 else 0 end ) var32, 
              sum(case when t.jaqy066calf = 33 then 1 else 0 end ) var33, 
              sum(case when t.jaqy066calf = 34 then 1 else 0 end ) var34, 
              sum(case when t.jaqy066calf = 35 then 1 else 0 end ) var35, 
              sum(case when t.jaqy066calf = 36 then 1 else 0 end ) var36, 
              sum(case when t.jaqy066calf = 37 then 1 else 0 end ) var37, 
              sum(case when t.jaqy066calf = 38 then 1 else 0 end ) var38, 
              sum(case when t.jaqy066calf = 39 then 1 else 0 end ) var39, 
              sum(case when t.jaqy066calf = 40 then 1 else 0 end ) var40, 
              sum(case when t.jaqy066calf = 41 then 1 else 0 end ) var41--, 
           --   sum(case when t.jaqy066calf = 42 then 1 else 0 end ) var42,
           --   sum(case when t.jaqy066calf = 43 then 1 else 0 end ) var43,
           --   sum(case when t.jaqy066calf = 44 then 1 else 0 end ) var44 
          into          
              pn_var30,
              pn_var31,
              pn_var32,
              pn_var33,
              pn_var34,
              pn_var35,
              pn_var36,
              pn_var37,
              pn_var38,
              pn_var39,
              pn_var40,
              pn_var41           
      from jaqy066 t , jaqy067 c 
      where t.jaqy066calf = c.jaqy067ccal 
          and c.jaqy067ccal >= 30
          and t.jaqy066fecp >= add_months(t.jaqy066fecp,-1*ln_meses_eva) 
          and t.jaqy066paic = pn_pai
          and t.jaqy066tdoc = pn_tdo
          and t.jaqy066tndoc = pc_ndo
       group by t.jaqy066paic, t.jaqy066tdoc, t.jaqy066tndoc ;
       
     exception when others then 
         null;
     end;    
    
      /*verificamos el valor segun la guia de proceso*/
      if pn_var30 >= ln_meses_cal then pc_var30 := 'S'; end if;
      if pn_var31 >= ln_meses_cal then pc_var31 := 'S'; end if;
      if pn_var32 >= ln_meses_cal then pc_var32 := 'S'; end if;
      if pn_var33 >= ln_meses_cal then pc_var33 := 'S'; end if;
      if pn_var34 >= ln_meses_cal then pc_var34 := 'S'; end if;
      if pn_var35 >= ln_meses_cal then pc_var35 := 'S'; end if;
      if pn_var36 >= ln_meses_cal then pc_var36 := 'S'; end if;
      if pn_var37 >= ln_meses_cal then pc_var37 := 'S'; end if;
      if pn_var38 >= ln_meses_cal then pc_var38 := 'S'; end if;
      if pn_var39 >= ln_meses_cal then pc_var39 := 'S'; end if;
      if pn_var40 >= ln_meses_cal then pc_var40 := 'S'; end if;
      if pn_var41 >= ln_meses_cal then pc_var41 := 'S'; end if;
               
       
  end Sp_cr_variables;
-------------------------------------------------------------------------------------------------
 
procedure sp_cr_rcc_sow2(
                          pn_pgpais number,
                          pn_tipdoc number,
                          pv_numdoc char,
                          pn_instancia number,
                          pd_fecha date,
                          pn_result out number) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_caja_sow2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/06/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna Indicador sow incluyendo al calculo la deuda total de cartera Caja Bantotal 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_montovuelo number(16,2) := 0; --monto de vuelo
    ln_tipcam number(14,8) :=0; --tipo de cambio del dia
    ln_montoCanc number(16,2) :=0;
    ln_montoTotal number(16,2) :=0;
    ln_montoNeto number(16,2) :=0;
    ln_deudaRccCMAC number(16,2):=0;
    ln_deudaRcc number(16,2):=0;
    ln_deudaCMAC number(16,2):=0;
    ln_deudaCMACFinal number(16,2) :=0;
    ln_deudaRccSinCmac number(16,2) :=0;
    ln_deudaRccFinal number(16,2) :=0;
    
 begin
  pn_result := 0.00; 
  
  
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end; 
      
        
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = pn_pgpais
              and t.petdoc = pn_tipdoc
              and t.pendoc = pv_numdoc;
      exception when others then 
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  pn_tipdoc; 
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                 
      end;
      
      /*Obtencion del codigo SBS*/
      begin 
        if ln_petipo = 'F' then           
          select c.c_codsbs into lv_codSBS
          from CLDRCCI c
          Where D_FECPRE = ld_fecrcc
                and C_TDOCID = ln_tipdocSBS
                and C_DOCIDE = pv_numdoc;
        else   
          if ln_petipo = 'J' then
            select c.c_codsbs into lv_codSBS
            from CLDRCCI c
             Where D_FECPRE = ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc ;
           else      
               lv_codSBS := null;
          end if ;
        end if ;  
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
      
      /*Se obtiene deuda RCC de Caja Arequipa*/
      begin 
        
        select nvl(sum(nvl(c.n_salcap,0)),0) into ln_deudaRccCMAC
          FROM CLDRCCS C
         WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
           AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
           AND C.C_CODEMP = '00104'
           AND NOT EXISTS (select 1 from fst198 t where t.tp1cod = 1 and t.tp1cod1 = 11149 and t.tp1corr1 = 7 and t.tp1corr2 = 1 and t.tp1nro1 = C.C_CRETIP ) --IN ('13') --EXCLUYE HIPOTECARIOS 
           AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
               SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
               OR (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND
               SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
               OR (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND
               SUBSTR(C.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
               OR (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND
               SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
               );
      
      exception when others then 
        ln_deudaRccCMAC :=0;
      end;
      
      /*Se obtiene deuda del todo el RCC del sistema financiero*/
      begin 
            select nvl(sum(nvl(c.n_salcap,0)),0) into ln_deudaRcc
              FROM CLDRCCS C
             WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
               AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
                  -- AND C.C_CODEMP='00104'
               --AND C.C_CRETIP NOT IN ('13') --EXCLUYE HIPOTECARIOS 
               AND NOT EXISTS (select 1 from fst198 t where t.tp1cod = 1 and t.tp1cod1 = 11149 and t.tp1corr1 = 7 and t.tp1corr2 = 1 and t.tp1nro1 = C.C_CRETIP ) --IN ('13')--EXCLUYE HIPOTECARIOS          
               AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                   SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND
                   SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND
                   SUBSTR(C.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND
                   SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                   );
      exception when others then 
        ln_deudaRcc :=0;
      end;
      
      /*deuda RCC sin caja */
      begin 
            select nvl(sum(nvl(c.n_salcap,0)),0) into ln_deudaRccSinCmac
              FROM CLDRCCS C
             WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
               AND C.D_FECPRE = ld_fecrcc --to_date('2021.07.31','rrrr.mm.dd') --TO_DATE('&YYYYMMDD','YYYYMMDD')
                   AND C.C_CODEMP <> '00104'
               --AND C.C_CRETIP NOT IN ('13') --EXCLUYE HIPOTECARIOS 
               AND NOT EXISTS (select 1 from fst198 t where t.tp1cod = 1 and t.tp1cod1 = 11149 and t.tp1corr1 = 7 and t.tp1corr2 = 1 and t.tp1nro1 = C.C_CRETIP ) --IN ('13')--EXCLUYE HIPOTECARIOS          
               AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                   SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND
                   SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND
                   SUBSTR(C.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
                   OR (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND
                   SUBSTR(C.C_CUENTA, 4, 1) = '5') ----LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                   );
      exception when others then 
        ln_deudaRccSinCmac :=0;
      end;
      
  
  /*sacar el tipo de cambio de dia*/
   begin
    select  e.cotcbi  INTO ln_tipcam
           FROM FsH005 e
       WHERE e.MONEDA = 101
         AND e.COFDES in (pd_fecha);
    exception when others then 
      ln_tipcam :=0;
    end;     
  
  /*saldo de duda total a la fecha*/
  begin
      select nvl(sum(decode(t.scmod,117,1,-1)*t.scsdo*decode(t.scmda,0,1,ln_tipcam) ),0) into ln_montoTotal
              from fsd011 t, fsr008 r
             where r.pgcod = t.pgcod
               and t.sccta = r.ctnro
               and r.cttfir = 'T'
               and r.ttcod = 1
               and (exists
             (select 1
                      from fst111 m
                     where m.dscod = 50
                       and m.modulo = t.scmod and m.modulo <> 116) or t.scmod = 117) 
               AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and t.scrub LIKE g.tp1desc||'%'  )                    
               and r.pepais = pn_pgpais
               and r.petdoc = pn_tipdoc
               and r.pendoc = pv_numdoc--'43299214'
               and substr(t.scrub, 1, 4) in (1411,
                                             1414,
                                             1415,
                                             1416,
                                             1421,
                                             1424,
                                             1425,
                                             1426,
                                             8113,
                                             8123,
                                             8119,
                                             8129,
                                             7215,
                                             7225);
     exception when others then 
       ln_montoTotal :=0;
     end;       
     
      
    /*verificar que la instancia esta en vuelo es ampliacion o vinculada*/
    /**/
              begin 
                /*Ampliacion*/
                select t.xwfmonto1*decode(t.xwfmoneda,0,1,ln_tipcam)
                into ln_montovuelo
                from xwf700 t, sng001 a
               where t.xwfprcins = pn_instancia
                 and t.xwfprcins = a.sng001inst
                 and a.sng001ori = 4 --ampliaciones
                 and t.xwfempresa = 1
                 and a.sng001emp = 1
                 and t.xwfcar3 = '1'
                 --AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and g.tp1nro1 = t.xwfmodulo )                   
                         ; -- en vuelo
              exception when others then 
                ln_montovuelo := 0;     
              end; 
              
              
              /*obtener el credito que se va a cancelar en una ampliacion */
              if ln_montovuelo > 0 then -- existe una instancia en vuelo de tipo ampliacion o vinculacion 
                      begin           
                       select /*+ all_rows */
                        -1 * nvl(sum(t.scsdo * decode(w.xwfmoneda, 0, 1, ln_tipcam)),0)
                         into ln_montoCanc
                         from fsd011 t, fsr008 r, xwf700 w, sng001 s
                        where t.pgcod = r.pgcod
                          and t.sccta = r.ctnro
                          and r.cttfir = 'T'
                          and r.ttcod = 1
                          and w.xwfempresa = t.pgcod
                          and w.xwfsucursal = t.scsuc
                          and w.xwfmodulo = t.scmod
                          and w.xwfmoneda = t.scmda
                          and w.xwfpapel = t.scpap
                          and w.xwfcuenta = t.sccta
                          and w.xwfoperacion = t.scoper
                          and w.xwfsubope = t.scsbop
                          and w.xwftipope = t.sctope
                          and w.xwfprcins = pn_instancia --5720524 /*pn_instancia*/
                          and w.xwfprcins = s.sng001inst
                          and s.sng001ori = 4
                          and --ampliaciones
                              w.xwfempresa = 1
                          and s.sng001emp = 1
                          and t.scstat <> 99
                          and w.xwfcar3 <> '1'
                          and exists (select 1
                                 from fst111 m
                                where m.dscod = 50
                                  and m.modulo = t.scmod)
                         --AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and g.tp1nro1 = t.scmod )                   
                         AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and t.scrub LIKE g.tp1desc||'%' ) 
                                  ;
                      exception when others then  
                                ln_montoCanc :=0;
                      end;
                  
                  else
                    
                /*vinculado*/
                      begin 
                          select /*+ all_rows */
                           nvl(max(n.xwfmonto1 * decode(n.xwfmoneda, 0, 1, ln_tipcam)),0)
                            into ln_montovuelo
                            from jaqy800 j, xwf700 n, xwf700 o
                           where j.jaqy800vinc = 'S'
                             and n.xwfprcins = j.jaqy800ins
                             and o.xwfprcins = j.jaqy800ins2
                             and n.xwfcar3 = '1'
                             and o.xwfcar3 <> '1'
                             and n.xwfprcins = pn_instancia
                             --AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and g.tp1nro1 = n.xwfmodulo )                   
                         ;
                          exception when others then ln_montovuelo := 0; end;
                          
                          if ln_montovuelo > 0 then 
                             
                             begin 
                                   select /*+ all_rows */
                                    nvl(sum(s.scsdo*decode(s.scmda, 0, 1, ln_tipcam)*decode(s.scmod,117,1,-1)),0) 
                                   into ln_montoCanc
                                    from jaqy800 j, xwf700 n, xwf700 o, fsd011 s
                                   where j.jaqy800vinc = 'S'
                                     and n.xwfprcins = j.jaqy800ins
                                     and o.xwfprcins = j.jaqy800ins2
                                     and n.xwfcar3 = '1'
                                     and o.xwfcar3 <> '1'
                                     and s.pgcod = o.xwfempresa
                                     and s.scmda = o.xwfmoneda
                                     and s.sccta = o.xwfcuenta
                                     and s.scoper = o.xwfoperacion
                                     and s.scmod = o.xwfmodulo
                                     and s.scstat <> 99
                                     and j.jaqy800ins = pn_instancia
                                     --AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and g.tp1nro1 = s.scmod )                   
                                     AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and s.scrub LIKE g.tp1desc||'%') 
                         ;   
                             
                             exception when others then 
                                  ln_montoCanc :=0;
                             end;
                           else 
                               --ln_montovuelo :=0;
                               ln_montoCanc :=0;
                               /*solicitud en vuelo*/
                               begin 
                                    /*solicitud en vuelo*/
                                    select t.xwfmonto1*decode(t.xwfmoneda,0,1,ln_tipcam)
                                    into ln_montovuelo
                                    from xwf700 t, sng001 a
                                   where t.xwfprcins = pn_instancia
                                     and t.xwfprcins = a.sng001inst
                                     --and a.sng001ori = 4 --ampliaciones
                                     and t.xwfempresa = 1
                                     and a.sng001emp = 1
                                     and t.xwfcar3 = '1'
                                    --AND NOT EXISTS (select 1 from fst198 g where g.tp1cod = 1 and g.tp1cod1 = 11149 and g.tp1corr1 = 6 and g.tp1corr2 = 1 and g.tp1nro1 = t.xwfmodulo )                   
                                             ; -- en vuelo
                                exception when others then 
                                    ln_montovuelo := 0;     
                                end; 
                               
                               
                               
                          end if;  
                 end if;
         
        /*calculo de saldo neto*/
        ln_montoNeto := ln_montovuelo - ln_montoCanc;
        if ln_montoNeto < 0 then 
          ln_montoNeto :=0;
        end if;
        
                  
   
  
    ln_deudaCMAC := ln_montoTotal + ln_montoNeto;   
    
    /*Calculo de deuda Caja mayor*/
    if ln_deudaCMAC > ln_deudaRccCMAC then 
      ln_deudaCMACFinal := ln_deudaCMAC;
      ln_deudaRccFinal := ln_deudaRccSinCmac+ ln_deudaCMACFinal;
      
    else
       ln_deudaCMACFinal :=  ln_deudaRccCMAC;
       ln_deudaRccFinal := ln_deudaRcc;
       
      end if;
    
    /*Calculo de ratio de SOW*/
    if ln_deudaRcc = 0 then 
      pn_result :=0;      
    else 
        select nvl(ROUND((ln_deudaCMACFinal) / (ln_deudaRccFinal) * 100, 2), 0) SOW
          into pn_result
          from dual;
    end if;
    
  
       
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
  
end sp_cr_rcc_sow2;

---------------------------------------------------------------------------------------------

 

end PQ_CR_SEGMENTACION_PYME;
/

