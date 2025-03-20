create or replace procedure sp_valida_numero(P_C_VALOR IN VARCHAR2,
                                             p_c_indica out varchar2
                                            ) is
begin
  select case
           when REGEXP_LIKE(P_C_VALOR, '[^0-9]') then
            'N'
           else
            'S'
         end c_codane
    into p_c_indica
    from dual;
Exception
When others then              
  p_c_indica := 'N';
end sp_valida_numero;
/

