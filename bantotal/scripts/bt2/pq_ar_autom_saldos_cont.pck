create or replace package PQ_AR_AUTOM_SALDOS_CONT is

  -- Sistema : BANTOTAL
  -- Author  : FPINTO
  -- Modulo : AUTOMATIZACION SALDOS
  -- Version : 1.0
  -- Created : 18/10/2022 
  -- Purpose : Automatización reclasificación a ingresos sobrantes contables
  -- Estado : Diseño
  
  Procedure sp_autom_saldos;

end PQ_AR_AUTOM_SALDOS_CONT;
/

create or replace package body PQ_AR_AUTOM_SALDOS_CONT is
       
       
  procedure sp_autom_saldos is
    ldfecha date;
  begin
      select pgfape into ldfecha from fst017 where pgcod = 1;
      
      for i in (select tp1desc from fst198 where tp1COD=1 AND TP1COD1=11143 and tp1corr1=8 and tp1corr2= 1)
        loop
          update fsd011 set scstat=19 where scrub = to_number(i.tp1desc) and scfcon < (ldfecha-30) and scstat<>19;

        end loop;
        commit;  
  end sp_autom_saldos;
end PQ_AR_AUTOM_SALDOS_CONT;
/

