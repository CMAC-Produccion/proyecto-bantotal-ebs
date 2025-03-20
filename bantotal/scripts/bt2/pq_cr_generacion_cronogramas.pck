create or replace package pq_cr_generacion_cronogramas is

  -- Author  : CHERNANDEZ
  -- Created : 17/09/2020 18:28:30
  -- Purpose : 
  procedure sp_inicio;
  procedure sp_inicializa(pd_pgfape out date);
  procedure sp_actualiza_estado(pd_pgfape date);
  procedure sp_tipo_rep;
  procedure sp_actualiza_vigencia;
  procedure sp_actualiza_otros_estados;
  procedure sp_capital_disparejo;
  procedure sp_capital_disparejo_lineas;
  procedure sp_verifica_cuotas(pd_pgfape date);
  procedure sp_insert_aqpb010(pd_pgfape date);
  procedure sp_exportar_data;
end pq_cr_generacion_cronogramas;
/

create or replace package body pq_cr_generacion_cronogramas is
  procedure sp_inicio is
    ld_pgfape date;
  begin
    --select pgfape into ld_pgfape from fst017 where pgcod = 1;
    pq_cr_generacion_cronogramas.sp_inicializa(ld_pgfape);
    pq_cr_generacion_cronogramas.sp_actualiza_estado(ld_pgfape);
    pq_cr_generacion_cronogramas.sp_tipo_rep();
    pq_cr_generacion_cronogramas.sp_actualiza_vigencia();
    pq_cr_generacion_cronogramas.sp_actualiza_otros_estados();
    pq_cr_generacion_cronogramas.sp_capital_disparejo();
    pq_cr_generacion_cronogramas.sp_capital_disparejo_lineas();
    pq_cr_generacion_cronogramas.sp_verifica_cuotas(ld_pgfape);
    --pq_cr_generacion_cronogramas.sp_insert_aqpb010(ld_pgfape);
    commit;
  end sp_inicio;
  procedure sp_inicializa(pd_pgfape out date) is
  
    cursor creditos is
      select aqpb013emp aoemp,
             aqpb013mod aomod,
             aqpb013suc aosuc,
             aqpb013mda aomda,
             aqpb013pap aopap,
             aqpb013cta aocta,
             aqpb013ope aoope,
             aqpb013sbo aosbo,
             aqpb013top aotop,
             aqpb013fep fecha
        from aqpb013
       where aqpb013est = 'A';
  
    /*cursor creditos is
    select aqpb002emp aoemp,
           aqpb002mod aomod,
           aqpb002suc aosuc,
           aqpb002mda aomda,
           aqpb002pap aopap,
           aqpb002cta aocta,
           aqpb002ope aoope,
           aqpb002sbo aosbo,
           aqpb002top aotop
      from aqpb002
     where aqpb002est = 'C'
       and nvl(aqpb002revr, 'N') = 'N'
       and aqpb002fep >= pd_fecini
       and aqpb002fep <= pd_fecfin
    
    union
    
    select jaqz698emp,
           jaqz698mod,
           jaqz698suc,
           jaqz698mda,
           jaqz698pap,
           jaqz698cta,
           jaqz698ope,
           jaqz698sbo,
           jaqz698top
    
      from jaqz698
     where jaqz698est = 'C'
       and jaqz698fep >= pd_fecini
       and jaqz698fep <= pd_fecfin
    
    union
    
    select jaqa255emp,
           jaqa255mod,
           jaqa255suc,
           jaqa255mda,
           jaqa255pap,
           jaqa255cta,
           jaqa255ope,
           jaqa255sbo,
           jaqa255tpo
    
      from jaqa255
     where jaqa255est = 'L'
       and jaqa255fec >= pd_fecini
       and jaqa255fec <= pd_fecfin
    
    union
    
    select pgcod,
           aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope
    
      from fsd010
     where pgcod = 1
       and aofval >= pd_fecini
       and aofval <= pd_fecfin
       and (pgcod, aosuc, aomod, aomda, aopap, aocta, aooper, aosbop,
            aotope) in
           (select xwfempresa,
                   xwfsucursal,
                   xwfmodulo,
                   xwfmoneda,
                   xwfpapel,
                   xwfcuenta,
                   xwfoperacion,
                   xwfsubope,
                   xwftipope
              from xwf700 d
             where xwfprcins in
                   (select sng001inst
                      from sng001
                     where sng001ori in (13, 14)
                       and sng001fin >= to_date('15/03/2020', 'dd/mm/yyyy'))
               and exists (select *
                      from xwf070 a
                     where a.xwfprcin = d.xwfprcins
                       and a.xwfcont = 'S')
               and xwfcar3 = '1');*/
  
    ln_existe numeric(3);
    ln_estado numeric(3);
    lx_aosuc  numeric(3);
    lx_sbop   numeric(9);
    lx_top    numeric(3);
    --ld_fecape date;
  begin
    --select pgfape into ld_fecape from fst017 where pgcod = 1;
    --cambia a O los que no se llegaron a procesar
    update aqpb009
       set aqpb009est = 'O', aqpb009usr = to_char(pd_pgfape)
     where aqpb009est = 'C'
       and aqpb009narc is null;
    commit;
  
    for i in creditos loop
      pd_pgfape := i.fecha;
      ln_existe := 0;
      select nvl(count(*), 0)
        into ln_existe
        from aqpb009
       where aqpb009emp = i.aoemp
         and aqpb009mod in (select modulo from fst111 where dscod = 50)
         and aqpb009mda = i.aomda
         and aqpb009pap = i.aopap
         and aqpb009cta = i.aocta
         and aqpb009ope = i.aoope;
    
      if ln_existe > 0 then
        --inicializa los creditos que ya existen en la aqpb009
        update aqpb009
           set aqpb009TPO    = null,
               aqpb009ase    = null,
               aqpb009mail   = null,
               aqpb009tea1   = null,
               aqpb009tea2   = null,
               aqpb009tcea1  = null,
               aqpb009tcea2  = null,
               aqpb009usr    = to_char(pd_pgfape, 'dd/mm/yyyy'),
               aqpb009hoi    = null,
               aqpb009hof    = null,
               aqpb009narc   = null,
               aqpb009fmail  = null,
               aqpb009rub    = null,
               aqpb009tcea3  = null,
               aqpb009mtodes = null,
               aqpb009cuot   = null,
               aqpb009fecd   = null,
               aqpb009pzo    = null,
               aqpb009fopag  = null,
               aqpb009mtore  = null,
               aqpb009pzoac  = null,
               aqpb009cuotac = null,
               aqpb009frepac = null,
               aqpb009est    = 'C'
         where aqpb009emp = i.aoemp
           and aqpb009mod in (select modulo from fst111 where dscod = 50)
           and aqpb009mda = i.aomda
           and aqpb009pap = i.aopap
           and aqpb009cta = i.aocta
           and aqpb009ope = i.aoope;
      
        commit;
      else
        --inserta registros no existentes en la aqpb009
        --Obtener dato vigente desde fsd010
        ln_estado := 1;
      
        begin
          select t.aosuc, t.aosbop, t.aotope
            into lx_aosuc, lx_sbop, lx_top
            from fsd010 t
           where t.pgcod = i.aoemp
             and t.aomod = i.aomod
             and t.aomda = i.aomda
             and t.aopap = i.aopap
             and t.aocta = i.aocta
             and t.aooper = i.aoope
             and t.aomod in
                 (select u.modulo from fst111 u where u.dscod = 50)
             and t.aostat <> 99;
        exception
          when others then
            ln_estado := 0;
        end;
      
        if ln_estado = 0 then
        
          begin
          
            select f.suc, f.sbop, f.top
              into lx_aosuc, lx_sbop, lx_top
              from (select x.aosuc suc, max(x.aosbop) sbop, x.aotope top
                    
                      from fsd010 x
                     where x.pgcod = i.aoemp
                       and x.aomod = i.aomod
                       and x.aomda = i.aomda
                       and x.aopap = i.aopap
                       and x.aocta = i.aocta
                       and x.aooper = i.aoope
                       and x.aomod in
                           (select u.modulo from fst111 u where u.dscod = 50)
                     group by x.aosuc, x.aotope
                     order by sbop desc) f
             where rownum = 1;
          
            ln_estado := 1;
          
          exception
            when others then
              ln_estado := 0;
          end;
        
        end if;
      
        if ln_estado = 1 then
        
          begin
            -- Call the procedure
            pq_cr_historico_pagos_dia.sp_verificar_cronograma(pn_pgcod  => i.aoemp,
                                                              pn_aomod  => i.aomod,
                                                              pn_aosuc  => lx_aosuc,
                                                              pn_aomda  => i.aomda,
                                                              pn_aopap  => i.aopap,
                                                              pn_aocta  => i.aocta,
                                                              pn_aooper => i.aoope,
                                                              pn_aosbop => lx_sbop,
                                                              pn_aotope => lx_top,
                                                              pn_estado => 'C');
          end;
        
        end if;
      
      end if;
    
    end loop;
    commit;
  end sp_inicializa;

  procedure sp_actualiza_estado(pd_pgfape date) is
    --actualiza estado duplicado y cancelado
    cursor creditos is
      select aqpb009emp,
             aqpb009mod,
             aqpb009suc,
             aqpb009mda,
             aqpb009pap,
             aqpb009cta,
             aqpb009ope,
             aqpb009sbo,
             aqpb009top,
             aqpb009est,
             aqpb009tref
        from aqpb009 a
       where a.aqpb009est = 'C'
         and aqpb009narc is null;
  
    ln_aostat number(2);
  BEGIN
    for i in creditos loop
    
      begin
        select aostat
          into ln_aostat
          from fsd010 f
         where f.PGCOD = i.aqpb009emp
           and f.AOMOD = i.aqpb009mod
              --and f.AOSUC = i.aqpb009suc
           and f.AOMDA = i.aqpb009mda
           and f.AOPAP = i.aqpb009pap
           and f.AOCTA = i.aqpb009cta
           and f.AOOPER = i.aqpb009ope
              --and f.AOSBOP = i.aqpb009sbo
              --and f.AOTOPE = i.aqpb009top
           and f.aostat <> 99;
      
        --
      
        update aqpb009 a
           set a.AQPB009ESTCR = ln_aostat,
               a.aqpb009usr   = to_char(pd_pgfape, 'dd/mm/yyyy')
         where a.aqpb009emp = i.aqpb009emp
           and a.aqpb009mod = i.aqpb009mod
           and a.aqpb009suc = i.aqpb009suc
           and a.aqpb009mda = i.aqpb009mda
           and a.aqpb009pap = i.aqpb009pap
           and a.aqpb009cta = i.aqpb009cta
           and a.aqpb009ope = i.aqpb009ope
           and a.aqpb009sbo = i.aqpb009sbo
           and a.aqpb009top = i.aqpb009top;
        commit;
      
      exception
        when TOO_MANY_ROWS then
          update aqpb009 a
             set a.aqpb009est = 'D',
                 a.aqpb009usr = to_char(pd_pgfape, 'dd/mm/yyyy')
           where a.aqpb009emp = i.aqpb009emp
             and a.aqpb009mod = i.aqpb009mod
             and a.aqpb009suc = i.aqpb009suc
             and a.aqpb009mda = i.aqpb009mda
             and a.aqpb009pap = i.aqpb009pap
             and a.aqpb009cta = i.aqpb009cta
             and a.aqpb009ope = i.aqpb009ope
             and a.aqpb009sbo = i.aqpb009sbo
             and a.aqpb009top = i.aqpb009top;
          commit;
          --dbms_output.put_line('Duplicado: ' || i.aqpb009cta);
        when NO_DATA_FOUND then
          update aqpb009 a
             set a.aqpb009est = 'X',
                 a.aqpb009usr = to_char(pd_pgfape, 'dd/mm/yyyy')
           where a.aqpb009emp = i.aqpb009emp
             and a.aqpb009mod = i.aqpb009mod
             and a.aqpb009suc = i.aqpb009suc
             and a.aqpb009mda = i.aqpb009mda
             and a.aqpb009pap = i.aqpb009pap
             and a.aqpb009cta = i.aqpb009cta
             and a.aqpb009ope = i.aqpb009ope
             and a.aqpb009sbo = i.aqpb009sbo
             and a.aqpb009top = i.aqpb009top;
          commit;
          --dbms_output.put_line('No data: ' || i.aqpb009cta);
        --null;
        When others then
          update aqpb009 a
             set a.aqpb009est = 'O',
                 a.aqpb009usr = to_char(pd_pgfape, 'dd/mm/yyyy')
           where a.aqpb009emp = i.aqpb009emp
             and a.aqpb009mod = i.aqpb009mod
             and a.aqpb009suc = i.aqpb009suc
             and a.aqpb009mda = i.aqpb009mda
             and a.aqpb009pap = i.aqpb009pap
             and a.aqpb009cta = i.aqpb009cta
             and a.aqpb009ope = i.aqpb009ope
             and a.aqpb009sbo = i.aqpb009sbo
             and a.aqpb009top = i.aqpb009top;
          commit;
          --dbms_output.put_line('Others: ' || i.aqpb009cta);
      end;
    
    end loop;
  
  end sp_actualiza_estado;

  procedure sp_tipo_rep is
  
    cursor creditos is
      select *
        from aqpb009 a
       where a.aqpb009est = 'C'
         and aqpb009narc is null;
  
    ld_fecha date;
    lv_tipo  varchar2(10);
    --ln_tasa  number(10, 6);
    --ln_stat  number(2);
    lv_rpta varchar2(1);
    --lc_flag  varchar2(1);
  begin
  
    for i in creditos loop
      begin
        select fecha, tipo
          into ld_fecha, lv_tipo
          from (
                
                select *
                  from (select aqpb002fep fecha, 'CONGEL' tipo
                           from aqpb002
                          where aqpb002emp = i.aqpb009emp
                            and aqpb002mod = i.aqpb009mod
                            and aqpb002suc = i.aqpb009suc
                            and aqpb002mda = i.aqpb009mda
                            and aqpb002pap = i.aqpb009pap
                            and aqpb002cta = i.aqpb009cta
                            and aqpb002ope = i.aqpb009ope
                            and aqpb002sbo = i.aqpb009sbo
                            and aqpb002top = i.aqpb009top
                            and aqpb002est = 'C'
                            and nvl(aqpb002revr, 'N') = 'N'
                         
                         union all
                         select jaqz698fep, 'RECONO'
                           from jaqz698
                          where jaqz698emp = i.aqpb009emp
                            and jaqz698mod = i.aqpb009mod
                            and jaqz698suc = i.aqpb009suc
                            and jaqz698mda = i.aqpb009mda
                            and jaqz698pap = i.aqpb009pap
                            and jaqz698cta = i.aqpb009cta
                            and jaqz698ope = i.aqpb009ope
                            and jaqz698sbo = i.aqpb009sbo
                            and jaqz698top = i.aqpb009top
                            and jaqz698est = 'C'
                         union all
                         select jaqa255fec, 'CAPIMA'
                           from jaqa255
                          where jaqa255emp = i.aqpb009emp
                            and jaqa255mod = i.aqpb009mod
                               --and jaqa255suc = i.aqpb009suc
                            and jaqa255mda = i.aqpb009mda
                            and jaqa255pap = i.aqpb009pap
                            and jaqa255cta = i.aqpb009cta
                            and jaqa255ope = i.aqpb009ope
                            and jaqa255sbo = i.aqpb009sbo - 1
                            and jaqa255tpo = i.aqpb009top
                            and jaqa255est = 'L'
                         
                         union all
                         
                         select aofval, 'CAPIAG'
                           from fsd010
                          where pgcod = i.aqpb009emp
                            and aosuc = i.aqpb009suc
                            and aomod = i.aqpb009mod
                            and aomda = i.aqpb009mda
                            and aopap = i.aqpb009pap
                            and aocta = i.aqpb009cta
                            and aooper = i.aqpb009ope
                            and aosbop = i.aqpb009sbo
                            and aotope = i.aqpb009top
                            and (pgcod, aosuc, aomod, aomda, aopap, aocta,
                                 aooper, aosbop, aotope) in
                                (select xwfempresa,
                                        xwfsucursal,
                                        xwfmodulo,
                                        xwfmoneda,
                                        xwfpapel,
                                        xwfcuenta,
                                        xwfoperacion,
                                        xwfsubope,
                                        xwftipope
                                   from xwf700 d
                                  where xwfprcins in
                                        (select sng001inst
                                           from sng001
                                          where sng001ori in (13, 14)
                                            and sng001fin >=
                                                to_date('15/03/2020',
                                                        'dd/mm/yyyy'))
                                    and exists
                                  (select *
                                           from xwf070 a
                                          where a.xwfprcin = d.xwfprcins
                                            and a.xwfcont = 'S')
                                    and xwfcar3 = '1'))
                 order by fecha desc
                
                )
         where rownum = 1;
      exception
        when others then
          ld_Fecha := null;
          lv_tipo  := '';
      end;
    
      lv_rpta := 'N';
      sp_cr_verificar_reprogramado(i.aqpb009emp,
                                   i.aqpb009mod,
                                   i.aqpb009suc,
                                   i.aqpb009mda,
                                   i.aqpb009pap,
                                   i.aqpb009cta,
                                   i.aqpb009ope,
                                   i.aqpb009sbo,
                                   i.aqpb009top,
                                   lv_rpta);
    
      update aqpb009
         set aqpb009TPO   = lv_tipo,
             aqpb009ase   = ld_fecha,
             aqpb009mail  = lv_rpta,
             aqpb009tea1  = null,
             aqpb009tea2  = null,
             aqpb009tcea1 = null,
             aqpb009tcea2 = null,
             --aqpb009usr    = null,
             aqpb009hoi    = null,
             aqpb009hof    = null,
             aqpb009narc   = null,
             aqpb009fmail  = null,
             aqpb009rub    = null,
             aqpb009tcea3  = null,
             aqpb009mtodes = null,
             aqpb009cuot   = null,
             aqpb009fecd   = null,
             aqpb009pzo    = null,
             aqpb009fopag  = null,
             aqpb009mtore  = null,
             aqpb009pzoac  = null,
             aqpb009cuotac = null,
             aqpb009frepac = null
      
       where aqpb009emp = i.aqpb009emp
         and aqpb009mod = i.aqpb009mod
         and aqpb009suc = i.aqpb009suc
         and aqpb009mda = i.aqpb009mda
         and aqpb009pap = i.aqpb009pap
         and aqpb009cta = i.aqpb009cta
         and aqpb009ope = i.aqpb009ope
         and aqpb009sbo = i.aqpb009sbo
         and aqpb009top = i.aqpb009top
         and aqpb009fep = i.aqpb009fep
         and aqpb009cor = i.aqpb009cor;
      commit;
    
    end loop;
  end sp_tipo_rep;

  ----PASO 2 script 3
  --actualiza a vigentes aqpb009
  procedure sp_actualiza_vigencia is
  
    --lc_fecha_ini date;
    --lc_fecha_fin date;
    lx_aosuc number;
    lx_sbop  number;
    lc_flag  char(1);
    lx_top   number(4);
  
    --Cursor INDIVIDUALES
    cursor cur_repro_fsh016 is
    
      select distinct b.aqpb066fep,
                      b.aqpb066cor,
                      b.aqpb066emp,
                      b.aqpb066mod,
                      b.aqpb066suc,
                      b.aqpb066mda,
                      b.aqpb066pap,
                      b.aqpb066cta,
                      b.aqpb066ope,
                      b.aqpb066sbo,
                      b.aqpb066top
        from aqpb066 b;
  
  Begin
  
    begin
    
      --1. Eliminar data auxiliar 
      delete from AQPB066;
      commit;
    
      --2. Inserción de data auxiliar
      insert into AQPB066
        (aqpb066fep,
         aqpb066cor,
         aqpb066emp,
         aqpb066mod,
         aqpb066suc,
         aqpb066mda,
         aqpb066pap,
         aqpb066cta,
         aqpb066ope,
         aqpb066sbo,
         aqpb066top,
         aqpb066tref)
        select aqpb009fep,
               aqpb009cor,
               aqpb009emp,
               aqpb009mod,
               aqpb009suc,
               aqpb009mda,
               aqpb009pap,
               aqpb009cta,
               aqpb009ope,
               aqpb009sbo,
               aqpb009top,
               'OTROS'
        
          from aqpb009 a
         where a.aqpb009est = 'C'
           and a.aqpb009narc is null
           and not exists (select *
                  from fsd010 b
                 where pgcod = a.aqpb009emp
                   and aomod = a.aqpb009mod
                   and aosuc = a.aqpb009suc
                   and aomda = a.aqpb009mda
                   and aopap = a.aqpb009pap
                   and aocta = a.aqpb009cta
                   and aooper = a.aqpb009ope
                   and aosbop = a.aqpb009sbo
                   and aotope = a.aqpb009top
                   and b.AOSTAT <> 99)
        minus
        select aqpb009fep,
               aqpb009cor,
               aqpb009emp,
               aqpb009mod,
               aqpb009suc,
               aqpb009mda,
               aqpb009pap,
               aqpb009cta,
               aqpb009ope,
               aqpb009sbo,
               aqpb009top,
               'OTROS'
        
          from aqpb009 a
         where a.aqpb009est = 'C'
           and a.aqpb009narc is null
           and not exists (select *
                  from fsd010 b
                 where pgcod = a.aqpb009emp
                   and aomod = a.aqpb009mod
                      --and aosuc = a.aqpb009suc
                   and aomda = a.aqpb009mda
                   and aopap = a.aqpb009pap
                   and aocta = a.aqpb009cta
                   and aooper = a.aqpb009ope
                      --and aosbop = a.aqpb009sbo 
                      --and aotope = a.aqpb009top
                   and b.AOSTAT <> 99);
      commit;
    
      ---Recurrido cursor JAQZ698
      for i in cur_repro_fsh016 loop
      
        lc_flag := 'S';
      
        begin
          -- Obtener la sucursal y suboperación vigente
          select t.aosuc, t.aosbop, t.AOTOPE
            into lx_aosuc, lx_sbop, lx_top
            from fsd010 t
           where t.pgcod = i.aqpb066emp
             and t.aomod = i.aqpb066mod
             and
                --t.aosuc = i.aqpb066suc and
                 t.aomda = i.aqpb066mda
             and t.aopap = i.aqpb066pap
             and t.aocta = i.aqpb066cta
             and t.aooper = i.aqpb066ope
             and
                --t.aosbop = i.aqpb066sbop and
                --t.aotope = i.aqpb066top and
                 t.aomod in
                 (select u.modulo from fst111 u where u.dscod = 50)
             and t.aostat <> 99;
        exception
          when others then
            lc_flag := 'N';
        end;
      
        if (lx_sbop <> i.aqpb066sbo or lx_aosuc <> i.aqpb066suc or
           lx_top <> i.aqpb066top) and lc_flag = 'S' then
        
          update aqpb060 t
             set t.aqpb060aosuc  = lx_aosuc,
                 t.aqpb060aosbop = lx_sbop,
                 t.aqpb060aotop  = lx_top
           where t.aqpb060pgcod = i.aqpb066emp
             and t.aqpb060aomod = i.aqpb066mod
             and t.aqpb060aosuc = i.aqpb066suc
             and t.aqpb060aomda = i.aqpb066mda
             and t.aqpb060aopap = i.aqpb066pap
             and t.aqpb060aocta = i.aqpb066cta
             and t.aqpb060aooper = i.aqpb066ope
             and t.aqpb060aosbop = i.aqpb066sbo
             and t.aqpb060aotop = i.aqpb066top;
          commit;
        
          update aqpb061 t
             set t.aqpb061suc  = lx_aosuc,
                 t.aqpb061sbop = lx_sbop,
                 t.aqpb061tope = lx_top
           where t.aqpb061pgcod = i.aqpb066emp
             and t.aqpb061mod = i.aqpb066mod
             and t.aqpb061suc = i.aqpb066suc
             and t.aqpb061mda = i.aqpb066mda
             and t.aqpb061pap = i.aqpb066pap
             and t.aqpb061cta = i.aqpb066cta
             and t.aqpb061oper = i.aqpb066ope
             and t.aqpb061sbop = i.aqpb066sbo
             and t.aqpb061tope = i.aqpb066top;
          commit;
        
          update aqpb062 t
             set t.aqpb062suc  = lx_aosuc,
                 t.aqpb062sbop = lx_sbop,
                 t.aqpb062tope = lx_top
           where t.aqpb062pgcod = i.aqpb066emp
             and t.aqpb062mod = i.aqpb066mod
             and t.aqpb062suc = i.aqpb066suc
             and t.aqpb062mda = i.aqpb066mda
             and t.aqpb062pap = i.aqpb066pap
             and t.aqpb062cta = i.aqpb066cta
             and t.aqpb062oper = i.aqpb066ope
             and t.aqpb062sbop = i.aqpb066sbo
             and t.aqpb062tope = i.aqpb066top;
          commit;
        
          update aqpb063 t
             set t.aqpb063suc  = lx_aosuc,
                 t.aqpb063sbop = lx_sbop,
                 t.aqpb063tope = lx_top
           where t.aqpb063pgcod = i.aqpb066emp
             and t.aqpb063mod = i.aqpb066mod
             and t.aqpb063suc = i.aqpb066suc
             and t.aqpb063mda = i.aqpb066mda
             and t.aqpb063pap = i.aqpb066pap
             and t.aqpb063cta = i.aqpb066cta
             and t.aqpb063oper = i.aqpb066ope
             and t.aqpb063sbop = i.aqpb066sbo
             and t.aqpb063tope = i.aqpb066top;
          commit;
        
          update aqpa973 t
             set t.aqpa973suc  = lx_aosuc,
                 t.aqpa973sbop = lx_sbop,
                 t.aqpa973tope = lx_top
           where t.aqpa973cod = i.aqpb066emp
             and t.aqpa973mod = i.aqpb066mod
             and t.aqpa973suc = i.aqpb066suc
             and t.aqpa973mda = i.aqpb066mda
             and t.aqpa973pap = i.aqpb066pap
             and t.aqpa973cta = i.aqpb066cta
             and t.aqpa973oper = i.aqpb066ope
             and t.aqpa973sbop = i.aqpb066sbo
             and t.aqpa973tope = i.aqpb066top;
          commit;
        
          update aqpa974 t
             set t.aqpa974suc  = lx_aosuc,
                 t.aqpa974sbop = lx_sbop,
                 t.aqpa974tope = lx_top
           where t.aqpa974pgcod = i.aqpb066emp
             and t.aqpa974mod = i.aqpb066mod
             and t.aqpa974suc = i.aqpb066suc
             and t.aqpa974mda = i.aqpb066mda
             and t.aqpa974pap = i.aqpb066pap
             and t.aqpa974cta = i.aqpb066cta
             and t.aqpa974oper = i.aqpb066ope
             and t.aqpa974sbop = i.aqpb066sbo
             and t.aqpa974tope = i.aqpb066top;
          commit;
        
          update aqpa975 t
             set t.aqpa975suc  = lx_aosuc,
                 t.aqpa975sbop = lx_sbop,
                 t.aqpa975tope = lx_top
           where t.aqpa975cod = i.aqpb066emp
             and t.aqpa975mod = i.aqpb066mod
             and t.aqpa975suc = i.aqpb066suc
             and t.aqpa975mda = i.aqpb066mda
             and t.aqpa975pap = i.aqpb066pap
             and t.aqpa975cta = i.aqpb066cta
             and t.aqpa975oper = i.aqpb066ope
             and t.aqpa975sbop = i.aqpb066sbo
             and t.aqpa975tope = i.aqpb066top;
          commit;
        
          update aqpb009 t
             set t.aqpb009suc = lx_aosuc,
                 t.aqpb009sbo = lx_sbop,
                 t.aqpb009top = lx_top
           where t.aqpb009fep = i.aqpb066fep
             and t.aqpb009cor = i.aqpb066cor
             and t.aqpb009emp = i.aqpb066emp
             and t.aqpb009mod = i.aqpb066mod
             and t.aqpb009suc = i.aqpb066suc
             and t.aqpb009mda = i.aqpb066mda
             and t.aqpb009pap = i.aqpb066pap
             and t.aqpb009cta = i.aqpb066cta
             and t.aqpb009ope = i.aqpb066ope
             and t.aqpb009sbo = i.aqpb066sbo
             and t.aqpb009top = i.aqpb066top;
          commit;
        
        end if;
      
      end loop;
    
      -- Eliminado de data auxiliar
      delete from AQPB066;
      commit;
    
    end;
  
  end sp_actualiza_vigencia;

  --script 4
  --actualiza otros estados
  procedure sp_actualiza_otros_estados is
  begin
    --
    update aqpb009
       set aqpb009est = 'J'
     where aqpb009est = 'C'
       and aqpb009estcr = '33'
       and aqpb009narc is null;
    --Refinanciados sin reprogr ultima subop
    update aqpb009
       set aqpb009est = 'B'
     where aqpb009est = 'C'
       and AQPB009TPO is null
       and aqpb009estcr = '61'
       and aqpb009narc is null;
    --prendarios que no tienen rep en subop vigente 
    update aqpb009
       set aqpb009est = 'P'
     where aqpb009est = 'C'
       and AQPB009TPO is null
       and aqpb009estcr not in ('61', '33')
       and aqpb009sbo <> 0
       and aqpb009mod = 108
       and aqpb009narc is null;
    --creditos extornados
    update aqpb009
       set aqpb009est = 'E'
     where aqpb009est = 'C'
       and AQPB009TPO is null
       and aqpb009estcr not in ('61', '33')
       and aqpb009mod <> 108
       and aqpb009sbo = 0
       and aqpb009narc is null;
    --creditos pjm que no tienen rep en subop vigente 
    update aqpb009
       set aqpb009est = 'K'
     where aqpb009est = 'C'
       and AQPB009TPO is null
       and aqpb009estcr not in ('61', '33')
       and aqpb009mod <> 108
       and aqpb009sbo <> 0
       and aqpb009narc is null;
    commit;
  end sp_actualiza_otros_estados;

  --script 5
  procedure sp_capital_disparejo is
  begin
    update aqpb009
       set aqpb009est = 'F'
     where (aqpb009emp, aqpb009mod, aqpb009suc, aqpb009mda, aqpb009pap,
            aqpb009cta, aqpb009ope, aqpb009sbo, aqpb009top) in
           (select aqpb009emp,
                   aqpb009mod,
                   aqpb009suc,
                   aqpb009mda,
                   aqpb009pap,
                   aqpb009cta,
                   aqpb009ope,
                   aqpb009sbo,
                   aqpb009top
              from aqpb009 a
             where aqpb009mod <> 116
               and aqpb009est = 'C'
               and aqpb009narc is null
               and (select sum(ppcap)
                      from fsd601
                     where pgcod = aqpb009emp
                       and ppcta = aqpb009cta
                       and ppoper = aqpb009ope
                       and ppsbop = aqpb009sbo
                       and ppmod = aqpb009mod
                       and ppsuc = aqpb009suc
                       and ppmda = aqpb009mda
                       and pppap = aqpb009pap
                       and pptope = aqpb009top
                       and d601co = 'S') -
                   (select sum(pp1cap)
                      from fsd602
                     where pgcod = aqpb009emp
                       and ppcta = aqpb009cta
                       and ppoper = aqpb009ope
                       and ppsbop = aqpb009sbo
                       and ppmod = aqpb009mod
                       and ppsuc = aqpb009suc
                       and ppmda = aqpb009mda
                       and pppap = aqpb009pap
                       and pptope = aqpb009top
                       and d602co = 'S'
                       and (pp1cap > 0 or pp1salmor = 0)) +
                   (select sum(scsdo)
                      from fsd011
                     where pgcod = aqpb009emp
                       and scsuc = aqpb009suc
                       and scmda = aqpb009mda
                       and scpap = aqpb009pap
                       and sccta = aqpb009cta
                       and scoper = aqpb009ope
                       and scsbop = aqpb009sbo
                       and sctope = aqpb009top
                       and scmod = aqpb009mod
                       and scmod in
                           (select modulo from fst111 where dscod = 50)) <> 0);
  
    commit;
  
  end sp_capital_disparejo;

  --script 6
  procedure sp_capital_disparejo_lineas is
  begin
  
    update aqpb009
       set aqpb009est = 'G'
    
     where (aqpb009emp, aqpb009mod, aqpb009suc, aqpb009mda, aqpb009pap,
            aqpb009cta, aqpb009ope, aqpb009sbo, aqpb009top) in
           (select aqpb009emp,
                   aqpb009mod,
                   aqpb009suc,
                   aqpb009mda,
                   aqpb009pap,
                   aqpb009cta,
                   aqpb009ope,
                   aqpb009sbo,
                   aqpb009top
              from aqpb009 a
             where aqpb009mod = 116
               and aqpb009est = 'C'
               and aqpb009narc is null
               and (select sum(ppcap)
                      from fsd601
                     where pgcod = aqpb009emp
                       and ppcta = aqpb009cta
                       and ppoper = aqpb009ope
                       and ppsbop = aqpb009sbo
                       and ppmod = aqpb009mod
                       and ppsuc = aqpb009suc
                       and ppmda = aqpb009mda
                       and pppap = aqpb009pap
                       and pptope = aqpb009top
                       and d601co = 'S') -
                   (select sum(pp1cap)
                      from fsd602
                     where pgcod = aqpb009emp
                       and ppcta = aqpb009cta
                       and ppoper = aqpb009ope
                       and ppsbop = aqpb009sbo
                       and ppmod = aqpb009mod
                       and ppsuc = aqpb009suc
                       and ppmda = aqpb009mda
                       and pppap = aqpb009pap
                       and pptope = aqpb009top
                       and d602co = 'S'
                       and (pp1cap > 0 or pp1salmor = 0)) +
                   (select sum(scsdo)
                      from fsd011
                     where pgcod = aqpb009emp
                       and scsuc = aqpb009suc
                       and scmda = aqpb009mda
                       and scpap = aqpb009pap
                       and sccta = aqpb009cta
                       and scoper = aqpb009ope
                       and scsbop = aqpb009sbo
                       and sctope = aqpb009top
                       and scmod = aqpb009mod
                       and scmod in
                           (select modulo from fst111 where dscod = 50)) <> 0);
  
    commit;
  
  end sp_capital_disparejo_lineas;

  procedure sp_verifica_cuotas(pd_pgfape date) is
    cursor creditos is
      select *
        from aqpb009
       where aqpb009est = 'C'
         and aqpb009narc is null;
  
    cursor fsd601(pn_pgcod  in number,
                  pn_aomod  in number,
                  pn_aosuc  in number,
                  pn_aomda  in number,
                  pn_aopap  in number,
                  pn_aocta  in number,
                  pn_aooper in number,
                  pn_aosbop in number,
                  pn_aotope in number) is
      select *
        from fsd601 d
       where pgcod = pn_pgcod
         and ppmod = pn_aomod
         and ppsuc = pn_aosuc
         and ppmda = pn_aomda
         and pppap = pn_aopap
         and ppcta = pn_aocta
         and ppoper = pn_aooper
         and ppsbop = pn_aosbop
         and pptope = pn_aotope
         and d.d601co = 'S'
       order by ppfpag;
  
    interes      numeric(18, 2);
    dias         numeric(5);
    capital      numeric(18, 2);
    capacu       numeric(18, 2);
    fecha        date;
    tasa         numeric(10, 6);
    saldocapital numeric(18, 2);
    intCalc      numeric(18, 2);
    cantidad     numeric(10);
    lv_mes       varchar2(2);
    lv_ano       varchar2(4);
    --ld_pgfape    date;
  begin
    cantidad := 0;
    for i in creditos loop
      for j in 1 .. 3 loop
        select lpad(to_char(add_months(pd_pgfape, j), 'MM'), 2, '0'),
               lpad(to_char(add_months(pd_pgfape, j), 'YYYY'), 4, '0')
          into lv_mes, lv_ano
          from dual;
      
        begin
          interes := 0;
          dias    := 0;
          fecha   := null;
          begin
            select a.ppint, a.ppfpag - a.ppfval, a.ppfpag
              into interes, dias, fecha
              from fsd601 a
             where pgcod = i.aqpb009emp
               and ppmod = i.aqpb009mod
               and ppsuc = i.aqpb009suc
               and ppmda = i.aqpb009mda
               and pppap = i.aqpb009pap
               and ppcta = i.aqpb009cta
               and ppoper = i.aqpb009ope
               and ppsbop = i.aqpb009sbo
               and pptope = i.aqpb009top
               and to_char(a.ppfpag, 'MM') = lv_mes
               and to_char(a.ppfpag, 'YYYY') = lv_ano
               and a.d601co = 'S'
               and a.pptipo = 'M';
            capital := 0;
            capacu  := 0;
            for j in fsd601(i.aqpb009emp,
                            i.aqpb009mod,
                            i.aqpb009suc,
                            i.aqpb009mda,
                            i.aqpb009pap,
                            i.aqpb009cta,
                            i.aqpb009ope,
                            i.aqpb009sbo,
                            i.aqpb009top) loop
              capital := capital + j.ppcap;
              if j.ppfpag < fecha then
                capacu := capacu + j.ppcap;
              end if;
            end loop;
            tasa := 0;
            select aotasa
              into tasa
              from fsd010
             where pgcod = i.aqpb009emp
               and aomod = i.aqpb009mod
               and aosuc = i.aqpb009suc
               and aomda = i.aqpb009mda
               and aopap = i.aqpb009pap
               and aocta = i.aqpb009cta
               and aooper = i.aqpb009ope
               and aosbop = i.aqpb009sbo
               and aotope = i.aqpb009top;
            begin
              select a.evtasa
                into tasa
                from fsd012 a
               where pgcod = i.aqpb009emp
                 and aomod = i.aqpb009mod
                 and aosuc = i.aqpb009suc
                 and aomda = i.aqpb009mda
                 and aopap = i.aqpb009pap
                 and aocta = i.aqpb009cta
                 and aooper = i.aqpb009ope
                 and aosbop = i.aqpb009sbo
                 and aotope = i.aqpb009top
                 and a.evtipo = 3
                 and a.d012co = 'S'
                 and a.evcorr = (select max(evcorr)
                                   from fsd012
                                  where pgcod = i.aqpb009emp
                                    and aomod = i.aqpb009mod
                                    and aosuc = i.aqpb009suc
                                    and aomda = i.aqpb009mda
                                    and aopap = i.aqpb009pap
                                    and aocta = i.aqpb009cta
                                    and aooper = i.aqpb009ope
                                    and aosbop = i.aqpb009sbo
                                    and aotope = i.aqpb009top
                                    and evtipo = 3
                                    and d012co = 'S');
            exception
              when others then
                null;
            end;
          
            saldocapital := capital - capacu;
          
            select (POWER((1 + (tasa / 100)), dias / 360) - 1) *
                   saldocapital
              into intCalc
              from dual;
            --        (((1 + tasa / 100) ^(dias / 360)) - 1) * saldocapital
          
            if intCalc <> interes then
              cantidad := cantidad + 1;
              insert into aqpb007g
                (aqpb007fep,
                 aqpb007cor,
                 aqpb007emp,
                 aqpb007mod,
                 aqpb007suc,
                 aqpb007mda,
                 aqpb007pap,
                 aqpb007cta,
                 aqpb007ope,
                 aqpb007sbo,
                 aqpb007top,
                 aqpb007intca,
                 aqpb007inter)
              values
                (pd_pgfape,
                 j,
                 i.aqpb009emp,
                 i.aqpb009mod,
                 i.aqpb009suc,
                 i.aqpb009mda,
                 i.aqpb009pap,
                 i.aqpb009cta,
                 i.aqpb009ope,
                 i.aqpb009sbo,
                 i.aqpb009top,
                 intCalc,
                 interes);
              commit;
              /*dbms_output.put_line('Cuenta ' || i.aqpb009cta || ' - ' ||
                                   i.aqpb009ope);
              dbms_output.put_line('Interes ' || intCalc || ' - ' || interes);*/
            end if;
          exception
            when others then
              /*dbms_output.put_line('Error ' || i.aqpb009cta || ' - ' ||
                                   i.aqpb009ope);
              dbms_output.put_line('Error no hay cuota');*/
              null;
          end;
        exception
          when others then
            /*dbms_output.put_line('Error ' || i.aqpb009cta || ' - ' ||
                                 i.aqpb009ope);
            dbms_output.put_line('Error ' || tasa || ' - ' || dias || ' - ' ||
                                 saldocapital);*/
            null;
        end;
      end loop;
    end loop;
    dbms_output.put_line('contador ' || cantidad);
    update aqpb009
       set aqpb009est = 'H'
     where (aqpb009emp, aqpb009mod, aqpb009suc, aqpb009mda, aqpb009pap,
            aqpb009cta, aqpb009ope, aqpb009sbo, aqpb009top) in
           (select aqpb007emp,
                   aqpb007mod,
                   aqpb007suc,
                   aqpb007mda,
                   aqpb007pap,
                   aqpb007cta,
                   aqpb007ope,
                   aqpb007sbo,
                   aqpb007top
              from aqpb007g a
             where a.aqpb007fep = pd_pgfape)
       and aqpb009est = 'C'
       and aqpb009narc is null;
  end sp_verifica_cuotas;

  procedure sp_insert_aqpb010(pd_pgfape date) is
    --previo a ejecutar el paqpb012
    --cuotas disparejas
  
    cursor creditos is
      select *
        from aqpb009
       where aqpb009est = 'H'
         and (aqpb009cta, aqpb009ope) in
             (select aqpb007cta, aqpb007ope
                from aqpb007g
               where aqpb007fep = pd_pgfape);
  
    ln_tasa     number(10, 6);
    ln_tasa10   number(10, 6);
    pd_fec      date;
    pd_fecvalor date;
    ld_fval     date;
    ln_stat     number(2);
    --lv_hora     varchar(8);
    ln_r2cod  number(3);
    ln_r2mod  number(3);
    ln_r2suc  number(3);
    ln_r2mda  number(4);
    ln_r2pap  number(4);
    ln_r2cta  number(9);
    ln_r2oper number(9);
    ln_r2sbop number(3);
    ln_r2tope number(3);
  
  begin
    --Cuotas distintas - capital correcto PAQPB012
    for i in creditos loop
      ln_tasa     := 0;
      ln_tasa10   := 0;
      ld_fval     := null;
      pd_fec      := null;
      ln_stat     := 0;
      pd_fecvalor := null;
      ln_r2cod    := 0;
      ln_r2mod    := 0;
      ln_r2suc    := 0;
      ln_r2mda    := 0;
      ln_r2pap    := 0;
      ln_r2cta    := 0;
      ln_r2oper   := 0;
      ln_r2sbop   := 0;
      ln_r2tope   := 0;
    
      --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
      ----dbms_output.put_line('lv_hora1: ' || lv_hora);
      --tasa vigente ln_tasa
      begin
        select evtasa
          into ln_tasa
          from fsd012
         where pgcod = i.aqpb009emp
           and aomod = i.aqpb009mod
           and aosuc = i.aqpb009suc
           and aomda = i.aqpb009mda
           and aopap = i.aqpb009pap
           and aocta = i.aqpb009cta
           and aooper = i.aqpb009ope
           and aosbop = i.aqpb009sbo
           and aotope = i.aqpb009top
           and evtipo = 3
           and d012co = 'S'
           and evcorr = (select max(a.evcorr)
                           from fsd012 a
                          where pgcod = i.aqpb009emp
                            and a.aomod = i.aqpb009mod
                            and a.aosuc = i.aqpb009suc
                            and a.aomda = i.aqpb009mda
                            and a.aopap = i.aqpb009pap
                            and a.aocta = i.aqpb009cta
                            and a.aooper = i.aqpb009ope
                            and a.aosbop = i.aqpb009sbo
                            and a.aotope = i.aqpb009top
                            and a.evtipo = 3
                            and a.d012co = 'S');
      exception
        when others then
          null;
      end;
      --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
      --dbms_output.put_line('lv_hora2: ' || lv_hora);
    
      begin
        select aotasa, aofval, aostat
          into ln_tasa10, ld_fval, ln_stat
          from fsd010
         where pgcod = i.aqpb009emp
           and aomod = i.aqpb009mod
           and aosuc = i.aqpb009suc
           and aomda = i.aqpb009mda
           and aopap = i.aqpb009pap
           and aocta = i.aqpb009cta
           and aooper = i.aqpb009ope
           and aosbop = i.aqpb009sbo
           and aotope = i.aqpb009top;
      exception
        when others then
          ln_tasa10 := 0;
          ld_fval   := null;
      end;
    
      --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
      --dbms_output.put_line('lv_hora3: ' || lv_hora);
    
      If ln_stat <> 99 then
        if i.aqpb009mod = 116 then
          begin
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_r2cod,
                   ln_r2mod,
                   ln_r2suc,
                   ln_r2mda,
                   ln_r2pap,
                   ln_r2cta,
                   ln_r2oper,
                   ln_r2sbop,
                   ln_r2tope
              from fsr011
             where relcod = 46
               and r1cod = i.aqpb009emp
               and r1mod = i.aqpb009mod
               and r1suc = i.aqpb009suc
               and r1mda = i.aqpb009mda
               and r1pap = i.aqpb009pap
               and r1cta = i.aqpb009cta
               and r1oper = i.aqpb009ope
               and r1sbop = i.aqpb009sbo
               and r1tope = i.aqpb009top;
          
            select aotasa
              into ln_tasa
              from fsd010
             where ln_r2cod = pgcod
               and ln_r2mod = aomod
               and ln_r2suc = aosuc
               and ln_r2mda = aomda
               and ln_r2pap = aopap
               and ln_r2cta = aocta
               and ln_r2oper = aooper
               and ln_r2sbop = aosbop
               and ln_r2tope = aotope;
          
          exception
            when others then
              ln_tasa := null;
          end;
        
          --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
          --dbms_output.put_line('lv_hora4: ' || lv_hora);
        
        end if;
        if ln_tasa is null or ln_tasa = 0 then
          ln_tasa := ln_tasa10;
        end if;
      
        --fecha valor primera cuota pendiente
      
        begin
          select min(a.ppfpag)
            into pd_fec
            from fsd601 a
           where pgcod = i.aqpb009emp
             and ppmod = i.aqpb009mod
             and ppsuc = i.aqpb009suc
             and ppmda = i.aqpb009mda
             and pppap = i.aqpb009pap
             and ppcta = i.aqpb009cta
             and ppoper = i.aqpb009ope
             and ppsbop = i.aqpb009sbo
             and pptope = i.aqpb009top
             and d601co = 'S'
             and not exists (select *
                    from fsd602 b
                   where b.pgcod = a.pgcod
                     and b.ppmod = a.ppmod
                     and b.ppsuc = a.ppsuc
                     and b.ppmda = a.ppmda
                     and b.pppap = a.pppap
                     and b.ppcta = a.ppcta
                     and b.ppoper = a.ppoper
                     and b.ppsbop = a.ppsbop
                     and b.pptope = a.pptope
                     and b.ppfpag = a.ppfpag
                     and b.d602co = 'S');
        exception
          when others then
            pd_fec := null;
        end;
      
        --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
        --dbms_output.put_line('lv_hora5: ' || lv_hora);
      
        if pd_fec is not null then
        
          pd_fecvalor := null;
          begin
            select min(a.ppfval)
              into pd_fecvalor
              from fsd601 a
             where pgcod = i.aqpb009emp
               and ppmod = i.aqpb009mod
               and ppsuc = i.aqpb009suc
               and ppmda = i.aqpb009mda
               and pppap = i.aqpb009pap
               and ppcta = i.aqpb009cta
               and ppoper = i.aqpb009ope
               and ppsbop = i.aqpb009sbo
               and pptope = i.aqpb009top
               and ppfpag = pd_fec
               and d601co = 'S';
          exception
            when others then
              pd_fecvalor := ld_fval;
          end;
        
          --select to_char(sysdate, 'HH24:MI:SS') into lv_hora from dual;
          --dbms_output.put_line('lv_hora6: ' || lv_hora);
        
          if pd_fecvalor is null then
            pd_fecvalor := ld_fval;
          end if;
          /*dbms_output.put_line('aqpb010cta: ' || i.aqpb009cta);
          dbms_output.put_line('aqpb010ope: ' || i.aqpb009ope);
          dbms_output.put_line('pd_fecvalor: ' || pd_fecvalor);
          dbms_output.put_line('aqpb009top: ' || i.aqpb009top);
          dbms_output.put_line('ln_tasa: ' || ln_tasa);
          dbms_output.put_line('----------------');*/
          insert into AQPB010
            (aqpb010emp,
             aqpb010mod,
             aqpb010suc,
             aqpb010mda,
             aqpb010pap,
             aqpb010cta,
             aqpb010ope,
             aqpb010sbo,
             aqpb010tpo,
             aqpb010fec,
             aqpb010fre,
             aqpb010fpg,
             aqpb010est,
             aqpb010tas,
             aqpb010ta1)
          values
            (i.aqpb009emp,
             i.aqpb009mod,
             i.aqpb009suc,
             i.aqpb009mda,
             i.aqpb009pap,
             i.aqpb009cta,
             i.aqpb009ope,
             i.aqpb009sbo,
             i.aqpb009top,
             pd_pgfape,
             pd_fecvalor,
             pd_fecvalor,
             'A',
             ln_tasa,
             ln_tasa);
          commit;
        else
          update aqpb009
             set aqpb009est = 'Q'
           where aqpb009fep = i.aqpb009fep
             and aqpb009cor = i.aqpb009cor
             and aqpb009emp = i.aqpb009emp
             and aqpb009mod = i.aqpb009mod
             and aqpb009suc = i.aqpb009suc
             and aqpb009mda = i.aqpb009mda
             and aqpb009pap = i.aqpb009pap
             and aqpb009cta = i.aqpb009cta
             and aqpb009ope = i.aqpb009ope
             and aqpb009sbo = i.aqpb009sbo
             and aqpb009top = i.aqpb009top;
          commit;
          /*dbms_output.put_line('HORROR1');
          dbms_output.put_line('aqpb010cta: ' || i.aqpb009cta);
          dbms_output.put_line('aqpb010ope: ' || i.aqpb009ope);
          dbms_output.put_line('----------------');*/
        end if;
      else
      
        update aqpb009
           set aqpb009est = 'Q'
         where aqpb009fep = i.aqpb009fep
           and aqpb009cor = i.aqpb009cor
           and aqpb009emp = i.aqpb009emp
           and aqpb009mod = i.aqpb009mod
           and aqpb009suc = i.aqpb009suc
           and aqpb009mda = i.aqpb009mda
           and aqpb009pap = i.aqpb009pap
           and aqpb009cta = i.aqpb009cta
           and aqpb009ope = i.aqpb009ope
           and aqpb009sbo = i.aqpb009sbo
           and aqpb009top = i.aqpb009top;
        commit;
        /*dbms_output.put_line('HORROR2');
        dbms_output.put_line('aqpb010cta: ' || i.aqpb009cta);
        dbms_output.put_line('aqpb010ope: ' || i.aqpb009ope);
        dbms_output.put_line('----------------');*/
      end if;
    end loop;
  End sp_insert_aqpb010;
  procedure sp_exportar_data is
    cursor creditos is
      select distinct to_date(trim(a.aqpb009usr), 'dd/mm/yyyy') FECHA,
                      (select b.petdoc
                         from fsr008 b
                        where b.pgcod = 1
                          and b.ctnro = a.aqpb009cta
                          and b.cttfir = 'T') NDOC,
                      (select trim(b.pendoc)
                         from fsr008 b
                        where b.pgcod = 1
                          and b.ctnro = a.aqpb009cta
                          and b.cttfir = 'T') DOCUMENTO,
                      trim(a.aqpb009narc) archivo,
                      LPAD(ROUND(dbms_random.value() * 999999), 6, '0') CLAVE,
                      a.aqpb009cta,
                      a.aqpb009ope,
                      a.aqpb009sbo
      
        from aqpb009 a
       where AQPB009NARC is not null
         and AQPB009EST = 'C'
         and (AQPB009EMP, AQPB009CTA, AQPB009OPE) in
             (SELECT AQPB013EMP, AQPB013CTA, AQPB013OPE
                FROM AQPB013
               where AQPB013EST = 'A');
  begin
    for i in creditos loop
    
      update AQPB013 a
         set AQPB013est  = 'C',
             aqpb013fej  = trunc(sysdate),
             aqpb013hor  = to_char(sysdate, 'hh24:mi:ss'),
             aqpb013tpo  = i.NDOC,
             aqpb013ndo  = i.documento,
             aqpb013narc = i.archivo,
             aqpb013cla  = i.clave
      
       where AQPB013est = 'A'
         and a.aqpb013cta = i.aqpb009cta
         and a.aqpb013ope = i.aqpb009ope
         and a.aqpb013sbo = i.aqpb009sbo
         and a.aqpb013fep = i.fecha;
      commit;
    end loop;
    update AQPB013 a set AQPB013est = 'E' where AQPB013est = 'A';
    commit;
  end sp_exportar_data;
end pq_cr_generacion_cronogramas;
/

