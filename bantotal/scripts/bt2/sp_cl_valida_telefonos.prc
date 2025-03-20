create or replace procedure SP_CL_VALIDA_TELEFONOS(P_N_PEPAIS in number,
                                                   P_N_PETDOC in number,
                                                   P_C_PENDOC in varchar2,
                                                   P_C_RESUL  out number,
                                                   P_C_TIPDOM out varchar2,
                                                   P_C_TIPTEL out varchar2,
                                                   P_C_NUMTEL out varchar2) is

  vpendoc char(12) := rpad(P_C_PENDOC, 12, ' ');

  cursor fonos is
    select a3.dodepcodp depa,
           a2.sngc16ttel tipo,
           trim(a1.dotelfp) fono,
           a4.sngc16dsc,
           a6.donom
      from FSR005 a1, SNGC17 a2, fsd005 a3, SNGC16 a4, sngc13 a5, fst015 a6
     where a1.pepais = a2.sngc17pais
       and a1.petdoc = a2.sngc17tdoc
       and a1.pendoc = a2.sngc17ndoc
       and a1.docod = a2.sngc17dcod
       and a1.doordp = a2.sngc17corr
       and a3.pepais = a2.sngc17pais
       and a3.petdoc = a2.sngc17tdoc
       and a3.pendoc = a2.sngc17ndoc
       and a3.docod = a2.sngc17dcod
       and a2.sngc16ttel = a4.sngc16ttel
       and a3.pepais = a5.sngc13pais
       and a3.petdoc = a5.sngc13tdoc
       and a3.pendoc = a5.sngc13ndoc
       and a3.docod = a5.docod
       and a5.docod = a6.docod
       and a5.sngc13est = 'H'
       and a3.pepais = P_N_PEPAIS
       and a3.petdoc = P_N_PETDOC
       and a3.pendoc = vpendoc;

  largo    number;
  largo_f  number;
  v_numero number;

begin

  P_C_RESUL := 0;

  for i in fonos loop
  
    P_C_TIPDOM := i.donom;
    P_C_TIPTEL := i.sngc16dsc;
    P_C_NUMTEL := i.fono;
  
    largo_f := length(i.fono);
  
    if i.tipo = 2 then
      -- fijo
      if i.depa in (7, 15) then
        -- lima y callao
        largo := 7;
      else
        largo := 6;
      end if;
    else
      --celulares
      largo := 9;
    end if;
  
    if largo_f <> largo then
      P_C_RESUL := 1; -- tamaño incorrecto 
      return;
    end if;
  
    begin
      v_numero := TO_NUMBER(i.fono);
    
      if v_numero = 0 then
        P_C_RESUL := 2; -- formato incorrecto 
        return;
      end if;
    exception
      when value_error then
        P_C_RESUL := 2; -- formato incorrecto 
        return;
    end;
  end loop;

end SP_CL_VALIDA_TELEFONOS;
/

