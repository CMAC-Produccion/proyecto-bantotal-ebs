create or replace function fn_direccion_cliente(
                                                lv_pepais in number,
                                                lv_petdoc in number,
                                                lv_pendoc in varchar2,
                                                lv_docod  in number,
                                                lv_tipo   in varchar2
                                               ) return varchar2 is
    -- lv_docod 1(Domicilio) 3 (Negocio)

    lc_direccion varchar2(200);
    lv_pendoc2 char(12);

  begin

    lv_pendoc2 := lv_pendoc;

    begin

      SELECT
             CASE  lv_tipo
                   WHEN 'DIR'  THEN sngc13Dir
                   WHEN 'DPTO' THEN (select DepNom from FST068 where Pais = lv_pepais and DepCod = sngc13Dpto)
                   WHEN 'PROV' THEN (select LocNom from FST070 where Pais = lv_pepais and DepCod = sngc13Dpto and LocCod =sngc13Prov)
                   WHEN 'DIS'  THEN (select Fst071Dsc from FST071 where Fst071Pai = lv_pepais and Fst071Dpt = sngc13Dpto and Fst071Loc =sngc13Prov and Fst071Col=sngc13Dist)
             END
       into  lc_direccion
      FROM  SNGC13
      WHERE
            Docod = lv_docod
        and sngc13Corr = 1
        and sngc13Pais = lv_pepais
        and sngc13Tdoc = lv_petdoc
        --and trim(sngc13Ndoc) = lv_pendoc2;
        and sngc13Ndoc = lv_pendoc;

    exception
      when no_data_found then
        lc_direccion := 'xxx'/*null*/;
      end;

  return lc_direccion;
end;
/

