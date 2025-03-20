CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_CLIENTE" (
                                               P_pais in number,
                                               P_tdoc in number,
                                               P_numdoc in varchar2 --NUMBER(3) 
                                             ) return TYPE_NOM_CLIENTE is
v_nomcliente varchar2(50);
v_apecliente varchar2(50);
v_nombre_apellido TYPE_NOM_CLIENTE;
  begin
    begin
    select INITCAP(PFNOM1),INITCAP(PFAPE1)  
    into v_nomcliente,v_apecliente
    from FSD002 a
    where a.Pfpais = P_pais
      and a.Pftdoc = P_tdoc
      and a.PFNDOC = rpad(P_numdoc, 12, ' ');
    v_nombre_apellido := TYPE_NOM_CLIENTE(v_nomcliente, v_apecliente);

  exception
  when no_data_found then
      v_nombre_apellido := NULL;
        end;
      return v_nombre_apellido;
end;
/

