create or replace function fn_tipo_cambio_fijo(P_FECHA in date) return number
is
  ln_tipcam fsh005.cotcbi%type;
Begin
     Select cotcbi
       Into ln_tipcam
       From (
               select u.cotcbi
                 From fsh005 u
                Where moneda=101
                  And cofdes <= P_FECHA
             Order by cofdes desc
            )
      Where rownum = 1;

     Return ln_tipcam;
Exception when others then
          return 0;
end fn_tipo_cambio_fijo;
/

