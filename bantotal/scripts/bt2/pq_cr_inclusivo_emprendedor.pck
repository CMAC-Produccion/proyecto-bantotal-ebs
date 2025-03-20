create or replace package PQ_CR_Inclusivo_Emprendedor is

  -- Author  : ENINAH
  -- Created : 16/08/2022 12:48:22
  -- Purpose : 
  procedure SP_CR_Mss_Reside_legal(ln_instancia in number,
                                   ln_meses     out number);
  procedure SP_CR_Promedio_Atraso(ln_instancia in number,
                                  ln_promedio  out number);

end PQ_CR_Inclusivo_Emprendedor;
/

create or replace package body PQ_CR_Inclusivo_Emprendedor is

  procedure SP_CR_Mss_Reside_legal(ln_instancia in number,
                                   ln_meses     out number) is
    ln_pais        number;
    ln_tdoc        number;
    lv_ndoc        varchar2(12);
    ld_fechaR      date;
    ld_fechape     date;
    ld_fechinicial date := to_date('01/01/1950', 'DD/MM/YYYY');
  
  begin
    ln_meses := 0;
    --Aqui obtengo el codigo de pais, tipo de documento y el numero de documento
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lv_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
    --De aqui obtengo la residencia del titular del credito
    begin
      select s.sngc13rdes
        into ld_fechaR -- Fecha de Residencia
        from sngc13 s
       where s.sngc13pais = ln_pais
         and s.sngc13tdoc = ln_tdoc
         and s.sngc13ndoc = lv_ndoc
         and s.docod = 1
         and s.sngc13corr <> 500
         and s.sngc13est = 'H';
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fechape from fst017 f where f.pgcod = 1;
    end;
  
    if ld_fechaR > ld_fechinicial then
    
      begin
        select round(MONTHS_BETWEEN(ld_fechape, ld_fechaR), 0)
          into ln_meses
          from dual;
      end;
    end if;
  
  end SP_CR_Mss_Reside_legal;
  ----------------------------------------------------------------------------
  --Procedimiento para Calcular el promedio Atrasado.
  procedure SP_CR_Promedio_Atraso(ln_instancia in number,
                                  ln_promedio  out number) is
  
    cursor lista(ln_empresa   number,
                 ln_modulo    number,
                 ln_sucursal  number,
                 ln_moneda    number,
                 ln_papel     number,
                 ln_cuenta    number,
                 ln_operacion number,
                 ln_subope    number,
                 ln_tipope    number) is
    
      select *
        from fsd601 f
       where f.pgcod = ln_empresa
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_subope
         and f.pptope = ln_tipope
         and f.ppfpag <= (select s.pgfape from fst017 s where s.pgcod = 1)
         and f.d601co = 'S';
  
    cursor instancias(ln_pais number, ln_tdoc number, lv_ndoc varchar2) is
    
      select s.sng001inst
        from sng001 s, xwf070 x
       where s.sng001inst = x.xwfprcin
         and s.sng001pais = ln_pais
         and s.sng001tdoc = ln_tdoc
         and s.sng001ndoc = lv_ndoc
         and x.xwfcont = 'S'
         and s.sng001inst <> ln_instancia
       order by s.sng001inst desc;
  
    ln_pais         number;
    ln_tdoc         number;
    lv_ndoc         varchar2(12);
    ln_numregistros number;
    ln_cta          number;
    ln_intancia_max number;
    ln_empresa      number;
    ln_modulo       number;
    ln_sucursal     number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_subope       number;
    ln_tipope       number;
    ln_diasaux      number := 0;
    ld_fchsist      date;
    ln_cont         number := 0;
    ln_dias         number := 0;
  
  begin
  
    ln_promedio := 0;
  
    --Primero se  verifica si se tiene aval asociado
    begin
      select count(*)
        into ln_numregistros
        from sng003 s
       where s.sng001inst = ln_instancia;
    end;
  
    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    end;
  
    if ln_numregistros > 0 then
      begin
        --- Aqui se obtiene el numero de cuenta, codigo de pais, tipo de documento y el numero
        --- de documento.
      
        begin
          select sn.sng003cta
            into ln_cta
            from sng003 sn
           where sn.sng001inst = ln_instancia;
        exception
          when others then
            null;
        end;
      
        begin
          select s.sng001pais, s.sng001tdoc, s.sng001ndoc
            into ln_pais, ln_tdoc, lv_ndoc
            from sng001 s
           where s.sng001inst = ln_instancia;
        exception
          when others then
            null;
        end;
      end;
    end if;
  
    for i in instancias(ln_pais, ln_tdoc, lv_ndoc) loop
    
      begin
        -- Si tiene aval asociado, se identifica todas las instancias del cliente y que 
        --tuvieron el mismo aval y se selcciona la ultima instanica.
        select n.sng001inst
          into ln_intancia_max
          from sng003 n
         where n.sng001inst = i.sng001inst
           and n.sng003cta = ln_cta;
      exception
        when others then
          ln_intancia_max := 0;
      end;
    
      if ln_intancia_max > 0 then
        exit;
      end if;
    
    end loop;
  
    if ln_intancia_max > 0 then
      begin
        -- identificas la clave del credito de la consulta anterior
        select x.xwfempresa,
               x.xwfmodulo,
               x.xwfsucursal,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_empresa,
               ln_modulo,
               ln_sucursal,
               ln_moneda,
               ln_papel,
               ln_cuenta,
               ln_operacion,
               ln_subope,
               ln_tipope
          from xwf700 x
         where x.xwfprcins = ln_intancia_max
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      for l in lista(ln_empresa,
                     ln_modulo,
                     ln_sucursal,
                     ln_moneda,
                     ln_papel,
                     ln_cuenta,
                     ln_operacion,
                     ln_subope,
                     ln_tipope) loop
      
        begin
          select f.d602fc - f.ppfpag
            into ln_diasaux
            from fsd602 f
           where f.pgcod = l.pgcod
             and f.ppmod = l.ppmod
             and f.ppsuc = l.ppsuc
             and f.ppmda = l.ppmda
             and f.pppap = l.pppap
             and f.ppcta = l.ppcta
             and f.ppoper = l.ppoper
             and f.ppsbop = l.ppsbop
             and f.pptope = l.pptope
             and f.ppfpag = l.ppfpag
             and f.pp1stat = 'T'
             and f.d602co = 'S';
        exception
          when others then
            ln_diasaux := ld_fchsist - l.ppfpag;
        end;
      
        if ln_diasaux < 0 then
          ln_diasaux := 0;
        end if;
      
        ln_cont := ln_cont + 1;
        ln_dias := ln_dias + ln_diasaux;
      
      end loop;
    
      if ln_cont > 0 then
        --MPOSTIGOC 26.08.2022
        ln_promedio := round((nvl(ln_dias, 0) / nvl(ln_cont, 0)), 2);
      else
        ln_promedio := 0;
      end if;
    
    end if;
  
  end SP_CR_Promedio_Atraso;

end PQ_CR_Inclusivo_Emprendedor;
/

