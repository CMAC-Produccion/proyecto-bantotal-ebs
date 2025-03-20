create or replace package PQ_CR_TCEA is
 
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
 PROCEDURE SP_CR_TCEA(
                     v_TCEA   in number,
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     pn_tasa out number,
                     pn_tades out number,
                     pn_tasori out number,
                     pn_tasaux out number                                          
                     ) ;   
                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_verificar_dparcial(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_tpo in number,
                                   pv_rpt out varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_existe_JAQL992(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_tpo in number,
                                 pv_rpt out varchar2);

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 end PQ_CR_TCEA;
/

create or replace package body PQ_CR_TCEA is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_TCEA
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
    --                            : 2020.05.14 DCASTRO Se agrego excepcion
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
----------------------------------------------------------------------------------------
 PROCEDURE SP_CR_TCEA(
                     v_TCEA   in number,
                     v_Pgcod  in number,
                     v_Scmod  in number,
                     v_Scsuc  in number,
                     v_Scmda  in number,
                     v_Scpap  in number,
                     v_Sccta  in number,
                     v_Scoper in number,
                     v_Scsbop in number,
                     v_Sctope in number,
                     pn_tasa out number,
                     pn_tades out number,
                     pn_tasori out number,
                     pn_tasaux out number                     
                     )  is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TCEA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.06.27
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna TCEA
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 


ln_periodo number;
ln_mtodes number(18,2);
ln_tasdes number(11,6);
ld_fecha date;

BEGIN



 --obtener mtodesembolso
    begin
        select f.aoimp, f.aoperiod
          into ln_mtodes, ln_periodo
          from fsd010 f
           where f.pgcod = v_Pgcod
             and f.aomod = v_Scmod
             and f.aosuc = v_Scsuc
             and f.aomda = v_Scmda
             and f.aopap = v_Scpap
             and f.aocta = v_Sccta
             and f.aooper = v_Scoper
             and f.aosbop = v_Scsbop
             and f.aotope = v_Sctope;
    exception when others then
           ln_mtodes := 0;
           ln_periodo := 1;          
    end;  
         

   begin
    pq_cr_seguro_desgravamen.sp_tasa_desgravamen(pa_pgcod => v_Pgcod,
                                                 pa_aomod => v_Scmod,
                                                 pa_aosuc => v_Scsuc,
                                                 pa_aomda => v_Scmda,
                                                 pa_aopap => v_Scpap,
                                                 pa_aocta => v_Sccta,
                                                 pa_aooper => v_Scoper,
                                                 pa_aosbop => v_Scsbop,
                                                 pa_aotope => v_Sctope,
                                                 pa_monto => ln_mtodes,
                                                 pa_tasa => ln_tasdes);
  end;

   pn_tades  :=  nvl(ln_tasdes,0);
    
    ln_tasdes := power( ( 1 + (ln_tasdes/100) ), 12/*(360/ln_periodo)*/) -1 ;
    pn_tasa   := v_TCEA - (ln_tasdes *100);
    
   --tasa origen
   begin
     select a.jaqa250fre
      into ld_fecha 
     from jaqa250 a
  where jaqa250est = 'S'
     and jaqa250emp = v_Pgcod 
     and jaqa250mod = v_Scmod 
     and jaqa250suc = v_Scsuc
     and jaqa250mda = v_Scmda
     and jaqa250pap = v_Scpap
     and jaqa250cta = v_Sccta
     and jaqa250ope = v_Scoper
     and jaqa250sbo = v_Scsbop
     and jaqa250tpo = v_Sctope;
   exception when others then
       ld_fecha := null;
   end;
   
   begin
  select f1.evtasa
    into pn_tasori
    from fsd012 f1
   where f1.pgcod =  v_Pgcod 
     and f1.aomod =  v_Scmod 
     and f1.aosuc =  v_Scsuc
     and f1.aomda =  v_Scmda
     and f1.aopap =  v_Scpap
     and f1.aocta =  v_Sccta
     and f1.aooper = v_Scoper
     and f1.aosbop = v_Scsbop
     and f1.aotope = v_Sctope
     and f1.evtipo = 3
     and f1.d012co = 'S'
     and f1.evcorr in (select max(f1.evcorr)
                         from fsd012 f1
                        where f1.pgcod =  v_Pgcod 
                          and f1.aomod =  v_Scmod 
                          and f1.aosuc =  v_Scsuc
                          and f1.aomda =  v_Scmda
                          and f1.aopap =  v_Scpap
                          and f1.aocta =  v_Sccta
                          and f1.aooper = v_Scoper
                          and f1.aosbop = v_Scsbop
                          and f1.aotope = v_Sctope
                          and f1.evtipo = 3
                          and f1.d012co = 'S'
                          and f1.evfval < ld_fecha);
   exception when others then
     begin
       select f1.aotasa
         into pn_tasori
         from fsd010 f1
        where f1.pgcod = v_Pgcod
          and f1.aomod = v_Scmod
          and f1.aosuc = v_Scsuc
          and f1.aomda = v_Scmda
          and f1.aopap = v_Scpap
          and f1.aocta = v_Sccta
          and f1.aooper = v_Scoper
          and f1.aosbop = v_Scsbop
          and f1.aotope = v_Sctope;
     exception
       when others then
         pn_tasori := 0;
     end;
   end;

   if pn_tasori = 0 then
     begin
       select f1.aotasa
         into pn_tasori
         from fsd010 f1
        where f1.pgcod = v_Pgcod
          and f1.aomod = v_Scmod
          and f1.aosuc = v_Scsuc
          and f1.aomda = v_Scmda
          and f1.aopap = v_Scpap
          and f1.aocta = v_Sccta
          and f1.aooper = v_Scoper
          and f1.aosbop = v_Scsbop
          and f1.aotope = v_Sctope;
     exception
       when others then
         pn_tasori := 0;
     end;

   end if;  

   pn_tasaux := null;
 
 end SP_CR_TCEA;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_verificar_dparcial(pn_emp in number,
                                   pn_mod in number,
                                   pn_suc in number,
                                   pn_mda in number,
                                   pn_pap in number,
                                   pn_cta in number,
                                   pn_ope in number,
                                   pn_sbo in number,
                                   pn_tpo in number,
                                   pv_rpt out varchar2) is
 

/* ************************************************************************************************************
    -- Nombre                     : sp_cr_verificar_dparcial
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Descripción                : Valida si solo tiene desembolsos parciales
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/07/2020
    -- Autor de Creación          : DCASTRO
    -- Versión                    : 1.0
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/

  ln_instancia number(10);
  contador  number(5);

begin
  pv_rpt := 'N';

  begin
      select max(x.xwfprcins)
        into ln_instancia
        from xwf700 x  , sng001 s
       where x.xwfprcins    = s.sng001inst 
         and x.xwfempresa   =  pn_emp
         and x.xwfsucursal  = pn_suc
         and x.xwfmodulo    = pn_mod
         and x.xwfmoneda    = pn_mda
         and x.xwfpapel     = pn_pap
         and x.xwfcuenta    = pn_cta
         and x.xwfoperacion = pn_ope
         and x.xwfsubope    = pn_sbo
         and x.xwftipope    = pn_tpo
         and s.sng001ori    = 7;
  exception when others then
        ln_instancia := 0;       
  end;
  
  if nvl(ln_instancia,0) = 0 then
     pv_rpt := 'N';
  else       
     begin
        select count(*)
          into contador
          from xwf700 x  , sng001 s
         where x.xwfprcins    = s.sng001inst 
           and x.xwfempresa   = pn_emp
           and x.xwfsucursal  = pn_suc
           and x.xwfmodulo    = pn_mod
           and x.xwfmoneda    = pn_mda
           and x.xwfpapel     = pn_pap
           and x.xwfcuenta    = pn_cta
           and x.xwfoperacion = pn_ope
           and x.xwfsubope    = pn_sbo
           and x.xwftipope    = pn_tpo
           and s.sng001ori not in ( 0,1,2,7,10,11)
           and s.sng001inst > ln_instancia;
     exception when others then
          contador := 0;
     end;
                 
      if nvl(contador,0) = 0 then
         pv_rpt := 'S';
      else
         pv_rpt := 'N';
      end if;
    
  end if;
end sp_cr_verificar_dparcial;
 
 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_existe_JAQL992(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_tpo in number,
                                 pv_rpt out varchar2) is
 

/* ************************************************************************************************************
    -- Nombre                     : sp_cr_existe_JAQL992
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Descripción                : Valida si existe en JAQL992
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/07/2020
    -- Autor de Creación          : DCASTRO
    -- Versión                    : 1.0
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/

ln_cantidad number;

begin
  pv_rpt := 'N';

  begin
       select count(*)
        into ln_cantidad
        from jaql992 j
       where j.jaql992pgcod  = pn_emp
         and j.jaql992suc    = pn_suc
         and j.jaql992mod    = pn_mod
         and j.jaql992mda    = pn_mda
         and j.jaql992pap    = pn_pap
         and j.jaql992cta    = pn_cta
         and j.jaql992ope    = pn_ope
         and j.jaql992sbop   = pn_sbo
         and j.jaql992tope   = pn_tpo;
  exception when others then
        ln_cantidad := 0;       
  end;
  
  if nvl(ln_cantidad,0) = 0 then
     pv_rpt := 'N';
  else       
     pv_rpt := 'S';
  end if;
  
end sp_cr_existe_JAQL992;
 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_TCEA;
/

