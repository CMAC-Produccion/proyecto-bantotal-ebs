create or replace package PQ_CR_RES_PATRIM is

  -- Author  : ABERNEDO
  -- Created : 30/06/2017 01:15:53 p.m.
  -- Purpose : 

  -- Public type declarations
  Procedure Sp_cr_calculo(pn_ins in number, pn_sdo out number);

end PQ_CR_RES_PATRIM;
/

create or replace package body PQ_CR_RES_PATRIM is

  Procedure Sp_cr_calculo(pn_ins in number, pn_sdo out number) is
  
    ln_cuenta  number(9);
    lc_codsbs  char(10);
    ld_fecrcc  date;
    lc_ndo     varchar2(12);
    ln_sdo     number(17, 2);
    ln_sdo_aux number(17, 2);
    cursor clientes(ln_cta in number) is
      select pepais, petdoc, pendoc
        from fsr008 a
       where a.pgcod = 1
         and a.ctnro = ln_cta;
  begin
    --fecha rcc
    begin
      select to_date(a.tpnro, 'ddmmyyyy')
        into ld_fecrcc
        from fst098 a
       where a.pgcod = 1
         and a.tpcod = 7647
         and a.tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    --obtener cuenta
    begin
      select a.xwfcuenta
        into ln_cuenta
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    ln_sdo     := 0;
    ln_sdo_aux := 0;
    for i in clientes(ln_cuenta) loop
      --obtener codigo sbs
      lc_ndo := trim(i.pendoc);
      if i.petdoc <> 9 then
      
      lc_codsbs := null;  --mpostigoc 19/07/2017
      ln_sdo_aux := 0; --mpostigoc 19/07/2017
      
        begin
          select a.c_codsbs
            into lc_codsbs
            from cldrcci a
           where a.d_fecpre = ld_fecrcc
             and a.c_docide = lc_ndo;
        exception
          when others then
            null;
        end;
      else
        begin
          select a.c_codsbs
            into lc_codsbs
            from cldrcci a
           where a.d_fecpre = ld_fecrcc
             and a.c_doctri = lc_ndo;
        exception
          when others then
            null;
        end;
      end if;
    
      --calcula saldo
      begin
        select sum(a.n_salcap)
          into ln_sdo_aux
          from cldrccs a
         where a.d_fecpre = ld_fecrcc
           and a.c_codsbs = lc_codsbs
           and a.c_codemp <> '00104'
           and a.c_cretip in
               ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
           and substr(trim(a.c_cuenta), 1, 4) in
               ('1411', '1413', '1414', '1415', '1416', /*'1418',*/
                '1421', '1423', '1424', '1425', '1426', /*'1428',*/
                '8113', '8123');
      exception
        when others then
          null;
      end;
      ln_sdo := ln_sdo + nvl(ln_sdo_aux, 0);
    end loop;
    pn_sdo := ln_sdo;
  end Sp_cr_calculo;

end PQ_CR_RES_PATRIM;
/

