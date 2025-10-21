create or replace package pq_cr_sequence_equifax is

  -- Author  : MHUAMANIA
  -- Created : 25/09/2025 12:24:44
  -- Purpose : Reemplazo paquete equifax
  PROCEDURE SP_secuencia_aqpb515q(ve_action    IN varchar2,
                                  vo_secuencia out number,
                                  vo_error     out varchar2,
                                  vo_msg_error out varchar2);

end pq_cr_sequence_equifax;
/
create or replace package body pq_cr_sequence_equifax is

  PROCEDURE SP_secuencia_aqpb515q(ve_action    IN varchar2,
                                  vo_secuencia out number,
                                  vo_error     out varchar2,
                                  vo_msg_error out varchar2) IS
    vi_seq    number(18);
    vi_action CHAR(3);
    vi_guiac  number(18);
    fecha     date;
  BEGIN
    BEGIN
      vi_action := TRIM(ve_action);
    
      begin
        SELECT PGFAPE INTO fecha FROM FST017 WHERE PGCOD = 1;
      exception
        when others then
          fecha := null;
      end;
      if vi_action = 'SEQ' THEN
        begin
          select aqpd780guia into vi_guiac from aqpd780;
        exception
          when others then
            vi_guiac := null;
        end;
        if vi_guiac is null then
          select Tp1nro1
            into vi_seq
            from FST198
           Where Tp1cod = 1
             and Tp1cod1 = 11146
             and Tp1corr1 = 1
             and Tp1corr2 = 11
             and Tp1corr3 = 1;
          vo_secuencia := vi_seq + 1;
          DELETE FROM AQPD780;
          INSERT INTO AQPD780
            (AQPD780CORR, AQPD780GUIA, AQPD780FECHA)
          VALUES
            (1, vo_secuencia, fecha);
          vo_error     := '000';
          vo_msg_error := '';
        else
          select aqpd780guia into vi_seq from aqpd780;
          vo_secuencia := vi_seq + 1;
          vo_error     := '000';
          vo_msg_error := '';
          UPDATE AQPD780 SET AQPD780GUIA = vo_secuencia;
        end if;
        COMMIT;
      end if;
    EXCEPTION
      WHEN no_Data_found THEN
        vo_error     := '001';
        vo_msg_error := 'No Existe Sequence (EQUIFAX) Parametrizada.';
    END;
  end;
end pq_cr_sequence_equifax;
/
