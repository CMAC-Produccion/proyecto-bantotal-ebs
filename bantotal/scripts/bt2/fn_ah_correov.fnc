create or replace function FN_AH_CORREOV(P_pgcod in number,
                                     P_Cuenta in number) return varchar2 is


   lc_Correo varchar2(300) := '';
   lc_tmp varchar(65);

   cursor d_Correo(P_pgcod in number,
                   P_Cuenta in number)
                  is (select x_08.ctxtxt
                        from fsx008 x_08
                       where x_08.pgcod = P_pgcod
                         and x_08.ctnro = P_Cuenta
                         and x_08.txcod = 0);

begin

   for d_data in d_Correo(P_pgcod, P_Cuenta)
   loop

      lc_tmp := trim(replace(d_data.ctxtxt,'\',''));
      lc_Correo := lc_Correo || lc_tmp || '; ';
      if length(lc_Correo) > 200 then
         exit;
      end if;
   end loop;
   lc_Correo := trim(substr(lc_Correo,1,length(lc_Correo) -2));
   return lower(lc_Correo);
end FN_AH_CORREOV;
/

