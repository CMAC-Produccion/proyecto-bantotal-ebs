create or replace procedure sp_valida_NONUMERO(P_C_VALOR IN VARCHAR2,
                                             p_c_indica out varchar2
                                            ) is

V1 VARCHAR2(1);                                            
V2 VARCHAR2(1);                                            
begin
  bEGIN
    select case
             when REGEXP_LIKE(P_C_VALOR, '[A-Za-züÜñÑ-]') then
              'S'
             else
              'N'
           end c_codane
      into V1
      from dual;
  Exception
  When others then
    V1 := 'E';
  END;  
begin
  select case
           when REGEXP_LIKE(P_C_VALOR, '[0-9]') then
            'N'
           else
            'S'
         end c_codane
    into V2
    from dual;
Exception
When others then
  V2 := 'E';
END;  
  
IF V1 = V2 THEN
  IF V1 = 'S' THEN
    p_c_indica := 'S';
  ELSE
    p_c_indica := 'N';
  END IF;  
ELSE
  p_c_indica := 'N';
END IF;

end sp_valida_nonumero;
/

