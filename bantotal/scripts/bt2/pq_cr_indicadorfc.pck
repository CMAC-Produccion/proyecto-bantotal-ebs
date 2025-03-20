create or replace package pq_cr_indicadorFC is

  Procedure Sp_cr_FlujoCaja(pn_ins    in number,
                            pc_nom    in char,
                            pd_fecpro in date,
                            pc_hora   in char,
                            pc_usr    in char,
                            pc_flg    out varchar2);

end pq_cr_indicadorFC;
/

create or replace package body pq_cr_indicadorFC is

  Procedure Sp_cr_FlujoCaja(pn_ins    in number,
                            pc_nom    in char,
                            pd_fecpro in date,
                            pc_hora   in char,
                            pc_usr    in char,
                            pc_flg    out varchar2) is
  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ln_tarea number(4);
    lc_var   char(30) := 'CUOTA_VARIABLE';
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    pq_cr_resolutor_cappago.sp_cr_flujocaja(ln_emp10  => ln_emp,
                                            ln_mod10  => ln_mod,
                                            ln_suc10  => ln_suc,
                                            ln_mda10  => ln_mda,
                                            ln_pap10  => ln_pap,
                                            ln_cta10  => ln_cta,
                                            ln_oper10 => ln_ope,
                                            ln_sbop10 => ln_sbo,
                                            ln_tope10 => ln_top,
                                            ln_flagFC => pc_flg);
  
    --insertar log
    begin
      select a.wftaskcod
        into ln_tarea
        from wfwrkitems a
       where a.wfinsprcid = pn_ins
         and a.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom --mod@abr 20190911
       and a.jaqz687var = lc_var --mod@abr 20190911       
    ;
    commit;
  
    insert into jaqz687
      (jaqz687prg,
       jaqz687var,
       jaqz687ins,
       jaqz687tar,
       jaqz687vc1,
       jaqz687fec,
       jaqz687hor,
       jaqz687usr)
    values
      (pc_nom,
       lc_var,
       pn_ins,
       ln_tarea,
       pc_flg,
       pd_fecpro,
       pc_hora,
       pc_usr);
  
    commit;
  
  end Sp_cr_FlujoCaja;

end pq_cr_indicadorFC;
/

