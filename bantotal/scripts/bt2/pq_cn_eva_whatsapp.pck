create or replace package PQ_CN_EVA_WHATSAPP is

  -- Public function and procedure declarations
  
  Procedure sp_ultimo_pago  (P_N_CUENTA    IN NUMBER,          
                             P_N_OPERACION IN NUMBER,                            
                             P_N_MONTOPAGO OUT NUMBER,
                             P_D_FECHAPAGO OUT DATE,                             
                             p_c_deserr    OUT VARCHAR2
                            );    
				
end PQ_CN_EVA_WHATSAPP;
/

create or replace package body PQ_CN_EVA_WHATSAPP is
Procedure sp_ultimo_pago  (  P_N_CUENTA    IN NUMBER,          
                             P_N_OPERACION IN NUMBER,                            
                             P_N_MONTOPAGO OUT NUMBER,
                             P_D_FECHAPAGO OUT DATE,                             
                             p_c_deserr    OUT VARCHAR2
                            ) is
 BEGIN
          
 select z.Pago , z.FecPag  into P_N_MONTOPAGO, P_D_FECHAPAGO
  from (
  select y.*,  row_number() over (order by y.fecpag desc) orden 
  from (
    select  x.ctnro Cuenta, x.itoper Operacion, x.itsubo SubOpe,  case
            when x.tp1nro1 = 6 then x.itimp6
            when x.tp1nro1 = 3 then x.itimp3
            when x.tp1nro1 = 1 then x.itimp1  end pago, x.itfcon FecPag  
    from (  
          select row_number() over( partition by h.pgcod, h.itsuc, h.itmod, h.ittran, h.itnrel order by h.itsbor asc) orden, 
                 h.*, n.tp1nro1, p.itfcon
          from (
                select distinct pgcod, itsuc, itmod, ittran, itnrel from fsd016 where ctnro = P_N_CUENTA and itoper=P_N_OPERACION) m
                inner join fsd016 h on m.pgcod = h.pgcod and m.itsuc = h.itsuc and  m.itmod = h.itmod 
                and m.ittran = h.ittran and  m.itnrel=h.itnrel    
                inner join fsd015 p on p.pgcod = h.pgcod
                and p.itmod = h.itmod
                and p.itsuc = h.itsuc
                and p.ittran = h.ittran
                and p.itnrel = h.itnrel
                and p.itcorr = 0
                inner join JAQZ511 n on h.pgcod = 1
                and n.tp1cod = h.pgcod
                and n.tp1corr1 = h.itmod
                and n.tp1corr2 = h.ittran
                and n.tp1corr3 = h.itord
          )x where x.orden=1 
    union all
      
    select  x.hcta, x.hoper, x.hcsubo,  case
            when x.tp1nro1 = 6 then x.hcimp6
            when x.tp1nro1 = 3 then x.hcimp3
            when x.tp1nro1 = 1 then x.hcimp1  end pago, x.hfcon FecPag
    from (
          select row_number() over( partition by i.pgcod, i.hcmod, i.hsucor, i.htran, i.hnrel, i.hfcon order by i.hcsubo asc) orden,
          i.*, n.tp1nro1
          from (
                select p.* 
                from (
                select distinct j.pgcod, j.hcmod, j.hsucor, j.htran, j.hnrel, j.hfcon 
                from fsh016 j 
                inner join JAQZ511 n on j.pgcod = 1
                and n.tp1cod = j.pgcod
                and n.tp1corr1 = j.hcmod
                and n.tp1corr2 = j.htran
                and n.tp1corr3 = j.hcord                   
                where j.pgcod=1 and j.hcta = P_N_CUENTA and j.hoper=P_N_OPERACION order by j.hfcon desc) p where rownum <= 1
                 ) m 
                 
                inner join fsh016 i on m.pgcod = i.pgcod and m.hcmod=i.hcmod 
                and m.hsucor = i.hsucor and m.htran =i.htran and m.hnrel = i.hnrel 
                and m.hfcon=i.hfcon
                inner join fsh015 p on p.pgcod = i.pgcod
                and p.hcmod = i.hcmod
                and p.hsucor = i.hsucor
                and p.htran = i.htran
                and p.hnrel = i.hnrel
                and p.hfcon = i.hfcon
                and p.hccorr = 0
                inner join JAQZ511 n on i.pgcod = 1
                and n.tp1cod = i.pgcod
                and n.tp1corr1 = i.hcmod
                and n.tp1corr2 = i.htran
                and n.tp1corr3 = i.hcord   
          )x where x.orden=1
    )y
  )z where z.orden <= 1;
                    
 EXCEPTION
    WHEN OTHERS THEN
      p_c_deserr := sqlerrm;                                  
    
end sp_ultimo_pago;                                 
                               
end PQ_CN_EVA_WHATSAPP;
/

