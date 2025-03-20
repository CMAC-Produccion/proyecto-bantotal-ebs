create or replace package pq_cr_reprograma is

  -- Author  : KVALENCIAC
  -- Created : 18/11/2020
  -- Purpose : Proceso para los Rerprogrmados Caja y Gobierno  actualización de tablas CMR 
  procedure sp_cajagobierno(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             ln_tipo out number
                             ) ;
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
end pq_cr_reprograma;
/

create or replace package body pq_cr_reprograma is

procedure sp_cajagobierno(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_tipo   out number
                             ) is
    ln_caja char(1);
    --Retorna S si se encuentra habilitado
   Begin
      ln_tipo := 0;
      ln_caja := pq_cr_funciones_cho.fn_obtener_tasaRepro_Caja(pn_emp => v_pgcod,
                                                               pn_mod => v_Scmod,
                                                               pn_suc => v_Scsuc,
                                                               pn_mda => v_Scmda,
                                                               pn_pap => v_Scpap,
                                                               pn_cta => v_Sccta,
                                                               pn_ope => v_Scoper,
                                                               pn_sbo => v_Scsbop,
                                                               pn_top => v_Sctope);
      if ( ln_caja <> 'S' ) then
        begin 
         SELECT
             'G'
             into ln_caja
          FROM LEY31050 L
          INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
          WHERE L.ESTADOSOLICITUD = 'BT' 
              AND L.TIPOFACILIDAD = 'GOBIERNO'
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
               ln_caja := ' ';
         end;
      end if;          
    if ( ln_caja = 'S' ) then
      ln_tipo:=1;
    end if;
    if ( ln_caja = 'G' ) then
      ln_tipo:=2;
    end if;

end sp_cajagobierno;
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
            AND L.TIPOFACILIDAD in ( 'CAJA','GOBIERNO') 
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
         begin
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
          exception
            when no_data_found then
              null;
          End;
         
          select count(*) into ln_contadorp from LEY31050_CREDITOSFACILIDAD F where F.IDLEY31050 = ln_id and PROCESADOBT in ('S');--cuenta todos los procesados
          select count(*) into ln_contador from LEY31050_CREDITOSFACILIDAD F where F.IDLEY31050 = ln_id; -- and ( PROCESADOBT in ('') or PROCESADOBT=null);--cuenta todos los no procesados          
          if ( ln_contadorp = ln_contador ) then --si es igual a cero quiere decir que no hay ninguno en nullo vacio todos están procesados o extornados
            Begin
             update LEY31050 L 
             set  ESTADOSOLICITUD='AP' , FECHAENPARAAPROBACION=pgfape
             WHERE  L.IDLEY31050 =  ln_id
                and L.ESTADOSOLICITUD = 'BT' ;
--                AND L.TIPOFACILIDAD = 'CAJA' ;  --para que funciona para caja y gobierno se comentó   
             commit;
             exception
            when no_data_found then
              null;
            End;
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
    --Retorna S si se encuentra habilitado
   Begin
      ln_id :=0;
      Begin
      select L.IDLEY31050 into ln_id 
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE --L.ESTADOSOLICITUD = 'AP'  AND
             L.TIPOFACILIDAD in ( 'CAJA','GOBIERNO')
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
          begin
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
          exception
            when no_data_found then
              null;
          End;
          begin
          update LEY31050 L 
             set  ESTADOSOLICITUD='BT' , FECHAENPARAAPROBACION=null
             WHERE  L.IDLEY31050 =  ln_id;
                -- and L.ESTADOSOLICITUD = 'BT' 
--                AND L.TIPOFACILIDAD = 'CAJA' ;  --para que funciona para caja y gobierno se comentó                          
          commit;
          exception
            when no_data_found then
              null;
          End;
       end if;
end sp_extornaCMR;

end pq_cr_reprograma;
/

