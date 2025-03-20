create or replace procedure SP_CORREL_SQ(P_C_NOMSEQ IN varchar2,
                                         P_C_CODUSU IN varchar2,
                                         P_N_CORREL OUT number) is
  lc_select varchar2(500);
  --  pragma autonomous_transaction;
begin

  delete from crdtcap
   where c_descri1 = P_C_NOMSEQ
     and c_descri2 = P_C_CODUSU;

  lc_select := 'insert into crdtcap(c_descri1, c_descri2, n_monto1) select ' || '''' ||
               P_C_NOMSEQ || '''' || ',' || '''' || P_C_CODUSU || '''' || ',' ||
               P_C_NOMSEQ || '.nextval from dual';

  execute immediate (lc_select);

  select n_monto1
    into P_N_CORREL
    from crdtcap
   where c_descri1 = P_C_NOMSEQ
     and c_descri2 = P_C_CODUSU;

end SP_CORREL_SQ;
/

