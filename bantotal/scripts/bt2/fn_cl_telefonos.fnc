create or replace function fn_cl_telefonos(
                            lv_pepais in number,
                            lv_petdoc in number,
                            lv_pendoc in varchar2
                          ) return varchar2
  IS

    lv_pendoc2 char(12);
    lv_telefonos varchar2(50);

    cursor c_tele_pers is
           select Dotelfp
             from Fsr005
            Where Pepais = lv_pepais
              and Petdoc = lv_petdoc
              and Pendoc = lv_pendoc2
              and Docod  = 1
            ;

  BEGIN
    lv_pendoc2 := lv_pendoc;

    for i in c_tele_pers  loop
        lv_telefonos := lv_telefonos || trim(i.Dotelfp)|| ',';
    end loop;
    lv_telefonos := substr(lv_telefonos, 1, length(lv_telefonos) - 1);
    return lv_telefonos;

  EXCEPTION
    when others then
         return null;

  END fn_cl_telefonos;
/

