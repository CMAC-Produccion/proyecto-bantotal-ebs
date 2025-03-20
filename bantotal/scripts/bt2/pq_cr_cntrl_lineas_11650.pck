create or replace package PQ_CR_CNTRL_LINEAS_11650 is

  -- Author  : MPOSTIGOC
  -- Created : 14/08/2023 09:52:56
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_inicio(ln_pgcodt  in number,
                         ln_suct    in number,
                         ln_modt    in number,
                         ln_ttran   in number,
                         ln_relt    in number,
                         ln_ordt    in number,
                         lc_pcancel out varchar2,
                         lc_Mensaje out varchar2);

end PQ_CR_CNTRL_LINEAS_11650;
/

create or replace package body PQ_CR_CNTRL_LINEAS_11650 is

  procedure sp_cr_inicio(ln_pgcodt  in number,
                         ln_suct    in number,
                         ln_modt    in number,
                         ln_ttran   in number,
                         ln_relt    in number,
                         ln_ordt    in number,
                         lc_pcancel out varchar2,
                         lc_Mensaje out varchar2) is
  
    ln_pgcod117      number;
    ln_mod117        number;
    ln_suc117        number;
    ln_mda117        number;
    ln_pap117        number;
    ln_cta117        number;
    ln_ope117        number;
    ln_sub117        number;
    ln_tope117       number;
    ln_CantDispVignt number;
    ln_instancia     number;
    ln_Exceptuado    number;
  
  begin
  
    lc_pcancel := 'N';
    lc_Mensaje := '';
  
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope
        into ln_pgcod117,
             ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_ope117,
             ln_sub117,
             ln_tope117
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt;
    exception
      when others then
        null;
    end;
  
    begin
      ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_ope117,
                                           v_Scsbop => ln_sub117,
                                           v_Sctope => ln_tope117);
    exception
      when others then
        ln_instancia := 0;
    end;
  
    begin
      select count(*)
        into ln_Exceptuado
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 123
         and f.tp1corr2 = 1
         and f.tp1corr3 > 0
         and f.tp1imp1 = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if ln_Exceptuado = 0 then
    
      begin
        select count(*)
          into ln_CantDispVignt
          from fsr011 f, fsd010 g
         where f.r1cod = g.pgcod
           and f.r1mod = g.aomod
           and f.r1suc = g.aosuc
           and f.r1mda = g.aomda
           and f.r1pap = g.aopap
           and f.r1cta = g.aocta
           and f.r1oper = g.aooper
           and f.r1sbop = g.aosbop
           and f.r1tope = g.aotope
           and f.r2cod = ln_pgcod117
           and f.r2mod = ln_mod117
           and f.r2suc = ln_suc117
           and f.r2mda = ln_mda117
           and f.r2pap = ln_pap117
           and f.r2cta = ln_cta117
           and f.r2oper = ln_ope117
           and f.r2sbop = ln_sub117
           and f.r2tope = ln_tope117
           and f.relcod = 46
           and g.aostat = 0;
      exception
        when others then
          null;
        
      end;
    
      if ln_CantDispVignt > 0 then
      
        begin
          select F.MNTXT
            into lc_Mensaje
            from fst702 F
           where MnIdiom = 'ES'
             and MnCod = 98831;
        exception
          when others then
            lc_Mensaje := 'La linea tiene una disposición vigente, ingresar por la tx 116/60';
        end;
      
        lc_pcancel := 'S';
      
      else
        lc_pcancel := 'N';
        lc_Mensaje := '';
      end if;
    
    else
    
      lc_pcancel := 'N';
      lc_Mensaje := '';
    
    end if;
  end sp_cr_inicio;

end PQ_CR_CNTRL_LINEAS_11650;
/

