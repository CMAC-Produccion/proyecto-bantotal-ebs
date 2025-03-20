create or replace package PQ_CR_CAVALI_BT is

      -- *****************************************************************
    -- Nombre                     : PQ_CR_CAVALI_BT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/02/2023
    -- Autor de Creación          : YYAMPI
    -- Uso                        : obtencion de datos de Cavali
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 02/05/2021 YYAMPI se modifico sp_cr_codigos para que se contemple lineas en el calculo de producto sbs
    -- ***************************************************************** 
 
 Procedure sp_cr_codigos(                         
                          PN_PGCOD IN NUMBER,
                          PN_SCSUC IN NUMBER,
                          PN_SCMDA IN NUMBER,
                          PN_SCPAP IN NUMBER,
                          PN_SCCTA IN NUMBER,
                          PN_SCOPER IN NUMBER,
                          PN_SCSBOP IN NUMBER,
                          PN_SCTOPE IN NUMBER,
                          PN_SCMOD IN NUMBER,                           
                          pn_codbanca out number, --codigo salida banca
                          pn_codprod out number,  --codigo salida producto
                          pc_coderr out char, --codigo de error ( 00000 = 'ok')
                          pc_deserr out varchar --mensaje de error
                         );
   
                               
                                            
  end PQ_CR_CAVALI_BT;
/

create or replace package body PQ_CR_CAVALI_BT is

  
  Procedure sp_cr_codigos(                         
                          PN_PGCOD IN NUMBER,
                          PN_SCSUC IN NUMBER,
                          PN_SCMDA IN NUMBER,
                          PN_SCPAP IN NUMBER,
                          PN_SCCTA IN NUMBER,
                          PN_SCOPER IN NUMBER,
                          PN_SCSBOP IN NUMBER,
                          PN_SCTOPE IN NUMBER,
                          PN_SCMOD IN NUMBER,                           
                          pn_codbanca out number, --codigo salida banca
                          pn_codprod out number,  --codigo salida producto
                          pc_coderr out char, --codigo de error ( 00000 = 'ok')
                          pc_deserr out varchar --mensaje de error
                         ) is
    /*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna codigos de cavali por credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PN_PGCOD (empresa),
                                  : PN_SCSUC (sucursal),
                                  : PN_SCMDA (moneda),
                                  : PN_SCPAP (papel),
                                  : PN_SCCTA (cuenta),
                                  : PN_SCOPER (operacion),
                                  : PN_SCSBOP (suboperacion),
                                  : PN_SCTOPE (tipo de operacion),
                                  : PN_SCMOD (modulo),    
    -- Parámetros de Salida       : pn_codbanca (codigo de banca cavali)
                                  : pn_codprod (codigo de producto cavali)  
                                  : pc_coderr (codigo de error)  00000 = 'ok'
                                  : pc_deserr (mensaje de error)
    -- Fecha Modificacion         : 02/05/2021 YYAMPI se modifico sp_cr_codigos para que se contemple lineas en el calculo de producto sbs                              
    ******************************************************************/                        
  
   
    
    ln_banca number(9);
    ln_modulo number(9);
    ln_bancaC number(9);
    ln_moduloC number(9);
    lc_coderr char(5):= '00000';
   
    
  begin
    
       
          /*Se obtiene el codigo del producto SBS - banca y modulo */
          begin 
             select 
             case when c.scmod = 117 then /*en caso de cupos de linea modulo 117*/
                 to_number(substr(c.scrub,7,2),'99')
             else  
               c.scgru /*creditos con rubro 14XXXX*/ 
             end  prodsbs, 
             c.scmod modulo
               into ln_banca, ln_modulo
               from  fsd011 c
              where 
                c.pgcod = PN_PGCOD
                and c.scsuc = PN_SCSUC
                and c.scmda = PN_SCMDA
                and c.scpap = PN_SCPAP
                and c.sccta = PN_SCCTA
                and c.scoper = PN_SCOPER
                and c.scsbop = PN_SCSBOP
                and c.sctope = PN_SCTOPE
                and c.scmod = PN_SCMOD;
          exception when others then
             ln_banca := 0;
             ln_modulo := 0;
             ln_bancaC := 0;
             ln_moduloC := 0;
             lc_coderr := '00001';
          end;
          

            
    /*Se obtiene el codigo del modulo - producto de cavali*/
    begin
      select tp1nro1 , tp1nro2 
        into ln_bancaC, ln_moduloC
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11168
         and tp1corr1 = ln_banca
         and tp1corr2 = ln_modulo;
    exception
      when others then
        ln_bancaC := 0;
        ln_moduloC := 0;
        lc_coderr := '00002';
    end;
    
    if lc_coderr = '00001' then
       pc_coderr := lc_coderr;
       pc_deserr := 'No existe producto SBS o modulo';
    else
      if lc_coderr = '00002' then
         pc_coderr := lc_coderr;
         pc_deserr := 'No existe codigo cavali asociado';
      else
          pn_codbanca := ln_bancaC;
          pn_codprod := ln_moduloC; 
          pc_coderr := lc_coderr;
      end if;  
    end if;
    
  
   
  end sp_cr_codigos;
----------------------------------------------------------------------------
end PQ_CR_CAVALI_BT;
/

