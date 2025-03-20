CREATE OR REPLACE TRIGGER TG_WFWRKITEMS_BI_01
  after insert on wfwrkitems
  for each row
declare
  x                     number(2);
  mensaje               varchar(8000);
  asunto                varchar(150);
  usuario               varchar(50);
  pn_codigo             numeric(10);
  pn_cuenta             number(9);
  pn_dni                char(12);
  pc_nombres            char(30);
  pn_plazo              number(5);
  pn_importe            number(17, 2);
  pn_operacion          number(9);
  pc_nom_garantia       char(30);
  pc_nombre_aval        char(60);
--11.10.2018
--var_garantias         char(500);
  var_garantias         varchar2(500);
  pn_cuenta_garantia    number(9);
  pn_operacion_garantia number(9);
  var_cuentagar         varchar(500);
  var_opergarant        varchar(500);
  pn_sucursal           number(3);
  pc_sucursal           char(30);
  pn_tipo_operacion7    number(9);
  pn_mont_gar           number(17, 2);
  pn_mont_gar_total     number(17, 2) := 0;
  pn_xwfmoneda          number(2);
  simbolo               char(3);
  pc_mes                char(10);
  pn_moneda_gar         number(3);
  descri_moneda         char(10);
  pn_contador           number := 0;
  flag                  char(1) := 'N';
  pn_cantcuox           number(5);
  pn_modulox            number(3);
  pn_periodo            number(5);
  pn_modulo             number(3);
  pn_sucursal1           number(3);
  pn_moneda             number(4);
  pn_papel              number(4);
  pn_suope              number(3);
  pn_pgcod_gatantia     number(3);
  pn_modulo_gatantia    number(3);
  pn_sucur_gatantia     number(3);
  pn_moneda_gatantia    number(4);
  pn_papel_gatantia     number(4);
  pn_subope_gatantia    number(3);
  pn_tipoope_gatantia   number(3);
  pn_estado_garantia    number(2);
  pc_nombre_garantia    character(30);


  cursor sng122 is
    select b.sng122mod, b.sng122tope, b.sng122cta, b.sng122oper
      from sng122 b
     inner join fst098 a
        on b.sng122tope = a.tpnro
     where b.sng122pgc = 1
       and b.sng122inst = pn_codigo
       and a.pgcod = 1
       and a.tpcod = 7732
       and a.tpcorr > 200;

  cursor fst098 is
    select a.tpdesc
      from fst098 a
     where a.pgcod = 1
       and a.tpcod = 7732
       and a.tpcorr < 201;

begin
  --Si cambia a estado 55 verifica si tiene ingreso de opinion de lo contrario enviar correo
  mensaje   := '';
  asunto    := '';
  pn_codigo := :new.wfinsprcid; -- numero de instancia

  --begin
  
    Begin
      select count(*)
        into pn_contador
        from sng122 b
       inner join fst098 a
          on b.sng122tope = a.tpnro
       where b.sng122pgc = 1
         and b.sng122inst = pn_codigo
         and a.pgcod = 1
         and a.tpcod = 7732
         and a.tpcorr > 200;
    exception
      when others then
        pn_contador := 0;
      
    end;
  
    if pn_contador > 0 then
    
      if :new.wftaskcod = 55 and :new.wfitemstsact = 1 and :new.wfitemprvtask = 11 then
      
          for p in sng122 loop
            ----agregado para la validacion de garantia real y agregar guia de proceso para correo
          
            begin
              -----------cuenta del credito
              select a.xwfcuenta, a.xwfoperacion, a.xwftipope,a.xwfmodulo,a.xwfsucursal,a.xwfmoneda,a.xwfpapel,a.xwfsubope
                into pn_cuenta, pn_operacion, pn_tipo_operacion7,pn_modulo,pn_sucursal1, pn_moneda, pn_papel,pn_suope
                from xwf700 a
               where a.xwfempresa = 1
                 and a.xwfprcins = pn_codigo
                 and a.xwfcar3 = '1';
            exception
              when others then
                pn_tipo_operacion7 := null;
            end;
                      
            begin
              ---- descripcion de la garantia
            
              select c.tonom
                into pc_nom_garantia
                from FST004 c
               where c.Modulo = p.sng122mod
                 and c.Totope = p.sng122tope;
            
            exception
              when others then
                pc_nom_garantia := null;
              
            end;
          
            if var_garantias is null then
              var_garantias := pc_nom_garantia;
            else
              var_garantias := var_garantias || ', ' || pc_nom_garantia;
            end if;
          
            begin
              ---cuenta de garantia
            
              select a.sng122pgc,a.sng122mod,a.sng122suc,a.sng122mda,a.sng122pap,a.sng122cta,a.sng122oper,a.sng122sbop,a.sng122tope --SUBSTR(a.sng122cta,2,1000) 
                into pn_pgcod_gatantia,pn_modulo_gatantia,pn_sucur_gatantia,pn_moneda_gatantia, pn_papel_gatantia,pn_cuenta_garantia, pn_operacion_garantia, pn_subope_gatantia,pn_tipoope_gatantia
                from sng122 a
               where a.sng122pgc = 1
                 and a.sng122cta = p.sng122cta
                 and a.sng122oper = p.sng122oper
                 and a.sng122inst = pn_codigo;
             
            exception
              when others then
                pn_cuenta_garantia := 0;
                pn_operacion_garantia := 0;
            end;
          
            if var_cuentagar is null then
              var_cuentagar := pn_cuenta_garantia;
              var_opergarant := pn_operacion_garantia;
            else
              var_cuentagar := var_cuentagar || ', ' || pn_cuenta_garantia;
              var_opergarant := var_opergarant || ', ' ||pn_operacion_garantia;
            end if;
            
            begin 
            ---------------Estado de la garantia
            select s.aostat 
            into pn_estado_garantia 
            from fsd010 s
            where s.pgcod = pn_pgcod_gatantia
            and s.aomod=pn_modulo_gatantia
            and s.aosuc=pn_sucur_gatantia
            and s.aomda=pn_moneda_gatantia
            and s.aopap= pn_papel_gatantia
            and s.aocta=pn_cuenta_garantia
            and s.aooper= pn_operacion_garantia
            and s.aosbop= pn_subope_gatantia
            and s.aotope= pn_tipoope_gatantia;
            exception
              when others then
                pn_estado_garantia := null;
            
            end;
            
            -----descripcion de la garnatia
            begin
                                        
            select a.cenom 
            into pc_nombre_garantia
            from fst026 a 
            where a.cecod = pn_estado_garantia;
            exception
              when others then
                pc_nombre_garantia := null;
              
            end;
                       
          
            begin
              ----importe de garantia
                    
              select s.sng122sdog, s.sng122mda
                into pn_mont_gar, pn_moneda_gar
                from sng122 s
               where s.sng122pgc = 1
                 and s.sng122cta = pn_cuenta_garantia
                 and s.sng122oper = pn_operacion_garantia
                 and s.sng122inst = pn_codigo;
                    
            exception
              when others then
                pn_mont_gar := null;
                      
            end;
              
            pn_mont_gar_total := pn_mont_gar_total + pn_mont_gar;
              
            if pn_moneda_gar = 101 then
              descri_moneda := 'USD';
            end if;
              
            if pn_moneda_gar = 0 then
              descri_moneda := 'PEN';
            end if;
              
            begin
              -------------dni del cliente
                
              select b.pendoc
                into pn_dni
                from fsr008 b
               where b.pgcod = 1
                 and b.ctnro = pn_cuenta
                 and b.cttfir = 'T';
            exception
              when others then
                pn_dni := null;
                  
            end;
            
            if pn_dni is not null then
                begin
                  -------------nombres del cliente
                  select c.penom
                    into pc_nombres
                    from FSD001 c
                   where c.pepais = 604
                     and c.pendoc = pn_dni;
                exception
                  when others then
                    pc_nombres := null;
                      
                end;
            end if;
                            
                begin
                  --------------monto
                  select x.xwfmonto1,/* x.xwfplazo1,*/ x.xwfmoneda
                    into pn_importe, /*pn_plazo, */pn_xwfmoneda
                    from xwf700 x
                   where x.xwfempresa = 1
                     and x.xwfcuenta = pn_cuenta -- pn_cuenta
                     and x.xwfoperacion = pn_operacion
                     and x.xwfcar3 = '1'; -- pn_operacion ;
                exception
                  when others then
              --      pn_plazo     := null;
                    pn_importe   := null;
                    pn_xwfmoneda := null;
                  
                end;
              
                if pn_xwfmoneda = 101 then
                  simbolo  := '$/';
                end if;
              
                if pn_xwfmoneda = 0 then
                  simbolo  := 'S/';               
                end if;
          ----------------------------------------------------------------------------------------------      
                ----plazo
               begin --pn_cuenta, pn_operacion,

                select  a.xllcantcuo,a.xllperiodo, a.xllaomod
                into pn_cantcuox , pn_periodo, pn_modulox
                 from x054023 a
                 where a.xllpgcod = 1 
                 and a.xllaomod= pn_modulo
                 and a.xllaosuc= pn_sucursal1
                 and a.xllaomda = pn_moneda
                 and a.xllaopap= pn_papel
                 and a.xllaocta= pn_cuenta  
                 and a.xllaooper= pn_operacion
                 and a.xllaosbop = pn_suope
                 and a.xllaotop = pn_tipo_operacion7;
                 
                 exception
                  when others then

                    pn_cantcuox   := null;
                    pn_periodo    := null;
                    pn_modulox    := null;
                
                end;
                
                if pn_modulox = 116 then
                  
                     if pn_periodo = 30 then
                      pc_mes   := ' Meses';
                    end if;
                     if pn_periodo = 60 then
                      pc_mes   := ' Bimensual';
                    end if;
                     if pn_periodo = 90 then
                      pc_mes   := ' Trimestral';
                    end if;
                    
                end if;
                
               if pn_modulox <> 116 then
                  
                     if pn_periodo = 30 then
                      pn_plazo := pn_cantcuox;
                      pc_mes   := ' /Meses';
                    end if;
                     if pn_periodo = 60 then
                      pn_plazo := pn_cantcuox;
                      pc_mes   := ' /Bimensual';
                    end if;
                     if pn_periodo = 90 then
                      pn_plazo := pn_cantcuox;
                      pc_mes   := ' /Trimestral';
                    end if;
                    
                end if;
                
              
                begin
                  ---titular de garantia
                
                  select a.pendoc
                    into pn_dni
                    from fsr008 a
                   where a.pgcod = 1
                     and a.cttfir = 'T'
                     and a.ctnro = pn_cuenta_garantia; ---titular de la garantia
                
                exception
                  when others then
                    pn_dni := null;
                end;
              
                begin
                  select b.penom
                    into pc_nombre_aval
                    from fsd001 b
                   where b.pepais = 604
                     and b.pendoc = pn_dni; ------obtengo titular de garantia 
                exception
                  when others then
                    pc_nombre_aval := '';
                  
                end;
              
                begin
                  --- Agencia
                
                  select s.xwfsucursal
                    INTo pn_sucursal
                    from xwf700 s
                   where s.xwfempresa = 1
                     and s.xwfcuenta = pn_cuenta
                     and s.xwfoperacion = pn_operacion;
                exception
                  when others then
                    pn_sucursal := null;
                  
                end;
              
                begin
                  -------------Nombre de la agencia 
                
                  select a.scnom
                    into pc_sucursal
                    from FST001 a
                   where a.pgcod = 1
                     and a.sucurs = pn_sucursal;
                exception
                  when others then
                    pc_sucursal := null;
                  
                end;
                flag := 'S';
          end loop;
          
         If  flag = 'S' then
            --envio de correo
            for r in fst098 loop
            
              begin
                usuario := '';
              
                --SELECT  A LA GUIA DE PROCESO PARA LEER LOS CORREOS 
                
                  usuario := trim(r.tpdesc);
                  usuario := usuario || '@cajaarequipa.pe';
                           
                mensaje := '<html>
                     <head>
                      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
                      <style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>
                     </head>
                     <body>
                      <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
                    Su solicitud de cr&#233;dito con garant&#237;a real ha sido aprobada con los siguientes datos: </p>     
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">
                          <b>N&#250;mero de solicitud de cr&#233;dito:</b> ' ||
                                 (pn_codigo) || ' </p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">   
                       <b>Cliente:</b> ' || TO_CHAR(pc_nombres) ||
                                 ' </p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">   
                       <b>Plazo: </b>' || TO_CHAR(pn_plazo) || '' ||
                                 pc_mes || '</p>    
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">   
                       <b>Monto:</b>' || simbolo || '' ||
                                 TO_CHAR(pn_importe) ||
                                 '</p>   
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Tipo de garant&#237;a:</b>' ||
                                 TO_CHAR(var_garantias) ||
                                 '</p> 
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Importe de garant&#237;a:</b>' ||
                                 descri_moneda || ' ' || TO_CHAR(pn_mont_gar_total) ||
                                 '</p>   
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>N&#250;mero de Cuenta de garant&#237;a:</b>' ||
                                 TO_CHAR(pn_cuenta_garantia) ||
                                 '</p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Operaci&#243;n de la garant&#237;a:</b>' ||
                                 TO_CHAR(pn_operacion_garantia) ||
                                 '</p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Estado de la garant&#237;a:</b>' ||
                                 TO_CHAR(pc_nombre_garantia) ||
                     '</p>    
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Titular de garant&#237;a: </b>' ||
                                 TO_CHAR(pc_nombre_aval) ||
                                 '</p>
                    <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">     
                       <b>Agencia:</b>' || TO_CHAR(pc_sucursal) ||
                                 '</p>    
                      <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"><b>Muchas Gracias y Saludos.</b></p>
                     </body>
                     
                  </html>';
                asunto := 'Alerta de aprobacion de Garantia real';
              
                sys.sp_sy_enviamail_html(pc_aquien  => usuario,
                                         pc_de      => 'notificacionesGarantias@cajaarequipa.pe',
                                         pc_motivo  => asunto, --'Alerta de aprobacion de Garantia real',
                                         pc_mensaje => mensaje);
              
              end;
            end loop;
        end if;
        --envio de correo 
        
      end if;
    
      
    end if;
   
exception
    
  when others then 
    
        Null;
     
  
end INS_WFWRKITEMS_CORR_GARANTIAS;
/

