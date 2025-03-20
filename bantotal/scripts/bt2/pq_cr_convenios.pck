create or replace package PQ_CR_Convenios is

  -- Author  : MPOSTIGOC
  -- Created : 27/01/2017 03:52:22 p.m.
  -- Purpose : 

  procedure sp_cr_BuscaConvenio(ln_instancia   in number,
                                lc_convenio    out varchar2,
                                ln_nwinstancia out number);
  -----------------------------------------------------------------
  procedure sp_cr_nroconvenio(ln_instancia in number,
                              lc_diapago   out varchar2);

end PQ_CR_Convenios;
/

create or replace package body PQ_CR_Convenios is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_Convenios
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : Cr¿ditos - Activas
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 27/01/2017 03:52:22 p.m.
  -- Autor de Creaci¿n          : MPOSTIGOC
  -- Uso                        : Identifica si el credito tiene un convenio asociado, y el numero de
  --                              convenio
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : ln_instancia (Numero de Solicitud en vuelo)
  -- Retorno                    : lc_convenio (S si tiene convenio, N si no tiene convenio)
  --                              
  -- Fecha de Modificaci¿n      : 2017.07.13
  -- Autor de la Modificaci¿n   : Mpostigoc
  -- Descripci¿n de Modificaci¿n: se ha agregado un rownum, si es que hay mas de 2 registros con la misma fecha
  --
  -- *****************************************************************
  procedure sp_cr_BuscaConvenio(ln_instancia   in number,
                                lc_convenio    out varchar2,
                                ln_nwinstancia out number) is
  
    ln_cuenta   number;
    lc_flag     varchar2(2);
    lc_flgExist varchar2(2);
    ln_pgcod    number;
    ln_sucursal number;
    ln_modulo   number;
    ln_moneda   number;
    ln_papel    number;
  
    ln_operacion number;
    ln_suboper   number;
  
    cursor busca_instancia is
    
      select distinct xwfprcins      ln_antginstancia,
                      f.xwfempresa   pgcod,
                      f.xwfsucursal  sucursal,
                      f.xwfmodulo    modulo,
                      f.xwfmoneda    moneda,
                      f.xwfpapel     papel,
                      f.xwfcuenta    cuenta,
                      f.xwfoperacion operacion,
                      f.xwfsubope    suboper
        from xwf700 f
       where xwfcuenta = ln_cuenta
         and xwfmodulo = 107
         and f.xwfcar3 = '1'
       order by f.xwfprcins,
                xwfempresa,
                xwfsucursal,
                xwfmodulo,
                xwfmoneda,
                xwfpapel,
                xwfcuenta,
                xwfoperacion,
                xwfsubope;
  
  begin
  
    lc_convenio := 'S';
  
    begin
    
      select distinct xwfcuenta, 'S'
        into ln_cuenta, lc_flag
        from xwf700
       where xwfprcins = ln_instancia
         and xwfmodulo = 107
         and xwfcar3 in ('G', 'S', 'R'); -- G AMPLIADO, S REPROGRAMADO, R REFINANCIADO
    
    exception
      when no_data_found then
        begin
          select distinct xwfcuenta, 'N' /*, xwfprcins*/
            into ln_cuenta, lc_flag /*,ln_nwinstancia*/
            from xwf700
           where xwfprcins = ln_instancia
             and xwfmodulo = 107
             and xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
    end;
  
    if ln_cuenta is not null and lc_flag = 'S' then
    
      for b in busca_instancia loop
      
        ln_nwinstancia := b.ln_antginstancia;
        ln_pgcod       := b.pgcod;
        ln_sucursal    := b.sucursal;
        ln_modulo      := b.modulo;
        ln_moneda      := b.moneda;
        ln_papel       := b.papel;
        ln_cuenta      := b.cuenta;
        ln_operacion   := b.operacion;
        ln_suboper     := b.suboper;
      
        begin
          select 'S'
            into lc_flgExist
            from fsd010 d
           where d.pgcod = ln_pgcod
             and d.aomod = ln_modulo
             and d.aosuc = ln_sucursal
             and d.aomda = ln_moneda
             and d.aopap = ln_papel
             and d.aocta = ln_cuenta
             and d.aooper = ln_operacion
             and d.aosbop = ln_suboper;
        
        exception
          when no_data_found then
            lc_flgExist := 'N';
        end;
      
        IF lc_flgExist = 'S' THEN
          exit;
        end IF;
      
      end loop;
    
      IF lc_flgExist = 'S' then
      
        begin
        
          select 'S'
            into lc_convenio
            from fpp102 f
           where f.pp102cta = ln_cuenta
             and f.pp102tfc = (select max(g.pp102tfc)
                                 from fpp102 g
                                where g.pp102cta = ln_cuenta)
             and f.pp102suc = (select distinct xwfsucursal
                                 from xwf700
                                where xwfprcins = ln_instancia
                                  and xwfmodulo = 107
                                  and xwfcar3 = '1');
        exception
          -- mpostigoc 13/07/17
          when too_many_rows then
            begin
              select 'S'
                into lc_convenio
                from fpp102 f
               where f.pp102cta = ln_cuenta
                 and f.pp102tfc =
                     (select max(g.pp102tfc)
                        from fpp102 g
                       where g.pp102cta = ln_cuenta)
                 and f.pp102suc = (select distinct xwfsucursal
                                     from xwf700
                                    where xwfprcins = ln_instancia
                                      and xwfmodulo = 107
                                      and xwfcar3 = '1')
                 and rownum = 1; -- mpostigoc 13/07/17
            
            end;
          when no_data_found then
            lc_convenio := 'N';
          
        end;
      end if;
    
    else
      if ln_cuenta is not null and lc_flag = 'N' then
      
        begin
          select s.sng001inst
            into ln_nwinstancia
            from sng001 s
           where s.Sng001inst = ln_instancia
             and sng001ori = 10;
        exception
          when others then
            null;
          
        end;
      
        begin
          select 'S'
            into lc_convenio
            from fpp102 f
           where f.pp102cta = ln_cuenta
             and f.pp102tfc = (select max(g.pp102tfc)
                                 from fpp102 g
                                where g.pp102cta = ln_cuenta)
             and f.pp102suc = (select distinct xwfsucursal
                                 from xwf700
                                where xwfprcins = ln_instancia
                                  and xwfmodulo = 107
                                  and xwfcar3 = '1')
                                  and rownum=1;
        exception
          when no_data_found then
          
            begin
              select 'S'
                into lc_convenio
                from wfattsvalues w
               where w.wfinsprcid = ln_instancia
                 and w.wfattsid = 'ID_CONVENIO';
            exception
              when others then
                lc_convenio := 'N';
              
            end;
          
        end;
      
      end if;
    End If;
  
  end sp_cr_BuscaConvenio;

  --------------------------------------------------------------------------------
  procedure sp_cr_nroconvenio(ln_instancia in number,
                              lc_diapago   out varchar2) is
  
    ln_nroconv     number;
    ln_cuenta      number;
    ln_sng001ori   number;
    ln_DiaPagCart  number;
    ln_DiaPagoCaln number;
  
  begin
  
    begin
      select sng001ori, sng001cta
        into ln_sng001ori, ln_cuenta
        from sng001 s
       where s.sng001inst = ln_instancia;
    
    end;
  
    if ln_sng001ori in (3, 4, 13, 14, 15) then
    
      begin
        select distinct (f.pp102ncart)
          into ln_nroconv
          from fpp102 f
         where f.pp102cta = ln_cuenta
           and f.pp102tfc = (select max(g.pp102tfc)
                               from fpp102 g
                              where g.pp102cta = ln_cuenta);
      exception
        when others then
          null;
        
      end;
    
    else
      if ln_sng001ori = 10 then
        begin
          select to_number(w.wfattsval)
            into ln_nroconv
            from WFATTSVALUES w
           where w.wfinsprcid = ln_instancia
             and w.wfattsid = 'ID_CONVENIO';
        exception
          when no_data_found then
            ln_nroconv := 0;
        end;
      end if;
    end if;
  
    --- Dia de Pago de la Cartera
    begin
    
      select JAQA201DPAG
        into ln_DiaPagCart
        from JAQA201 j
       where j.jaqa201nca = ln_nroconv;
    exception
      when others then
        ln_DiaPagCart := 0;
    end;
    -- Dia de Pago del Calendario del Credito
    begin
      select to_number(TO_CHAR(x.xllfprimpa, 'DD'))
        into ln_DiaPagoCaln
        from x054023 x, xwf700 w
       WHERE XllPgcod = XWFEMPRESA
         and XllAomod = XWFMODULO
         and XllAosuc = XWFSUCURSAL
         and XllAomda = XWFMONEDA
         and XllAopap = XWFPAPEL
         and XllAocta = XWFCUENTA
         and XllAooper = XWFOPERACION
         and XllAosbop = XWFSUBOPE
         and XllAotop = XWFTIPOPE
         and w.xwfprcins = ln_instancia
         and w.xwfcar3 = '1';
    exception
      when others then
        ln_DiaPagoCaln := 0;
    end;
  
    if ln_DiaPagCart = ln_DiaPagoCaln then
      lc_diapago := 'S';
    else
      lc_diapago := 'N';
    end if;
  
  end sp_cr_nroconvenio;
  ---------------------------------------------------------------------------------
end PQ_CR_Convenios;
/

