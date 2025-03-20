create or replace package PQ_CR_PROMEDIO_REPRO is
 
    -- *****************************************************************
    -- Nombre                     : PQ_CR_CAPITAL_NEGATIVO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_max_porcentaje( pn_instancia in number,
                                  pn_pordif out number
                                  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_plazo( pn_instancia in number,
                         pn_plazo out number
                        );                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 end PQ_CR_PROMEDIO_REPRO;
/

create or replace package body PQ_CR_PROMEDIO_REPRO is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_CAPITAL_NEGATIVO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.06.12
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_max_porcentaje( pn_instancia in number,
                                  pn_pordif out number
                                  ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_max_porcentaje
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

   ln_pgcod number;
   ln_suc   number;
   ln_mod   number;
   ln_mda   number;
   ln_pap   number;
   ln_cta   number;
   ln_ope   number;
   ln_sob   number;
   ln_tip   number;   
   ln_mto   number;
   ln_num   number;
   ln_cuopen number;
   ln_cuonew number;
   ld_fecpag date;
   ln_periodo number;

       
BEGIN

   ln_cuopen := 0;
   ln_cuonew := 0;

   --solicitud a reprogramar
   begin
      select a.xwfempresa, a.xwfsucursal, a.xwfmodulo, a.xwfmoneda, a.xwfpapel, a.xwfcuenta, a.xwfoperacion, a.xwfsubope, a.xwftipope, b.xllperiodo
        into ln_pgcod, ln_suc, ln_mod, ln_mda, ln_pap, ln_cta, ln_ope, ln_sob, ln_tip, ln_periodo
        from xwf700 a, x054023 b
       where a.xwfprcins = pn_instancia 
         and b.xllpgcod = a.xwfempresa
         and b.xllaomod = a.xwfmodulo
         and b.xllaosuc = a.xwfsucursal
         and b.xllaomda = a.xwfmoneda
         and b.xllaopap = a.xwfpapel
         and b.xllaocta = a.xwfcuenta
         and b.xllaooper = a.xwfoperacion
         and b.xllaosbop = a.xwfsubope
         and b.xllaotop = a.xwftipope
         and a.xwfcar3 <>  '1';  --reprogramar
   exception when others then
      ln_pgcod := null;
   end;

   begin
     select max(f.ppfpag)
       into ld_fecpag 
       from fsd602 f
      where f.pgcod = ln_pgcod
        and f.ppmod = ln_mod
        and f.ppsuc = ln_suc
        and f.ppmda = ln_mda
        and f.pppap = ln_pap
        and f.ppcta = ln_cta
        and f.ppoper = ln_ope
        and f.ppsbop = ln_sob
        and f.pptope = ln_tip
        and f.pp1stat = 'T'
        and f.d602co = 'S';
   exception when no_data_found then
       select /*+index(f FSD60107)*/SUM(f.ppcap + f.ppint + g.ppimp11 + g.ppimp12 + g.ppimp13 + g.ppimp14) , count(*)
       into ln_mto, ln_num 
       from fsd601 f left join fsd611 g
         on f.pgcod = g.pgcod 
        and f.ppmod = g.ppmod 
        and f.ppsuc = g.ppsuc 
        and f.ppmda = g.ppmda 
        and f.pppap = g.pppap 
        and f.ppcta = g.ppcta 
        and f.ppoper = g.ppoper
        and f.ppsbop = g.ppsbop
        and f.pptope = g.pptope
      where f.pgcod = ln_pgcod
        and f.ppmod = ln_mod
        and f.ppsuc = ln_suc
        and f.ppmda = ln_mda
        and f.pppap = ln_pap
        and f.ppcta = ln_cta
        and f.ppoper = ln_ope
        and f.ppsbop = ln_sob
        and f.pptope = ln_tip
        and f.d601co = 'S';     
   end;   
      
   if nvl(ln_num ,0) = 0 and ld_fecpag is not null then            
     begin
       select /*+index(f FSD60107)*/ SUM(f.ppcap + f.ppint + nvl(g.ppimp11,0) + nvl(g.ppimp12,0) + nvl(g.ppimp13,0) + nvl(g.ppimp14,0) ), count(*)
       into ln_mto, ln_num 
       from fsd601 f left join fsd611 g
         on f.pgcod = g.pgcod 
        and f.ppmod = g.ppmod 
        and f.ppsuc = g.ppsuc 
        and f.ppmda = g.ppmda 
        and f.pppap = g.pppap 
        and f.ppcta = g.ppcta 
        and f.ppoper = g.ppoper
        and f.ppsbop = g.ppsbop
        and f.pptope = g.pptope
        and f.ppfpag = g.ppfpag
      where f.pgcod = ln_pgcod
        and f.ppmod = ln_mod
        and f.ppsuc = ln_suc
        and f.ppmda = ln_mda
        and f.pppap = ln_pap
        and f.ppcta = ln_cta
        and f.ppoper = ln_ope
        and f.ppsbop = ln_sob
        and f.pptope = ln_tip
        and f.d601co = 'S'
        and f.ppfpag > ld_fecpag;     
     end;
        
     ln_cuopen := ln_mto/ ln_num;-- promedio de cuotas pendiente
     ln_cuopen := round((ln_cuopen/ (ln_periodo/30) ),2) ;
   end if;   

   if nvl(ln_num ,0) = 0 and ld_fecpag is null then            
     begin
       select /*+index(f FSD60107)*/ SUM(f.ppcap + f.ppint + nvl(g.ppimp11,0) + nvl(g.ppimp12,0) + nvl(g.ppimp13,0) + nvl(g.ppimp14,0)) , count(*)
       into ln_mto, ln_num 
       from fsd601 f left join fsd611 g
         on f.pgcod = g.pgcod 
        and f.ppmod = g.ppmod 
        and f.ppsuc = g.ppsuc 
        and f.ppmda = g.ppmda 
        and f.pppap = g.pppap 
        and f.ppcta = g.ppcta 
        and f.ppoper = g.ppoper
        and f.ppsbop = g.ppsbop
        and f.pptope = g.pptope
        and f.ppfpag = g.ppfpag
      where f.pgcod = ln_pgcod
        and f.ppmod = ln_mod
        and f.ppsuc = ln_suc
        and f.ppmda = ln_mda
        and f.pppap = ln_pap
        and f.ppcta = ln_cta
        and f.ppoper = ln_ope
        and f.ppsbop = ln_sob
        and f.pptope = ln_tip
        and f.d601co = 'S';     
     end;
        
     ln_cuopen := ln_mto/ ln_num;-- promedio de cuotas pendiente
     ln_cuopen := round((ln_cuopen/ (ln_periodo/30) ),2) ;
   end if;   

   ---solicitud nueva
   begin
      select a.xwfempresa, a.xwfsucursal, a.xwfmodulo, a.xwfmoneda, a.xwfpapel, a.xwfcuenta, a.xwfoperacion, a.xwfsubope, a.xwftipope, b.xllperiodo
        into ln_pgcod, ln_suc, ln_mod, ln_mda, ln_pap, ln_cta, ln_ope, ln_sob, ln_tip, ln_periodo
        from xwf700 a, x054023 b
       where a.xwfprcins = pn_instancia 
         and b.xllpgcod = a.xwfempresa
         and b.xllaomod = a.xwfmodulo
         and b.xllaosuc = a.xwfsucursal
         and b.xllaomda = a.xwfmoneda
         and b.xllaopap = a.xwfpapel
         and b.xllaocta = a.xwfcuenta
         and b.xllaooper = a.xwfoperacion
         and b.xllaosbop = a.xwfsubope
         and b.xllaotop = a.xwftipope
         and a.xwfcar3 =  '1';  --reprogramar
   exception when others then
      ln_pgcod := null;
   end;
 
    begin
       select /*+index(f FSD60107)*/ SUM(f.ppcap + f.ppint + nvl(g.ppimp11,0) + nvl(g.ppimp12,0) + nvl(g.ppimp13,0) + nvl(g.ppimp14,0)) , count(*)
       into ln_mto, ln_num 
       from fsd601 f left join fsd611 g
         on f.pgcod = g.pgcod 
        and f.ppmod = g.ppmod 
        and f.ppsuc = g.ppsuc 
        and f.ppmda = g.ppmda 
        and f.pppap = g.pppap 
        and f.ppcta = g.ppcta 
        and f.ppoper = g.ppoper
        and f.ppsbop = g.ppsbop
        and f.pptope = g.pptope
        and f.ppfpag = g.ppfpag        
      where f.pgcod = ln_pgcod
        and f.ppmod = ln_mod
        and f.ppsuc = ln_suc
        and f.ppmda = ln_mda
        and f.pppap = ln_pap
        and f.ppcta = ln_cta
        and f.ppoper = ln_ope
        and f.ppsbop = ln_sob
        and f.pptope = ln_tip
        and f.d601co in('S', 'X');     
     end;
     
        
     ln_cuonew := ln_mto/ ln_num;-- promedio de cuotas nuevas
     ln_cuonew := round((ln_cuonew/ (ln_periodo/30) ),2) ;

     pn_pordif := ( ln_cuonew / ln_cuopen ) * 100 ;
     pn_pordif := round( pn_pordif, 2);
   
END sp_cr_max_porcentaje;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_plazo( pn_instancia in number,
                         pn_plazo out number
                        ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_plazo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


BEGIN
  
    begin
      select t.xllcantcuo
        into pn_plazo
        from xwf700 s , x054023 t 
       where t.xllpgcod = s.xwfempresa
         and t.xllaomod = s.xwfmodulo
         and t.xllaosuc = s.xwfsucursal
         and t.xllaomda = s.xwfmoneda
         and t.xllaopap = s.xwfpapel
         and t.xllaocta = s.xwfcuenta
         and t.xllaooper = s.xwfoperacion
         and t.xllaosbop = s.xwfsubope
         and t.xllaotop = s.xwftipope
         and s.xwfprcins = pn_instancia 
         and s.xwfcar3 = '1' ;  
    exception when others then
       pn_plazo := 0;
    end;

end sp_cr_plazo;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_PROMEDIO_REPRO;
/

