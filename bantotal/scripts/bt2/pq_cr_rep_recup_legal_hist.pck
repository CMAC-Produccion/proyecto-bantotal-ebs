create or replace package PQ_CR_REP_RECUP_LEGAL_HIST is

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
  -- Fecha de Modificaci¿n      :
  -- Autor de la Modificaci¿n   :
  -- Descripci¿n de Modificaci¿n:
  -- *****************************************************************

 
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
                             pn_ITF  in out number,
                             pd_HFCON in date);
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
Procedure sp_cr_cred_amort_CV(pn_suc IN number,pd_fecproc IN date, pd_fecprocfin IN DATE);
---------------------------------------------------------------------
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


-----------------------------------------------------------------------
procedure sp_inserta_jaqy711_job (pd_fecini IN date, pdfecfin IN date);
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

end PQ_CR_REP_RECUP_LEGAL_HIST;
/

create or replace package body PQ_CR_REP_RECUP_LEGAL_HIST is


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
                             pn_ITF  in out number,
                             pd_HFCON in date)

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
             select h.hcimp1 into pn_ITF
            from
            fsh016 h
            where h.hsucor = pn_ITSUC
            and h.hcmod = pn_ITMOD
            and h.htran = pn_ITTRAN
            and h.hnrel = pn_ITNREL
            and h.hrubro in ('2517050901001','2527050901001') 
            and h.hfcon=pd_HFCON ;
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
            select (select sum(h.hcimp1) as monto
              from fsh016 h
             inner join fst198 f
             on h.hcmod = f.tp1corr1
               and h.htran = f.tp1corr2
               and h.hcord = f.tp1corr3
             where h.hcmod =  pn_ITMOD
               and h.hsucor = pn_ITSUC
               and h.htran =  pn_ITTRAN
               and h.hnrel =  pn_ITNREL
               and f.tp1cod1=10876
                and h.hcmod<>999999) - (select hcimp1 as monto
                                       from fsh016
                                      where hcmod =    pn_ITMOD
                                        and hsucor =   pn_ITSUC
                                        and htran =    pn_ITTRAN
                                        and hnrel =    pn_ITNREL
                                        and hcord = 56)
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
begin

 If((pn_ITMOD=30 and pn_ITTRAN in (395,397,401,403,407,408,669,670)) or (pn_ITMOD=98 and pn_ITTRAN=303))then
  ln_indicador:=1;
 else
      if(pn_stat in(21,22,33,34))then
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

Procedure sp_cr_cred_amort_CV(pn_suc IN number,pd_fecproc IN date,pd_fecprocfin IN date)
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
   select f.pgcod,f.hcmod,f.hsucor,f.htran,f.hnrel,f.hfcon from fsh015 f
   inner join 
    (select distinct g.tp1cod,g.tp1corr1,g.tp1corr2 from fst198 g where g.tp1cod = 1 AND g.tp1cod1 = 10876 AND g.tp1corr1 <> 999999) g
     ON  f.pgcod=g.tp1cod
     and f.hcmod = g.tp1corr1
     AND f.htran = g.tp1corr2
     AND f.hfcon>=pd_fecproc and f.hfcon<=pd_fecprocfin
     AND f.hsucor =pn_suc
     and f.hccorr=0;

   cursor transaccion(p_pgcod in number, p_hcmod in number,p_hsucor in number,p_htran in number,p_hnrel in number,p_hfcon in date)
   is --pgcod:1	hcmod:30	hsucor:31	htran:103	hnrel:1	hfcon:31/10/2014
        select hfcon,hcmod,htran,hsucor,hnrel,
        sum(decode(tp1nro1,1,(monto/cont) ,0 ))  capital,
        sum(decode(tp1nro1,2,(monto/cont),0 )) interes,
        sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,
        sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
        sum(decode(tp1nro1,5,(monto/cont),0 )) seguros,
        sum(decode(tp1nro1,6,(monto/cont),0 )) rub_obli,
        sum(decode(tp1nro1,7,(monto/cont),0 )) gastos
        from
        (
        select g.tp1nro1,h.hcmod,h.hsucor,h.htran,h.hnrel,h.hfcon,
        sum(h.hcimp1) monto,count(*) cont
        from  fsh016 h
        inner join fst198 g
        on  h.pgcod=g.tp1cod
        and h.hcmod=g.tp1corr1
        and h.htran=g.tp1corr2
        and h.hcord=g.tp1corr3
        and g.tp1cod=1
        and g.tp1cod1=10876
        and g.tp1corr1<>999999
        where h.pgcod=p_pgcod
        and h.hcmod=p_hcmod
        and h.hsucor=p_hsucor
        and h.htran=p_htran
        and h.hnrel=p_hnrel
        and h.hfcon=p_hfcon 
        group by g.tp1nro1,h.hcmod,h.hsucor,h.htran,h.hnrel,h.hfcon 
        )
        group by hfcon,hcmod,htran,hsucor,hnrel;    
         
         ---VARIABLES
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
        
        
        
        
BEGIN
  FOR c in c_cart_cred_act LOOP
     FOR  y IN transaccion(c.pgcod,c.hcmod,c.hsucor,c.htran,c.hnrel,c.hfcon ) LOOP
         pl_scsuc:=null;
         pl_scmod:=null;
         pl_scmda:=null;
         pl_scpap:=null;
         pl_sccta:=null;
         pl_scoper:=null;
         pl_scsbop:=null;
         pl_sctope:=null;


       pq_cr_rep_recup_legal_hist.sp_cr_obtiene_pk( pt_pgcod => c.pgcod,
                                                      pt_modt => c.hcmod,
                                                      pt_tran => c.htran,
                                                      pt_suct => c.hsucor,
                                                      pt_rel => c.hnrel,
                                                      pt_suc =>    pl_scsuc,
                                                      pt_mod =>    pl_scmod,
                                                      pt_moneda => pl_scmda,
                                                      pt_papel =>  pl_scpap,
                                                      pt_cnta =>   pl_sccta,
                                                      pt_operac => pl_scoper,
                                                      pt_sboper => pl_scsbop,
                                                      pt_toper =>  pl_sctope,
                                                      pt_fecpag=>y.hfcon);

        fpag := y.hfcon;
       pq_cr_rep_recup_legal_hist.sp_cr_mod_est_act(pt_fecpag =>fpag ,
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
                                                     pn_ITSUC =>y.hsucor,
                                                     pn_ITMOD =>y.hcmod,
                                                     pn_ITTRAN =>y.htran,
                                                     pn_ITNREL=>y.hnrel);

      ln_valido:=pq_cr_rep_recup_legal_hist.fn_pago_valido(pt_pgcod => c.pgcod,
                                                         pt_suc => pl_scsuc,
                                                         pt_mod => pl_scmod,
                                                         pt_moneda => pl_scmda,
                                                         pt_papel => pl_scpap,
                                                         pt_cnta => pl_sccta,
                                                         pt_operac => pl_scoper,
                                                         pt_sboper => pl_scsbop,
                                                         pt_toper => pl_sctope,
                                                         pn_itsuc => y.hsucor,
                                                         pn_itmod => y.hcmod,
                                                         pn_ittran => y.htran,
                                                         pn_itnrel => y.hnrel,
                                                         pn_stat => ln_stat);

      IF (ln_valido=1 )
      THEN
      ln_capital  :=y.capital;
      ln_interes  :=y.interes;
      ln_int_comp_extra :=y.int_comp_extra;
      ln_mora     :=y.mora;
      ln_rub_obli :=y.rub_obli;
      ln_gastos   := y.gastos;
      ln_seguros  := y.seguros;


                    sp_cr_montos_amort(pn_itsuc => y.hsucor,
                                       pn_itmod => y.hcmod,
                                       pn_ittran => y.htran,
                                       pn_itnrel => y.hnrel,
                                       pn_capital=> ln_capital,
                                       pn_interes => ln_interes,
                                       pn_int_comp_extra => ln_int_comp_extra,
                                       pn_mora => ln_mora,
                                       pn_seguros => ln_seguros,
                                       pn_rub_obli => ln_rub_obli,
                                       pn_gastos => ln_gastos,
                                       pn_itf => ITF,
                                       pd_HFCON => y.hfcon );

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
                                                                     itmod => y.hcmod,
                                                                     ittran => y.htran);

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
                              y.hcmod,
                              y.htran,
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
                              y.hfcon ,
                              y.hnrel,
                              y.hsucor,
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
     END LOOP;
  END LOOP;
end;

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
begin
--nuevoooooooooooooooooo

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
--nuevo
   
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
                  ln_indicador:=0;
     end;
   end if;
end sp_cr_obtiene_pk;
------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
procedure sp_inserta_jaqy711_job (pd_fecini IN date, pdfecfin IN date)
                                is

   lc_feccar varchar2(10);
    lc_feccarFIN varchar2(10);
   lc_variable   varchar2(4000);
   ln_job        number:= 0;
   lc_hostname varchar2(64);
   
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
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

     lc_feccar := to_char(pd_fecini,'RRRR.MM.DD');
     lc_feccarFIN := to_char(pdfecfin,'RRRR.MM.DD');

      for job in c_sucursales_job loop

        lc_variable := ' begin '||
              ' PQ_CR_REP_RECUP_LEGAL_HIST.sp_cr_cred_amort_CV(to_number('''||job.sucurs||''')'||
              ',TO_DATE('''||lc_feccar||''',''RRRR.MM.DD'')'||
              ',TO_DATE('''||lc_feccarFIN||''',''RRRR.MM.DD'')'||');'||
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
                              instance =>  2,
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

  end sp_inserta_jaqy711_job;
---------------------------------------------------

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

end PQ_CR_REP_RECUP_LEGAL_HIST;
/

