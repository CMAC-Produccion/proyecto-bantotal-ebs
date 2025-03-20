create or replace package pq_cr_reprogramaopinion is

  -- Author  : KVALENCIAC
  -- Created : 13/07/2021
  -- Purpose : Opinión de Riesgo para reprogramados  
  
      -- Modificación  : KVALENCIAC
  -- Created : 29/08/2023
  -- Purpose : Opinión de Riesgo para reprogramados por rating de agencia 
        -- Modificación  : KVALENCIAC
  -- Created : 29/09/2023
  -- Purpose : Opinión de Riesgo para SEP29
   -- Modificación  : KVALENCIAC
  -- Created : 27/10/2023
  -- Purpose : Opinión de Riesgo para 26OCT
   -- Modificación  : KVALENCIAC
  -- Created : 18/01/2024
  -- Purpose : Monto de Opinión solo considerando el saldo capital del crédito 
  
procedure sp_tieneopinion(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             );  
procedure sp_tieneopinionrp(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             );                                                         
procedure sp_validamontoopinion(
                             v_instancia   in number,                         
                             v_requiereopinion out varchar
                             ); 
procedure sp_validamontoopinionCap(
                             v_instancia   in number,                         
                             v_requiereopinion out varchar
                             );                             
procedure sp_requiereopinion(
                             v_instancia   in number,                         
                             v_requiereopinion out varchar
                             ); 
procedure sp_validamaontoopilinea(
                             v_instancia   in number,                         
                             v_esmontomayor out varchar
                             );                                                                
                                                                      
end pq_cr_reprogramaopinion;
/

create or replace package body pq_cr_reprogramaopinion is

procedure sp_tieneopinion(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             ) is                           
begin
  v_mensaje:='';
  v_tieneopinion:=0;
   begin
    select  1,jaqz253opi into v_tieneopinion, v_tipoopinion            
    from jaqz253 
    where jaqz253sol   = v_instancia 
      and jaqz253esrep='S'
      and jaqz253est= 'A';
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
end   sp_tieneopinion;
procedure sp_tieneopinionrp(
                             v_instancia   in number,
                             v_tieneopinion out number,                             
                             v_tipoopinion out varchar,
                             v_mensaje out varchar
                             ) is                           
begin
  v_mensaje:='';
  v_tieneopinion:=0;
   begin
    select  1,jaqz253opi into v_tieneopinion, v_tipoopinion            
    from jaqz253 
    where jaqz253sol   = v_instancia 
      --and jaqz253esrep='S'
      and jaqz253est= 'A';
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
end   sp_tieneopinionrp;
procedure sp_validamontoopinion(
                             v_instancia   in number,
                             v_requiereopinion out varchar                                                         
                             ) is
ln_monto_tope number;
lc_fecha varchar(30);  
ld_fecha date; 
ln_tipocambio number(14,8);
ld_pgfape date; 
ln_SNG001Pais number;
ln_SNG001TDOC number; 
lc_SNG001NDoc char(12);
ln_montoconsolidado number; 
ln_xwfcuenta number;
ln_xwfoperacion number;
ln_xwfmoneda number;
ld_aofval date;
ln_sucursal number;   --kvalenciac 29/08/2023 
ln_tipo number; --kvalenciac 29/08/2023                
ln_rango number; --kvalenciac 29/08/2023 
lc_tipo varchar(20);--kvlenciac 29/09/2023
lc_cuenta_operacion varchar(30); --kvalenciac 29/09/2023
lc_var varchar(30);--kvalenciac 27/10/2023
begin                             
---&montoconsolidado = 0
  begin 
    select SNG001Pais,SNG001Tdoc,SNG001NDoc into
           ln_SNG001Pais,ln_SNG001TDOC,lc_SNG001NDoc
     from sng001
    where SNG001Inst = v_instancia;
  exception
   when others then
      ln_SNG001Pais :=0;
  end;
  begin
     select pgfape into ld_pgfape from fst017
     where pgcod=1;
  exception
    when others then
       null;
  end;
  
  ln_tipocambio :=0;
  pQ_CR_CREDITOS_CAP_HS.sp_tipo_cambio_fijo (ld_pgfape,
                                             ln_tipocambio);
  ln_montoconsolidado :=0;                                           
  pq_cr_resolutor_autonomia.sp_cuentas (ln_SNG001Pais, 
                                       ln_SNG001TDOC ,
                                       lc_SNG001NDoc,
                                       ln_tipocambio,
                                       v_instancia,
                                       ld_pgfape,
                                       ln_montoconsolidado);
 begin 
    select xwfcuenta, xwfoperacion, xwfmoneda, xwfsucursal,xwfcuenta || '-' || xwfoperacion into --kvalenciac 29/09/2023
           ln_xwfcuenta, ln_xwfoperacion, ln_xwfmoneda, ln_sucursal, lc_cuenta_operacion  --kvalenciac 29/08/2023
    from xwf700
    where xwfprcins=v_instancia and xwfcar3='1';
  exception
     when others then
        ln_xwfcuenta :=0;
  end;
  ---inicio kvalenciac 29/09/2023 valida el tipo 
  lc_tipo:='';
  begin
  SELECT rtrim(tiporeprogramacion) into lc_tipo 
        from v_reprog 
       WHERE estadosolicitud = 'BT'
         and cuentaoperacion = lc_cuenta_operacion;
  exception
    when others then
       lc_tipo:='';
  end;
  --fin kvalenciac 29/09/2023
 ---veo modalidad  1 es x monto y 2 es x rango  --inicio kvalenciac 29/08/2023
 begin
    select tp1imp1 into ln_tipo
    from fst198
    where Tp1cod= 1
    and Tp1cod1= 10899
    and Tp1corr1=400000
    and Tp1corr2=2
    and Tp1corr3=3;   
   exception
     when others then
       ln_tipo:=1;
   end;
  -----inicio kvalenciac 27/10/2023
  begin
    select rtrim(tp1desc) into lc_var
    from fst198
    where Tp1cod= 1
    and Tp1cod1= 10899
    and Tp1corr1=400000
    and Tp1corr2=2
    and Tp1corr3=5;   
   exception
     when others then
       lc_var:='';
   end;
   -----fin kvalenciac 27/10/2023
  --inicio kvalenciac 29/09/2023   
 if (lc_tipo = lc_var ) then   --'29SEP') then  --kvalenciac 27/10/2023
    --monto tope para los casos 29SEP
      begin
        select tp1imp1 into ln_monto_tope
        from fst198
        where Tp1cod= 1
        and Tp1cod1= 10899
        and Tp1corr1=400000
        and Tp1corr2=2
        and Tp1corr3=4;   
       exception
         when others then
           ln_monto_tope:=0;
       end;  
 else    --fin kvalenciac 29/09/2023
     if (ln_tipo =1 ) then  --fin kvalenciac 29/08/2023
         --monto tope es de una guía
          begin
            select tp1imp1 into ln_monto_tope
            from fst198
            where Tp1cod= 1
            and Tp1cod1= 10899
            and Tp1corr1=400000
            and Tp1corr2=2
            and Tp1corr3=1;   
           exception
             when others then
               ln_monto_tope:=0;
           end;
      else   --inicio kvalenciac 29/08/2023
         --busco el rating de la sucursal de la agencia
         begin
           select tpimp into ln_rango
           from fst098
           where pgcod=1
           and tpcod=7698
           and tpnro=ln_sucursal
           and rownum=1;
         exception
           when others then
             ln_rango:=1;
         end;

         ---según el rango busco el monto
         begin
            select tp1imp1 into ln_monto_tope
            from fst198
            where Tp1cod= 1
            and Tp1cod1= 10899
            and Tp1corr1=400001
            and Tp1corr2=1
            and Tp1corr3>0
            and tp1nro1= ln_rango;   
           exception
             when others then
               ln_monto_tope:=0;
           end;
      end if;  --fin kvalenciac 29/08/2023
  end if;
  --busco fecha de desembolso
  begin 
    select aofval into ld_aofval --fecha de dedesembolso
    from fsd010 
    where aocta= ln_xwfcuenta
    and aooper=ln_xwfoperacion
    and aomda=ln_xwfmoneda
	  and aomod in (select modulo from fst111 where dscod=50) --agregado esto
    and aosbop in (select min(aosbop) from fsd010 where aocta=ln_xwfcuenta and aooper=ln_xwfoperacion and aomda=ln_xwfmoneda and aomod in (select modulo from fst111 where dscod=50));
  exception
    when others then
       null;
  end;
  --fecha de la guía desde se considera monto tope de opinión
  begin
    select tp1desc into lc_fecha
    from fst198
    where Tp1cod= 1
    and Tp1cod1= 10899
    and Tp1corr1=400000
    and Tp1corr2=2
    and Tp1corr3=2;
  exception 
    when others then
      lc_fecha:='';
  end;
  ld_fecha := to_date(trim(lc_fecha), 'DD/MM/YYYY');
  v_requiereopinion :='N';
  --si fecha de desembolso ld_aofval es menor a la fecha de la guía ld_fecha (01/07/2020)
  if ( ld_aofval < ld_fecha ) then 
       DBMS_OUTPUT.put_line('ENTRA1: ');
      --valida monto sea mayor a 300000  guía que esta en la guía
      if ( ln_montoconsolidado > ln_monto_tope ) then
        v_requiereopinion:='S';
      else
        v_requiereopinion:='N';
      end if;
  else
           DBMS_OUTPUT.put_line('ENTRA2: ');
    v_requiereopinion:='S';
  end if;                     
end   sp_validamontoopinion;
--inicio kvalenciac 18/01/2024
procedure sp_validamontoopinionCap(
                             v_instancia   in number,
                             v_requiereopinion out varchar                                                         
                             ) is
ln_monto_tope number;
lc_fecha varchar(30);  
ld_fecha date; 
ln_tipocambio number(14,8);
ld_pgfape date; 
ln_SNG001Pais number;
ln_SNG001TDOC number; 
lc_SNG001NDoc char(12);
ln_montocapital number; 
ln_xwfcuenta number;
ln_xwfoperacion number;
ln_xwfmoneda number;
ld_aofval date;
ln_sucursal number; 
ln_xwfempresa number(3); 
ln_xwfmodulo number(3); 
ln_XWFTIPOPE number(3);
ln_XWFPAPEL number(4);
ln_XWFSUBOPE number(3);
lc_cuenta_operacion varchar(30);
begin                             

  begin 
    select SNG001Pais,SNG001Tdoc,SNG001NDoc into
           ln_SNG001Pais,ln_SNG001TDOC,lc_SNG001NDoc
     from sng001
    where SNG001Inst = v_instancia;
  exception
   when others then
      ln_SNG001Pais :=0;
  end;
  begin
     select pgfape into ld_pgfape from fst017
     where pgcod=1;
  exception
    when others then
       null;
  end;
  begin 
    select xwfempresa, xwfmodulo, XWFTIPOPE, XWFMONEDA, XWFPAPEL, xwfcuenta, xwfoperacion, XWFSUBOPE, xwfsucursal,xwfcuenta || '-' || xwfoperacion into 
           ln_xwfempresa, ln_xwfmodulo, ln_XWFTIPOPE, ln_xwfmoneda, ln_XWFPAPEL, ln_xwfcuenta, ln_xwfoperacion, ln_XWFSUBOPE, ln_sucursal, lc_cuenta_operacion  
    from xwf700
    where xwfprcins=v_instancia and xwfcar3='1';
  exception
     when others then
        ln_xwfcuenta :=0;
  end;
  --busco saldo capital
  begin 
    select abs(scsdo) into ln_montocapital --fecha de dedesembolso
    from fsd011 
    where PGCOD = ln_xwfempresa
    and SCMOD = ln_xwfmodulo
    and SCTOPE = ln_XWFTIPOPE
    and SCMDA = ln_xwfmoneda
    and SCPAP = ln_XWFPAPEL
    and SCCTA = ln_xwfcuenta
    and SCOPER = ln_xwfoperacion
    and SCSBOP = ln_XWFSUBOPE
	  and SCMOD in (select modulo from fst111 where dscod=50);--solo debe ver un registro
  exception
    when others then
       ln_montocapital:=0;
  end;
   --monto tope es de una guía
  begin
            select tp1imp1 into ln_monto_tope
            from fst198
            where Tp1cod= 1
            and Tp1cod1= 10899
            and Tp1corr1=400000
            and Tp1corr2=2
            and Tp1corr3=6;--monto tope   
           exception
             when others then
               ln_monto_tope:=0;
  end;
  if ( ln_montocapital > ln_monto_tope ) then
        v_requiereopinion:='S';
  else
        v_requiereopinion:='N';
  end if;    
                   
end   sp_validamontoopinionCap;
--fin kvalenciac 18/01/2024
procedure sp_requiereopinion(
                             v_instancia   in number,
                             v_requiereopinion out varchar                                                         
                             ) is
ln_monto_tope number;
lc_fecha varchar(30);  
ld_fecha date; 
ln_tipocambio number(14,8);
ld_pgfape date; 
ln_SNG001Pais number;
ln_SNG001TDOC number; 
lc_SNG001NDoc char(12);
ln_montoconsolidado number; 
ln_xwfcuenta number;
ln_xwfoperacion number;
ln_xwfmoneda number;
ld_aofval date;                      
begin                             

 begin 
    select xwfcuenta, xwfoperacion, xwfmoneda into
           ln_xwfcuenta, ln_xwfoperacion, ln_xwfmoneda
    from xwf700
    where xwfprcins=v_instancia and xwfcar3='1';
  exception
     when others then
        ln_xwfcuenta :=0;
  end; 
  --busco fecha de desembolso
  begin 
    select aofval into ld_aofval --fecha de dedesembolso
    from fsd010 
    where aocta= ln_xwfcuenta
    and aooper=ln_xwfoperacion
    and aomda=ln_xwfmoneda
    and aosbop in (select min(aosbop) from fsd010 where aocta=ln_xwfcuenta and aooper=ln_xwfoperacion and aomda=ln_xwfmoneda);
  exception
    when others then
       null;
  end;
  --fecha de la guía desde se considera monto tope de opinión
  begin
    select tp1desc into lc_fecha  --01/07/2021
    from fst198
    where Tp1cod= 1
    and Tp1cod1= 10899
    and Tp1corr1=400000
    and Tp1corr2=2
    and Tp1corr3=2;
  exception 
    when others then
      lc_fecha:='';
  end;
  ld_fecha := to_date(trim(lc_fecha), 'DD/MM/YYYY');
  v_requiereopinion :='N';
  --si fecha de desembolso ld_aofval es menor a la fecha de la guía ld_fecha (01/07/2020)
  if ( ld_aofval >= ld_fecha ) then       
        v_requiereopinion:='S';   
  end if;                     
end   sp_requiereopinion;
procedure sp_validamaontoopilinea(
                             v_instancia   in number,
                             v_esmontomayor out varchar                                                         
                             ) is
ln_monto_tope number;
lc_fecha varchar(30);  
ld_fecha date; 
ln_tipocambio number(14,8);
ld_pgfape date; 
ln_SNG001Pais number;
ln_SNG001TDOC number; 
lc_SNG001NDoc char(12);
ln_montoconsolidado number; 
ln_xwfcuenta number;
ln_xwfoperacion number;
ln_xwfmoneda number;
ld_aofval date; 
                
begin                              
  ---&montoconsolidado = 0
  begin 
    select SNG001Pais,SNG001Tdoc,SNG001NDoc into
           ln_SNG001Pais,ln_SNG001TDOC,lc_SNG001NDoc
     from sng001
    where SNG001Inst = v_instancia;
  exception
   when others then
      ln_SNG001Pais :=0;
  end;
  begin
     select pgfape into ld_pgfape from fst017
     where pgcod=1;
  exception
    when others then
       null;
  end;
  
  ln_tipocambio :=0;
  pQ_CR_CREDITOS_CAP_HS.sp_tipo_cambio_fijo (ld_pgfape,
                                             ln_tipocambio);
  ln_montoconsolidado :=0;                                           
  pq_cr_resolutor_autonomia.sp_cuentas (ln_SNG001Pais, 
                                       ln_SNG001TDOC ,
                                       lc_SNG001NDoc,
                                       ln_tipocambio,
                                       v_instancia,
                                       ld_pgfape,
                                       ln_montoconsolidado);
  begin 
    select xwfcuenta, xwfoperacion, xwfmoneda into
           ln_xwfcuenta, ln_xwfoperacion, ln_xwfmoneda
    from xwf700
    where xwfprcins=v_instancia and xwfcar3='1';
  exception
     when others then
        ln_xwfcuenta :=0;
  end;
  --monto tope es de una guía
  begin
    select tp1imp1 into ln_monto_tope
    from fst198
    where Tp1cod= 1
    and Tp1cod1= 10899
    and Tp1corr1=400000
    and Tp1corr2=2
    and Tp1corr3=1;   
   exception
     when others then
       ln_monto_tope:=0;
   end;  
  v_esmontomayor :='N';
  --valida si el monto es mayor al monto de la guía
  if ( ln_montoconsolidado > ln_monto_tope ) then
        v_esmontomayor:='S';
  else
        v_esmontomayor:='N';
  end if;
                    
end   sp_validamaontoopilinea;                                                
end pq_cr_reprogramaopinion;
/

