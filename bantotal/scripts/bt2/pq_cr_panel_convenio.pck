create or replace package pq_cr_panel_convenio is

  -- Author  : RMONTESR
  -- Created : 30/04/2021 17:08:32
  -- Purpose : Procedimientos resolutores panel convenio condicion laboral

  procedure sp_cr_condicion_laboral(pn_insta in numeric,
                                    pv_rpta  out varchar2);

  procedure sp_cr_antiguedad_claboral(pn_insta in numeric,
                                      pd_fape  in date,
                                      pn_rpta  out numeric);

  procedure sp_cr_validar_tope(pn_insta in numeric, pv_rpta out varchar2);

end pq_cr_panel_convenio;
/

create or replace package body pq_cr_panel_convenio is

  procedure sp_cr_condicion_laboral(pn_insta in numeric,
                                    pv_rpta  out varchar2) is
  
    lv_condlab varchar2(255);
  begin
  
    pv_rpta := 'N';
    begin
      select t2.jaqa305va2
        into lv_condlab
        from sng001 t1
       inner join jaqa305 t2
          on t2.jaqa305cta = t1.sng001cta
       where t1.sng001inst = pn_insta;
    exception
      when others then
        lv_condlab := '';
    end;
    pv_rpta := lv_condlab;
  
  end sp_cr_condicion_laboral;
  ------------------------------------------------------------------------------

  procedure sp_cr_antiguedad_claboral(pn_insta in numeric,
                                      pd_fape  in date,
                                      pn_rpta  out numeric) is
  
  begin
  
    begin
      select pd_fape - t2.sngc60fine
        into pn_rpta
        from sng001 t1
       inner join sngc60 t2
          on t2.sngc60pais = t1.sng001pais
         and t2.sngc60tdoc = t1.sng001tdoc
         and t2.sngc60ndoc = t1.sng001ndoc
       where t1.sng001inst = pn_insta;
    exception
      when others then
        pn_rpta := 0;
    end;
  
  end sp_cr_antiguedad_claboral;
  ----------------------------------------------------------------------------------

  procedure sp_cr_validar_tope(pn_insta in numeric, pv_rpta out varchar2) is
    ln_conta1 numeric;
  begin
  
    begin
      select count(*)
        into ln_conta1
        from xwf700 t1
       inner join jaqa305 t2
          on t2.jaqa305cta = t1.xwfcuenta
       inner join fpp104 t3
          on t3.pp104ncart = t2.jaqa305nca
       where t1.xwfprcins = pn_insta
         and t3.pp104val2 = t1.xwftipope;
    exception
      when others then
        ln_conta1 := 0;
    end;
    if ln_conta1 > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
  
  end sp_cr_validar_tope;

end pq_cr_panel_convenio;
/

