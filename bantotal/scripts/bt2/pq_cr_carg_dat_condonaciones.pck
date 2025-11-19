create or replace package pq_cr_carg_dat_condonaciones is

 -- Author  : RCASTRO
 -- Created : 07/10/2025 10:58:25 a.m.
 -- Purpose : pROCESO PARA OBTENER EL MONTO MAXIMO DE DESCUENTO
 -- Modificado : RCASTRO
 -- Fecha : 07/10/2025
 procedure sp_cr_dat_condonaciones(v_pgcod  in number,
                                    v_Scmod  in number,
                                    v_Scsuc  in number,
                                    v_Scmda  in number,
                                    v_Scpap  in number,
                                    v_Sccta  in number,
                                    v_Scoper in number,
                                    v_Scsbop in number,
                                    v_Sctope in number,
                                    v_rpta   out varchar2,
                                    v_monto  out number);


end pq_cr_carg_dat_condonaciones;
/
create or replace package body pq_cr_carg_dat_condonaciones is

  -- Author  : RCASTRO
  -- Created : 07/10/2025 10:58:25 a.m.
  -- Purpose : pROCESO PARA OBTENER EL MONTO MAXIMO DE DESCUENTO
  -- Modificado : RCASTRO
  -- Fecha : 07/10/2025
  procedure sp_cr_dat_condonaciones(v_pgcod  in number,
                                    v_Scmod  in number,
                                    v_Scsuc  in number,
                                    v_Scmda  in number,
                                    v_Scpap  in number,
                                    v_Sccta  in number,
                                    v_Scoper in number,
                                    v_Scsbop in number,
                                    v_Sctope in number,
                                    v_rpta   out varchar2,
                                    v_monto  out number) is
  begin
    v_monto := 0;
    begin
      select AQPD412CDCM/*CAPITAL TOTAL A DESCONTAR*/
      into v_monto
      from aqpd412 a
      where a.aqpd412emp = v_pgcod 
        and a.aqpd412mod = v_Scmod 
        and a.aqpd412suc = v_Scsuc 
        and a.aqpd412mda = v_Scmda 
        and a.aqpd412pap = v_Scpap 
        and a.aqpd412cta = v_Sccta 
        and a.aqpd412ope = v_Scoper
        and a.aqpd412sop = v_Scsbop
        and a.aqpd412top = v_Sctope;

    exception
      when others then
        v_rpta := 'N';
    end;  
    if  v_monto > 0 then
        v_rpta := 'T'; -- POR LO PRONTO TODO ES CANCELACION TOTAL.
    end if; 
  
    --v_rpta si devuelve T, se toma como Cancelacion Total
    --v_monto  debe devolver el monto maximo de capital a condonar
    --En el panel de Autorización de Condonación, se van a grabar los eventos de tasa 3 y 4, Tasa y Tasa mora, con valor 0.
    

  end sp_cr_dat_condonaciones;
end pq_cr_carg_dat_condonaciones;
/
