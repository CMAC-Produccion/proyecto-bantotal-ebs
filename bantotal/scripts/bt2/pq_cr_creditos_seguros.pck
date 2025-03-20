create or replace package pq_cr_creditos_seguros is

-- Author       : HSUAREZ
-- Created      : 02/03/2017 04:23:53 p.m.
-- Purpose      : OBTIENE DATOS GENERALES
-- Modificación : SMARQUEZ 23/09/2024 OPTIMIZACION PROCESO
procedure sp_carga(p_fecha in date) ;

--Procedure sp_cr_seguro(tipo_seguro in number, v_fecha in date);
procedure sp_cr_seguro (tipo_seguro in number, 
                            v_fecha in date, 
                            v_desde in number,
                            v_hasta in number);

Procedure sp_verifica_pago ( ln_pgcod     in number,
                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             fecha1      in date,
                             fecha2      in date,
                             ln_codvar out fsd602.pp1nump%type,
                             ln_d602cd out fsd602.d602cd%type,
                             ln_d602mo out fsd602.d602mo%type,
                             ln_d602su out fsd602.d602su%type,
                             ln_d602tr out fsd602.d602tr%type,
                             ln_d602re out fsd602.d602re%type,
                             ln_d602fc out fsd602.d602fc%type,
                             ln_ppfpag out fsd602.ppfpag%type

                          );
 Procedure sp_verifica_transaccion(
                                    ln_d602cd fsd602.d602cd%type,
                                    ln_d602mo fsd602.d602mo%type,
                                    ln_d602su fsd602.d602su%type,
                                    ln_d602tr fsd602.d602tr%type,
                                    ln_d602re fsd602.d602re%type,
                                    ln_d602fc fsd602.d602fc%type,
                                    --variable par definir tipo de  seguro
                                    tipo_seguro in number,
                                    ln_rubro    out number,
                                    lc_variable out varchar
                                   );

 procedure sp_cr_seg_vidacaja(pd_fecini in date);
 procedure sp_cr_seg_familiaseg(pd_fecini in date);
 procedure sp_cr_seg_movigas(pd_fecini in date);
 procedure sp_cr_seg_credvehic(pd_fecini in date);
 procedure sp_cr_tipo_seguro(pd_fecini in date,tipo_seguro in number);

 Procedure sp_consultar_seguros (
                                  ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_suboper   in number,
                                  ln_tope      in number,
                                  ln_tp1corr2  in number,
                                  ln_codseg    out number,
                                  lc_ctdseg    out number,
                                  lc_posicion  out number,
                                  lc_monto     out number
                                );

 procedure sp_consultar_pgoseg_cpto(
                                    ln_pgcod     in number,
                                    ln_modulo    in number,
                                    ln_sucursal  in number,
                                    ln_moneda    in number,
                                    ln_papel     in number,
                                    ln_cuenta    in number,
                                    ln_operacion in number,
                                    ln_suboper   in number,
                                    ln_tope      in number,
                                    ln_fpago     in date,
                                    ld_fproceso  in date,
                                    ln_codvar    in number, --pp1num
                                    lc_ctdseg    in number, -- cantidad de seguros
                                    lc_posicion  in number, -- posición
                                    lc_monto     in number, -- monto
                                    ln_flag      out varchar,
                                    ln_newmonto  out number
                                  );

 procedure sp_cr_carga_job_seguro(pd_fecpro IN date); ---,tipo_seguro in number);
--  procedure sp_cr_carga_job_seguro(tipo_seguro in number, pd_fecpro IN date, digito in number);
/*
  function fn_cuota_vencida(
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date
                           ) return number;
*/
  procedure sp_valida_numsuc(P_mod  in number,
                             P_tran in number,
                             P_suc out number);
-----------------------------------------------------------------------------
 procedure Validacion_VIDACAJA;



end pq_cr_creditos_seguros;
/

create or replace package body pq_cr_creditos_seguros is
    -- *****************************************************************
    -- Nombre                     : pq_cr_creditos_seguros
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.26
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Paquete para la ejecucion de seguros vidacaja,vehicular,movigas,familia seguro.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :31/05/2021
    -- Autor de la Modificación+   : Silvia Modificacón
    -- Descripción de Modificación : Modificación para adicion del monto pagado
    -- Fecha de Modificación      :12/07/2023
    -- Autor de la Modificación+   : Silvia Modificacón
    -- Descripción de Modificación : Modificación para Modificacion de Proceso para que pase prima completa pagada
    -- Modificación                : SMARQUEZ 20/09/2024 optimizacion de generacion de jobs seguros
    -- *****************************************************************

procedure sp_carga (p_fecha in date) is

  cursor seguros(v_fech1 date,v_fech2 date,seguro number) is
        Select /*+ NO_CPU_COSTING */
               a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               P_fecha,
               a.aofval,
               a.aostat,
               b.sgcod, --codigo seguro
               b.pp001imp, --monto seguro
               (select trunc(tp1imp1)
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 10875
                                    and tp1corr1 = 4
                                    AND TP1CORR2 = 1  --SE AÑADIO
                                    and tp1nro2 =  seguro 
                                    and rownum = 1) rubro
          from fsd010 a
          join fpp001 b
            on a.pgcod = b.pgcod
           and a.aomod = b.aomod
           and a.aosuc = b.aosuc
           and a.aomda = b.aomda
           and a.aopap = b.aopap
           and a.aocta = b.aocta
           and a.aooper = b.aooper
           and a.aosbop = b.aosbop
           and a.aotope = b.aotope
         where a.aomod in (select modulo from fst111 where dscod = 50)
           and a.aocta <> 999999999
           and a.aostat <> 99
           and b.sgcod in (select tp1nro1
                             from fst198
                            where tp1cod = 1
                              and tp1cod1 = 10875
                              and tp1corr1 = 4
                              AND TP1CORR2 = 1  --SE AÑADIO
                              and tp1nro2 = seguro)
        --   and (a.aostat <> 99 or (a.aostat = 99 and a.aofe99 >= v_fech1 and a.aofe99 <= v_fech2))--;
           and exists (select 1 from fsd011  ---sma 12/07/2023
                        where pgcod = 1
                          and scsuc = a.aosuc
                          and scrub = (select trunc(tp1imp1)
                                         from fst198
                                        where tp1cod = 1
                                          and tp1cod1 = 10875
                                          and tp1corr1 = 4
                                          AND TP1CORR2 = 1  --SE AÑADIO
                                          and tp1nro2 = seguro 
                                          and rownum = 1) 
                          and scmda =a.aomda
                          and scpap = a.aopap
                          and sccta = a.aocta
                          and scoper = a.aooper                   
                          and scmod = 260
                          and scsdo > 0);
  cursor seguros1(v_fech1 date,v_fech2 date,seguro number) is
        Select /*+ NO_CPU_COSTING */
               a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               P_fecha,
               a.aofval,
               a.aostat,
               b.sgcod, --codigo seguro
               b.pp001imp, --monto seguro
               (select trunc(tp1imp1)
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 10875
                                    and tp1corr1 = 4
                                    AND TP1CORR2 = 1  --SE AÑADIO
                                    and tp1nro2 =  seguro 
                                    and rownum = 1) rubro
          from fsd010 a
          join fpp001 b
            on a.pgcod = b.pgcod
           and a.aomod = b.aomod
           and a.aosuc = b.aosuc
           and a.aomda = b.aomda
           and a.aopap = b.aopap
           and a.aocta = b.aocta
           and a.aooper = b.aooper
           and a.aosbop = b.aosbop
           and a.aotope = b.aotope
         where a.aomod in (select modulo from fst111 where dscod = 50)
           and a.aocta <> 999999999
           and a.aostat = 99
           and a.aofe99 >= add_months (v_fech1,-3) 
           and b.sgcod in (select tp1nro1
                             from fst198
                            where tp1cod = 1
                              and tp1cod1 = 10875
                              and tp1corr1 = 4
                              AND TP1CORR2 = 1  --SE AÑADIO
                              and tp1nro2 = seguro)
        --   and (a.aostat <> 99 or (a.aostat = 99 and a.aofe99 >= v_fech1 and a.aofe99 <= v_fech2))--;
           and exists (select 1 from fsd011  ---sma 12/07/2023
                        where pgcod = 1
                          and scsuc = a.aosuc
                          and scrub = (select trunc(tp1imp1)
                                         from fst198
                                        where tp1cod = 1
                                          and tp1cod1 = 10875
                                          and tp1corr1 = 4
                                          AND TP1CORR2 = 1  --SE AÑADIO
                                          and tp1nro2 = seguro 
                                          and rownum = 1) 
                          and scmda =a.aomda
                          and scpap = a.aopap
                          and sccta = a.aocta
                          and scoper = a.aooper                   
                          and scmod = 260
                          and scsdo > 0);
  cursor guia is
  select * from   fst198 where tp1cod =1 and tp1cod1 = 10884 and tp1corr1 = 81;
                      
  fecha1 date := TRUNC(p_fecha, 'MM');
  fecha2 date := last_day(p_fecha);
  i number := 1;
begin
  --while i <= 6 LOOP
 --   i:= 1;
   for i in guia loop
    for x in seguros (fecha1,fecha2,i.tp1nro1) loop
      begin
         INSERT INTO jaqz716_AUX
           (jaqz716id,
            jaqz716cod,
            jaqz716suc,
            jaqz716mda,
            jaqz716pap,
            jaqz716cta,
            jaqz716oper,
            jaqz716sbop,
            jaqz716tope,
            jaqz716mod,
            jaqz716estcr,
            jaqz716tipseg,
            jaqz716fecpro,
            jaqz716monseg, 
            jaqz716rub, 
            jaqz716sgcod  )
         VALUES
           (2,
            x.pgcod,
            x.aosuc,
            x.aomda,
            x.aopap,
            x.aocta,
            x.aooper,
            x.aosbop,
            x.aotope,
            x.aomod,
            x.aostat,
            i.tp1nro1,
            p_fecha,
            x.pp001imp,
            x.rubro,
            x.sgcod);
             commit;
          exception
            when dup_val_on_index then
              null;
          end;
         
    end loop;
    
    for x in seguros1 (fecha1,fecha2,i.tp1nro1) loop
      begin
         INSERT INTO jaqz716_AUX
           (jaqz716id,
            jaqz716cod,
            jaqz716suc,
            jaqz716mda,
            jaqz716pap,
            jaqz716cta,
            jaqz716oper,
            jaqz716sbop,
            jaqz716tope,
            jaqz716mod,
            jaqz716estcr,
            jaqz716tipseg,
            jaqz716fecpro,
            jaqz716monseg, 
            jaqz716rub, 
            jaqz716sgcod  )
         VALUES
           (2,
            x.pgcod,
            x.aosuc,
            x.aomda,
            x.aopap,
            x.aocta,
            x.aooper,
            x.aosbop,
            x.aotope,
            x.aomod,
            x.aostat,
            i.tp1nro1,
            p_fecha,
            x.pp001imp,
            x.rubro,
            x.sgcod); 
            commit;
          exception
            when dup_val_on_index then
              null;
          end;
    end loop;
  --  i := i + 1  ;
  end loop;
  delete jaqz716_aux where JAQZ716TIPSEG =4 and JAQZ716MOD <>112;
  commit;
end sp_carga;


--Procedure sp_cr_seguro (tipo_seguro in number,v_fecha in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.26
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso para obtener los seguros segun condicion a detalle.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 11/2017
    -- Autor de la Modificación   :Silvia Marquez Avendaño
    -- Descripción de Modificación:Cambios para el proceso mensual para carga de datos
    -- Fecha de Modificación      : 12/07/2023
    -- Autor de la Modificación   :Silvia Marquez Avendaño
    -- Descripción de Modificación:mODIFICACION DEL PROCESO DE COBRO
    -- *****************************************************************
  --CARGANDO SEGUROS DE VIDA CAJA DEL MES
  Procedure sp_cr_seguro (tipo_seguro in number, 
                              v_fecha IN date, 
                              v_desde in number,
                              v_hasta in number) is
       cursor seguro1 is ---(tipo_seguro in number) is
         select *
           from jaqz716_aux
          where jaqz716tipseg = tipo_seguro ---verificar tipos
            and jaqz716cta between v_desde and v_hasta
--            and to_char(substr(trim(jaqz716cta ), -1, 1)) = digito
        --    and jaqz716cta = 3270418	
        --    and jaqz716oper =13136484           
            ;          
            

      cursor pagos(ln_pgcod     number,
                   ln_modulo    number,
                   ln_sucursal  number,
                   ln_moneda    number,
                   ln_papel     number,
                   ln_cuenta    number,
                   ln_operacion number,
                   ln_suboper   number,
                   ln_tope      number,
                   fecha1       date,
                   fecha2       date ) is
          select
                 g.pp1nump,
                 g.d602cd,
                 g.d602mo,
                 g.d602su,
                 g.d602tr,
                 g.d602re,
                 g.d602fc,
                 g.ppfpag
            from fsd602 g
           where g.pgcod  = ln_pgcod
             and g.ppmod  = ln_modulo
             and g.ppsuc  = ln_sucursal
             and g.ppmda  = ln_moneda
             and g.pppap  = ln_papel
             and g.ppcta  = ln_cuenta
             and g.ppoper = ln_operacion
             and g.ppsbop = ln_suboper
             and g.pptope = ln_tope
             and g.d602co = 'S'
             and g.pp1stat = 'T'
             and g.ppfpag <= fecha2
             and (( g.pp1fech >= fecha1 and g.pp1fech <= fecha2  )  or
                   ( g.d602fc >= fecha1 and g.d602fc <= fecha2  ));
  ln_d602cd fsd602.d602cd%type;
  ln_d602mo fsd602.d602mo%type;
  ln_d602su fsd602.d602su%type;
  ln_d602tr fsd602.d602tr%type;
  ln_d602re fsd602.d602re%type;
  ln_d602fc fsd602.d602fc%type;
  lc_variable varchar(1) ;
  ln_codvar number;
  lc_ctdseg number;
  lc_monto  number;
  lc_posicion number;
  lc_flag varchar(1);
--  ln_tp1corr2 number;
  ln_ppfpage date;
  ln_dias_atraso number;
--  lc_itcont number;
  fecha1 date := TRUNC(v_fecha, 'MM');
  fecha2 date := last_day(v_fecha);
  ln_rubrotrx number;
  ln_codseguro number;

  ln_nuevomonto number :=0;
  ln_saldo NUMBER(17,2);
  resultado number;
  Flag_inserta char(1);
  begin
        for job in seguro1 loop
          BEgin
            select SCSDO
              INTO ln_saldo
              from fsd011  ---sma 12/07/2023
              where pgcod = 1
                and scsuc = job.jaqz716suc
                and scrub = (select trunc(tp1imp1)
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 10875
                                and tp1corr1 = 4
                                AND TP1CORR2 = 1  --SE AÑADIO
                                and tp1nro2 = job.jaqz716tipseg 
                                and rownum = 1) 
                and scmda = job.jaqz716mda
                and scpap = job.jaqz716pap
                and sccta = job.jaqz716cta
                and scoper = job.jaqz716oper              
                and scmod = 260;
           exception  
                when no_Data_found then
                  ln_saldo := 0;
                  
                when too_many_rows then 
                   select SCSDO
                     INTO ln_saldo
                     from fsd011 ---sma 12/07/2023
                    where pgcod = 1
                      and scsuc = job.jaqz716suc
                      and scrub = (select trunc(tp1imp1)
                                     from fst198
                                    where tp1cod = 1
                                      and tp1cod1 = 10875
                                      and tp1corr1 = 4
                                      AND TP1CORR2 = 1 --SE AÑADIO
                                      and tp1nro2 = job.jaqz716tipseg
                                      and rownum = 1)
                      and scmda = job.jaqz716mda
                      and scpap = job.jaqz716pap
                      and sccta = job.jaqz716cta
                      and scoper = job.jaqz716oper
                      and scmod = 260
                      and rownum = 1;
           end;
           ---Nuevo calculo para el monto a cobrar cuotas completas
           if ln_saldo >= job.jaqz716monseg and ln_saldo<> 0 and job.jaqz716monseg <> 0 then
               select Mod(ln_saldo,job.jaqz716monseg) into resultado from dual;
               if resultado = 0 then
                 ln_nuevomonto := ln_saldo;
               else
                 resultado := trunc(ln_saldo/job.jaqz716monseg);
                 ln_nuevomonto := resultado  * job.jaqz716monseg;
               end if; 
               Flag_inserta :='S';
            else
              Flag_inserta :='N';
              dbms_output.put_line(job.jaqz716cta||' '||job.jaqz716oper||' '||ln_saldo||' '||job.jaqz716monseg);
            end if;
         
                    --AGREGAR LOS REGISTROS.
                if Flag_inserta = 'S' then
                    begin

                        INSERT INTO jaqz716
                        (
                               jaqz716id,
                               jaqz716cod,
                               jaqz716suc,
                               jaqz716mda,
                               jaqz716pap,
                               jaqz716cta,
                               jaqz716oper,
                               jaqz716sbop,
                               jaqz716tope,
                               jaqz716mod,
                               jaqz716estcr,
                               jaqz716tipseg,
                               jaqz716fecseg,
                               jaqz716fecpag,
                               jaqz716fecca,
                               jaqz716monseg,
                               jaqz716diaatr,
                               jaqz716itsuc,
                               jaqz716itmod,
                               jaqz716ittran,
                               jaqz716itnrel,
                               jaqz716itfcon,
                               jaqz716itcont,
                               jaqz716rub,
                               jaqz716sgcod,
                               jaqz716aux3,
                               jaqz716contt 
                        )
                        VALUES
                        (
                               2,
                               job.jaqz716cod,--.pgcod   ,
                               job.jaqz716suc,--aosuc   ,
                               job.jaqz716mda,--.aomda   ,
                               job.jaqz716pap,--.aopap   ,
                               job.jaqz716cta,---.aocta   ,
                               job.jaqz716oper,--.aooper  ,
                               job.jaqz716sbop,--.aosbop  ,
                               job.jaqz716tope,--.aotope  ,
                               job.jaqz716mod,--.aomod   ,
                               job.jaqz716estcr,--.aostat  ,
                               tipo_seguro ,
                               v_fecha     ,                               
                               v_fecha  ,
                               v_fecha  ,
                               ln_nuevomonto, --lc_monto sma 29/05/2021
                               0,
                               0,
                               0,
                               0,
                               0,
                               v_fecha,
                               'S',
                               job.jaqz716rub,
                               job.jaqz716sgcod,
                               'N',
                              1
                        );
                        exception
                          when dup_val_on_index then
                            null;
                         /*   dbms_output.put_line(job.jaqz716cod||' '||job.jaqz716suc||' '||job.jaqz716mda
                               ||' '||job.jaqz716pap||' '||job.jaqz716cta||' '||job.jaqz716oper
                               ||' '||job.jaqz716sbop||' '||job.jaqz716tope||' '||job.jaqz716mod
                               ||' '||job.jaqz716estcr||' '||tipo_seguro||' '||v_fecha||' '||ln_ppfpage
                               ||' '||ln_d602fc||' '||lc_monto||' '||ln_dias_atraso||' '||
                               ln_d602su||' '||ln_d602mo||' '||ln_d602tr||' '||ln_d602re||' '||ln_d602fc
                               ||'S'||ln_rubrotrx||' '|| ln_codseguro);*/
                        end;
                        begin

                        INSERT INTO jaqz716H
                        (
                               jaqz716idh,
                               jaqz716codh,
                               jaqz716such,
                               jaqz716mdah,
                               jaqz716paph,
                               jaqz716ctah,
                               jaqz716operh,
                               jaqz716sboph,
                               jaqz716topeh,
                               jaqz716modh,
                               jaqz716estcrh,
                               jaqz716tipsegh,
                               jaqz716fecsegh,
                               --jaqz716fecpro,
                               jaqz716fecpagh,
                               jaqz716feccah,
                               jaqz716monsegh,

                               jaqz716diaatrh,
                               jaqz716itsuch,
                               jaqz716itmodh,
                               jaqz716ittranh,
                               jaqz716itnrelh,
                               jaqz716itfconh,
                               jaqz716itconth,
                               jaqz716rubh,
                               jaqz716sgcodh
                        )
                        VALUES
                        (
                               2,
                               job.jaqz716cod,--.pgcod   ,
                               job.jaqz716suc,--aosuc   ,
                               job.jaqz716mda,--.aomda   ,
                               job.jaqz716pap,--.aopap   ,
                               job.jaqz716cta,---.aocta   ,
                               job.jaqz716oper,--.aooper  ,
                               job.jaqz716sbop,--.aosbop  ,
                               job.jaqz716tope,--.aotope  ,
                               job.jaqz716mod,--.aomod   ,
                               job.jaqz716estcr,--.aostat  ,
                               tipo_seguro,
                               v_fecha     ,
                               --v_fecha     ,
                               v_fecha  ,
                               v_fecha   ,
                               ln_nuevomonto,--lc_monto  sma 29/05/2021
                               0,
                               0,
                               0,
                               0,
                               0,
                               v_fecha,
                               'S',
                               job.jaqz716rub,
                               job.jaqz716sgcod
                        );
                        exception
                          when dup_val_on_index then
                            null;
                        end;
         --       end if;
                commit;
            end if;
       --  end loop;
       end loop;
       commit;
       Validacion_VIDACAJA;
  end sp_cr_seguro;


 Procedure sp_verifica_pago (ln_pgcod     in number,
                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             fecha1      in date,
                             fecha2      in date,
                             ln_codvar   out fsd602.pp1nump%type,

                             ln_d602cd out fsd602.d602cd%type,
                             ln_d602mo out fsd602.d602mo%type,
                             ln_d602su out fsd602.d602su%type,
                             ln_d602tr out fsd602.d602tr%type,
                             ln_d602re out fsd602.d602re%type,
                             ln_d602fc out fsd602.d602fc%type,
                             ln_ppfpag out fsd602.ppfpag%type

                          ) is
    -- *****************************************************************
    -- Nombre                     : sp_verifica_pago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : verifica que se hayan realizado pagos para el mes consultado.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

  --CONSULTA TABLA SI EXCISTE PAGO DEL SEGURO.
  begin
       select
               /*
               g.pgcod,
               g.ppmod,
               g.ppsuc,
               g.ppmda,
               g.ppmda,
               g.ppcta,
               g.ppoper,
               g.ppsbop,
               g.pptope,
               v_fecha,
               g.ppfpag
               */
               g.pp1nump,
               g.d602cd,
               g.d602mo,
               g.d602su,
               g.d602tr,
               g.d602re,
               g.d602fc,
               g.ppfpag
          into
               ln_codvar,
               ln_d602cd,
               ln_d602mo,
               ln_d602su,
               ln_d602tr,
               ln_d602re,
               ln_d602fc,
               ln_ppfpag
          from fsd602 g
         where g.pgcod  = ln_pgcod
           and g.ppmod  = ln_modulo
           and g.ppsuc  = ln_sucursal
           and g.ppmda  = ln_moneda
           and g.pppap  = ln_papel
           and g.ppcta  = ln_cuenta
           and g.ppoper = ln_operacion
           and g.ppsbop = ln_suboper
           and g.pptope = ln_tope
           and g.d602co = 'S'
           and g.pp1stat ='T'
           and (
                 ( g.pp1fech >= fecha1 and g.pp1fech <= fecha2  )
                  or
                 ( g.d602fc >= fecha1 and g.d602fc <= fecha2  )
               );
         commit;

  exception
     when too_many_rows then
       Begin
        select g.pp1nump,
               g.d602cd,
               g.d602mo,
               g.d602su,
               g.d602tr,
               g.d602re,
               g.d602fc,
               g.ppfpag
          into
               ln_codvar,
               ln_d602cd,
               ln_d602mo,
               ln_d602su,
               ln_d602tr,
               ln_d602re,
               ln_d602fc,
               ln_ppfpag
          from fsd602 g
         where g.pgcod  = ln_pgcod
           and g.ppmod  = ln_modulo
           and g.ppsuc  = ln_sucursal
           and g.ppmda  = ln_moneda
           and g.pppap  = ln_papel
           and g.ppcta  = ln_cuenta
           and g.ppoper = ln_operacion
           and g.ppsbop = ln_suboper
           and g.pptope = ln_tope
           and g.d602co = 'S'
           and g.pp1stat ='T'
           and g.ppfpag between fecha1 and fecha2 ;
         exception
           when no_data_found then
             select g.pp1nump,
               g.d602cd,
               g.d602mo,
               g.d602su,
               g.d602tr,
               g.d602re,
               g.d602fc,
               g.ppfpag
          into
               ln_codvar,
               ln_d602cd,
               ln_d602mo,
               ln_d602su,
               ln_d602tr,
               ln_d602re,
               ln_d602fc,
               ln_ppfpag
          from fsd602 g
         where g.pgcod  = ln_pgcod
           and g.ppmod  = ln_modulo
           and g.ppsuc  = ln_sucursal
           and g.ppmda  = ln_moneda
           and g.pppap  = ln_papel
           and g.ppcta  = ln_cuenta
           and g.ppoper = ln_operacion
           and g.ppsbop = ln_suboper
           and g.pptope = ln_tope
           and g.d602co = 'S'
           and g.pp1stat ='T'
           and g.ppfpag  = (select max(ppfpag)
                              from fsd602
                             where pgcod  = ln_pgcod
                               and ppmod  = ln_modulo
                               and ppsuc  = ln_sucursal
                               and ppmda  = ln_moneda
                               and pppap  = ln_papel
                               and ppcta  = ln_cuenta
                               and ppoper = ln_operacion
                               and ppsbop = ln_suboper
                               and pptope = ln_tope
                               and d602co = 'S'
                               and pp1stat ='T'
                               and ppfpag <= fecha2);

         end;
     when others then
           --INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           --VALUES(0,'AUDIT',lc_variable, TRUNC(SYSDATE));
           COMMIT;

  end;
---
 Procedure sp_consultar_seguros (
                                  ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_suboper   in number,
                                  ln_tope      in number,
                                  --CODIGO DEL SEGURO
                                  ln_tp1corr2  in number,
                                  ln_codseg    out number,
                                  lc_ctdseg    out number,
                                  lc_posicion  out number,
                                  lc_monto     out number
                                ) is
    -- *****************************************************************
    -- Nombre                     : sp_verifica_pago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : verifica cuantos seguros tiene el credito ,posicion y monto del seguro solicitado..
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    temp number;
    temp2 number;
    monto1 number := 0;
    monto2 number := 0;
    monto3 number := 0;
    monto4 number := 0;
    monto5 number := 0;
    cursor segurosxcuenta is
        select *
          from fpp001 a
          where a.pgcod  = ln_pgcod
            and a.aomod  = ln_modulo
            and a.aosuc  = ln_sucursal
            and a.aomda  = ln_moneda
            and a.aopap  = ln_papel
            and a.aocta  = ln_cuenta
            and a.aooper = ln_operacion
            and a.aosbop = ln_suboper
            and a.aotope = ln_tope;
    --Seguro - guia especial de proceso -- El seguro esta definido por el parametro recibido.
    cursor moduloxseguro(seguro number) is
    select tp1nro1
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10875
       and tp1corr1 = 4
       and tp1nro2 = seguro
       and tp1corr3 > 0;
    begin
       --Aqui encuentro la cantidad de seguros.
       begin
          select
                 count (*)
          into
                 lc_ctdseg
          from fpp001 a
          where a.pgcod  = ln_pgcod
            and a.aomod  = ln_modulo
            and a.aosuc  = ln_sucursal
            and a.aomda  = ln_moneda
            and a.aopap  = ln_papel
            and a.aocta  = ln_cuenta
            and a.aooper = ln_operacion
            and a.aosbop = ln_suboper
            and a.aotope = ln_tope;
       exception     
         when no_Data_found then
         lc_ctdseg:= 0;
       end;
       -- Aqui encuentro posición del Seguro.
       begin
           temp := 0;
           temp2:= 0;
           lc_monto:=0;
           if lc_ctdseg>0 then
               for job in segurosxcuenta loop
                     temp := temp + 1;
                     for job2 in moduloxseguro(ln_tp1corr2) loop
                         if job.sgcod = job2.tp1nro1 then
                            lc_monto := job.pp001imp;
                            ln_codseg := job.sgcod;
                            temp2 := temp;
                            exit;
                         end if;
                     end loop;
               end loop;
           else
                temp2 := 1;
           end if;
           lc_posicion := temp2;
           if lc_monto = 0 then --20190104 sma
             Begin
                 select ppimp11, ppimp12, ppimp13,ppimp14, ppimp15
                   into monto1, monto2, monto3, monto4, monto5
                   from fsd611
                  where pgcod = ln_pgcod
                    and ppmod = ln_modulo
                    and ppsuc = ln_sucursal
                    and ppmda = ln_moneda
                    and pppap = ln_papel
                    and ppcta = ln_cuenta
                    and ppoper = ln_operacion
                    and ppsbop = ln_suboper
                    and pptope = ln_tope
                    and ppfpag = ( select min(ppfpag) from fsd611 f6
                                    where pgcod = ln_pgcod
                                      and ppmod = ln_modulo
                                      and ppsuc = ln_sucursal
                                      and ppmda = ln_moneda
                                      and pppap = ln_papel
                                      and ppcta = ln_cuenta
                                      and ppoper = ln_operacion
                                      and ppsbop = ln_suboper
                                      and pptope = ln_tope);
              if lc_posicion = 1 then
                lc_monto := monto1;
              end if;
              if lc_posicion = 2 then
                lc_monto := monto2;
              end if;
              if lc_posicion = 3 then
                lc_monto := monto3;
              end if;
              if lc_posicion = 4 then
                lc_monto := monto4;
              end if;
              if lc_posicion = 5 then
                lc_monto := monto5;
              end if;
             exception
               when no_data_found then
                 lc_monto := 0;
             End;
           end if;
       end;
    end;

---
  Procedure sp_verifica_transaccion (
                                    ln_d602cd fsd602.d602cd%type,
                                    ln_d602mo fsd602.d602mo%type,
                                    ln_d602su fsd602.d602su%type,
                                    ln_d602tr fsd602.d602tr%type,
                                    ln_d602re fsd602.d602re%type,
                                    ln_d602fc fsd602.d602fc%type,
                                    --variable par definir tipo de  seguro
                                    tipo_seguro in number,
                                    ln_rubro    out number,
                                    lc_variable out varchar
                                   ) is
  -- *****************************************************************
    -- Nombre                     : sp_verifica_pago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.26
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : verifica que contablemente se haya realizado el pago del seguro.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
   rubro number := 0;
   cuenta number := 0;
   operacion number := 0;
   begin
     if tipo_seguro = 1 then
       --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE SEGURO VIDA CAJA.
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable,rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro in ('2524020000008', '2514020000008');
          exception
            when no_data_found then
              lc_variable := 'N';
              /*begin
                  select 'S', decode(x.ppmda,0,2514020000008,2524020000008)
                    into lc_variable,rubro
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag
                     and rownum = 1;
            exception
              when no_data_found then
              lc_variable := 'N';
            end;*/
       end;


     end if;
     --
     --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE SEGURO FAMILIA SEGURA.
     if tipo_seguro = 2 then
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable,rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro = 2514020000013;
          exception
            when no_data_found then
              lc_variable := 'N';
              /*begin
                  select 'S', 2514020000013
                    into lc_variable,rubro
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag;
            exception
              when no_data_found then
              lc_variable := 'N';
            end;*/
       end;
     end if;
     --
     --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE SEGURO MOVIGAS.
     if tipo_seguro = 3 then
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable, rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro = 2514020000002;
          exception
            when no_data_found then
              lc_variable := 'N';
/*              begin
                  select 'S', 2514020000002
                    into lc_variable,rubro
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag;
            exception
              when no_data_found then
              lc_variable := 'N';
            end;*/
       end;
     end if;
     --
     --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE CREDITO VEHICULAR.
     if tipo_seguro = 4 then
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable,rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro in (2514020000007,2524020000007);
          exception
            when no_Data_found then
               lc_variable := 'N';
               /*begin
                  select 'S', Decode(x.ppmda, 0,2514020000007,2524020000007)
                    into lc_variable,rubro
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag;
            exception
              when no_data_found then
              lc_variable := 'N';
            end;*/
       end;
     end if;
     --
     --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE DIVINO SEGURO.
     if tipo_seguro = 5 then
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable,rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro in (2514020000014,2524020000014);
          exception
            when no_Data_found then
              begin
                  select y.ppcta, y.ppoper
                    into cuenta, operacion
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag
                     and rownum = 1;
              exception
                when no_data_found then
                 cuenta := 0;
                 operacion := 0;
              end;
              Begin
                select distinct ('S'),hrubro
                  into lc_variable,rubro
                  from fsh016
                 where PGCOD  = 1
                   and hrubro in  (2514020000014,2524020000014)
                   and hmda IN (0,101)
                   and hpap = 0
                   and hcta = cuenta
                   and HFvco  = ln_d602fc
                   and HCMOD  = 99
                   and HTRAN  = 834
                   and hoper = operacion;
              exception
                when no_data_found then
                  lc_variable := 'N';
              end;
           end;
     end if;
     --
     --CONSULTA TABLA SI EXISTE EN LOS MOVIMIENTOS HISTORICOS EL PAGO DE MULTIRIESGO.
     if tipo_seguro = 6 then
       begin
            --consultar duda --> que pasa si esta fue denegada es decir este en estado disinto a s en la fsh015.
            select distinct ('S'),hrubro
              into lc_variable ,rubro
              from fsh016
             where PGCOD  = ln_d602cd
               and HCMOD  = ln_d602mo
               and HSUCOR = ln_d602su
               and HTRAN  = ln_d602tr
               and HNREL  = ln_d602re
               and HFCON  = ln_d602fc
               and hrubro = 2514020000015;
          exception
            when no_data_found then
              begin
                  select y.ppcta, y.ppoper
                    into cuenta, operacion
                    from fsd602 X,
                         FSD612 Y
                   where D602CD = 1
                     and X.D602MO = ln_d602mo
                     and X.D602SU = ln_d602su
                     and X.D602TR = ln_d602tr
                     and X.D602RE = ln_d602re
                     and X.D602FC = ln_d602fc
                     and X.d602co='S'
                     and X.pp1stat='T'
                     and y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag
                     and rownum = 1;
              exception
                when no_data_found then
                 cuenta := 0;
                 operacion := 0;
              end;
              Begin
                select distinct ('S'),hrubro
                  into lc_variable,rubro
                  from fsh016
                 where PGCOD  = 1
                   and hrubro = 2514020000015
                   and hmda IN (0,101)
                   and hpap = 0
                   and hcta = cuenta
                   and HFvco  = ln_d602fc
                   and HCMOD  = 99
                   and HTRAN  = 833
                   and hoper = operacion;
              exception
                when no_data_found then
                  lc_variable := 'N';
              end;
       end;
     end if;
     ln_rubro := rubro;
end sp_verifica_transaccion;
---
procedure sp_cr_seg_vidacaja(pd_fecini in date)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso mensual de pagos de seguro vida caja.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
          --execute immediate('delete table JAQZ428');
          delete from jaqz716 where jaqz716tipseg=1 and jaqz716fecseg=pd_fecini;
          --commit;
          --proceso para generar seguro vida caja := 1
--          sp_cr_carga_job_seguro(pd_fecini,1);
          commit;
          --proceso para generar
          DBMS_LOCK.Sleep( 10 );
          ----- comprobar que termino el jobs de pagos.
          DBMS_LOCK.Sleep( 1 );
          ln_temp:=1;
          while ln_temp>0 loop
             select count(*) into ln_temp from dba_jobs where upper(what) like '%PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO(''1''%';
             if ln_temp=0 then
                exit;
             end if;
          end loop;
          commit;
end sp_cr_seg_vidacaja;
---------------------------------------------------------------------------------------------------------
---
procedure sp_cr_tipo_seguro(pd_fecini in date,tipo_seguro in number)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso mensual de pagos de seguro vida caja.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
          --execute immediate('delete table JAQZ428');
          delete from jaqz716 where jaqz716tipseg=1 and jaqz716fecseg=pd_fecini;
          --commit;
          --proceso para generar seguro vida caja := 1
--          sp_cr_carga_job_seguro(pd_fecini,tipo_seguro);
          commit;
          --proceso para generar
          DBMS_LOCK.Sleep( 10 );
          ----- comprobar que termino el jobs de pagos.
          DBMS_LOCK.Sleep( 1 );
          ln_temp:=1;
          while ln_temp>0 loop
             select count(*) into ln_temp from dba_jobs where upper(what) like '%PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO('''+tipo_seguro+'%';
             if ln_temp=0 then
                exit;
             end if;
          end loop;
          commit;
end sp_cr_tipo_seguro;
---------------------------------------------------------------------------------------------------------




procedure sp_cr_seg_familiaseg(pd_fecini in date)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso mensual de pagos de seguro vida caja.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
          delete from jaqz716 where jaqz716tipseg=4 and jaqz716fecseg=pd_fecini;
          --execute immediate('Truncate table JAQZ428');
          --execute immediate('Truncate table JAQZ428p');
          --commit;
          --proceso para generar seguro familia segura := 4
--          sp_cr_carga_job_seguro(pd_fecini,4);
          --sp_cr_altaseg_desg_diario(pd_fecini);
          commit;
          --proceso para generar la baja del seguro desgravamen, en simultaneo usando jobs.
          DBMS_LOCK.Sleep( 10 );
          ----- comprobar que termino el jobs de pagos.
          DBMS_LOCK.Sleep( 1 );
          ln_temp:=1;
          while ln_temp>0 loop
             select count(*) into ln_temp from dba_jobs where upper(what) like '%PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO(''4''%';
             if ln_temp=0 then
                exit;
             end if;
          end loop;
          commit;
end sp_cr_seg_familiaseg;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_seg_movigas(pd_fecini in date)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso mensual de pagos de seguro vida caja.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
          delete from jaqz716 where jaqz716tipseg=2 and jaqz716fecseg=pd_fecini;
          --execute immediate('Truncate table JAQZ428');
          --execute immediate('Truncate table JAQZ428p');
          --commit;
          --proceso para generar seguro movigas := 2
--          sp_cr_carga_job_seguro(pd_fecini,2);
          --sp_cr_altaseg_desg_diario(pd_fecini);
          commit;
          --proceso para generar la baja del seguro desgravamen, en simultaneo usando jobs.
          DBMS_LOCK.Sleep( 10 );
          ----- comprobar que termino el jobs de pagos.
          DBMS_LOCK.Sleep( 1 );
          ln_temp:=1;
          while ln_temp>0 loop
             select count(*) into ln_temp from dba_jobs where upper(what) like '%PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO(''2''%';
             if ln_temp=0 then
                exit;
             end if;
          end loop;
          commit;
end sp_cr_seg_movigas;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_seg_credvehic(pd_fecini in date)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_vidacaja
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.04.27
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso mensual de pagos de seguro vida caja.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
          delete from jaqz716 where jaqz716tipseg=3 and jaqz716fecseg=pd_fecini;
          --execute immediate('Truncate table JAQZ428');
          --execute immediate('Truncate table JAQZ428p');
          --commit;
          --proceso para generar seguro credito vehicular := 3
--          sp_cr_carga_job_seguro(pd_fecini,3);
          --sp_cr_altaseg_desg_diario(pd_fecini);
          commit;
          --proceso para generar .
          DBMS_LOCK.Sleep( 10 );
          ----- comprobar que termino el jobs de pagos.
          DBMS_LOCK.Sleep( 1 );
          ln_temp:=1;
          while ln_temp>0 loop
             select count(*) into ln_temp from dba_jobs where upper(what) like '%PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO(''3''%';
             if ln_temp=0 then
                exit;
             end if;
          end loop;
          commit;
end sp_cr_seg_credvehic;
---------------------------------------------------------------------------------------------------------

--- Mod.20/09/2024 SMA
procedure sp_cr_carga_job_seguro(pd_fecpro IN date) is---,tipo_seguro in number) is
-- job que permite ejecutar varias instancias en simultaneo.
     cursor seguros is
      select * from fst198 
       where tp1cod = 1 and tp1cod1 = 10884
         and tp1corr1 = 80 
       ORDER BY TP1CORR3;
       
    cursor guia is
     select * from   fst198 where tp1cod =1 and tp1cod1 = 10884 and tp1corr1 = 81;
                        
    
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     ln_cont       number(3):=0;
     lc_hostname   varchar2(64);
     x number;
     y number;
  
  BEGIN
     -- Limpiar datos anteriores
     Execute immediate('truncate table jaqz716_aux');
     Execute immediate('truncate table jaqz716');

     --Ejecutar Proceso -- 18 min aprox
     sp_carga(pd_fecpro);

     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;


   /*  y:= 1;
     while y <= 6 loop
        x:= 0;
        while  x <10  loop*/
    For y in guia loop
      for x in seguros loop
              lc_variable := ' begin '||
              'PQ_CR_CREDITOS_SEGUROS.SP_CR_SEGURO('''||y.tp1nro1||''','''||pd_fecpro||''','''||x.tp1nro1||''','''||x.tp1nro2||''');'||
                                                                  ' End; ';

              ln_cont := ln_cont +1;
              ln_job := ln_job +1;

--              if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then --pruebas DSBD1051
                IF SYS.FN_BD_ISRAC='TRUE' THEN
                      DBMS_JOB.SUBMIT(job => ln_job,
                                      what => lc_variable,
                                      next_date => sysdate+1/(24*60),
                                      interval => null,
                                      no_parse => false,
                                      instance => 1, --1 pruebas
                                      --instance => 2, 01/01/2024
                                      force => false
                                      );
              else
                    DBMS_JOB.SUBMIT(job => ln_job,
                                    what => lc_variable,
                                    next_date => sysdate+1/(24*60),
                                    interval => null,
                                    no_parse => false,
                                    instance => 1,
                                    force => false
                                    );
              end if;

              commit;
         --     x := x + 1;

        end loop;
       /* y := y + 1;*/

     end loop;

end sp_cr_carga_job_seguro;

procedure sp_consultar_pgoseg_cpto( ln_pgcod     in number,
                                    ln_modulo    in number,
                                    ln_sucursal  in number,
                                    ln_moneda    in number,
                                    ln_papel     in number,
                                    ln_cuenta    in number,
                                    ln_operacion in number,
                                    ln_suboper   in number,
                                    ln_tope      in number,
                                    ln_fpago     in date,
                                    ld_fproceso  in date,
                                    ln_codvar    in number, --pp1num
                                    lc_ctdseg    in number, -- cantidad de seguros
                                    lc_posicion  in number, -- posición
                                    lc_monto     in number, -- monto
                                    ln_flag      out varchar,
                                    ln_newmonto  out number
                                  ) is
  seguro  fsd612.pp1imp1%type;
  seguro1 fsd612.pp1imp11%type;
  seguro2 fsd612.pp1imp12%type;
  seguro3 fsd612.pp1imp13%type;
  seguro4 fsd612.pp1imp14%type;
  seguro5 fsd612.pp1imp15%type;
  pp1nump_real number;

  begin

     --Obtener todos los seguros pagados en la tabla fsd612.
      begin
         select
                sum(d.pp1imp11),
                sum(d.pp1imp12),
                sum(d.pp1imp13),
                sum(d.pp1imp14),
                sum(d.pp1imp15)
           into
                seguro1,
                seguro2,
                seguro3,
                seguro4,
                seguro5
         from  fsd612 d
         where d.pgcod   = ln_pgcod
           and d.ppmod   = ln_modulo
           and d.ppsuc   = ln_sucursal
           and d.ppmda   = ln_moneda
           and d.pppap   = ln_papel
           and d.ppcta   = ln_cuenta
           and d.ppoper  = ln_operacion
           and d.ppsbop  = ln_suboper
           and d.pptope  = ln_tope
           and d.ppfpag  = ln_fpago
           and d.ppfpag  <= ld_fproceso
           and d.pp1nump <= ln_codvar
           and exists(select pp1nump from  fsd612 d
                                       where d.pgcod   = ln_pgcod
                                         and d.ppmod   = ln_modulo
                                         and d.ppsuc   = ln_sucursal
                                         and d.ppmda   = ln_moneda
                                         and d.pppap   = ln_papel
                                         and d.ppcta   = ln_cuenta
                                         and d.ppoper  = ln_operacion
                                         and d.ppsbop  = ln_suboper
                                         and d.pptope  = ln_tope
                                         and d.ppfpag  = ln_fpago
                                         and d.ppfpag  <= ld_fproceso
                                         and d.pp1nump = ln_codvar);
      exception
        when no_Data_found then
          null;
      end;

      Begin
        select max(pp1nump)
          into pp1nump_real
          from  fsd612 d
         where d.pgcod   = ln_pgcod
           and d.ppmod   = ln_modulo
           and d.ppsuc   = ln_sucursal
           and d.ppmda   = ln_moneda
           and d.pppap   = ln_papel
           and d.ppcta   = ln_cuenta
           and d.ppoper  = ln_operacion
           and d.ppsbop  = ln_suboper
           and d.pptope  = ln_tope
           and d.ppfpag  = ln_fpago
           and d.ppfpag  <= ld_fproceso;
          if   pp1nump_real <> 0 then
           -- if pp1nump_real <> ln_codvar and pp1nump_real < ln_codvar then
               begin
                 select sum(d.pp1imp11),
                        sum(d.pp1imp12),
                        sum(d.pp1imp13),
                        sum(d.pp1imp14),
                        sum(d.pp1imp15)
                   into seguro1, seguro2, seguro3, seguro4, seguro5
                   from fsd612 d
                  where d.pgcod = ln_pgcod
                    and d.ppmod = ln_modulo
                    and d.ppsuc = ln_sucursal
                    and d.ppmda = ln_moneda
                    and d.pppap = ln_papel
                    and d.ppcta = ln_cuenta
                    and d.ppoper = ln_operacion
                    and d.ppsbop = ln_suboper
                    and d.pptope = ln_tope
                    and d.ppfpag = ln_fpago
                    and d.pp1nump <= pp1nump_real
                    and d.ppfpag  <= ld_fproceso
                    ;
               exception
                 when no_data_found then
                   null;
               end;
          --  end if;
          end if;
       exception
         when no_data_found then
              pp1nump_real := 0;
       end;


      -- Ahora extraer el seguro que corresponde a nuestro seguro y verificar si fue completamente pagado.
      begin
         ln_flag := 'N';


        if lc_posicion = 1 then
           seguro := seguro1;
        end if;

        if lc_posicion = 2 then
           seguro := seguro2;
        end if;
        if lc_posicion = 3 then
           seguro := seguro3;
        end if;
        if lc_posicion = 4 then
           seguro := seguro4;
        end if;
         --Verificamos si el seguro extraido de la fsd612 es igual al seguro de la fpp001
         -- Si son iguales significa que se ha pagado completo el seguro. se aplica para todos los seguros excepto
         -- desgravamen.
         ln_flag := 'N';
         if lc_monto = seguro OR (MOD(seguro,lc_monto) = 0)then
            ln_flag := 'S';
            ln_newmonto := seguro;
         end if;
      end;

end sp_consultar_pgoseg_cpto;
----------------------------------------------
procedure sp_valida_numsuc(P_mod  in number,
                           P_tran in number,
                           P_suc out number) is

    Cursor sucursal is
       select * from FST001 order by sucurs;
  relacion number;
Begin
       For s in sucursal loop
          select max(Nrtrel)
            into relacion
            from fsn003
           where PgCod = 1
             and Nrsuc = s.sucurs
             and Trmod = p_mod
             and Trnro = p_tran;

          if relacion < 9999 then
            p_suc := s.sucurs;
            exit;
          end if ;
       end loop;
End sp_valida_numsuc;
 procedure Validacion_VIDACAJA is
   Cursor dato_VC is
      select * from jaqz716 where jaqz716tipseg = '1'order by jaqz716cta,jaqz716oper;
 Scrub1 number;
 existe number;
 Begin
  /*  for reg in dato_VC loop
       if reg.jaqz716mda = 0 then
          Scrub1 := 2514020000008;
       else
          Scrub1 := 2524020000008;
       end if;
       Begin
          SELECT 1
            INTO EXISTE
            from fsd011 a, jaqz716 b
           where b.JAQZ716COD = a.pgcod
             and b.JAQZ716SUC = a.scsuc
             and b.JAQZ716MDA = a.scmda
             and b.JAQZ716PAP = a.scpap
             and b.JAQZ716CTA = a.sccta
             and b.JAQZ716OPER = a.scoper
             and b.JAQZ716SBOP = a.scsbop
             and b.jaqz716tipseg = '1'
             and a.sccta = reg.JAQZ716CTA
             and a.scoper = reg.JAQZ716oper
             and a.scsbop = reg.jaqz716sbop
             and a.Scmod = 260
             and a.Scrub = Scrub1 -- in (2514020000008,2524020000008)
             and a.Scsdo >= b.Jaqz716monseg
             and rownum = 1;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           EXISTE := 0;
       END;
          UPDATE JAQZ716
             SET jaqz716contt = EXISTE
           where jaqz716id = 2
             and jaqz716cod = reg.jaqz716cod
             and jaqz716suc = reg.jaqz716suc
             and jaqz716mda = reg.jaqz716mda
             and jaqz716pap = reg.jaqz716pap
             and jaqz716cta = reg.jaqz716cta
             and jaqz716oper = reg.jaqz716oper
             and jaqz716sbop = reg.jaqz716sbop
             and jaqz716tope = reg.jaqz716tope
             and jaqz716mod = reg.jaqz716mod
             and jaqz716tipseg ='1';
         commit;
   end loop;
   */
   null;
 End;
end pq_cr_creditos_seguros;
/

