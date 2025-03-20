create or replace procedure SP_AH_DATANEW(pn_sucursal in number,
                                          pn_rubro    in varchar2,
                                          pn_moneda   in number,
                                          pn_cuenta   in number,
                                          pn_oper     in number,
                                          pn_fecha    out date,
                                          pn_hora     out varchar2,
                                          pn_usuario  out varchar2) is
                                          
cursor datos is
    select min(b.hfcon) fecha,min(b.hhora) hora,b.husing usuario   
      from fsh016 a, 
           fsh015 b
     where a.pgcod = 1 
       and a.hsucur = pn_sucursal 
       and a.hrubro = pn_rubro
       and a.hoper  = pn_oper
       and a.hcta   = pn_cuenta
       and b.pgcod = a.pgcod
       and b.hcmod = a.hcmod
       and b.hsucor = a.hsucor 
       and b.htran = a.htran
       and b.hnrel = a.hnrel
       and b.hfcon = a.hfcon
     group by b.hfcon,b.hhora ,b.husing   
     union
    select min(d.itfcon) fecha,min(d.ithora) hora,d.ituing usuario   
      from fsd016 c, 
           fsd015 d
     where c.pgcod = 1 
       and c.itsuc = pn_sucursal 
       and c.rubro = pn_rubro
       and c.itoper  = pn_oper
       and c.ctnro   = pn_cuenta
       and d.pgcod = c.pgcod
       and d.itmod = c.itmod
       and d.itsuc = c.itsuc
       and d.ittran = c.ittran
       and d.itnrel = c.itnrel
--       and d.itfcon = c.itfcon
     group by d.itfcon, d.ithora,d.ituing;

ld_fecha date;                                         
lc_hora  char(8);
lc_usuario char(10);
ld_fechamin date;
begin
    for reg in datos loop  
      ld_fecha := reg.fecha;
      lc_hora  := reg.hora;
      lc_usuario := reg.usuario;
    end loop;  
      
   if ld_fecha is null  then
     pn_fecha := to_date('01/01/0001','dd/mm/yyyy');
     pn_hora  := lc_hora;
     pn_usuario := lc_usuario;
   else
     pn_fecha  := ld_fecha;
     pn_hora   := lc_hora;
     pn_usuario := lc_usuario;   
   end if;  
end SP_AH_DATANEW;
/

