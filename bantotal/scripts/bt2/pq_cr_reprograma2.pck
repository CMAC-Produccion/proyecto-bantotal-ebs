create or replace package pq_cr_reprograma2 is

  -- Author  : KVALENCIAC
  -- Created : 18/11/2020
  -- Purpose : Proceso para los Rerprogrmados Caja y Gobierno  actualización de tablas CMR 
  procedure sp_esgobierno(
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
procedure sp_verificasaldo (vn_Ppgcod in number, 
                            vn_Pitsuc in number, 
                            vn_Pitmod in number, 
                            vn_PIttran in number, 
                            vn_Pitnrel in number, 
                            vn_Pitord in number, 
                            vn_Pitsbor in number,  
                            rpta out number, 
                            ln_saldo out number);                                                                                      
end pq_cr_reprograma2;
/

create or replace package body pq_cr_reprograma2 is

procedure sp_esgobierno(
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
             -- and ( F.PROCESADOBT is null or F.PROCESADOBT<>'S' or  F.PROCESADOBT='');
         exception
           when no_data_found then
               ln_caja := ' ';
         end;            
    if ( ln_caja = 'G' ) then
      ln_tipo:=2;  --solo si devuelve 2 es reprogramado gobierno
    end if;
end sp_esgobierno;
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
            AND L.TIPOFACILIDAD in ( 'GOBIERNO')  --se modifció para que sea solo gobierno antes esta 'CAJA'
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
    --Retorna S si se encuentra habilitado
   Begin
      ln_id :=0;
      select pgfape into ld_pgfape from fst017 where pgcod=v_pgcod;
      Begin
      select L.IDLEY31050 into ln_id 
        FROM LEY31050 L --obtengo  l.idley3150
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE --L.ESTADOSOLICITUD = 'AP'  AND
             L.TIPOFACILIDAD in ( 'GOBIERNO') --'CAJA',
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
       ---extorno tabla AQPA840
       update AQPA840 set AQPA840EST='E', AQPA840FECEXT=ld_pgfape
       where AQPA840EMP = v_pgcod  
       and AQPA840MOD =  v_Scmod  
       and AQPA840SUC =  v_Scsuc  
       and AQPA840MDA =  v_Scmda  
       and AQPA840PAP =  v_Scpap  
       and AQPA840CTA =  v_Sccta  
       and AQPA840OPE =  v_Scoper 
       and AQPA840SBO =  v_Scsbop 
       and AQPA840TOP =  v_Sctope ;
       commit;   
       
end sp_extornaCMR;
procedure sp_verificasaldo(vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_saldo out number)
  is
--ln_atributo number(9);
--ln_modulo number(3);
ln_ppg000pgc number(3);
ln_ppg000mod number(4);
ln_ppg000suc number(3);
ln_ppg000mda number(4);
ln_ppg000pap number(4);
ln_ppg000cta number(9);
ln_ppg000ope number(9);
ln_ppg000sbo number(3);
ln_ppg000tpo number(3);
ln_ppg000frm number(3);
ln_ordinal number(4);
ld_pgfape date;
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=vn_Ppgcod; 
  
  rpta := 0;
  Begin
      select 
          pgcod,modulo,itsucd,moneda,papel,ctnro,itoper,itsubo,ittope into ln_ppg000pgc,
          ln_ppg000mod,
          ln_ppg000suc,
          ln_ppg000mda,
          ln_ppg000pap,
          ln_ppg000cta,
          ln_ppg000ope,
          ln_ppg000sbo,
          ln_ppg000tpo
        from fsd016
       where pgcod = vn_Ppgcod
         and itsuc = vn_Pitsuc
         and itmod = vn_Pitmod
         and ittran = vn_PIttran
         and itnrel = vn_Pitnrel
         and itord = 10   --Ceci lo tenía en una guía
         and itsbor = vn_Pitsbor;
      Exception
         when no_data_found then
          ln_ppg000cta:=0;
          ln_ppg000ope:=0;
   end;
      --busco formulario
   ln_saldo :=0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = ln_ppg000pgc and
        sccta = ln_ppg000cta and
        scrub in (9500095000000) and 
        scoper = ln_ppg000ope and     
        scmda = ln_ppg000mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;   
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      rpta := 1;
    end if;
end sp_verificasaldo;

end pq_cr_reprograma2;
/

