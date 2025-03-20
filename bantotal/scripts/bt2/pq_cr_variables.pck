create or replace package pq_cr_variables is

  -- Author  : KVALENCIAC
  -- Created : 11/08/2021 
  -- Purpose : 
     
  procedure sp_REP_PLAZO (vn_Pgcod in number, 
                          vn_instancia   in number,
                          vc_REP_PLAZO out number
                             ) ;
  
end pq_cr_variables;
/

create or replace package body pq_cr_variables is

procedure sp_REP_PLAZO ( vn_Pgcod in number, 
                          vn_instancia   in number,
                          vc_REP_PLAZO out number)
is
ln_XWfEmpresa number;  
ln_XWfSucursal number; 
ln_XWfModulo number;
ln_XWfMoneda number;
ln_XWfPapel number;
ln_XWfCuenta number;
ln_XWfOperacion number;
ln_XWfSubope number;
ln_XWfTipOpe number;
ln_XLloAopzo number;
begin
    begin 
    select XWfEmpresa,  
           XWfSucursal, 
           XWfModulo,   
           XWfMoneda,   
           XWfPapel,    
           XWfCuenta,   
           XWfOperacion,
           XWfSubope,
           XWfTipOpe
           into
           ln_XWfEmpresa,  
           ln_XWfSucursal,
           ln_XWfModulo, 
           ln_XWfMoneda, 
           ln_XWfPapel, 
           ln_XWfCuenta, 
           ln_XWfOperacion,
           ln_XWfSubope ,
           ln_XWfTipOpe 
    from xwf700
    where xwfprcins=vn_instancia 
      and xwfcar3='1';
  exception
     when others then
        ln_XWfCuenta :=0;
  end;
  ln_XLloAopzo := 0;
  if ( ln_XWfCuenta > 0 ) then
    Begin
      select XLloAopzo 
             into ln_XLloAopzo
      from X054007
      where  PgCod  = ln_XWfEmpresa  
      and XlloAomod = ln_XWfModulo
      and XlloAosuc = ln_XWfSucursal
      and XlloAomda = ln_XWfMoneda 
      and XlloAopap = ln_XWfPapel 
      and XlloAocta = ln_XWfCuenta
      and XlloAooper= ln_XWfOperacion
      and XlloAosbop= ln_XWfSubope
      and XlloAotope =ln_XWfTipOpe ;
    exception
      when others then
        ln_XLloAopzo := 0;
    end;
  end if;
  vc_REP_PLAZO:=  ln_XLloAopzo;          
end sp_REP_PLAZO;
end pq_cr_variables;
/

