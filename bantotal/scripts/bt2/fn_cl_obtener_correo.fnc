CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_CORREO" (
                                               P_pais in number,
                                               P_tdoc in number,
                                               P_nrodoc in varchar2
                                             ) return varchar2 is
    v_correo varchar2(100);
  begin
    begin
      SELECT substr(trim(PEXTXT), 1, instr(trim(PEXTXT), '\') - 1)
      into  v_correo
      FROM  fsx001 a
      WHERE a.pepais = P_pais
        and a.petdoc = P_tdoc
        and a.pendoc = rpad(P_nrodoc, 12, ' ')   
        and a.txcod = 0
        and length(substr(trim(a.PEXTXT), 1, instr(trim(a.PEXTXT), '\') - 1)) > 0
        and a.PEXREN =(SELECT MAX(x.PEXREN)
                            FROM fsx001 x
                            WHERE x.pepais = a.pepais
                              and x.petdoc = a.petdoc
                              and x.pendoc = a.pendoc
                              and x.txcod  = a.txcod
                              and length(substr(trim(x.PEXTXT),1,instr(trim(x.PEXTXT), '\') - 1)) > 0
                          );
    exception
      when no_data_found then
        v_correo := NULL;
      end;
  return lower(v_correo);
end;
/

