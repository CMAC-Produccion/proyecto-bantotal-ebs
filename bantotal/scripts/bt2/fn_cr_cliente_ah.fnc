create or replace function fn_cr_cliente_ah (pn_pai in number,pn_tdo in number,pc_ndo in char) return char is
lc_existe char(1);

begin
     begin

         lc_existe := 'N';
         begin
           select 'S'
             into lc_existe
             from fsr008 w,
                  fsd011 z
            where z.pgcod = 1
              and w.pepais = pn_pai
              and w.petdoc = pn_tdo
              and w.pendoc = pc_ndo
              and z.sccta = w.ctnro
              and z.scmod = 21
              and z.scstat = 0
              and rownum = 1;
          exception
            when others then 
                 lc_existe := 'N';
          end;

     end;
     return lc_existe;
end fn_cr_cliente_ah;
/

