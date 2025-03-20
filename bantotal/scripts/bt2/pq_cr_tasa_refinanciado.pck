create or replace package PQ_CR_TASA_REFINANCIADO is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure SP_RETORNA_TASA( pn_instancia in number, pn_tasa out number);   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_TASA_REFINANCIADO;
/

create or replace package body PQ_CR_TASA_REFINANCIADO is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TASA_REFINANCIADO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.06.14
    -- Autor de Creación          : DCASTRO
    -- Uso                        : RETORNA TASA DE REFINANCIADOS 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2017.07.12
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico condicion al obtener el tipo de cambio en SP_RETORNA_TASA
    --                            : 
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_RETORNA_TASA( PN_INSTANCIA in number, pn_tasa out number) is
    -- *****************************************************************
    -- Nombre                     : SP_RETORNA_TASA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.06.14
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Obtiene tasa para credito refinanciado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2017.07.12
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico condicion al obtener el tipo de cambio  <= por =
    -- *****************************************************************


cursor refinanciado(ln_instancia number) is 
select * from xwf700 f where f.xwfprcins = ln_instancia and f.xwfcar3 in ('J', 'R');


ln_moneda number;
ln_tasa number:=0;

--ln_instancia number:= 2864537;--2859830;--2843773;--2835522;--2844697;
--observados 2859830;--2852709;--2857112;--2857686;--2761816; --2845034;-- 2830677;--2837923;--1513830;--2848373;--2795851;--2761816;--2828995;--2830624;

ln_monto number:=0;
ln_mtotot number:=0;
ln_mtotas number:=0;
ln_modulo number:=0; 
ln_mtotasa number:=0; 
ln_tipoope  number:=0;
ld_fecha date;
ld_fecTC date;
ln_tipcam number(14,8);
ln_tasfin number;
ln_tasini number;
ln_numero number:=0;
ln_mtoini number:=0;
ln_cuenta number:=0;

BEGIN

  begin
    select pgfape into ld_fecha from fst017 where pgcod = 1;
  end;   

  begin
      select max(cofdes) into ld_fecTC from fsh005 where moneda = 0 and cofdes <= ld_fecha and cotcbi > 0;
  end;
  


  begin
      select f.xwfmoneda, f.xwfmodulo, f.xwftipope, f.xwfcuenta 
        into ln_moneda, ln_modulo, ln_tipoope, ln_cuenta --, ln_tasIni
        from xwf700 f 
       where f.xwfprcins = PN_INSTANCIA and f.xwfcar3 = '1'; 
  end; 
  
--  dbms_output.put_line('Instancia '|| ln_instancia ||' ln_cuenta '||ln_cuenta);
--  dbms_output.put_line('TipoCambio '|| ld_fecTC);    

--  dbms_output.put_line('ln_moneda '|| ln_moneda||' ln_modulo '||ln_modulo||' ln_tipoope ' ||ln_tipoope);
  
  -- contar creditos a refinanciar
 begin 
  select count(*) into ln_numero
   from xwf700 f where f.xwfprcins = PN_INSTANCIA and f.xwfcar3 in ( 'R', 'J');
 exception when others then
   ln_numero := 0;
 end;  
   
--  dbms_output.put_line('ln_numero '||ln_numero); 
  
  --obtener creditos que seran refinanciados
  for i in refinanciado(PN_INSTANCIA) loop
      
      --valida moneda
      if i.xwfmoneda = ln_moneda then
          --buscar en FSD012
          begin
               select f.evtasa
                 into ln_tasa
                 from fsd012 f
                where f.pgcod = i.xwfempresa
                  and f.aomod = i.xwfmodulo
                  and f.aosuc = i.xwfsucursal
                  and f.aomda = i.xwfmoneda
                  and f.aopap = i.xwfpapel
                  and f.aocta =  i.xwfcuenta
                  and f.aooper = i.xwfoperacion
                  and f.aosbop = i.xwfsubope
                  and f.aotope =  i.xwftipope
                  and f.evtipo = 3
                  and f.d012co = 'S';
          exception when no_data_found then 
               ln_tasa := 0;             
          end;
          
      --    dbms_output.put_line('CambioTasa '||ln_tasa); 
            
                     
          if ln_tasa = 0 then

           --obtener tasa de fsd010        
              begin
                   select f.AOTASA, f.AOIMP
                     into ln_tasa, ln_monto 
                     from fsd010 f
                    where f.pgcod = i.xwfempresa
                      and f.aomod = i.xwfmodulo
                      and f.aosuc = i.xwfsucursal
                      and f.aomda = i.xwfmoneda
                      and f.aopap = i.xwfpapel
                      and f.aocta =  i.xwfcuenta
                      and f.aooper = i.xwfoperacion
                      and f.aosbop = i.xwfsubope
                      and f.aotope =  i.xwftipope;
              exception when no_data_found then 
                   ln_tasa := 0;     
                   ln_monto := 0;        
              end;
            
       --     dbms_output.put_line('TasaFSD010 '||ln_tasa||' ln_monto '||ln_monto); 
                      
          else


           --obtener tasa de fsd010        
              begin
                   select f.AOIMP
                     into ln_monto 
                     from fsd010 f
                    where f.pgcod = i.xwfempresa
                      and f.aomod = i.xwfmodulo
                      and f.aosuc = i.xwfsucursal
                      and f.aomda = i.xwfmoneda
                      and f.aopap = i.xwfpapel
                      and f.aocta =  i.xwfcuenta
                      and f.aooper = i.xwfoperacion
                      and f.aosbop = i.xwfsubope
                      and f.aotope =  i.xwftipope;
              exception when no_data_found then 
                   ln_monto := 0;        
              end;
           
        --    dbms_output.put_line('Se cambio Tasa obtiene ln_monto '||ln_monto); 
           
          end if; 
        
          if ln_numero = 1 then --refinanciacion de 1-1
             ln_tasfin := ln_tasa;
             --dbms_output.put_line('Ref 1-1 '||ln_numero); 
             exit;
             
          else   
             
             ln_mtotot := ln_mtotot + ln_monto ;
             ln_mtotas := ln_mtotas + (ln_monto * ln_tasa);
             
         --    dbms_output.put_line('ln_mtotas '||ln_mtotas || ' ln_mtotot '||ln_mtotot); 
               
          end if;
        
      
      else --Si moneda es diferente
      --aplicar tipo cambio
      
      --buscar en FSD012
          begin
               select f.evtasa
                 into ln_tasa
                 from fsd012 f
                where f.pgcod = i.xwfempresa
                  and f.aomod = i.xwfmodulo
                  and f.aosuc = i.xwfsucursal
                  and f.aomda = i.xwfmoneda
                  and f.aopap = i.xwfpapel
                  and f.aocta =  i.xwfcuenta
                  and f.aooper = i.xwfoperacion
                  and f.aosbop = i.xwfsubope
                  and f.aotope =  i.xwftipope
                  and f.evtipo = 3
                  and f.d012co = 'S';
          exception when no_data_found then 
               ln_tasa := 0;             
          end;
      
         if ln_tasa = 0 then

           --obtener tasa de fsd010        
              begin
                   select f.AOTASA, f.AOIMP
                     into ln_tasa, ln_monto 
                     from fsd010 f
                    where f.pgcod = i.xwfempresa
                      and f.aomod = i.xwfmodulo
                      and f.aosuc = i.xwfsucursal
                      and f.aomda = i.xwfmoneda
                      and f.aopap = i.xwfpapel
                      and f.aocta =  i.xwfcuenta
                      and f.aooper = i.xwfoperacion
                      and f.aosbop = i.xwfsubope
                      and f.aotope =  i.xwftipope;
              exception when no_data_found then 
                   ln_tasa := 0;     
                   ln_monto := 0;        
              end;
            
       --     dbms_output.put_line('TasaFSD010 '||ln_tasa||' ln_monto '||ln_monto); 
                      
          else


           --obtener tasa de fsd010        
              begin
                   select f.AOIMP
                     into ln_monto 
                     from fsd010 f
                    where f.pgcod = i.xwfempresa
                      and f.aomod = i.xwfmodulo
                      and f.aosuc = i.xwfsucursal
                      and f.aomda = i.xwfmoneda
                      and f.aopap = i.xwfpapel
                      and f.aocta =  i.xwfcuenta
                      and f.aooper = i.xwfoperacion
                      and f.aosbop = i.xwfsubope
                      and f.aotope =  i.xwftipope;
              exception when no_data_found then 
                   ln_monto := 0;        
              end;
         end if;
   
         --obtener tipo de cambio
         begin
             select cotcbi
               into ln_tipcam 
               from fsh005 where moneda = 101 and cofdes = ld_fecTC and cotcbi > 0;
         end;   
         
         if ln_moneda = 0 then --soles 
            ln_MtoIni := ln_monto * ln_tipcam;
         else --dolares
            ln_MtoIni := ln_monto / ln_tipcam;         
         end if;
      
         ---Busca tasa en PIZARRA
         --obtener tasa
         begin
            select min(tamto) into ln_mtotasa
            from fpp028 f , fsr025 g 
            where g.tpizar = f.pp028defn
            and f.pp017par = 17 
            and f.pp028mod = g.tamod
            and f.pp028mda = g.tamda
            and f.pp028pap = g.tapap
            and f.pp028mod = ln_modulo
            and f.pp028mda = ln_moneda
            and f.pp028top = ln_tipoope
            and g.tamto >= ln_MtoIni;
         exception when others then
                   ln_mtotasa := 0;      
         end;   

       
          begin  
            select tatasa
            into ln_tasa
            from fpp028 f , fsr025 g 
            where g.tpizar = f.pp028defn
            and f.pp017par = 17 
            and f.pp028mod = g.tamod
            and f.pp028mda = g.tamda
            and f.pp028pap = g.tapap
            and f.pp028mod = ln_modulo
            and f.pp028mda = ln_moneda
            and f.pp028top = ln_tipoope
            and g.tamto = ln_mtotasa;
         exception when others then
                   ln_tasa := 0;   
         end;   
      
      
          if ln_numero = 1 then --refinanciacion de 1-1
                 ln_tasfin := ln_tasa;
                 exit;
          else   
             ln_mtotot := ln_mtotot + ln_MtoIni ;
             ln_mtotas := ln_mtotas + (ln_MtoIni * ln_tasa);
      
          end if;
             
      end if;
  
  
  
  end loop;

  if ln_numero > 1 then
    ln_tasfin := ln_mtotas / ln_mtotot ;
  end if;
    
  
  --dbms_output.put_line('ln_mtotas '||ln_mtotas || ' ln_mtotot '||ln_mtotot); 
  
  --dbms_output.put_line('ln_tasfin '||ln_tasfin); 
   
 pn_tasa := ln_tasfin;
 

 
 
 end SP_RETORNA_TASA;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_TASA_REFINANCIADO;
/

