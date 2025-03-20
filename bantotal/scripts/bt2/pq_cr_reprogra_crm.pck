create or replace package pq_Cr_reprogra_crm is

  procedure sp_verifica(pn_ins in number,
                        pc_flg out char,
                        pn_sol out number);

end;
/

create or replace package body pq_Cr_reprogra_crm is

--- 2020.08.10 dcastro se comento trim por optimizacion

  procedure sp_verifica(pn_ins in number,
                        pc_flg out char,
                        pn_sol out number) is
  
    ln_cta number(9);
    ln_ope number(9);
    lc_doc char(12);
    lc_flg char(1) := 'N';
    ln_sol number;
  begin
  
    begin
      select a.xwfcuenta, a.xwfoperacion
        into ln_cta, ln_ope
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng001ndoc
        into lc_doc
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S', solicitud
        into lc_flg, ln_sol
--        from REPROG@cmr
        from REPROG--RFC
       where dnicliente = TRIM(lc_doc)  ---2020.08.08 se comentó trim(dnicliente)
         and to_number(substr(cuentaoperacion,
                              1,
                              (instr(cuentaoperacion, '-') - 1))) = ln_cta
         and to_number(substr(cuentaoperacion,
                              (instr(cuentaoperacion, '-') + 1),
                              LENGTH(cuentaoperacion))) = ln_ope
         and estadosolicitud = 'BT';
    exception
      when others then
        null;
    end;
  
    pc_flg := nvl(lc_flg, 'N');
    pn_sol := nvl(ln_sol, 0);
  
  end sp_verifica;
end pq_Cr_reprogra_crm;
/

