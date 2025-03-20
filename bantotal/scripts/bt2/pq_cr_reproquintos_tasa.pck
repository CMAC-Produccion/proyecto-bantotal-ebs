create or replace package PQ_CR_REPROQUINTOS_TASA is

  -- Author  : MPOSTIGOC
  -- Created : 13/11/2020 7:28:39 p. m.
  -- Purpose : 

  procedure sp_cr_inicio(ln_instancia in number,
                         ld_fecha     in date,
                         ln_tasaorig  in number);
  -----------------------------------------------------
  procedure sp_cr_AQPA386(ln_inst  in number,
                          ld_FECHA in date,
                          ln_PGCOD in number,
                          ln_MOD   in number,
                          ln_SUC   in number,
                          ln_MDA   in number,
                          ln_PAP   in number,
                          ln_CTA   in number,
                          ln_OPE   in number,
                          ln_SBO   in number,
                          ln_TOP   in number,
                          ln_tori  in number,
                          ln_NCUO  in number,
                          ld_FCUO  in date,
                          ln_TASA  in number);
  -----------------------------------------------
  procedure sp_cr_ExtornaDesemb(PPgcod    in number,
                                Pitmod    in number,
                                PItsuc    in number,
                                PIttran   in number,
                                PItnrel   in number,
                                ld_FchExt in date);

end PQ_CR_REPROQUINTOS_TASA;
/

create or replace package body PQ_CR_REPROQUINTOS_TASA is

  procedure sp_cr_inicio(ln_instancia in number,
                         ld_fecha     in date,
                         ln_tasaorig  in number) is
  
    cursor cuotas(ln_pgcod    number,
                  ln_modulo   number,
                  ln_sucursal number,
                  ln_moneda   number,
                  ln_papel    number,
                  ln_cta      number,
                  ln_oper     number,
                  ln_suboper  number,
                  ln_tope     number) is
      select *
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cta
         and f.ppoper = ln_oper
         and f.ppsbop = ln_suboper
         and f.pptope = ln_tope;
  
    ln_pgcod     number := 0;
    ln_modulo    number := 0;
    ln_sucursal  number := 0;
    ln_moneda    number := 0;
    ln_papel     number := 0;
    ln_cta       number := 0;
    ln_oper      number := 0;
    ln_suboper   number := 0;
    ln_tope      number := 0;
    ln_nrocuotas number := 0;
    ln_tasadesmb number(14, 6) := 0.000;
    ln_PriQnt    number(10);
    ln_SegQnt    number(10);
    ln_TrcQnt    number(10);
    ln_CrtQnt    number(10);
    ld_FchPriQnt date;
    ld_FchSegQnt date;
    ld_FchTrcQnt date;
    ld_FchCrtQnt date;
    ln_tasadsct  number(14, 6) := 0.0000;
    ln_TasaPriQ  number(14, 6) := 0.0000;
    ln_TasaSegQ  number(14, 6) := 0.0000;
    ln_TasaTrcQ  number(14, 6) := 0.0000;
    ln_TasaCrtQ  number(14, 6) := 0.0000;
  
    x         number := 1;
    ln_factor number(10, 2);
    --  ln_TasaOrig number(14, 6);
    -- ld_fecha date;
  
  begin
  
    begin
      update aqpa386b a
         set a.aqpa386est = 'I'
       where a.aqpa386inst = ln_instancia
         and a.aqpa386est = 'H';
    end;
  
    begin
      select y.xwfempresa,
             y.xwfmodulo,
             y.xwfsucursal,
             y.xwfmoneda,
             y.xwfpapel,
             y.xwfcuenta,
             y.xwfoperacion,
             y.xwfsubope,
             y.xwftipope
        into ln_pgcod,
             ln_modulo,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cta,
             ln_oper,
             ln_suboper,
             ln_tope
        from xwf700 y
       where y.xwfprcins = ln_instancia
         and y.xwfcar3 = '1';
    exception
      when others then
        null;
      
    end;
  
    if ln_cta is not null then
    
      begin
        select x.xllcantcuo, x.xlltasap
          into ln_nrocuotas, ln_tasadesmb
          from x054023 x
         where x.xllpgcod = ln_pgcod
           and x.xllaomod = ln_modulo
           and x.xllaosuc = ln_sucursal
           and x.xllaomda = ln_moneda
           and x.xllaopap = ln_papel
           and x.xllaocta = ln_cta
           and x.xllaooper = ln_oper
           and x.xllaosbop = ln_suboper
           and x.xllaotop = ln_tope;
      exception
        when others then
          ln_nrocuotas := 0;
      end;
    
      ln_PriQnt := (ln_nrocuotas * 1 / 5);
      ln_SegQnt := (ln_nrocuotas * 2 / 5);
      ln_TrcQnt := (ln_nrocuotas * 3 / 5);
      ln_CrtQnt := (ln_nrocuotas * 4 / 5);
    
      -- Obtenemos la tasa original, consideramos el valor dl primer quinto 
      -- porque con ese dscto lo mando BI
      begin
        select a.aqpa385dsct
          into ln_tasadsct
          from aqpa385 a
         where a.aqpa385quinto = 15
           and a.aqpa385dsd <= ln_tasadesmb
           and a.aqpa385hst >= ln_tasadesmb;
      exception
        when others then
          ln_tasadsct := 0;
      end;
    
      if ln_tasadsct > 0 then
      
        ln_factor := (100 - ln_tasadsct) / 100;
        --ln_TasaOrig := (ln_tasadesmb / ln_factor);
      
        for c in cuotas(ln_pgcod,
                        ln_modulo,
                        ln_sucursal,
                        ln_moneda,
                        ln_papel,
                        ln_cta,
                        ln_oper,
                        ln_suboper,
                        ln_tope) loop
        
          if x = ln_PriQnt then
            ld_FchPriQnt := c.ppfpag;
            begin
              -- Obtenemos la tasa del primer quinto
              begin
                select a.aqpa385dsct
                  into ln_tasadsct
                  from aqpa385 a
                 where a.aqpa385quinto = 25
                   and a.aqpa385dsd <= ln_TasaOrig
                   and a.aqpa385hst >= ln_TasaOrig;
              exception
                when others then
                  ln_tasadsct := 0;
              end;
            
              ln_factor   := (100 - ln_tasadsct) / 100;
              ln_TasaPriQ := round(ln_TasaOrig * ln_factor, 6);
            end;
          
            begin
              PQ_CR_REPROQUINTOS_TASA.sp_cr_AQPA386(ln_inst  => ln_instancia,
                                                    ld_FECHA => ld_fecha,
                                                    ln_PGCOD => ln_pgcod,
                                                    ln_MOD   => ln_modulo,
                                                    ln_SUC   => ln_sucursal,
                                                    ln_MDA   => ln_moneda,
                                                    ln_PAP   => ln_papel,
                                                    ln_CTA   => ln_cta,
                                                    ln_OPE   => ln_oper,
                                                    ln_SBO   => ln_suboper,
                                                    ln_TOP   => ln_tope,
                                                    ln_tori  => ln_tasaorig,
                                                    ln_NCUO  => ln_PriQnt,
                                                    ld_FCUO  => ld_FchPriQnt,
                                                    ln_TASA  => ln_TasaPriQ);
            end;
          
          else
            if x = ln_SegQnt then
              ld_FchSegQnt := c.ppfpag;
              begin
                -- Obtenemos la tasa del segundo quinto
                begin
                  select a.aqpa385dsct
                    into ln_tasadsct
                    from aqpa385 a
                   where a.aqpa385quinto = 35
                     and a.aqpa385dsd <= ln_TasaOrig
                     and a.aqpa385hst >= ln_TasaOrig; -- MPOSTIGOC 08.03.2021
                exception
                  when others then
                    ln_tasadsct := 0;
                end;
              
                ln_factor   := (100 - ln_tasadsct) / 100;
                ln_TasaSegQ := round(ln_TasaOrig * ln_factor, 6);
              end;
            
              begin
                PQ_CR_REPROQUINTOS_TASA.sp_cr_AQPA386(ln_inst  => ln_instancia,
                                                      ld_FECHA => ld_fecha,
                                                      ln_PGCOD => ln_pgcod,
                                                      ln_MOD   => ln_modulo,
                                                      ln_SUC   => ln_sucursal,
                                                      ln_MDA   => ln_moneda,
                                                      ln_PAP   => ln_papel,
                                                      ln_CTA   => ln_cta,
                                                      ln_OPE   => ln_oper,
                                                      ln_SBO   => ln_suboper,
                                                      ln_TOP   => ln_tope,
                                                      ln_tori  => ln_tasaorig,
                                                      ln_NCUO  => ln_SegQnt,
                                                      ld_FCUO  => ld_FchSegQnt,
                                                      ln_TASA  => ln_TasaSegQ);
              end;
            
            else
              if x = ln_TrcQnt then
                ld_FchTrcQnt := c.ppfpag;
                begin
                  -- Obtenemos la tasa del tercer quinto
                  begin
                    select a.aqpa385dsct
                      into ln_tasadsct
                      from aqpa385 a
                     where a.aqpa385quinto = 45
                       and a.aqpa385dsd <= ln_TasaOrig
                       and a.aqpa385hst >= ln_TasaOrig;
                  exception
                    -- MPOSTIGOC 08.03.2021
                    when others then
                      ln_tasadsct := 0;
                  end;
                
                  ln_factor   := (100 - ln_tasadsct) / 100;
                  ln_TasaTrcQ := round(ln_TasaOrig * ln_factor, 6);
                end;
              
                begin
                  PQ_CR_REPROQUINTOS_TASA.sp_cr_AQPA386(ln_inst  => ln_instancia,
                                                        ld_FECHA => ld_fecha,
                                                        ln_PGCOD => ln_pgcod,
                                                        ln_MOD   => ln_modulo,
                                                        ln_SUC   => ln_sucursal,
                                                        ln_MDA   => ln_moneda,
                                                        ln_PAP   => ln_papel,
                                                        ln_CTA   => ln_cta,
                                                        ln_OPE   => ln_oper,
                                                        ln_SBO   => ln_suboper,
                                                        ln_TOP   => ln_tope,
                                                        ln_tori  => ln_tasaorig,
                                                        ln_NCUO  => ln_TrcQnt,
                                                        ld_FCUO  => ld_FchTrcQnt,
                                                        ln_TASA  => ln_TasaTrcQ);
                end;
              
              else
                if x = ln_CrtQnt then
                  ld_FchCrtQnt := c.ppfpag;
                  begin
                    -- La tasa del ultimo tramo siempre sera 0%;
                    ln_TasaCrtQ := 0.000000;
                  end;
                
                  begin
                    PQ_CR_REPROQUINTOS_TASA.sp_cr_AQPA386(ln_inst  => ln_instancia,
                                                          ld_FECHA => ld_fecha,
                                                          ln_PGCOD => ln_pgcod,
                                                          ln_MOD   => ln_modulo,
                                                          ln_SUC   => ln_sucursal,
                                                          ln_MDA   => ln_moneda,
                                                          ln_PAP   => ln_papel,
                                                          ln_CTA   => ln_cta,
                                                          ln_OPE   => ln_oper,
                                                          ln_SBO   => ln_suboper,
                                                          ln_TOP   => ln_tope,
                                                          ln_tori  => ln_tasaorig,
                                                          ln_NCUO  => ln_CrtQnt,
                                                          ld_FCUO  => ld_FchCrtQnt,
                                                          ln_TASA  => ln_TasaCrtQ);
                  end;
                
                end if;
              end if;
            end if;
          end if;
        
          x := x + 1;
        
          if x > ln_CrtQnt then
            exit;
          end if;
        end loop;
      end if;
    
    end if;
  
  end sp_cr_inicio;
  -------------------------------------------------------------
  procedure sp_cr_AQPA386(ln_inst  in number,
                          ld_FECHA in date,
                          ln_PGCOD in number,
                          ln_MOD   in number,
                          ln_SUC   in number,
                          ln_MDA   in number,
                          ln_PAP   in number,
                          ln_CTA   in number,
                          ln_OPE   in number,
                          ln_SBO   in number,
                          ln_TOP   in number,
                          ln_tori  in number,
                          ln_NCUO  in number,
                          ld_FCUO  in date,
                          ln_TASA  in number) is
  
    ln_corr number := 0;
    lc_hora char(8) := '00:00:00';
    lc_EST  varchar2(5) := 'H';
  
  begin
  
    begin
      select max(a.aqpa386corr)
        into ln_corr
        from aqpa386b a
       where a.aqpa386inst = ln_inst;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
    lc_EST  := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    insert into AQPA386B
      (AQPA386CORR,
       AQPA386INST,
       AQPA386FECHA,
       AQPA386HORA,
       AQPA386PGCOD,
       AQPA386MOD,
       AQPA386SUC,
       AQPA386MDA,
       AQPA386PAP,
       AQPA386CTA,
       AQPA386OPE,
       AQPA386SBO,
       AQPA386TOP,
       AQPA386TORI,
       AQPA386NCUO,
       AQPA386FCUO,
       AQPA386TASA,
       AQPA386EST)
    
    values
      (ln_CORR + 1,
       ln_INST,
       ld_FECHA,
       lc_hora,
       ln_PGCOD,
       ln_MOD,
       ln_SUC,
       ln_MDA,
       ln_PAP,
       ln_CTA,
       ln_OPE,
       ln_SBO,
       ln_TOP,
       ln_tori,
       ln_NCUO,
       ld_FCUO,
       ln_TASA,
       lc_EST);
    commit;
  
  end sp_cr_AQPA386;
  -------------------------------------------------------
  procedure sp_cr_ExtornaDesemb(PPgcod    in number,
                                Pitmod    in number,
                                PItsuc    in number,
                                PIttran   in number,
                                PItnrel   in number,
                                ld_FchExt in date) is
  
    --  ld_fchSist     date;
    --  ModAnu         number;
    --  ln_NroRelacion number;
  
  begin
  
    -- ModAnu := Pitmod - 500;
  
    begin
      update aqpa386 a
         set a.aqpa386est = 'E'
       where a.aqpa386emptx = PPgcod
         and a.aqpa386suctx = PItsuc
         and a.aqpa386modtx = Pitmod
         and a.aqpa386tran = PIttran
         and a.aqpa386reltx = PItnrel
            -- and a.aqpa386ordtx = PItord
         and a.aqpa386fecha = ld_FchExt;
    
      commit;
    end;
  
  end sp_cr_ExtornaDesemb;

-------------------------------------------------------

end PQ_CR_REPROQUINTOS_TASA;
/

