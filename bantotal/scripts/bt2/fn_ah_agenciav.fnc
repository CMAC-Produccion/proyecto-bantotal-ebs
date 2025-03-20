create or replace function FN_AH_AGENCIAV(P_PGCOD in number,
                                      P_Agencia in number) return varchar2 is

   ps_Agencia varchar2(30);

begin

   begin
    select t_001.scnom
      into ps_Agencia
      from fst001 t_001
     where t_001.pgcod = P_PGCOD
       and t_001.sucurs = P_Agencia;
   exception when others then
      ps_Agencia := null;
   end;

   return trim(ps_Agencia);
end FN_AH_AGENCIAV;
/

