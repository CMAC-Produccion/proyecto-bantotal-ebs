create or replace package PQ_CR_LISTADO is

  -- Author  : MPOSTIGOC
  -- Created : 17/05/2016 11:39:25 a.m.
  -- Purpose : 

  PROCEDURE sp_cr_listado(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------
  /* procedure sp_cr_estado(ln_pgcod     in number,
    ln_modulo    in number,
    ln_sucursal  in number,
    ln_moneda    in number,
    ln_papel     in number,
    ln_cuenta    in number,
    ln_operacion in number,
    ln_suboper   in number,
    ln_tope      in number,
  --  ld_fechpag   in date,
    ld_pd_fecini in date,
    ld_pd_fecfin in date,
    ln_monto     out number,
    ln_imp1      out number,
    ln_imp2      out number,
    ln_imp3      out number,
    ln_imp4      out number,
    ln_imp5      out number,
  --  estado       out varchar2,
    lc_mespago   out varchar2,
    lc_mescuot   out varchar2);*/
  -------------------------------------------------------------------
  procedure sp_cr_insertjaqy145(ln_pgcod     in number,
                                ln_modulo    in number,
                                ln_sucursal  in number,
                                ln_moneda    in number,
                                ln_papel     in number,
                                ln_cuenta    in number,
                                ln_operacion in number,
                                ln_suboper   in number,
                                ln_tope      in number,
                                ld_fchcuo    in date,
                                ld_fechpag   in date,
                                ln_monto     in number,
                                ln_imp1      in number,
                                ln_imp2      in number,
                                ln_imp3      in number,
                                ln_imp4      in number,
                                ln_imp5      in number);

  ----------------------------------------------------------------------
  procedure sp_cr_cliente(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number);
  -----------------------------------------------------------------------
  procedure sp_cr_datoscli (P_N_INI in number, P_N_FIN in number);
  --------------------------------------------------------------
  procedure sp_cr_jobcliente;
-----------------------------------------------------------------
procedure sp_cr_jobjaqy145(pd_fecini in date, pd_fecfin in date);  
  -------------------------------------------------------------------                         
  procedure sp_cr_llenardatosI(pd_fecini in date, pd_fecfin in date);
----------------------------------------------------------------------
  procedure sp_cr_llenardatosII;
  -------------------------------------------------------------------------
  procedure sp_cr_listadoII(pd_fecini in date, pd_fecfin in date,P_N_INI in number,P_N_FIN in number );
--------------------------------------------------------------------------
 PROCEDURE sp_cr_listado_SINVC(pd_fecini in date, pd_fecfin in date);
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoIII(pd_fecini in date, pd_fecfin in date );
 ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosSV(pd_fecini in date, pd_fecfin in date);
 --------------------------------------------------------------------------

end PQ_CR_LISTADO;
/

create or replace package body PQ_CR_LISTADO is
  ---------------------------------------------------------------

  PROCEDURE sp_cr_listado(pd_fecini in date, pd_fecfin in date) is
  
    cursor listado(pd_fecini date, pd_fecfin date) is
    
      select f.pgcod  pgcod,
             f.ppmod  modulo,
             f.ppsuc  sucursal,
             f.ppmda  moneda,
             f.pppap  papel,
             f.ppcta  cuenta,
             f.ppoper operacion,
             f.ppsbop suboper,
             f.pptope tope /*,
                                                                                                                                                 f.ppfpag fechapag*/
      
        from fsd611 f, fsd010 g, fsd602 h
       where f.ppcta = g.aocta
         and f.ppoper = g.aooper
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and h.pgcod = f.pgcod
         and h.ppmod = f.ppmod
            --and h.ppsuc
         and h.ppmda = f.ppmda
         and h.pppap = f.pppap
         and h.ppcta = f.ppcta
         and h.ppoper = f.ppoper
         and h.d602co = 'S'
         and h.d602fc between (pd_fecini) and (pd_fecfin)
         and f.ppfpag = h.ppfpag
         and ((g.aofe99 > (pd_fecini) and g.aostat = 99) or
             g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
            /*and ((ppimp11 + ppimp12 + ppimp13 + ppimp14) in (1.5, 2.5) or
                         (h.ppmda = 101 and
                         (ppimp11 + ppimp12 + ppimp13 + ppimp14) < 1))*/
         and f.ppcta <> 999999999
      -- and f.ppcta in (1180431, 1584411, 1386736)
      /*and h.d602mo = 30        and h.d602tr not in (355,356,357,358,359,360,381,390,391,392)*/
       group by f.pgcod,
                f.ppmod,
                f.ppsuc,
                f.ppmda,
                f.pppap,
                f.ppcta,
                f.ppoper,
                f.ppsbop,
                f.pptope /*,f.ppfpag*/
      
      minus (select pgcod,
                    aomod,
                    aosuc,
                    aomda,
                    aopap,
                    aocta,
                    aooper,
                    aosbop,
                    aotope
               from fpp001
               where sgcod in (116,117,118,120,121,122) --2016.07.07
              group by pgcod,
                       aomod,
                       aosuc,
                       aomda,
                       aopap,
                       aocta,
                       aooper,
                       aosbop,
                       aotope);
  
    ln_numero number := 0;
    ln_corr   number := 1;
  begin
  
    execute immediate 'truncate table jaqy144';
    --  execute immediate 'truncate table jaqy145';
  
    for i in listado(pd_fecini, pd_fecfin) loop
    
      insert into jaqy144
        (jaqy144corr,
         jaqy144pgcod,
         jaqy144mod,
         jaqy144suc,
         jaqy144mda,
         jaqy144pap,
         jaqy144cta,
         jaqy144ope,
         jaqy144sbop,
         jaqy144top)
      values
        (ln_corr,
         i.pgcod,
         i.modulo,
         i.sucursal,
         i.moneda,
         i.papel,
         i.cuenta,
         i.operacion,
         i.suboper,
         i.tope);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 500 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(jaqy144corr) into ln_corr from jaqy144;
    end;
    ln_corr := ln_corr + 1;
    ----     
  
  end sp_cr_listado;

  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoII(pd_fecini in date, pd_fecfin in date,P_N_INI in number,P_N_FIN in number ) is
  
    ln_imp1 number(10, 2);
  
    ln_imp2 number(10, 2);
    ln_imp3 number(10, 2);
    ln_imp4 number(10, 2);
    ln_imp5 number(10, 2);
    --estado     varchar2(2);
    lc_mespago varchar2(2);
    lc_mescuot varchar2(2);
    ln_monto   number(10, 2);
  
    lc_tip char(1) := null;
    pc_tip char(1) := null;
  
    ln_codvar   NUMBER;
    ln_mtoprima number(10, 2);
  
    cursor llenar is
    
      select j.jaqy144pgcod,
             j.jaqy144mod,
             j.jaqy144suc,
             j.jaqy144mda,
             j.jaqy144pap,
             j.jaqy144cta,
             j.jaqy144ope,
             j.jaqy144sbop,
             j.jaqy144top,
             j.jaqy144fchpag
        from jaqy144 j
     where jaqy144corr >= P_N_INI
         and jaqy144corr <= P_N_FIN ;
  
  begin
    for i in llenar loop
      pq_cr_vidacaja.Sp_monto_calendarioVCC(i.jaqy144pgcod,
                                            i.jaqy144mod,
                                            i.jaqy144suc,
                                            i.jaqy144mda,
                                            i.jaqy144pap,
                                            i.jaqy144cta,
                                            i.jaqy144ope,
                                            i.jaqy144sbop,
                                            i.jaqy144top,
                                            pc_tip,
                                            pd_fecfin,
                                            ln_mtoprima,
                                            ln_codvar,
                                            lc_tip);
    
    end loop;
  end sp_cr_listadoII;
  --------------------------------------------------------------------------------------------
  /*procedure sp_cr_estado(ln_pgcod     in number,
                        ln_modulo    in number,
                        ln_sucursal  in number,
                        ln_moneda    in number,
                        ln_papel     in number,
                        ln_cuenta    in number,
                        ln_operacion in number,
                        ln_suboper   in number,
                        ln_tope      in number,
                        --ld_fechpag   in date,
                        ld_pd_fecini in date,
                        ld_pd_fecfin in date,
                        ln_monto     out number,
                        ln_imp1      out number,
                        ln_imp2      out number,
                        ln_imp3      out number,
                        ln_imp4      out number,
                        ln_imp5      out number,
                        --estado       out varchar2,
                        lc_mespago   out varchar2,
                        lc_mescuot   out varchar2) is
  
   --  ld_fchpago date;
  
   lc_flag   varchar2(2) := 'N';
  
  -- ln_corr number := 1;
   -- ln_monto number(10, 2);
  
   lc_tip      char(1) := null;
   ln_mtoprima number(10, 2);
   ln_codvar number;
  
   lc_variable varchar2(2);
  
   cursor cuotas is
     select /*+ parallel(h,2)*/
  /* h.d602mo modulo,
   h.d602su sucursal,
   h.d602tr transaccion,
   h.d602re relacion,
   h.d602fc fchcontable,
   
   h.pp1stat lc_estado,
   i.ppfpag ld_fchcuo,
   h.d602fc ld_fchpago,
   to_char(to_date(i.ppfpag, 'dd/mm/rrrr'), 'MM') lc_mespago,
   to_char(to_date(ld_pd_fecini, 'dd/mm/rrrr'), 'MM') lc_mescuot,
   sum(i.pp1imp11) ln_imp1,
   sum(i.pp1imp12) ln_imp2,
   sum(i.pp1imp13) ln_imp3,
   sum(i.pp1imp14) ln_imp4,
   sum(i.pp1imp15) ln_imp5
  
    from fsd602 h, fsd612 i
   where h.d602cd = i.pgcod
     and h.d602co = 'S'
     and h.d602fc between (ld_pd_fecini) and (ld_pd_fecfin)
     and i.pgcod = h.pgcod
     and i.ppcta = h.ppcta
     and i.ppoper = h.ppoper
     and i.ppfpag = h.ppfpag
     and i.ppmod = h.ppmod
     and i.ppsuc = h.ppsuc
     and i.ppmda = h.ppmda
     and i.pppap = h.pppap
     and i.pp1nump = h.pp1nump
     and i.pgcod = ln_pgcod
     and i.ppmod = ln_modulo
     and i.ppsuc = ln_sucursal
     and i.ppmda = ln_moneda
     and i.pppap = ln_papel
     and i.ppcta = ln_cuenta
     and i.ppoper = ln_operacion
  /* and i.ppsbop = ln_suboper
                                                           and i.pptope = ln_tope*/
  /*   group by h.d602mo,
                h.d602su,
                h.d602tr,
                h.d602re,
                h.d602fc,
                h.pp1stat,
                i.ppfpag,
                h.d602fc;
  
  begin
  
    for j in cuotas loop
      lc_flag := 'N';
    
      begin
      
        select distinct ('S')
          into lc_variable
          from fsh016
         where PGCOD = 1
           and HCMOD = j.modulo
           and HSUCOR = j.sucursal
           and HTRAN = j.transaccion
           and HNREL = j.relacion
           and HFCON = j.fchcontable
           and hrubro in ('2524020000008', '2514020000008');
      exception
        when others then
          lc_variable := 'N';
        
      end;
    
      if lc_variable = 'S' then
      
        begin
        
          pq_cr_vidacaja.Sp_monto_calendarioVCC(ln_pgcod,
                                                ln_modulo,
                                                ln_sucursal,
                                                ln_moneda,
                                                ln_papel,
                                                ln_cuenta,
                                                ln_operacion,
                                                ln_suboper,
                                                ln_tope,
                                                lc_tip,
                                                j.ld_fchpago,
                                                ln_mtoprima,
                                                ln_codvar,
                                                lc_tip);
        end;
      
        
      
       
      end if;
    end loop;
  
  end sp_cr_estado;*/
  -------------------------------------------------------------------------------------------- 
  procedure sp_cr_insertjaqy145(ln_pgcod     in number,
                                ln_modulo    in number,
                                ln_sucursal  in number,
                                ln_moneda    in number,
                                ln_papel     in number,
                                ln_cuenta    in number,
                                ln_operacion in number,
                                ln_suboper   in number,
                                ln_tope      in number,
                                ld_fchcuo    in date,
                                ld_fechpag   in date,
                                ln_monto     in number,
                                ln_imp1      in number,
                                ln_imp2      in number,
                                ln_imp3      in number,
                                ln_imp4      in number,
                                ln_imp5      in number) is
    ln_corr number;
  
  begin
    begin
      select count(*) into ln_corr from jaqy145;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
    INSERT INTO JAQy145
      (Jaqy145corr,
       Jaqy145pgcod,
       Jaqy145mod,
       Jaqy145suc,
       Jaqy145mda,
       Jaqy145pap,
       Jaqy145cta,
       Jaqy145ope,
       Jaqy145sbop,
       Jaqy145top,
       JAQY145FCHCUO,
       Jaqy145fchpag,
       JAQY145IMPSG,
       Jaqy145imp1,
       Jaqy145imp2,
       Jaqy145imp3,
       Jaqy145imp4,
       Jaqy145imp5,
       JAQY145IND)
    VALUES
      (ln_corr + 1,
       ln_pgcod,
       ln_modulo,
       ln_sucursal,
       ln_moneda,
       ln_papel,
       ln_cuenta,
       ln_operacion,
       ln_suboper,
       ln_tope,
       ld_fchcuo,
       ld_fechpag,
       ln_monto,
       ln_imp1,
       ln_imp2,
       ln_imp3,
       ln_imp4,
       ln_imp5,
       'D');
  
    commit;
  
  end sp_cr_insertjaqy145;

  ------------------------------------------------------------------------------
  procedure sp_cr_cliente(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number) is
    ln_pais     number;
    ln_petdoc   number;
    ln_doc      varchar2(12);
    lc_nombre   varchar2(250);
    ld_fchnac   date;
    ld_fecha    date;
    ld_fechades date;
    estado      number;
    lc_estado   varchar2(50);
    numcre      varchar2(22);
  begin
    begin
      -- principales 
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_petdoc, ln_doc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cuenta
         and f.ttcod = 1
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    begin
      --nombre del cliente
      select f.penom
        into lc_nombre
        from fsd001 f
       where f.pepais = ln_pais
         and f.petdoc = ln_petdoc
         and f.pendoc = ln_doc;
    exception
      when others then
        null;
      
    end;
  
    begin
      --fecha de nacimiento
      select f.pffnac
        into ld_fchnac
        from fsd002 f
       where f.pfpais = ln_pais
         and f.pftdoc = ln_petdoc
         and f.pfndoc = ln_doc;
    exception
      when others then
        null;
    end;
  
    begin
      --fecha de cancelacion
      select b.aofe99
        into ld_fecha
        from FSD010 b
       where b.pgcod = ln_pgcod
         and b.aomod = ln_modulo
         and b.aosuc = ln_sucursal
         and b.aomda = ln_moneda
         and b.aopap = ln_papel
         and b.aocta = ln_cuenta
         and b.aooper = ln_operacion
         and b.aosbop = ln_suboper
         and b.aotope = ln_tope
         and b.aostat = 99;
    exception
      when others then
        NULL;
    end;
  
    begin
      --fecha de cancelacion
      select b.aofval, b.aostat
        into ld_fechades, estado
        from FSD010 b
       where b.pgcod = ln_pgcod
         and b.aomod = ln_modulo
         and b.aosuc = ln_sucursal
         and b.aomda = ln_moneda
         and b.aopap = ln_papel
         and b.aocta = ln_cuenta
         and b.aooper = ln_operacion
         and b.aosbop = ln_suboper
         and b.aotope = ln_tope;
      --    and b.aostat <> 99;
    exception
      when others then
        NULL;
    end;
  
    begin
      --fecha de cancelacion
      select f.cenom into lc_estado from fst026 f where f.cecod = estado;
      --    and b.aostat <> 99;
    exception
      when others then
        NULL;
    end;
  
    begin
    
      numcre := lpad(Trim(to_char(ln_cuenta)), 9, '0') ||
                lpad(Trim(to_char(ln_moneda)), 4, '0') ||
                lpad(Trim(to_char(ln_operacion)), 9, '0');
    end;
  
    begin
      update jaqy145 j
         set j.jaqy145tit  = lc_nombre,
             j.jaqy145doc  = ln_doc,
             j.jaqy145fnac = ld_fchnac,
             j.jaqy145fcan = ld_fecha,
             j.jaqy145fdes = ld_fechades,
             j.jaqy145est  = lc_estado,
             j.jaqy145nroc = numcre
       where j.jaqy145pgcod = ln_pgcod
         and j.jaqy145mod = ln_modulo
         and j.jaqy145suc = ln_sucursal
         and j.jaqy145mda = ln_moneda
         and j.jaqy145pap = ln_papel
         and j.jaqy145cta = ln_cuenta
         and j.jaqy145ope = ln_operacion
         and j.jaqy145sbop = ln_suboper
         and j.jaqy145top = ln_tope;
    
      commit;
    end;
  end sp_cr_cliente;
  --------------------------------------------------------------------------
  procedure sp_cr_datoscli (P_N_INI in number, P_N_FIN in number) is
  
    cursor datos is
    
      select *
        from jaqy145
       where jaqy145corr >= P_N_INI
         and jaqy145corr <= P_N_FIN;
    
  begin
    for i in datos loop
      pq_cr_listado.sp_cr_cliente(i.jaqy145pgcod,
                                  i.jaqy145mod,
                                  i.jaqy145suc,
                                  i.jaqy145mda,
                                  i.jaqy145pap,
                                  i.jaqy145cta,
                                  i.jaqy145ope,
                                  i.jaqy145sbop,
                                  i.jaqy145top);
    end loop;
  
  end sp_cr_datoscli;
-----------------------------------------------------------------------------
procedure sp_cr_jobcliente  is 
ln_ini number;
ln_fin number;
ln_divisor number:=5000;
lc_variable varchar2(1000);
ln_job number:=0;
ld_finmes date;
ln_contador number;
ln_num number:= 1;
lc_hostname varchar2(64);
 
begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

   begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', 
                                    tabname          => 'JAQY145',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

     begin
       select ceil(count(*)/ln_divisor) into ln_contador from jaqy145;
   end;       

   ln_ini := 1; 
   ln_fin := 5000;
   WHILE ln_num <= ln_contador
   LOOP
   
          
          lc_variable := 'begin '||'  PQ_CR_LISTADO.sp_cr_datoscli('||ln_ini||','||ln_fin||' );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
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

         ln_ini := ln_fin + 1;
         ln_fin := ln_ini + ln_divisor - 1;
         ln_num := ln_num + 1;
         commit;
  END LOOP;   
  
end sp_cr_jobcliente;  

----------------------------------------------------------------------------
procedure sp_cr_jobjaqy145(pd_fecini in date, pd_fecfin in date)  is 
ln_ini number;
ln_fin number;
ln_divisor number:=5000;
lc_variable varchar2(1000);
ln_job number:=0;
ld_finmes date;
ln_contador number;
ln_num number:= 1;
lc_hostname varchar2(64);

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
   begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', 
                                    tabname          => 'JAQY144',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

     begin
       select ceil(count(*)/ln_divisor) into ln_contador from jaqy144;
   end;       

   ln_ini := 1; 
   ln_fin := 5000;
   WHILE ln_num <= ln_contador
   LOOP
   
       
          lc_variable := 'begin '||'  PQ_CR_LISTADO.sp_cr_listadoII(''' || pd_fecini || ''',''' || pd_fecfin || ''','||ln_ini||','||ln_fin||' );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
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

         ln_ini := ln_fin + 1;
         ln_fin := ln_ini + ln_divisor - 1;
         ln_num := ln_num + 1;
         commit;
  END LOOP;   
  
end sp_cr_jobjaqy145;    
  

  ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosI(pd_fecini in date, pd_fecfin in date) is
  begin
  
    begin
      --- llena jaqy144 
      pq_cr_listado.sp_cr_listado(pd_fecini, pd_fecfin);
    end;
  
  
    begin
      -- llena desafiliados jaqy145
      pq_cr_listado.sp_cr_jobjaqy145(pd_fecini,pd_fecfin);
    end;
  
   /* begin
      -- completa datos jaqy145 (Afiliados y desafiliados)
        pq_cr_listado.sp_cr_jobcliente;
    end;*/
  
    commit;
  end sp_cr_llenardatosI;
----------------------------------------------------------------------------
  procedure sp_cr_llenardatosII is
  begin
  
     begin
      -- completa datos jaqy145 (Afiliados y desafiliados)
        pq_cr_listado.sp_cr_jobcliente;
    end;
  
    commit;
  end sp_cr_llenardatosII;

--------------------------------------------------------------------------
 PROCEDURE sp_cr_listado_SINVC(pd_fecini in date, pd_fecfin in date) is
  
    cursor listado(pd_fecini date, pd_fecfin date) is
    
      select f.pgcod  pgcod,
             f.ppmod  modulo,
             f.ppsuc  sucursal,
             f.ppmda  moneda,
             f.pppap  papel,
             f.ppcta  cuenta,
             f.ppoper operacion,
             f.ppsbop suboper,
             f.pptope tope /*,
                                                                                                                                                 f.ppfpag fechapag*/
      
        from fsd611 f, fsd010 g, fsd602 h
       where f.ppcta = g.aocta
         and f.ppoper = g.aooper
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and h.pgcod = f.pgcod
         and h.ppmod = f.ppmod
            --and h.ppsuc
         and h.ppmda = f.ppmda
         and h.pppap = f.pppap
         and h.ppcta = f.ppcta
         and h.ppoper = f.ppoper
         and h.d602co = 'S'
         and h.d602fc between (pd_fecini) and (pd_fecfin)
         and f.ppfpag = h.ppfpag
         and ((g.aofe99 > (pd_fecini) and g.aostat = 99) or
             g.aofe99 = to_Date('01.01.0001', 'dd.mm.yyyy'))
            /*and ((ppimp11 + ppimp12 + ppimp13 + ppimp14) in (1.5, 2.5) or
                         (h.ppmda = 101 and
                         (ppimp11 + ppimp12 + ppimp13 + ppimp14) < 1))*/
         and f.ppcta <> 999999999
       --and f.ppcta in (1231094) and f.ppoper = 2140771
       
      /*and h.d602mo = 30        and h.d602tr not in (355,356,357,358,359,360,381,390,391,392)*/
       group by f.pgcod,
                f.ppmod,
                f.ppsuc,
                f.ppmda,
                f.pppap,
                f.ppcta,
                f.ppoper,
                f.ppsbop,
                f.pptope /*,f.ppfpag*/
      
      minus (select pgcod,
                    aomod,
                    aosuc,
                    aomda,
                    aopap,
                    aocta,
                    aooper,
                    aosbop,
                    aotope
               from fpp001
               where sgcod in (116,117,118,120,121,122) --2016.07.07
              group by pgcod,
                       aomod,
                       aosuc,
                       aomda,
                       aopap,
                       aocta,
                       aooper,
                       aosbop,
                       aotope);
  
    ln_numero number := 0;
    ln_corr   number := 1;
  begin
  
  --inserta a tabla ya existente
    execute immediate 'truncate table jaqy144';
    execute immediate 'truncate table jaqy145';
  
    for i in listado(pd_fecini, pd_fecfin) loop
    
      insert into jaqy144
        (jaqy144corr,
         jaqy144pgcod,
         jaqy144mod,
         jaqy144suc,
         jaqy144mda,
         jaqy144pap,
         jaqy144cta,
         jaqy144ope,
         jaqy144sbop,
         jaqy144top)
      values
        (ln_corr,
         i.pgcod,
         i.modulo,
         i.sucursal,
         i.moneda,
         i.papel,
         i.cuenta,
         i.operacion,
         i.suboper,
         i.tope);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 500 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(jaqy144corr) into ln_corr from jaqy144;
    end;
    ln_corr := ln_corr + 1;
    ----     
  
  end sp_cr_listado_SINVC;
----------------------------------------------------------------------------  
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_listadoIII(pd_fecini in date, pd_fecfin in date ) is
  
    ln_imp1 number(10, 2);
  
    ln_imp2 number(10, 2);
    ln_imp3 number(10, 2);
    ln_imp4 number(10, 2);
    ln_imp5 number(10, 2);
    --estado     varchar2(2);
    lc_mespago varchar2(2);
    lc_mescuot varchar2(2);
    ln_monto   number(10, 2);
  
    lc_tip char(1) := null;
    pc_tip char(1) := null;
  
    ln_codvar   NUMBER;
    ln_mtoprima number(10, 2);
  
    cursor llenar is
    
      select j.jaqy144pgcod,
             j.jaqy144mod,
             j.jaqy144suc,
             j.jaqy144mda,
             j.jaqy144pap,
             j.jaqy144cta,
             j.jaqy144ope,
             j.jaqy144sbop,
             j.jaqy144top,
             j.jaqy144fchpag
        from jaqy144 j;
  
  begin
    for i in llenar loop
      pq_cr_vidacaja.Sp_monto_calendarioSVC(i.jaqy144pgcod,
                                            i.jaqy144mod,
                                            i.jaqy144suc,
                                            i.jaqy144mda,
                                            i.jaqy144pap,
                                            i.jaqy144cta,
                                            i.jaqy144ope,
                                            i.jaqy144sbop,
                                            i.jaqy144top,
                                            pc_tip,
                                            pd_fecfin,
                                            ln_mtoprima,
                                            ln_codvar,
                                            lc_tip);
    
    end loop;
  end sp_cr_listadoIII;
  --------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------
  procedure sp_cr_llenardatosSV(pd_fecini in date, pd_fecfin in date) is
  begin
  
    begin
      --- llena jaqy144 
      pq_cr_listado.sp_cr_listado_SINVC(pd_fecini, pd_fecfin);
    end;
  
  
    begin
      pq_cr_listado.sp_cr_listadoiii(pd_fecini => pd_fecini,
                                     pd_fecfin => pd_fecfin);
    end;
  
  
  
    commit;
  end sp_cr_llenardatosSV;
----------------------------------------------------------------------------
   
end PQ_CR_LISTADO;
/

