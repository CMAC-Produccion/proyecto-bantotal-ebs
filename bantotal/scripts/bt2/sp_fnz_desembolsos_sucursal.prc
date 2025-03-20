create or replace procedure sp_fnz_desembolsos_sucursal(pd_fecini in date,
                                                        pd_fecfin in date)
is
begin
  delete
  from jaqz101d d
  where d.jaqz101dfch = pd_fecfin;
  commit;

  insert into jaqz101d
  select
  pd_fecfin,
  sucurs,  
  sum(decode(h16.hmda,0,h16.hcimp1,h16.hcimp1*Fn_tipo_cambio_fijo(pd_fecfin))),
  0
  from fsh015 h15 join fsh016 h16 on h16.pgcod = h15.pgcod
  and h16.hcmod = h15.hcmod
  and h16.hsucor= h15.hsucor
  and h16.htran = h15.htran
  and h16.hnrel = h15.hnrel
  and h16.hfcon = h15.hfcon
  and h16.hmodul in (select modulo from fst111 where dscod = 50)
  and h16.hmodul <> 33
  and h16.hcodmo = 1 
  join fst034 t34 on t34.pgcod = h15.pgcod
  and t34.trmod = h15.hcmod
  and t34.trnro = h15.htran               
  join fst004 t4 on t4.modulo = h16.hmodul 
  and t4.totope = h16.htoper 
  join fst003 t3 on t3.modulo = h16.hmodul  
  join fst001 t001 on t001.pgcod = h16.pgcod
  and t001.sucurs = h16.hsucur                              
  left join xwf700 xf on xf.xwfempresa = h16.pgcod
  and xf.xwfsucursal = h16.hsucur
  and xf.xwfmodulo = h16.hmodul
  and xf.xwfmoneda = h16.hmda
  and xf.xwfpapel = h16.hpap
  and xf.xwfcuenta = h16.hcta
  and xf.xwfoperacion = h16.hoper
  and xf.xwfsubope = h16.hsubop
  and xf.xwftipope = h16.htoper
  and xf.xwfcar3 = '1'
  left join sng001 g1  on g1.sng001inst = xf.xwfprcins   
  left join fsr008 r8  on r8.pgcod = h16.pgcod
  and r8.ctnro = h16.hcta
  and r8.ttcod = 1
  and r8.cttfir='T'
  left join fsd001 d1  on d1.pepais = r8.pepais
  and d1.petdoc = r8.petdoc
  and d1.pendoc = r8.pendoc   
  left join fsd002 d2 on d2.pfpais = r8.pepais
  and d2.pftdoc = r8.petdoc
  and d2.pfndoc = r8.pendoc                                                
  where h15.pgcod = 1
  and h15.hccorr <> 99 
  and h15.hfcon between pd_fecini and pd_fecfin
  and 
  (
    (h15.hcmod = 116 and h15.htran in (50,60,200)) OR
    (h15.hcmod = 210 and h15.htran = 971) OR
    (h15.hcmod = 183 and h15.htran = 10) OR
    (h15.hcmod =  30 and h15.htran in (350,360,951,351,355,356))
  )
  group by sucurs;
  commit;

end;
/

