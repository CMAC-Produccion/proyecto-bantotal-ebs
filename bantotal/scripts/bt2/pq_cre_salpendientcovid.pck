create or replace package pq_cre_salPendientCovid is

  -- Author  : KVALENCIAC
  -- Created : 08/06/2020 
  -- Purpose : DEvuelve saldos pendientes de Reprogramaciones Covid19
  
procedure sp_verificasaldo (vn_Ppgcod in number,
                             vn_cta in number, 
                             vn_ope in number, 
                             vn_mda in number,                               
                             ln_ICV out number,
                             ln_Penalidad out number,
                              ln_Mora out number, 
                              ln_saldo out number);
  
end pq_cre_salPendientCovid;
/

create or replace package body pq_cre_salPendientCovid is

procedure sp_verificasaldo(vn_Ppgcod in number, vn_cta in number, vn_ope in number, vn_mda in number, ln_ICV out number,ln_Penalidad out number, ln_Mora out number, ln_saldo out number)
  is

begin  
   ln_saldo :=0;
   ln_ICV   :=0;
   ln_Penalidad :=0;
   ln_Mora   :=0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500092000000,9500093000000,9500094000000) and 
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;
    ------  Obtengo saldo pendiente ICV 
     begin        
        select  
        sum(scsdo) into ln_ICV
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500094000000) and 
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_ICV:=0;
    end;   
    ---------Obtengo Penalidad
    begin        
        select  
        sum(scsdo) into ln_Penalidad
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500093000000) and 
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_Penalidad:=0;
    end;
    ---------Obtengo IntMora
    begin        
        select  
        sum(scsdo) into ln_Mora
        from fsd011
        where
        pgcod = vn_Ppgcod and
        sccta = vn_cta and
        scrub in (9500092000000) and 
        scoper = vn_ope and     
        scmda = vn_mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_Mora:=0;
    end;
    ------------------------------
    if (ln_ICV<0) then
       ln_ICV := ln_ICV*-1;
    end if;
    if (ln_Penalidad<0) then
       ln_Penalidad := ln_Penalidad*-1;
    end if;
    if (ln_Mora<0) then
       ln_Mora := ln_Mora*-1;
    end if;
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
end sp_verificasaldo;
end pq_cre_salPendientCovid;
/

