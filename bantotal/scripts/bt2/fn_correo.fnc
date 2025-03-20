create or replace function FN_Correo(P_Pais in number,
                                     P_Cuenta in number) return varchar2 is


   lc_Correo varchar2(500) := '';

   cursor d_Correo(P_Pais in number,
                   P_Cuenta in number)
                  is (select x_08.ctxtxt
                        from fsx008 x_08
                       where x_08.pgcod = P_Pais
                         and x_08.ctnro = P_Cuenta
                         and x_08.txcod = 0);

begin

   for d_data in d_Correo(P_Pais, P_Cuenta)
   loop

      lc_Correo := lc_Correo || trim(d_data.ctxtxt) || ' - ' ;
   end loop;
   lc_Correo := substr(lc_Correo,1,length(lc_Correo) -3);
   return lower(lc_Correo);
end FN_Correo;
/

