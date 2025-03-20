create or replace package pq_cr_potencial_pyme is
 -- *****************************************************************
    -- Nombre                     : pq_cr_potencial_pyme
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : juego de procemientos para calculo de potencial del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 12/10/2022 YYAMPI ultimo cambio de jose francisco con el tema de rubros para calculos de volumen y recurrencia solo el rubro 14 y para el calculo de primera fecha en el rcc se toma 14, 72 y 83
    --                              21/10/2022 YYAMPI se agrego los nuevos procedimientos para el calculo en linea sp_potencial_cliente_linea, sp_tiempo_potencial_l, sp_volumen_credito_l, sp_recurrencia_credito_l, sp_resultado_credito_l, sp_potencial_cliente_l
    --  
    -- *****************************************************************
   Function fn_potencial_cliente(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char
                        ) return number;
                        
   Procedure sp_potencial_cliente(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        ) ;     
                                        
  Procedure sp_tiempo_potencial(
                          pd_fecha  in date,                        
                          pn_resp  out number
                          );
                          
 procedure sp_volumen_credito(                                   
                                    pd_fecha  in date,     
                                    pn_result out number
                                    );
  
 procedure sp_cr_saldos_cuo_pyme(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pn_saldos out number,
                                pn_cuotas out number,
                                pn_volumen out number,
                                pn_escala out number
                                );  
                                

                                                    
procedure sp_recurrencia_credito(                                   
                                    pd_fecha  in date,     
                                    pn_result out number
                                    );
procedure sp_cr_recurrencia_cliente(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pn_meses_con out number,
                                pn_meses_act out number,
                                pn_recurrencia out number,
                                pn_escala out number
                                )  ; 


  Function fn_codsbs_cliente(
                        pd_fecini  in date,
                        pd_fecfin  in date,
                        pn_pgpais   in number,
                        pn_tipdoc   in number,
                        pc_numdoc   in char
                        ) return varchar;
                        
 Procedure sp_job_tiempo_potencial(pd_fecha  in date
                                   ) ;
   
  Procedure sp_tiempo_potencial_j(
                          pv_cod in varchar,
                          pd_fecha  in date
                          )  ;  
 
 Procedure sp_job_volumen_credito(pd_fecha  in date
                                   ) ;
  procedure sp_volumen_credito_j(                                   
                                pv_cod in varchar,
                                pd_fecha  in date                                     
                                );
                                    
  procedure sp_volumen_cliente_j(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pv_codsbs varchar,
                                pn_saldos out number,
                                pn_cuotas out number,
                                pn_volumen out number,
                                pn_escala out number
                                );      

Procedure sp_job_recurrencia_credito(pd_fecha  in date
                                   ) ;

procedure sp_recurrencia_credito_j(                                   
                                    pv_cod in varchar,
                                    pd_fecha  in date 
                                    );
procedure sp_recurrencia_cliente_j(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pv_codsbs varchar,
                                pn_meses_con out number,
                                pn_meses_act out number,
                                pn_recurrencia out number,
                                pn_escala out number
                                );                                                                       


Procedure sp_job_resultado_credito(pd_fecha  in date
                                   ) ;

procedure sp_resultado_credito_j(                                   
                                    pv_cod in varchar,
                                    pd_fecha  in date 
                                    );

Procedure sp_potencial_cliente2(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        ) ;
                        
Procedure sp_potencial_cliente_linea(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number                     
                        );

Procedure sp_tiempo_potencial_l(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char
                        );  

 procedure sp_volumen_credito_l(                                   
                                pd_fecha  in date,
                                pn_pais   in number,
                                pn_tdoc   in number,
                                pc_ndoc   in char     
                                );                                                                      

 procedure sp_recurrencia_credito_l(                                   
                                    pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pc_ndoc   in char  
                                    );  
 
procedure sp_resultado_credito_l(                                   
                                    pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pc_ndoc   in char, 
                                    pn_pote  out number  
                                    );
                                    
 Procedure sp_potencial_cliente_l(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        );                                                                                                                                                                                                                
end pq_cr_potencial_pyme;
/

create or replace package body pq_cr_potencial_pyme is



 ------------------------------------------------------------------
 
 Function fn_potencial_cliente(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char
                        ) return number is
  
  -- *****************************************************************
    -- Nombre                     : fn_potencial_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL VALOR DE POTENCIAL POR CLIENTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : EL VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
  begin
  
    begin
    
      /*obtener el valor del potencial del cliente*/
      select 
               decode(t.aqpb833va1,0,1,t.aqpb833va1)*
               decode(t.aqpb833va2,0,1,t.aqpb833va2)*
               decode(t.aqpb833va3,0,1,t.aqpb833va3)               
              into ln_potval
        from AQPB833 t
       where t.aqpb833fec = pd_fecha
         and t.aqpb833pai = pn_pais
         and t.aqpb833tdo = pn_tdoc
         and t.aqpb833ndo = pc_ndoc
         and t.aqpb833est = 'S';
      
      
      select t.tp1corr3
        into ln_potencial
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11155
         and t.tp1corr1 = 100
         and t.tp1corr2 = 1
         and ln_potval between t.tp1nro1 and t.tp1nro2;
      
      return ln_potencial;    
      
      
    exception
      when others then
       return ln_potencial;
    end;  
     
    return ln_potencial;
  
  end fn_potencial_cliente;
-----------------------------------------------------------------------------
  
Procedure sp_potencial_cliente(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_potencial_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE POTENCIAL POR CLIENTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
  begin
  
    begin
    
      /*obtener el valor del potencial del cliente*/
      select 
               /*decode(t.aqpb833va1,0,1,t.aqpb833va1)*
               decode(t.aqpb833va2,0,1,t.aqpb833va2)*
               decode(t.aqpb833va3,0,1,t.aqpb833va3)*/ 
              t.aqpb833va4               
              into ln_potval
        from AQPB833 t
       where t.aqpb833fec = pd_fecha
         and t.aqpb833pai = pn_pais
         and t.aqpb833tdo = pn_tdoc
         and t.aqpb833ndo = pc_ndoc
         and t.aqpb833est = 'S';
      
      
      /*select t.tp1corr3
        into ln_potencial
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11155
         and t.tp1corr1 = 100
         and t.tp1corr2 = 1
         and ln_potval between t.tp1nro1 and t.tp1nro2;*/
      
      pn_poten := ln_potval;    
      
      
    exception
      when others then       
       /*se calcula la potencialidad en linea*/
       begin
          
          pq_cr_potencial_pyme.sp_potencial_cliente_linea(pd_fecha => pd_fecha,
                                                          pn_pais  => pn_pais ,
                                                          pn_tdoc  => pn_tdoc,
                                                          pc_ndoc  => pc_ndoc,
                                                          pn_poten => ln_potval);  
           pn_poten := ln_potval; 
         exception when others then           
           pn_poten := 5 ;--ln_potencial;   --caso de no haber nada por default 5 (muy bajo) cambio solicitado por parametrizacion  
           end;             
      
    end; 
     
    --pn_poten := ln_potval;  
  
  end sp_potencial_cliente;
-----------------------------------------------------------------------------

Procedure sp_tiempo_potencial(
                        pd_fecha  in date,                        
                        pn_resp  out number
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_tiempo_potencial
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.04.08
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL TIEMPO POTENCIAL 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    -- Parámetros de Salida       : pn_resp ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    
    /*cursor que calcula la edad de todos los clientes y su rango */   
    cursor c_cliente(p_fecini date, p_fecfin date) is
          /*proceso de edad*/
          select /*+ all_rows */ pfpais, pftdoc, pfndoc, edad, 
          case 
            when edad > 58 then 1  
            when edad > 51 and edad <=58 then 2
            when edad > 44 and edad <=51 then 3
            when edad > 36 and edad <=44 then 4
            when edad >= 0 and edad <= 36 then 5    
            end  valor, 
            fn_codsbs_cliente(pd_fecini => p_fecini,
                              pd_fecfin => p_fecfin,
                              pn_pgpais => pfpais,
                              pn_tipdoc => pftdoc,
                              pc_numdoc => pfndoc) csbs
            from (
          select /*+ all_rows */ 
          distinct t.pfpais, t.pftdoc, t.pfndoc, t.pffnac, trunc(months_between(pd_fecha,t.pffnac)/12) edad 
          from fsd002 t, fsr008 r 
          where 
          t.pfpais = r.pepais
          and t.pftdoc = r.petdoc
          and t.pfndoc = r.pendoc 
          and r.cttfir = 'T'
          and r.ttcod = 1
          );
           
    
    ln_conta number(15) :=0;  --valor sin respuesta
    ln_meses_eva  number(16);
    ld_fecrcc date ;
    ld_fecrcci date ;
    
  begin
       /*borrar de la tabla*/
       delete from AQPB833 t where t.aqpb833fec = pd_fecha;
       commit;
 
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
    /*obtencion de 10 años para evaluar guia de proceso*/
    begin 
      select t.tp1nro1 into ln_meses_eva
             from FST198 T 
        WHERE t.Tp1cod   = 1
         AND t.Tp1cod1  = 11155 
         and t.tp1corr1 = 3
         and t.tp1corr2 = 1
         and t.tp1corr3 = 1;
       exception when others then 
          ln_meses_eva := null;
      end;           

      begin 
        ld_fecrcci := add_months(ld_fecrcc,-1*ln_meses_eva);
      exception when others then 
        ld_fecrcci := null;  
      end;

      /*obtener el valor del potencial del cliente*/
      for c in c_cliente(ld_fecrcci,ld_fecrcc ) loop        
          begin 
            insert into AQPB833
              (AQPB833FEC,
               AQPB833PAI,
               AQPB833TDO,
               AQPB833NDO,
               AQPB833EST,
               AQPB833CSBS,
               AQPB833VA1               
               )
            values
              (pd_fecha, c.pfpais, c.pftdoc, c.pfndoc, 'S',c.csbs, c.valor);
          exception when others then 
            dbms_output.put_line(c.pfndoc||'-'|| sqlerrm);
            pn_resp :=0;
          end;
          
          /*commit en 1000 en 1000*/
          if ln_conta = 1000 then 
            commit;
            ln_conta :=0;
          else
            ln_conta := ln_conta+ 1;
          end if;    
              
      
      end loop;
      commit;
      pn_resp := 1;
      exception when others then 
      dbms_output.put_line(sqlerrm);
            pn_resp :=0;
        
  end sp_tiempo_potencial;
-----------------------------------------------------------------------------

 procedure sp_cr_saldos_cuo_pyme(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pn_saldos out number,
                                pn_cuotas out number,
                                pn_volumen out number,
                                pn_escala out number
                                ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_saldos_cuo_pyme
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el volumen de credito por cliente 
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
    pn_result number;
    pv_numdoc varchar(12); 
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
          and t.Tp1corr1 = 3 
          and t.Tp1corr2 = 1 
          and t.Tp1corr3 = 1;
          
          ld_fecrcci := add_months(ld_fecrcc, -1*120/*ln_meseva*/);
            
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
              and t.pendoc = pc_numdoc;
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
        pv_numdoc := trim(pc_numdoc); 
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
            select /*+ all_rows */ sum(c.n_salcap) , count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
             into pn_saldos ,  pn_cuotas
             FROM CLDRCCS C 
                    WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                      AND C.D_FECPRE between ld_fecrcci and ld_fecrcc
                      --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                     AND ( (SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                           SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6'))
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS      
                           ) --CREDITOS DIRECTOS
                      
                      AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                          from FST198 T 
                                            WHERE t.Tp1cod   = 1
                                            AND t.Tp1cod1  = 11155 
                                            AND t.Tp1corr1 = 1 
                                            AND t.Tp1corr2 = 1) ; 
                   
                   if pn_cuotas > 0 then
                     pn_volumen := pn_saldos/pn_cuotas;                      
                   else 
                      pn_volumen :=0; 
                   end if ;
                   
                   /*calcular la escala*/
                   if  pn_volumen >=0 and pn_volumen <= 2500 then 
                       pn_escala := 1;
                     else
                       if pn_volumen > 2500 and pn_volumen <= 5000 then
                         pn_escala := 2;
                         else
                           if pn_volumen > 5000 and pn_volumen <= 10000  then
                             pn_escala := 3;
                           else 
                               if pn_volumen > 10000 and pn_volumen <= 25000  then
                                 pn_escala := 4;
                               else 
                                   if pn_volumen > 25000 then
                                      pn_escala := 5;
                                   end if;
                               end if;
                           end if;
                       end if;      
                   end if; 
                          
                                       
         exception when others then 
                   pn_result :=0;
                   pn_saldos :=0;
                   pn_cuotas :=0;
                   pn_volumen :=0;
                   
                   --pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     pn_saldos :=0;
     pn_cuotas :=0;
     pn_volumen :=0;
     --pv_result :='S'; 
  
end sp_cr_saldos_cuo_pyme;
-----------------------------------------------------------------------------
 procedure sp_volumen_credito(                                   
                                    pd_fecha  in date,     
                                    pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_volumen_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/04/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Procesa la variable de volumen creditos 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo from aqpb833 t
      where t.aqpb833fec = pd_fecha
      --and t.aqpb833ndo = '16160851'
      and rownum <= 100000
    --where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    
begin
  pn_result := 0; --
  
            
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
   
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_cr_saldos_cuo_pyme(pn_pgpais  => ti.aqpb833pai,
                                                       pn_tipdoc  => ti.aqpb833tdo,
                                                       pc_numdoc  => ti.aqpb833ndo,
                                                       pn_saldos  => ln_saldos,
                                                       pn_cuotas  => ln_cuotas,
                                                       pn_volumen => ln_volumen,
                                                       pn_escala => ln_escala);     
            
                       
            /*actualiza la tabla de clientes*/        
            update aqpb833 u
               set u.aqpb833va2 = ln_escala
             where u.aqpb833fec = ti.aqpb833fec
               and u.aqpb833pai = ti.aqpb833pai
               and u.aqpb833tdo = ti.aqpb833tdo
               and u.aqpb833ndo = ti.aqpb833ndo;
            
         
              /*commit en 1000 en 1000*/
              if ln_conta = 1000 then 
                commit;
                ln_conta :=0;
              else
                ln_conta := ln_conta+ 1;
              end if;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb833ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_volumen_credito;
------------------------------------------------------------------------------------------   

 procedure sp_recurrencia_credito(                                   
                                    pd_fecha  in date,     
                                    pn_result out number
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_recurrencia_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Procesa la variable de recurrencia de credito 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo from aqpb833 t
      where t.aqpb833fec = pd_fecha
      --and t.aqpb833ndo = '16160851'
      and rownum <= 10000
    --where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meses_eva number(15,2) :=0;
    ln_meses_con number(16,2);
    ln_meses_act  number(16,2);
    ln_recurrencia number(16,2);
    --ln_escala number(16,2);      
    
begin
  pn_result := 0; --
  
            
  /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
  /*obtencion de 10 años para evaluar guia de proceso*/
  select t.tp1nro1 into ln_meses_eva
         from FST198 T 
    WHERE t.Tp1cod   = 1
     AND t.Tp1cod1  = 11155 
     and t.tp1corr1 = 3
     and t.tp1corr2 = 1
     and t.tp1corr3 = 1;
  
  
  
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_cr_recurrencia_cliente(pd_fecfin      => ld_fecrcc,
                                                           pn_meses_eva   => ln_meses_eva,
                                                           pn_pgpais      => ti.aqpb833pai, 
                                                           pn_tipdoc      => ti.aqpb833tdo,
                                                           pc_numdoc      => ti.aqpb833ndo,
                                                           pn_meses_con   => ln_meses_con,
                                                           pn_meses_act   => ln_meses_act,
                                                           pn_recurrencia => ln_recurrencia,
                                                           pn_escala      => ln_escala)
                                                           ;     
            
                       
            /*actualiza la tabla de clientes*/        
            update aqpb833 u
               set u.aqpb833va3 = ln_escala
             where u.aqpb833fec = ti.aqpb833fec
               and u.aqpb833pai = ti.aqpb833pai
               and u.aqpb833tdo = ti.aqpb833tdo
               and u.aqpb833ndo = ti.aqpb833ndo;
            
         
              /*commit en 1000 en 1000*/
              if ln_conta = 1000 then 
                commit;
                ln_conta :=0;
              else
                ln_conta := ln_conta+ 1;
              end if;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb833ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_recurrencia_credito;
---------------------------------------------------------------------------------
procedure sp_cr_recurrencia_cliente(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pn_meses_con out number,
                                pn_meses_act out number,
                                pn_recurrencia out number,
                                pn_escala out number
                                ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_recurrencia_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna la recurrencia de un cliente de meses activos / meses consumidos 
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
    pn_result number;
    pv_numdoc varchar(12); 
    ln_meses_act number(15);
    ln_meses_con number(15);
    ld_fecini date; 
    --ln_meses number
    
begin
  pn_result := 0.00; 
  --pv_result := 'S';
  
     /*fecha de ultima carga del RCC */
     /*begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then
           ld_fecrcc := null;   
      end; */
      
      /*obtener fecha del primer credito*/
      
      
      begin 
        
        /*se calcula la fecha de inicio */  
          ld_fecrcci := add_months(pd_fecfin, -1*pn_meses_eva/*ln_meseva*/);
            
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
              and t.pendoc = pc_numdoc;
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
        pv_numdoc := trim(pc_numdoc); 
        if ln_petipo = 'F' then     
          select c_codsbs into lv_codSBS 
          from (      
          select c.c_codsbs 
          from CLDRCCI c
          Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between ld_fecrcci and pd_fecfin
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
          lv_codSBS := null;                               
      end;
             
  /*Calculo de meses de antiguedad*/
  
        begin  
            select /*+ all_rows */ min(c.d_fecpre) fecha_ini, count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
             into ld_fecini ,  pn_meses_act
             FROM CLDRCCS C 
                    WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
                      AND C.D_FECPRE between ld_fecrcci and pd_fecfin
                      --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                     AND ( (SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                           SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6'))
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS      
                           ) --CREDITOS DIRECTOS
                      
                      AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                          from FST198 T 
                                            WHERE t.Tp1cod   = 1
                                            AND t.Tp1cod1  = 11155 
                                            AND t.Tp1corr1 = 1 
                                            AND t.Tp1corr2 = 1) ; 
                   
                   /*se calcular la fecha menor*/
                   if ld_fecrcci < ld_fecini then
                       ld_fecini := ld_fecrcci;
                      
                     end if;
                     
                     /*calculo de meses consumidos*/
                    pn_meses_con := trunc(MONTHS_BETWEEN(pd_fecfin, ld_fecini)); 
                   
                   if pn_meses_con > 0 then
                     pn_recurrencia := pn_meses_act/pn_meses_con;                      
                   else 
                      pn_recurrencia :=0; 
                   end if ;
                   
                   /*calcular la escala*/
                   if  pn_recurrencia >=0 and pn_recurrencia <= 0.2 then 
                       pn_escala := 1;
                     else
                       if pn_recurrencia > 0.2 and pn_recurrencia <= 0.4 then
                         pn_escala := 2;
                         else
                           if pn_recurrencia > 0.4 and pn_recurrencia <= 0.6  then
                             pn_escala := 3;
                           else 
                               if pn_recurrencia > 0.6 and pn_recurrencia <= 0.8  then
                                 pn_escala := 4;
                               else 
                                   if pn_recurrencia > 0.8 then
                                      pn_escala := 5;
                                   end if;
                               end if;
                           end if;
                       end if;      
                   end if; 
                          
                                       
         exception when others then 
                   pn_result :=0;
                   ln_meses_con :=0;
                   pn_meses_act :=0;
                   pn_recurrencia :=0;
                   pn_escala := null;
                   --pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     ln_meses_con :=0;
     pn_meses_act :=0;
     pn_recurrencia :=0;
     pn_escala := null;
     --pv_result :='S'; 
  
end sp_cr_recurrencia_cliente;
------------------------------------------------------------------------------------------

 Function fn_codsbs_cliente(
                        pd_fecini  in date,
                        pd_fecfin  in date,
                        pn_pgpais   in number,
                        pn_tipdoc   in number,
                        pc_numdoc   in char
                        ) return varchar is
  
  -- *****************************************************************
    -- Nombre                     : fn_codsbs_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecini ( FECHA DE PROCESO INICIAL )
    --                            : pd_fecfin ( FECHA DE PROCESO FIN )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : codigo sbs
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0; --
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :=''; --codigoSBS 
    pv_numdoc varchar(12):=0; --numero de documento 
   -- ln_petipo
  begin
  
      /*obtener tipo de persona (Juridica o natural) */
      begin 
        select t.petipo into ln_petipo 
        from fsd001 t
        where t.pepais = pn_pgpais
              and t.petdoc = pn_tipdoc
              and t.pendoc = pc_numdoc;
      exception when others then 
       --DBMS_OUTPUT.put_line(SQLERRM);
       ln_petipo := '';
       null;                        
      end;
      
      /*Calculo de tipo de documento SBS*/
      begin 
          select t.tp1corr3 into ln_tipdocSBS 
          from FST198 t 
          where t.tp1cod = 1 and t.tp1cod1 = 11111
               and t.tp1corr1 = 1 and t.tp1corr2 = 3
               and t.tp1nro1 =  pn_tipdoc; 
      exception when others then 
         --DBMS_OUTPUT.put_line(SQLERRM);
         ln_tipdocSBS := 0;
         null;                          
      end;
      
      /*Obtencion del codigo SBS*/
      begin
        pv_numdoc := trim(pc_numdoc); 
        if ln_petipo = 'F' then     
          select c_codsbs into lv_codSBS 
          from (      
          select c.c_codsbs 
          from CLDRCCI c
          Where --D_FECPRE = ld_fecrcc
                C.D_FECPRE between pd_fecini and pd_fecfin
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
                C.D_FECPRE between pd_fecini and pd_fecfin
                and C_TDOCTR = ln_tipdocSBS
                and C_DOCTRI = pv_numdoc
                 order by C.D_FECPRE desc
                ) where rownum = 1 ;
           else      
               /*caso externo */
               begin 
                    select c_codsbs
                      into lv_codSBS
                      from (select c.c_codsbs
                               from CLDRCCI c
                              Where --D_FECPRE = ld_fecrcc
                              C.D_FECPRE between pd_fecini and pd_fecfin
                           and C_TDOCID = ln_tipdocSBS
                           and C_DOCIDE = pv_numdoc
                              order by C.D_FECPRE desc)
                     where rownum = 1;
               exception when others then          
                   lv_codSBS := null;
               end;
          end if ;
        end if ;  
      exception when others then 
          --DBMS_OUTPUT.put_line(SQLERRM);
          lv_codSBS := null; 
                                        
      end;
     
    return lv_codSBS;
  
  end fn_codsbs_cliente;
  
--------------------------------------------------------------------------------------------  


 Procedure sp_job_tiempo_potencial(pd_fecha  in date
                                   )             
    is
 -- *****************************************************************
    -- Nombre                     : sp_job_tiempo_potencial
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecini ( FECHA DE PROCESO INICIAL )
    --                            : pd_fecfin ( FECHA DE PROCESO FIN )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : codigo sbs
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
     
    --ln_max number;
    --ln_inc number;
    lv_ini varchar2(3);
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    lv_fecha varchar(10);
    --lc_coderr varchar2(300);
   
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --execute immediate ('truncate table UAI_ACLPRE');
    /*borrar de la tabla*/
   delete from AQPB833 t where t.aqpb833fec = pd_fecha;
   commit;
    
   /*calculamos fecha de proceso*/
   lv_fecha := to_char(pd_fecha,'dd/mm/rrrr');
   
    delete Tab_jobs where c_Codage = 'POTEN_T';
    commit;
    for i in 0..99 loop
      lv_ini      := lpad(i,2,'0');
      lc_variable := ' begin ' || '  pq_cr_potencial_pyme.sp_tiempo_potencial_j(''' || lv_ini || ''',' || 'TO_DATE( ''' ||
                     lv_fecha || ''', ''DD/MM/RRRR''  ' ||  '));' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('POTEN_T', 1*lv_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'POTEN_T', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_tiempo_potencial;
--------------------------------------------------------------------------------------------  
Procedure sp_tiempo_potencial_j(
                        pv_cod in varchar,
                        pd_fecha  in date
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_tiempo_potencial
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.04.08
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL TIEMPO POTENCIAL 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    -- Parámetros de Salida       : pn_resp ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 24/10/2022 YYAMPI Incluir todos los clientes registrados en Bantotal 
    --  
    -- *****************************************************************
    
    /*cursor que calcula la edad de todos los clientes y su rango */   
    cursor c_cliente(p_fecini date, p_fecfin date) is
          /*proceso de edad*/
          select /*+ all_rows */ pfpais, pftdoc, pfndoc, edad, 
          case 
            when tipper = 'J' then 0
            when tipper = 'N' and edad > 58 then 1  
            when tipper = 'N' and edad > 51 and edad <=58 then 2
            when tipper = 'N' and edad > 44 and edad <=51 then 3
            when tipper = 'N' and edad > 36 and edad <=44 then 4
            when tipper = 'N' and edad >= 0 and edad <=36 then 5    
            end  valor, 
            fn_codsbs_cliente(pd_fecini => p_fecini,
                              pd_fecfin => p_fecfin,
                              pn_pgpais => pfpais,
                              pn_tipdoc => pftdoc,
                              pc_numdoc => pfndoc) csbs, 
            tipper                  
            from (
          /*personas juridicas*/  
          select /*+ all_rows */ 
          distinct t.pfpais, t.pftdoc, t.pfndoc, t.pffnac, trunc(months_between(pd_fecha,t.pffnac)/12) edad, 'N' tipper  
          from fsd002 t--, fsr008 r 
          where 
          --t.pfpais = r.pepais
          --and t.pftdoc = r.petdoc
          --and t.pfndoc = r.pendoc 
          --and r.cttfir = 'T'
          --and r.ttcod = 1
          substr(trim(t.pfndoc),-2,2) = pv_cod
          union
          /*personas juridicas*/
          select /*+ all_rows */ 
          distinct t.pjpais, t.pjtdoc, t.pjndoc, t.pjfcon, trunc(months_between(pd_fecha,t.pjfcon)/12) edad, 'J' tipper
          from fsd003 t--, fsr008 r 
          where 
          --t.pjpais = r.pepais
          --and t.pjtdoc = r.petdoc
          --and t.pjndoc = r.pendoc 
          --and r.cttfir = 'T'
          --and r.ttcod = 1
          substr(trim(t.pjndoc),-2,2) = pv_cod
          --and substr(r.pendoc, LENGTH(r.pendoc)-2)*1 = pn_cod
          ) --d, tmp_segmen2 s --cambio temporal @yyampi
          --where d.pfndoc = s.jaqy066tndoc    --cambio temporal @yyampi     
          ;
           
    
    ln_conta number(15) :=0;  --valor sin respuesta
    ln_meses_eva  number(16);
    ld_fecrcc date ;
    ld_fecrcci date ;
    pn_resp number(10);
  begin
       /*borrar de la tabla*/
       /*delete from AQPB833 t where t.aqpb833fec = pd_fecha;
       commit;*/
       
      /*insertar log*/
      update tab_jobs g
       set g.d_fecini = sysdate
      where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_T';
      commit; 
       
       
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
    /*obtencion de 10 años para evaluar guia de proceso*/
    begin 
      select t.tp1nro1 into ln_meses_eva
             from FST198 T 
        WHERE t.Tp1cod   = 1
         AND t.Tp1cod1  = 11155 
         and t.tp1corr1 = 3
         and t.tp1corr2 = 1
         and t.tp1corr3 = 1;
       exception when others then 
          ln_meses_eva := null;
      end;           

      begin 
        ld_fecrcci := add_months(ld_fecrcc,-1*ln_meses_eva);
      exception when others then 
        ld_fecrcci := null;  
      end;

      /*obtener el valor del potencial del cliente*/
      for c in c_cliente(ld_fecrcci,ld_fecrcc ) loop        
          begin 
            insert into AQPB833
              (AQPB833FEC,
               AQPB833PAI,
               AQPB833TDO,
               AQPB833NDO,
               AQPB833EST,
               AQPB833CSBS,
               AQPB833VA1,
               AQPB833VAR1, 
               AQPB833VAR6                              
               )
            values
              (pd_fecha, c.pfpais, c.pftdoc, c.pfndoc, 'S',c.csbs, c.valor, 'EDAD='||c.edad, 'TIP PER='||c.tipper);
          exception when others then 
            dbms_output.put_line(c.pfndoc||'-'|| sqlerrm);
            pn_resp :=0;
          end;
          
          /*commit en 1000 en 1000*/
          if ln_conta = 100 then 
            commit;
            ln_conta :=0;
          else
            ln_conta := ln_conta+ 1;
          end if;    
              
      
      end loop;
      commit;
      
      /*Graba log*/
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_T';
    commit;
      
      pn_resp := 1;
      exception when others then 
      dbms_output.put_line(sqlerrm);
            pn_resp :=0;
        
  end sp_tiempo_potencial_j;
-----------------------------------------------------------------------------
Procedure sp_job_volumen_credito(pd_fecha  in date
                                   )             
    is
 -- *****************************************************************
    -- Nombre                     : sp_job_volumen_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO INICIAL )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
     
    --ln_max number;
    --ln_inc number;
    lv_ini varchar2(3);
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    lv_fecha varchar(10);
    --lc_coderr varchar2(300);
   
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --execute immediate ('truncate table UAI_ACLPRE');
    /*borrar de la tabla*/
   --delete from AQPB833 t where t.aqpb833fec = pd_fecha;
   --commit;
    
   /*calculamos fecha de proceso*/
   lv_fecha := to_char(pd_fecha,'dd/mm/rrrr');
   
    delete Tab_jobs where c_Codage = 'POTEN_V';
    commit;
    for i in 0..99 loop
      lv_ini      := lpad(i,2,'0');
      lc_variable := ' begin ' || '  pq_cr_potencial_pyme.sp_volumen_credito_j(''' || lv_ini || ''',' || 'TO_DATE( ''' ||
                     lv_fecha || ''', ''DD/MM/RRRR''  ' ||  '));' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('POTEN_V', 1*lv_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'POTEN_V', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_volumen_credito;
---------------------------------------------------------------------------------------

  procedure sp_volumen_credito_j(                                   
                                    pv_cod in varchar,
                                    pd_fecha  in date     
                                   
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_volumen_credito_j
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/04/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Procesa la variable de volumen creditos 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo, t.aqpb833csbs from aqpb833 t
      where t.aqpb833fec = pd_fecha
      and substr(trim(t.aqpb833ndo),-2,2) = pv_cod
      --and t.aqpb833ndo = '16160851'
      --and rownum <= 100000
    --where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meseva number(15,2):=0;
    pn_result number(15,2) :=0;
    ln_minpot number(15,2) :=0;
    lc_minpot char(2) :='';
    
begin
    pn_result := 0; --
    
     /*insertar log*/
      update tab_jobs g
       set g.d_fecini = sysdate
      where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_V';
      commit; 
             
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
   
      begin 
       select t.tp1nro1
        into ln_meseva 
        from  FST198 t       
          Where t.Tp1cod   = 1
          and t.Tp1cod1  = 11155 
          and t.Tp1corr1 = 3 
          and t.Tp1corr2 = 1 
          and t.Tp1corr3 = 1; 
      exception when others then
        ln_meseva := 0;
      end; 
      
      /*limite de meses de historial rcc*/
      begin 
          select t.tp1nro1 into ln_minpot 
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11155  
         and t.tp1corr1 = 400        
         and t.tp1corr2 = 1;
      exception when others then 
          ln_minpot := 24; 
      end;    
    
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_volumen_cliente_j(
                                                       pd_fecfin => ld_fecrcc,
                                                       pn_meses_eva => ln_meseva,
                                                       pn_pgpais => ti.aqpb833pai,
                                                       pn_tipdoc => ti.aqpb833tdo,
                                                       pc_numdoc => ti.aqpb833ndo,
                                                       pv_codsbs => ti.aqpb833csbs,
                                                       pn_saldos => ln_saldos,
                                                       pn_cuotas => ln_cuotas,
                                                       pn_volumen => ln_volumen,
                                                       pn_escala => ln_escala);     
            
            /*actualiza campo de potencial bajo*/
            
            if ln_minpot > nvl(ln_cuotas,0)   then
                 lc_minpot := 'MB';
              else
                lc_minpot := '';
            end if; 
            
                      
            /*actualiza la tabla de clientes*/        
            update aqpb833 u
               set u.aqpb833va2 = ln_escala,
                   u.aqpb833var2 = 'VOLUMEN='||ln_saldos,
                   u.aqpb833var3 = 'TIEMPO_ACT='||ln_cuotas,    
                   u.aqpb833var7 = lc_minpot               
             where u.aqpb833fec = ti.aqpb833fec
               and u.aqpb833pai = ti.aqpb833pai
               and u.aqpb833tdo = ti.aqpb833tdo
               and u.aqpb833ndo = ti.aqpb833ndo;
            
         
              /*commit en 1000 en 1000*/
              if ln_conta = 100 then 
                commit;
                ln_conta :=0;
              else
                ln_conta := ln_conta+ 1;
              end if;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb833ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
      
      /*Graba log*/
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_V';
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_volumen_credito_j;

--------------------------------------------------------------------------------------------
 procedure sp_volumen_cliente_j(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pv_codsbs varchar,
                                pn_saldos out number,
                                pn_cuotas out number,
                                pn_volumen out number,
                                pn_escala out number
                                ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_volumen_cliente_j
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna el volumen de credito por cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 12/10/2022  yyampi ultimo cambio de jose francisco con el tema de rubros para calculos de volumen y recurrencia solo el rubro 14 y para el calculo de primera fecha en el rcc se toma 14, 72 y 83
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva number; --meses de evaluacion 
    ld_fecrcci date; --fecha de inicio carga RCC
    pn_result number;
    pv_numdoc varchar(12); 
begin
  pn_result := 0.00; 
  --pv_result := 'S';
  
    begin          
      ld_fecrcci := add_months(pd_fecfin, -1*pn_meses_eva);            
     exception when others then
        ln_meseva := 0;
        ld_fecrcci := null;
    end;
      
                    
  /*Calculo de meses de antiguedad*/
  
        begin 
           /*cambio 12/10/2022  yyampi ultimo cambio de jose francisco con el tema de rubros*/ 
            select /*+ all_rows */ sum(c.n_salcap) , count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
             into pn_saldos ,  pn_cuotas
             FROM CLDRCCS C 
                    WHERE C.C_CODSBS = pv_codsbs --A.CODSBS
                      AND C.D_FECPRE between ld_fecrcci and pd_fecfin
                      --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                     AND ( (SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                           SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6'))
                     /*OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                     OR
                     (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS      
                       */    ) --CREDITOS DIRECTOS
                      
                      AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                          from FST198 T 
                                            WHERE t.Tp1cod   = 1
                                            AND t.Tp1cod1  = 11155 
                                            AND t.Tp1corr1 = 1 
                                            AND t.Tp1corr2 = 1) ; 
                   
                   if pn_cuotas > 0 then
                     pn_volumen := pn_saldos/pn_cuotas;                      
                   else 
                      pn_volumen :=0; 
                   end if ;
                   
                   /*calcular la escala*/
                   if  pn_volumen >=0 and pn_volumen <= 2500 then 
                       pn_escala := 1;
                     else
                       if pn_volumen > 2500 and pn_volumen <= 5000 then
                         pn_escala := 2;
                         else
                           if pn_volumen > 5000 and pn_volumen <= 10000  then
                             pn_escala := 3;
                           else 
                               if pn_volumen > 10000 and pn_volumen <= 25000  then
                                 pn_escala := 4;
                               else 
                                   if pn_volumen > 25000 then
                                      pn_escala := 5;
                                   end if;
                               end if;
                           end if;
                       end if;      
                   end if; 
                          
                                       
         exception when others then 
                   pn_result :=0;
                   pn_saldos :=0;
                   pn_cuotas :=0;
                   pn_volumen :=0;
                   
                   --pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     pn_saldos :=0;
     pn_cuotas :=0;
     pn_volumen :=0;
     --pv_result :='S'; 
  
end sp_volumen_cliente_j;
-----------------------------------------------------------------------------------------------

Procedure sp_job_recurrencia_credito(pd_fecha  in date
                                   )             
    is
 -- *****************************************************************
    -- Nombre                     : sp_job_recurrencia_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO INICIAL )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
     
    --ln_max number;
    --ln_inc number;
    lv_ini varchar2(3);
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    lv_fecha varchar(10);
    --lc_coderr varchar2(300);
   
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --execute immediate ('truncate table UAI_ACLPRE');
    /*borrar de la tabla*/
   --delete from AQPB833 t where t.aqpb833fec = pd_fecha;
   --commit;
    
   /*calculamos fecha de proceso*/
   lv_fecha := to_char(pd_fecha,'dd/mm/rrrr');
   
    delete Tab_jobs where c_Codage = 'POTEN_R';
    commit;
    for i in 0..99 loop
      lv_ini      := lpad(i,2,'0');
      lc_variable := ' begin ' || '  pq_cr_potencial_pyme.sp_recurrencia_credito_j(''' || lv_ini || ''',' || 'TO_DATE( ''' ||
                     lv_fecha || ''', ''DD/MM/RRRR''  ' ||  '));' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('POTEN_R', 1*lv_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'POTEN_R', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_recurrencia_credito;
-------------------------------------------------------------------------------------
procedure sp_recurrencia_credito_j(                                   
                                    pv_cod in varchar,
                                    pd_fecha  in date 
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_recurrencia_credito_j
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Procesa la variable de recurrencia de credito 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo, t.aqpb833csbs from aqpb833 t
      where t.aqpb833fec = pd_fecha
      and substr(trim(t.aqpb833ndo),-2,2) = pv_cod
      --and t.aqpb833ndo = '16160851'
      --and rownum <= 10000
    --where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meses_eva number(15,2) :=0;
    ln_meses_con number(16,2);
    ln_meses_act  number(16,2);
    ln_recurrencia number(16,2);
    pn_result number(15,2);
    --ln_escala number(16,2);      
    
begin
  pn_result := 0; --
  
    /*insertar log*/
      update tab_jobs g
       set g.d_fecini = sysdate
      where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_R';
      commit;   
  
          
  /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
  /*obtencion de 10 años para evaluar guia de proceso*/
  select t.tp1nro1 into ln_meses_eva
         from FST198 T 
    WHERE t.Tp1cod   = 1
     AND t.Tp1cod1  = 11155 
     and t.tp1corr1 = 3
     and t.tp1corr2 = 1
     and t.tp1corr3 = 1;
  
  
  
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_recurrencia_cliente_j(pd_fecfin      => ld_fecrcc,
                                                           pn_meses_eva   => ln_meses_eva,
                                                           pn_pgpais      => ti.aqpb833pai, 
                                                           pn_tipdoc      => ti.aqpb833tdo,
                                                           pc_numdoc      => ti.aqpb833ndo,
                                                           pv_codsbs      => ti.aqpb833csbs,
                                                           pn_meses_con   => ln_meses_con,
                                                           pn_meses_act   => ln_meses_act,
                                                           pn_recurrencia => ln_recurrencia,
                                                           pn_escala      => ln_escala)
                                                           ;     
            
                       
            /*actualiza la tabla de clientes*/        
            update aqpb833 u
               set u.aqpb833va3 = ln_escala,
                   u.aqpb833var4 = 'TIEMPO_ACT='||ln_meses_act,
                   u.aqpb833var5 = 'TIEMPO_CON='||ln_meses_con                   
             where u.aqpb833fec = ti.aqpb833fec
               and u.aqpb833pai = ti.aqpb833pai
               and u.aqpb833tdo = ti.aqpb833tdo
               and u.aqpb833ndo = ti.aqpb833ndo;
            
         
              /*commit en 1000 en 1000*/
              if ln_conta = 100 then 
                commit;
                ln_conta :=0;
              else
                ln_conta := ln_conta+ 1;
              end if;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb833ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
      
      /*Graba log*/
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_R';
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_recurrencia_credito_j;
--------------------------------------------------------------------------------------------

    procedure sp_recurrencia_cliente_j(
                                pd_fecfin date,
                                pn_meses_eva number,
                                pn_pgpais number,
                                pn_tipdoc number,
                                pc_numdoc char,
                                pv_codsbs varchar,
                                pn_meses_con out number,
                                pn_meses_act out number,
                                pn_recurrencia out number,
                                pn_escala out number
                                ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_recurrencia_cliente_j
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/03/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna la recurrencia de un cliente de meses activos / meses consumidos 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 12/10/2022  yyampi ultimo cambio de jose francisco con el tema de rubros para calculos de volumen y recurrencia solo el rubro 14 y para el calculo de primera fecha en el rcc en recurrencia se toma 14, 72 y 83
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva number; --meses de evaluacion 
    ld_fecrcci date; --fecha de inicio carga RCC
    pn_result number;
    pv_numdoc varchar(12); 
    ln_meses_act number(15);
    ln_meses_con number(15);
    ld_fecini date; 
    --ln_meses number
    
begin
  pn_result := 0.00; 
  --pv_result := 'S';
  
     /*fecha de ultima carga del RCC */
     /*begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then
           ld_fecrcc := null;   
      end; */
      
      /*obtener fecha del primer credito*/
      
      
      begin 
        
        /*se calcula la fecha de inicio */  
          ld_fecrcci := add_months(pd_fecfin, -1*pn_meses_eva/*ln_meseva*/);
            
      exception when others then
        ln_meseva := 0;
        ld_fecrcci := null;
      end;
      
        
      
             
  
  
        begin  
            /*cambio 12/10/2022  yyampi ultimo cambio de jose francisco con el tema de rubros*/
            /*Calculo de meses de antiguedad*/
            begin 
                select /*+ all_rows */  count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
                 into   pn_meses_act
                 FROM CLDRCCS C 
                        WHERE C.C_CODSBS = pv_codsbs --A.CODSBS
                          AND C.D_FECPRE between ld_fecrcci and pd_fecfin
                          --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                         AND ( (SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                               SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6'))
                        /* OR
                         (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                         OR
                         (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS      
                            */   ) --CREDITOS DIRECTOS
                          
                         /*tipos de creditos SBS a considerar en el calculo */
                          AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                              from FST198 T 
                                                WHERE t.Tp1cod   = 1
                                                AND t.Tp1cod1  = 11155 
                                                AND t.Tp1corr1 = 1 
                                                AND t.Tp1corr2 = 1) ; 
                                                
                   exception when others then
                     pn_meses_act :=0;
                   end;                             
                   
                   /*cambio 12/10/2022  yyampi ultimo cambio de jose francisco con el tema de rubros*/                         
                  /*Calculo de fecha del primer credito en el SF*/
                  begin 
                        select /*+ all_rows */ min(c.d_fecpre) fecha_ini --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
                         into ld_fecini 
                         FROM CLDRCCS C 
                                WHERE C.C_CODSBS = pv_codsbs --A.CODSBS
                                 -- AND C.D_FECPRE between ld_fecrcci and pd_fecfin
                                  --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
                                 AND ( (SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
                                       SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6'))
                                 OR
                                 (SUBSTR(C.C_CUENTA, 1, 2) = '72' AND SUBSTR(C.C_CUENTA, 4, 1) = '5') ------LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
                                 /*OR
                                 (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2','3', '4'))--CREDITOS INDIRECTOS
                                 */
                                 OR
                                 (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND SUBSTR(C.C_CUENTA, 4, 3)='302')--CREDITOS CASTIGADOS      
                                       ) --CREDITOS DIRECTOS
                                  
                                 /* AND C.C_CRETIP IN ( select SUBSTR(T.TP1DESC,1,2) 
                                                      from FST198 T 
                                                        WHERE t.Tp1cod   = 1
                                                        AND t.Tp1cod1  = 11155 
                                                        AND t.Tp1corr1 = 1 
                                                        AND t.Tp1corr2 = 1)*/ ; 
                                                
                   exception when others then
                     ld_fecini := null;
                   end;                            
                   
                   /*se calcular la fecha menor*/
                   /*if ld_fecrcci < ld_fecini then
                       ld_fecini := ld_fecrcci;                      
                     end if;*/
                     
                     /*calculo de meses consumidos*/
                     if ld_fecini is null then 
                       pn_meses_con :=0;
                     else 
                       if ld_fecini < ld_fecrcci then 
                         pn_meses_con := 120;
                       else 
                           pn_meses_con := trunc(MONTHS_BETWEEN(pd_fecfin, ld_fecini));--+1; 
                         end if;  
                     end if;
                                        
                   
                   if pn_meses_con > 0 then
                     pn_recurrencia := pn_meses_act/pn_meses_con;                      
                   else 
                      pn_recurrencia :=0; 
                   end if ;
                   
                   /*calcular la escala*/
                   if  pn_recurrencia >=0 and pn_recurrencia <= 0.2 then 
                       pn_escala := 1;
                     else
                       if pn_recurrencia > 0.2 and pn_recurrencia <= 0.4 then
                         pn_escala := 2;
                         else
                           if pn_recurrencia > 0.4 and pn_recurrencia <= 0.6  then
                             pn_escala := 3;
                           else 
                               if pn_recurrencia > 0.6 and pn_recurrencia <= 0.8  then
                                 pn_escala := 4;
                               else 
                                   if pn_recurrencia > 0.8 then
                                      pn_escala := 5;
                                   end if;
                               end if;
                           end if;
                       end if;      
                   end if; 
                          
                                       
         exception when others then 
                   pn_result :=0;
                   ln_meses_con :=0;
                   pn_meses_act :=0;
                   pn_recurrencia :=0;
                   pn_escala := null;
                   --pv_result :='S';
         end;                
        
            
   exception
    WHEN OTHERS THEN
     pn_result :=0; 
     ln_meses_con :=0;
     pn_meses_act :=0;
     pn_recurrencia :=0;
     pn_escala := null;
     --pv_result :='S'; 
  
end sp_recurrencia_cliente_j;
------------------------------------------------------------------------------------------



Procedure sp_job_resultado_credito(pd_fecha  in date
                                   )             
    is
 -- *****************************************************************
    -- Nombre                     : sp_job_recurrencia_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA EL CODIGO SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO INICIAL )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
     
    --ln_max number;
    --ln_inc number;
    lv_ini varchar2(3);
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    lv_fecha varchar(10);
    --lc_coderr varchar2(300);
   
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --execute immediate ('truncate table UAI_ACLPRE');
    /*borrar de la tabla*/
   --delete from AQPB833 t where t.aqpb833fec = pd_fecha;
   --commit;
    
   /*calculamos fecha de proceso*/
   lv_fecha := to_char(pd_fecha,'dd/mm/rrrr');
   
    delete Tab_jobs where c_Codage = 'POTEN_F';
    commit;
    for i in 0..99  loop
      lv_ini      := lpad(i,2,'0');
      lc_variable := ' begin ' || '  pq_cr_potencial_pyme.sp_resultado_credito_j(''' || lv_ini || ''',' || 'TO_DATE( ''' ||
                     lv_fecha || ''', ''DD/MM/RRRR''  ' ||  '));' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('POTEN_F', 1*lv_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'POTEN_F', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_resultado_credito;
-------------------------------------------------------------------------------------
procedure sp_resultado_credito_j(                                   
                                    pv_cod in varchar,
                                    pd_fecha  in date 
                                    ) is                                              
-- *****************************************************************
    -- Nombre                     : sp_recurrencia_credito_j
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Procesa la variable de recurrencia de credito 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo, t.aqpb833csbs, t.aqpb833var7 from aqpb833 t
      where t.aqpb833fec = pd_fecha
      and substr(trim(t.aqpb833ndo),-2,2) = pv_cod
      --and t.aqpb833ndo in ('001614616', '001705816','001716616')
      --and t.aqpb833ndo = '16160851'
      --and rownum <= 10000
    --where r.ctnro = pn_cta    
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meses_eva number(15,2) :=0;
    ln_meses_con number(16,2);
    ln_meses_act  number(16,2);
    ln_recurrencia number(16,2);
    pn_result number(15,2);
    ln_poten number(15,2):=0;
    lv_aqpb833ndo varchar(12);
    ln_relacre number(16):=0;
    ln_potenf number(15,2):=0;
    --ln_escala number(16,2);      
    
begin
  pn_result := 0; --
  
    /*insertar log*/
      update tab_jobs g
       set g.d_fecini = sysdate
      where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_F';
      commit;   
  
  
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
        
            --lv_aqpb833ndo := ti.aqpb833ndo;
            
            
            
           /* pq_cr_relcrediticia_a.sp_cr_recalcula(pn_pais     => ti.aqpb833pai,
                                                  pn_tdo      => ti.aqpb833tdo,
                                                  pc_ndo      => ti.aqpb833ndo,
                                                  pd_fecpro   => ti.aqpb833fec,
                                                  ln_contador => ln_relacre);*/
            
            pq_cr_potencial_pyme.sp_potencial_cliente2(pd_fecha => ti.aqpb833fec,
                                                      pn_pais  => ti.aqpb833pai,
                                                      pn_tdoc  => ti.aqpb833tdo,
                                                      pc_ndoc  => ti.aqpb833ndo,
                                                      pn_poten => ln_poten);                        
      
                 
                                  
            /*actualiza la tabla de clientes*/
            if ti.aqpb833var7 = 'MB' then
               ln_potenf := 5;
            else
              ln_potenf := ln_poten;
              end if;   
                    
            update aqpb833 u
               set u.aqpb833va4 = ln_potenf                             
             where u.aqpb833fec = ti.aqpb833fec
               and u.aqpb833pai = ti.aqpb833pai
               and u.aqpb833tdo = ti.aqpb833tdo
               and u.aqpb833ndo = ti.aqpb833ndo;
            
            
         
              /*commit en 1000 en 1000*/
              if ln_conta = 100 then 
                commit;
                ln_conta :=0;
              else
                ln_conta := ln_conta+ 1;
              end if;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb833ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
      
      /*Graba log*/
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pv_cod*1
       and g.c_codage = 'POTEN_F';
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_resultado_credito_j;

------------------------------------------------------------------------------------------

Procedure sp_potencial_cliente2(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_potencial_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE POTENCIAL POR CLIENTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
    lc_tipper char(1) := '';
  begin
  
    begin
    
      /*obtener el valor del potencial del cliente*/
      select 
               decode(t.aqpb833va1,0,1,t.aqpb833va1)*
               decode(t.aqpb833va2,0,1,t.aqpb833va2)*
               decode(t.aqpb833va3,0,1,t.aqpb833va3) potval,  
               substr(t.aqpb833var6,-1,1) tipper             
              into ln_potval, lc_tipper
        from AQPB833 t
       where t.aqpb833fec = pd_fecha
         and t.aqpb833pai = pn_pais
         and t.aqpb833tdo = pn_tdoc
         and t.aqpb833ndo = pc_ndoc
         and t.aqpb833est = 'S';
      
      if lc_tipper = 'N' then  -- personas naturales 
          select t.tp1corr3
            into ln_potencial
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11155
             and t.tp1corr1 = 100
             and t.tp1corr2 = 1
             and ln_potval between t.tp1nro1 and t.tp1nro2;
       else -- personas juridicas 
           
           select t.tp1corr3
            into ln_potencial
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11155
             and t.tp1corr1 = 300
             and t.tp1corr2 = 1
             and ln_potval between t.tp1imp1 and t.tp1imp2;
           
       end if;      
          
      pn_poten := ln_potencial;    
      
      
    exception
      when others then
       -- dbms_output.put_line( sqlerrm);
       pn_poten := 5;  --caso de no haber nada por default 5 (muy bajo) cambio solicitado por parametrizacion
    end;  
     
    --pn_poten := ln_potencial;  
  
  end sp_potencial_cliente2;
----------------------------------------------------------------------------- 


Procedure sp_potencial_cliente_linea(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number                     
                        )  is
 
  -- *****************************************************************
    -- Nombre                     : sp_potencial_cliente_linea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.20
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE POTENCIAL POR CLIENTE EN LINEA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
     ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
    lc_tipper char(1) := '';
    lv_msgerr varchar(40) :='';
    lc_coderr char(5) := '';
  begin
     /*borra tabla de calculos por cliente*/
     begin
       delete from AQPB835 t
        where t.aqpb835fec = pd_fecha
          and t.aqpb835pai = pn_pais
          and t.aqpb835tdo = pn_tdoc
          and t.aqpb835ndo = pc_ndoc;
          commit;
     exception when others then
         lc_coderr := '00001'; 
         lv_msgerr := substr(sqlerrm,1,40); 
       end;  
  
    /*calculo de tiempo*/
    begin
      pq_cr_potencial_pyme.sp_tiempo_potencial_l(pd_fecha => pd_fecha,
                                                 pn_pais  => pn_pais,
                                                 pn_tdoc  => pn_tdoc,
                                                 pc_ndoc  => pc_ndoc);
    exception
      when others then
        pn_poten := 5;
    end;
    
    /*calculo de volumen*/
    begin
      pq_cr_potencial_pyme.sp_volumen_credito_l(pd_fecha => pd_fecha,
                                                pn_pais  => pn_pais,
                                                pn_tdoc  => pn_tdoc,
                                                pc_ndoc  => pc_ndoc);
    exception
      when others then
        pn_poten := 5;
    end;
        
    /*calculo de recurrencia*/  
    begin
      pq_cr_potencial_pyme.sp_recurrencia_credito_l(pd_fecha => pd_fecha,
                                                    pn_pais  => pn_pais,
                                                    pn_tdoc  => pn_tdoc,
                                                    pc_ndoc  => pc_ndoc);
    exception
      when others then
        pn_poten := 5;
    end;
        
   /*calculo resultado */
   begin
      pq_cr_potencial_pyme.sp_resultado_credito_l(pd_fecha => pd_fecha,
                                                    pn_pais  => pn_pais,
                                                    pn_tdoc  => pn_tdoc,
                                                    pc_ndoc  => pc_ndoc,
                                                    pn_pote => pn_poten);
    exception
      when others then
        pn_poten := 5;
    end;
     
  
  
              
   
  end sp_potencial_cliente_linea;

--------------------------------------------------------------------------------------------  
Procedure sp_tiempo_potencial_l(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_tiempo_potencial_l
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.04.08
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL TIEMPO POTENCIAL (EDAD) 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais (PAIS)
    --                            : pn_tdoc (TIPO DE DOCUMENTO)
    --                            : pc_ndoc (NUMERO DE DOCUMENTO)
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    
    /*cursor que calcula la edad de todos los clientes y su rango */   
    cursor c_cliente1(p_fecini date, p_fecfin date) is
          /*proceso de edad*/
          select /*+ all_rows */
           pfpais,
           pftdoc,
           pfndoc,
           edad,
           case
             when tipper = 'J' then
              0
             when tipper = 'N' and edad > 58 then
              1
             when tipper = 'N' and edad > 51 and edad <= 58 then
              2
             when tipper = 'N' and edad > 44 and edad <= 51 then
              3
             when tipper = 'N' and edad > 36 and edad <= 44 then
              4
             when tipper = 'N' and edad >= 0 and edad <= 36 then
              5
           end valor,
           fn_codsbs_cliente(pd_fecini => p_fecini,
                             pd_fecfin => p_fecfin,
                             pn_pgpais => pfpais,
                             pn_tipdoc => pftdoc,
                             pc_numdoc => pfndoc) csbs,
           tipper
            from (
                  /*personas naturales*/
                  select /*+ all_rows */
                  distinct t.pfpais,
                            t.pftdoc,
                            t.pfndoc,
                            t.pffnac,
                            trunc(months_between(pd_fecha, t.pffnac) / 12) edad,
                            'N' tipper
                    from fsd002 t--, fsr008 r
                   where /*t.pfpais = r.pepais
                     and t.pftdoc = r.petdoc
                     and t.pfndoc = r.pendoc
                     and*/ t.pfpais = pn_pais
                     and t.pftdoc = pn_tdoc
                     and t.pfndoc = pc_ndoc
                 
                  union
                  /*personas juridicas*/
                  select /*+ all_rows */
                  distinct t.pjpais,
                            t.pjtdoc,
                            t.pjndoc,
                            t.pjfcon,
                            trunc(months_between(pd_fecha, t.pjfcon) / 12) edad,
                            'J' tipper
                    from fsd003 t--, fsr008 r
                   where /*t.pjpais = r.pepais
                     and t.pjtdoc = r.petdoc
                     and t.pjndoc = r.pendoc
                     and */t.pjpais = pn_pais
                     and t.pjtdoc = pn_tdoc
                     and t.pjfcon = pc_ndoc);
          
          
         cursor c_cliente2(p_fecini date, p_fecfin date) is
          /*proceso de edad*/
          select /*+ all_rows */ pfpais, pftdoc, pfndoc, edad, 
          case 
            when tipper = 'J' then 0
            when tipper = 'N' and edad > 58 then 1  
            when tipper = 'N' and edad > 51 and edad <=58 then 2
            when tipper = 'N' and edad > 44 and edad <=51 then 3
            when tipper = 'N' and edad > 36 and edad <=44 then 4
            when tipper = 'N' and edad >= 0 and edad <=36 then 5    
            end  valor, 
            pq_cr_potencial_pyme.fn_codsbs_cliente(pd_fecini => p_fecini,
                                                  pd_fecfin => p_fecfin,
                                                  pn_pgpais => pfpais,
                                                  pn_tipdoc => pftdoc,
                                                  pc_numdoc => pfndoc2) csbs, 
            tipper                  
            from (
          /*personas reniec BI */  
          select /*+ all_rows */ 
          distinct 604 pfpais, decode(t.aqpb834tipdoc,1,21,0) pftdoc, t.aqpb834numdoc pfndoc,pc_ndoc pfndoc2 ,to_date(t.aqpb834naci,'dd/mm/rr') pffnac, 
           case when trunc(months_between(pd_fecha,to_date(t.aqpb834naci,'dd/mm/rrrr'))/12) <=0 then
               trunc(months_between(pd_fecha,to_date(substr(t.aqpb834naci,1,6)||'19'||substr(t.aqpb834naci,7,2),'dd/mm/rrrr'))/12)
          else 
            trunc(months_between(pd_fecha,to_date(t.aqpb834naci,'dd/mm/rrrr'))/12)
            end edad, 'N' tipper  
          from aqpb834 t where t.aqpb834numdoc =  trim(pc_ndoc))
          ; 
           
    
    ln_conta number(15) :=0;  --valor sin respuesta
    ln_meses_eva  number(16);
    ld_fecrcc date ;
    ld_fecrcci date ;
    pn_resp number(10);
    ln_existe number(10):=0;
  begin
      
     /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
    /*obtencion de 10 años para evaluar guia de proceso*/
    begin 
      select t.tp1nro1 into ln_meses_eva
             from FST198 T 
        WHERE t.Tp1cod   = 1
         AND t.Tp1cod1  = 11155 
         and t.tp1corr1 = 3
         and t.tp1corr2 = 1
         and t.tp1corr3 = 1;
       exception when others then 
          ln_meses_eva := null;
      end;           

      begin 
        ld_fecrcci := add_months(ld_fecrcc,-1*ln_meses_eva);
      exception when others then 
        ld_fecrcci := null;  
      end;

      /*obtener el valor del potencial del cliente*/
      for c in c_cliente1(ld_fecrcci,ld_fecrcc ) loop        
          begin 
            insert into AQPB835
              (AQPB835FEC,
               AQPB835PAI,
               AQPB835TDO,
               AQPB835NDO,
               AQPB835EST,
               AQPB835CSBS,
               AQPB835VA1,
               AQPB835VAR1, 
               AQPB835VAR6                              
               )
            values
              (pd_fecha, c.pfpais, c.pftdoc, c.pfndoc, 'S',c.csbs, c.valor, 'EDAD='||c.edad, 'TIP PER='||c.tipper);
              commit;
          exception when others then 
            dbms_output.put_line(c.pfndoc||'-'|| sqlerrm);
            pn_resp :=0;
          end;        
      end loop;
      commit;
      
      /*si no existe registro consulta reniec */
      begin
        select count(*)
          into ln_existe
          from AQPB835 t
         where t.aqpb835fec = pd_fecha
           and t.aqpb835pai = pn_pais
           and t.aqpb835tdo = pn_tdoc
           and t.aqpb835ndo = pn_tdoc;
      exception
        when others then
          ln_existe := 0;
      end;
      
      
      if  ln_existe = 0  then     
          /*consulta base de reniec*/
          for c in c_cliente2(ld_fecrcci,ld_fecrcc ) loop        
              begin 
                insert into AQPB835
                  (AQPB835FEC,
                   AQPB835PAI,
                   AQPB835TDO,
                   AQPB835NDO,
                   AQPB835EST,
                   AQPB835CSBS,
                   AQPB835VA1,
                   AQPB835VAR1, 
                   AQPB835VAR6                              
                   )
                values
                  (pd_fecha, c.pfpais, c.pftdoc, c.pfndoc, 'S',c.csbs, c.valor, 'EDADR='||c.edad, 'TIP PER='||c.tipper);
                  commit;
              exception when others then 
                dbms_output.put_line(c.pfndoc||'-'|| sqlerrm);
                pn_resp :=0;
              end;        
          end loop;
          commit;
      end if;
      
      
      
     /* pn_resp := 1;
      exception when others then 
      dbms_output.put_line(sqlerrm);
            pn_resp :=0;*/
        
  end sp_tiempo_potencial_l;
-------------------------------------------------------------------------------------------

 procedure sp_volumen_credito_l(                                   
                                    pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pc_ndoc   in char     
                                   
                                    ) is                                              
  -- *****************************************************************
    -- Nombre                     : sp_volumen_credito_l
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.04.08
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VOLUMEN (SALDOS RCC) 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais (PAIS)
    --                            : pn_tdoc (TIPO DE DOCUMENTO)
    --                            : pc_ndoc (NUMERO DE DOCUMENTO)
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb835fec, t.aqpb835pai, t.aqpb835tdo, t.aqpb835ndo, t.aqpb835csbs from aqpb835 t
      where t.aqpb835fec = pd_fecha
      and t.aqpb835pai = pn_pais
      and t.aqpb835tdo = pn_tdoc
      and t.aqpb835ndo = pc_ndoc         
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meseva number(15,2):=0;
    pn_result number(15,2) :=0;
    ln_minpot number(15,2) :=0;
    lc_minpot char(2) :='';
    
begin
    pn_result := 0; --
    
    
             
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
   
      begin 
       select t.tp1nro1
        into ln_meseva 
        from  FST198 t       
          Where t.Tp1cod   = 1
          and t.Tp1cod1  = 11155 
          and t.Tp1corr1 = 3 
          and t.Tp1corr2 = 1 
          and t.Tp1corr3 = 1; 
      exception when others then
        ln_meseva := 0;
      end; 
      
      /*limite de meses de historial rcc*/
      begin 
          select t.tp1nro1 into ln_minpot 
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11155  
         and t.tp1corr1 = 400        
         and t.tp1corr2 = 1;
      exception when others then 
          ln_minpot := 24; 
      end;    
    
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_volumen_cliente_j(
                                                       pd_fecfin => ld_fecrcc,
                                                       pn_meses_eva => ln_meseva,
                                                       pn_pgpais => ti.aqpb835pai,
                                                       pn_tipdoc => ti.aqpb835tdo,
                                                       pc_numdoc => ti.aqpb835ndo,
                                                       pv_codsbs => ti.aqpb835csbs,
                                                       pn_saldos => ln_saldos,
                                                       pn_cuotas => ln_cuotas,
                                                       pn_volumen => ln_volumen,
                                                       pn_escala => ln_escala);     
            
            /*actualiza campo de potencial bajo*/
            
            if ln_minpot > nvl(ln_cuotas,0)   then
                 lc_minpot := 'MB';
              else
                lc_minpot := '';
            end if; 
            
                      
            /*actualiza la tabla de clientes*/        
            update aqpb835 u
               set u.aqpb835va2 = ln_escala,
                   u.aqpb835var2 = 'VOLUMEN='||ln_saldos,
                   u.aqpb835var3 = 'TIEMPO_ACT='||ln_cuotas,    
                   u.aqpb835var7 = lc_minpot               
             where u.aqpb835fec = ti.aqpb835fec
               and u.aqpb835pai = ti.aqpb835pai
               and u.aqpb835tdo = ti.aqpb835tdo
               and u.aqpb835ndo = ti.aqpb835ndo;                           
               commit;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb835ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;    
     
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_volumen_credito_l;

---------------------------------------------------------------------------------------------
procedure sp_recurrencia_credito_l(                                   
                                    pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pc_ndoc   in char  
                                    ) is                                              
  -- *****************************************************************
    -- Nombre                     : sp_recurrencia_credito_l
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.04.08
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA LA RECURRENCIA (EXISTENCIA EN RCC) 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais (PAIS)
    --                            : pn_tdoc (TIPO DE DOCUMENTO)
    --                            : pc_ndoc (NUMERO DE DOCUMENTO)
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb835fec, t.aqpb835pai, t.aqpb835tdo, t.aqpb835ndo, t.aqpb835csbs from aqpb835 t
      where t.aqpb835fec = pd_fecha
      and t.aqpb835pai =  pn_pais
      and t.aqpb835tdo =  pn_tdoc
      and t.aqpb835ndo =  pc_ndoc       
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meses_eva number(15,2) :=0;
    ln_meses_con number(16,2);
    ln_meses_act  number(16,2);
    ln_recurrencia number(16,2);
    pn_result number(15,2);
    --ln_escala number(16,2);      
    
begin
  pn_result := 0; --
  
             
  /*fecha de ultima carga del RCC */
     begin
        select to_date(Tpnro, 'dd.mm.yyyy')
          into ld_fecrcc  --fecha fin
          from Fst098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception when others then 
          ld_fecrcc := null;
      end; 
   
  /*obtencion de 10 años para evaluar guia de proceso*/
  select t.tp1nro1 into ln_meses_eva
         from FST198 T 
    WHERE t.Tp1cod   = 1
     AND t.Tp1cod1  = 11155 
     and t.tp1corr1 = 3
     and t.tp1corr2 = 1
     and t.tp1corr3 = 1;
  
  
  
  for ti in titulares  loop   
       
      --t.aqpb833fec, t.aqpb833pai, t.aqpb833tdo, t.aqpb833ndo
      begin 
            pq_cr_potencial_pyme.sp_recurrencia_cliente_j(pd_fecfin      => ld_fecrcc,
                                                           pn_meses_eva   => ln_meses_eva,
                                                           pn_pgpais      => ti.aqpb835pai, 
                                                           pn_tipdoc      => ti.aqpb835tdo,
                                                           pc_numdoc      => ti.aqpb835ndo,
                                                           pv_codsbs      => ti.aqpb835csbs,
                                                           pn_meses_con   => ln_meses_con,
                                                           pn_meses_act   => ln_meses_act,
                                                           pn_recurrencia => ln_recurrencia,
                                                           pn_escala      => ln_escala)
                                                           ;     
            
                       
            /*actualiza la tabla de clientes*/        
            update aqpb835 u
               set u.aqpb835va3 = ln_escala,
                   u.aqpb835var4 = 'TIEMPO_ACT='||ln_meses_act,
                   u.aqpb835var5 = 'TIEMPO_CON='||ln_meses_con                   
             where u.aqpb835fec = ti.aqpb835fec
               and u.aqpb835pai = ti.aqpb835pai
               and u.aqpb835tdo = ti.aqpb835tdo
               and u.aqpb835ndo = ti.aqpb835ndo;
                    
                commit;
              
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb835ndo||'-'||sqlerrm);           
      end;
      end loop;
      commit ;
      
   
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
  
end sp_recurrencia_credito_l;

--------------------------------------------------------------------

procedure sp_resultado_credito_l(                                   
                                    pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pc_ndoc   in char, 
                                    pn_pote  out number  
                                    ) is                                              
  -- *****************************************************************
    -- Nombre                     : sp_resultado_credito_l
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL RESULTADO (POTENCIALIDAD) 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais (PAIS)
    --                            : pn_tdoc (TIPO DE DOCUMENTO)
    --                            : pc_ndoc (NUMERO DE DOCUMENTO)
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    
    cursor titulares is 
      select /*+ all_rows */ distinct 
      t.aqpb835fec, t.aqpb835pai, t.aqpb835tdo, t.aqpb835ndo, t.aqpb835csbs, t.aqpb835var7 from aqpb835 t
      where t.aqpb835fec = pd_fecha
      and t.aqpb835pai = pn_pais
      and t.aqpb835tdo = pn_tdoc
      and t.aqpb835ndo = pc_ndoc  
    ;
   
    
    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_cantent number(10) :=0; --numero de entidades
    ln_cantentot number(10) :=0; --numero de entidades total
    
    ln_calif0 number(5,2) :=0;
    ln_calif1 number(5,2) :=0;
    ln_calif2 number(5,2) :=0;
    ln_calif3 number(5,2) :=0;
    ln_calif4 number(5,2) :=0; 
    
    ln_saldos  number(15,2) :=0;
    ln_cuotas  number(15,2) :=0;
    ln_volumen number(15,2) :=0;
    ln_escala number(15,2) :=0;
    ln_conta number(15,2):=0;
    ln_meses_eva number(15,2) :=0;
    ln_meses_con number(16,2);
    ln_meses_act  number(16,2);
    ln_recurrencia number(16,2);
    pn_result number(15,2);
    ln_poten number(15,2):=0;
    lv_aqpb833ndo varchar(12);
    ln_relacre number(16):=0;
    ln_potenf number(15,2):=0;
    --ln_escala number(16,2);      
    
begin
  pn_result := 0; --   
  
  for ti in titulares  loop  
      
      begin 
    
            pq_cr_potencial_pyme.sp_potencial_cliente_l(pd_fecha => ti.aqpb835fec,
                                                      pn_pais  => ti.aqpb835pai,
                                                      pn_tdoc  => ti.aqpb835tdo,
                                                      pc_ndoc  => ti.aqpb835ndo,
                                                      pn_poten => ln_poten);                        
      
            
            /*actualiza la tabla de clientes*/
            if ti.aqpb835var7 = 'MB' then
               ln_potenf := 5;
            else
              ln_potenf := ln_poten;
              end if;   
                    
            update aqpb835 u
               set u.aqpb835va4 = ln_potenf                             
             where u.aqpb835fec = ti.aqpb835fec
               and u.aqpb835pai = ti.aqpb835pai
               and u.aqpb835tdo = ti.aqpb835tdo
               and u.aqpb835ndo = ti.aqpb835ndo;
            
            commit;
            pn_pote := ln_potenf;
              
      exception when others then  
        pn_result:=0;
        dbms_output.put_line(ti.aqpb835ndo||'-'||sqlerrm);    
        pn_pote := 5; --muy bajo       
      end;
      end loop;
      commit ;
      
      pn_pote := ln_potenf;
        
   exception
    WHEN OTHERS THEN
     pn_result :=0; null;
     dbms_output.put_line(sqlerrm);  
      pn_pote := 5;   --muy bajo
   
end sp_resultado_credito_l;

---------------------------------------------------------------------------------------

Procedure sp_potencial_cliente_l(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_poten  out number
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_potencial_cliente_l
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.03.02
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE POTENCIAL POR CLIENTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_potencial number(10) :=0;  --valor sin respuesta
    ln_potval number(10) :=0;
    lc_tipper char(1) := '';
  begin
  
    begin
    
      /*obtener el valor del potencial del cliente*/
      select 
               decode(t.aqpb835va1,0,1,t.aqpb835va1)*
               decode(t.aqpb835va2,0,1,t.aqpb835va2)*
               decode(t.aqpb835va3,0,1,t.aqpb835va3) potval,  
               substr(t.aqpb835var6,-1,1) tipper             
              into ln_potval, lc_tipper
        from AQPB835 t
       where t.aqpb835fec = pd_fecha
         and t.aqpb835pai = pn_pais
         and t.aqpb835tdo = pn_tdoc
         and t.aqpb835ndo = pc_ndoc
         and t.aqpb835est = 'S';
      
      if lc_tipper = 'N' then  -- personas naturales 
          select t.tp1corr3
            into ln_potencial
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11155
             and t.tp1corr1 = 100
             and t.tp1corr2 = 1
             and ln_potval between t.tp1nro1 and t.tp1nro2;
       else -- personas juridicas 
           
           select t.tp1corr3
            into ln_potencial
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11155
             and t.tp1corr1 = 300
             and t.tp1corr2 = 1
             and ln_potval between t.tp1imp1 and t.tp1imp2;
           
       end if;      
          
      pn_poten := ln_potencial;    
      
      
    exception
      when others then
       -- dbms_output.put_line( sqlerrm);
       pn_poten := 5;  --caso de no haber nada por default 5 (muy bajo) cambio solicitado por parametrizacion
    end;  
     
    --pn_poten := ln_potencial;  
  
  end sp_potencial_cliente_l;

-----------------------------------------------------------------------------------
end pq_cr_potencial_pyme;
/

