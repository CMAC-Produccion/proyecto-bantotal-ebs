create or replace package pq_cr_reprogramaexo is

  -- Author  : KVALENCIAC
  -- Created : 25/02/2021
  -- Purpose : Proceso para los Rerprogrmados Caja Capitalizacion Exonerados 
   -- MOdificar  : KVALENCIAC
  -- Created : 06/05/2021
  -- Purpose : Se adicionò proceso de reducciòn de tasa 
   -- MOdificar  : KVALENCIAC
  -- Created : 19/09/2021 KVALENCIAC
  -- Purpose : Se adicionò proceso si es un crédito reprogramado con exoneraión de útima cuota AQPB411
   -- MOdificar  : KVALENCIAC
  -- Created : 05/10/2021 KVALENCIAC
  -- Purpose : Se adicionò proceso si es un crédito refinanciado con exoneraión de útima cuota AQPB408
   -- MOdificar  : KVALENCIAC
  -- Created : 28/10/2021 KVALENCIAC
  -- Purpose : Se adicionò reprogramción caja reducción tasa "Tasa Juntos"
     -- MOdificar  : KVALENCIAC
  -- Created : 18/01/2024 KVALENCIAC
  -- Purpose : Se adicionò para que valida que la opinión se la registrada de la última reprogramación
   -- Modificado : 23/01/2024 KVALENCIAC
  -- Purpose : Se adicionò validación de reprogrmados caja por flujo de reducción de tasa y de exoneración
  procedure sp_esexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,                             
                             ln_tipo out number
                             ) ;
  procedure sp_esreduccion(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,                             
                             ln_tipo out number
                             ) ;     --06/05/2021 kdvc  
  procedure sp_escancelacion(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,                             
                             ln_tipo out number
                             ) ;     --06/05/2021 kdvc 
 procedure sp_esTasaJuntos(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,                             
                             ln_tipo out number
                             ) ;     --28/10/2021 kdvc                                              
  procedure sp_actualizaCMR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             pgfape in date,
                             v_nombre in varchar
                             ) ;
 procedure sp_extornaCMR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number                             
                             ) ; 
procedure sp_validaopinion(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             );                             
procedure sp_esreprogramadoespecial(
                             v_instancia   in number,                            
                             v_flag out varchar
                             );   
procedure sp_esreprogramadoexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_encontro out number,
                             v_msg out varchar                             
                             ) ;                                
procedure sp_eliminareprogExonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             v_msg out varchar                             
                             ) ;   
procedure sp_MONTOEXO_ESMAYOR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             v_rpta out varchar                             
                             ) ;  
procedure sp_VarRefExo(
                             v_instancia   in number,
                             v_CUOESMAYOR_MTOEXO out varchar,                             
                             v_ES_REFCONEXO out varchar
                             );
--inicio kdvc 05/10/2021
procedure sp_esrefeinanciadoexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_encontro out number,
                             v_msg out varchar                             
                             ) ;                                
procedure sp_eliminarefinExonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             v_msg out varchar                             
                             ) ;   
--fin kdvc 05/10/2021  
--inicio  kdvc  23/01/2024
procedure sp_MTOEXO_ESMAYORFLUJO(
                             v_instancia in number,                                                        
                             v_rpta out varchar                             
                             ) ; 
procedure sp_esrefinanciacajaexo(
                             v_instancia   in number,                                                        
                             v_rpta out varchar                             
                             ) ; 
--fin kdvc  23/01/2024                                                                                                                                
end pq_cr_reprogramaexo;
/

create or replace package body pq_cr_reprogramaexo is
procedure sp_esexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,
                             ln_tipo  out number
                             ) is    
    --Retorna S si se encuentra habilitado
    Begin
      ln_tipo := 0; 
      ln_monto:=0;
         begin 
         SELECT  1           
             into ln_tipo
          FROM LEY31050 L --usrwebcrm.LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          WHERE L.ESTADOSOLICITUD = 'BT' 
              AND L.TIPOFACILIDAD = 'CAJA'
              AND ( F.facilidad like 'Exoneración de%' or  F.facilidad like 'Exoneracion de%' ) --13/08/2021 kdvc descripción --04/03/2021  kdvc se adicionó para distinguir el de exoneración del de reducción de tasa
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
              AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;             
         exception
           when no_data_found then
               ln_tipo :=0;
         end;
       if (ln_tipo > 0) then     
          begin 
           SELECT  montocapitalizacion           
               into ln_monto
            FROM LEY31050 L --usrwebcrm.LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT' 
                AND L.TIPOFACILIDAD = 'CAJA'
                AND ( F.facilidad like 'Exoneración de%' or  F.facilidad like 'Exoneracion de%' ) --13/08/2021 kdvc descripción --04/03/2021  kdvc se adicionó para distinguir el de exoneración del de reducción de tasa
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
                AND F.EMPRESA  = v_pgcod
                AND F.SUCURSAL = v_Scsuc
                AND F.MODULO =  v_Scmod
                AND F.MONEDA =  v_Scmda
                AND F.PAPEL  =  v_Scpap
                AND F.SUBOPERACION  = v_Scsbop
                AND F.TIPOOPERACION = v_Sctope;             
           exception
             when no_data_found then
                 ln_monto :=0;
           end; 
          end if;    
end sp_esexonerado;
--kdvc  06/05/2021 inicio
procedure sp_esreduccion(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,
                             ln_tipo  out number
                             ) is    
    --Retorna S si se encuentra habilitado
    Begin
      ln_tipo := 0; 
      ln_monto:=0;
         begin 
         SELECT  1           
             into ln_tipo
          FROM LEY31050 L --usrwebcrm.LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          WHERE L.ESTADOSOLICITUD = 'BT' 
              AND L.TIPOFACILIDAD = 'CAJA'
              AND ( F.facilidad like 'Reducción%' or F.facilidad like 'Reduccion%' or  F.facilidad like 'Tasa Juntos%' ) --13/08/2021 kdvc descripción //28/10/2021 kdvc 
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
              AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;             
         exception
           when no_data_found then
               ln_tipo :=0;
         end;
       if (ln_tipo > 0) then     
          begin 
           SELECT  montocapitalizacion           
               into ln_monto
            FROM LEY31050 L --usrwebcrm.LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT' 
                AND L.TIPOFACILIDAD = 'CAJA'
                AND ( F.facilidad like 'Reducción%' or F.facilidad like 'Reduccion%' or  F.facilidad like 'Tasa Juntos%' ) --13/08/2021 kdvc descripción //28/10/2021 kdvc   
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
                AND F.EMPRESA  = v_pgcod
                AND F.SUCURSAL = v_Scsuc
                AND F.MODULO =  v_Scmod
                AND F.MONEDA =  v_Scmda
                AND F.PAPEL  =  v_Scpap
                AND F.SUBOPERACION  = v_Scsbop
                AND F.TIPOOPERACION = v_Sctope;             
           exception
             when no_data_found then
                 ln_monto :=0;
           end; 
          end if;    
end sp_esreduccion;
----kdvc  06/05/2021 fin
--kdvc  09/08/2021 inicio
procedure sp_escancelacion(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,
                             ln_tipo  out number
                             ) is    
    --Retorna S si se encuentra habilitado
    Begin
      ln_tipo := 0; 
      ln_monto:=0;
         begin 
         SELECT  1           
             into ln_tipo
          FROM LEY31050 L --usrwebcrm.LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          WHERE L.ESTADOSOLICITUD = 'BT' 
              AND L.TIPOFACILIDAD = 'CAJA'
              AND F.facilidad like 'Amortizaci%' 
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
              AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;             
         exception
           when no_data_found then
               ln_tipo :=0;
         end;
       if (ln_tipo > 0) then     
          begin 
           SELECT  montocapitalizacion           
               into ln_monto
            FROM LEY31050 L --usrwebcrm.LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT' 
                AND L.TIPOFACILIDAD = 'CAJA'
                AND F.facilidad like 'Amortizaci%' 
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
                AND F.EMPRESA  = v_pgcod
                AND F.SUCURSAL = v_Scsuc
                AND F.MODULO =  v_Scmod
                AND F.MONEDA =  v_Scmda
                AND F.PAPEL  =  v_Scpap
                AND F.SUBOPERACION  = v_Scsbop
                AND F.TIPOOPERACION = v_Sctope;             
           exception
             when no_data_found then
                 ln_monto :=0;
           end; 
          end if;    
end sp_escancelacion;
----kdvc  09/08/2021 fin
--inicio kdvc 28/10/2021
procedure sp_esTasaJuntos(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_monto out number,
                             ln_tipo  out number
                             ) is    
    --Retorna S si se encuentra habilitado
    Begin
      ln_tipo := 0; 
      ln_monto:=0;
         begin 
         SELECT  1           
             into ln_tipo
          FROM LEY31050 L --usrwebcrm.LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          WHERE L.ESTADOSOLICITUD = 'BT' 
              AND L.TIPOFACILIDAD = 'CAJA'
              AND (  F.facilidad like 'Tasa Juntos%' ) 
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
              AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;             
         exception
           when no_data_found then
               ln_tipo :=0;
         end;
       if (ln_tipo > 0) then     
          begin 
           SELECT  montocapitalizacion           
               into ln_monto
            FROM LEY31050 L --usrwebcrm.LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT' 
                AND L.TIPOFACILIDAD = 'CAJA'
                AND ( F.facilidad like 'Tasa Juntos%' ) --13/08/2021 kdvc descripción //28/10/2021 kdvc 
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
                AND F.EMPRESA  = v_pgcod
                AND F.SUCURSAL = v_Scsuc
                AND F.MODULO =  v_Scmod
                AND F.MONEDA =  v_Scmda
                AND F.PAPEL  =  v_Scpap
                AND F.SUBOPERACION  = v_Scsbop
                AND F.TIPOOPERACION = v_Sctope;             
           exception
             when no_data_found then
                 ln_monto :=0;
           end; 
          end if;    
end sp_esTasaJuntos;
--fin kdvc 28/10/2021
procedure sp_actualizaCMR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             pgfape in date,
                             v_nombre in varchar
                             ) is
---    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_id number;
    ln_contador number;--registros por procesar
    ln_contadorp number;--registros procesados
    --Retorna S si se encuentra habilitado
   Begin
     ln_id :=0;
     ln_contador:=0;
     ln_contadorp:=0;
       Begin
        select L.IDLEY31050 into ln_id 
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE L.ESTADOSOLICITUD = 'BT' 
            AND L.TIPOFACILIDAD in ( 'CAJA')  --'CAJA'
            AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
            AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
            AND F.EMPRESA  = v_pgcod
            AND F.SUCURSAL = v_Scsuc
            AND F.MODULO =  v_Scmod
            AND F.MONEDA =  v_Scmda
            AND F.PAPEL  =  v_Scpap
            AND F.SUBOPERACION  = v_Scsbop
            AND F.TIPOOPERACION = v_Sctope; 
       exception
        when no_data_found then
          ln_id :=0;
       end;
       if ( ln_id <> 0 ) then
         
          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='S', NUEVOCRONOGRAMA = v_nombre
          WHERE F.IDLEY31050 = ln_id
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
              AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;
          commit;
          --inicio kdvc 08/01/2020   esto es para los casos que tienen doble registro por que uno de los titulares falleció
          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='S', NUEVOCRONOGRAMA = v_nombre
          WHERE F.IDLEY31050 = ln_id
             -- AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod;
          commit;          
          --fin kdvc 08/01/2020
          select count(*) into ln_contadorp from LEY31050_CREDITOSFACILIDAD F where F.IDLEY31050 = ln_id and PROCESADOBT in ('S');--cuenta todos los procesados
          select count(*) into ln_contador from LEY31050_CREDITOSFACILIDAD F where F.IDLEY31050 = ln_id; -- and ( PROCESADOBT in ('') or PROCESADOBT=null);--cuenta todos los no procesados          
          if ( ln_contadorp = ln_contador ) then --si es igual a cero quiere decir que no hay ninguno en nullo vacio todos están procesados o extornados
             update LEY31050 L 
             set  ESTADOSOLICITUD='AP' , FECHAENPARAAPROBACION=pgfape
             WHERE  L.IDLEY31050 =  ln_id
                and L.ESTADOSOLICITUD = 'BT' ;
--                AND L.TIPOFACILIDAD = 'CAJA' ;  --para que funciona para caja y gobierno se comentó   
             commit;
          end if;
       end if;
end sp_actualizaCMR;

procedure sp_extornaCMR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number                             
                             ) is
     ln_id number;
     ld_pgfape date;
     lc_facilidad varchar(30); --06/05/2021  kdvc
    --Retorna S si se encuentra habilitado
   Begin
      ln_id :=0;
      select pgfape into ld_pgfape from fst017 where pgcod=v_pgcod;
      Begin
      select L.IDLEY31050,F.facilidad into ln_id,lc_facilidad --L.IDLEY31050 into ln_id  --06/05/2021  kdvc
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE --L.ESTADOSOLICITUD = 'AP'  AND
             L.TIPOFACILIDAD in ( 'CAJA') --'CAJA',
            AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
            AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
            AND F.EMPRESA  = v_pgcod
            AND F.SUCURSAL = v_Scsuc
            AND F.MODULO =  v_Scmod
            AND F.MONEDA =  v_Scmda
            AND F.PAPEL  =  v_Scpap
           -- AND F.SUBOPERACION  = v_Scsbop
            AND F.TIPOOPERACION = v_Sctope; 
      exception
        when no_data_found then
          ln_id :=0;
      end;
       if ( ln_id <> 0 ) then

          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDLEY31050 = ln_id
              AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod
              AND F.SUCURSAL = v_Scsuc
              AND F.MODULO =  v_Scmod
              AND F.MONEDA =  v_Scmda
              AND F.PAPEL  =  v_Scpap
             -- AND F.SUBOPERACION  = v_Scsbop
              AND F.TIPOOPERACION = v_Sctope;
          commit;
          --inicio kdvc 08/01/2020   esto es para el extorno de los casos que tienen doble registro por que uno de los titulares falleció
          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDLEY31050 = ln_id
             -- AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod;
          commit;          
          --fin kdvc 08/01/2020
          update LEY31050 L 
             set  ESTADOSOLICITUD='BT' , FECHAENPARAAPROBACION=null
             WHERE  L.IDLEY31050 =  ln_id;
                -- and L.ESTADOSOLICITUD = 'BT' 
--                AND L.TIPOFACILIDAD = 'CAJA' ;  --para que funciona para caja y gobierno se comentó                          
          commit;
       end if;
       
       if ( ltrim(lc_facilidad) = 'Exoneración de capitalización'  or  ltrim(lc_facilidad) = 'Exoneracion de capitalizacion' ) then  --13/08/2021 kdvc --06/05/2021  kdvc
           ---extorno tabla AQPB411
           update AQPB411 set AQPB411EST='E', AQPB411FECEXT=ld_pgfape
           where AQPB411COD = v_pgcod  
           and AQPB411MOD =  v_Scmod  
           and AQPB411SUC =  v_Scsuc  
           and AQPB411MDA =  v_Scmda  
           and AQPB411PAP =  v_Scpap  
           and AQPB411CTA =  v_Sccta  
           and AQPB411OPE =  v_Scoper 
           and AQPB411SBO =  v_Scsbop 
           and AQPB411TPO =  v_Sctope ;
           commit;  
        end if ;
        if ( lc_facilidad = 'Reducción de tasa' ) or ( lc_facilidad = 'Reduccion de tasa' ) then  --13/08/2021 kdvc --06/05/2021  kdvc  inicio
          update AQPA840 set AQPA840EST='E', AQPA840FECEXT=ld_pgfape
           where AQPA840EMP = v_pgcod  
           and AQPA840MOD =  v_Scmod  
           and AQPA840SUC =  v_Scsuc  
           and AQPA840MDA =  v_Scmda  
           and AQPA840PAP =  v_Scpap  
           and AQPA840CTA =  v_Sccta  
           and AQPA840OPE =  v_Scoper 
           and AQPA840SBO =  v_Scsbop 
           and AQPA840TOP =  v_Sctope 
           and AQPA840TIP = 1;
            commit;  
        end if;    --06/05/2021  kdvc  fin
       if ( ltrim(lc_facilidad) = 'Amortizacion Anticipada' ) then  --13/08/2021 kdvc --09/08/2021  kdvc
           ---extorno tabla AQPB411
           update AQPB411 set AQPB411EST='E', AQPB411FECEXT=ld_pgfape
           where AQPB411COD = v_pgcod  
           and AQPB411MOD =  v_Scmod  
           and AQPB411SUC =  v_Scsuc  
           and AQPB411MDA =  v_Scmda  
           and AQPB411PAP =  v_Scpap  
           and AQPB411CTA =  v_Sccta  
           and AQPB411OPE =  v_Scoper 
           and AQPB411SBO =  v_Scsbop 
           and AQPB411TPO =  v_Sctope ;
           commit;  
        end if ;  --09/08/2021  kdvc  fin
end sp_extornaCMR;
procedure sp_validaopinion(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             ) is                           
ld_pgfape date;                             
begin
  v_mensaje:='';
  v_tieneopinion:=0;
  
  select pgfape into ld_pgfape from fst017 where pgcod=1; -- kvalenciac  18/01/2024
  
   begin
    select  1,jaqz253opi into v_tieneopinion, v_tipoopinion            
    from jaqz253 
    where jaqz253sol   = v_instancia 
      and jaqz253esrep='S'
      and jaqz253est= 'A'
      and jaqz253fec>=ld_pgfape;-- kvalenciac  18/01/2024  la opinión se debe realizar en el día tal cual como la reprogramación porque sino es otro registro que se creo en la JAQA400
   exception
        when no_data_found then
          v_tieneopinion :=0;
          v_tipoopinion :='';
   end; 
   if ( v_tieneopinion = 0 )   then
     v_mensaje := 'No tiene ingresado Opinión de Riesgo - Reprogramaciones Especiales';
   end if; 
   if ( v_tieneopinion = 1 and v_tipoopinion='N' )   then
     v_mensaje := 'La Opinión de Riesgo ingresada para está instancia es "No Viable Covid".';
   end if;                           
end   sp_validaopinion; 
procedure sp_esreprogramadoespecial(
                             v_instancia   in number,                            
                             v_flag out varchar
                             ) is                           
begin 
   v_flag :='N';
  begin
      select 'S' into v_flag 
      from JAQA400
      where JAQA400AI1=v_instancia
      and rownum=1;
   exception
        when no_data_found then
          v_flag :='N';          
   end; 
end   sp_esreprogramadoespecial; 

--inicio kdvc 19/09/2021
procedure sp_esreprogramadoexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_encontro out number,
                             v_msg out varchar                              
                             ) is
 ln_encontro number ;                              
begin
  begin
    select 1 into ln_encontro
    from aqpb411
    where aqpb411cod = v_pgcod
      and aqpb411mod = v_Scmod
      and aqpb411suc = v_Scsuc
      and aqpb411mda = v_Scmda
      and aqpb411pap = v_Scpap
      and aqpb411cta = v_Sccta
      and aqpb411ope = v_Scoper
      and aqpb411sbo = v_Scsbop
      and aqpb411tpo = v_Sctope
      and aqpb411est = 'P' ;
  exception
    when others then
          ln_encontro:=0;
          v_msg :='';
  end; 
  v_encontro := ln_encontro; 
  if (v_encontro=1) then
    v_msg := 'Si confirma esta reprogramación perderá la reprogramación de exoneración de última cuota.';
  end if ;                          
end   sp_esreprogramadoexonerado;                               
procedure sp_eliminareprogExonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_msg out varchar                             
                             ) is    
ld_pgfape date;                        
begin
  select pgfape into ld_pgfape from fst017 where pgcod= v_pgcod; 
  begin    
    update AQPB411 
    set aqpb411est = 'I', 
        aqpb411fecext = ld_pgfape,
        aqpb411aux01 = 1    
    where aqpb411cod = v_pgcod
      and aqpb411mod = v_Scmod
      and aqpb411suc = v_Scsuc
      and aqpb411mda = v_Scmda
      and aqpb411pap = v_Scpap
      and aqpb411cta = v_Sccta
      and aqpb411ope = v_Scoper
      and aqpb411sbo = v_Scsbop
      and aqpb411tpo = v_Sctope
      and aqpb411est = 'P' ;
  exception
    when others then
          v_msg:='No se ha encontrado este crédito, como un crédito de reprogramación de exoneración de última cuota.';
  end;                             
end   sp_eliminareprogExonerado;
procedure sp_MONTOEXO_ESMAYOR(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_rpta out varchar                             
                             ) is    
ld_Ppfpag date; 
ld_pgfape date;
ln_Ppcap number;
ln_Ppint  number;
ln_seguro number;
ln_totalcuota number;
ln_monto number;
begin
  ln_totalcuota :=0;
  select pgfape into ld_pgfape from fst017 where pgcod= v_pgcod;
  begin
     select max(Ppfpag)
            into ld_Ppfpag 
     from FSD601
     Where PgCod  = v_pgcod 
      and Ppmod  =  v_Scmod 
      and Ppsuc  =  v_Scsuc 
      and Ppmda  =  v_Scmda 
      and Pppap  =  v_Scpap 
      and Ppcta  =  v_Sccta 
      and Ppoper =  v_Scoper
      and Ppsbop =  609  --&xwfsubope   
      and Pptope =  v_Sctope
      and Pptipo <> 'K'
      and D601co = 'X';
  exception
    when others then
       ld_Ppfpag := null;
  end ;
  begin
     select Ppcap,Ppint 
            into ln_Ppcap,
                 ln_Ppint
     from FSD601
     Where PgCod  = v_pgcod 
      and Ppmod  =  v_Scmod 
      and Ppsuc  =  v_Scsuc 
      and Ppmda  =  v_Scmda 
      and Pppap  =  v_Scpap 
      and Ppcta  =  v_Sccta 
      and Ppoper =  v_Scoper
      and Ppsbop =  609  --&xwfsubope   
      and Pptope =  v_Sctope
      and Ppfpag = ld_Ppfpag
      and Pptipo <> 'K'
      and D601co = 'X';
    exception
    when others then
       ln_Ppcap := 0;
       ln_Ppint := 0;
    end ;
   begin 
      select Ppimp11+Ppimp12+Ppimp13+Ppimp14+Ppimp15
         into ln_seguro
      from FSD611
      where PgCod =  v_pgcod 
        and PPmod =  v_Scmod 
        and Ppsuc =  v_Scsuc 
        and Ppmda =  v_Scmda 
        and Pppap =  v_Scpap 
        and Ppcta =  v_Sccta 
        and Ppoper=  v_Scoper
        and Ppsbop=  609 
        and Pptope = v_Sctope
        and Ppfpag = ld_Ppfpag;
      exception
     when others then
       ln_seguro := 0;       
      end ;
    ln_totalcuota:= ln_Ppcap + ln_Ppint + ln_seguro; 
    begin
     SELECT  montocapitalizacion           
               into ln_monto
            FROM LEY31050 L --usrwebcrm.LEY31050 L
            INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
            WHERE L.ESTADOSOLICITUD = 'BT' 
                AND L.TIPOFACILIDAD = 'CAJA'
                AND ( F.facilidad like 'Exoneración de%' or  F.facilidad like 'Exoneracion de%' )
                AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
                AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
                AND F.EMPRESA  = v_pgcod
                AND F.SUCURSAL = v_Scsuc
                AND F.MODULO =  v_Scmod
                AND F.MONEDA =  v_Scmda
                AND F.PAPEL  =  v_Scpap
                AND F.SUBOPERACION  = v_Scsbop
                AND F.TIPOOPERACION = v_Sctope;             
      exception
             when no_data_found then
                 ln_monto :=0;
      end; 
      if ( ln_totalcuota > ln_monto ) then
        v_rpta := 'S';
      else
        v_rpta := 'N';
      end if;     
end   sp_MONTOEXO_ESMAYOR;
procedure sp_VarRefExo(
                             v_instancia   in number,
                             v_CUOESMAYOR_MTOEXO out varchar,                             
                             v_ES_REFCONEXO out varchar
                             ) is    
ld_Ppfpag date; 
ld_pgfape date;
ln_Ppcap number;
ln_Ppint  number;
ln_seguro number;
ln_totalcuota number;
ln_monto number;
ln_XWfEmpresa number;
ln_XWfSucursal number;
ln_XWfModulo number;
ln_XWfMoneda number;
ln_XWfPapel number;
ln_XWfCuenta number;
ln_XWfOperacion number;
ln_XWfSubope number;
ln_XWfTipOpe number;
ln_encontro number;
ln_MontoExonerado number;
ln_montoconajuste number;
cursor creditos is
Select * from xwf700 
 where XWFPRCINS=v_instancia 
   and XWFCar3 = 'R';
begin   
  begin 
    select XWfEmpresa,
           XWfSucursal,
           XWfModulo,
           XWfMoneda,
           XWfPapel,
           XWfCuenta,
           XWfOperacion,
           XWfSubope,
           XWfTipOpe
           into
           ln_XWfEmpresa,
           ln_XWfSucursal,
           ln_XWfModulo,
           ln_XWfMoneda,
           ln_XWfPapel,
           ln_XWfCuenta,
           ln_XWfOperacion,
           ln_XWfSubope,
           ln_XWfTipOpe
      from xwf700  
      where XWFPRCINS=v_instancia 
      and XWFCar3 = '1';
    exception 
      when others then
        ln_XWfCuenta:=0;
    end;
   
    --busco el motno de la última cuota
    begin
     select max(Ppfpag)
            into ld_Ppfpag 
     from FSD601
     Where PgCod  = ln_XWfEmpresa
      and Ppmod  =  ln_XWfModulo
      and Ppsuc  =  ln_XWfSucursal
      and Ppmda  =  ln_XWfMoneda
      and Pppap  =  ln_XWfPapel
      and Ppcta  =  ln_XWfCuenta
      and Ppoper =  ln_XWfOperacion
      and Ppsbop =  ln_XWfSubope  
      and Pptope =  ln_XWfTipOpe
      and Pptipo <> 'K'
        and D601co = 'X';
    exception
      when others then
         ld_Ppfpag := null;
    end ;
    begin
     select Ppcap,Ppint 
            into ln_Ppcap,
                 ln_Ppint
     from FSD601
     Where PgCod  = ln_XWfEmpresa
      and Ppmod  =  ln_XWfModulo
      and Ppsuc  =  ln_XWfSucursal
      and Ppmda  =  ln_XWfMoneda
      and Pppap  =  ln_XWfPapel
      and Ppcta  =  ln_XWfCuenta
      and Ppoper =  ln_XWfOperacion
      and Ppsbop =  ln_XWfSubope    
      and Pptope =  ln_XWfTipOpe
      and Ppfpag = ld_Ppfpag
      and Pptipo <> 'K'
      and D601co = 'X';
    exception
    when others then
       ln_Ppcap := 0;
       ln_Ppint := 0;
    end ;
   begin 
      select Ppimp11+Ppimp12+Ppimp13+Ppimp14+Ppimp15
         into ln_seguro
      from FSD611
      where PgCod =  ln_XWfEmpresa
        and PPmod =  ln_XWfModulo
        and Ppsuc =  ln_XWfSucursal
        and Ppmda =  ln_XWfMoneda
        and Pppap =  ln_XWfPapel
        and Ppcta =  ln_XWfCuenta
        and Ppoper=  ln_XWfOperacion
        and Ppsbop=  ln_XWfSubope  
        and Pptope = ln_XWfTipOpe
        and Ppfpag = ld_Ppfpag;
      exception
     when others then
       ln_seguro := 0;       
      end ;
    ln_totalcuota:= ln_Ppcap + ln_Ppint + ln_seguro;
    -- verifico si el crédito es un refinanciado con exoneración
     begin
       select count(*)
             into  ln_encontro
       from AQPB408
       where AQPB408COD = ln_XWfEmpresa
         and AQPB408MOD = ln_XWfModulo
         and AQPB408SUC = ln_XWfSucursal   
         and AQPB408MDA = ln_XWfMoneda
         and AQPB408PAP = ln_XWfPapel
         and AQPB408CTA = ln_XWfCuenta
         and AQPB408OPE = ln_XWfOperacion
         and AQPB408SBO = ln_XWfSubope  
         and AQPB408TPO = ln_XWfTipOpe
         and AQPB408EST = 'C';
       exception
          when others then
            ln_encontro :=0;
       end;
       if ( ln_encontro > 0 ) then
         v_ES_REFCONEXO :='S';
       end if;    
    --busco el monto de algún crédito refinanciado  --busco la primera variable si es un refinanciado con exoneración
    ln_MontoExonerado :=0;
    for a in creditos loop        
      ln_montoconajuste :=0;
      begin        
        select JAQN870CAA+JAQN870INA+JAQN870PEA+JAQN870MOA+JAQN870ICA --montos exonerados
              into ln_montoconajuste  
        from JAQN870
        where JAQN870EMP = a.xwfempresa  
        and JAQN870MOD = a.xwfmodulo
        and JAQN870SUC = a.xwfsucursal  
        and JAQN870MDA = a.xwfmoneda   
        and JAQN870PAP = a.xwfpapel    
        and JAQN870CTA = a.xwfcuenta   
        and JAQN870OPE = a.xwfoperacion
        and JAQN870SBO = a.xwfsubope   
        and JAQN870TOP = a.XWfTipOpe
        and JAQN870EST = 'X';                
       exception
         when others then
           ln_montoconajuste:=0;
       end;
       ln_MontoExonerado :=  ln_MontoExonerado + ln_montoconajuste;
     end loop;
     if ( ln_totalcuota > ln_MontoExonerado ) then
       v_CUOESMAYOR_MTOEXO := 'S';
     else
       v_CUOESMAYOR_MTOEXO := 'N';
     end if;
end   sp_VarRefExo;                             
--fin kdvc 19/09/2021                     
--inicio kdvc 05/10/2021
procedure sp_esrefeinanciadoexonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_encontro out number,
                             v_msg out varchar                              
                             ) is
 ln_encontro number ;                              
begin
  begin
    select 1 into ln_encontro
    from aqpb408
    where aqpb408cod = v_pgcod
      and aqpb408mod = v_Scmod
      and aqpb408suc = v_Scsuc
      and aqpb408mda = v_Scmda
      and aqpb408pap = v_Scpap
      and aqpb408cta = v_Sccta
      and aqpb408ope = v_Scoper
      and aqpb408sbo = v_Scsbop
      and aqpb408tpo = v_Sctope
      and aqpb408est = 'C' ;
  exception
    when others then
          ln_encontro:=0;
          v_msg :='';
  end; 
  v_encontro := ln_encontro; 
  if (v_encontro=1) then
    v_msg := 'Si confirma esta reprogramación perderá la refinanciación de exoneración de última cuota.';
  end if ;                          
end sp_esrefeinanciadoexonerado;                               
procedure sp_eliminarefinExonerado(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_msg out varchar                             
                             ) is    
ld_pgfape date;                        
begin
  select pgfape into ld_pgfape from fst017 where pgcod= v_pgcod; 
  begin    
    update AQPB408 
    set aqpb408est = 'I', 
        aqpb408fecext = ld_pgfape,
        aqpb408aux01 = 1    
    where aqpb408cod = v_pgcod
      and aqpb408mod = v_Scmod
      and aqpb408suc = v_Scsuc
      and aqpb408mda = v_Scmda
      and aqpb408pap = v_Scpap
      and aqpb408cta = v_Sccta
      and aqpb408ope = v_Scoper
      and aqpb408sbo = v_Scsbop
      and aqpb408tpo = v_Sctope
      and aqpb408est = 'C' ;
  exception
    when others then
          v_msg:='No se ha encontrado este crédito, como un crédito de refinanciación de exoneración de última cuota.';
  end;                             
end   sp_eliminarefinExonerado;
--fin kdvc 05/10/2021 
---inicio 23/0182024
procedure sp_MTOEXO_ESMAYORFLUJO(
                             v_instancia in number,                             
                             v_rpta out varchar                             
                             ) is    
ld_Ppfpag date; 
ld_pgfape date;
ln_Ppcap number;
ln_Ppint  number;
ln_seguro number;
ln_totalcuota number;
ln_monto number;
v_pgcod number;
v_Scmod number;
v_Scsuc  number;
v_Scmda  number;
v_Scpap  number;
v_Sccta  number;
v_Scoper number;
v_Scsbop number;
v_Sctope number;
begin
  ln_totalcuota :=0;
  select pgfape into ld_pgfape from fst017 where pgcod= 1;
  begin 
     select x.xwfempresa,x.xwfsucursal,x.xwfmodulo,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope
     into v_pgcod,          
          v_Scsuc,
          v_Scmod, 
          v_Scmda, 
          v_Scpap, 
          v_Sccta, 
          v_Scoper,
          v_Scsbop,
          v_Sctope
     from xwf700 x
     where x.xwfprcins= v_instancia
     and x.xwfcar3='1';
  exception 
      when others then
        v_Sccta:=0;
  end;
  if ( v_Sccta >0 ) then
      begin
         select max(Ppfpag)
                into ld_Ppfpag 
         from FSD601
         Where PgCod  = v_pgcod 
          and Ppmod  =  v_Scmod 
          and Ppsuc  =  v_Scsuc 
          and Ppmda  =  v_Scmda 
          and Pppap  =  v_Scpap 
          and Ppcta  =  v_Sccta 
          and Ppoper =  v_Scoper
          and Ppsbop =  v_Scsbop
          and Pptope =  v_Sctope
          and Pptipo <> 'K'
          and D601co = 'X';
      exception
        when others then
           ld_Ppfpag := null;
      end ;
      begin
         select Ppcap,Ppint 
                into ln_Ppcap,
                     ln_Ppint
         from FSD601
         Where PgCod  = v_pgcod 
          and Ppmod  =  v_Scmod 
          and Ppsuc  =  v_Scsuc 
          and Ppmda  =  v_Scmda 
          and Pppap  =  v_Scpap 
          and Ppcta  =  v_Sccta 
          and Ppoper =  v_Scoper
          and Ppsbop =  v_Scsbop
          and Pptope =  v_Sctope
          and Ppfpag = ld_Ppfpag
          and Pptipo <> 'K'
          and D601co = 'X';
        exception
        when others then
           ln_Ppcap := 0;
           ln_Ppint := 0;
        end ;
       begin 
          select Ppimp11+Ppimp12+Ppimp13+Ppimp14+Ppimp15
             into ln_seguro
          from FSD611
          where PgCod =  v_pgcod 
            and PPmod =  v_Scmod 
            and Ppsuc =  v_Scsuc 
            and Ppmda =  v_Scmda 
            and Pppap =  v_Scpap 
            and Ppcta =  v_Sccta 
            and Ppoper=  v_Scoper
            and Ppsbop=  v_Scsbop
            and Pptope = v_Sctope
            and Ppfpag = ld_Ppfpag;
          exception
         when others then
           ln_seguro := 0;       
          end ;
        ln_totalcuota:= ln_Ppcap + ln_Ppint + ln_seguro;
         --busco la clave del crédito que muere
        begin 
           select x.xwfempresa,x.xwfsucursal,x.xwfmodulo,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope
           into v_pgcod,          
                v_Scsuc,
                v_Scmod, 
                v_Scmda, 
                v_Scpap, 
                v_Sccta, 
                v_Scoper,
                v_Scsbop,
                v_Sctope
           from xwf700 x
           where x.xwfprcins= v_instancia
           and x.xwfcar3<>'1'
           and rownum =1;
        exception 
            when others then
              v_Sccta:=0;
        end; 
        begin
         SELECT  a.aqpd154desfin           
                   into ln_monto
                FROM aqpd154 a
                 where
                     a.aqpd154emp = v_pgcod 
                    AND a.aqpd154mod = v_Scmod
                    AND a.aqpd154suc = v_Scsuc 
                    AND a.aqpd154mda = v_Scmda
                    AND a.aqpd154pap = v_Scpap 
                    AND a.aqpd154cta = v_Sccta
                    AND a.aqpd154ope  = v_Scoper
                    AND a.aqpd154sbop = v_Scsbop
                    and a.aqpd154tope = v_Sctope
                    and a.aqpd154estreg = 'P';             
          exception
                 when no_data_found then
                     ln_monto:=0;
          end;
     end if;
      if ( ln_totalcuota > ln_monto ) then
        v_rpta := 'S';
      else
        v_rpta := 'N';
   end if;     
end sp_MTOEXO_ESMAYORFLUJO;        

procedure sp_esrefinanciacajaexo(
                             v_instancia   in number,                                                        
                             v_rpta out varchar                             
                             ) is 
ld_Ppfpag date; 
ld_pgfape date;
ln_Ppcap number;
ln_Ppint  number;
ln_seguro number;
ln_totalcuota number;
ln_monto number;
v_pgcod number;
v_Scmod number;
v_Scsuc  number;
v_Scmda  number;
v_Scpap  number;
v_Sccta  number;
v_Scoper number;
v_Scsbop number;
v_Sctope number;                                                       
begin
   v_rpta :='N';
   --busco la clave del crédito que muere
        begin 
           select x.xwfempresa,x.xwfsucursal,x.xwfmodulo,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope
           into v_pgcod,          
                v_Scsuc,
                v_Scmod, 
                v_Scmda, 
                v_Scpap, 
                v_Sccta, 
                v_Scoper,
                v_Scsbop,
                v_Sctope
           from xwf700 x
           where x.xwfprcins= v_instancia
           and x.xwfcar3<>'1'
           and rownum =1;
        exception 
            when others then
              v_Sccta:=0;
        end; 
  --valido si es refinancia caja por flujo
  begin
         SELECT  a.aqpd154desfin           
                   into ln_monto
                FROM aqpd154 a
                 where
                     a.aqpd154emp = v_pgcod 
                    AND a.aqpd154mod = v_Scmod
                    AND a.aqpd154suc = v_Scsuc 
                    AND a.aqpd154mda = v_Scmda
                    AND a.aqpd154pap = v_Scpap 
                    AND a.aqpd154cta = v_Sccta
                    AND a.aqpd154ope  = v_Scoper
                    AND a.aqpd154sbop = v_Scsbop
                    and a.aqpd154tope = v_Sctope
                    and a.aqpd154estreg = 'P'
                    and a.aqpd154desfin>0;             
          exception
                 when no_data_found then
                     ln_monto :=0;
          end;
  if (ln_monto > 0) then
    v_rpta:='S'; 
  else
     v_rpta:='N';
  end if; 
 
end sp_esrefinanciacajaexo;
---fin kdvc 23/01/2024    

   
end pq_cr_reprogramaexo;
/

