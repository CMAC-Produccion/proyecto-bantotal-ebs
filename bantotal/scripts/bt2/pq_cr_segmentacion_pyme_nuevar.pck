create or replace package PQ_CR_SEGMENTACION_PYME_NUEVAR is

-- *****************************************************************
    -- Nombre                     : paquete para calcular nuevas variables de nueva segmentacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/09/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : paquete de rutinas para la nueva segmentacion pyme - mejora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
                            
    procedure SP_CR_SEGM_ANT(
              pn_pgpais number,
              pn_tipdoc number,
              pv_numdoc char,
              pn_instancia number,                          
              pn_result out varchar);                         

end PQ_CR_SEGMENTACION_PYME_NUEVAR;
/

create or replace package body PQ_CR_SEGMENTACION_PYME_NUEVAR is

----------------------------------------------------------------------------------------------
   procedure SP_CR_SEGM_ANT(
                          pn_pgpais number,
                          pn_tipdoc number,
                          pv_numdoc char,
                          pn_instancia number,                          
                          pn_result out varchar) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_segm_ant
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/09/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna segmentacion pyme anterior de un cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    ln_petipo varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    ln_montovuelo number(16,2) := 0; --monto de vuelo
    ln_tipcam number(14,8) :=0; --tipo de cambio del dia
    ln_montoCanc number(16,2) :=0;
    ln_montoTotal number(16,2) :=0;
    ln_montoNeto number(16,2) :=0;
    ln_deudaRccCMAC number(16,2):=0;
    ln_deudaRcc number(16,2):=0;
    ln_deudaCMAC number(16,2):=0;
    ln_deudaCMACFinal number(16,2) :=0;
    ld_fecdesem date;
    ln_instancia number :=0;
    lc_seganterior varchar(30) := ''; 
    ln_coditem number(9) :=0;
    
 begin
  --pn_result := 0.00; 
    
     begin 
          select t.tp1nro1 into ln_coditem
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11155
             and t.tp1corr1 = 200
             and t.tp1corr2 = 1
             and t.tp1corr3 = 1;
     exception when others then
           ln_coditem := 486;         
       end;
  
     /*creditos con instancia que pasaron con la politica 484*/   
     begin
         
            select /*+ all_rows */ distinct aofval, xwfprcins into ld_fecdesem, ln_instancia
            from (
             Select /*+ all_rows */ 
                    distinct 
                     b.pepais,
                     b.petdoc,
                     b.pendoc,
                     a.pgcod,
                     a.aomod,
                     a.aosuc,
                     a.aomda,
                     a.aopap,
                     a.aocta,
                     a.aooper,
                     a.aosbop,
                     a.aotope,
                     a.aofval, 
                     w.xwfprcins
                from fsd010 a, fsr008 b , xwf700 w
               where a.pgcod = 1
                 and a.aomod in (select modulo
                                   from fst111
                                  where dscod = 50
                                    and modulo not in (33, 200, 108))
                 
                 and a.pgcod = b.pgcod
                 and a.aocta = b.ctnro
                 and b.cttfir = 'T'
                 and w.xwfempresa = a.pgcod
                 and w.xwfsucursal = a.aosuc
                 and w.xwfmodulo = a.aomod
                 and w.xwfmoneda = a.aomda 
                 and w.xwfpapel = a.aopap
                 and w.xwfcuenta = a.aocta
                 and w.xwfoperacion = a.aooper
                 and w.xwfsubope = a.aosbop
                 and w.xwftipope = a.aotope
                 and b.pepais = pn_pgpais --('24486702')
                 and b.petdoc = pn_tipdoc --('24486702')
                 and b.pendoc = pv_numdoc --('24486702')
                 --('70297120')--('45143580')--('24486702')--('70141633', '31680267', '42532635')
                 and exists (  --existe con la politica de nueva segmentacion 484
                                select  1  
                                    from fpae71 f    --,  fpae73 p 
                                    where f.pae51eva = 1 and 
                                    f.pae70nro = (select /*+ all_rows */ max(pae70nro) from fpae70 where pae70ins = w.xwfprcins AND PAE51EVA=1) 
                                    and f.pae71ite = ln_coditem --486
                 )
                 and w.xwfprcins <> pn_instancia -- diferente a la instancia en vuelo
                 order by a.aofval desc, w.xwfprcins desc
                 ) where rownum = 1;
                 
      exception when others then  
        ld_fecdesem := null;
        ln_instancia := null;          
      end; 
      
        
      /*segmentacion del ultimo credito desembolsado anterior */
      begin          
          select distinct trim(substr(f.pae71val, 1, instr(f.pae71val, ':') - 1)) 
          into lc_seganterior
            from fpae71 f  
           where f.pae51eva = 1
             and f.pae70nro = (select max(pae70nro)
                                 from fpae70
                                where pae70ins = ln_instancia 
                                  AND PAE51EVA = 1)
             and f.pae71ite = ln_coditem;--486;   
      
      exception when others then 
         lc_seganterior := 'N';
         pn_result := lc_seganterior;                                 
      end;
      
      pn_result := lc_seganterior;
      
exception when others then       
   pn_result := 'N';        
  
end SP_CR_SEGM_ANT;

---------------------------------------------------------------------------------------------


end PQ_CR_SEGMENTACION_PYME_NUEVAR;
/

