create or replace package pq_cr_max_dias_reprog is

 procedure sp_cr_max_dias_reprog(ve_Instancia  number,
                                 vs_validacion out varchar);
  procedure sp_cr_min_fecha (ve_Instancia  number,
                                  vs_validacion out varchar);

end pq_cr_max_dias_reprog;
/

create or replace package body pq_cr_max_dias_reprog is

  procedure sp_cr_max_dias_reprog(ve_Instancia  number,
                                  vs_validacion out varchar) is
  
    v_empresa                number;
    v_sucursal               number;
    v_modulo                 number;
    v_moneda                 number;
    v_papel                  number;
    v_cuenta                 number;
    v_operacion              number;
    v_subope                 number;
    v_tipope                 number;
    v_fecha_nuevo_cronograma date;
    v_diferencia_dias        number;
    v_maximo_dias            number;
  
  begin
    begin
      select xwfempresa,
             xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope
        from xwf700
       where xwfcar3 = '1'
         and xwfprcins = ve_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select min(ppfpag)
        into v_fecha_nuevo_cronograma
        from fsd601
       where pgcod = v_empresa
         and ppmod = v_modulo
         and ppsuc = v_sucursal
         and ppmda = v_moneda
         and pppap = v_papel
         and ppcta = v_cuenta
         and ppoper = v_operacion
         and ppsbop = 609
         and pptope = v_tipope;
    exception
      when others then
        null;
    end;
  
    begin
      select (v_fecha_nuevo_cronograma - pgfape)
        into v_diferencia_dias
        from fst017
       where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select tp1nro1
        into v_maximo_dias
        from fst198
       where tp1cod = 1
         and tp1cod1 = 614000
         and tp1corr2 > 0;
    exception
      when others then
        null;
    end;
    if v_diferencia_dias <= v_maximo_dias then
      vs_validacion := 'S';
    else
      vs_validacion := 'N';
    end if;
  
  end sp_cr_max_dias_reprog;
  
  procedure sp_cr_min_fecha (ve_Instancia  number,
                                  vs_validacion out varchar) is
    
    v_empresa                number;
    v_sucursal               number;
    v_modulo                 number;
    v_moneda                 number;
    v_papel                  number;
    v_cuenta                 number;
    v_operacion              number;
    v_subope                 number;
    v_tipope                 number;
    v_fecha_nuevo_cronograma date;
    v_diferencia_dias        number;
    v_maximo_dias            number;
    ld_fecpag                date;
    fecha1                   date;
    
  begin 
    
   begin
      select xwfempresa,
             xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope
        from xwf700
       where xwfcar3 = '1'
         and xwfprcins = ve_Instancia;
    exception
      when others then
        null;
    end;
    
      begin
      select max(ppfpag)
        into ld_fecpag
        from fsd602 f
       where f.pgcod = v_empresa
         and f.ppmod = v_modulo
         and f.ppsuc = v_sucursal
         and f.ppmda = v_moneda
         and f.pppap = v_papel
         and f.ppcta = v_cuenta
         and f.ppoper = v_operacion
         and f.ppsbop = v_subope
         and f.pptope = v_tipope
         and f.PP1STAT = 'T'
         and f.D602CO = 'S';
     exception
      when others then
        ld_fecpag := null;
     end;
     
     if ld_fecpag is null then
        begin
          select min(ppfpag)
            into fecha1
            from fsd601
           where pgcod = v_empresa
             and ppmod = v_modulo
             and ppsuc = v_sucursal
             and ppmda = v_moneda
             and pppap = v_papel
             and ppcta = v_cuenta
             and ppoper = v_operacion
             and ppsbop = v_subope
             and pptope = v_tipope;
        exception
          when others then
            fecha1 := null;
        end;
     else
       begin
         select min(ppfpag)
          into fecha1
          from fsd601
         where pgcod = v_empresa
           and ppmod = v_modulo
           and ppsuc = v_sucursal
           and ppmda = v_moneda
           and pppap = v_papel
           and ppcta = v_cuenta
           and ppoper = v_operacion
           and ppsbop = v_subope
           and pptope = v_tipope
           and ppfpag > ld_fecpag;
      exception
        when others then
          null;
      end;    
    end if;
             
    begin
      select tp1nro1
        into v_maximo_dias
        from fst198
       where tp1cod = 1
         and tp1cod1 = 614000
         and tp1corr2 > 0;
    exception
      when others then
        null;
    end;
    
    begin        
      select min(ppfpag)
             into v_fecha_nuevo_cronograma
          from fsd601
         where pgcod = v_empresa
           and ppmod = v_modulo
           and ppsuc = v_sucursal
           and ppmda = v_moneda
           and pppap = v_papel
           and ppcta = v_cuenta
           and ppoper = v_operacion
           and ppsbop = 609
           and pptope = v_tipope;   
   exception
      when others then
        null;
   end;   
      
   begin
      select (v_fecha_nuevo_cronograma - fecha1)
        into v_diferencia_dias
        from dual;
    exception
      when others then
        null;
    end;
    
    if v_diferencia_dias <= v_maximo_dias then
      vs_validacion := 'S';
    else
      vs_validacion := 'N';
    end if;
                         
  end sp_cr_min_fecha;
  
end pq_cr_max_dias_reprog;
/

