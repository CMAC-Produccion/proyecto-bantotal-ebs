create or replace procedure SP_CR_OBTENER_USUARIO_DESEMB(pINST IN NUMBER, pUSU OUT VARCHAR2) is
begin
  select distinct max(USUARIO) USUARIO 
   INTO pUSU
  from (
select distinct h5.husing USUARIO
  from xwf700 x, fsd010 f, fsh016 h,fsh015 h5
where x.xwfprcins =   pINST
   and x.xwfcar3 = '1'
   and x.xwfempresa = f.PGCOD
   and x.xwfsucursal= f.AOSUC
   and x.xwfmodulo  = f.AOMOD
   and x.xwfmoneda = f.AOMDA
   and x.xwfpapel  = f.AOPAP
   and x.xwfcuenta = f.AOCTA
   and x.xwfoperacion = f.AOOPER
   and x.xwfsubope = f.AOSBOP
   and x.xwftipope = f.AOTOPE
   and h.PGCOD  = f.PGCOD
   and h.HMODUL = f.AOMOD
   and h.HMDA = F.AOMDA
   AND h.HPAP = F.AOPAP
   AND H.HCTA = F.AOCTA
   AND H.HOPER= F.AOOPER
   AND H.HSUBOP = F.AOSBOP
   AND H.HTOPER = F.AOTOPE
   AND h5.pgcod = h.PGCOD
   and h5.hcmod = h.HCMOD
   and h5.hsucor = h.HSUCOR
   and h5.htran = h.HTRAN
   and h5.hnrel = h.HNREL
   and h5.hfcon = h.HFCON
   and h5.hfcon = f.aofval
UNION
select distinct d5.ITUING USUARIO
from xwf700 x, fsd010 f, fsd016 d,fsd015 d5
where x.xwfprcins = pINST
   and x.xwfcar3 = '1'
   and x.xwfempresa = f.PGCOD
   and x.xwfsucursal= f.AOSUC
   and x.xwfmodulo  = f.AOMOD
   and x.xwfmoneda = f.AOMDA
   and x.xwfpapel  = f.AOPAP
   and x.xwfcuenta = f.AOCTA
   and x.xwfoperacion = f.AOOPER
   and x.xwfsubope = f.AOSBOP
   and x.xwftipope = f.AOTOPE
   and d.PGCOD  = f.PGCOD
   and d.modulo = f.AOMOD
   and d.MONEDA = F.AOMDA
   AND d.PAPEL = F.AOPAP
   AND d.ctnro = F.AOCTA
   AND d.ITOPER= F.AOOPER
   AND d.ITSUBO = F.AOSBOP
   AND d.ITTOPE = F.AOTOPE
   AND d5.pgcod = d.PGCOD
   and d5.ITMOD = d.ITMOD
   and d5.ITSUC = d.ITSUC
   and d5.ittran = d.ittran
   and d5.itnrel = d.itnrel
union
select ' ' USUARIO from dual
);
EXCEPTION
   WHEN OTHERS THEN
      NULL;
end SP_CR_OBTENER_USUARIO_DESEMB;
/

