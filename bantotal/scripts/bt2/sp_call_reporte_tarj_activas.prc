create or replace procedure SP_CALL_REPORTE_TARJ_ACTIVAS is

  -- *****************************************************************
  -- Nombre                     : SP_CALL_REPORTE_TARJ_ACTIVAS
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : TARJETAS DEBITO
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 26/10/2017
  -- Autor de Creaci�n          : Hernan Laqui Jimenez
  -- Uso                        : Call Reporte Resumen de  Tarjetas
  -- Estado                     : Activo
  -- Acceso                     :
  -- Par�metros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificaci�n      :
  -- Autor de la Modificaci�n   :
  -- Descripci�n de Modificaci�n:
  -- *****************************************************************
  
  cursor c1( FecIni Date ,  FecFin Date) is    
  select d.z0e483suc codsuc,e.z0e468cod tiptar ,  count(1) TotMen
  from z0e483 d, z0e478 e
  where d.z0e483nro = e.z0e478nro
  and d.z0e483fmd >= FecIni 
  and d.z0e483fmd <= FecFin 
  and d.z0e483tnv = 'INS'
  and e.z0e463cod = 1
  and d.z0e483est = 'PE'
  group by d.z0e483suc, e.z0e468cod  
  union all  
  select a.jaql68sucu ,'O' TipTar , count(*) from jaql068 a
  where jaql68esta=5 and jaql68fees>=FecIni
  and jaql68fees<=FecFin
  group by a.jaql68sucu
  order by 1;
  
  ln_Mes Number(2):=0;
  ln_A�o Number(4):=0;
  ld_fecha date;  
  ld_fecFin date;    
  ld_fecIni date;    
  ln_numReg Number(10):=0;

begin
  /*
    p_c_EstTar = 'A' : Activas
    p_c_EstTar = 'I' : Inactivas
  */      
  select pgfape into ld_fecha from fst017 where pgcod = 1;            
  select to_number(to_char(ld_fecha, 'YYYY')) into ln_A�o from dual;
  select to_number(to_char(ld_fecha, 'MM')) into  ln_Mes from dual;
  select count(1) into ln_numReg from jaqz347r a where a.jaqz347rmes=ln_Mes and a.jaqz347rano=ln_A�o;
  
  If ln_numReg <= 0  then
    select last_day(ld_fecha) into  ld_fecFin from dual;
     select last_day(add_months(ld_fecha, -1)) +1 into ld_fecIni from dual;
    for i in c1(ld_fecIni,ld_fecFin) loop 
        Insert into jaqz347r
        values( ln_Mes, ln_A�o, i.codsuc, i.tiptar, i.totmen);
    End Loop;
    commit;
  end if;
end SP_CALL_REPORTE_TARJ_ACTIVAS;
/

