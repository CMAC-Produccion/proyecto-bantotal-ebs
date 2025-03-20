create or replace package pq_cr_log_evaluaciones is

  -- Author  : RMONTESR
  -- Created : 16/07/2021 09:57:48
  -- Purpose : Guardar log de evaluaciones

  procedure sp_cr_guardar_log(pn_instancia number, pv_resp out varchar2);
  
  procedure sp_cr_guardar_log2(pn_instancia number, pc_usuario varchar, pv_resp out varchar2);

end pq_cr_log_evaluaciones;
/

create or replace package body pq_cr_log_evaluaciones is

  procedure sp_cr_guardar_log(pn_instancia number, pv_resp out varchar2) is
  
    ln_eval numeric;
    ln_taskcod numeric;
  begin
    pv_resp := 'S';
    begin
      select a.sng021eval
        into ln_eval
        from sng021 a
       where a.sng021sol = pn_instancia;
    exception
      when others then
        pv_resp := 'N';
    end;
    
    begin
      select t1.wftaskcod into ln_taskcod
        from wfwrkitems t1
       where t1.wfinsprcid = pn_instancia
         and t1.wfitemstsact = 1
         and rownum <= 1;
    exception
      when others then
        ln_taskcod := 0;
    end;
    begin
      delete from aqpb383 where aqpb383eval = ln_eval and aqpb383taskcod = ln_taskcod;
      commit;
      insert into aqpb383
        (aqpb383eval,
         aqpb383taskcod,
         aqpb383pdoc,
         aqpb383tdoc,
         aqpb383ndoc,
         aqpb383fec,
         aqpb383usu,
         aqpb383sol,
         aqpb383tmod,
         aqpb383fecg,
         aqpb383horg,
         aqpb383user)
        select t1.sng021eval,
               ln_taskcod,
               t1.sng021pdoc,
               t1.sng021tdoc,
               t1.sng021ndoc,
               t1.sng021fec,
               t1.sng021usu,
               t1.sng021sol,
               t1.sng021tmod,
               to_date(sysdate,'DD/MM/YYYY'),
               to_char(sysdate,'HH24:MI:SS'),
               ''
          from sng021 t1
         where t1.sng021eval = ln_eval;
         commit;
    
    end;
  
    begin
      delete from aqpb384 where aqpb384eval = ln_eval and aqpb384taskcod = ln_taskcod;
      commit;
      insert into aqpb384
        (aqpb384eval, aqpb384cod, aqpb384taskcod, aqpb384mto, aqpb384fecg, aqpb384horg, aqpb384user)
        select t2.sng021eval, t2.sng026cod, ln_taskcod, t2.sng023mto, to_date(sysdate,'DD/MM/YYYY'), to_char(sysdate,'HH24:MI:SS'), ''
          from sng023 t2
         where t2.sng021eval = ln_eval;
         commit;
    end;
  
  end sp_cr_guardar_log;
  --------------------------------------------------------------------------------------------------
   procedure sp_cr_guardar_log2(pn_instancia number, pc_usuario varchar, pv_resp out varchar2) is
  
    ln_eval numeric;
    ln_taskcod numeric;
  begin
    pv_resp := 'S';
    begin
      select a.sng021eval
        into ln_eval
        from sng021 a
       where a.sng021sol = pn_instancia;
    exception
      when others then
        pv_resp := 'N';
    end;
    
    begin
      select t1.wftaskcod into ln_taskcod
        from wfwrkitems t1
       where t1.wfinsprcid = pn_instancia
         and t1.wfitemstsact = 1
         and rownum <= 1;
    exception
      when others then
        ln_taskcod := 0;
    end;
    begin
      delete from aqpb383 where aqpb383eval = ln_eval and aqpb383taskcod = ln_taskcod;
      commit;
      insert into aqpb383
        (aqpb383eval,
         aqpb383taskcod,
         aqpb383pdoc,
         aqpb383tdoc,
         aqpb383ndoc,
         aqpb383fec,
         aqpb383usu,
         aqpb383sol,
         aqpb383tmod,
         aqpb383fecg,
         aqpb383horg,
         aqpb383user)
        select t1.sng021eval,
               ln_taskcod,
               t1.sng021pdoc,
               t1.sng021tdoc,
               t1.sng021ndoc,
               t1.sng021fec,
               t1.sng021usu,
               t1.sng021sol,
               t1.sng021tmod,
               to_date(sysdate,'DD/MM/YYYY'),
               to_char(sysdate,'HH24:MI:SS'),
               pc_usuario
          from sng021 t1
         where t1.sng021eval = ln_eval;
         commit;
    
    end;
  
    begin
      delete from aqpb384 where aqpb384eval = ln_eval and aqpb384taskcod = ln_taskcod;
      commit;
      insert into aqpb384
        (aqpb384eval, aqpb384cod, aqpb384taskcod, aqpb384mto, aqpb384fecg, aqpb384horg, aqpb384user)
        select t2.sng021eval, t2.sng026cod, ln_taskcod, t2.sng023mto, to_date(sysdate,'DD/MM/YYYY'), to_char(sysdate,'HH24:MI:SS'), pc_usuario
          from sng023 t2
         where t2.sng021eval = ln_eval;
         commit;
    end;
  
  end sp_cr_guardar_log2;
end pq_cr_log_evaluaciones;
/

