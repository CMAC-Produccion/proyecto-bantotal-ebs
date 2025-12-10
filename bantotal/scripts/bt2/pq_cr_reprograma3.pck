create or replace package pq_cr_reprograma3 is
    -- *****************************************************************
    -- Nombre  : pq_cr_reprograma3
    -- Sistema : BANTOTAL    
    -- Author  : KVALENCIAC
    -- Created : 21/06/2021
    -- Purpose : Proceso para los reprogramados FOndos Gobierno Reactiva y FAE y actualización de tablas CMR 
    -- Modificar  : KVALENCIAC
    -- MOdificado : 30/07/2021
    -- Modificado  : KVALENCIAC
    -- MOdificado : 30/03/2022
    -- Modificado  : KVALENCIAC
    -- MOdificado : 23/01/2023
    --Comentario  : Se ha modificado 
    -- Modificado  : DCASTRO
    -- MOdificado : 25/10/2025 se agregó procedimiento sp_credito_BBP 
    -- *****************************************************************  
  procedure sp_reprogramafondo(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             ln_tipo out number,
                             lc_tipo_fondo out varchar
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
procedure sp_montocomision(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             lc_tipo_fondo out varchar,
                             ln_monto   out number,
                             lc_estado  out varchar,
                             ln_monto2   out number,
                             lc_estado2  out varchar) ;
procedure sp_esreprogramadoespecial(
                             v_instancia   in number,                            
                             v_flag out number
                             );          
procedure sp_esexoneradocontrol(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             vn_Ppgcod in number, 
                              vn_Pitsuc in number, 
                              vn_Pitmod in number, 
                              vn_PIttran in number, 
                              vn_Pitnrel in number, 
                              vn_Pitord in number, 
                              vn_Pitsbor in number,
                              ld_pgfape in date, 
                              vn_esexonerado out number,
                              vc_mensaje out varchar                            
                             ) ;  
--inicio 23/01/2023  kvalenciac
procedure sp_cuotaconcapital ( v_pgcod   in number,
                               v_Scmod   in number,
                               v_Scsuc   in number,
                               v_Scmda   in number,
                               v_Scpap   in number,
                               v_Sccta   in number,
                               v_Scoper  in number,
                               v_Scsbop  in number,
                               v_Sctope  in number,
                               vn_Ppgcod in number, 
                                vn_Pitsuc in number, 
                                vn_Pitmod in number, 
                                vn_PIttran in number, 
                                vn_Pitnrel in number, 
                                vn_Pitord in number, 
                                vn_Pitsbor in number,
                                ld_pgfape in date,  
                                rpta out number,
                                vc_mensaje out varchar); 
--fin 23/01/2023 kvalenciac 
--inicio 15/03/2023  kvalenciac  
procedure sp_comisionFAET(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             lc_tipo_fondo out varchar,
                             ln_monto   out number
                             ) ;  
--fin 15/03/2023  kvalenciac      


procedure sp_credito_BBP(
                                 vn_Ppgcod in number, 
                                 vn_Pitsuc in number, 
                                 vn_Pitmod in number, 
                                 vn_PIttran in number, 
                                 vn_Pitnrel in number, 
                                 vn_Pitord in number, 
                                 vn_monto  out number                                                          
                             ) ;                                                                                                                                                                                 
end pq_cr_reprograma3;
/
create or replace package body pq_cr_reprograma3 is

procedure sp_reprogramafondo(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_tipo   out number,
                             lc_tipo_fondo out varchar
                             ) is
    ln_caja char(1);
    --Retorna S si se encuentra habilitado
   Begin
      ln_tipo := 0;      
        begin 
             SELECT 'F',F.tipoprograma
             into ln_caja, lc_tipo_fondo
               --into ln_tasa
              FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
              WHERE F.IDFONDO = G.IDFONDO
              AND G.ESTADOSOLICITUD = 'BT'
               AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
               AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper
               AND F.EMPRESA = v_pgcod
               AND F.SUCURSAL = v_Scsuc
               AND F.MODULO = v_Scmod
               AND F.MONEDA = v_Scmda
               AND F.PAPEL = v_Scpap
               AND F.SUBOPERACION = v_Scsbop
               AND F.TIPOOPERACION = v_Sctope;
         exception
           when no_data_found then
               ln_caja := ' ';
               lc_tipo_fondo :='';
         end;            
    if ( ln_caja = 'F' ) then
      ln_tipo:=4;  --solo si devuelve 4      es reprogramado fonod Reactiva y FAE
    end if;
end sp_reprogramafondo;
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
         select F.IDFONDO into ln_id    --obtengo  l.idley3150
         FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
              WHERE F.IDFONDO = G.IDFONDO
              AND G.ESTADOSOLICITUD = 'BT'
               AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
               AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper
               AND F.EMPRESA = v_pgcod
               AND F.SUCURSAL = v_Scsuc
               AND F.MODULO = v_Scmod
               AND F.MONEDA = v_Scmda
               AND F.PAPEL = v_Scpap
               AND F.SUBOPERACION = v_Scsbop
               AND F.TIPOOPERACION = v_Sctope; 
       exception
        when no_data_found then
          ln_id :=0;
       end;
       if ( ln_id <> 0 ) then
         
          update FONDOS_CREDITOSFACILIDAD F set PROCESADOBT='S', NUEVOCRONOGRAMA = v_nombre
          WHERE F.IDFONDO = ln_id
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
       /*   --esto es para los casos que tienen doble registro por que uno de los titulares falleció
          update LEY31050_CREDITOSFACILIDAD F set PROCESADOBT='S', NUEVOCRONOGRAMA = v_nombre
          WHERE F.IDLEY31050 = ln_id
             -- AND SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1)  = v_Sccta
              AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) = v_Scoper
              AND F.EMPRESA  = v_pgcod;
          commit;   */                 
          select count(*) into ln_contadorp from FONDOS_CREDITOSFACILIDAD F where F.IDFONDO = ln_id and PROCESADOBT in ('S');--cuenta todos los procesados
          select count(*) into ln_contador from FONDOS_CREDITOSFACILIDAD F where F.IDFONDO = ln_id; -- and ( PROCESADOBT in ('') or PROCESADOBT=null);--cuenta todos los no procesados          
          if ( ln_contadorp = ln_contador ) then --si es igual a cero quiere decir que no hay ninguno en nullo vacio todos están procesados o extornados
             update FONDOS L 
             set  ESTADOSOLICITUD='AP' , FECHAENPARAAPROBACION=pgfape
             WHERE  L.IDFONDO =  ln_id
                and L.ESTADOSOLICITUD = 'BT' ; 
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
      select F.IDFONDO into ln_id    --obtengo  l.idley3150
         FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
              WHERE F.IDFONDO = G.IDFONDO
             -- AND G.ESTADOSOLICITUD = 'BT'
               AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = v_Sccta
               AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99) = v_Scoper
               AND F.EMPRESA = v_pgcod
               AND F.SUCURSAL = v_Scsuc
               AND F.MODULO = v_Scmod
               AND F.MONEDA = v_Scmda
               AND F.PAPEL = v_Scpap
              -- AND F.SUBOPERACION = v_Scsbop
               AND F.TIPOOPERACION = v_Sctope;  
      exception
        when no_data_found then
          ln_id :=0;
      end;
       if ( ln_id <> 0 ) then

          update FONDOS_CREDITOSFACILIDAD F set PROCESADOBT='E', NUEVOCRONOGRAMA = null
          WHERE F.IDFONDO = ln_id
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
          update FONDOS L 
             set  ESTADOSOLICITUD='BT' , FECHAENPARAAPROBACION=null
             WHERE  L.IDFONDO =  ln_id;                                         
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
      -- and AQPA840SBO =  v_Scsbop 
       and AQPA840TOP =  v_Sctope 
       and AQPA840EST = 'C';
       commit;          
end sp_extornaCMR;
--verifica si tiene saldo con el ingreso de la transacción esto es para casos que ingresan desde una transacción
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
        scrub in (9500095000000) and   --9500095000000- Inventario devengado pendiente
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

procedure sp_montocomision(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             lc_tipo_fondo out varchar,
                             ln_monto   out number,
                             lc_estado  out varchar,
                             ln_monto2   out number,
                             lc_estado2  out varchar                              
                             ) is
Begin
    begin 
       --select AQPA840TIPFONDO, AQPA840FCOMMONTO, AQPA840FEST, AQPA840FCOMMONTO, AQPA840GEST 
       select AQPA840TIPFONDO, AQPA840FCOMMONTO, AQPA840FEST, AQPA840FGRAMONTO, AQPA840GEST --kdvc 30/07/2021
       into  lc_tipo_fondo,ln_monto, lc_estado, ln_monto2, lc_estado2
       from  AQPA840 
       where AQPA840EMP = v_pgcod  
       and AQPA840MOD =  v_Scmod  
       and AQPA840SUC =  v_Scsuc  
       and AQPA840MDA =  v_Scmda  
       and AQPA840PAP =  v_Scpap  
       and AQPA840CTA =  v_Sccta  
       and AQPA840OPE =  v_Scoper
       and AQPA840SBO =  v_Scsbop
       and AQPA840TOP =  v_Sctope
       and AQPA840EST = 'C'       
       and rownum=1;                        
    Exception
         when no_data_found then
          lc_tipo_fondo:='';
          ln_monto:=0;
          lc_estado:='';
    end;   
end sp_montocomision; 
procedure sp_esreprogramadoespecial(
                             v_instancia   in number,                            
                             v_flag out number
                             ) is                           
begin 
   v_flag :=0;
  begin
      select 1 into v_flag 
      from JAQA400
      where JAQA400AI1=v_instancia
      and rownum=1;
   exception
        when no_data_found then
          v_flag :=0;          
   end; 
end   sp_esreprogramadoespecial;

procedure sp_esexoneradocontrol( v_pgcod   in number,
                                 v_Scmod   in number,
                                 v_Scsuc   in number,
                                 v_Scmda   in number,
                                 v_Scpap   in number,
                                 v_Sccta   in number,
                                 v_Scoper  in number,
                                 v_Scsbop  in number,
                                 v_Sctope  in number,
                                 vn_Ppgcod in number, 
                                 vn_Pitsuc in number, 
                                 vn_Pitmod in number, 
                                 vn_PIttran in number, 
                                 vn_Pitnrel in number, 
                                 vn_Pitord in number, 
                                 vn_Pitsbor in number,
                                 ld_pgfape in date,  
                                 vn_esexonerado out number, 
                                 vc_mensaje out varchar)
is
ln_contador number;
ln_encontro number;
ln_ncuotas number;
ln_ncuotasp number;
ln_ncuotaspt number;
ln_cuotastotp number;
begin
  ln_contador :=0;
  vn_esexonerado :=0;
  
  -- busco si es exonerado
  Begin
      -- busca con la clave del crédito que se ingreso en la transacción de pago
      select count(*) into ln_contador         
        from AQPC154
       where  aqpc154pgc = v_pgcod
         and  aqpc154mod = v_Scmod 
         and  aqpc154suc = v_Scsuc 
         and  aqpc154mda = v_Scmda
         and  aqpc154pap = v_Scpap
         and  aqpc154cta = v_Sccta
         and  aqpc154ope = v_Scoper
         and  aqpc154sbp = v_Scsbop
         and  aqpc154top = v_Sctope
         and  aqpc154flg = 'S';                  
      Exception
         when no_data_found then
          ln_contador:=0;
   end;
   --busco primero si la transacción ingresada es un transacción de cancelación total si es así debe mostrar mensaje antes de realizar el pago
   if ( ln_contador > 0 ) then
     vn_esexonerado :=1;
     ln_encontro :=0;
     vc_mensaje:='';
     ln_cuotastotp:=0;
     begin 
          --busca si la transacción es de cancelación total si es así debe mostrar el mensaje
          select count(*) into ln_encontro 
          from fst198
          where Tp1cod = 1
              and Tp1cod1 = 11123
              and Tp1corr1 = 14
              and Tp1corr2 = 1
              and Tp1corr3 > 0   
              and TP1NRO1 = vn_Pitmod
              and TP1NRO2 = vn_PIttran;
          Exception
           when no_data_found then
            ln_encontro:=0;           
      end;
      if (ln_encontro>0) then
         vc_mensaje := 'Antes de Cancelar debe realizar el siguiente pago.';
      else
        --buscar si es última cuota pagada    
         begin
          ln_ncuotas:=0;
          ln_ncuotasp :=0;
          ln_ncuotaspt :=0;
          --busco números de cuotas
          select count(*) into ln_ncuotas
          from fsd601
               where PgCod= v_pgcod
               and Ppmod  = v_Scmod
               and Ppsuc  = v_Scsuc   
               and Ppmda  = v_Scmda  
               and Pppap  = v_Scpap 
               and Ppcta  = v_Sccta
               and Ppoper = v_Scoper
               and Ppsbop = v_Scsbop
               and Pptope = v_Sctope              
               and Pptipo <> 'K'
               and Ppcap+Ppint<>0;
           Exception
           when no_data_found then
            ln_ncuotas:=0;
         end;
         --busco números de cuotas pagadas
         begin 
         select count(*) into ln_ncuotasp
          from fsd602
           where PgCod= v_pgcod
           and Ppmod  = v_Scmod
           and Ppsuc  = v_Scsuc 
           and Ppmda  = v_Scmda 
           and Pppap  = v_Scpap 
           and Ppcta  = v_Sccta
           and Ppoper = v_Scoper
           and Ppsbop = v_Scsbop
           and Pptope = v_Sctope
           and Pp1stat = 'T'
           and D602co = 'S'
           and Pp1cap+Pp1int<>0;
         Exception
           when no_data_found then
            ln_ncuotasp:=0;
         end;
         if ( ln_ncuotas-ln_ncuotasp = 1 ) then
              vc_mensaje := 'Antes de pagar su última cuota debe realizar el siguiente pago.';
         else
              --valido si está amortizado más cuotas  busca las cuotas pagadas por la transacción de ingreso
              begin
              select count(*) into ln_ncuotaspt
              from fsd602              
                Where D602cd = vn_Ppgcod 
                and D602mo   = vn_Pitmod  
                and D602su   = vn_Pitsuc
                and D602tr   = vn_PIttran
                and D602re   = vn_Pitnrel
                and D602fc   = ld_pgfape               
                and Pp1stat= 'T'                 
                and Pp1cap+Pp1int<>0;
               Exception
               when no_data_found then
                ln_ncuotaspt:=0;
               end;
               ln_cuotastotp := ln_ncuotasp+ln_ncuotaspt;
               if ( ln_ncuotas - ln_cuotastotp = 0 ) then
                  vc_mensaje := 'Antes de pagar debe realizar el siguiente pago.';
               end if;
          end if; 
      end if;
     end if;         
end sp_esexoneradocontrol;
--inicio 23/01/2023 kvalenciac
procedure sp_cuotaconcapital(  v_pgcod   in number,
                               v_Scmod   in number,
                               v_Scsuc   in number,
                               v_Scmda   in number,
                               v_Scpap   in number,
                               v_Sccta   in number,
                               v_Scoper  in number,
                               v_Scsbop  in number,
                               v_Sctope  in number,
                               vn_Ppgcod in number, 
                               vn_Pitsuc in number, 
                               vn_Pitmod in number, 
                               vn_PIttran in number, 
                               vn_Pitnrel in number, 
                               vn_Pitord in number, 
                               vn_Pitsbor in number,
                               ld_pgfape in date,   
                               rpta out number,
                               vc_mensaje out varchar)
  is
ln_encontro number(1);  
ln_ppg000pgc number(3);
ld_ppfpagmax date;
ln_ppcap number(18,2);
begin
     ln_encontro :=0;
     vc_mensaje:='';
     begin 
          --busca si la transacción es de cancelación total si es así debe mostrar el mensaje
          select count(*) into ln_encontro 
          from fst198
          where Tp1cod = 1
              and Tp1cod1 = 11123
              and Tp1corr1 = 14
              and Tp1corr2 = 1
              and Tp1corr3 > 0   
              and TP1NRO1 = vn_Pitmod
              and TP1NRO2 = vn_PIttran;
          Exception
           when no_data_found then
            ln_encontro:=0;           
     End;
     If (  ln_encontro =1 ) then
         vc_mensaje := 'Antes de Cancelar debe realizar el siguiente pago.';
         ln_ppcap :=1;
     else
        --busco máxima cuota pagada
        begin
        select max(ppfpag) into ld_ppfpagmax
        from fsd602
        where PgCod  = v_pgcod
               and Ppmod  = v_Scmod
               and Ppsuc  = v_Scsuc   
               and Ppmda  = v_Scmda  
               and Pppap  = v_Scpap 
               and Ppcta  = v_Sccta
               and Ppoper = v_Scoper
               and Ppsbop = v_Scsbop
               and Pptope = v_Sctope
               and d602co='S' 
               and pp1stat='T';
         exception
           when  no_data_found then
            select min(ppfpag)-1 into ld_ppfpagmax
            from fsd601
            where PgCod  = v_pgcod
               and Ppmod  = v_Scmod
               and Ppsuc  = v_Scsuc   
               and Ppmda  = v_Scmda  
               and Pppap  = v_Scpap 
               and Ppcta  = v_Sccta
               and Ppoper = v_Scoper
               and Ppsbop = v_Scsbop
               and Pptope = v_Sctope
               and Pptipo <> 'K'
               and Ppcap+Ppint<>0;         
        End;
        --busco si la proxima cuota a pagar va a pagar capital
        begin
        ln_ppcap := 0;
          select ppcap into ln_ppcap
          from fsd601
             where PgCod  = v_pgcod
               and Ppmod  = v_Scmod
               and Ppsuc  = v_Scsuc   
               and Ppmda  = v_Scmda  
               and Pppap  = v_Scpap 
               and Ppcta  = v_Sccta
               and Ppoper = v_Scoper
               and Ppsbop = v_Scsbop
               and Pptope = v_Sctope              
               and Pptipo <> 'K'
               and Ppcap+Ppint<>0
               and ppfpag > ld_ppfpagmax
               and rownum=1
               order by ppfpag asc;
           Exception
           when no_data_found then
              ln_ppcap:=0;
         end;
         ---  si no cumple conla anterior condición busco si alguna de las cuota que se va a pagar está pagando capital amortización      
         if (ln_ppcap=0) then
           begin
              select pp1cap into ln_ppcap
              from fsd602              
                Where D602cd = vn_Ppgcod 
                and D602mo   = vn_Pitmod  
                and D602su   = vn_Pitsuc
                and D602tr   = vn_PIttran
                and D602re   = vn_Pitnrel
                and D602fc   = ld_pgfape               
                and Pp1stat= 'T'                 
                and Pp1cap+Pp1int<>0
                and pp1cap >0 
                and rownum=1;
               Exception
               when no_data_found then
                ln_ppcap:=0;
               end;               
               if ( ln_ppcap > 0 ) then
                  vc_mensaje := 'Antes de pagar debe realizar el siguiente pago.';
               end if;
         end if;  
    end if;
    if (ln_ppcap>0) then
      rpta := 1;
    end if;
end sp_cuotaconcapital;
--fin 23/01/2023 kvalenciac
--inicio 15/03/2023 kvalenciac
procedure sp_comisionFAET(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,                             
                             lc_tipo_fondo out varchar,
                             ln_monto   out number                                                          
                             ) is
Begin
    ln_monto:=0;
    begin        
       select sum(AQPB435FCOMMT)
       into  ln_monto 
       from  AQPB435 
       where AQPB435EMP = v_pgcod  
       and AQPB435MOD =  v_Scmod  
    -- and AQPB435SUC =  v_Scsuc  
       and AQPB435MDA =  v_Scmda  
       and AQPB435PAP =  v_Scpap  
       and AQPB435CTA =  v_Sccta  
       and AQPB435OPE =  v_Scoper
    -- and AQPB435SBO =  v_Scsbop
       and AQPB435TOP =  v_Sctope
       and AQPB435EST = 'C' 
       and (AQPB435FEST <> 'C' or aqpb435fest is null)
       group by aqpb435emp,aqpb435mod,aqpb435mda,aqpb435pap,aqpb435cta,aqpb435ope,aqpb435top;                        
    Exception
         when no_data_found then
          lc_tipo_fondo:='';
          ln_monto:=0;          
    end;  
    if ( ln_monto > 0 ) then
       lc_tipo_fondo:='FAE TURISMO';
    end if;
end sp_comisionFAET; 
--fin 15/03/2023 kvalenciac

procedure sp_credito_BBP(
                                 vn_Ppgcod in number, 
                                 vn_Pitsuc in number, 
                                 vn_Pitmod in number, 
                                 vn_PIttran in number, 
                                 vn_Pitnrel in number, 
                                 vn_Pitord in number, 
                                 vn_monto  out number                                                          
                             ) is
    -- *****************************************************************
    -- Nombre                       : sp_credito_BBP
    -- Sistema                      : BANTOTAL
    -- Módulo                       : retorna indicador si es credito BBP y tiene pagos pendientes
    -- Versión                      : 1.0
    -- Fecha de Creación            : 2025.10.25
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 
    -- Autor de Modificación        : 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  lc_indicador char(1);       
  ln_mtoInt number;
  ln_mtoSeg number;                  
  ln_mtoITF number; 
  ln_mtosdo number; 
  ln_monto number;
  v_pgcod number;
  v_Scmda number; 
  v_Scpap number; 
  v_Sccta number;
  v_Scoper number;
   
      
Begin
    ln_monto:=0;
    
    --JAQA93MIN // INTERES PENDIENTE
    --JAQA93AI1 // SEGUROS
    --JAQA93AI2 //ITF
    --Realizar pago mediante transaccion Se ingresa al panel de Ingreso de transacciones (panel de Plataforma)
    -- y se ingresa la transacción 30/129,
    begin
       select PGCOD, MONEDA, PAPEL, CTNRO, ITOPER--MODULO, ITTOPE, ITSUCD,  MONEDA, PAPEL, CTNRO, ITOPER, ITSUBO
       into v_pgcod, v_Scmda, v_Scpap, v_Sccta, v_Scoper
         from fsd016 f
         where f.pgcod  = vn_Ppgcod 
           and f.itsuc  = vn_Pitsuc 
           and f.itmod  = vn_Pitmod 
           and f.ittran = vn_PIttran
           and f.itnrel = vn_Pitnrel
           and f.itord  = vn_Pitord; 
    exception when others then
       v_Sccta := 0;
       v_Scoper := 0;
    end;
    
    
    
    begin        
      select 'S', j.JAQA93MIN, j.JAQA93AI1, j.JAQA93AI2
        into lc_indicador , ln_mtoInt, ln_mtoSeg, ln_mtoITF
        from JAQA93 J
       where j.jaqa93emp = v_pgcod  
 --        and j.jaqa93mod =  v_Scmod  
         and j.jaqa93mda =  v_Scmda  
         and j.jaqa93pap =  v_Scpap  
         and j.jaqa93cta =  v_Sccta  
         and j.jaqa93ope =  v_Scoper
 --        and j.jaqa93tope =  v_Sctope
         and j.JAQA93EST = 'C' ;   
    exception when others then
        ln_mtoInt := 0;    
        ln_mtoSeg := 0;    
        ln_mtoITF := 0;          
    end;  
    
    ln_monto := nvl(ln_mtoInt,0) + nvl(ln_mtoSeg,0) + nvl(ln_mtoITF,0);
    
    if ln_monto <> 0 then ---verifica si existe en FSD011
       begin
         select f.scsdo * -1
           into ln_mtosdo  
           from fsd011 f
          where f.pgcod = 1
            and f.sccta =  v_Sccta
            and f.scoper = v_Scoper
            and f.scrub = '1517010000010';
       exception when others then     
            ln_mtosdo := 0;
       end;
       if ln_mtosdo = ln_monto then
         ln_monto := ln_mtosdo;
       else
         ln_monto := 0;  
       end if;         
    else 
        ln_monto := 0; 
    end if;   
    
    vn_monto := ln_monto;
    

end sp_credito_BBP; 

end pq_cr_reprograma3;
/
