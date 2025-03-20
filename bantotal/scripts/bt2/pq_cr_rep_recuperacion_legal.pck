create or replace package PQ_CR_REP_RECUPERACION_LEGAL is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_REP_RECUPERACION_LEGAL
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : Cr¿ditos - Activas
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.01.15
  -- Autor de Creaci¿n          : SFERNANDEZ
  -- Uso                        : OBTENER LOS DATOS DE RECUPERACION LEGAL PARA LOS REPORTES DE LIQUIDACION DE GESTORES,
  --                              AMORTIZACIONES,INVENTARIO,SALDO ACTUAL VARIACION
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificaci¿n      :11/01/2021
  -- Autor de la Modificaci¿n   :Karen Valencia
  -- Descripci¿n de Modificaci¿n:No muestra algunos movimientos en el reporte de amortizaciones
  ---------------------------------------------------------------------------------------------------
  -- Fecha de Modificaci¿n      :19/12/2022
  -- Autor de la Modificaci¿n   :Karen Valencia
  -- Descripci¿n de Modificaci¿n: No muestra algunos movimientos en el reporte de amortizaciones, se adicionó guía para transacciones que si se deben considerar y itanu='N' para los casos que se dividen en dos
  -- *****************************************************************
 -- Fecha de Modificaci¿n      :23/05/2024  
  -- Autor de la Modificaci¿n   :Karen Valencia
  -- Descripci¿n de Modificaci¿n: Se copió el paquete del 19/12/2022 da menos errores de asignación 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--======================================================================================
--========================= LIQUIDACION DE GESTORES=====================================
--======================================================================================

----------------------------------------------------------------------------------------
--========================= USADOS PARA TABLA :JAQY710 -LLENADO DIARIO==================
------------------------------------------------------------------------
Function fn_cr_cantidad_av(pn_pgcod IN number,
                           pn_inst IN number)
                           return number;
-----------------------------------------------------------------------
Function fn_cr_desc_sucursal(pn_pgcod IN number,
                             pn_succod IN number)
                             return varchar2;
---------------------------------------------------------------------
Function  fn_cr_dias_atraso_cred(pd_fec IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number)
                             return number;
-------------------------------------------------------------------------------
Function fn_cr_monto_cuota(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number) return number;
---------------------------------------------------------------------------------
Function fn_cr_cuota_impaga(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number) return number;                               
----------------------------------------------------------------------------------
Procedure sp_cr_datos_titular(pn_pgcod IN number,
                              pn_cta IN number,
                              pn_pais OUT number,
                              pn_petdoc OUT number,
                              pn_pendoc OUT varchar2,
                              pc_nomtit OUT varchar2,
                              pc_dirtit OUT varchar2,
                              pc_reftit OUT varchar2,
                              pc_distit  OUT varchar2);
-----------------------------------------------------------------------------------------------------
Procedure  sp_cr_credito_fevento(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                ln_tipcam in number,
                                pn_saldocap OUT number,
                                pn_datraso_max_eve OUT number,
                                pn_saldocon_eve OUT number,
                                pd_fecpagoeve out date,
                                ln_montocuoeve OUT NUMBER,
                                pn_cuo_imp OUT number,
                                pn_deuda_mora out number);
--------------------------------------------------------------------------------
Procedure sp_cr_datos_constantes(pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                pn_inst   in number,
                                pn_frecpag OUT number,
                                pn_mtoapro OUT number);

--------------------------------------------------------------------------------
type reg_gestores is record ( c_zon_val varchar2(40),  --zona
                              c_cor_val number(10),    --Correlativo del sng410
                              c_seg_val varchar2(40),  --segmentacion (CARGO)
                              c_fge_val date,          --fecha de generacion
                              c_fsi_val date,          --fecha de asignacion
                              c_eve_val number(10),    --evento
                              c_prog_val varchar2(10), --programa
                              c_rpj_val varchar2(10),  --retorno de prejudicial
                              c_rge_val varchar2(10),  --usuario responsable de gestion
                              c_nge_val varchar2(30),  --nombre responsable de gestion
                              c_nsu_val varchar2(30),  --nombre responsable de supervision
                              c_nas_val varchar2(30),  --nombre responsable de asignacion
                              c_ins_val number(10),     --instancia
                              c_mod_val number(3),     --modulo
                              c_suc_val number(3),     --sucursal
                              c_mda_val number(4),     --moneda
                              c_pap_val number(4),     --papel
                              c_cta_val number(9),     --cta
                              c_ope_val number(9),     --operacion
                              c_sbo_val number(3),     --sub operacion
                              c_top_val number(3),      --tipo de operacion
                              c_fcom_val date,         --fecha de compromiso
                              c_ucom_val varchar2(10)
                              );
type tab_gest is table of reg_gestores index by binary_integer;

Procedure sp_cr_datos_gestores(pn_pgcod IN number,
                               pn_codreg IN number,
                               pd_fecini IN date,
                               pd_fecfin IN date,
                               t_gest in out tab_gest,
                               pn_contg out number);
----------------------------------------------------------------------
procedure sp_elimina_jaqy710(pn_codreg IN number,--cod region
                             pd_feccar IN date);
----------------------------------------------------------------------
Procedure sp_inserta_jaqy710(pn_pgcod IN number,
                             pn_codreg IN number,--cod region
                             pd_feccar IN date);
----------------------------------------------------------------------
Procedure sp_actualiza_jaqy710(lc_pgcod in number,
                                pn_sucur IN number,
                                  pd_feccar IN date);
----------------------------------------------------------------------
procedure sp_actualiza_jaqy710_job;
-----------------------------------------------------------------------
procedure sp_inserta_jaqy710_job (pn_pgcod IN number,
                                  pd_feccar IN date) ;



--==========================USADOS PARA TABLA:JAQY709-REPORTE==============================

Procedure sp_inserta_jaqy712(pn_pgcod IN number,
                             pn_codreg IN number,--cod sucursal
                             pd_fecape IN date);
--------------------------------------------------------------------------------
procedure sp_inserta_jaqy712_job (pn_pgcod IN number,
                                pd_fecape IN date);


--------------------------------------------------------------------------------
Procedure sp_inserta_jaqy709(pn_pgcod IN number,
                             pn_codreg IN number,--cod region
                             pd_fecini IN date,
                             pd_fecfin IN date,
                             pd_fecape IN date);


--------------------------------------------------------------------------
 Procedure sp_cr_credito_factual( pd_fecape IN date ,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                pn_cuo_pag OUT number,
                                pn_statcre OUT number,
                                pd_fechcan OUT date,
                                ld_fecultpag OUT date);

-----------------------------------------------------------------------
Procedure sp_cr_credito_ffin(pd_fecfin IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                               -- pn_pais in number,
                              --  pn_petdoc in number,
                              --  pc_pendoc in varchar2,
                                pn_dat_cuopag OUT number,
                                pd_fec_ultcuo OUT date,
                            --    pn_atraso_max_clie OUT number,
                               pc_descprodsbs out varchar2,
                                pc_tipcont out varchar2
                                );

---------------------------------------------------------------------
Function fn_cr_atraso_max_cli(  pd_fec IN date,
                                pn_pais in number,
                                pn_petdoc in number,
                                pc_pendoc in varchar2)return number;
-----------------------------------------------------------------------
/*Function fn_cr_saldo_acum_cli(  pd_fec IN date,
                                pn_pais in number,
                                pn_petdoc in number,
                                pc_pendoc in char)return number;     */


-----------------------------------------------------------------------
procedure sp_inserta_jaqy709_job (pn_pgcod IN number,
                                pd_fecape IN date);
---------------------------------------------------------------------
Procedure sp_actualiza_jaqy709(pn_pgcod IN number,
                             pn_codreg IN number,--cod sucursal
                             pd_fecape IN date);
----------------------------------------------------------------------
procedure sp_actualiza_jaqy709_job (pn_pgcod IN number,
                                pd_fecape IN date);
-----------------------------------------------------------------------


--==========================REPORTE DE AMORTIZACIONES:==============================


-----------------------------------------------------------------------
Function fn_cr_cap_ingreso(pt_pgcod   in number,
                            pt_cnta   in number,
                            pt_operac in number)return number;
---------------------------------------------------------------------
Function fn_cr_desc_trans(pt_pgcod   in number,
                           itmod in number,
                           ittran in number ) return varchar2;
-----------------------------------------------------------------------
Procedure sp_cr_abog_dmda(  pt_pgcod   in number,
                            pt_modu   in number,
                            pt_sucu   in number,
                            pt_moneda in number,
                            pt_papel  in number,
                            pt_cnta   in number,
                            pt_operac in number,
                            pt_sboper in number,
                            pt_toper  in number,
                            pn_scstat in number,
                            pf_asig out date,
                            pc_abrev out varchar2,
                            pf_deman out date ,
                            pf_pasajud out date,
                            pf_trancart out date
                            );

----------------------------------------------------------------------
Procedure sp_cr_montos_amort( pn_ITSUC in number,
                             pn_ITMOD  in number,
                             pn_ITTRAN in  number,
                             pn_ITNREL in number,
                             pn_capital in out number,
                             pn_interes   in out number,
                             pn_int_comp_extra in out number,
                             pn_mora   in out number,
                             pn_seguros  in out number,
                             pn_rub_obli  in out number,
                             pn_gastos  in out number,
                             pn_ITF  in out number);
-----------------------------------------------------------------------
Function fn_pago_valido(pt_pgcod in number,
                     pt_suc in number,
                     pt_mod in number,
                     pt_moneda in number,
                     pt_papel in number ,
                     pt_cnta in number,
                     pt_operac in number,
                     pt_sboper in number,
                     pt_toper in number,
                     pn_ITSUC  in number,
                     pn_ITMOD  in number,
                     pn_ITTRAN in number,
                     pn_ITNREL in number,
                     pn_stat in number)
                            return number;
--------------------------------------------------------------------
Procedure sp_cr_obtiene_pk(pt_pgcod in number,
                           pt_modt in number,
                           pt_tran in number,
                           pt_suct in number,
                           pt_rel in number,
                           pt_suc out number,
                           pt_mod out number,
                           pt_moneda out number,
                           pt_papel  out number ,
                           pt_cnta in out number,
                           pt_operac in out number,
                           pt_sboper out number,
                           pt_toper out number,
                           pt_fecpag in date);
---------------------------------------------------------------------
Procedure sp_cr_cred_amort_CV(pn_suc IN number,pd_fecproc IN date);

-----------------------------------------------------------------------
procedure sp_inserta_jaqy711_job ( pd_fecape IN date);
 -----------------------
/*Procedure sp_cr_act_cap_ing(pn_suc in number,pt_fecpro in date);
 -------
procedure sp_actualiza_jaqy711_job (pd_fecape IN date);*/
--=================================================================================


----------------------------------------------------------------------
Procedure sp_cr_mod_est_act(pt_fecpag in out date,
                            pt_pgcod   in number,
                            pt_suc in number,
                            pt_mod in number,
                            pt_moneda in number,
                            pt_papel  in number,
                            pt_cnta   in number,
                            pt_operac in number,
                            pt_sboper in number,
                            pt_toper  in number,
                            estado out number,
                            pt_datraso out number,
                             pn_ITSUC in number,
                             pn_ITMOD  in number,
                             pn_ITTRAN in  number,
                             pn_ITNREL in number);
---------------------------------------------------------------------------
Procedure sp_cr_elimina_anul_repe(pt_fecpro in date);
----------------------------------------------------------------------------
Procedure sp_cr_anula_extornos(pt_fecpro in date);
--==================================================================================



--=================================================================================
Procedure sp_cr_mto_inserta_jaqy729(pt_fecini in date,pt_fecfin in date);
Procedure sp_cr_mto_elimina(pt_fecini in date,pt_fecfin in date);
end PQ_CR_REP_RECUPERACION_LEGAL;
/

create or replace package body PQ_CR_REP_RECUPERACION_LEGAL is


--=======================USADOS PARA TABLA: JAQY709 -LLENADO DIARIO =======================================
-----------------------------------------------------------------------------------------------------------------
Function fn_cr_cantidad_av(pn_pgcod IN number,
                           pn_inst IN number)
                            return number
is
  -- ******************************************************************************************************
  -- Nombre                     : fn_cr_cantidad_av
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Calcula la cantidad de avales
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1, pn_inst: instancia
  -- Par¿metros de Salida       : ln_cant_av: cantidad de avales
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

 ln_cant_av number(5);
 lc_error varchar2(100);
 lc_coderr  varchar2(100);
begin

   select count(*)
   into ln_cant_av
   from sng003 s
   where s.sng003pgc = pn_pgcod
   and s.sng001inst = pn_inst ;
   return ln_cant_av;
exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
end fn_cr_cantidad_av;

----------------------------------------------------------------------------------------------------
Function fn_cr_desc_sucursal(pn_pgcod IN number,
                             pn_succod IN number)
                             return varchar2
is
   -- ******************************************************************************************************
  -- Nombre                     : fn_cr_desc_sucursal
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Descripcion de oficina
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1, pn_succod: codigo de oficina
  -- Par¿metros de Salida       : pn_succod: descripcion de oficina
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

 lc_nomsuc varchar2(30);
 lc_error varchar2(100);
 lc_coderr  varchar2(100);
begin
   select scnom
   into lc_nomsuc
   from fst001
   where pgcod = pn_pgcod
   and sucurs = pn_succod;

   return lc_nomsuc;
exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
        return lc_nomsuc;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
        return lc_nomsuc;
end fn_cr_desc_sucursal;


------------------------------------------------------------------------------------------------------
Function fn_cr_dias_atraso_cred(pd_fec IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number)
                             return number
is
  -- ******************************************************************************************************
  -- Nombre                     : fn_cr_dias_atraso_cred
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Calcula la cantidad de avales
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_fec:fecha ,pt_pgcod,pt_modu,pt_sucu,pt_moneda,pt_papel,pt_cnta,pt_operac,
  --                              pt_sboper,pt_toper: clave del credito
  -- Par¿metros de Salida       : ln_dias: atraso dias de atraso del credito
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************


 ln_diasatraso number(5);
 lc_error varchar2(100);
 lc_coderr  varchar2(100);

begin
  begin
   select fn_dias_atraso(pd_fec,
           f.pgcod,
           f.aomod,
           f.aosuc,
           f.aomda,
           f.aopap,
           f.aocta,
           f.aooper,
           f.aosbop,
           f.aotope,
           f.aostat,
           f.aofvto) into ln_diasatraso
      from fsd010 f
      where  f.pgcod=pt_pgcod
        and  f.aomod= pt_modu
        and  f.aosuc= pt_sucu
        and  f.aomda= pt_moneda
        and  f.aopap= pt_papel
        and  f.aocta= pt_cnta
        and  f.aooper=pt_operac
        and  f.aosbop=pt_sboper
        and  f.aotope=pt_toper
        and  f.aostat<>99;
   exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    end;
     return ln_diasatraso;
end  fn_cr_dias_atraso_cred;
------------------------------------------------------------------------------------------------------
Function fn_cr_monto_cuota(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number) return number
is
ld_fecpag date;
ln_seguro number;
lc_estado_pago varchar(10);
ln_montocuoeve number(17,2);
begin
    ----MONTO CUOTA----
    begin
       select /*+FIRST_ROWS*/ max(ppfpag)--,max(f.pp1stat)
       into ld_fecpag --,lc_estado_pago
       from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.d602co = 'S'
        and f.ppfpag <pd_feceve ;
        
        If(ld_fecpag is null) then
                    select /*+FIRST_ROWS*/ min(ppfpag)
                    into ld_fecpag
                    from fsd601 f
                    where f.pgcod = pt_pgcod
                      and f.ppmod = pt_modu
                      and f.ppsuc = pt_sucu
                      and f.ppmda = pt_moneda
                      and f.pppap = pt_papel
                      and f.ppcta = pt_cnta
                      and f.ppoper = pt_operac
                      and f.ppsbop = pt_sboper
                      and f.pptope = pt_toper;
        Else
        
               select /*+FIRST_ROWS*/max(f.pp1stat)
               into lc_estado_pago
               from fsd602 f
              where f.pgcod = pt_pgcod
                and f.ppmod = pt_modu
                and f.ppsuc = pt_sucu
                and f.ppmda = pt_moneda
                and f.pppap = pt_papel
                and f.ppcta = pt_cnta
                and f.ppoper = pt_operac
                and f.ppsbop = pt_sboper
                and f.pptope = pt_toper
                and f.d602co = 'S'
                and f.ppfpag =ld_fecpag ;

                if(lc_estado_pago='T') then
                     
                           select /*+FIRST_ROWS*/ min(ppfpag)
                           into ld_fecpag
                           from fsd601 f
                           where f.pgcod = pt_pgcod
                              and f.ppmod = pt_modu
                              and f.ppsuc = pt_sucu
                              and f.ppmda = pt_moneda
                              and f.pppap = pt_papel
                              and f.ppcta = pt_cnta
                              and f.ppoper = pt_operac
                              and f.ppsbop = pt_sboper
                              and f.pptope = pt_toper
                              and f.ppfpag>ld_fecpag;
                              
                        If(ld_fecpag is null) then
                        
                           select /*+FIRST_ROWS*/ min(ppfpag)
                            into ld_fecpag
                            from fsd601 f
                            where f.pgcod = pt_pgcod
                              and f.ppmod = pt_modu
                              and f.ppsuc = pt_sucu
                              and f.ppmda = pt_moneda
                              and f.pppap = pt_papel
                              and f.ppcta = pt_cnta
                              and f.ppoper = pt_operac
                              and f.ppsbop = pt_sboper
                              and f.pptope = pt_toper;
                        End if ;
                end if ;
        End if;
    exception
        when no_data_found then
                   select /*+FIRST_ROWS*/ min(ppfpag)
                    into ld_fecpag
                    from fsd601 f
                    where f.pgcod = pt_pgcod
                      and f.ppmod = pt_modu
                      and f.ppsuc = pt_sucu
                      and f.ppmda = pt_moneda
                      and f.pppap = pt_papel
                      and f.ppcta = pt_cnta
                      and f.ppoper = pt_operac
                      and f.ppsbop = pt_sboper
                      and f.pptope = pt_toper;
     end;

     begin   --si tiene seguro

       select  Ppcap + Ppint + Ppicap + Ppiint into ln_montocuoeve
       from fsd601 f1
       where f1.pgcod = pt_pgcod
       and f1.ppmod  = pt_modu
       and f1.ppsuc  = pt_sucu
       and f1.ppmda  = pt_moneda
       and f1.pppap  = pt_papel
       and f1.ppcta  = pt_cnta
       and f1.ppoper  = pt_operac
       and f1.ppsbop  = pt_sboper
       and f1.pptope  = pt_toper
       and f1.ppfpag = ld_fecpag;

            begin

            select f1.ppimp11+f1.ppimp12+f1.ppimp13 into ln_seguro
              from fsd611 f1
             inner join fpp001 f on f1.pgcod = f.pgcod
                                and f1.ppmod = f.aomod
                                and f1.ppsuc = f.aosuc
                                and f1.ppmda = f.aomda
                                and f1.pppap = f.aopap
                                and f1.ppcta = f.aocta
                                and f1.ppoper = f.aooper
                                and f1.ppsbop = f.aosbop
                                and f1.pptope = f.aotope
             where  f.pgcod = pt_pgcod
                     and f.aomod = pt_modu
                     and f.aosuc = pt_sucu
                     and f.aomda = pt_moneda
                     and f.aopap = pt_papel
                     and f.aocta = pt_cnta
                     and f.aooper = pt_operac
                     and f.aosbop = pt_sboper
                     and f.aotope = pt_toper
                     and f.pp001co <> 'N'
                     and f1.ppfpag = ld_fecpag;



             exception
                  when no_data_found then
                        ln_seguro:=0;
                   when others then
                         ln_seguro:=0;
             end;


      exception
            when no_data_found then
                  ln_montocuoeve:=0;
             when others then
                   ln_montocuoeve:=0;

      end;

       ln_montocuoeve   := ln_montocuoeve+ ln_seguro;
       return ln_montocuoeve;
end fn_cr_monto_cuota ;
--------------------------------------------------------------------------------------------------------------
Function fn_cr_cuota_impaga(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number) return number
is
ld_fecpag date;
lc_estado_pago varchar(10);
ln_montocuoeve number(17,2):=0;
ln_montocuoeve_parcial  number(17,2):=0;
ln_cuota_comp number(17,2):=0;
begin
    ----MONTO CUOTA----

       select /*+FIRST_ROWS*/ max(ppfpag)--,max(f.pp1stat)
       into ld_fecpag --,lc_estado_pago
       from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.d602co = 'S'
        and f.pp1fech <=pd_feceve ;
        
        If(ld_fecpag is null) then
                    select /*+FIRST_ROWS*/ min(ppfpag)
                    into ld_fecpag
                    from fsd601 f
                    where f.pgcod = pt_pgcod
                      and f.ppmod = pt_modu
                      and f.ppsuc = pt_sucu
                      and f.ppmda = pt_moneda
                      and f.pppap = pt_papel
                      and f.ppcta = pt_cnta
                      and f.ppoper = pt_operac
                      and f.ppsbop = pt_sboper
                      and f.pptope = pt_toper;    
                                 
                       begin   --cuotas impagas completas
                            select sum( Ppcap + Ppint + Ppicap + Ppiint)
                            into ln_cuota_comp
                            from fsd601 f
                            where f.pgcod = pt_pgcod
                              and f.ppmod = pt_modu
                              and f.ppsuc = pt_sucu
                              and f.ppmda = pt_moneda
                              and f.pppap = pt_papel
                              and f.ppcta = pt_cnta
                              and f.ppoper = pt_operac
                              and f.ppsbop = pt_sboper
                              and f.pptope = pt_toper
                              and f.ppfpag<=pd_feceve
                              and f.ppfpag>=ld_fecpag;   

                         
                        exception
                              when no_data_found then
                                    ln_cuota_comp:=0;
                               when others then
                                     ln_cuota_comp:=0;

                        end;        
                       return nvl(ln_montocuoeve,0)+nvl(ln_cuota_comp,0);
                 
        Else
        
               select /*+FIRST_ROWS*/max(f.pp1stat)
               into lc_estado_pago
               from fsd602 f
              where f.pgcod = pt_pgcod
                and f.ppmod = pt_modu
                and f.ppsuc = pt_sucu
                and f.ppmda = pt_moneda
                and f.pppap = pt_papel
                and f.ppcta = pt_cnta
                and f.ppoper = pt_operac
                and f.ppsbop = pt_sboper
                and f.pptope = pt_toper
                and f.d602co = 'S'
                and f.ppfpag =ld_fecpag ;

                if(lc_estado_pago='P') then
                         begin
                             select  f.pp1cap + f.pp1int + f.pp1icap + f.pp1icap
                               into ln_montocuoeve_parcial
                               from fsd602 f
                              where f.pgcod = pt_pgcod
                                and f.ppmod = pt_modu
                                and f.ppsuc = pt_sucu
                                and f.ppmda = pt_moneda
                                and f.pppap = pt_papel
                                and f.ppcta = pt_cnta
                                and f.ppoper = pt_operac
                                and f.ppsbop = pt_sboper
                                and f.pptope = pt_toper
                                and f.d602co = 'S'
                                and f.ppfpag =ld_fecpag 
                                and f.pp1stat='P';
                        exception
                              when no_data_found then
                                    ln_montocuoeve_parcial:=0;
                               when others then
                                    ln_montocuoeve_parcial:=0;

                        end;    
                       begin   --cuota  completa
                         select  Ppcap + Ppint + Ppicap + Ppiint into ln_montocuoeve
                         from fsd601 f1
                         where f1.pgcod = pt_pgcod
                         and f1.ppmod  = pt_modu
                         and f1.ppsuc  = pt_sucu
                         and f1.ppmda  = pt_moneda
                         and f1.pppap  = pt_papel
                         and f1.ppcta  = pt_cnta
                         and f1.ppoper  = pt_operac
                         and f1.ppsbop  = pt_sboper
                         and f1.pptope  = pt_toper
                         and f1.ppfpag = ld_fecpag;


                        exception
                              when no_data_found then
                                    ln_montocuoeve:=0;
                               when others then
                                     ln_montocuoeve:=0;

                        end;    
                     
                     ln_montocuoeve   := (ln_montocuoeve-ln_montocuoeve_parcial);  
                End if ;
        End if;    
        
       begin   --cuotas impagas completas
            select sum( Ppcap + Ppint + Ppicap + Ppiint)
            into ln_cuota_comp
            from fsd601 f
            where f.pgcod = pt_pgcod
              and f.ppmod = pt_modu
              and f.ppsuc = pt_sucu
              and f.ppmda = pt_moneda
              and f.pppap = pt_papel
              and f.ppcta = pt_cnta
              and f.ppoper = pt_operac
              and f.ppsbop = pt_sboper
              and f.pptope = pt_toper
              and f.ppfpag<=pd_feceve
              and f.ppfpag>ld_fecpag;   

         
        exception
              when no_data_found then
                    ln_cuota_comp:=0;
               when others then
                     ln_cuota_comp:=0;

        end;        
       return nvl(ln_montocuoeve,0)+nvl(ln_cuota_comp,0);
end fn_cr_cuota_impaga ;
-------------------------------------------------------------------------------------------------------------
Procedure sp_cr_datos_titular(pn_pgcod IN number,
                              pn_cta IN number,
                              pn_pais OUT number,
                              pn_petdoc OUT number,
                              pn_pendoc OUT varchar2,
                              pc_nomtit OUT varchar2,
                              pc_dirtit OUT varchar2,
                              pc_reftit OUT varchar2,
                              pc_distit  OUT varchar2)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_datos_titular
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Datos del titular
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1,pn_cta: cuenta
  -- Par¿metros de Salida       : pn_pais:pais,pn_petdoc:tipo doc,pn_pendoc:nro de documento
  --                             ,pc_nomtit:nombre del titular, pc_dirtit: direccion del titular,
  --                             ,pc_reftit:referencia del titular, distrito: titular
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************


  lc_error  varchar(500);
  lc_coderr varchar(500);
begin

  begin -- NRO DE DOCUMENTO--
    select pepais,petdoc,pendoc
     into pn_pais,pn_petdoc,pn_pendoc
    from fsr008
    where pgcod = pn_pgcod
     and  ctnro = pn_cta
     and cttfir = 'T'
     and ttcod = 1;
  exception
  when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
  end;

  begin --NOMBRE TITULAR  --
     select penom
     into pc_nomtit
     from fsd001
     where pepais = pn_pais
     and petdoc = pn_petdoc
     and pendoc = pn_pendoc;
  exception
  when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
  end;

  begin--DIRECCION TITULAR--
      select sngc13dir,sngc13ref1, f1.fst071dsc
      into  pc_dirtit,pc_reftit,pc_distit
     from sngc13 s13
     inner join  fst071 f1
      on s13.sngc13pais=f1.fst071pai
      and s13.sngc13dpto=f1.Fst071dpt
      and s13.sngc13prov=f1.Fst071Loc
      and s13.sngc13Dist=f1.fst071col
     where sngc13Pais= pn_pais
      and sngc13Tdoc = pn_petdoc
      and sngc13Ndoc = pn_pendoc
      and docod = 1
      and sngc13est='H';
  exception
  when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
  end;
end sp_cr_datos_titular;
-----------------------------------------------------------------------------------------------------------------------------
Procedure  sp_cr_credito_fevento(pd_feceve IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                ln_tipcam in number,
                                pn_saldocap OUT number,
                                pn_datraso_max_eve OUT number,
                                pn_saldocon_eve OUT number,
                                pd_fecpagoeve out date,
                                ln_montocuoeve OUT NUMBER,
                                pn_cuo_imp OUT number,
                                pn_deuda_mora out number)

is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_credito_fevento
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : calcula saldo capital, dias de atraso, saldo  a la fecha del evento
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_feceve: fecha de evento
  --                              pt_pgcod,pt_modu,pt_sucu,pt_moneda,pt_papel,pt_cnta,pt_operac,pt_sboper:
  --                              clave del credito
  -- Par¿metros de Salida       : pn_saldocap:saldo capital,pn_datraso_max_eve: atraso maximo
  --                             ,pn_saldocon_eve:saldo consolidado
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

lc_error  varchar(500);
lc_coderr varchar(500);

begin

 begin
     ---FECHA DEL ULTIMO PAGO A LA FECHA DEL EVENTO-----
      select /*+FIRST_ROWS*/ max(pp1fech)
      into pd_fecpagoeve
      from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.pp1stat = 'T'
        and f.d602co = 'S'
        and f.ppfpag<pd_feceve;

   exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   end;


 begin
     ---SALDO CAPITAL-----
        select f.scsdo--decode(pt_moneda,101,round(nvl(f.scsdo,0)*ln_tipcam,2),0,round(nvl(f.scsdo,0),2))
          into  pn_saldocap
          from fsd011 f
        where f.pgcod = pt_pgcod
           and f.scsuc=pt_sucu
           and f.scmod=pt_modu
           and f.scmda=pt_moneda
           and f.scpap=pt_papel
           and f.sccta=pt_cnta
           and f.scoper=pt_operac
           and f.scsbop=pt_sboper
           and f.sctope=pt_toper
           and f.scmod in (select modulo from fst111 t where t.dscod =50);

   exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   end;
    begin
       select f.pp075mto1, f.pp075mto2
       into pn_datraso_max_eve,pn_saldocon_eve
         from fpp075 f
        where pgcod = 1
          and aocta = pt_cnta
          and f.pp075fval = pd_feceve
          and f.pp075user = 'GESTCOB'
          and aomod = 0
          and aoSUC = 0
          and aomda = 0
          and aopap = 0
          and aooper = 0;

     exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   end;
   begin
        ----DEUDA EN MORA ,CUOTA IMPAGA-----

        select  JAQL964MTD ,(j.jaql964cuo+j.jaql964int) --11/07/2017 ya no esta penalidad
        into pn_deuda_mora,pn_cuo_imp
        from JAQL964 j
        where j.jaql964suc=pt_sucu
        and j.jaql964mod=pt_modu
        and j.jaql964mda=pt_moneda
        and j.jaql964cta=pt_cnta
        and j.jaql964ope=pt_operac
        and j.jaql964sob=pt_sboper
        and j.jaql964top=pt_toper;
        
        
        
      exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   end;
   ln_montocuoeve := pq_cr_rep_recuperacion_legal.fn_cr_monto_cuota(pd_feceve => pd_feceve,
                                                            pt_pgcod => pt_pgcod,
                                                            pt_modu => pt_modu,
                                                            pt_sucu => pt_sucu,
                                                            pt_moneda => pt_moneda,
                                                            pt_papel => pt_papel,
                                                            pt_cnta => pt_cnta,
                                                            pt_operac => pt_operac,
                                                            pt_sboper => pt_sboper,
                                                            pt_toper => pt_toper);
    If(pn_cuo_imp=0 or pn_cuo_imp is null) then
             
         pn_cuo_imp:= pq_cr_rep_recuperacion_legal.fn_cr_cuota_impaga(pd_feceve => pd_feceve,
                                                             pt_pgcod => pt_pgcod,
                                                             pt_modu => pt_modu,
                                                             pt_sucu => pt_sucu,
                                                             pt_moneda => pt_moneda,
                                                             pt_papel => pt_papel,
                                                             pt_cnta => pt_cnta,
                                                             pt_operac => pt_operac,
                                                             pt_sboper => pt_sboper,
                                                             pt_toper => pt_toper);
        
        End if;
end sp_cr_credito_fevento;
------------------------------------------------------------------------------------------------
Procedure sp_cr_datos_constantes(pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                pn_inst   in number,
                                pn_frecpag OUT number,
                                pn_mtoapro OUT number)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_datos_constantes
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Datos constantes del credito
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_feceve: fecha de evento
  --                              pt_pgcod,pt_modu,pt_sucu,pt_moneda,pt_papel,pt_cnta,pt_operac,pt_sboper:
  --                              clave del credito,  pn_inst:instancia
  -- Par¿metros de Salida       : pn_frecpag:frecuencia de pago,pn_mtoapro_monto aprobado,pn_mon_cuo:monto cuota
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

lc_error  varchar(500);
lc_coderr varchar(500);
begin
     -----FERECUENCIA DE PAGO-------
     begin
        select f.aoperiod
          into pn_frecpag
          from fsd010 f
         where f.pgcod = pt_pgcod
           and f.aomod = pt_modu
           and f.aosuc = pt_sucu
           and f.aomda = pt_moneda
           and f.aopap = pt_papel
           and f.aocta = pt_cnta
           and f.aooper = pt_operac
           and f.aosbop = pt_sboper
           and f.aotope = pt_toper;
     exception
          when no_data_found then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
          when others then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
     end;
        ---------------------------
        -----MONTO APROBADO DEL CREDITO-------
     begin
        select xllcapital
          into pn_mtoapro
          from x054023 x
         where x.xllpgcod = pt_pgcod
           and x.xllaomod = pt_modu
           and x.xllaosuc = pt_sucu
           and x.xllaomda = pt_moneda
           and x.xllaopap = pt_papel
           and x.xllaocta = pt_cnta
           and x.xllaooper = pt_operac
           and x.xllaosbop = pt_sboper
           and x.xllaotop = pt_toper;
     exception
          when no_data_found then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
          when others then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
     end;

end sp_cr_datos_constantes;

-----------------------------------------------------------------------------------------------------------------------------
Procedure sp_cr_datos_gestores(pn_pgcod IN number,
                               pn_codreg IN number,--cod region
                               pd_fecini IN date,
                               pd_fecfin IN date,
                               t_gest in out tab_gest,
                               pn_contg out number)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_datos_gestores
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Obtiene los datos de un eventos
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1,pn_codreg:codigo de region,pd_fecini:fecha de inicio de generacion del evento
  --                             pd_fecfin:fecha fin de generacion del evento ,t_gest:estructura
  -- Par¿metros de Salida       :pn_contg:cantidad de registros
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

  lc_cargo      sng055.sng055dsc%type;   --segmentacion (CARGO)
  ld_fecgene    sng410.sng410FECG%type;  --fecha de generacion
  ld_fecasig    sng410.sng410FECG%type;  --fecha de asignacion
  ln_evento     sng410.sng400evto%type;  --evento
  lc_usuregest  sng410.sng410ase%type;   --usuario responsable de gestion
  lc_usuresupe  sng410.sng410ase%type;   --usuario responsable de supervision
  lc_usuresasi  sng410.sng410ase%type;   --usuario responsable de asignacion
  lc_retprejud  varchar(5);              --retorno de prejudicial
  lc_nomresasi  fst746.ubnom%type;       --nombre responsable de asignacion
  lc_nomresges  fst746.ubnom%type;       --nombre responsable de gestion
  lc_nomresupe  fst746.ubnom%type;       --nombre responsable de supervision

  ln_cantreg  number(10):=0;             --cantidad de registros
  lc_error  varchar(100);
  lc_coderr varchar(100);
  lc_usucom varchar2(10); --usuario compromiso
  ld_feccomp date; --fecha de compromiso
  verif_seg number;
  estado number;
  
  

  ln_numcargo sng055.sng055car%type;--codigo del cargo

  CURSOR gestores--(pn_codreg IN number)
  IS
      select distinct s.sng410inst,
                      s.sng410corr,
                      s2.sng406prg,
                      s.sng400evto,
                      s.sng410its,
                      s.sng410fecg,
                      s.sng410ase,
                      s.sng410suc,
                      s.sng410mod,
                      s.sng410mda,
                      s.sng410pap,
                      s.sng410cta,
                      s.sng410op,
                      s.sng410sbop,
                      s.sng410top,
                      f1.regnom
       from sng410 s
       inner join fst811 f8 --- relacion  sucursal-region
            on f8.pgcod = s.sng400cod
            and s.sng410suc = f8.oficod
      inner join fst810 f1 -- tabla de regiones
            on f8.pgcod = f1.pgcod
            and f8.regcod = f1.regcod
            and f8.regcod < 100
      inner join sng411 s2
            on s.sng410corr=s2.sng410corr
      where s.sng400cod=pn_pgcod
            and s.sng400evto in (select tp1nro1 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =1)
--            and s.sng400evto in (1100,1101)
            and s.sng410fecg=pd_fecini --and s.sng410fecg<=pd_fecfin
            and f8.regcod = pn_codreg
            and s.sng410mod not in (108,141,117);
     
   evento1001 number;
   evento1002 number;
   evento1003 number;
   evento1004 number;
   evento1100 number;
   evento1101 number;
   
   evento1001_HSNG461 varchar2(10);
   evento1001_HSNG462 varchar2(10);
   evento1001_HSNG461A varchar2(10);
   
   evento1003_HSNG461 varchar2(10);
   evento1003_HSNG462 varchar2(10);
   evento1003_HSNG461A varchar2(10);
   
   evento1004_HSNG461 varchar2(10);

   evento1101_HSNG461 varchar2(10);
   evento1101_HSNG462 varchar2(10);
   evento1101_HSNG461A varchar2(10);
   
begin
   --EVENTOS 
   select distinct(tp1nro1)into evento1001 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2; --1001
   select distinct(tp1nro1) into evento1002 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =3;  --1002
   select distinct(tp1nro1) into evento1003 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =4;  --1003
   select distinct(tp1nro1) into evento1004 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =5;  --1004
   select distinct(tp1nro1) into evento1100 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =6; --1100
   select distinct(tp1nro1) into evento1101 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =7; --1101

   --PROGRAMAS
   
   select  substr(tp1desc,1,10) into evento1001_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=1; --1001:hsgn461
   select  substr(tp1desc,1,10) into evento1001_HSNG461A from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=2;
   select  substr(tp1desc,1,10) into evento1001_HSNG462 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=3;
    

   select  substr(tp1desc,1,10) into evento1003_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=1; --1003:hsgn461
   select  substr(tp1desc,1,10) into evento1003_HSNG461A from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=2;
   select  substr(tp1desc,1,10) into evento1003_HSNG462 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=3;
   
   select  substr(tp1desc,1,10) into evento1004_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =5 and tp1corr3=1; --1004:hsgn461

   select  substr(tp1desc,1,10) into evento1101_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =7 and tp1corr3=1; --1101:hsgn461
   select  substr(tp1desc,1,10) into evento1101_HSNG461A from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =7 and tp1corr3=2; --1101:hsgn461a
   select  substr(tp1desc,1,10) into evento1101_HSNG462 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =7 and tp1corr3=3; --1101:hsgn462


   for g in gestores loop

     --limpiando variables
   begin
     lc_cargo    :=null;
     ld_fecgene  :=null;
     ld_fecasig  :=null;
     ln_evento   :=null;
     lc_usuregest:=null;
     lc_nomresges:=null;
     lc_usuresupe:=null;
     lc_nomresupe:=null;
     lc_usuresasi:=null;
     lc_nomresasi:=null;
     lc_retprejud:=null;
     lc_usucom := null;
     ld_feccomp := null;

     CASE
     WHEN g.sng400evto =evento1001 or g.sng400evto=evento1003    THEN

           CASE
           WHEN  g.sng406prg=evento1001_HSNG461 THEN --ASESOR

                ld_fecgene := g.sng410fecg;--f generacion

                 begin --f asignacion
                  select s.sng229fece
                  into ld_fecasig
                  from sng229 s
                  where s.sng229rss = g.sng410corr;
                exception
                when no_data_found then
                   lc_error:= sqlcode;
                   lc_coderr:=sqlerrm;
                 when others then
                   lc_error:= sqlcode;
                   lc_coderr:=sqlerrm;
                end;

                begin
                   select s.sng001ase -- usuario de asignacion
                   into lc_usuresasi
                   from sng001 s
                   where s.sng001inst = g.sng410inst;

                   select distinct SNG057JEF --usuario supervision
                   into lc_usuresupe
                   from sng057
                   where sng055emp =pn_pgcod
                   and sng057usr= lc_usuresasi;

                   lc_usuregest:= lc_usuresasi;--usuario de gestion

                exception
                when no_data_found then
                   lc_error:= sqlcode;
                   lc_coderr:=sqlerrm;
                 when others then
                   lc_error:= sqlcode;
                   lc_coderr:=sqlerrm;
                end;

                begin   --Segmentacion
                 select s5.sng055dsc
                 into lc_cargo
                 from sng055 s5
                 inner join sng057 s7
                 on s5.sng055emp=s7.sng055emp
                 and s5.sng055car=s7.sng055car
                 where  sng057usr=lc_usuresasi;
                exception
                  when no_data_found then
                     lc_error:= sqlcode;
                     lc_coderr:=sqlerrm;
                   when others then
                     lc_error:= sqlcode;
                     lc_coderr:=sqlerrm;
                end;

           WHEN  g.sng406prg = evento1001_HSNG461A OR  g.sng406prg=evento1001_HSNG462 THEN--GESTOR

                  ld_fecgene := g.sng410fecg;--f generacion


                   begin
                        select sng415cpo -- usuario asignacion
                        into lc_usuresasi
                        from sng415
                        where sng410corr =  g.sng410corr;

                         select s5.sng055car-- En el caso de que sea Gestor: usu gestion es JEFE DIRECTO
                         into ln_numcargo
                         from sng055 s5
                         inner join sng057 s7
                         on s5.sng055emp=s7.sng055emp
                         and s5.sng055car=s7.sng055car
                         where  sng057usr=lc_usuresasi;

                         IF(ln_numcargo=205)THEN
                            select distinct SNG057JEF
                            into lc_usuresasi
                            from sng057
                            where sng055emp =pn_pgcod
                            and sng057usr= lc_usuresasi;

                            lc_usuregest:=lc_usuresasi;--usuario  de gestion
                         End if;

                         lc_usuresupe:=lc_usuresasi;--usuario de supervision


                   exception
                         when no_data_found then
                           lc_error:= sqlcode;
                           lc_coderr:=sqlerrm;
                         when others then
                           lc_error:= sqlcode;
                           lc_coderr:=sqlerrm;
                   end;

                lc_cargo:='Gestor de Cobranza'; --Segmentacion

          END CASE;

    WHEN g.sng400evto =  evento1002    THEN

         ld_fecgene := g.sng410fecg;--f generacion

         begin --f asignacion
             select s.sng229fece
             into ld_fecasig
             from sng229 s
             where s.sng229rss = g.sng410corr;
         exception
          when no_data_found then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
          when others then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
         end;

         begin -- usuario de asignacion
             select distinct s.sng001ase
            into lc_usuresasi
            from sng001 s
            where s.sng001inst = g.sng410inst;

            select distinct SNG057JEF -- usuario de supervision
            into lc_usuresupe
            from sng057
            where sng055emp =pn_pgcod
            and sng057usr= lc_usuresasi;

            lc_usuregest:= lc_usuresasi;--usuario de  gestion

          exception
          when no_data_found then
             lc_error:= sqlcode;
             lc_coderr:=sqlerrm;
           when others then
             lc_error:= sqlcode;
             lc_coderr:=sqlerrm;
          end;

         begin   --Segmentacion
           select s5.sng055dsc
           into lc_cargo
           from sng055 s5
           inner join sng057 s7
           on s5.sng055emp=s7.sng055emp
           and s5.sng055car=s7.sng055car
           where  sng057usr=lc_usuresasi;
        exception
         when no_data_found then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
         when others then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
         end;



    WHEN  g.sng400evto =  evento1004   THEN

         ld_fecgene := g.sng410fecg;--f generacion
         ld_fecasig := g.sng410fecg;
          IF  g.sng406prg=evento1004_HSNG461 THEN
                     begin
                         select s.sng001ase -- usuario de asignacion
                         into lc_usuresasi
                         from sng001 s
                         where s.sng001inst = g.sng410inst;

                         select distinct SNG057JEF --usuario supervision
                         into lc_usuresupe
                         from sng057
                         where sng055emp =pn_pgcod
                         and sng057usr= lc_usuresasi;

                         lc_usuregest:= lc_usuresasi;--usuario de gestion

                      exception
                      when no_data_found then
                         lc_error:= sqlcode;
                         lc_coderr:=sqlerrm;
                       when others then
                         lc_error:= sqlcode;
                         lc_coderr:=sqlerrm;
                      end;

                      begin   --Segmentacion
                       select s5.sng055dsc
                       into lc_cargo
                       from sng055 s5
                       inner join sng057 s7
                       on s5.sng055emp=s7.sng055emp
                       and s5.sng055car=s7.sng055car
                       where  sng057usr=lc_usuresasi;
                      exception
                        when no_data_found then
                           lc_error:= sqlcode;
                           lc_coderr:=sqlerrm;
                         when others then
                           lc_error:= sqlcode;
                           lc_coderr:=sqlerrm;
                      end;
            ELSE--WHEN  g.sng406prg='HSNG461A' THEN
                   lc_usuresasi:='SISTEMA';  --resp asignacion

                     begin
                        select sng415cpo --usuario de gestion
                        into lc_usuregest
                        from sng415
                        where sng410corr = g.sng410corr;

                        select distinct SNG057JEF -- usuario de supervision
                        into lc_usuresupe
                        from sng057
                        where sng055emp =pn_pgcod
                        and sng057usr= lc_usuregest;

                     exception
                      when no_data_found then
                       lc_error:= sqlcode;
                       lc_coderr:=sqlerrm;
                      when others then
                       lc_error:= sqlcode;
                       lc_coderr:=sqlerrm;
                     end;

                     begin   --Segmentacion
                         select s5.sng055dsc
                         into lc_cargo
                         from sng055 s5
                         inner join sng057 s7
                         on s5.sng055emp=s7.sng055emp
                         and s5.sng055car=s7.sng055car
                         where  sng057usr=lc_usuregest;
                     exception
                      when no_data_found then
                       lc_error:= sqlcode;
                       lc_coderr:=sqlerrm;
                      when others then
                       lc_error:= sqlcode;
                       lc_coderr:=sqlerrm;
                     end;

             END IF;

     WHEN g.sng400evto=evento1100 or g.sng400evto=evento1101 THEN

         ld_fecgene := g.sng410fecg;--f generacion

         IF g.sng410its=0 or g.sng410its is null THEN
          lc_retprejud:='NO';
         END IF;
         IF g.sng410its=999 THEN
          lc_retprejud:='SI';
         END IF;

         begin --usu asig
           select sng419user
           into lc_usuresasi
           FROM sng419
           where sng419acc = 7
           and sng410corr = g.sng410corr;
        exception
          when no_data_found then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
          when others then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
         end;

     END CASE;
   exception
    when no_data_found then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
    when others then
     lc_error:= sqlcode;
     lc_coderr:=sqlerrm;
   end;----FIN CASE



     if(lc_usuresasi ='SISTEMA') then --nom asig
          lc_nomresasi:='SISTEMA';
     else
          begin
         select ubnom into lc_nomresasi
         from fst746 where ubuser=lc_usuresasi;
         exception
          when no_data_found then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
          when others then
           lc_error:= sqlcode;
           lc_coderr:=sqlerrm;
         end;
     end if;

     begin              --nom ges
     select ubnom into lc_nomresges
     from fst746 where ubuser=lc_usuregest;
     exception
      when no_data_found then
       lc_error:= sqlcode;
       lc_coderr:=sqlerrm;
      when others then
       lc_error:= sqlcode;
       lc_coderr:=sqlerrm;
     end;

     begin   --nom super
       select ubnom into lc_nomresupe
       from fst746 where ubuser=lc_usuresupe;
     exception
        when no_data_found then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
        when others then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
     end;
     
     If(g.sng400evto=evento1101) then--segmentacion
      select aostat
        into estado
        from fsd010
       where aomod = g.sng410mod
         and aomda = g.sng410mda
         and aopap = g.sng410pap
         and aocta = g.sng410cta
         and aooper = g.sng410op
         and aosbop = g.sng410sbop
       and aotope = g.sng410top;
       
       if(estado in (0,61,21,24)) then
                        begin 
                               select distinct 1 into verif_seg
                               from sng411
                              where exists (select *
                                       from sng411
                                      where sng410corr = g.sng410corr
                                        and sng406PRG = evento1101_HSNG461);
                                     
                              
                                 select s.sng001ase -- usuario de asignacion
                                 into lc_usuresasi
                                 from sng001 s
                                 where s.sng001inst = g.sng410inst;

                                 select distinct SNG057JEF --usuario supervision
                                 into lc_usuresupe
                                 from sng057
                                 where sng055emp =pn_pgcod
                                 and sng057usr= lc_usuresasi;

                                 lc_usuregest:= lc_usuresasi;--usuario de gestion
                                 
                                    begin   --Segmentacion
                                     select s5.sng055dsc
                                     into lc_cargo
                                     from sng055 s5
                                     inner join sng057 s7
                                     on s5.sng055emp=s7.sng055emp
                                     and s5.sng055car=s7.sng055car
                                     where  sng057usr=lc_usuresasi;
                                    exception
                                      when no_data_found then
                                         lc_error:= sqlcode;
                                         lc_coderr:=sqlerrm;
                                       when others then
                                         lc_error:= sqlcode;
                                         lc_coderr:=sqlerrm;
                                    end;         
                            
                        exception 
                        when no_data_found then
                          begin
                              select distinct 1 into  verif_seg
                               from sng411
                              where exists (select *
                                       from sng411
                                      where sng410corr = g.sng410corr
                                        and (sng406PRG = evento1101_HSNG462  or sng406PRG = evento1101_HSNG461A));
                              if(verif_seg =1) then
                                         lc_cargo:='Gestor de Cobranza';
                              end if;
                             exception
                              when no_data_found then
                                 lc_error:= sqlcode;
                                 lc_coderr:=sqlerrm;
                               when others then
                                 lc_error:= sqlcode;
                                 lc_coderr:=sqlerrm;
                              end;
                         end;

                       end if;
     end if;
     
     begin
     select sng230fecp, sng230user
     into   ld_feccomp,lc_usucom
       from sng230
      where sng229corr = g.sng410corr;
     exception
        when no_data_found then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
        when others then
         lc_error:= sqlcode;
         lc_coderr:=sqlerrm;
     end;
     ln_cantreg := nvl(ln_cantreg,0) + 1;

     t_gest(ln_cantreg).c_zon_val:= g.regnom;
     t_gest(ln_cantreg).c_cor_val:=g.sng410corr;
     t_gest(ln_cantreg).c_seg_val:= lc_cargo;
     t_gest(ln_cantreg).c_fge_val:= ld_fecgene;
     t_gest(ln_cantreg).c_fsi_val:= ld_fecasig;
     t_gest(ln_cantreg).c_eve_val:= g.sng400evto;
     t_gest(ln_cantreg).c_prog_val:=g.sng406prg;
     t_gest(ln_cantreg).c_rpj_val:= lc_retprejud;
     t_gest(ln_cantreg).c_rge_val:= lc_usuregest;
     t_gest(ln_cantreg).c_nge_val:= lc_nomresges;
     t_gest(ln_cantreg).c_nsu_val:= lc_nomresupe;
     t_gest(ln_cantreg).c_nas_val:= lc_nomresasi;
     t_gest(ln_cantreg).c_ins_val:= g.sng410inst;
     t_gest(ln_cantreg).c_mod_val:= g.sng410mod;
     t_gest(ln_cantreg).c_suc_val:= g.sng410suc;
     t_gest(ln_cantreg).c_mda_val:= g.sng410mda;
     t_gest(ln_cantreg).c_pap_val:= g.sng410pap;
     t_gest(ln_cantreg).c_cta_val:= g.sng410cta;
     t_gest(ln_cantreg).c_ope_val:= g.sng410op;
     t_gest(ln_cantreg).c_sbo_val:= g.sng410sbop;
     t_gest(ln_cantreg).c_top_val:= g.sng410top;
     t_gest(ln_cantreg).c_fcom_val:=ld_feccomp;
     t_gest(ln_cantreg).c_ucom_val:=lc_usucom;


  end loop;
 pn_contg:=ln_cantreg;

end sp_cr_datos_gestores;

----------------------------------------------------------------------------------------
procedure sp_elimina_jaqy710(pn_codreg IN number,--cod region
                             pd_feccar IN date)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_elimina_jaqy710
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Elimina evento 1001,1003 si tienen los eventos (HSNG461 Y HSNG462)-SE ELIMINAR ELHSNG461
  --                              EN EL CASO QUE TENGAN LOS EVENTOS (HSNG461A Y HSNG462 ) -SE ELIMINA EL  HSNG462
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_codreg:codigo de region,pd_feccar:fecha de apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  CURSOR repetidos IS
      select JAQY710FPRO,
           JAQY710COD,
           JAQY710MOD,
           JAQY710SUC,
           JAQY710MDA,
           JAQY710PAP,
           JAQY710CTA,
           JAQY710OPE,
           JAQY710SBO,
           JAQY710TOP,
           jaqy710inst,
           count(*),
           min(jaqy710cor)as jaqy710cor 
      from jaqy710
     where jaqy710fpro = pd_feccar
      and jaqy710czo = pn_codreg
      group by JAQY710FPRO,
              JAQY710COD,
              JAQY710MOD,
              JAQY710SUC,
              JAQY710MDA,
              JAQY710PAP,
              JAQY710CTA,
              JAQY710OPE,
              JAQY710SBO,
              JAQY710TOP,
              jaqy710inst
    having count(*) > 1;
   evento1001 number;
   evento1002 number;
   evento1003 number;
   evento1004 number;
   evento1100 number;
   evento1101 number;
   
   evento1001_HSNG461 varchar2(10);
   evento1001_HSNG462 varchar2(10);
   evento1001_HSNG461A varchar2(10);
   
   evento1003_HSNG461 varchar2(10);
   evento1003_HSNG462 varchar2(10);
   evento1003_HSNG461A varchar2(10);


   evento1101_HJAQM220 varchar2(10);

   
begin
   --EVENTOS 
   select distinct(tp1nro1)into evento1001 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2; --1001
   select distinct(tp1nro1) into evento1003 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =4;  --1003
   select distinct(tp1nro1) into evento1100 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =6; --1100
   select distinct(tp1nro1) into evento1101 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =7; --1101

   --PROGRAMAS
   
   select substr(tp1desc,1,10) into evento1001_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=1; --1001:hsgn461
   select substr(tp1desc,1,10) into evento1001_HSNG461A from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=2;
   select  substr(tp1desc,1,10) into evento1001_HSNG462 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =2 and tp1corr3=3;
    

   select  substr(tp1desc,1,10) into evento1003_HSNG461 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=1; --1003:hsgn461
   select  substr(tp1desc,1,10) into evento1003_HSNG461A from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=2;
   select  substr(tp1desc,1,10) into evento1003_HSNG462 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =4 and tp1corr3=3;
   
   select  substr(tp1desc,1,10) into evento1101_HJAQM220 from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2 =7 and tp1corr3=4; --1101:hsgn461
   


    DELETE FROM JAQY710 WHERE
    (JAQY710COR, JAQY710FPRO, JAQY710COD, JAQY710MOD, JAQY710SUC, JAQY710MDA, JAQY710PAP, JAQY710CTA, JAQY710OPE, JAQY710SBO, JAQY710TOP)
    in
    (
      select a.JAQY710COR,a.JAQY710FPRO,a.JAQY710COD,a.JAQY710MOD,a.JAQY710SUC,a.JAQY710MDA,a.JAQY710PAP,a.JAQY710CTA,a.JAQY710OPE,a.JAQY710SBO,a.JAQY710TOP
       from jaqy710 a,
             (select jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
                from jaqy710
               where jaqy710eve in (evento1001)
                 and jaqy710prg in (evento1001_HSNG461, evento1001_HSNG462)
                 and jaqy710fge = pd_feccar
                 and jaqy710czo = pn_codreg
               group by jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
              having count(*) > 1) b
       where a.jaqy710cta = b.jaqy710cta
         and a.jaqy710ope = b.jaqy710ope
         and a.jaqy710eve = b.jaqy710eve
         and a.jaqy710fge = b.jaqy710fge
         and a.jaqy710prg = evento1001_HSNG461
    );
    commit;

     DELETE FROM JAQY710 WHERE
    (JAQY710COR, JAQY710FPRO, JAQY710COD, JAQY710MOD, JAQY710SUC, JAQY710MDA, JAQY710PAP, JAQY710CTA, JAQY710OPE, JAQY710SBO, JAQY710TOP)
    in
    (
      select a.JAQY710COR,a.JAQY710FPRO,a.JAQY710COD,a.JAQY710MOD,a.JAQY710SUC,a.JAQY710MDA,a.JAQY710PAP,a.JAQY710CTA,a.JAQY710OPE,a.JAQY710SBO,a.JAQY710TOP
       from jaqy710 a,
             (select jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
                from jaqy710
               where jaqy710eve in (evento1003)
                 and jaqy710prg in (evento1003_HSNG461, evento1003_HSNG462)
                 and jaqy710fge = pd_feccar
                 and jaqy710czo = pn_codreg
               group by jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
              having count(*) > 1) b
       where a.jaqy710cta = b.jaqy710cta
         and a.jaqy710ope = b.jaqy710ope
         and a.jaqy710eve = b.jaqy710eve
         and a.jaqy710fge = b.jaqy710fge
         and a.jaqy710prg = evento1003_HSNG461
    );
    commit;

     DELETE FROM JAQY710 WHERE
    (JAQY710COR, JAQY710FPRO, JAQY710COD, JAQY710MOD, JAQY710SUC, JAQY710MDA, JAQY710PAP, JAQY710CTA, JAQY710OPE, JAQY710SBO, JAQY710TOP)
    in
    (
      select a.JAQY710COR,a.JAQY710FPRO,a.JAQY710COD,a.JAQY710MOD,a.JAQY710SUC,a.JAQY710MDA,a.JAQY710PAP,a.JAQY710CTA,a.JAQY710OPE,a.JAQY710SBO,a.JAQY710TOP
       from jaqy710 a,
             (select jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
                from jaqy710
               where jaqy710eve in (evento1001)
                 and jaqy710prg in (evento1001_HSNG461A, evento1001_HSNG462)
                 and jaqy710fge = pd_feccar
                 and jaqy710czo = pn_codreg
               group by jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
              having count(*) > 1) b
       where a.jaqy710cta = b.jaqy710cta
         and a.jaqy710ope = b.jaqy710ope
         and a.jaqy710eve = b.jaqy710eve
         and a.jaqy710fge = b.jaqy710fge
         and a.jaqy710prg = evento1001_HSNG462
    );
    commit;

    DELETE FROM JAQY710 WHERE
    (JAQY710COR, JAQY710FPRO, JAQY710COD, JAQY710MOD, JAQY710SUC, JAQY710MDA, JAQY710PAP, JAQY710CTA, JAQY710OPE, JAQY710SBO, JAQY710TOP)
    in
    (
      select a.JAQY710COR,a.JAQY710FPRO,a.JAQY710COD,a.JAQY710MOD,a.JAQY710SUC,a.JAQY710MDA,a.JAQY710PAP,a.JAQY710CTA,a.JAQY710OPE,a.JAQY710SBO,a.JAQY710TOP
       from jaqy710 a,
             (select jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
                from jaqy710
               where jaqy710eve in (evento1003)
                 and jaqy710prg in (evento1003_HSNG461A, evento1003_HSNG462)
                 and jaqy710fge = pd_feccar
                 and jaqy710czo = pn_codreg
               group by jaqy710cod,jaqy710mod,jaqy710suc,jaqy710mda,jaqy710pap,jaqy710cta,jaqy710ope,jaqy710sbo,jaqy710top,jaqy710eve,jaqy710fge
              having count(*) > 1) b
       where a.jaqy710cta = b.jaqy710cta
         and a.jaqy710ope = b.jaqy710ope
         and a.jaqy710eve = b.jaqy710eve
         and a.jaqy710fge = b.jaqy710fge
         and a.jaqy710prg = evento1003_HSNG462
    );
    commit;


    delete  from jaqy710
    where jaqy710eve in (evento1101,evento1100)
     and jaqy710prg <>evento1101_HJAQM220
     and jaqy710fge = pd_feccar
     and jaqy710czo = pn_codreg;
    commit;
   FOR  g in repetidos LOOP
   delete from  jaqy710 j 
          where j.jaqy710fpro=g.JAQY710FPRO
          and j.JAQY710COD=g.JAQY710COD
          and j.JAQY710MOD = g.JAQY710MOD
          and j.JAQY710SUC = g.JAQY710SUC
          and j.JAQY710MDA = g.JAQY710MDA
          and j.JAQY710PAP = g.JAQY710PAP
          and j.JAQY710CTA = g.JAQY710CTA
          and j.JAQY710OPE = g.JAQY710OPE
          and j.JAQY710SBO = g.JAQY710SBO
          and j.JAQY710TOP = g.JAQY710TOP
          and j.jaqy710inst= g.jaqy710inst
          and j.jaqy710cor >g.jaqy710cor; 
          commit;
   END LOOP;
end;
------------------------------------------------------------------------------------------------------
Procedure sp_actualiza_jaqy710(lc_pgcod in number,
                                pn_sucur IN number,
                                  pd_feccar IN date)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_elimina_jaqy710
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Elimina evento 1001,1003 si tienen los eventos (HSNG461 Y HSNG462)-SE ELIMINAR ELHSNG461
  --                              EN EL CASO QUE TENGAN LOS EVENTOS (HSNG461A Y HSNG462 ) -SE ELIMINA EL  HSNG462
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_codreg:codigo de region,pd_feccar:fecha de apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  cursor c_jaqy710 is
    select o.sng229fece,j.* from sng229  o
    inner join jaqy710 j
    on o.sng229rss =j.jaqy710cev
    where jaqy710fpro=pd_feccar  and jaqy710eve<>(select distinct(tp1nro1)  from fst198 where tp1cod1=10890  and tp1corr1=1 and tp1corr2  =5)  --1004
    and j.jaqy710suc=pn_sucur
    and j.jaqy710cod=lc_pgcod;

begin
  for jj in c_jaqy710 loop
           update jaqy710 j10 set jaqy710fas=jj.sng229fece where
           j10.JAQY710COR = jj.JAQY710COR and
           j10.JAQY710FPRO= jj.JAQY710FPRO and
           j10.JAQY710COD = jj.JAQY710COD and
           j10.JAQY710MOD = jj.JAQY710MOD and
           j10.JAQY710SUC = jj.JAQY710SUC and
           j10.JAQY710MDA = jj.JAQY710PAP and
           j10.JAQY710CTA = jj.JAQY710CTA and
           j10.JAQY710OPE = jj.JAQY710OPE and
           j10.JAQY710SBO = jj.JAQY710SBO and
           j10.JAQY710TOP = jj.JAQY710TOP;
           commit;
    end loop;
    

end;
---------------------------------------------------------------------------
procedure sp_actualiza_jaqy710_job
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy709_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para insercion jay709- reporte de liquidacion de gestores
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1,pd_feccar:fecha apeertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

    cursor c_regiones_job is  --sucursales
       select sucurs
         from fst001
        where sucurs < 200
          and pgcod = 1;

   lc_feccar varchar2(10);

   lc_pgcod varchar2(4);


lc_hostname varchar2(64);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
      fpro date;

  BEGIN
    
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
  
      select pgfape into fpro from fst017 where pgcod = 1;
     lc_feccar := to_char(fpro,'RRRR.MM.DD');
     lc_pgcod  :=to_char(1);


     for job in c_regiones_job loop

         lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_actualiza_jaqy710(to_number('''||lc_pgcod||''')'||
              ',to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_feccar||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;

--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then --2017
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
--                      instance => 2,
                      instance => 1,
                      force => false
                      );
else
                         DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
end if;
        commit;

     end loop;

  end sp_actualiza_jaqy710_job;
------------------------------------------------------------------------------------------------------
Procedure sp_inserta_jaqy710(pn_pgcod IN number,
                             pn_codreg IN number,--cod region
                             pd_feccar IN date)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy710
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.24
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Obtiene los datos de un eventos
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1,pn_codreg:codigo de region,pd_feccar:fecha de apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

  lc_error  varchar(500);
  lc_coderr varchar(500);


  ln_cant_gest number(10);
  t_datos_gest   tab_gest;

  lc_zon varchar2(40);  --zona
  lc_seg varchar2(40);  --segmentacion (CARGO)
  ld_fge date;          --fecha de generacion
  ld_fsi date;          --fecha de asignacion
  ln_eve number(10);    --evento
  lc_rpj varchar2(10);  --retorno de prejudicial
  lc_rge varchar2(10);  --usuario responsable de gestion
  lc_nge varchar2(30);  --nombre responsable de gestion
  lc_nsu varchar2(30);  --nombre responsable de supervision
  lc_nas varchar2(30);  --nombre responsable de asignacion
  lc_ins number(10);     --instancia
  ln_mod number(3);     --modulo
  ln_suc number(3);     --sucursal
  ln_mda number(4);     --moneda
  ln_pap number(4);     --papel
  ln_cta number(9);     --cta
  ln_ope number(9);     --operacion
  ln_sbo number(3);     --sub operacion
  ln_top number(3);      --tipo de operacion
  ld_fco date;           --fecha compromiso
  lc_uco varchar(10);    --usuario compromiso

  ln_pais number(3);     --pais
  ln_tdoc number(2);     --tipo doc
  lc_ndoc varchar2(12);  --nro doc

  lc_nomtit fsd001.penom%type;      --nombre titular
  lc_dirtit sngc13.sngc13dir%type;   --direccion titular
  lc_reftit sngc13.sngc13ref1%type;  --referencia titular
  lc_distit fst071.fst071dsc%type;   --ditrito titular

  lc_descsu varchar(30);  --descripcion sucursal
  ln_frecpag number(5); --frecuencia de pago
  ln_mtoapro number(17,2); --monto aprobado


  ln_saldocap number(17,2);--saldo capital
  lc_credusu varchar2(30); --usuario asignado al cred.
  ln_canaval number(5); --cant avales
  ln_prg varchar2(10); --programa


  ln_atraso_eve number(5); --atraso del credito a la fecha del evento
  ln_datraso_max_eve number(5); --atraso MAX del CLIENTE a la fec EVENTO
  ln_saldocon_eve number(17,2); --saldo acum a la fech del evento por el CLIENTE
  ln_corr number(18);
  ln_ceve number(10);--correlativo de la sng410
  ln_tipcam number(14,8);--tipo de cambio
  pd_fecpagoeve date;--ultimo pago a la fecha del evento
  pn_deuda_mora_eve number(17,2); --deuda mora a la fecha del evento
  pn_cuo_imp_eve number(17,2);--cuota impaga a la fecha del evento
  ln_montocuoeve number(17,2);-- monto cuota a la fecha del evento

  begin


   select cotcbi into ln_tipcam
    from fsh005
   where cofdes =
         (select max(cofdes)
            from fsh005
           where moneda = 101
             and cofdes <= pd_feccar)
   and moneda = 101;
  pq_cr_rep_recuperacion_legal.sp_cr_datos_gestores(pn_pgcod => pn_pgcod,
                                                      pn_codreg => pn_codreg,
                                                      pd_fecini => pd_feccar,
                                                      pd_fecfin => pd_feccar,
                                                      t_gest => t_datos_gest,
                                                      pn_contg =>ln_cant_gest);
    for j in 1..ln_cant_gest loop
          pd_fecpagoeve :=null;
          pn_deuda_mora_eve:=null;
          pn_cuo_imp_eve:=null;
          ln_montocuoeve := null;
          lc_zon:= t_datos_gest(j).c_zon_val;
          lc_seg:= t_datos_gest(j).c_seg_val;
          ld_fge:= t_datos_gest(j).c_fge_val;
          ld_fsi:= t_datos_gest(j).c_fsi_val;
          ln_eve:= t_datos_gest(j).c_eve_val;
          ln_prg:= t_datos_gest(j).c_prog_val;
          lc_rpj:= t_datos_gest(j).c_rpj_val;
          lc_rge:= t_datos_gest(j).c_rge_val;
          lc_nge:= t_datos_gest(j).c_nge_val;
          lc_nsu:= t_datos_gest(j).c_nsu_val;
          lc_nas:= t_datos_gest(j).c_nas_val;
          lc_ins:= t_datos_gest(j).c_ins_val;
          ln_mod:= t_datos_gest(j).c_mod_val;
          ln_suc:= t_datos_gest(j).c_suc_val;
          ln_mda:= t_datos_gest(j).c_mda_val;
          ln_pap:= t_datos_gest(j).c_pap_val;
          ln_cta:= t_datos_gest(j).c_cta_val;
          ln_ope:= t_datos_gest(j).c_ope_val;
          ln_sbo:= t_datos_gest(j).c_sbo_val;
          ln_top:= t_datos_gest(j).c_top_val;
          ld_fco:= t_datos_gest(j).c_fcom_val;
          lc_uco:= t_datos_gest(j).c_ucom_val;
          ln_ceve:=  t_datos_gest(j).c_cor_val;


          pq_cr_rep_recuperacion_legal.sp_cr_datos_titular(pn_pgcod => pn_pgcod,
                                                           pn_cta => ln_cta,
                                                           pn_pais => ln_pais,
                                                           pn_petdoc => ln_tdoc,
                                                           pn_pendoc => lc_ndoc,
                                                           pc_nomtit => lc_nomtit,
                                                           pc_dirtit => lc_dirtit,
                                                           pc_reftit => lc_reftit,
                                                           pc_distit => lc_distit);

         lc_descsu := pq_cr_rep_recuperacion_legal.fn_cr_desc_sucursal(pn_pgcod => pn_pgcod,
                                                              pn_succod => ln_suc);

         ln_canaval := pq_cr_rep_recuperacion_legal.fn_cr_cantidad_av(pn_pgcod => pn_pgcod,
                                                            pn_inst => lc_ins);

         lc_credusu := fn_analista_credito(v_scmod => ln_mod,
                                           v_scsuc =>ln_suc,
                                           v_scmda => ln_mda,
                                           v_scpap => ln_pap,
                                           v_sccta => ln_cta,
                                           v_scoper => ln_ope,
                                           v_scsbop => ln_sbo,
                                           v_sctope => ln_top);

      pq_cr_rep_recuperacion_legal.sp_cr_credito_fevento(pd_feceve => ld_fge,--FECHA DEL EVENTO ES LA FECHA DE GENERACION
                                                     pt_pgcod => pn_pgcod,
                                                     pt_modu => ln_mod,
                                                     pt_sucu => ln_suc,
                                                     pt_moneda => ln_mda,
                                                     pt_papel => ln_pap,
                                                     pt_cnta => ln_cta,
                                                     pt_operac => ln_ope,
                                                     pt_sboper => ln_sbo,
                                                     pt_toper => ln_top,
                                                     ln_tipcam => ln_tipcam,
                                                     pn_saldocap => ln_saldocap,
                                                     pn_datraso_max_eve => ln_datraso_max_eve,
                                                     pn_saldocon_eve => ln_saldocon_eve,
                                                     pd_fecpagoeve => pd_fecpagoeve,
                                                     ln_montocuoeve => ln_montocuoeve,
                                                     pn_cuo_imp => pn_cuo_imp_eve,
                                                     pn_deuda_mora => pn_deuda_mora_eve);




      ln_atraso_eve := pq_cr_rep_recuperacion_legal.fn_cr_dias_atraso_cred(pd_fec => ld_fge,
                                                                 pt_pgcod => pn_pgcod,
                                                                 pt_modu => ln_mod,
                                                                 pt_sucu => ln_suc,
                                                                 pt_moneda => ln_mda,
                                                                 pt_papel => ln_pap,
                                                                 pt_cnta => ln_cta,
                                                                 pt_operac => ln_ope,
                                                                 pt_sboper => ln_sbo,
                                                                 pt_toper => ln_top);

       pq_cr_rep_recuperacion_legal.sp_cr_datos_constantes(pt_pgcod => pn_pgcod,
                                                      pt_modu => ln_mod,
                                                      pt_sucu => ln_suc,
                                                      pt_moneda => ln_mda,
                                                      pt_papel => ln_pap,
                                                      pt_cnta => ln_cta,
                                                      pt_operac => ln_ope,
                                                      pt_sboper => ln_sbo,
                                                      pt_toper => ln_top,
                                                      pn_inst => lc_ins,
                                                      pn_frecpag => ln_frecpag,
                                                      pn_mtoapro => ln_mtoapro);



       If (ln_atraso_eve>0) then
                           --genera el correlativo
                   select nvl(max(t.jaqy710cor),0) + 1
                     into ln_corr
                     from jaqy710 t
                    where JAQY710COD=pn_pgcod
                      and JAQY710MOD=ln_mod
                      and JAQY710SUC=ln_suc
                      and JAQY710MDA=ln_mda
                      and JAQY710PAP=ln_pap
                      and JAQY710CTA=ln_cta
                      and JAQY710OPE=ln_ope
                      and JAQY710SBO=ln_sbo
                      and JAQY710TOP=ln_top
                      and JAQY710FPRO=pd_feccar;

                 begin
                insert into jaqy710 (
                  JAQY710COR,
                  JAQY710INST,
                  JAQY710COD,
                  JAQY710MOD,
                  JAQY710SUC,
                  JAQY710MDA,
                  JAQY710PAP,
                  JAQY710CTA,
                  JAQY710OPE,
                  JAQY710SBO,
                  JAQY710TOP,
                  JAQY710FPRO,
                  JAQY710PAI,
                  JAQY710TDC,
                  JAQY710NDC,
                  JAQY710AGE,
                  JAQY710USU,
                  JAQY710TIT,
                  JAQY710SAC,
                  JAQY710AMA,
                  JAQY710MAP,
                  JAQY710SCA,
                  JAQY710MCU,
                  JAQY710FRP,
                  JAQY710DAT,
                  JAQY710DTI,
                  JAQY710RET,
                  JAQY710DIS,
                  JAQY710NAV,
                  JAQY710RPJ,
                  JAQY710CZO,
                  JAQY710ZON,
                  JAQY710SEG,
                  JAQY710FGE,
                  JAQY710FAS,
                  JAQY710CEV,
                  JAQY710EVE,
                  JAQY710UGE,
                  JAQY710NGE,
                  JAQY710NSU,
                  JAQY710NAS,
                  JAQY710FCO,
                  JAQY710UCO,
                  JAQY710PRG,
                  JAQY710UFPE ,
                  jaqy710dmoe,
                  jaqy710cime,
                  jaqy710tca
                )
                values
                (ln_corr,
                 lc_ins,
                 pn_pgcod,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top,
                 pd_feccar,
                 ln_pais,
                 ln_tdoc,
                 lc_ndoc,
                 lc_descsu,
                 lc_credusu,
                 lc_nomtit,
                 ln_saldocon_eve,
                 ln_datraso_max_eve,
                 ln_mtoapro,
                 ln_saldocap*-1,
                 ln_montocuoeve,
                 ln_frecpag,
                 ln_atraso_eve,
                 lc_dirtit,
                 lc_reftit,
                 lc_distit,
                 ln_canaval,
                 lc_rpj,
                 pn_codreg,
                 lc_zon,
                 lc_seg,
                 ld_fge,
                 ld_fsi,
                 ln_ceve,
                 ln_eve,
                 lc_rge,
                 lc_nge,
                 lc_nsu,
                 lc_nas,
                 ld_fco,
                 lc_uco,
                 ln_prg,
                 pd_fecpagoeve,
                 pn_deuda_mora_eve,
                 pn_cuo_imp_eve,
                 ln_tipcam

                );
                exception
                    when no_data_found then
                     lc_error:= sqlcode;
                     lc_coderr:=sqlerrm;
                    when others then
                     lc_error:= sqlcode;
                     lc_coderr:=sqlerrm;
                 end;
                commit;
       end if;
    end loop;

    sp_elimina_jaqy710(pn_codreg,pd_feccar ) ;

End sp_inserta_jaqy710;
-----------------------------------------------------------------------------------------------------------------------------
procedure sp_inserta_jaqy710_job (pn_pgcod IN number,
                                  pd_feccar IN date) is
  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy709_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para insercion jay709- reporte de liquidacion de gestores
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1,pd_feccar:fecha apeertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

   cursor c_regiones_job is
         select regcod
           from FST810
          where regcod < 100
            and pgcod = 1;

   lc_feccar varchar2(10);

   lc_pgcod varchar2(4);


     lc_hostname varchar2(64);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;


  BEGIN


begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
  
     lc_feccar := to_char(pd_feccar,'RRRR.MM.DD');
     lc_pgcod  :=to_char(pn_pgcod);


     for job in c_regiones_job loop

         lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_inserta_jaqy710(to_number('''||lc_pgcod||''')'||
              ',to_number('''||job.regcod||''')'||
              ',TO_DATE('''||lc_feccar||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;

--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then 
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
--                      instance => 2,
                      instance => 1,
                      force => false
                      );
else
            DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
end if ;
        commit;

     end loop;

  end sp_inserta_jaqy710_job;
-----------------------------------------------------------------------------------------------

--=================================TABLA: JAQY709 --GENERA REPORTE===================================
-----------------------------------------------------------------------------------------------------

Function fn_cr_atraso_max_cli(  pd_fec IN date,
                                pn_pais in number,
                                pn_petdoc in number,
                                pc_pendoc in varchar2)return number
is
  -- ******************************************************************************************************
  -- Nombre                     : fn_cr_atraso_max_cli
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Atraso maximo del cliente
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_fec:fecha ,pn_pais:pais,pn_petdoc:tipo doc,pc_pendoc:nro doc
  -- Par¿metros de Salida       : maximo nro de dias de atraso
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 ln_dias_atraso_max number(5):=0;
begin
 begin

  select max(fn_dias_atraso(pd_fec,
          f.pgcod,
         f.aomod,
         f.aosuc,
         f.aomda,
         f.aopap,
         f.aocta,
         f.aooper,
         f.aosbop,
         f.aotope,
         f.aostat,
         f.aofvto)) into ln_dias_atraso_max
    from fsd010 f
    inner join fsr008 f8
    on f.aocta=f8.ctnro and f.pgcod=f8.pgcod
    inner join fst111 f11
    on f.aomod=f11.modulo
    and f11.dscod = 50
   where f8.pepais = pn_pais
     and f8.petdoc = pn_petdoc
     and f8.pendoc = pc_pendoc
     and f8.ttcod = 1
     and f8.CTTFIR = 'T'
     and f.aostat<>99
     and f.aomod not in(108,141,117) ;
  exception
    when no_data_found then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;

  end;

        return ln_dias_atraso_max;
end fn_cr_atraso_max_cli;
-------------------------------------------------------------------------------------------------------
Procedure sp_cr_credito_ffin(pd_fecfin IN date,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                pn_dat_cuopag OUT number,
                                pd_fec_ultcuo OUT date,
                                pc_descprodsbs out varchar2,
                                pc_tipcont out varchar2)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_credito_ffin
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : calcula la fecha de la ultima cuota pagada, el monto, tipo y descripcion del producto sbs
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_fec:fecha ,pn_pais:pais,pn_petdoc:tipo doc,pc_pendoc:nro doc
  -- Par¿metros de Salida       : pd_fecfin :fecha fin, pt_pgcod,pt_modu,pt_sucu,pt_moneda,pt_papel,pt_cnta,
  --                              pt_papel,pt_cnta,pt_operac,pt_sboper,pt_toper:pk del credito
  --                              pn_pais:pais,pn_petdoc:tipo doc,pc_pendoc:nro doc
  -- Fecha de Modificaci¿n      : pn_dat_cuopag:,pd_fec_ultcuo:fecha de ultima cuota,
  --                               pc_descprodsbs:descripcion de prod sbs,pc_tipcont:tipo sbs
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
  ln_prodsbs number(2);
 ln_rubro number(16);
 pd_fec_ultcuo_cal date;
begin

   ----fecha del ultimo pago en el rango fecini - fecfin---
      select max(pp1fech),max(ppfpag)
      into pd_fec_ultcuo, pd_fec_ultcuo_cal
      from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.pp1stat = 'T'
        and f.d602co = 'S'
        and f.ppfpag<=pd_fecfin;--last_day(add_months(pd_fecfin,-1));--

  --dias de atraso de la ultima cuota pagada dentro del rango: fecini -fecfin---
  begin
     select  nvl(pp1fech - ppfpag ,0)as d_atraso
      into pn_dat_cuopag
      from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.pp1stat = 'T'
        and f.d602co = 'S'
        and f.ppfpag=pd_fec_ultcuo_cal;

      IF (pn_dat_cuopag<0) THEN
        pn_dat_cuopag:=0;
      END IF;

  exception
    when no_data_found then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
      pn_dat_cuopag:=0;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;

  end;
  begin
        select nvl(f.scgru,0),f.scrub into ln_prodsbs,ln_rubro
        from fsd011 f
        inner join fst111 t
        on f.scmod = t.modulo
        where
        t.dscod = 50
        and f.pgcod = pt_pgcod
        and f.scsuc = pt_sucu
        and f.scmod = pt_modu
        and f.scmda = pt_moneda
        and f.scpap = pt_papel
        and f.sccta = pt_cnta
        and f.scoper=  pt_operac
        and f.SCSBOP=  pt_sboper
        and f.sctope = pt_toper ;

          --PRODUCTO SBS---
         CASE
         WHEN ln_prodsbs = 2 THEN pc_descprodsbs:='MICROEMPRESAS';
         WHEN ln_prodsbs = 3 and substr(ln_rubro,11,3)='015' THEN pc_descprodsbs:='CONSUMO REVOLVENTE';
         WHEN ln_prodsbs = 3 and substr(ln_rubro,11,3)<>'015' THEN pc_descprodsbs:='CONSUMO NO REVOLVENTE';
         WHEN ln_prodsbs = 4 THEN pc_descprodsbs:='HIPOTECARIO';
         WHEN ln_prodsbs = 12 THEN pc_descprodsbs:='MEDIANA EMPRESA';
         WHEN ln_prodsbs = 13 THEN pc_descprodsbs:='PEQUE¿A EMPRESA';
           ELSE pc_descprodsbs:='';
         END CASE;

         ---TIPO CONTABLE---
          CASE
          WHEN substr(ln_rubro, 1, 4) = '1411' or
               substr(ln_rubro, 1, 4) = '1421' THEN
            pc_tipcont := 'NORMAL';
          WHEN substr(ln_rubro, 1, 4) = '1414' or
               substr(ln_rubro, 1, 4) = '1424' THEN
            pc_tipcont := 'REFINANCIADO';
          WHEN substr(ln_rubro, 1, 4) = '1415' or
               substr(ln_rubro, 1, 4) = '1425' THEN
            pc_tipcont := 'VENCIDO';
          WHEN substr(ln_rubro, 1, 4) = '1416' or
               substr(ln_rubro, 1, 4) = '1426' THEN
            pc_tipcont := 'JUDICIAL';
         END CASE;
   exception
   when no_data_found then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
    when others then
      lc_coderr := sqlcode;
      lc_msgerr := sqlerrm;
  end;

end sp_cr_credito_ffin;
-----------------------------------------------------------------------------------------------------------------------------
 Procedure sp_cr_credito_factual( pd_fecape IN date ,
                                pt_pgcod   in number,
                                pt_modu   in number,
                                pt_sucu   in number,
                                pt_moneda in number,
                                pt_papel  in number,
                                pt_cnta   in number,
                                pt_operac in number,
                                pt_sboper in number,
                                pt_toper  in number,
                                pn_cuo_pag OUT number,
                                pn_statcre OUT number,
                                pd_fechcan OUT date,
                                ld_fecultpag OUT date)
is
    -- *****************************************************************
    -- Nombre                     : sp_cr_credito_factual
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          :
    -- Autor de Creaci¿n          :Sofia Fernandez
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      :pd_fecape : Fecha de apertura
    --                              pt_pgcod: 1
    --                              pt_modu: modulo
    --                              pt_sucu: sucursal
    --                              pt_moneda: moneda
    --                              pt_papel: moneda
    --                              pn_cta: cuenta
    --                              pt_operac: operacion
    --                              pt_sboper: sub operacion
    --                              pt_toper: tipo  operacion
    --                              pn_inst: instancia
    -- Par¿metros de Salida       : pn_cuo_imp: Cuota impaga
    --                              pn_statcre: estado del credito
    --                              pd_fechcan: fecha de cancelacion
    --                              pn_deuda_mora: deuda en mora al fecha
    --                              ld_fecultpag: ultima fecha de pago
    --                              pn_cuo_pag: cantidad de cuotas pagadad
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    -- *****************************************************************
  ld_fecpag date;
   lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
begin
ld_fecultpag:=null;
    /*  select max(ppfpag)
      into ld_fecultpag
      from fsd602 f
      where f.pgcod = pt_pgcod
        and f.ppmod = pt_modu
        and f.ppsuc = pt_sucu
        and f.ppmda = pt_moneda
        and f.pppap = pt_papel
        and f.ppcta = pt_cnta
        and f.ppoper = pt_operac
        and f.ppsbop = pt_sboper
        and f.pptope = pt_toper
        and f.pp1stat = 'T'
        and f.d602co = 'S';*/



      begin
        -----FERECUENCIA DE PAGO, ESTADO, FECHA DE CANCELACION-------
        select  f.aostat,f.aofe99
          into  pn_statcre,pd_fechcan
          from fsd010 f
         where f.pgcod = pt_pgcod
           and f.aomod = pt_modu
           and f.aosuc = pt_sucu
           and f.aomda = pt_moneda
           and f.aopap = pt_papel
           and f.aocta = pt_cnta
           and f.aooper = pt_operac
           and f.aosbop = pt_sboper
           and f.aotope = pt_toper;
        ---------------------------



        ---- CANTIDAD DE CUOTAS PAGADAS ----
        select count(*)
          into pn_cuo_pag
          from fsd602
         where pp1stat = 'T'
           and pgcod = pt_pgcod
           and ppmod = pt_modu
           and ppsuc = pt_sucu
           and ppmda = pt_moneda
           and pppap = pt_papel
           and ppcta = pt_cnta
           and ppoper = pt_operac
           and ppsbop = pt_sboper
           and pptope = pt_toper;
        ------------------------



      exception
        when no_data_found then
             lc_coderr := sqlcode;
             lc_msgerr := sqlerrm;
          end;
end sp_cr_credito_factual;

------------------------------------------------------------------------------------------------------
Procedure sp_inserta_jaqy709(pn_pgcod IN number,
                             pn_codreg IN number,--cod region
                             pd_fecini IN date,
                             pd_fecfin IN date,
                             pd_fecape IN date)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy709
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : inserta los datos a la tabla jaqy709
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1 ,pn_codreg:codigo region,pd_fecini:fecha inicio,pd_fecfin:fecha de fin  doc,pd_fecape
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************



  ln_cuo_imp number(17,2);
  ln_statcre number(2);
  ld_fechcan date;
  ln_cuo_pag number(5);
  ln_deuda_mora number(17,2);
  ld_fecultpag date;

  ln_dat_cuopag  number(5);
  ld_fec_ultcuo  date;
  lc_descprodsbs varchar2(30);
  lc_tipcont     varchar2(30);

  ln_atraso_fin number(5); --atraso del credito a la fecha del FIN
  ln_atraso_max_clie number(5);--atraso MAX del CLIENTE a la fec FIN

  ln_corr number(18);
  ln_tipcam number(18,4);
 -- ln_montocuoact number(18,2);
  cursor c_jaqy710 is
  select
  JAQY710COD,
  JAQY710MOD,
  JAQY710SUC,
  JAQY710MDA,
  JAQY710PAP,
  JAQY710CTA,
  JAQY710OPE,
  JAQY710SBO,
  JAQY710TOP,
  JAQY710PAI,
  JAQY710TDC,
  JAQY710NDC
  from jaqy710  where JAQY710fge>=pd_fecini and jaqy710fge<=pd_fecfin
  and JAQY710COD=pn_pgcod and JAQY710SUC=pn_codreg
  group by  JAQY710COD,
  JAQY710MOD,
  JAQY710SUC,
  JAQY710MDA,
  JAQY710PAP,
  JAQY710CTA,
  JAQY710OPE,
  JAQY710SBO,
  JAQY710TOP,
  JAQY710PAI,
  JAQY710TDC,
  JAQY710NDC ;

  begin
   BEGIN
      select cotcbi into ln_tipcam
        from fsh005
       where cofdes =
             (select max(cofdes)
                from fsh005
               where moneda = 101
                 and cofdes <= pd_fecfin -1) --last_day(add_months(pd_fecfin,-1)))
                 AND MONEDA=101;
    exception
     when no_data_found then
        ln_tipcam:=0;
     when others then
       Dbms_Output.put_line(sqlerrm);
     end;
    for j in c_jaqy710 loop
    --ln_montocuoact:=0;
      --genera el correlativo
         select nvl(max(t.jaqy709cor),0) + 1
           into ln_corr
           from jaqy709 t
          where JAQY709COD=j.jaqy710cod
            and JAQY709MOD=j.jaqy710mod
            and JAQY709SUC=j.jaqy710suc
            and JAQY709MDA=j.jaqy710mda
            and JAQY709PAP=j.jaqy710pap
            and JAQY709CTA=j.jaqy710cta
            and JAQY709OPE=j.jaqy710ope
            and JAQY709SBO=j.jaqy710sbo
            and JAQY709TOP=j.jaqy710top;


          pq_cr_rep_recuperacion_legal.sp_cr_credito_factual(pd_fecape => pd_fecape,
                                                         pt_pgcod => j.jaqy710cod,
                                                         pt_modu => j.jaqy710mod,
                                                         pt_sucu => j.jaqy710suc,
                                                         pt_moneda =>j.jaqy710mda,
                                                         pt_papel => j.jaqy710pap,
                                                         pt_cnta => j.jaqy710cta,
                                                         pt_operac => j.jaqy710ope,
                                                         pt_sboper => j.jaqy710sbo,
                                                         pt_toper => j.jaqy710top,
                                                         pn_cuo_pag => ln_cuo_pag,
                                                         pn_statcre => ln_statcre,
                                                         pd_fechcan => ld_fechcan,
                                                         ld_fecultpag => ld_fecultpag);

      pq_cr_rep_recuperacion_legal.sp_cr_credito_ffin(pd_fecfin => pd_fecfin,
                                                      pt_pgcod => j.jaqy710cod,
                                                      pt_modu =>  j.jaqy710mod,
                                                      pt_sucu =>  j.jaqy710suc,
                                                      pt_moneda =>j.jaqy710mda,
                                                      pt_papel => j.jaqy710pap,
                                                      pt_cnta =>  j.jaqy710cta,
                                                      pt_operac =>j.jaqy710ope,
                                                      pt_sboper =>j.jaqy710sbo,
                                                      pt_toper => j.jaqy710top,
                                                      pn_dat_cuopag => ln_dat_cuopag,
                                                      pd_fec_ultcuo => ld_fec_ultcuo,
                                                      pc_descprodsbs =>lc_descprodsbs,
                                                      pc_tipcont => lc_tipcont   );

     ln_atraso_fin := pq_cr_rep_recuperacion_legal.fn_cr_dias_atraso_cred(pd_fec => pd_fecfin,--last_day(add_months(pd_fecfin,-1)),--
                                                                 pt_pgcod =>  j.jaqy710cod,
                                                                 pt_modu =>   j.jaqy710mod,
                                                                 pt_sucu =>   j.jaqy710suc,
                                                                 pt_moneda => j.jaqy710mda,
                                                                 pt_papel =>  j.jaqy710pap,
                                                                 pt_cnta =>   j.jaqy710cta,
                                                                 pt_operac => j.jaqy710ope,
                                                                 pt_sboper => j.jaqy710sbo,
                                                                 pt_toper =>  j.jaqy710top);

     ln_atraso_max_clie := pq_cr_rep_recuperacion_legal.fn_cr_atraso_max_cli(pd_fec =>pd_fecfin,--last_day(add_months(pd_fecfin,-1)),--
                                                               pn_pais =>   j.jaqy710pai,
                                                               pn_petdoc => j.jaqy710tdc,
                                                               pc_pendoc => j.jaqy710ndc);

      insert into jaqy709
      (
      JAQY709COR,
      JAQY709COD,
      JAQY709MOD,
      JAQY709SUC,
      JAQY709MDA,
      JAQY709PAP,
      JAQY709CTA,
      JAQY709OPE,
      JAQY709SBO,
      JAQY709TOP,
      JAQY709FPRO,
      JAQY709PRO,
      JAQY709TCO,
      JAQY709STAT,
     -- JAQY709CIM,
      JAQY709FUP,
     -- JAQY709DMO,
      JAQY709CPA,
      JAQY709DUC,
      JAQY709DAC,
      JAQY709UFP,
      JAQY709AMC,
      JAQY709SCC,
      JAQY709FCA,
      JAQY709PAI,
      JAQY709TDC,
      JAQY709NDC,
      jaqy709tca

      )values
      (
        ln_corr,
        j.jaqy710cod,
        j.jaqy710mod,
        j.jaqy710suc,
        j.jaqy710mda,
        j.jaqy710pap,
        j.jaqy710cta,
        j.jaqy710ope,
        j.jaqy710sbo,
        j.jaqy710top,
        pd_fecfin ,
        lc_descprodsbs,
        lc_tipcont,
        ln_statcre,
      --  ln_cuo_imp,
        ld_fecultpag,
       -- ln_deuda_mora,
        ln_cuo_pag,
        ln_dat_cuopag,
        ln_atraso_fin,
        ld_fec_ultcuo,
        ln_atraso_max_clie,
        null,
        ld_fechcan,
        j.jaqy710pai,
        j.jaqy710tdc,
        j.jaqy710ndc,
        ln_tipcam

      )  ;
     commit;
    end loop;

  End sp_inserta_jaqy709;
----------------------------------------------------------------------------------------------------------------------
procedure sp_inserta_jaqy709_job (pn_pgcod IN number,
                                pd_fecape IN date)
                                is
  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy709_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para insercion jay709- reporte de liquidacion de gestores
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1/
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

   cursor c_regiones_job is  --sucursales
       select sucurs
         from fst001
        where sucurs < 200
          and pgcod = 1;

   lc_fecini varchar2(10);
   lc_fecfin varchar2(10);
   lc_pgcod varchar2(4);


   lc_hostname varchar2(64);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;

   ln_fec number(10);

  BEGIN

begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--'BANT221216', --2017
                                    tabname          => 'JAQY710',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;


    ln_fec:= to_number(to_char(pd_fecape, 'DD'));

    ------------------------------------------------------
    ---si es el primero generar todo lo del mes anterior---
    IF  ln_fec=1 THEN
         lc_fecini := to_char(pd_fecape,'RRRR.MM')||'.01';--to_char(ADD_MONTHS(pd_fecape,-1),'RRRR.MM')||'.01';
         lc_fecfin :=to_char(pd_fecape,'RRRR.MM')||'.01';-- to_char(ADD_MONTHS(pd_fecape,-1),'RRRR.MM')||'.01';
--         lc_fecfin := to_char(LAST_DAY(ADD_MONTHS(pd_fecape,-1)),'RRRR.MM.DD');
     ELSE
         lc_fecini:=to_char(pd_fecape,'RRRR.MM')||'.01';
         lc_fecfin := to_char(pd_fecape,'RRRR.MM.DD') ;
     END IF;


     lc_pgcod  :=to_char(pn_pgcod);

     for job in c_regiones_job loop

         lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_inserta_jaqy709(to_number('''||lc_pgcod||''')'||
              ',to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_fecini||''',''RRRR.MM.DD'')'||
              ',TO_DATE('''||lc_fecfin||''',''RRRR.MM.DD'')'||
              ',TO_DATE('''||lc_fecfin||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then  
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
--                              instance => 2,
                              instance => 1,
                              force => false
                              );
else
  DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
                              force => false
                              );
end if;
        commit;
       end loop;

  end sp_inserta_jaqy709_job;
----------------------------------------------------------------------------------------------------------------------
Procedure sp_inserta_jaqy712(pn_pgcod IN number,
                             pn_codreg IN number,--cod sucursal
                             pd_fecape IN date)
is

  -- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy712
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : lee la fsh012 -los creditos que tenga un cliente y lo almacena en la jay712
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1 ,pn_codreg:codigo region,pd_fecini:fecha inicio,pd_fecfin:fecha de fin  doc,pd_fecape
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  fechist date;
  ln_saldoacum number(18,2);
  --ln_rubro number(16);
  lc_sql varchar(2000);
  cursor c_jaqy709 is
    select /*+ALL_ROWS*/f.pgcod,
           f.aomod,
           f.aosuc,
           f.aomda,
           f.aopap,
           f.aocta,
           f.aooper,
           f.aosbop,
           f.aotope,
           a.jaqy709pai,
           a.jaqy709tdc,
           a.jaqy709ndc
      from fsd010 f
     inner join fsr008 f8 on f.aocta = f8.ctnro
                         and f.pgcod = f8.pgcod
     inner join fst111 f11 on f.aomod = f11.modulo
                          and f11.dscod = 50
     inner join (select JAQY709PAI, JAQY709TDC, JAQY709NDC
                   from jaqy709
                  where JAQY709fpro =pd_fecape
                    and JAQY709COD = pn_pgcod
                    and JAQY709SUC = pn_codreg
                  group by JAQY709PAI, JAQY709TDC, JAQY709NDC) a
     on f8.pepais = a.jaqy709pai
     and f8.petdoc = a.jaqy709tdc
     and f8.pendoc = a.jaqy709ndc
     where f8.ttcod = 1
     and f8.CTTFIR = 'T';

begin
  fechist:=pd_fecape-1;
  --fechist:=last_day(add_months(pd_fecape,-1));

      for j in c_jaqy709 loop

       LC_SQL :=  'INSERT INTO JAQY712(JAQY712COD,JAQY712SUC,JAQY712MOD,JAQY712MDA,JAQY712PAP,'||
                  'JAQY712CTA,JAQY712OPE,JAQY712SBO,JAQY712TOP,JAQY712FPRO,JAQY712PAI,JAQY712NDC,'||
                  'JAQY712TDC,JAQY712SDMN,JAQY712RUBRO)'||
                  'SELECT BCEMP,BCSUC,BCMOD,BCMDA,BCPAP,'||
                  'BCCTA,BCOPER,BCSBOP,BCTOP,TO_DATE('''||TO_CHAR(pd_fecape)||''',''DD/MM/RRRR''),'||j.jaqy709pai||','''||j.jaqy709ndc||''','||
                   j.jaqy709tdc||',NVL(BCSDMN,0),BCRUBR'||
                  ' FROM FSH012 PARTITION (FSH012_'||TO_CHAR(FECHIST,'YYYYMMDD')||')'||
                  ' INNER JOIN FST111 T ON BCMOD = T.MODULO'||
                  ' WHERE  T.DSCOD = 50 AND BCEMP = '||j.pgcod||
                  ' AND BCSUC= '||j.aosuc||
                  ' AND BCMOD= '||j.aomod||
                  ' AND BCMDA= '||j.aomda||
                  ' AND BCPAP= '||j.aopap||
                  ' AND BCCTA= '||j.aocta||
                  ' AND BCOPER='||j.aooper||
                  ' AND BCSBOP='||j.aosbop||
                  ' AND BCTOP= '||j.aotope;
          begin
          execute immediate lc_sql;
          /*
          insert into jaqy712(JAQY712COD,
                        JAQY712SUC,
                        JAQY712MOD,
                        JAQY712MDA,
                        JAQY712PAP,
                        JAQY712CTA,
                        JAQY712OPE,
                        JAQY712SBO,
                        JAQY712TOP,
                        JAQY712FPRO,
                        JAQY712PAI,
                        JAQY712NDC,
                        JAQY712TDC,
                        JAQY712SDMN,
                        JAQY712RUBRO)
             values ( j.pgcod,
                      j.aosuc,
                      j.aomod,
                      j.aomda,
                      j.aopap,
                      j.aocta,
                      j.aooper,
                      j.aosbop,
                      j.aotope,
                      pd_fecape,
                      j.jaqy709pai,
                      j.jaqy709ndc,
                      j.jaqy709tdc,
                      ln_saldoacum*-1,
                      ln_rubro);*/
               commit;
           exception
           when no_data_found then
              ln_saldoacum:=0;
           when others then
             Dbms_Output.put_line(sqlerrm);
           end;

     end loop;

end sp_inserta_jaqy712;
----------------------------------------------------------------------------------------------------------------------
procedure sp_inserta_jaqy712_job (pn_pgcod IN number,
                                pd_fecape IN date)
                                is
  -- ******************************************************************************************************
  -- Nombre                     : sp_actualiza_jaqy709_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para insertar jaqy712- saldos de cliente
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1/pd_fecape:fecha apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

   cursor c_regiones_job is  --sucursales
       select sucurs
         from fst001
        where sucurs < 200
          and pgcod = 1;


   lc_hostname varchar2(64);
   lc_fecini varchar2(10);
   lc_pgcod varchar2(4);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;
  BEGIN

begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
    lc_pgcod :=to_char(pn_pgcod);
    lc_fecini:= to_char(pd_fecape, 'RRRR.MM.DD');

    execute immediate 'truncate table jaqy712';
    commit;
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--'BANT221216', --2017
                                    tabname          => 'JAQY712',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => true);
    end;

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--'BANT221216', --2017
                                    tabname          => 'JAQY709',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    for job in c_regiones_job loop

         lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_inserta_jaqy712(to_number('''||lc_pgcod||''')'||
              ',to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_fecini||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;
--     if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--     if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
--                              instance => 2,
                              instance => 1,
                              force => false
                              );
      else
         DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
                              force => false
                              );
     end if;                        
        commit;
       end loop;

  end sp_inserta_jaqy712_job;
----------------------------------------------------------------------------------------------------------------------
Procedure sp_actualiza_jaqy709(pn_pgcod IN number,
                             pn_codreg IN number,--cod sucursal
                             pd_fecape IN date)
is
 -- ******************************************************************************************************
  -- Nombre                     : sp_actualiza_jaqy709
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para actualizacion de saldos jay709- reporte de liquidacion de gestores
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1/pd_fecape:fecha apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  cursor c_jaqy712 is

    select jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc, sum(jaqy712sdmn)as scc
    from jaqy712 j
    inner join jaql964 f
    on j.jaqy712suc=f.jaql964suc
    and j.jaqy712mod=f.jaql964mod
    and j.jaqy712mda=f.jaql964mda
    and j.jaqy712cta=f.jaql964cta
    and j.jaqy712ope=f.jaql964ope
    and j.jaqy712sbo=f.jaql964sob
    and j.jaqy712top=f.jaql964top
    where jaqy712fpro=pd_fecape  and jaqy712cod=pn_pgcod
    and f.jaql964dia>0
    and jaqy712mod not in(108,141,117)
   group by jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc  ;

      /* select jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc, sum(jaqy712sdmn)as scc
    from jaqy712 where jaqy712fpro=pd_fecape and jaqy712cod=pn_pgcod
    group by jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc;*/
    /*   select jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc, sum(jaqy712sdmn)as scc
    from jaqy712 j
    inner join fsd010 f
      on j.jaqy712cod=f.pgcod
      and j.jaqy712suc=f.aosuc
      and j.jaqy712mod = f.aomod
      and j.jaqy712mda= f.aomda
      and j.jaqy712pap=f.aopap
      and j.jaqy712cta=f.aocta
      and j.jaqy712ope=f.aooper
      and j.jaqy712sbo=f.aosbop
      and j.jaqy712top= f.aotope
    where jaqy712fpro=pd_fecape and jaqy712cod=pn_pgcod
    and fn_dias_atraso(pd_fecape,j.jaqy712cod,
           j.jaqy712mod,
           j.jaqy712suc,
           j.jaqy712mda,
           j.jaqy712pap,
           j.jaqy712cta,
           j.jaqy712ope,
           j.jaqy712sbo,
           j.jaqy712top,f.aostat,f.aofvto)>0
    and jaqy712mod not in(108,141,117)
   group by jaqy712fpro,jaqy712pai, jaqy712ndc, jaqy712tdc  ;*/
begin
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',--'BANT221216', --2017
                                  tabname          => 'JAQY712',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => dbms_stats.auto_sample_size,
                                  cascade          => true);
  end;
  for c in c_jaqy712 loop
       update jaqy709 t
       set t.jaqy709scc= c.scc
       where  t.jaqy709pai=c.jaqy712pai
       and t.jaqy709tdc=c.jaqy712tdc
       and t.jaqy709ndc=c.jaqy712ndc
       and t.jaqy709suc=pn_codreg
       and t.jaqy709fpro=c.jaqy712fpro;
       commit;
   end loop;

End sp_actualiza_jaqy709;
--------------------------------------------------------------------------------------------
procedure sp_actualiza_jaqy709_job (pn_pgcod IN number,
                                pd_fecape IN date)
                                is
  -- ******************************************************************************************************
  -- Nombre                     : sp_actualiza_jaqy709_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : JOBS para actualizacion de saldos jay709- reporte de liquidacion de gestores
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pn_pgcod:1/pd_fecape:fecha apertura
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************

   cursor c_regiones_job is  --sucursales
       select sucurs
         from fst001
        where sucurs < 200
          and pgcod = 1;

   lc_hostname varchar2(64);
   lc_fecini varchar2(10);
   lc_pgcod varchar2(4);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;
  BEGIN

begin
    select host_name
      into lc_hostname
      from v$instance;
  end;


    lc_pgcod :=to_char(pn_pgcod);
    lc_fecini:= to_char(pd_fecape, 'RRRR.MM.DD');

    for job in c_regiones_job loop

         lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_actualiza_jaqy709(to_number('''||lc_pgcod||''')'||
              ',to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_fecini||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;
              
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+5/(24*60),
                              interval => null,
                              no_parse => false,
--                              instance => 2,
                              instance => 1,
                              force => false
                              );
else
                DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+5/(24*60),
                              interval => null,
                              no_parse => false,
                              force => false
                              );
end if;
        commit;
       end loop;

end sp_actualiza_jaqy709_job;
--============================================================================================
--==================================REPORTE DE AMORTIZACIONES=================================
--============================================================================================
-------------------------------------------------------------------------------------------------------------
Function fn_cr_cap_ingreso(pt_pgcod   in number,
                           pt_cnta   in number,
                            pt_operac in number)
                            return number
--******************************************************************************************************
  -- Nombre                     : fn_cr_cap_ingreso
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.03.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : retorna el capital de ingreso de un credito
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pk_credito
  -- Par¿metros de Salida       :ln_capingreso:capital de ingreso
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 ln_capingreso number(17,2):=0;
begin
  begin
     select h.hcimp1 into ln_capingreso
     from fsh016 h
     where  h.hcmod = 300
     and h.htran =390
     and h.hcord=10
     and h.pgcod=pt_pgcod
     and h.hcta = pt_cnta
     and h.hoper = pt_operac;

   exception
          when no_data_found then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;

   end;
return ln_capingreso;
end;

-----------------------------------------------------------------------
Function fn_cr_desc_trans(pt_pgcod   in number,
                           itmod in number,
                           ittran in number )
                            return varchar2
  --******************************************************************************************************
  -- Nombre                     : fn_cr_desc_trans
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.03.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Retorna  las iniciales del abogado y la fecha de demanda
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pt_pgcod:1,itmod: mod. de  transaccion,ittran:transaccion
  -- Par¿metros de Salida       :lc_dectran:descripcion de la transaccion
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
is

 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 lc_dectran varchar2(100):='';
begin
   begin
     select f.trnom into  lc_dectran
     from fst034 f
     where f.pgcod=pt_pgcod
     and f.trmod=itmod
     and f.trnro=ittran;
   exception
          when no_data_found then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;

   end;
  return lc_dectran;
end;

-----------------------------------------------------------------------
Procedure sp_cr_abog_dmda(  pt_pgcod   in number,
                            pt_modu   in number,
                            pt_sucu   in number,
                            pt_moneda in number,
                            pt_papel  in number,
                            pt_cnta   in number,
                            pt_operac in number,
                            pt_sboper in number,
                            pt_toper  in number,
                            pn_scstat in number,
                            pf_asig out date,
                            pc_abrev out varchar2,
                            pf_deman out date,
                            pf_pasajud out date,
                            pf_trancart out date
                            )
--******************************************************************************************************
  -- Nombre                     : sp_cr_abog_dmda
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.03.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Retorna  las iniciales del abogado y la fecha de demanda
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pk_credito,
  -- Par¿metros de Salida       : pf_asig: fecha de asiganacion, pc_abrev: iniciales del abogado
  --                              pf_deman: fecha de demanda
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 JAQM35PgCo fsr011.r1cod%type;
 JAQM35Mod  fsr011.R1mod%type;
 JAQM35Suc fsr011.R1suc%type;
 JAQM35Mda fsr011.R1mda%type;
 JAQM35Pap  fsr011.R1pap%type;
 JAQM35Cta fsr011.R1cta%type;
 JAQM35Oper fsr011.R1oper%type;
 JAQM35Sbop fsr011.R1sbop%type;
 JAQM35Tope  fsr011.R1tope%type;
 estado_cre fsd010.aostat%type;


 ln_Pgcod fsr011.r1cod%type;
 ln_R1mod  fsr011.R1mod%type;
 ln_R1suc fsr011.R1suc%type;
 ln_R1mda fsr011.R1mda%type;
 ln_R1pap  fsr011.R1pap%type;
 ln_R1cta fsr011.R1cta%type;
 ln_R1oper fsr011.R1oper%type;
 ln_R1sbop fsr011.R1sbop%type;
 ln_R1tope  fsr011.R1tope%type;



 ln_Pgcod2 fsr011.r2cod%type;
 ln_R2mod  fsr011.R2mod%type;
 ln_R2suc fsr011.R2suc%type;
 ln_R2mda fsr011.R2mda%type;
 ln_R2pap  fsr011.R2pap%type;
 ln_R2cta fsr011.R2cta%type;
 ln_R2oper fsr011.R2oper%type;
 ln_R2sbop fsr011.R2sbop%type;
 ln_R2tope  fsr011.R2tope%type;

instancia xwf700.XWFPRCINS%type;
begin
  pf_asig:=null;
  pc_abrev:=null;

   begin --fecha de asignacion/ abrev de abogado

      select distinct t.jaqm35tfec, s.jaqm34abr
       into pf_asig, pc_abrev
       from jaqm35 t
       left join jaqm34 s
       on  s.jaqm34cod = t.jaqm34cod
       where t.jaqm35pgco=pt_pgcod
       and t.jaqm35mda=pt_moneda
       and t.jaqm35pap=pt_papel
       and t.jaqm35cta=pt_cnta
       and t.jaqm35oper=pt_operac
       and t.jaqm35tcon='S'
       and (t.jaqm35corr,t.jaqm35sbop)in (
                 select max(t.jaqm35corr),max(t.jaqm35sbop)
                 from jaqm35 t
                 left join jaqm34 s
                 on  s.jaqm34cod = t.jaqm34cod
                 where t.jaqm35pgco=pt_pgcod
                 and t.jaqm35mda=pt_moneda
                 and t.jaqm35pap=pt_papel
                 and t.jaqm35cta=pt_cnta
                 and t.jaqm35oper=pt_operac
                  and t.jaqm35tcon='S'
         );

       exception
          WHEN TOO_MANY_ROWS THEN
            begin
              select t.jaqm35tfec, s.jaqm34abr
               into pf_asig, pc_abrev
               from jaqm35 t
               left join jaqm34 s
               on  s.jaqm34cod = t.jaqm34cod
               inner join fsd010 f
                   on  t.jaqm35pgco=f.pgcod
                   and t.jaqm35mod=f.aomod
                   and t.jaqm35suc=f.aosuc
                   and t.jaqm35mda=f.aomda
                   and t.jaqm35pap=f.aopap
                   and t.jaqm35cta=f.aocta
                   and t.jaqm35oper=f.aooper
                   and t.jaqm35sbop=f.aosbop
                   and t.jaqm35tope=f.aotope

               where t.jaqm35pgco=pt_pgcod
               and t.jaqm35mda=pt_moneda
               and t.jaqm35pap=pt_papel
               and t.jaqm35cta=pt_cnta
               and t.jaqm35oper=pt_operac
               and t.jaqm35tcon='S'
               and f.aostat<>99
               and (t.jaqm35corr,t.jaqm35sbop)in (
                         select max(t.jaqm35corr),max(t.jaqm35sbop)
                         from jaqm35 t
                         left join jaqm34 s
                         on  s.jaqm34cod = t.jaqm34cod
                         where t.jaqm35pgco=pt_pgcod
                         and t.jaqm35mda=pt_moneda
                         and t.jaqm35pap=pt_papel
                         and t.jaqm35cta=pt_cnta
                         and t.jaqm35oper=pt_operac
                          and t.jaqm35tcon='S'
                 );
                 exception
            when no_data_found then
              begin

                         select distinct t.jaqm35tfec, s.jaqm34abr
                           into pf_asig, pc_abrev
                             from jaqm35 t
                             left join jaqm34 s
                             on  s.jaqm34cod = t.jaqm34cod
                             inner join fsr011 f
                             on t.jaqm35pgco= f.r1cod
                             and t.jaqm35mod=f.r1mod
                             and t.jaqm35suc=f.r1suc
                             and t.jaqm35mda=f.r1mda
                             and t.jaqm35pap=f.r1pap
                             and t.jaqm35cta=f.r1cta
                             and t.jaqm35oper=f.r1oper
                             and t.jaqm35sbop=f.r1sbop
                             and t.jaqm35tope=f.r1tope
                             and t.jaqm35tcon='S'
                             where f.r1cod    =pt_pgcod
                                 and f.r2mod = pt_modu
                                and f.r2suc  = pt_sucu
                               and f.r2mda   = pt_moneda
                               and f.r2pap   = pt_papel
                               and r2cta     = pt_cnta
                               and r2oper    = pt_operac
                               and f.r2sbop  = pt_sboper
                               and f.r2tope  = pt_toper
                               and f.relcod  =33        ;
             exception
             when no_data_found then
                    begin
                         select distinct t.jaqm35tfec, s.jaqm34abr
                           into pf_asig, pc_abrev
                             from jaqm35 t
                             left join jaqm34 s
                             on  s.jaqm34cod = t.jaqm34cod
                             inner join fsr011 f
                             on t.jaqm35pgco= f.r1cod
                             and t.jaqm35mod=f.r1mod
                             and t.jaqm35suc=f.r1suc
                             and t.jaqm35mda=f.r1mda
                             and t.jaqm35pap=f.r1pap
                             and t.jaqm35cta=f.r1cta
                             and t.jaqm35oper=f.r1oper
                             and t.jaqm35sbop=f.r1sbop
                             and t.jaqm35tope=f.r1tope
                             and t.jaqm35tcon='S'
                             where f.r1cod    =pt_pgcod
                                and  f.r2mod  =pt_modu
                                and f.r2suc   =pt_sucu
                               and f.r2mda    =pt_moneda
                               and f.r2pap    =pt_papel
                               and r2cta      =pt_cnta
                               and r2oper     =pt_operac
                               and f.r2sbop   =pt_sboper
                               and f.r2tope   =pt_toper
                               and f.relcod=36 ;

                    EXCEPTION
                       when others then
                            lc_coderr := sqlcode;
                            lc_msgerr := sqlerrm;

                    end;

              when others then
                            lc_coderr := sqlcode;
                            lc_msgerr := sqlerrm;
              end;
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
            end;
          when no_data_found then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;
   end;

   --fecha demanda /pasaje a judicial
       If pt_modu <> 117 then
              BEGIN
                   select  m.jaqm33fint  --fecha de demanda
                     into pf_deman
                     from jaqm27 t
                     inner join jaqm33 m
                     on t.jaqm33cor=m.jaqm33cor
                     Where JAQM27Pgc  = pt_pgcod
                      and JAQM27Mod  =  pt_modu
                      and JAQM27Suc  =  pt_sucu
                      and JAQM27Mda  =  pt_moneda
                      and JAQM27Pap  =  pt_papel
                      and JAQM27Cta  =  pt_cnta
                      and JAQM27Oper =  pt_operac
                      and JAQM27Sbop =  pt_sboper
                      and JAQM27Tope =  pt_toper
                      and jaqm33fint<>to_date('01/01/0001','dd/mm/rrrr');
             exception
               when no_data_found then
                 begin
                     select distinct m.jaqm33fint --fecha de demanda
                     into pf_deman
                     from jaqm27 t
                     inner join jaqm33 m
                     on t.jaqm33cor=m.jaqm33cor
                      inner join fsr011 f
                      on JAQM27Pgc  = r1cod
                      and JAQM27Mod  =  r2mod
                      and JAQM27Suc  =  r2suc
                      and JAQM27Mda  =  r2mda
                      and JAQM27Pap  =  r2pap
                      and JAQM27Cta  =  r2cta
                      and JAQM27Oper =  r2oper
                      and JAQM27Sbop =  r2sbop
                      and JAQM27Tope =  r2tope
                      where relcod=34
                      and    r1mod   =  pt_modu
                      and    r1suc  =   pt_sucu
                      and    r1mda   =  pt_moneda
                      and    r1pap   =  pt_papel
                      and    r1cta   =  pt_cnta
                      and    r1oper  =  pt_operac
                      and    r1sbop  =  pt_sboper
                      and    r1tope   = pt_toper
                      and jaqm33fint<>to_date('01/01/0001','dd/mm/rrrr');
                 exception
                  when no_data_found then
                    begin
                        select distinct m.jaqm33fint  --fecha de demanda
                         into pf_deman
                         from jaqm27 t
                         inner join jaqm33 m
                         on t.jaqm33cor=m.jaqm33cor
                         Where JAQM27Pgc  = pt_pgcod
                          and JAQM27Mda  =  pt_moneda
                          and JAQM27Pap  =  pt_papel
                          and JAQM27Cta  =  pt_cnta
                          and JAQM27Oper =  pt_operac
                          and jaqm33fint<>to_date('01/01/0001','dd/mm/rrrr');
                      EXCEPTION
                       when others then
                            lc_coderr := sqlcode;
                            lc_msgerr := sqlerrm;

                    end;
                 when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
                 end;

              when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
             end;
       Else

            BEGIN
                  select r1cod,R1mod,R1suc,R1mda,R1pap,R1cta,R1oper,R1sbop,R1tope
                  into ln_Pgcod,ln_R1mod,ln_R1suc,ln_R1mda,ln_R1pap,ln_R1cta,ln_R1oper,ln_R1sbop,ln_R1tope
                  from (select r1cod,R1mod,
                               R1suc,R1mda,
                               R1pap,R1cta,
                               R1oper,R1sbop,
                               R1tope
                          from FSR011 f
                         inner join fsd010 f10 on f10.Pgcod = f.r1cod
                                              and f10.aomod = f.R1mod
                                              and f10.aosuc = f.R1suc
                                              and f10.aomda = f.R1mda
                                              and f10.aopap = f.R1pap
                                              and f10.aocta = f.R1cta
                                              and f10.aooper = f.R1oper
                                              and f10.aosbop = f.R1sbop
                                              and f10.aotope = f.R1tope
                         Where f.R2cod = pt_pgcod
                           and f.R2mod = pt_modu
                           and f.R2suc = pt_sucu
                           and f.R2mda = pt_moneda
                           and f.R2pap = pt_papel
                           and f.R2cta = pt_cnta
                           and f.R2oper = pt_operac
                           and f.R2sbop = pt_sboper
                           and f.R2tope = pt_toper
                           and f.Relcod = 46
                           and f.R011co = 'S'
                           and f.r1mod = 200
                         order by R2cod,R2mod,R2suc,R2mda,R2pap,R2cta,R2oper,R2sbop,R2tope,Relcod asc) ff
                 where rownum = 1;

       exception
              when no_data_found then
                   begin
                        select r1cod,R1mod,R1suc,R1mda,R1pap,R1cta,R1oper,R1sbop,R1tope
                        into ln_Pgcod,ln_R1mod,ln_R1suc,ln_R1mda,ln_R1pap,ln_R1cta,ln_R1oper,ln_R1sbop,ln_R1tope
                        from (select r1cod,
                                     R1mod,
                                     R1suc,
                                     R1mda,
                                     R1pap,
                                     R1cta,
                                     R1oper,
                                     R1sbop,
                                     R1tope
                                from FSR011 f
                               inner join fsd010 f10 on f10.Pgcod = f.r1cod
                                                    and f10.aomod = f.R1mod
                                                    and f10.aosuc = f.R1suc
                                                    and f10.aomda = f.R1mda
                                                    and f10.aopap = f.R1pap
                                                    and f10.aocta = f.R1cta
                                                    and f10.aooper = f.R1oper
                                                    and f10.aosbop = f.R1sbop
                                                    and f10.aotope = f.R1tope
                               Where f.R2cod = pt_pgcod
                                 and f.R2mod = pt_modu
                                 and f.R2suc = pt_sucu
                                 and f.R2mda = pt_moneda
                                 and f.R2pap = pt_papel
                                 and f.R2cta = pt_cnta
                                 and f.R2oper = pt_operac
                                 and f.R2sbop = pt_sboper
                                 and f.R2tope = pt_toper
                                 and f.Relcod = 46
                                 and f.R011co = 'S'
                                 and f.r1mod<>200
                               order by R2cod,R2mod,R2suc,R2mda,R2pap,R2cta,R2oper,R2sbop,R2tope,Relcod desc) ff
                            where rownum = 1;
                    exception
                    when no_data_found then
                        BEGIN
                           select XWFPRCINS
                           into instancia
                           from XWF700
                           Where XWfEmpresa = pt_pgcod
                              and  XWfSucursal =  pt_modu
                              and XWfModulo    =  pt_sucu
                              and XWfMoneda    =  pt_moneda
                              and XWfPapel     =  pt_papel
                              and XWfCuenta    =  pt_cnta
                              and XWfOperacion =  pt_operac
                              and XWfSubope    =  pt_sboper
                              and XWfTipOpe    =  pt_toper
                               and XWFCar3      = 'A';
                         BEGIN
                             select R1mod , R1suc,R1mda , R1pap ,R1cta , R1oper, R1sbop,R1tope
                                 into
                                 ln_R1mod,ln_R1suc,ln_R1mda,ln_R1pap,ln_R1cta,ln_R1oper,ln_R1sbop,ln_R1tope
                             from
                             (select  R1mod , R1suc,R1mda , R1pap ,R1cta , R1oper, R1sbop,R1tope
                              from XWF700 x
                              inner join FSR011 f
                              on  R2cod  = x.xwfempresa
                                   and  R2mod  =  XWfModulo
                                   and  R2suc  =  XWfSucursal
                                   and  R2mda  =  XWfMoneda
                                   and  R2pap  =  XWfPapel
                                   and  R2cta  =  XWfCuenta
                                   and  R2oper =  XWfOperacion
                                   and  R2sbop =  XWfSubope
                                   and  R2tope =  XWfTipOpe
                              Where f.Relcod = 46
                              and  f.R011co = 'S'
                              and  x.XWFCar3   = '1'
                              and  x.XWFPRCINS=instancia
                              and f.r1mod=200
                              order by R2cod, R2mod, R2suc, R2mda, R2pap, R2cta, R2oper, R2sbop, R2tope, Relcod)
                              where rownum=1;
                          EXCEPTION
                          WHEN no_data_found THEN
                               BEGIN
                               select R1mod , R1suc,R1mda , R1pap ,R1cta , R1oper, R1sbop,R1tope
                               into
                               ln_R1mod,ln_R1suc,ln_R1mda,ln_R1pap,ln_R1cta,ln_R1oper,ln_R1sbop,ln_R1tope
                               from
                               (select R1mod , R1suc,R1mda , R1pap ,R1cta , R1oper, R1sbop,R1tope
                                from XWF700 x
                                inner join FSR011 f
                                on  R2cod  = x.xwfempresa
                                     and  R2mod  =  XWfModulo
                                     and  R2suc  =  XWfSucursal
                                     and  R2mda  =  XWfMoneda
                                     and  R2pap  =  XWfPapel
                                     and  R2cta  =  XWfCuenta
                                     and  R2oper =  XWfOperacion
                                     and  R2sbop =  XWfSubope
                                     and  R2tope =  XWfTipOpe
                                Where f.Relcod = 46
                                and  f.R011co = 'S'
                                and  x.XWFCar3   = '1'
                                and  x.XWFPRCINS=instancia
                                and f.r1mod<>200
                                order by R2cod, R2mod, R2suc, R2mda, R2pap, R2cta, R2oper, R2sbop, R2tope, Relcod desc)
                                where rownum=1;
                                EXCEPTION
                                   when others then
                                        lc_coderr := sqlcode;
                                         lc_msgerr := sqlerrm;

                                END;
                          END;

                        EXCEPTION
                         when others then
                          lc_coderr := sqlcode;
                          lc_msgerr := sqlerrm;
                        END;
                    when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;


                    END;
               when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
              END;

              BEGIN
                select  m.jaqm33fint --fecha de demanda
                 into pf_deman
                 from jaqm27 t
                 inner join jaqm33 m
                 on t.jaqm33cor=m.jaqm33cor
                Where JAQM27Pgc  = ln_Pgcod
                  and JAQM27Mod  =   ln_R1mod
                  and JAQM27Suc  =   ln_R1suc
                  and JAQM27Mda  =   ln_R1mda
                  and JAQM27Pap  =   ln_R1pap
                  and JAQM27Cta  =  ln_R1cta
                  and JAQM27Oper =   ln_R1oper;

              exception
              when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
             end;
        End if;
        Begin
                select max(sng419fect) into pf_trancart
                  from sng419 s
                 where s.sng419acc = 4
                   and s.sng419cta = pt_cnta
                   and s.sng419ope = pt_operac;
        EXCEPTION
         when others then
           lc_coderr := sqlcode;
           lc_msgerr := sqlerrm;
        End ;
end sp_cr_abog_dmda;

---------------------------------------------------------------------
Procedure sp_cr_montos_amort( pn_ITSUC in number,
                             pn_ITMOD  in number,
                             pn_ITTRAN in  number,
                             pn_ITNREL in number,
                             pn_capital in out number,
                             pn_interes   in out number,
                             pn_int_comp_extra in out number,
                             pn_mora   in out number,
                             pn_seguros  in out number,
                             pn_rub_obli  in out number,
                             pn_gastos  in out number,
                             pn_ITF  in out number)

is
--******************************************************************************************************
  -- Nombre                     : sp_cr_montos_amort
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.03.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Retorna  los montos a los conceptos dados
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : trailer: pn_ITSUC,pn_ITMOD,pn_ITTRAN,pn_ITNREL
  -- Par¿metros de Salida       :  pn_interes   ,pn_int_comp_extra,pn_mora,pn_seguros,pn_rub_obli,pn_gastos,pn_ITF
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 monto_pago number:=0;
begin

    begin
             select h.itimp1 into pn_ITF
            from
            fsd016 h
            where h.itsuc = pn_ITSUC
            and h.itmod = pn_ITMOD
            and h.ittran = pn_ITTRAN
            and h.itnrel = pn_ITNREL
            and h.rubro in ('2517050901001','2527050901001');
      exception
            when no_data_found then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
              pn_ITF:=0;
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
       end;

        If(pn_ITMOD=30 and (pn_ITTRAN=669 or pn_ITTRAN=670))THEN -- CASO FALLECIDOS
          begin
            select (select sum(h.itimp1) as monto
              from fsd016 h
             inner join fst198 f
             on h.itmod = f.tp1corr1
               and h.ittran = f.tp1corr2
                and h.itord = f.tp1imp1 -- f.tp1corr3 --062017
             where itmod =  pn_ITMOD
               and itsuc = pn_ITSUC
               and ittran =  pn_ITTRAN
               and itnrel =  pn_ITNREL
               and f.tp1cod1=10876
                and h.itmod<>999999) - (select itimp1 as monto
                                       from fsd016
                                      where itmod =  pn_ITMOD
                                        and itsuc = pn_ITSUC
                                        and ittran =  pn_ITTRAN
                                        and itnrel =  pn_ITNREL
                                        and itord = 56)
              into monto_pago
              from dual;

           IF(monto_pago<pn_ITF and  monto_pago>0 and pn_ITF>0) then
                     pn_ITF:=monto_pago;
                     pn_capital :=0;
                     pn_seguros:=0;
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
            end if;
           monto_pago:=monto_pago-pn_ITF;
            if(monto_pago<=0) then
                     pn_capital :=0;
                     pn_seguros:=0;
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
           end if ;

           if(monto_pago<pn_capital and monto_pago>0 ) then
                     pn_capital :=monto_pago;
                     pn_seguros:=0;
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
            end if;
             monto_pago:=monto_pago-pn_capital;
           if(monto_pago<=0) then
                     pn_seguros:=0;
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
           end if ;


           IF(monto_pago<pn_seguros and  monto_pago>0 and pn_seguros>0) then
                     pn_seguros :=monto_pago;
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
           End if;
           monto_pago:=monto_pago-pn_seguros;
           if(monto_pago<=0) then
                     pn_gastos:=0;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
           end if ;


           IF(monto_pago<pn_gastos and monto_pago>0 and pn_gastos>0) then
                     pn_gastos :=monto_pago;
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
          End if;
            monto_pago:=monto_pago-pn_gastos;
           if(monto_pago<=0) then
                     pn_rub_obli:=0;
                     pn_mora:=0;
                     pn_int_comp_extra:=0;
                     pn_interes:=0;
           end if ;


           IF(monto_pago<pn_rub_obli and monto_pago>0 and pn_rub_obli>0) then
                         pn_rub_obli :=monto_pago;
                         pn_mora:=0;
                         pn_int_comp_extra:=0;
                         pn_interes:=0;
            End if;
            monto_pago:=monto_pago-pn_rub_obli;
            if(monto_pago<=0) then
                         pn_mora:=0;
                         pn_int_comp_extra:=0;
                         pn_interes:=0;
           end if ;


           IF(monto_pago<pn_mora and monto_pago>0 and pn_mora>0) then
                           pn_mora :=monto_pago;
                           pn_int_comp_extra:=0;
                           pn_interes:=0;
           End if;
           monto_pago:=monto_pago-pn_mora;
           if(monto_pago<=0) then
                           pn_int_comp_extra:=0;
                           pn_interes:=0;
           end if ;


           IF(monto_pago<pn_int_comp_extra and monto_pago>0 and pn_int_comp_extra>0 ) then
                           pn_int_comp_extra :=monto_pago;
                           pn_interes:=0;
            End if;
            monto_pago:=monto_pago-pn_int_comp_extra;
           if(monto_pago<=0) then
                           pn_interes:=0;
           end if ;


            IF(monto_pago<pn_interes  and monto_pago>0 and pn_interes>0) then
                         pn_interes :=monto_pago;
             End if;

             monto_pago:=monto_pago-pn_interes;
             if(monto_pago<=0) then
               monto_pago:=0;
             end if ;

       exception
              when others then
                      lc_coderr := sqlcode;
                      lc_msgerr := sqlerrm;
         end;
      End if;
  exception
        when no_data_found then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;

end sp_cr_montos_amort;
-----------------------------------------------------------------------
Function fn_pago_valido(pt_pgcod in number,
                     pt_suc in number,
                     pt_mod in number,
                     pt_moneda in number,
                     pt_papel in number ,
                     pt_cnta in number,
                     pt_operac in number,
                     pt_sboper in number,
                     pt_toper in number,
                     pn_ITSUC  in number,
                     pn_ITMOD  in number,
                     pn_ITTRAN in number,
                     pn_ITNREL in number,
                     pn_stat in number)
                            return number
--******************************************************************************************************
  -- Nombre                     : fn_cr_cap_ingreso
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.03.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : retorna el capital de ingreso de un credito
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pk_credito
  -- Par¿metros de Salida       :ln_capingreso:capital de ingreso
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 ln_indicador number(5):=0;
 ln_estranjud number(1):=0;
begin
 select count(*) into ln_estranjud 
   from fst198
   where tp1cod = 1
   and tp1cod1 =11167
   and tp1corr1 = 1
   and tp1corr2 = 1
   and tp1nro1 = pn_ITMOD
   and tp1nro2 = pn_ITTRAN;
 
 --If((pn_ITMOD=30 and pn_ITTRAN in (395,397,401,403,407,408,669,670,396)) or (pn_ITMOD=98 and pn_ITTRAN in (303)))then  --11/01/2021 kdvc se ha agregado la 396
 if ( ln_estranjud > 0 ) then--kvalenciac 19/12/2022 si es una transacción de judicial que está ingresada en la guía 11167 automática se considera
  ln_indicador:=1;
 else
      if(pn_stat in (21,22,33,34,23,64,90)) then   --11/01/2021 kdvc se ha agregado estado 23, 64, 90
               ln_indicador:=1;
      else
              if( pn_stat=99) then
                      begin
                             select 1
                               into ln_indicador --REFINANCIADO JUDICIAL
                               from dual
                              where exists (select *
                                       from  fsr011 r
                                      inner join fst111 t on t.modulo = pt_mod
                                      where r.r2cod = pt_pgcod
                                        and r.r2mod = pt_mod
                                        and r.r2suc = pt_suc
                                        and r.r2mda = pt_moneda
                                        and r.r2pap = pt_papel
                                        and r.r2cta = pt_cnta
                                        and r.r2oper = pt_operac
                                        and r.r2sbop = pt_sboper
                                        and r.r2tope = pt_toper
                                        and pt_sboper > 0
                                        and r.relcod = 35
                                        and r.r011co = 'S'
                                        and t.dscod = 50);

                       exception
                              when no_data_found then
                               begin
                                        select 1
                                          into ln_indicador --PJ DEMANDA /PJ ABOGADO
                                          from dual
                                         where exists (select *
                                                  from fsr011 r
                                                 inner join fst111 t on r.r1mod = pt_mod
                                                 where r.r1cod = pt_pgcod
                                                   and r.r1mod = pt_mod
                                                   and r.r1suc = pt_suc
                                                   and r.r1mda = pt_moneda
                                                   and r.r1pap = pt_papel
                                                   and r.r1cta = pt_cnta
                                                   and r.r1oper = pt_operac
                                                   and r.r1sbop = pt_sboper
                                                   and r.r1tope = pt_toper
                                                   and pt_mod in
                                                       (101, 102, 103, 104, 105, 106, 107, 109, 110, 111, 112, 113, 114, 115, 116)
                                                   and pt_toper = 550
                                                   and r.relcod <> 34
                                                   and r.r011co = 'S'
                                                   and t.dscod = 50);
                                 exception
                                       when no_data_found then
                                            begin
                                                 select 1 --
                                                   into ln_indicador
                                                   from dual
                                                  where exists
                                                  (select *
                                                           from sng410 s
                                                          where s.sng400evto in (1110, 1101)
                                                            and s.sng410cta = pt_cnta
                                                            and s.sng410op = pt_operac);

                                              exception
                                              when no_data_found then
                                                  ln_indicador:=0;
                                              when others then
                                                      lc_coderr := sqlcode;
                                                      lc_msgerr := sqlerrm;

                                            end;
                                      when others then
                                        lc_coderr := sqlcode;
                                        lc_msgerr := sqlerrm;

                                 end;
                              when others then
                                lc_coderr := sqlcode;
                                lc_msgerr := sqlerrm;

                       end;
              end if;
         end if;
    end if;
return ln_indicador;
end fn_pago_valido;
------------------------------------------------------------------------
Procedure sp_cr_obtiene_pk(pt_pgcod in number,
                           pt_modt in number,
                           pt_tran in number,
                           pt_suct in number,
                           pt_rel in number,
                           pt_suc out number,
                           pt_mod out number,
                           pt_moneda  out number,
                           pt_papel  out number ,
                           pt_cnta in out number,
                           pt_operac in out number,
                           pt_sboper out number,
                           pt_toper out number,
                           pt_fecpag in date)

is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 ln_indicador number(5):=1;
 ln_tp1imp1 number(3);
 ln_tp1imp2 number(3);
begin

   if(pt_modt=30 and pt_tran in (395,397)) then
    begin
     select distinct AOMOD,
            AOSUC,
            AOMDA,
            AOPAP,
            AOCTA,
            AOOPER,
            AOSBOP,
            AOTOPE
          into
            pt_mod,
            pt_suc,
            pt_moneda,
            pt_papel,
            pt_cnta,
            pt_operac,
            pt_sboper,
            pt_toper
       from fsd010
      where aocta = pt_cnta
        and aooper = pt_operac
        and aotope = 550;
     exception
         when others THEN
                  ln_indicador:=0;
     end;
   end if;
   if((pt_modt=30 and pt_tran in (407,408,403,401)) or (pt_modt=98 and pt_tran in (303))) then
    begin
           select  distinct JAQL166SCMOD,
                  JAQL166SCSUC,
                  JAQL166SCMDA,
                  JAQL166SCPAP,
                  JAQL166SCCTA,
                  JAQL166SCOPE,
                  JAQL166SCSBO,
                  JAQL166SCTOP
                  into
                    pt_mod,
                    pt_suc,
                    pt_moneda,
                    pt_papel,
                    pt_cnta,
                    pt_operac,
                    pt_sboper,
                    pt_toper
             from jaql166
            where d166mo = pt_modt
              and d166tr = pt_tran
              and d166su = pt_suct
              and d166re = pt_rel
              and jaql166fpga= pt_fecpag;
     exception
         when others THEN
                  ln_indicador:=0;
     end;
   else
     begin
             select distinct  PPSUC,
                    PPMOD,
                    PPMDA,
                    PPPAP,
                    PPCTA,
                    PPOPER,
                    PPSBOP,
                    PPTOPE
                    into
                      pt_suc,
                      pt_mod,
                      pt_moneda,
                      pt_papel,
                      pt_cnta,
                      pt_operac,
                      pt_sboper,
                      pt_toper
             from fsd602
             where d602mo =  pt_modt
             and d602tr  =   pt_tran
             and d602su  =   pt_suct
             and d602re  =   pt_rel
             and d602fc = pt_fecpag;
       exception
         when others THEN
             -- ln_indicador:=0; --comentado 20/12/2022 kvalenciac
             --inicio 20/12/2022 kvalenciac
             --busco el ordinal de donde buscará la clave del crédito
             ln_tp1imp1 :=0;
             ln_tp1imp2 :=0;
             begin 
               select tp1imp1, tp1imp2 into ln_tp1imp1, ln_tp1imp2 from fst198 
               where tp1cod=1 
               and tp1cod1=11123 
               and tp1corr1=10 
               and tp1corr2=4
               and TP1nro1=pt_modt
               and TP1nro2=pt_tran;--TP1nro1-> modulo y TP1nro2-> transacción  
             exception
             when others then
                begin
                    select tp1nro1, tp1nro2 into ln_tp1imp1, ln_tp1imp2 from fst198 
                     where tp1cod=1 
                     and tp1cod1=11123 
                     and tp1corr1=9 
                     and tp1corr2=1
                     and TP1imp1=pt_modt
                     and TP1imp2=pt_tran;--TP1nro1-> modulo y TP1nro2-> transacción 
                 exception
                 when others then
                    ln_tp1imp1 :=10;
                 end;
             end;
             if (ln_tp1imp1>0 or ln_tp1imp2>0) then
               begin 
                 select Itsucd,
                        Modulo,
                        Moneda, 
                        Papel,
                        Ctnro,
                        Itoper,
                        Itsubo,
                        Ittope           
                    into
                      pt_suc,
                      pt_mod,
                      pt_moneda,
                      pt_papel,
                      pt_cnta,
                      pt_operac,
                      pt_sboper,
                      pt_toper
                   from fsd016
                   where itsuc = pt_suct
                   and itmod  = pt_modt
                   and ittran = pt_tran
                   and itnrel = pt_rel
                   and itord  = ln_tp1imp1;
                  exception
                    when others then
                      begin
                       select Itsucd,
                        Modulo,
                        Moneda, 
                        Papel,
                        Ctnro,
                        Itoper,
                        Itsubo,
                        Ittope           
                      into
                        pt_suc,
                        pt_mod,
                        pt_moneda,
                        pt_papel,
                        pt_cnta,
                        pt_operac,
                        pt_sboper,
                        pt_toper
                       from fsd016
                       where itsuc = pt_suct
                       and itmod  = pt_modt
                       and ittran = pt_tran
                       and itnrel = pt_rel
                       and itord  = ln_tp1imp2;
                      exception 
                        when others then
                          ln_indicador:=0;
                      end;
                  end;
             end if;
     end;
   end if;
end sp_cr_obtiene_pk;
------------------------------------------------------------------------
Procedure sp_cr_cred_amort_CV(pn_suc IN number,pd_fecproc IN date)
is
  -- ******************************************************************************************************
  -- Nombre                     : sp_cr_cred_amort_CV
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Reporte de amortizaciones de cartera vigente
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : pd_fecproc:fecha de proceso
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
    cursor c_cart_cred_act is

      select distinct h.pgcod,
               h.moneda ,
               h.papel ,
               h.ctnro ,
               h.itoper ,
               h.itmod,
               h.ittran,
               h.itsuc,
               h.itnrel
          from fsd016 h
         inner join fst198 g on h.itmod = g.tp1corr1
                            and h.ittran = g.tp1corr2
                            and h.itord = g.tp1imp1 --  062017 --and h.itord = g.tp1corr3
                            and g.tp1cod = 1
                            and g.tp1cod1 = 10876
                            and g.tp1corr1 <> 999999
         inner join fsd015 f on f.pgcod = h.pgcod
                            and f.itsuc = h.itsuc
                            and f.itmod = h.itmod
                            and f.ittran = h.ittran
                            and f.itnrel = h.itnrel
                            and f.itsuc=pn_suc
         where f.itcont = 'S'
           and f.itcorr = 0;

     cursor transaccion(p_pgcod in number, p_itmod in number,p_ittran in number,p_itsuc in number,p_itnrel in number)
      is
         select f_pag,itmod,ittran,itsuc,itnrel,
        sum(decode(tp1nro1,1,(monto/cont) ,0 ))  capital,
        sum(decode(tp1nro1,2,(monto/cont),0 )) interes,
        sum(decode(tp1nro3,1,decode(tp1nro1,3,(monto/cont),0 ),4,decode(tp1nro1,3,(monto4/cont),0 ),12,decode(tp1nro1,3,(monto12/cont),0 ))) int_comp_extra, -- 062017 -- sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,--ICV        
        sum(decode(tp1nro3,1,decode(tp1nro1,4,(monto/cont),0),4,decode(tp1nro1,4,(monto4/cont),0),12,decode(tp1nro1,4,(monto12/cont),0 ))) mora,   --062017 -- sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
        sum(decode(tp1nro1,5,(monto/cont),0 )) seguros,
        sum(decode(tp1nro1,6,(monto/cont),0 )) rub_obli,
        sum(decode(tp1nro1,7,(monto/cont),0 )) gastos
        from
        (select g.tp1nro1,h.itmod,g.tp1nro3,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,-- 062017 (select g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto, sum(h.itimp4) monto4, sum(h.itimp12) monto12,count(*) cont --062017 se adiciono suma de impuestos --sum(h.itimp1) monto,count(*) cont
        from
        fsd016 h
        inner join fst198 g
        on  h.itmod=g.tp1corr1
        and h.ittran=g.tp1corr2
         and h.itord=g.tp1imp1 --  062017--and h.itord=g.tp1corr3
        and g.tp1cod=1
        and g.tp1cod1=10876
        and g.tp1corr1<>999999
        inner join fsd015 f
        on  f.pgcod=h.pgcod
        and f.itsuc=h.itsuc
        and f.itmod=h.itmod
        and f.ittran=h.ittran
        and f.itnrel=h.itnrel

        where f.pgcod=p_pgcod
        and f.itmod=p_itmod
        and f.ittran=p_ittran
        and f.itsuc=p_itsuc
        and f.itnrel=p_itnrel

        and f.itcont='S'
        and f.itcorr=0
        and h.itanu ='N'  --19/12/2022 kvalenciac
        group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1nro3  )--062017 --group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
        group by f_pag,itmod,ittran,itsuc,itnrel;

 ld_fecasig date;
 ld_fdemand date;
 lc_abrev varchar2(5);
 ln_capingreso number(17,2);
 lc_desctran varchar2(30) ;
 ln_corr number(18);
 ln_pais number(3);     --pais
 ln_tdoc number(2);     --tipo doc
 lc_ndoc varchar2(12);  --nro doc

 lc_nomtit fsd001.penom%type;      --nombre titular
 lc_dirtit sngc13.sngc13dir%type;   --direccion titular
 lc_reftit sngc13.sngc13ref1%type;  --referencia titular
 lc_distit fst071.fst071dsc%type;   --ditrito titular

 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);
 lc_descsuc  varchar2(30);
 pl_pgcod fsd601.pgcod%type;
 pl_scsuc fsd601.ppsuc%type;
 pl_scmod fsd601.ppmod%type;
 pl_scmda fsd601.ppmda%type;
 pl_scpap fsd601.pppap%type;
 pl_sccta fsd601.ppcta%type;
 pl_scoper fsd601.ppoper%type;
 pl_scsbop fsd601.ppsbop%type;
 pl_sctope fsd601.pptope%type;
 fpag date;
 ln_capital number(17,2);
 ln_interes number(17,2);
 ln_int_comp_extra number(17,2);
 ln_mora number(17,2);
 ln_rub_obli number(17,2);
 ln_gastos number(17,2);
 ln_seguros number(17,2);

 ITF number(17,2);
 ln_stat number(2,0);
 ln_dat number(4,0);
 pf_pasajud date;
 pf_trancart date;
 ln_valido number(5,0);
begin

 FOR c in c_cart_cred_act LOOP

     for y in transaccion(c.pgcod,c.itmod,c.ittran,c.itsuc,c.itnrel ) loop
         pl_scsuc:=null;
         pl_scmod:=null;
         pl_scmda:=null;
         pl_scpap:=null;
         pl_sccta:=c.ctnro;
         pl_scoper:=c.itoper;
         pl_scsbop:=null;
         pl_sctope:=null;

         pl_sccta:=c.ctnro;
         pl_scoper:=c.itoper;

       pq_cr_rep_recuperacion_legal.sp_cr_obtiene_pk( pt_pgcod => c.pgcod,
                                                      pt_modt => c.itmod,
                                                      pt_tran => c.ittran,
                                                      pt_suct => c.itsuc,
                                                      pt_rel => c.itnrel,
                                                      pt_suc =>    pl_scsuc,
                                                      pt_mod =>    pl_scmod,
                                                      pt_moneda => pl_scmda,
                                                      pt_papel =>  pl_scpap,
                                                      pt_cnta =>   pl_sccta,
                                                      pt_operac => pl_scoper,
                                                      pt_sboper => pl_scsbop,
                                                      pt_toper =>  pl_sctope,
                                                      pt_fecpag=>y.f_pag);

       fpag := y.f_pag;
      pq_cr_rep_recuperacion_legal.sp_cr_mod_est_act(pt_fecpag =>fpag ,
                                                     pt_pgcod =>  c.pgcod,
                                                     pt_suc =>    pl_scsuc,
                                                     pt_mod =>    pl_scmod,
                                                     pt_moneda => pl_scmda,
                                                     pt_papel =>  pl_scpap,
                                                     pt_cnta =>   pl_sccta,
                                                     pt_operac => pl_scoper,
                                                     pt_sboper => pl_scsbop,
                                                     pt_toper =>  pl_sctope,
                                                     estado => ln_stat,
                                                     pt_datraso => ln_dat,
                                                     pn_ITSUC =>y.itsuc,
                                                     pn_ITMOD =>y.itmod,
                                                     pn_ITTRAN =>y.ittran,
                                                     pn_ITNREL=>y.itnrel);

      ln_valido:=pq_cr_rep_recuperacion_legal.fn_pago_valido(pt_pgcod => c.pgcod,
                                                         pt_suc => pl_scsuc,
                                                         pt_mod => pl_scmod,
                                                         pt_moneda => pl_scmda,
                                                         pt_papel => pl_scpap,
                                                         pt_cnta => pl_sccta,
                                                         pt_operac => pl_scoper,
                                                         pt_sboper => pl_scsbop,
                                                         pt_toper => pl_sctope,
                                                         pn_itsuc => y.itsuc,
                                                         pn_itmod => y.itmod,
                                                         pn_ittran => y.ittran,
                                                         pn_itnrel => y.itnrel,
                                                         pn_stat => ln_stat);

      IF (ln_valido=1 )--and pl_scsuc<>null and pl_scmod<>null and pl_scsbop<>null and pl_sctope<>null )
      THEN
      ln_capital  :=y.capital;
      ln_interes  :=y.interes;
      ln_int_comp_extra :=y.int_comp_extra;
      ln_mora     :=y.mora;
      ln_rub_obli :=y.rub_obli;
      ln_gastos   := y.gastos;
      ln_seguros  := y.seguros;


                pq_cr_rep_recuperacion_legal.sp_cr_montos_amort(pn_itsuc => y.itsuc,
                                                            pn_itmod => y.itmod,
                                                            pn_ittran => y.ittran,
                                                            pn_itnrel => y.itnrel,
                                                            pn_capital=> ln_capital,
                                                            pn_interes => ln_interes,
                                                            pn_int_comp_extra => ln_int_comp_extra,
                                                            pn_mora => ln_mora,
                                                            pn_seguros => ln_seguros,
                                                            pn_rub_obli => ln_rub_obli,
                                                            pn_gastos => ln_gastos,
                                                            pn_itf => ITF);

               pq_cr_rep_recuperacion_legal.sp_cr_abog_dmda(pt_pgcod =>   c.pgcod,
                                                             pt_modu =>    pl_scmod,
                                                             pt_sucu =>    pl_scsuc,
                                                             pt_moneda =>  pl_scmda,
                                                             pt_papel =>   pl_scpap,
                                                             pt_cnta =>    pl_sccta,
                                                             pt_operac =>  pl_scoper,
                                                             pt_sboper =>  pl_scsbop,
                                                             pt_toper =>   pl_sctope,
                                                             pn_scstat => ln_stat,
                                                             pf_asig => ld_fecasig,
                                                             pc_abrev => lc_abrev,
                                                             pf_deman => ld_fdemand,
                                                             pf_pasajud=> pf_pasajud,
                                                             pf_trancart=>  pf_trancart);

              ln_capingreso := pq_cr_rep_recuperacion_legal.fn_cr_cap_ingreso(pt_pgcod => c.pgcod,
                                                                              pt_cnta =>   pl_sccta,
                                                                              pt_operac => pl_sctope);

              lc_desctran := pq_cr_rep_recuperacion_legal.fn_cr_desc_trans(pt_pgcod => c.pgcod,
                                                                     itmod => y.itmod,
                                                                     ittran => y.ittran);

               pq_cr_rep_recuperacion_legal.sp_cr_datos_titular(pn_pgcod => c.pgcod,
                                                                 pn_cta => pl_sccta,
                                                                 pn_pais => ln_pais,
                                                                 pn_petdoc => ln_tdoc,
                                                                 pn_pendoc => lc_ndoc,
                                                                 pc_nomtit => lc_nomtit,
                                                                 pc_dirtit => lc_dirtit,
                                                                 pc_reftit => lc_reftit,
                                                                 pc_distit => lc_distit);
                 lc_descsuc := pq_cr_rep_recuperacion_legal.fn_cr_desc_sucursal(pn_pgcod =>  c.pgcod,
                                                                            pn_succod => pl_scsuc);


                begin
                --genera el correlativo
                       select nvl(max(t.JAQY711CORR),0) + 1
                         into ln_corr
                         from jaqy711 t
                        where JAQY711COD=c.pgcod
                          and JAQY711MOD=pl_scmod
                          and JAQY711SUC=pl_scsuc
                          and JAQY711MDA=pl_scmda
                          and JAQY711PAP=pl_scpap
                          and JAQY711CTA=pl_sccta
                          and JAQY711OPE=pl_scoper
                          and JAQY711SBO=pl_scsbop
                          and JAQY711TOP=pl_sctope
                          and JAQY711FPAG=pd_fecproc;

                          insert into jaqy711(
                           JAQY711CORR,   --ln_corr,
                            JAQY711COD,   --c.pgcod,
                            JAQY711MOD,   --c.scmod,
                            JAQY711SUC,   --c.scsuc,
                            JAQY711MDA,   --c.scmda,
                            JAQY711PAP,   --c.scpap,
                            JAQY711CTA,   --c.sccta,
                            JAQY711OPE,   --c.scoper,
                            JAQY711SBO,   --c.scsbop,
                            JAQY711TOP,   --c.sctope,
                            JAQY711FPAG,  --pd_fecproc,
                            JAQY711TMOD,  --itmod,
                            JAQY711TTRAN, --ittran,
                            JAQY711NTRA,  --lc_desctran,
                            JAQY711NAGE,  --lc_descsuc,
                            JAQY711PAI,   --ln_pais,
                            JAQY711TDC,   --ln_tdoc,
                            JAQY711NDC,   --lc_ndoc,
                            JAQY711NCLI , --lc_nomtit,
                            JAQY711FDE,   --ld_fdemand,
                            JAQY711FASI , --ld_fecasig,
                            JAQY711CIN,   --ln_capingreso,
                            JAQY711MPA,   --capital+interes+int_comp_extra+mora+rub_obli+gastos,
                            JAQY711CAP,   --capital,
                            JAQY711INT,   --interes,
                            JAQY711ICOM,  --int_comp_extra,
                            JAQY711MOR,   --mora,
                            JAQY711ROB,   --rub_obli,
                            JAQY711GAS,   --gastos,
                            JAQY711ITF,   --ITF,
                            JAQY711ABO,   --lc_abrev,
                            JAQY711FPRO,
                            JAQY711NREL,
                            JAQY711TSUC,
                            jaqy711stat,
                            jaqy711dat,
                            jaqy711seg,
                            jaqy711ftc
                          ) values(
                              ln_corr,
                              c.pgcod,
                              pl_scmod,
                              pl_scsuc,
                              pl_scmda,
                              pl_scpap,
                              pl_sccta,
                              pl_scoper,
                              pl_scsbop,
                              pl_sctope,
                              fpag,--.f_pag,
                              y.itmod,
                              y.ittran,
                              lc_desctran,
                              lc_descsuc,
                              ln_pais,
                              ln_tdoc,
                              lc_ndoc,
                              lc_nomtit,
                              ld_fdemand,
                              ld_fecasig,
                              ln_capingreso,
                              ln_capital+ln_interes+ln_int_comp_extra+ln_mora+ln_rub_obli+ln_gastos+ITF+ln_seguros,
                              ln_capital,
                              ln_interes,
                              ln_int_comp_extra,
                              ln_mora,
                              ln_rub_obli,
                              ln_gastos,
                              ITF,
                              lc_abrev,
                              pd_fecproc,
                              y.itnrel,
                              y.itsuc,
                              ln_stat,
                              ln_dat,
                              ln_seguros,
                              pf_trancart
                          );
                commit;

           exception
                when no_data_found then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;

            end;
      END IF;
     end loop;
 END LOOP;

end;


-----------------------------------------------------------------------------------------------------------
procedure sp_inserta_jaqy711_job (pd_fecape IN date)
                                is
   lc_hostname varchar2(64);
   lc_feccar varchar2(10);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;

   cursor c_sucursales_job is
    select sucurs
         from fst001
        where ( sucurs < 800 or sucurs=904)--MAY 2017
          and pgcod = 1;
-- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy11_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Genera jobs para los distintos tipos de cartera
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  BEGIN

  begin
      select host_name
        into lc_hostname
        from v$instance;
    end;
    
     lc_feccar := to_char(pd_fecape,'RRRR.MM.DD');

      for job in c_sucursales_job loop

        lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_cred_amort_CV(to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_feccar||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
--                              instance => 2,
                              instance => 1,
                              force => false
                              );
else
     DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
                              force => false
                              );
end if;
              COMMIT;
      end loop;
       /* lc_variable := ' begin '||
        ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_cred_amort_CartCan('||
        'TO_DATE('''||lc_feccar||''',''RRRR.MM.DD''));'||
        ' End; ';

        ln_job := ln_job +1;
        DBMS_JOB.SUBMIT(job => ln_job,
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                       instance => 2,
                        force => false
                        );
        COMMIT;

       lc_variable := ' begin '||
        ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_cred_amort_CartJC('||
        'TO_DATE('''||lc_feccar||''',''RRRR.MM.DD''));'||
        ' End; ';

        ln_job := ln_job +1;
        DBMS_JOB.SUBMIT(job => ln_job,
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
                        force => false
                        );
         COMMIT;

       lc_variable := ' begin '||
        ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_cred_amort_CartPJAC('||
        'TO_DATE('''||lc_feccar||''',''RRRR.MM.DD''));'||
        ' End; ';

        ln_job := ln_job +1;
        DBMS_JOB.SUBMIT(job => ln_job,
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                       instance => 2,
                        force => false
                        );
        COMMIT;

       lc_variable := ' begin '||
        ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_cred_amort_CartRJC('||
        'TO_DATE('''||lc_feccar||''',''RRRR.MM.DD''));'||
        ' End; ';

        ln_job := ln_job +1;
        DBMS_JOB.SUBMIT(job => ln_job,
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
                        force => false
                        );
       COMMIT;*/
  end sp_inserta_jaqy711_job;
---------------------------------------------------
/*Procedure sp_cr_act_cap_ing(pn_suc in number,pt_fecpro in date)
is
   cursor c_fsh016 is select jaqy711cod,jaqy711cta,jaqy711ope,jaqy711suc,jaqy711fpro,h.hcimp1 --into ln_capingreso
     from fsh016 h
     inner join jaqy711 j
     on  h.hcmod = 300
     and h.htran =390
     and h.hcord=10
     and h.pgcod =j.jaqy711cod
     and h.hcta=j.jaqy711cta
     and h.hoper=j.jaqy711ope
     where j.jaqy711fpro=pt_fecpro
     and j.jaqy711suc=pn_suc;

begin
  FOR cc in c_fsh016 LOOP
       update  jaqy711 j set  JAQY711CIN=cc.hcimp1
        where j.jaqy711cta=cc.jaqy711cta
         and j.jaqy711ope=cc.jaqy711ope
         and j.jaqy711cod=cc.jaqy711cod
         and j.jaqy711fpro= cc.jaqy711fpro
         and j.jaqy711suc=cc.jaqy711suc;
         commit;
   END LOOP;

end sp_cr_act_cap_ing;
-----------------------------------------------------------------------
procedure sp_actualiza_jaqy711_job (pd_fecape IN date)
                                is

   lc_feccar varchar2(10);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;

   cursor c_sucursales_job is
    select sucurs
         from fst001
        where sucurs < 800
          and pgcod = 1;
-- ******************************************************************************************************
  -- Nombre                     : sp_inserta_jaqy11_job
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     :
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2014.02.05
  -- Autor de Creaci¿n          : SFERNANDEM
  -- Uso                        : Genera jobs para los distintos tipos de cartera
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Salida       :
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  --
  -- ********************************************************************************************************
  BEGIN

     lc_feccar := to_char(pd_fecape,'RRRR.MM.DD');

      for job in c_sucursales_job loop

        lc_variable := ' begin '||
              ' PQ_CR_REP_RECUPERACION_LEGAL.sp_cr_act_cap_ing(to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_feccar||''',''RRRR.MM.DD'')'||');'||
              ' End; ';

              ln_job := ln_job +1;
              DBMS_JOB.SUBMIT(job => ln_job,
                              what => lc_variable,
                              next_date => sysdate+1/(24*60),
                              interval => null,
                              no_parse => false,
                              instance => 2,
                              force => false
                              );
              COMMIT;
      end loop;
end sp_actualiza_jaqy711_job;*/
-----------------------------------------------------------------------
Procedure sp_cr_mod_est_act(pt_fecpag in out date,
                            pt_pgcod   in number,
                            pt_suc in number,
                            pt_mod in number,
                            pt_moneda in number,
                            pt_papel  in number,
                            pt_cnta   in number,
                            pt_operac in number,
                            pt_sboper in number,
                            pt_toper  in number,
                            estado out number,
                            pt_datraso out number,
                             pn_ITSUC in number,
                             pn_ITMOD  in number,
                             pn_ITTRAN in  number,
                             pn_ITNREL in number

                            )
is
 lc_coderr varchar2(500);
 lc_msgerr  varchar2(500);

fvto date;

 begin

    select  aostat, aofvto into estado,fvto
      from fsd010 f
     where f.pgcod=pt_pgcod
      and f.aomod=pt_mod
      and f.aosuc=pt_suc
      and f.aomda=pt_moneda
      and f.aopap=pt_papel
      and f.aocta = pt_cnta
      and f.aooper = pt_operac
      and f.aosbop=pt_sboper
      and f.aotope=pt_toper;


   begin
    select distinct pp1fech into pt_fecpag
    from fsd602 a
    where  a.pp1fech = pt_fecpag
      and a.d602mo = pn_ITMOD
      and a.d602su = pn_ITSUC
      and a.d602tr = pn_ITTRAN
      and a.d602re = pn_ITNREL ;
    exception
      when too_many_rows then
             begin
              select distinct  pp1fech into pt_fecpag
              from fsd602 a
              where a.pp1fech = pt_fecpag
                and a.d602mo = pn_ITMOD
                and a.d602su = pn_ITSUC
                and a.d602tr = pn_ITTRAN
                and a.d602re = pn_ITNREL
                and a.pp1stat='T';
            exception
              when no_data_found then
                 begin
                  select distinct pp1fech into pt_fecpag
                  from fsd602 a
                  where  a.pp1fech = pt_fecpag
                    and a.d602mo = pn_ITMOD
                    and a.d602su = pn_ITSUC
                    and a.d602tr = pn_ITTRAN
                    and a.d602re = pn_ITNREL
                    and a.pp1stat='P';
                  exception
                  when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
                  end;
             when others then
                    lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;
           end;
      when no_data_found then
        begin
         select distinct  pp1fech into pt_fecpag
         from fsd602 a
         where  a.d602fc = pt_fecpag
            and a.d602mo = pn_ITMOD
            and a.d602su = pn_ITSUC
            and a.d602tr = pn_ITTRAN
            and a.d602re = pn_ITNREL ;
      exception
            when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;

       end;
    end;

    if(estado=33) then
       begin
           SELECT nvl( max(b.pp1fech-a.ppfpag),0)
             into pt_datraso
              FROM FSD601 a
              left  join FSD602 b on b.Pgcod = a.Pgcod
                                and b.Ppmod = a.Ppmod
                                and b.Ppsuc = a.Ppsuc
                                and b.Ppmda = a.Ppmda
                                and b.Pppap = a.Pppap
                                and b.Ppcta = a.Ppcta
                                and b.Ppoper = a.Ppoper
                                and b.Ppsbop = a.Ppsbop
                                and b.Pptope = a.Pptope
                                and b.Ppfpag = a.Ppfpag
                                and b.Pptipo = a.Pptipo
                                 and b.Pp1stat in ( 'T','P')
                                and b.D602co = 'S'
                                and b.pp1fech = pt_fecpag
             where a.Pgcod = pt_pgcod
               and a.Ppmod =pt_mod
               and a.Ppsuc = pt_suc
               and a.Ppmda = pt_moneda
               and a.Pppap = pt_papel
               and a.Ppcta = pt_cnta
               and a.Ppoper = pt_operac
               and a.Ppsbop = pt_sboper
               and a.Pptope =pt_toper
               and a.Ppfpag <= pt_fecpag
               and a.D601co = 'S'
               and (a.ppcap + a.ppint) > 0
               and b.pp1fech-a.ppfpag>=0
               and b.pp1fech is not null
              and b.d602mo = pn_ITMOD
              and b.d602su = pn_ITSUC
              and b.d602tr = pn_ITTRAN
              and b.d602re = pn_ITNREL ;
         exception
            when no_data_found then
                 pt_datraso:=0;
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;

         end;
      end if;
 exception
          when no_data_found then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;

end sp_cr_mod_est_act;
-----------------------------------------------------------/
Procedure sp_cr_elimina_anul_repe(pt_fecpro in date)
is
  cursor   Cursor_repetidos is
       select JAQY711COD, JAQY711MOD, JAQY711SUC,JAQY711MDA, JAQY711PAP,JAQY711CTA,JAQY711OPE,JAQY711SBO, JAQY711TOP, JAQY711FPAG,
             JAQY711FPRO, JAQY711TMOD, JAQY711TTRAN,JAQY711NREL, JAQY711TSUC, JAQY711NTRA, JAQY711NAGE,JAQY711PAI,
             JAQY711TDC,JAQY711NDC,JAQY711NCLI, JAQY711FDE,  JAQY711FASI, JAQY711CIN, JAQY711MPA, JAQY711CAP, JAQY711INT,
             JAQY711ICOM, JAQY711MOR, JAQY711ROB,JAQY711GAS, JAQY711ITF,JAQY711ABO,JAQY711DAT, JAQY711STAT,min(JAQY711corr) as JAQY711CORR
            from jaqy711
        group by JAQY711COD, JAQY711MOD, JAQY711SUC,JAQY711MDA, JAQY711PAP,JAQY711CTA,JAQY711OPE,JAQY711SBO, JAQY711TOP, JAQY711FPAG,
             JAQY711FPRO, JAQY711TMOD, JAQY711TTRAN,JAQY711NREL, JAQY711TSUC, JAQY711NTRA, JAQY711NAGE,JAQY711PAI,
             JAQY711TDC,JAQY711NDC,JAQY711NCLI, JAQY711FDE,  JAQY711FASI, JAQY711CIN, JAQY711MPA, JAQY711CAP, JAQY711INT,
             JAQY711ICOM, JAQY711MOR, JAQY711ROB,JAQY711GAS, JAQY711ITF,JAQY711ABO,JAQY711DAT,  JAQY711STAT
             having count(*)>1;

begin
 FOR c in Cursor_repetidos LOOP
           delete  from jaqy711 f
            Where f.JAQY711COD =   c.JAQY711COD      and
                  f.JAQY711MOD =   c.JAQY711MOD      and
                  f.JAQY711SUC  =   c.JAQY711SUC     and
                  f.JAQY711MDA  =   c.JAQY711MDA     and
                  f.JAQY711PAP  =   c.JAQY711PAP     and
                  f.JAQY711CTA  =   c.JAQY711CTA     and
                  f.JAQY711OPE  =   c.JAQY711OPE     and
                  f.JAQY711SBO  =   c.JAQY711SBO     and
                  f.JAQY711TOP =   c.JAQY711TOP      and
                  f.JAQY711FPAG  =   c.JAQY711FPAG   and
                  f.JAQY711FPRO   =   c.JAQY711FPRO  and
                  f.jaqy711tmod =   c.jaqy711tmod    and
                  f.jaqy711ntra =   c.jaqy711ntra    and
                  f.jaqy711tsuc =   c.jaqy711tsuc    and
                  f.jaqy711nrel =   c.jaqy711nrel    and --falta transaccion
                  f.JAQY711FPRO  = pt_fecpro and
                  jaqy711corr>c.JAQY711CORR;
             commit;
  END LOOP ;

end sp_cr_elimina_anul_repe;
---------------------------------------------------------------///
Procedure sp_cr_anula_extornos(pt_fecpro in date)
is
   cursor c_extornos is
             select f1.pgcod, f1.itsuc, f1.itmod, f1.ittran, f1.itnrel,  f1.itfcon, f1.itfvc,f2.ftran,
                 f1.pgcod as cod, f1.itsuc as suc, (f1.itmod - 500) mod,  f1.ittran as tran,f1.trel
          from         (select f.pgcod, f.itsuc, f.itmod, f.ittran, f.itnrel,  f.itfcon, f.itfvc,
                        to_number(txtext) as trel
                    from fsd015 f
                   inner join fst198 f2
                  on f.pgcod = f2.tp1cod
                  and f.itmod = f2.tp1corr2
                  and f.ittran = f2.tp1imp1 --  062017--and f.ittran = f2.tp1corr3
                   inner join fsx015 fx on fx.pgcod = f.pgcod
                                       and fx.hsucor = f.itsuc
                                       and fx.hcmod = f.itmod
                                       and fx.htran = f.ittran
                                       and fx.hnrel = f.itnrel
                                       and fx.hfcon = f.itfcon
                   where f2.tp1cod1 = 10876
                     and f2.tp1corr1 = 999999
                     and f.itcont = 'S'
                     and fx.txcod = 0
                     and fx.txreng = 1) f1

             inner join
                     ( select f.pgcod, f.itsuc, f.itmod, f.ittran, f.itnrel,  f.itfcon, f.itfvc, to_date(txtext,'dd/mm/rrrr') as ftran
                      from fsd015 f
                     inner join fst198 f2
                    on f.pgcod = f2.tp1cod
                    and f.itmod = f2.tp1corr2
                    and f.ittran = f2.tp1imp1 -- 062017--and f.ittran = f2.tp1corr3
                     inner join fsx015 fx on fx.pgcod = f.pgcod
                                         and fx.hsucor = f.itsuc
                                         and fx.hcmod = f.itmod
                                         and fx.htran = f.ittran
                                         and fx.hnrel = f.itnrel
                                         and fx.hfcon = f.itfcon
                     where f2.tp1cod1 = 10876
                       and f2.tp1corr1 = 999999
                       and f.itcont = 'S'
                       and fx.txcod = 0
                       and fx.txreng = 2 )f2
               on  f1.pgcod=f2.pgcod
               and f1.itsuc=f2.itsuc
               and f1.itmod=f2.itmod
               and f1.ittran=f2.ittran
               and f1.itnrel=f2.itnrel
               and f1.itfcon=f2.itfcon
               and f1.itfvc=f2.itfvc;


begin
 pq_cr_rep_recuperacion_legal.sp_cr_elimina_anul_repe(pt_fecpro => pt_fecpro);
 FOR c in c_extornos LOOP
     update  jaqy711 j set  jaqy711ext='S'
      where jaqy711tsuc = c.suc
        and jaqy711tmod = c.mod
        and jaqy711ttran = c.tran
        and jaqy711nrel = c.trel
        and jaqy711fpag = c.ftran;
       commit;
 END LOOP;


end sp_cr_anula_extornos;
--==========================================================================================
Procedure sp_cr_mto_inserta_jaqy729(pt_fecini in date,pt_fecfin in date)
is
begin


   insert into jaqy729(
    JAQY729COR,
    JAQY729FIN,
    JAQY729FPRO,
    JAQY729MOD,
    JAQY729SUC,
    JAQY729PAP,
    JAQY729MDA,
    JAQY729CTA,
    JAQY729OPE,
    JAQY729SBOP,
    JAQY729TOP,
    JAQY729ZON,
    JAQY729CEV,
    JAQY729AGE,
    JAQY729USU,
    JAQY729TIT,
    JAQY729NDC,     
    JAQY729SAC,
    JAQY29AMA,
    JAQY729PRO,
    JAQY729TCO,
    JAQY729STAT,
    JAQY729MAP,
    JAQY729SCA,
    JAQY729MCU,
    JAQY729CIME,
    JAQY729FPR,
    JAQY729UFPE,
    JAQY729DAT,
    JAQY729DMOE,
    JAQY729CPA,
    JAQY729DTI,
    JAQY729RET,
    JAQY729DIS,
    JAQY729NAV,
    JAQY729RPJ,
    JAQY729SEG,
    JAQY729FGE,
    JAQY729FAS,
    JAQY729EVE,
    JAQY729UGE,
    JAQY729NGE,
    JAQY729NUSU,
    JAQY729NAS,
    JAQY729DUC,
    JAQY729DAC,
    JAQY729UFP,
    JAQY729AMC,
    JAQY729SCC,
    JAQY729FCA,
    JAQY729FCO,
    JAQY729UCO,
    JAQY729TCA,
    JAQY729DTCA,
    JAQY729MDAD,
    JAQY729CZO
   )
    
    select  /*+all_rows*/
    JAQY710COR ,
    pt_fecfin,
    JAQY710FPRO,
    JAQY710MOD ,
    JAQY710SUC ,
    JAQY710PAP ,
    JAQY710MDA ,
    JAQY710CTA ,
    JAQY710OPE ,
    JAQY710SBO ,
    JAQY710TOP ,
    JAQY710ZON,
    Jaqy710cev,
    jaqy710age,
    jaqy710usu,
    jaqy710tit,
    jaqy710ndc,
    jaqy710sac,
    jaqy710ama,
    JAQY709PRO,
    JAQY709TCO,
    f.cenom as JAQY709STAT,
    jaqy710map,
    jaqy710sca,
    jaqy710mcu,
    jaqy710cime,
    jaqy710frp,
    jaqy710ufpe,
    jaqy710dat,
    jaqy710dmoe,
     JAQY709CPA,
    jaqy710dti,
    replace(replace(jaqy710ret,chr(13)||chr(10),' '), chr(9),' ') as jaqy710ret ,
    jaqy710dis,
    jaqy710nav,
    jaqy710rpj,
    jaqy710seg,
    jaqy710fge,
    jaqy710fas,
    jaqy710eve,
    jaqy710uge,
    jaqy710nge,
    jaqy710nsu,
    jaqy710nas,
    JAQY709DUC,
    JAQY709DAC,
    JAQY709UFP,
    JAQY709AMC,
    (JAQY709SCC*-1) as JAQY709SCC,
    JAQY709FCA,
    jaqy710fco,
    jaqy710uco,
    jaqy709tca,
    trunc(jaqy710tca,3) as jaqy710tca,
    decode(JAQY710MDA,0,'S/.',101,'$') as JAQY710MDA,
    jaqy710czo
    from jaqy710 j
    inner join jaqy709 jj on j.jaqy710cod = jj.jaqy709cod
                          and j.jaqy710mod = jj.jaqy709mod
                          and j.jaqy710suc = jj.jaqy709suc
                          and j.jaqy710pap = jj.jaqy709pap
                          and j.jaqy710cta = jj.jaqy709cta
                          and j.jaqy710ope = jj.jaqy709ope
                          and j.jaqy710sbo = jj.jaqy709sbo
                          and j.jaqy710top = jj.jaqy709top  
     left join fst026 f
     on  jj.JAQY709STAT =f.Cecod                            
     where j.jaqy710fge >= pt_fecini
     and j.jaqy710fge <=pt_fecfin
     and jj.jaqy709fpro =pt_fecfin;
   commit;
end sp_cr_mto_inserta_jaqy729;

--------------------------------------------------------------------------
Procedure sp_cr_mto_elimina(pt_fecini in date,pt_fecfin in date)
is
begin

  delete from jaqy709 where jaqy709fpro=pt_fecfin;
  commit;
  delete from jaqy709 where jaqy709fpro<LAST_DAY(add_months(pt_fecfin,-1));
  commit;
  
  if(pt_fecini<>pt_fecfin) then
   delete from jaqy710 where jaqy710fge>=pt_fecini and jaqy710fge<=pt_fecfin ;
   commit;
  End if ;
  If(pt_fecfin-1<>LAST_DAY(add_months(pt_fecfin,-1))) then
   delete from jaqy729 where JAQY729FIN=pt_fecfin-1;
   commit;
  End if ;
  
end sp_cr_mto_elimina;


end PQ_CR_REP_RECUPERACION_LEGAL;
/

