create or replace package PQ_CR_RN_REPROG_CAJA is

 /* ************************************************************************************************************
    -- Nombre                     : PQ_CR_RN_REPROG_CAJA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ACTIVAS
    -- Descripción                : Politicas para Reprogramados Caja
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.06
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -- 
    -- Autor de la Modificación   : -- 
    -- Descripción de Modificación: --
 * *************************************************************************************************************/

procedure sp_buscar_credito (pn_instancia in number, pn_pgcod out number, 
          pn_lcmod out number, pn_lcsuc out number, pn_lcmda out number, pn_lcpap out number, 
          pn_lccta out number, pn_lcoper out number, pn_lcsbop out number, pn_lctope out number); 
          
procedure sp_lineacredito_vinculada (pn_instancia in number, pn_instancia2 out number, pn_pgcod out number, 
          pn_lcmod out number, pn_lcsuc out number, pn_lcmda out number, pn_lcpap out number, 
          pn_lccta out number, pn_lcoper out number, pn_lcsbop out number, pn_lctope out number);
          
procedure sp_instancia_vinculada (pn_instancia in number, pn_instancia2 out number);
   
procedure sp_cr_si_listado_bi (pn_instancia in number, pv_res_listado out varchar2);

procedure sp_cr_si_panel_reprog (pn_instancia in number, pv_res_panel out varchar2, pv_facilidad out varchar2, pn_codfacil out number);

procedure sp_cr_si_cuota_reprog (pn_instancia in number, pv_res_cuota out varchar2);

procedure sp_cr_si_tasa_reprog (pn_instancia in number, pv_res_tasa out varchar2);
  
procedure sp_cr_si_tasaCta_reprog (pn_instancia in number, pv_res_tasaCta out varchar2);

end PQ_CR_RN_REPROG_CAJA;
/

create or replace package body PQ_CR_RN_REPROG_CAJA is

procedure sp_buscar_credito (pn_instancia in number, pn_pgcod out number, 
          pn_lcmod out number, pn_lcsuc out number, pn_lcmda out number, pn_lcpap out number, 
          pn_lccta out number, pn_lcoper out number, pn_lcsbop out number, pn_lctope out number) 
    -- *****************************************************************
    -- Nombre                     : sp_buscar_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Devuelve la clave del credito vinculado
    -- Estado                     : Activo
    -- Acceso                     : Privado
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pn_pgcod ( Codigo Empresa )
    --                              pn_lcmod ( Modulo )
    --                              pn_lcmod ( Sucursal )
    --                              pn_lcmda ( Moneda )
    --                              pn_lcpap ( Papel )
    --                              pn_lccta ( Cuenta )
    --                              pn_lcoper ( Operacion )
    --                              pn_lcsbop ( Sub Operacion )
    --                              pn_lctope ( Tipo Operacion )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
  begin         
        begin 
           select b.xwfempresa, b.xwfmodulo, b.xwfsucursal, 
                  b.xwfmoneda, b.xwfpapel, b.xwfcuenta, 
                  b.xwfoperacion, b.xwfsubope, b.xwftipope
                  into pn_pgcod, pn_lcmod, pn_lcsuc, 
                       pn_lcmda, pn_lcpap, pn_lccta, 
                       pn_lcoper, pn_lcsbop, pn_lctope
                  from xwf700 b 
           where b.xwfprcins = pn_instancia and b.xwfcar3 = '1';
        exception
           when others then
               pn_pgcod := 0; 
               pn_lcmod := 0; 
               pn_lcsuc := 0; 
               pn_lcmda := 0; 
               pn_lcpap := 0; 
               pn_lccta := 0; 
               pn_lcoper := 0; 
               pn_lcsbop := 0; 
               pn_lctope := 0; 
        end;       
end sp_buscar_credito;

procedure sp_lineacredito_vinculada (pn_instancia in number, pn_instancia2 out number, pn_pgcod out number, 
          pn_lcmod out number, pn_lcsuc out number, pn_lcmda out number, pn_lcpap out number, 
          pn_lccta out number, pn_lcoper out number, pn_lcsbop out number, pn_lctope out number) 
    -- *****************************************************************
    -- Nombre                     : sp_lineacredito_vinculada
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Devuelve la instancia y clave del credito vinculado
    -- Estado                     : Activo
    -- Acceso                     : Privado
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pn_instancia2 ( Instancia Linea Credito )
    --                              pn_pgcod ( Codigo Empresa )
    --                              pn_lcmod ( Modulo )
    --                              pn_lcmod ( Sucursal )
    --                              pn_lcmda ( Moneda )
    --                              pn_lcpap ( Papel )
    --                              pn_lccta ( Cuenta )
    --                              pn_lcoper ( Operacion )
    --                              pn_lcsbop ( Sub Operacion )
    --                              pn_lctope ( Tipo Operacion )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
  begin         
        begin 
           select a.jaqy800ins2, b.xwfempresa, b.xwfmodulo, b.xwfsucursal, b.xwfmoneda, 
                  b.xwfpapel, b.xwfcuenta, b.xwfoperacion, b.xwfsubope, b.xwftipope
                  into pn_instancia2, pn_pgcod, pn_lcmod, pn_lcsuc, pn_lcmda, pn_lcpap,
                      pn_lccta, pn_lcoper, pn_lcsbop, pn_lctope
                  from jaqy800 a  
                  inner join xwf700 b on b.xwfprcins = a.jaqy800ins
           where a.jaqy800ins = pn_instancia and a.jaqy800tpc = 'P' and B.xwfcar3='1';
        exception
           when others then
               pn_instancia2 := 0; 
               pn_pgcod := 0; 
               pn_lcmod := 0; 
               pn_lcsuc := 0; 
               pn_lcmda := 0; 
               pn_lcpap := 0; 
               pn_lccta := 0; 
               pn_lcoper := 0; 
               pn_lcsbop := 0; 
               pn_lctope := 0; 
        end;       
end sp_lineacredito_vinculada;   

procedure sp_instancia_vinculada (pn_instancia in number, pn_instancia2 out number) 
    -- *****************************************************************
    -- Nombre                     : sp_instancia_vinculada
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Devuelve la instancia de la linea de credito vinculada
    -- Estado                     : Activo
    -- Acceso                     : Privado
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pn_instancia2 ( Instancia Linea Credito )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
  begin         
        begin 
           select a.jaqy800ins2 into pn_instancia2
                  from jaqy800 a  
           where a.jaqy800ins = pn_instancia and a.jaqy800tpc = 'P';
        exception
           when others then
               pn_instancia2 := 0;
        end;       
end sp_instancia_vinculada; 

procedure sp_cr_si_listado_bi (pn_instancia in number, pv_res_listado out varchar2) 
    -- *****************************************************************
    -- Nombre                     : sp_cr_si_listado_bi
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.06
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica que indica si el crédito esta incluido en la tabla aqpb904a
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pv_res_listado ( Resultado S/N )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        ln_si_lista integer;  
        ln_instancia2 number;               
  begin
        ln_si_lista := 0;
        ln_instancia2 := 0; 
        begin          
            PQ_CR_RN_REPROG_CAJA.sp_instancia_vinculada(pn_instancia,ln_instancia2);
            select count(*) into ln_si_lista from aqpb904a where aqpb904ains = ln_instancia2;
        end;
        if ln_si_lista = 0 then
           pv_res_listado := 'N';   
        else
           pv_res_listado := 'S';  
        end if;   
end sp_cr_si_listado_bi;    

procedure sp_cr_si_panel_reprog (pn_instancia in number, pv_res_panel out varchar2, pv_facilidad out varchar2, pn_codfacil out number) 
    -- *****************************************************************
    -- Nombre                     : sp_cr_si_panel_reprog
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.06
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica que indica si el crédito fue gestionado y esta incluido en la tabla aqpb904
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pv_res_panel ( Resultado S/N )
    --                              pv_facilidad ( Facilidad )
    --                              pn_codfacil  ( Codigo Facilidad )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        ln_si_panel integer;  
        lv_facilid  varchar2(150);
        ln_codfacil number;
        ln_instancia2 number;  
  begin
        ln_si_panel := 0;
        lv_facilid := ''; 
        ln_codfacil := 0; 
        ln_instancia2 := 0;
        begin
            PQ_CR_RN_REPROG_CAJA.sp_instancia_vinculada(pn_instancia,ln_instancia2);
            select count(*) into ln_si_panel from aqpb904 where aqpb904ins = ln_instancia2 and aqpb904esta = 'G' and aqpb904ehab = 'H';
        end;
        if ln_si_panel = 0 then
           pv_res_panel := 'N'; 
           pv_facilidad := '-'; 
           pn_codfacil  := 0;    
        else
           begin
              select aqpb904faci, aqpb904cfaci into lv_facilid, ln_codfacil from aqpb904 where aqpb904ins = ln_instancia2 and aqpb904esta = 'G' and aqpb904ehab = 'H';
           end;
           pv_res_panel := 'S';  
           pv_facilidad := lv_facilid;
           pn_codfacil  := ln_codfacil;      
        end if;   
end sp_cr_si_panel_reprog;      

procedure sp_cr_si_cuota_reprog (pn_instancia in number, pv_res_cuota out varchar2)
    -- *****************************************************************
    -- Nombre                     : sp_cr_si_cuota_reprog
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica que indica si el monto de descuento no sea mayor ultima cuota
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pv_res_cuota ( Resultado S/N )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        ld_feult_cuota date;
        ln_instancia2 number; 
        ln_monto number;
        ln_segur number;
        ln_montd number;
        ln_pgcod number; 
        ln_lcmod number; 
        ln_lcsuc number; 
        ln_lcmda number; 
        ln_lcpap number; 
        ln_lccta number; 
        ln_lcoper number; 
        ln_lcsbop number; 
        ln_lctope number;  
  begin
        ln_instancia2 := 0;
        ln_montd := 0;
        ln_monto := 0;
        ln_segur := 0;
        ln_pgcod := 0; 
        ln_lcmod := 0; 
        ln_lcsuc := 0; 
        ln_lcmda := 0; 
        ln_lcpap := 0; 
        ln_lccta := 0; 
        ln_lcoper := 0; 
        ln_lcsbop := 0; 
        ln_lctope := 0; 
        begin
            PQ_CR_RN_REPROG_CAJA.sp_lineacredito_vinculada(pn_instancia,ln_instancia2,ln_pgcod,ln_lcmod,ln_lcsuc,ln_lcmda,ln_lcpap,ln_lccta,ln_lcoper,ln_lcsbop,ln_lctope);
            
            select nvl(aqpb904mntd,0) into ln_montd from aqpb904 where aqpb904ins = ln_instancia2 and aqpb904esta = 'G' and aqpb904ehab = 'H';
            
            select max(ppfpag) into ld_feult_cuota from fsd601 
                   where pgcod = ln_pgcod and ppmod = ln_lcmod and ppsuc = ln_lcsuc and ppmda = ln_lcmda and pppap = ln_lcpap 
                     and ppcta = ln_lccta and ppoper = ln_lcoper and ppsbop = ln_lcsbop and pptope = ln_lctope;
            
            select nvl(sum(ppcap + ppint),0) into ln_monto from fsd601 
                   where pgcod = ln_pgcod and ppmod = ln_lcmod and ppsuc = ln_lcsuc and ppmda = ln_lcmda and pppap = ln_lcpap 
                     and ppcta = ln_lccta and ppoper = ln_lcoper and ppsbop= ln_lcsbop and pptope = ln_lctope and ppfpag = ld_feult_cuota;
            
            select nvl(sum(ppimp10 + ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15 + ppimp16 + ppimp17 + ppimp18 + ppimp19 + ppimp20),0) into ln_segur from fsd611  
                   where pgcod = ln_pgcod and ppmod = ln_lcmod and ppsuc = ln_lcsuc and ppmda = ln_lcmda and pppap = ln_lcpap 
                     and ppcta = ln_lccta and ppoper = ln_lcoper and ppsbop= ln_lcsbop and pptope = ln_lctope and ppfpag = ld_feult_cuota;
            
            ln_monto := ln_monto + ln_segur;
            if ln_montd > ln_monto then      
                pv_res_cuota := 'S'; 
            else      
                pv_res_cuota := 'N'; 
            end if;
        exception when others then        
                pv_res_cuota := 'E';                                                                                      
        end;  
end sp_cr_si_cuota_reprog;


procedure sp_cr_si_tasa_reprog (pn_instancia in number, pv_res_tasa out varchar2)
    -- *****************************************************************
    -- Nombre                     : sp_cr_si_tasa_reprog
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.17
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica que indica si las tasas son iguales
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pv_res_tasa ( Resultado S/N )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        ln_instancia2 number;
        ln_cofaci     number;
        lv_facili     varchar2(100);
        lv_rpta       varchar2(1);
        ln_tasard     number(10,6);
        ln_tasap      number(10,6);
        ln_pgcod      number; 
        ln_lcmod      number; 
        ln_lcsuc      number; 
        ln_lcmda      number; 
        ln_lcpap      number; 
        ln_lccta      number; 
        ln_lcoper     number; 
        ln_lcsbop     number; 
        ln_lctope     number;  
  begin
        ln_instancia2 := 0;
        ln_tasard := 0;
        ln_tasap  := 0;
        ln_pgcod := 0; 
        ln_lcmod := 0; 
        ln_lcsuc := 0; 
        ln_lcmda := 0; 
        ln_lcpap := 0; 
        ln_lccta := 0; 
        ln_lcoper := 0; 
        ln_lcsbop := 0; 
        ln_lctope := 0;
        begin
            -- Si linea de credito fue gestionada por el panel
            PQ_CR_RN_REPROG_CAJA.sp_cr_si_panel_reprog(pn_instancia,lv_rpta,lv_facili,ln_cofaci);  
            if lv_rpta = 'S' and (ln_cofaci = 1 or ln_cofaci = 5) then
                begin
                    --clave del credito en vuelo y la instancia vinculada
                    PQ_CR_RN_REPROG_CAJA.sp_lineacredito_vinculada(pn_instancia,ln_instancia2,ln_pgcod,ln_lcmod,ln_lcsuc,ln_lcmda,ln_lcpap,ln_lccta,ln_lcoper,ln_lcsbop,ln_lctope);

                    select aqpb904tred into ln_tasard 
                                     from aqpb904 where aqpb904ins = ln_instancia2;
                                                                                     
                    select xlltasap into ln_tasap 
                                    from X054023 where xllpgcod = ln_pgcod and xllaomod = ln_lcmod and xllaosuc = ln_lcsuc and xllaomda = ln_lcmda and xllaopap = ln_lcpap 
                                                   and xllaocta = ln_lccta and xllaooper = ln_lcoper and xllaosbop = ln_lcsbop and xllaotop = ln_lctope;
                    
                    if ln_tasard = ln_tasap then
                       pv_res_tasa := 'S';
                    else
                       pv_res_tasa := 'N';
                    end if;            
                exception when others then        
                       pv_res_tasa := 'N';                                                                                      
                end;  
            else
                pv_res_tasa := 'S';
            end if;
        end;

end sp_cr_si_tasa_reprog;

procedure sp_cr_si_tasaCta_reprog (pn_instancia in number, pv_res_tasaCta out varchar2)
    -- *****************************************************************
    -- Nombre                     : sp_cr_si_tasaCta_reprog
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.21
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor Politica que indica si la tasa fue gestionada en la misma cta
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( Instancia )
    -- Parámetros de Salida       : pv_res_tasaCta ( Resultado S/N )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- ******************************************************************
  is
        ln_siCta      number := 0;
        ln_siVin      number := 0;
        ln_pgcod      number := 0; 
        ln_lcmod      number := 0; 
        ln_lcsuc      number := 0; 
        ln_lcmda      number := 0; 
        ln_lcpap      number := 0; 
        ln_lccta      number := 0; 
        ln_lcoper     number := 0; 
        ln_lcsbop     number := 0; 
        ln_lctope     number := 0;  
  begin
        begin
            -- Buscamos clave de la instancia
            PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(pn_instancia,ln_pgcod,ln_lcmod,ln_lcsuc,ln_lcmda,ln_lcpap,ln_lccta,ln_lcoper,ln_lcsbop,ln_lctope);
            
            select count(*) into ln_siCta 
                   from aqpb954 
            where aqpb954cta = ln_lccta and aqpb954tipi = 'S';
            
            if ln_siCta > 0 then
               pv_res_tasaCta := 'N';
               
               select count(*) into ln_siVin 
                      from jaqy800 
               where jaqy800ins2 in
                     (select aqpb904ins 
                             from aqpb904 
                      where aqpb904cta = ln_lccta and
                            aqpb904esta = 'G' and aqpb904ehab = 'H' and
                            aqpb904cfaci in (1,5));
                                         
               if ln_siVin > 0 then                 
                  pv_res_tasaCta := 'S';
               end if;
            
            else
               pv_res_tasaCta := 'S';
            end if;
        end;               

end sp_cr_si_tasaCta_reprog;

end PQ_CR_RN_REPROG_CAJA;
/

