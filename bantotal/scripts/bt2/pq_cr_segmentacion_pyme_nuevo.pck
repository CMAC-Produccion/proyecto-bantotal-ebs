create or replace package PQ_CR_SEGMENTACION_PYME_NUEVO is

-- *****************************************************************
    -- Nombre                     : paquete para calcular nuevas variables de la nueva segmentacion mype
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : paquete de rutinas para la nueva segmentacion pyme - mejora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 16/06/2022 YYAMPI se agrego el procedimento sp_cr_caja_sow2
    -- *****************************************************************
  procedure sp_cr_antiguedad_pyme(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pn_result out number);
                                
                          

end PQ_CR_SEGMENTACION_PYME_NUEVO;
/

create or replace package body PQ_CR_SEGMENTACION_PYME_NUEVO is

  procedure sp_cr_antiguedad_pyme(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pn_result out number) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_antiguedad_pyme
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna la antiguedad de deuda pyme viva en el SF
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva number; --meses de evaluacion 
    ld_fecrcci date; --fecha de inicio carga RCC
    
begin
  pn_result := 0.00; 
  --pv_result := 'S';
  
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then
           ld_fecrcc := null;   
      end; 
      
      /*obtener el numero de meses maximo para la evaluacion*/
      begin 
        select t.tp1nro1
        into ln_meseva 
        from  FST198 t       
          Where t.Tp1cod   = 1
          and t.Tp1cod1  = 11155 
          and t.Tp1corr1 = 2 
          and t.Tp1corr2 = 1 
          and t.Tp1corr3 = 2;
          
          ld_fecrcci := add_months(ld_fecrcc, -1*ln_meseva);
            
      exception when others then
        ln_meseva := 0;
        ld_fecrcci := null;
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
          select c_codsbs into lv_codSBS 
          from (      
          select c.c_codsbs 
          from CLDRCCI c
          Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between ld_fecrcci and ld_fecrcc
                and C_TDOCID = ln_tipdocSBS
                and C_DOCIDE = pv_numdoc
                order by C.D_FECPRE desc
                ) where rownum = 1;
        else   
          if ln_petipo = 'J' then
            select c_codsbs into lv_codSBS 
            from ( 
            select c.c_codsbs --into lv_codSBS
            from CLDRCCI c
             Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between ld_fecrcci and ld_fecrcc
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc
                 order by C.D_FECPRE desc
                ) where rownum = 1 ;
           else      
               lv_codSBS := null;
          end if ;
        end if ;  
      exception when others then 
          DBMS_OUTPUT.put_line(SQLERRM);                               
      end;
             
  /*Calculo de meses de antiguedad*/
  
        begin  
            select /*+ all_rows */ count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
             into pn_result 
             FROM CLDRCCS C 
                    WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                      AND C.D_FECPRE between ld_fecrcci and ld_fecrcc
                      --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                      AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                          from FST198 T 
                                            WHERE t.Tp1cod   = 1
                                            AND t.Tp1cod1  = 11155 
                                            AND t.Tp1corr1 = 1 
                                            AND t.Tp1corr2 = 1) ; 
                   
                   /*if pn_result > 0 then
                     pv_result := 'N';
                   end if ;*/  
                          
                                       
         exception when others then 
                   pn_result :=0;
                   --pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     --pv_result :='S'; 
  
end sp_cr_antiguedad_pyme;

--------------------------------------------------------------------------


end PQ_CR_SEGMENTACION_PYME_NUEVO;
/

