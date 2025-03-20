create or replace package pq_cr_rte_tasas is

  -- Author  : RMONTESR
  -- Created : 14/04/2021 18:15:56
  -- Purpose : 

  procedure sp_cr_veriftasas(ln_pgcod  in number,
                             ln_suc    in number,
                             ln_itmod  in number,
                             ln_ittran in number,
                             ln_itrel  in number,
                             ln_itord  in number,
                             ln_itsbor in number,
                             lc_cancel out varchar2,
                             ln_tasa1  out number,
                             ln_tasa2  out number);

end pq_cr_rte_tasas;
/

create or replace package body pq_cr_rte_tasas is

  procedure sp_cr_veriftasas(ln_pgcod  in number,
                             ln_suc    in number,
                             ln_itmod  in number,
                             ln_ittran in number,
                             ln_itrel  in number,
                             ln_itord  in number,
                             ln_itsbor in number,
                             lc_cancel out varchar2,
                             ln_tasa1  out number,
                             ln_tasa2  out number) is
  
    ln_modulo    number;
    ln_tipoper   number;
    ln_sucursal  number;
    ln_moneda    number;
    ln_papel     number;
    ln_cuenta    number;
    ln_operacion number;
    ln_suboper   number;
  
    ln_modulo_2    number;
    ln_tipoper_2   number;
    ln_sucursal_2  number;
    ln_moneda_2    number;
    ln_papel_2     number;
    ln_cuenta_2    number;
    ln_operacion_2 number;
    ln_suboper_2   number;
    ln_tasaaux     number;
  
  begin
  
    begin
      select t1.modulo,
             t1.ittope,
             t1.itsuc,
             t1.moneda,
             t1.papel,
             t1.ctnro,
             t1.itoper,
             t1.itsubo
        into ln_modulo,
             ln_tipoper,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper
        from fsd016 t1
       where t1.pgcod = ln_pgcod
         and t1.itsuc = ln_suc
         and t1.itmod = ln_itmod
         and t1.ittran = ln_ittran
         and t1.itnrel = ln_itrel
         and t1.itord = ln_itord
         and t1.itsbor = ln_itsbor;
    end;
  
    begin
      select t2.r2mod,
             t2.r2tope,
             t2.r2suc,
             t2.r2mda,
             t2.r2pap,
             t2.r2cta,
             t2.r2oper,
             t2.r2sbop,
             t2.r1tope,
             t2.r1suc
        into ln_modulo_2,
             ln_tipoper_2,
             ln_sucursal_2,
             ln_moneda_2,
             ln_papel_2,
             ln_cuenta_2,
             ln_operacion_2,
             ln_suboper_2,
             ln_tipoper,
             ln_sucursal
        from fsr011 t2
       where t2.r1cod = ln_pgcod
         and t2.r1mod = ln_itmod
            --and t2.r1suc = ln_sucursal
         and t2.r1mda = ln_moneda
         and t2.r1pap = ln_papel
         and t2.r1cta = ln_cuenta
         and t2.r1oper = ln_operacion
         and t2.r1sbop = ln_suboper
            --and t2.r1tope = ln_tipoper
         and t2.r2mod = 117;
    
    end;
  
    begin
      ln_tasa1 := pq_cr_cuotamora.BT_Tasa_Interes(ln_pgcod,
                                                  ln_itmod,
                                                  ln_sucursal,
                                                  ln_moneda,
                                                  ln_papel,
                                                  ln_cuenta,
                                                  ln_operacion,
                                                  ln_suboper,
                                                  ln_tipoper);
      ln_tasa2 := pq_cr_cuotamora.BT_Tasa_Interes(ln_pgcod,
                                                  ln_modulo_2,
                                                  ln_sucursal_2,
                                                  ln_moneda_2,
                                                  ln_papel_2,
                                                  ln_cuenta_2,
                                                  ln_operacion_2,
                                                  ln_suboper_2,
                                                  ln_tipoper_2);
    exception
      when others then
        ln_tasa1 := 0;
        ln_tasa2 := 0;
    end;
    begin
      select x.xlltasap
        into ln_tasaaux
        from x054023 x
       where x.xllpgcod = ln_pgcod
         and x.xllaomod = 116
         and x.xllaosuc = ln_sucursal
         and x.xllaomda = ln_moneda
         and x.xllaopap = ln_papel
         and x.xllaocta = ln_cuenta
         and x.xllaooper = ln_operacion
         and x.xllaosbop = ln_suboper
         and x.xllaotop = ln_tipoper;
    
    exception
      when others then
        ln_tasaaux := 0;
    end;
    if ln_tasa1 = 0 then
      ln_tasa1 := ln_tasaaux;
    end if;
    if ln_tasa1 = ln_tasa2 then
      lc_cancel := 'S';
    else
      lc_cancel := 'N';
    end if;
  
  end sp_cr_veriftasas;

end pq_cr_rte_tasas;
/

