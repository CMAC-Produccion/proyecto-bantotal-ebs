create or replace package pq_cr_ultimo is


  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para obtener la ultima clave del credito
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/06/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 
 
procedure sp_clave_final (vn_R2Cod  in number,
                          vn_R2mda  in number,
                          vn_R2pap  in number,
                          vn_R2cta  in number,
                          vn_R2oper in number,
                          vn_PgcodC out number,
                          vn_AomodC out number,
                          vn_AosucC out number,
                          vn_AomdaC out number,
                          vn_AopapC out number,
                          vn_AoctaC  out number,
                          vn_AooperC out number,
                          vn_AosbopC out number,
                          vn_AotopeC out number,
                          vn_AoimpC  out number,
                          vn_AostatC out number,
                          vd_FechaBaja out date);
end pq_cr_ultimo;
/
create or replace package body pq_cr_ultimo is
----estado 23 procesos
procedure sp_clave_final (vn_R2Cod  in number,
                           vn_R2mda  in number,
                           vn_R2pap  in number,
                           vn_R2cta  in number,
                           vn_R2oper in number,
                           vn_PgcodC out number,
                           vn_AomodC out number,
                           vn_AosucC out number,
                           vn_AomdaC out number,
                           vn_AopapC out number,
                           vn_AoctaC  out number,
                           vn_AooperC out number,
                           vn_AosbopC out number,
                           vn_AotopeC out number,
                           vn_AoimpC  out number,
                           vn_AostatC out number,
                           vd_FechaBaja out date)                           
is
ln_aosbop number;
  ln_PgcodC number;
  ln_AomodC number;
  ln_AosucC number;
  ln_AomdaC number;
  ln_AopapC number;
  ln_AoctaC  number;
  ln_AooperC number;
  ln_AosbopC number;
  ln_AotopeC number;
  ln_AoimpC  number;
  ln_AostatC number;
  ln_contador number;
  ld_FechaBaja date;
begin

  begin
    select  PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE, AOIMP, AOSTAT 
     into ln_PgcodC, ln_AomodC, ln_AosucC, ln_AomdaC, ln_AopapC, ln_AoctaC, ln_AooperC, ln_AosbopC, ln_AotopeC, ln_AoimpC, ln_AostatC
    from fsd010
    where pgcod = vn_R2Cod
      and AOCTA = vn_R2cta  
      and AOMOD = 65
      and AOMDA = vn_R2mda 
      and AOPAP = vn_R2pap       
      and AOOPER= vn_R2oper;  -- indice PGCOD, AOCTA, AOMOD
     exception 
       when NO_DATA_FOUND then
         begin 
            select  PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE, AOIMP, AOSTAT 
             into ln_PgcodC, ln_AomodC, ln_AosucC, ln_AomdaC, ln_AopapC, ln_AoctaC, ln_AooperC, ln_AosbopC, ln_AotopeC, ln_AoimpC, ln_AostatC
            from fsd010
            where pgcod = vn_R2Cod
              and AOCTA = vn_R2cta  
              and AOMOD = 33
              and AOMDA = vn_R2mda 
              and AOPAP = vn_R2pap       
              and AOOPER= vn_R2oper;  -- indice PGCOD, AOCTA, AOMOD
             exception 
               when NO_DATA_FOUND then
                 ln_AoctaC:=0;
          end;
  end;
  
  if (ln_AoctaC=0) then-- si no esta vendido ni castigado se busca la máxima suboperación
    begin
      select max(AOSBOP) into ln_aosbop
      from fsd010
      where pgcod = vn_R2Cod
        and AOCTA = vn_R2cta  
        and AOMOD in (select modulo from fst111 where dscod=50) 
        and AOMDA = vn_R2mda 
        and AOPAP = vn_R2pap       
        and AOOPER= vn_R2oper;  -- indice PGCOD, AOCTA, AOMOD
    exception 
       when NO_DATA_FOUND then
         ln_aosbop:=0;
    end;
    begin 
      select count(*) into ln_contador
      from fsd010
      where pgcod = vn_R2Cod       
        and AOCTA = vn_R2cta 
        and AOMOD in (select modulo from fst111 where dscod=50)
        and AOMDA = vn_R2mda 
        and AOPAP = vn_R2pap
        and AOOPER= vn_R2oper
        and AOSBOP= ln_aosbop;
      exception 
       when NO_DATA_FOUND then
         ln_contador:=0;      
    end;
    if (ln_contador=1) then --este es la última clave
      begin
       select PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE, AOIMP, AOSTAT,AOFE99        
       into ln_PgcodC, ln_AomodC, ln_AosucC, ln_AomdaC, ln_AopapC, ln_AoctaC, ln_AooperC, ln_AosbopC, ln_AotopeC, ln_AoimpC, ln_AostatC,ld_FechaBaja
       from fsd010
       where  pgcod = vn_R2Cod       
        and AOCTA = vn_R2cta 
        and AOMOD in (select modulo from fst111 where dscod=50)
        and AOMDA = vn_R2mda 
        and AOPAP = vn_R2pap
        and AOOPER= vn_R2oper
        and AOSBOP= ln_aosbop;
       exception 
       when NO_DATA_FOUND then
         ln_AoctaC:=0;      
       end;
    else   --se busca la ultima clave
        begin 
            select  PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE, AOIMP, AOSTAT,AOFE99 
             into ln_PgcodC, ln_AomodC, ln_AosucC, ln_AomdaC, ln_AopapC, ln_AoctaC, ln_AooperC, ln_AosbopC, ln_AotopeC, ln_AoimpC, ln_AostatC,ld_FechaBaja
            from fsd010
            where pgcod = vn_R2Cod
              and AOCTA = vn_R2cta  
              and AOMOD = 200
              and AOMDA = vn_R2mda 
              and AOPAP = vn_R2pap       
              and AOOPER= vn_R2oper
              and AOSBOP= ln_aosbop;  -- indice PGCOD, AOCTA, AOMOD
             exception 
               when NO_DATA_FOUND then
                 ln_AoctaC:=0;
        end;
    end if;
  end if;
  vn_PgcodC := ln_PgcodC;
  vn_AomodC := ln_AomodC; 
  vn_AosucC := ln_AosucC; 
  vn_AomdaC := ln_AomdaC; 
  vn_AopapC := ln_AopapC; 
  vn_AoctaC := ln_AoctaC; 
  vn_AooperC:= ln_AooperC;
  vn_AosbopC:= ln_AosbopC;
  vn_AotopeC:= ln_AotopeC;
  vn_AoimpC := ln_AoimpC ;
  vn_AostatC:= ln_AostatC;
  vd_FechaBaja:=ld_FechaBaja;
end  sp_clave_final;
end pq_cr_ultimo;
/
