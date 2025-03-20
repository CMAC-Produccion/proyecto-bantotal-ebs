create or replace procedure sp_cr_corresponde_garantia(instancia   in number,
                                                       monto_cap   out number,
                                                       monto_c_gar out varchar2) is
                                                       
  -- *****************************************************************
  -- Nombre                     : sp_cr_corresponde_garantia
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.10.16   
  -- Autor de Creación          : ENINAH
  -- Uso                        : PROCEDIMIENTO ALMACENADO PARA VERIFICAR SI LE CORRESPONDE GARANTÍA   
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  codigo       number;
  sucursal     number;
  modulo       number;
  moneda       number;
  papel        number;
  cuenta       number;
  operacion    number;
  suboperacion number;
  tipoperacion number;
  montocapital number;
  garantia     varchar2(2) := 'N';
  SNG122ModV   number;
  SNG122TopeV  number;
  contador     number;
  tp1codv      number;
  tp1cod1v     number;
  tp1corr1v    number;
  tp1corr2v    number;

begin
  begin
    select x.xwfempresa,
           x.xwfsucursal,
           x.xwfmodulo,
           x.xwfmoneda,
           x.xwfpapel,
           x.xwfcuenta,
           x.xwfoperacion,
           x.xwfsubope,
           x.xwftipope,
           'S'
      into codigo,
           sucursal,
           modulo,
           moneda,
           papel,
           cuenta,
           operacion,
           suboperacion,
           tipoperacion,
           garantia
      from xwf700 x
     where x.xwfprcins = instancia
       and x.xwfcar1 = '1';
  exception
    when others then
      garantia := 'N';
  end;

  begin
    select f.scsdo
      into montocapital
      from fsd011 f
     where f.pgcod = codigo
       and f.scsuc = sucursal
       and f.scmod = modulo
       and f.scmda = moneda
       and f.scpap = papel
       and f.sccta = cuenta
       and f.scoper = operacion
       and f.scsbop = suboperacion
       and f.sctope = tipoperacion;
  exception
    when others then
      null;
  end;

  if garantia = 'S' then
    begin
      select 'N'
        into garantia
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 610011
         and f.tp1corr1 = 1
         and f.tp1corr3 > 0
         and f.tp1nro1 = modulo;
    exception
      when others then
        garantia := 'S';
    end;
  
    begin
      select s.sng122mod, s.sng122tope, 'N', 1
        into SNG122ModV, SNG122TopeV, garantia, contador
        from sng122 s
       where s.sng122inst = instancia;
    exception
      when others then
        garantia := 'S';
        contador := 0;
    end;
  else
    garantia := 'N';
  end if;

  if contador = 1 then
    tp1codv   := 1;
    tp1cod1v  := 10846;
    tp1corr1v := 50;
    tp1corr2v := 1;
    garantia  := 'N';
  
    begin
      select 'S'
        into garantia
        from fst198 f
       where f.tp1cod = tp1codv
         and f.tp1cod1 = tp1cod1v
         and f.tp1corr1 = tp1corr1v
         and f.tp1corr2 = tp1corr2v
         and f.tp1nro1 = SNG122ModV
         and f.tp1nro2 = SNG122TopeV;
    exception
      when others then
        garantia := 'N';
    end;
  else
  
    begin
      select 'N'
        into garantia
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 610011
         and f.tp1corr1 = 1
         and f.tp1corr3 > 0
         and f.tp1nro1 = modulo;
    exception
      when others then
        garantia := 'S';
    end;
  end if;

  monto_cap   := montocapital;
  monto_c_gar := garantia;
end sp_cr_corresponde_garantia;
/

