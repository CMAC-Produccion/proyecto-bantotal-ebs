create or replace package PQ_CR_RTE_FESTICAJA is

  -- Author  : MPOSTIGOC
  -- Created : 01/07/2016 05:53:49 p.m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cuentas(ln_Pepais   in number,
                       ln_Petdoc   in number,
                       ln_documnto in varchar2,
                       ln_pgcod    in number,
                       ln_suctran  in number,
                       ln_modtran  in number,
                       ln_trantran in number,
                       ln_reltran  in number,
                       ln_fchconta in date,
                       lc_mensaje  out varchar2);

  ------------------------------------------------------------
  procedure sp_cuentasII(ln_Pepais   in number,
                         ln_Petdoc   in number,
                         ln_documnto in varchar2,
                         ln_pgcod    in number,
                         ln_suctran  in number,
                         ln_modtran  in number,
                         ln_trantran in number,
                         ln_reltran  in number,
                         ln_fchconta in date,
                         lc_mensaje  out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_aval(ln_Pepais in number,
                       ln_Petdoc in number,
                       ln_Pendoc in varchar2,
                       lc_aval   out varchar2);
  ----------------------------------------------------------

  procedure sp_cr_registros(ln_Pepais    in number,
                            ln_Petdoc    in number,
                            ln_Pendoc    in char,
                            ln_nromora   out number,
                            ln_registros out number);
  ------------------------------------------------------------
  procedure sp_cr_pagos(ln_nromora   in number,
                        ln_registros in number,
                        lc_flag      out varchar2);

  ------------------------------------------------------------
  procedure sp_cr_insertajaqy146(ln_Pepais    in number,
                                 ln_Petdoc    in number,
                                 ln_Pendoc    in varchar2,
                                 ln_pgcod     in number,
                                 ln_modtran   in number,
                                 ln_suctran   in number,
                                 ln_trantran  in number,
                                 ln_reltran   in number,
                                 ln_fchconta  in date,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operacion in number,
                                 ln_subope    in number,
                                 ln_tipoope   in number);
  ------------------------------------------------------------          
end PQ_CR_RTE_FESTICAJA;
/

create or replace package body PQ_CR_RTE_FESTICAJA is

  procedure sp_cuentas(ln_Pepais   in number,
                       ln_Petdoc   in number,
                       ln_documnto in varchar2,
                       ln_pgcod    in number,
                       ln_suctran  in number,
                       ln_modtran  in number,
                       ln_trantran in number,
                       ln_reltran  in number,
                       ln_fchconta in date,
                       lc_mensaje  out varchar2) is
  
    ln_nromora   number;
    ln_registros number;
    lc_existe    varchar2(2);
    lc_flag      varchar2(2);
    lc_aval      varchar(2);
    lc_nromax    number;
    ln_nroent    number;
    lc_fgOK      varchar2(2);
    ln_nrdias    number;
    ln_diasI     number;
    ln_fgdias    varchar2(2);
    lc_fgsuc     varchar2(2);
  
    ln_Pendoc char(10);
  
    cursor cliente is
    
      select f.ppmod  ln_modulo,
             f.ppsuc  ln_sucursal,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subope,
             f.pptope ln_tipoope
      
        from fsd602 f
       where f.d602cd = ln_pgcod
         and f.d602su = ln_suctran
         and f.d602mo = ln_modtran
         and f.d602tr = ln_trantran
         and f.d602re = ln_reltran
         and f.d602fc = ln_fchconta;
  
  begin
  
    ln_Pendoc  := rpad(ln_documnto, 10, ' ');
    lc_mensaje := 'N';
  
    pq_cr_rte_festicaja.sp_cr_aval(ln_Pepais,
                                   ln_Petdoc,
                                   ln_Pendoc,
                                   lc_aval);
  
    if lc_aval = 'N' then
    
      pq_cr_rte_festicaja.sp_cr_registros(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          ln_nromora,
                                          ln_registros);
    
      if ln_registros > 0 then
      
        for c in cliente loop
        
          pq_cr_rte_festicaja.sp_cr_pagos(ln_nromora,
                                          ln_registros,
                                          lc_flag);
        
          if lc_flag = 'S' then
            begin
              select 'S'
                into lc_existe
                from jaqy146 j
               where j.JAQY146PEPAIS = ln_Pepais
                 AND j.JAQY146PETDOC = ln_Petdoc
                 and j.Jaqy146pendoc = ln_Pendoc
                 and j.JAQY146EST = 'S';
            exception
              when others then
                lc_existe := 'N';
            end;
          
            begin
              begin
                select count(*)
                  into lc_nromax
                  from jaqy146 j
                 where j.JAQY146EST = 'S';
              exception
                when others then
                  null;
              end;
            
              begin
                select f.tpnro
                  into ln_nroent
                  from fst098 f
                 where f.pgcod = 1
                   and f.tpcod = 7699
                   and f.tpcorr = 2;
              exception
                when others then
                  null;
              end;
            
              if lc_nromax <= ln_nroent then
                lc_fgOK := 'S';
              
              else
                lc_fgOK := 'N';
              end if;
            
            end;
          
            begin
              begin
                select (ln_fchconta - d.ppfpag)
                  into ln_nrdias
                  from fsd602 d
                 where d.pgcod = 1
                   and d.PPMOD = c.ln_modulo
                   and d.PPSUC = c.ln_sucursal
                   and d.Ppmda = c.ln_moneda
                   and d.PPPAP = c.ln_papel
                   and d.Ppcta = c.ln_cuenta
                   and d.PPOPER = c.ln_operacion
                   and d.Ppsbop = c.ln_subope
                   and d.Pptope = c.ln_tipoope
                   and d.d602fc = ln_fchconta;
              exception
                when others then
                  null;
              end;
            
              begin
                select f.tpnro
                  into ln_diasI
                  from fst098 f
                 where f.pgcod = 1
                   and f.tpcod = 7699
                   and f.tpcorr = 1;
              exception
                when others then
                  null;
                
              end;
            
              if ln_nrdias <= ln_diasI then
              
                ln_fgdias := 'S';
              ELSE
                ln_fgdias := 'N';
              end if;
            
            end;
          
            begin
              select 'S'
                into lc_fgsuc
                from fst198
               where Tp1cod = 1
                 and Tp1cod1 = 10899
                 and Tp1corr1 = 21
                 and Tp1corr2 = 1
                 and Tp1nro1 = ln_suctran;
            exception
              when others then
                lc_fgsuc := 'N';
              
            end;
            
            if lc_fgsuc = 'S' then
          
            if c.ln_modulo = 106 and
               (c.ln_tipoope not in (10, 11, 30, 31, 32, 33, 34)) then
            
              if lc_existe = 'N' and lc_fgOK = 'S' and ln_fgdias = 'S' then
              
                lc_mensaje := 'S';
              
              end if;
            
            else
              if c.ln_modulo <> 106 then
              
                if lc_existe = 'N' and lc_fgOK = 'S' and ln_fgdias = 'S' then
                
                  lc_mensaje := 'S';
                
                end if;
              end if;
            
            end if;
          
          end if;
          end if;
        
        end loop;
      
      end if;
    
    end if;
  
    -- lc_mensaje:= 'CLIENTE PUNTUAL ENTREGAR ENTRADA FESTICAJA';
  
  end sp_cuentas;

  -------------------------------------------------------------------
  procedure sp_cuentasII(ln_Pepais   in number,
                         ln_Petdoc   in number,
                         ln_documnto in varchar2,
                         ln_pgcod    in number,
                         ln_suctran  in number,
                         ln_modtran  in number,
                         ln_trantran in number,
                         ln_reltran  in number,
                         ln_fchconta in date,
                         lc_mensaje  out varchar2) is
  
    ln_nromora   number;
    ln_registros number;
    lc_existe    varchar2(2);
    lc_flag      varchar2(2);
    lc_aval      varchar(2);
    lc_nromax    number;
    ln_nroent    number;
    lc_fgOK      varchar2(2);
    ln_nrdias    number;
    ln_diasI     number;
    ln_fgdias    varchar2(2);
    lc_fgsuc varchar(2);
  
    ln_Pendoc char(10);
  
    cursor cliente is
    
      select f.ppmod  ln_modulo,
             f.ppsuc  ln_sucursal,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subope,
             f.pptope ln_tipoope
      
        from fsd602 f
       where f.d602cd = ln_pgcod
         and f.d602su = ln_suctran
         and f.d602mo = ln_modtran
         and f.d602tr = ln_trantran
         and f.d602re = ln_reltran
         and f.d602fc = ln_fchconta;
  
  begin
  
    ln_Pendoc  := rpad(ln_documnto, 10, ' ');
    lc_mensaje := 'N';
  
    pq_cr_rte_festicaja.sp_cr_aval(ln_Pepais,
                                   ln_Petdoc,
                                   ln_Pendoc,
                                   lc_aval);
  
    if lc_aval = 'N' then
    
      pq_cr_rte_festicaja.sp_cr_registros(ln_Pepais,
                                          ln_Petdoc,
                                          ln_Pendoc,
                                          ln_nromora,
                                          ln_registros);
    
      if ln_registros > 0 then
      
        for c in cliente loop
        
          pq_cr_rte_festicaja.sp_cr_pagos(ln_nromora,
                                          ln_registros,
                                          lc_flag);
        
          if lc_flag = 'S' then
            begin
              select 'S'
                into lc_existe
                from jaqy146 j
               where j.JAQY146PEPAIS = ln_Pepais
                 AND j.JAQY146PETDOC = ln_Petdoc
                 and j.Jaqy146pendoc = ln_Pendoc
                 and j.JAQY146EST = 'S';
            exception
              when others then
                lc_existe := 'N';
            end;
          
            begin
              begin
                select count(*)
                  into lc_nromax
                  from jaqy146 j
                 where j.JAQY146EST = 'S';
              exception
                when others then
                  null;
              end;
            
              begin
                select f.tpnro
                  into ln_nroent
                  from fst098 f
                 where f.pgcod = 1
                   and f.tpcod = 7699
                   and f.tpcorr = 2;
              exception
                when others then
                  null;
              end;
            
              if lc_nromax <= ln_nroent then
                lc_fgOK := 'S';
              
              else
                lc_fgOK := 'N';
              end if;
            
            end;
          
            begin
              begin
                select (ln_fchconta - d.ppfpag)
                  into ln_nrdias
                  from fsd602 d
                 where d.pgcod = 1
                   and d.PPMOD = c.ln_modulo
                   and d.PPSUC = c.ln_sucursal
                   and d.Ppmda = c.ln_moneda
                   and d.PPPAP = c.ln_papel
                   and d.Ppcta = c.ln_cuenta
                   and d.PPOPER = c.ln_operacion
                   and d.Ppsbop = c.ln_subope
                   and d.Pptope = c.ln_tipoope
                   and d.d602fc = ln_fchconta;
              exception
                when others then
                  null;
              end;
            
              begin
                select f.tpnro
                  into ln_diasI
                  from fst098 f
                 where f.pgcod = 1
                   and f.tpcod = 7699
                   and f.tpcorr = 1;
              exception
                when others then
                  null;
                
              end;
            
              if ln_nrdias <= ln_diasI then
              
                ln_fgdias := 'S';
              ELSE
                ln_fgdias := 'N';
              end if;
            
            end;
            
             begin
              select 'S'
                into lc_fgsuc
                from fst198
               where Tp1cod = 1
                 and Tp1cod1 = 10899
                 and Tp1corr1 = 21
                 and Tp1corr2 = 1
                 and Tp1nro1 = ln_suctran;
            exception
              when others then
                lc_fgsuc := 'N';
              
            end;
            
            if lc_fgsuc = 'S' then
          
            if c.ln_modulo = 106 and
               (c.ln_tipoope not in (10, 11, 30, 31, 32, 33, 34)) then
            
              if lc_existe = 'N' and lc_fgOK = 'S' and ln_fgdias = 'S' then
                pq_cr_rte_festicaja.sp_cr_insertajaqy146(ln_Pepais,
                                                         ln_Petdoc,
                                                         ln_Pendoc,
                                                         ln_pgcod,
                                                         ln_modtran,
                                                         ln_suctran,
                                                         ln_trantran,
                                                         ln_reltran,
                                                         ln_fchconta,
                                                         c.ln_modulo,
                                                         c.ln_sucursal,
                                                         c.ln_moneda,
                                                         c.ln_papel,
                                                         c.ln_cuenta,
                                                         c.ln_operacion,
                                                         c.ln_subope,
                                                         c.ln_tipoope);
                lc_mensaje := 'S';
              
              end if;
            
            else
              if c.ln_modulo <> 106 then
              
                if lc_existe = 'N' and lc_fgOK = 'S' and ln_fgdias = 'S' then
                  pq_cr_rte_festicaja.sp_cr_insertajaqy146(ln_Pepais,
                                                           ln_Petdoc,
                                                           ln_Pendoc,
                                                           ln_pgcod,
                                                           ln_modtran,
                                                           ln_suctran,
                                                           ln_trantran,
                                                           ln_reltran,
                                                           ln_fchconta,
                                                           c.ln_modulo,
                                                           c.ln_sucursal,
                                                           c.ln_moneda,
                                                           c.ln_papel,
                                                           c.ln_cuenta,
                                                           c.ln_operacion,
                                                           c.ln_subope,
                                                           c.ln_tipoope);
                  lc_mensaje := 'S';
                
                end if;
              
              end if;
            
            end if;
          
          end if;
          
          end if;
        
        end loop;
      
      end if;
    
    end if;
  
    -- lc_mensaje:= 'CLIENTE PUNTUAL ENTREGAR ENTRADA FESTICAJA';
  
  end sp_cuentasII;

  -------------------------------------------------------------------
  procedure sp_cr_aval(ln_Pepais in number,
                       ln_Petdoc in number,
                       ln_Pendoc in varchar2,
                       lc_aval   out varchar2) is
  
    -- lc_aval varchar2(2);
  begin
    begin
      select 'S'
        into lc_aval
        from sng003 s, xwf700 x, fsd010 f
       where s.sng003pgc = 1
         and s.sng003cta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Ttcod = 1
                                and Cttfir = 'T')
         and s.sng001inst = x.xwfprcins
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.aosuc
         and x.xwfmodulo = f.aomod
         and x.xwfmoneda = f.aomda
         and x.xwfpapel = f.aopap
         and x.xwfcuenta = f.aocta
         and x.xwfoperacion = f.aooper
         and x.xwfsubope = f.aosbop
         and (f.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                        from fst198 a
                                       where a.tp1cod1 = 10899
                                         and tp1corr1 = 20
                                         and tp1corr2 = 1))) or
             f.Aomod in (117));
    
      -- and f.aostat <> 99;
    
    exception
      when others then
        lc_aval := 'N';
    end;
  end;
  -------------------------------------------------------------------

  procedure sp_cr_registros(ln_Pepais    in number,
                            ln_Petdoc    in number,
                            ln_Pendoc    in char,
                            ln_nromora   out number,
                            ln_registros out number) is
  
  begin
    begin
      select sum(f.pp1fech - f.ppfpag), count(*)
        into ln_nromora, ln_registros
        from (select *
                from fsd010 d10, fsd602 f602
               where d10.Pgcod = 1
                 and d10.Aocta in (select Ctnro
                                     from fsr008
                                    where pepais = ln_Pepais
                                      and Petdoc = ln_Petdoc
                                      and pendoc = ln_Pendoc
                                      and Ttcod = 1
                                      and Cttfir = 'T')
                 and (d10.Aomod in
                     (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in
                              ((select tp1nro1
                                  from fst198 a
                                 where a.tp1cod1 = 10899
                                   and tp1corr1 = 20
                                   and tp1corr2 = 1))) or Aomod = 117)
                    -- and d10.Aostat <> 99
                 and f602.pgcod = 1
                 and d10.aomod = f602.ppmod
                 and d10.aosuc = f602.ppsuc
                 and d10.aomda = f602.ppmda
                 and d10.aopap = f602.pppap
                 and d10.aocta = f602.ppcta
                 and d10.aooper = f602.ppoper
                 and d10.aosbop = f602.ppsbop
                 and f602.pp1stat = 'T'
                 and f602.d602co = 'S'
               order by f602.pp1fech desc) f
       where ROWNUM <= 3;
      --  group by f.pp1fech, f.ppfpag;
    exception
      when others then
        null;
    end;
  
    if ln_nromora < 0 then
      ln_nromora := 0;
    end if;
  
  end sp_cr_registros;

  -------------------------------------------------------------------
  procedure sp_cr_pagos(ln_nromora   in number,
                        ln_registros in number,
                        lc_flag      out varchar2) is
  
    resultado number;
    ln_dias   number;
  
  begin
  
    resultado := nvl(ln_nromora, 0) / nvl(ln_registros, 0);
  
    begin
      select f.tpnro
        into ln_dias
        from fst098 f
       where f.pgcod = 1
         and f.tpcod = 7699
         and f.tpcorr = 1;
    exception
      when others then
        null;
      
    end;
  
    if resultado <= ln_dias then
      lc_flag := 'S';
    
    else
      lc_flag := 'N';
    end if;
  
  end sp_cr_pagos;
  --------------------------------------------------------------------
  procedure sp_cr_insertajaqy146(ln_Pepais    in number,
                                 ln_Petdoc    in number,
                                 ln_Pendoc    in varchar2,
                                 ln_pgcod     in number,
                                 ln_modtran   in number,
                                 ln_suctran   in number,
                                 ln_trantran  in number,
                                 ln_reltran   in number,
                                 ln_fchconta  in date,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operacion in number,
                                 ln_subope    in number,
                                 ln_tipoope   in number) is
    ln_corr number;
  begin
    begin
      select count(*) into ln_corr from jaqy146;
    exception
      when no_data_found then
        ln_corr := 0;
    end;
  
    begin
      insert into jaqy146
        (jaqy146corr,
         jaqy146pepais,
         jaqy146petdoc,
         jaqy146pendoc,
         jaqy146pgcod,
         jaqy146hcmod,
         jaqy146hsucor,
         jaqy146htran,
         jaqy146hnrel,
         jaqy146fchcont,
         jaqy146mod,
         jaqy146suc,
         jaqy146mda,
         jaqy146pap,
         jaqy146cta,
         jaqy146ope,
         jaqy146sbop,
         jaqy146tope,
         jaqy146est)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         ln_pgcod,
         ln_modtran,
         ln_suctran,
         ln_trantran,
         ln_reltran,
         ln_fchconta,
         ln_modulo,
         ln_sucursal,
         ln_moneda,
         ln_papel,
         ln_cuenta,
         ln_operacion,
         ln_subope,
         ln_tipoope,
         'S');
    
      COMMIT;
    end;
  
  end sp_cr_insertajaqy146;
  -------------------------------------------------------------------  
end PQ_CR_RTE_FESTICAJA;
/

