create or replace package jc_fa_biendeprynodepr_pkg authid current_user is

  procedure sp_inserta_data(pn_request_id number
                           ,pc_periodo    varchar2
                           ,pn_org_id     number);

  procedure sp_elimina_data(pn_request_id number);

end;
/
create or replace package body jc_fa_biendeprynodepr_pkg is

  procedure sp_inserta_data(pn_request_id number
                           ,pc_periodo    varchar2
                           ,pn_org_id     number) is
  
    pc_date_h    varchar2(28);
 
    vd_fecha_ini date;
    vd_fecha_fin date;
  
  
    cursor c_main_0 is
      select a.invoice_number
            ,a.description
            ,a.fixed_assets_cost
            ,a.vendor_name
            ,a.vendor_number
            ,a.po_number
            ,a.invoice_date invoice_created_date
            ,a.invoice_date
            ,b.concatenated_segments
            ,a.book_type_code
            ,a.po_vendor_id
            ,a.invoice_id
        from fa_mass_additions_v      a
            ,gl_code_combinations_kfv b
       where 1 = 1
         and a.payables_code_combination_id = b.code_combination_id
        -- and a.queue_name = 'NEW'
        -- and a.posting_status = 'NEW'
       order by a.invoice_date;
  
  begin
  
    begin
      select start_date
            ,end_date
        into vd_fecha_ini
            ,vd_fecha_fin
        from gl_period_statuses
       where application_id = 101
         and ledger_id = xxbol.ts_gl_utils.fu_ledger_id(pn_org_id)
         and period_name = pc_periodo;
    exception
      when no_data_found then
        vd_fecha_ini := null;
        vd_fecha_fin := null;
    end;
  
    select to_char(sysdate, 'HH:MI:SS am')
      into pc_date_h
      from dual;
  
    for a in c_main_0 loop
    
      insert into jc.jc_fa_biendeprynodepr_all
        (request_id
        ,invoice_number
        ,description
        ,fixed_assets_cost
        ,vendor_name
        ,vendor_number
        ,po_number
        ,invoice_created_date
        ,invoice_date
        ,concatenated_segments
        ,book_type_code
        ,po_vendor_id
        ,invoice_id)
      values
        (pn_request_id
        ,a.invoice_number
        ,a.description
        ,a.fixed_assets_cost
        ,a.vendor_name
        ,a.vendor_number
        ,a.po_number
        ,a.invoice_created_date
        ,a.invoice_date
        ,a.concatenated_segments
        ,a.book_type_code
        ,a.po_vendor_id
        ,a.invoice_id);
    
    end loop;
  
    commit;
  
  end;

  procedure sp_elimina_data(pn_request_id number) is
  begin
    delete from jc.jc_fa_biendeprynodepr_all
     where request_id = pn_request_id;
    null;
    commit;
  end;

end;
/
