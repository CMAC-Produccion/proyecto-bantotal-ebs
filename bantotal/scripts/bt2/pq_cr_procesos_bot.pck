create or replace package PQ_CR_PROCESOS_BOT is

  -- Author  : ENINAH
  -- Created : 26/09/2022 15:57:12
  -- Purpose : Este paquete se encargara de todos los procesos que realice el bot de correos.

  procedure sp_cr_devolver_corr_exte(cod_proce in number,
                                     inst      in number,
                                     corr      out number,
                                     corr2     out number,
                                     cod_err   out number,
                                     msj_err   out varchar2);
end PQ_CR_PROCESOS_BOT;
/

create or replace package body PQ_CR_PROCESOS_BOT is

  procedure sp_cr_devolver_corr_exte(cod_proce in number,
                                     inst      in number,
                                     corr      out number,
                                     corr2     out number,
                                     cod_err   out number,
                                     msj_err   out varchar2) is
  begin
    begin
      select B.AQPC565CORR, B.AQPC565CORR2
        into corr, corr2
        from (select *
                from AQPC565 A
               where A.AQPC565IDCPE = cod_proce
                 and A.Aqpc565inst = inst
               order by AQPC565CORR desc) B
       where rownum = 1;
    exception
      when others then
        msj_err := 'No hay correlativo asociado para el proceso enviado';
        cod_err := 1;
    end;
  end sp_cr_devolver_corr_exte;
end PQ_CR_PROCESOS_BOT;
/

