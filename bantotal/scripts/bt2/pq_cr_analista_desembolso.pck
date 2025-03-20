create or replace package pq_cr_analista_desembolso is

  -- Author  : ECOLLADO
  -- Created : 31/10/2022 17:07:25
  -- Purpose : 
  
  procedure sp_cr_analista_desembolso (ve_modulo in number,
                                       ve_sucursal in number,
                                       ve_moneda in number,
                                       ve_papel in number,
                                       ve_cuenta in number,
                                       ve_operacion in number,
                                       ve_suboperacion in number,
                                       ve_tipo_operacion in number,
                                       ve_analista_credito in varchar,
                                       ve_analista_desembolso out varchar );

end pq_cr_analista_desembolso;
/

create or replace package body pq_cr_analista_desembolso is

  -- Private type declarations
   procedure sp_cr_analista_desembolso (ve_modulo in number,
                                        ve_sucursal in number,
                                        ve_moneda in number,
                                        ve_papel in number,
                                        ve_cuenta in number,
                                        ve_operacion in number,
                                        ve_suboperacion in number,
                                        ve_tipo_operacion in number,
                                        ve_analista_credito in varchar,
                                        ve_analista_desembolso out varchar ) is 
                                       
      ve_analista_sng130 varchar(100);                      
      begin                                                      
                                       
       begin
        select trim(s.sng130asor) into ve_analista_sng130--, s.*, t.*
          from sng130 s, sng131 t
         where t.sng130cor = s.sng130cor
           and SNG131CERR = 0
           and SNG131PGC = 1
           and SNG131MOD = ve_modulo
           and SNG131MDA = ve_moneda
           and SNG131PAP = ve_papel
           and SNG131CTA = ve_cuenta
           and SNG131OPE = ve_operacion
           and s.SNG130cor = (select min(s.SNG130cor)
                                 from sng130 s, sng131 t
                                where t.sng130cor = s.sng130cor
                                  and SNG131CERR = 0
                                  and SNG131PGC = 1
                                  and SNG131MOD = ve_modulo
                                  and SNG131MDA = ve_moneda
                                  and SNG131PAP = ve_papel
                                  and SNG131CTA = ve_cuenta
                                  and SNG131OPE = ve_operacion);
            exception
              when others then
                  ve_analista_desembolso:= ve_analista_sng130;
              end;

         if ve_analista_sng130 = ve_analista_credito then 
           ve_analista_desembolso:= ve_analista_credito;
         else 
           ve_analista_desembolso:= ve_analista_sng130;
         end if;
     end sp_cr_analista_desembolso;                                  
                                       
end pq_cr_analista_desembolso;
/

