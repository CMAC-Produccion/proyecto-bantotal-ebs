create or replace package PQ_CR_TASAS_CAMP_NOVA is

  -- Author  : MPOSTIGOC
  -- Created : 18/01/2021 1:36:52 p. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_PizaJAQZ697(ln_cuenta in number);
  ----------------------------------------------------------
  procedure sp_cr_elimpiza(ln_cuenta in number);

end PQ_CR_TASAS_CAMP_NOVA;
/

create or replace package body PQ_CR_TASAS_CAMP_NOVA is

  procedure sp_cr_PizaJAQZ697(ln_cuenta in number) is
    -- Carga de PIzarras 
  
    cursor listado_027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.aqpa372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mn in (0, 101)
         and q.aqpa372pp = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372ct = ln_cuenta;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mn in (0, 101)
         and q.aqpa372pp = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372ct = ln_cuenta;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mn in (0, 101)
         and q.aqpa372pp = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372ct = ln_cuenta;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
      
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1) + 7 --mpostigoc 12.10.2020
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
                  -- and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 --  t.plazo,
                 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     -- t.plazo,
                     99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    end if;
  end;

  ----------------------------------------------------
  procedure sp_cr_elimpiza(ln_cuenta in number) is
  
  begin
  
    delete from fsd027 f
     where f.pgcod = 1
       and f.ctnro = ln_cuenta
       and f.tpfdes > to_date('4/01/2021', 'DD/MM/YYYY');
  
    delete from fsr027 f
     where f.pgcod = 1
       and f.ctnro = ln_cuenta
       and f.tpfdes > to_date('4/01/2021', 'DD/MM/YYYY');
  
    delete from fsd327 f
     where f.vt1pgcod = 1
       and f.vt1ctnr = ln_cuenta
       and f.vt1tpfd > to_date('4/01/2021', 'DD/MM/YYYY');
  
  end;

end PQ_CR_TASAS_CAMP_NOVA;
/

