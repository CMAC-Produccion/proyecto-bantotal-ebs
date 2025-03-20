create or replace package pq_cr_cred_teso_mant is
  procedure sp_cr_cred_teso_add (ln_bcemp in number,
                               ln_bcsuc in number,
                               ln_bcmda in number,
                               ln_bcpap in number,
                               ln_bccta in number,
                               ln_bcoper in number,
                               ln_bcsbop in number,
                               ln_bctop in number,
                               ln_bcmod in number
                              );
  procedure sp_cr_cred_teso_del (ln_rowid in varchar2
                            );
end pq_cr_cred_teso_mant;
/

create or replace package body pq_cr_cred_teso_mant is
  procedure sp_cr_cred_teso_add (ln_bcemp in number,
                               ln_bcsuc in number,
                               ln_bcmda in number,
                               ln_bcpap in number,
                               ln_bccta in number,
                               ln_bcoper in number,
                               ln_bcsbop in number,
                               ln_bctop in number,
                               ln_bcmod in number
                              )
  is
  begin
    insert into JAQZ498 values (ln_bcemp,ln_bcsuc,ln_bcmda,ln_bcpap,ln_bccta,ln_bcoper,ln_bcsbop,ln_bctop,ln_bcmod);
    commit;
    dbms_output.put_line('Procesado Correctamente.');
  exception When Others Then
    dbms_output.put_line('Error al procesar: '||SQLCODE||'-'||SQLERRM);
  end sp_cr_cred_teso_add;

  procedure sp_cr_cred_teso_del (ln_rowid in varchar2
                            )
  is
  begin
    delete from JAQZ498 where rowid = ln_rowid;
    commit;
    dbms_output.put_line('Procesado Correctamente.');
  exception When Others Then
    dbms_output.put_line('Error al procesar: '||SQLCODE||'-'||SQLERRM);
  end sp_cr_cred_teso_del;

end pq_cr_cred_teso_mant;
/

