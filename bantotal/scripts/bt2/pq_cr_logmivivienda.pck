create or replace package PQ_CR_LOGMIVIVIENDA is
  /* BHERNARD S. BEISAGA ARENAS
    * INGRESO DE DATOS EN ARCHIVO LOG AQPB582 PARA CREDITOS MI VIVVIENDA
    */

     procedure sp_cr_log_mivivienda(vi_aprobacion in varchar2, vi_tabla in varchar2, vi_cinst in number, vi_fechasis in date);

end;
/

create or replace package body PQ_CR_LOGMIVIVIENDA is



 procedure sp_cr_log_mivivienda(vi_aprobacion in varchar2, vi_tabla in varchar2, vi_cinst in number, vi_fechasis in date) is
    /* BHERNARD S. BEISAGA ARENAS
    * INGRESO DE DATOS EN ARCHIVO LOG AQPB582 PARA CREDITOS MI VIVVIENDA
    *
    */
      correl  number;
      variabl  VARCHAR2(10):='APROB_FMV';
      err_code    NUMBER;
      err_msg   VARCHAR2(1500);

    begin
      begin
        --select count(*) into correl from aqpb582 WHERE SUBSTR(AQPB582VAR, 1, 9) =  variabl ; -- correaltivo de la variable
        select count(*) into correl from aqpb582 WHERE AQPB582VAR =  variabl ||'-'||vi_tabla ; -- correaltivo de la variable
         correl := correl +1;
      end;

      begin
          insert into aqpb582 (aqpb582nro,aqpb582var,aqpb582val,aqpb582regl,aqpb582inst,aqpb582fec,aqpb582hor)
          values (correl,variabl ||'-'||vi_tabla,vi_aprobacion,0,vi_cinst, trunc(vi_fechasis) , to_char(sysdate, 'HH24:MI:SS') );
                 DBMS_OUTPUT.put_line('Filas insertadas AQPB582: ' || SQL%ROWCOUNT);
          COMMIT;
      exception
            when others then
                   err_code := SQLCODE;
                   err_msg := SUBSTR(SQLERRM, 1, 500);
                   DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
          ROLLBACK;
      end ;
    end sp_cr_log_mivivienda;


end;
/

