create or replace package pq_biusrgst_maintain is
  procedure sp_biusrgst_add (ln_cod in number,
                             lv_usr in varchar2,
                             lv_tip in varchar2,
                             lv_des in varchar2
                            );
  procedure sp_biusrgst_del (lv_id in varchar2
                            );
  procedure sp_biusrgst_upd (lv_id in varchar2,
                             ln_cod in number,
                             lv_usr in varchar2,
                             lv_tip in varchar2,
                             lv_des in varchar2
                            );
end pq_biusrgst_maintain;
/

create or replace package body pq_biusrgst_maintain is
  procedure sp_biusrgst_add (ln_cod in number,
                             lv_usr in varchar2,
                             lv_tip in varchar2,
                             lv_des in varchar2
                            )
  is
  begin
    insert into biusrgst values (ln_cod,lv_usr,lv_tip,lv_des);
    commit;
    dbms_output.put_line('Procesado Correctamente.');
  exception When Others Then
    dbms_output.put_line('Error al procesar: '||SQLCODE||'-'||SQLERRM);
  end sp_biusrgst_add;

  procedure sp_biusrgst_del (lv_id in varchar2
                            )
  is
  begin
    delete from biusrgst where rowid = lv_id;
    commit;
    dbms_output.put_line('Procesado Correctamente.');
  exception When Others Then
    dbms_output.put_line('Error al procesar: '||SQLCODE||'-'||SQLERRM);
  end sp_biusrgst_del;

  procedure sp_biusrgst_upd (lv_id in varchar2,
                             ln_cod in number,
                             lv_usr in varchar2,
                             lv_tip in varchar2,
                             lv_des in varchar2
                            )
  is
  begin
    update biusrgst set cod = ln_cod, usr = lv_usr, tip = lv_tip, des = lv_des where rowid = lv_id;
    commit;
    dbms_output.put_line('Procesado Correctamente.');
  exception When Others Then
    dbms_output.put_line('Error al procesar: '||SQLCODE||'-'||SQLERRM);
  end sp_biusrgst_upd;
end pq_biusrgst_maintain;
/

