create or replace package pq_cr_proc_rechFE is

  Procedure Sp_regularizacion;
  Procedure Sp_proceso_diario;

end pq_cr_proc_rechFE;
/

create or replace package body pq_cr_proc_rechFE is

  Procedure Sp_regularizacion is
  
    cursor errores(cd_fec in date) is
      select *
        from jaqm752 a
       where a.jaqm752fch <= cd_fec
         and a.jaqm752dsc in
             ('9571: No se encontró descripción para el error.',
              '9573: No se encontró descripción para el error.',
              '9574: No se encontró descripción para el error.');
  
    ld_fec   date;
    lc_error varchar2(100);
  begin
  
    begin
      select a.pgfape - 1 into ld_fec from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for i in errores(ld_fec) loop
      if trim(i.jaqm752dsc) =
         '9571: No se encontró descripción para el error.' then
        lc_error := '9571: La operación para Ampliación no existe.';
      end if;
    
      if trim(i.jaqm752dsc) =
         '9573: No se encontró descripción para el error.' then
        lc_error := '9573: Error en la tarea de Solicitud.';
      end if;
    
      if trim(i.jaqm752dsc) =
         '9574: No se encontró descripción para el error.' then
        lc_error := '9574: Error en la tarea de Evaluación/Propuesta.';
      end if;
    
      if trim(i.jaqm752dsc) in
         ('9571: No se encontró descripción para el error.',
          '9573: No se encontró descripción para el error.',
          '9574: No se encontró descripción para el error.') then
        update jaqm752 a
           set a.jaqm752dsc = lc_error
         where a.jaqm752emp = i.jaqm752emp
           and a.jaqm752fch = i.jaqm752fch
           and a.jaqm752reg = i.jaqm752reg;
      
        commit;
      
      end if;
    
    end loop;
  
    commit;
  
  end Sp_regularizacion;

  Procedure Sp_proceso_diario is
  
    cursor errores(cd_fec in date) is
      select *
        from jaqm752 a
       where a.jaqm752fch = cd_fec
         and a.jaqm752dsc in
             ('9571: No se encontró descripción para el error.',
              '9573: No se encontró descripción para el error.',
              '9574: No se encontró descripción para el error.');
  
    ld_fec   date;
    lc_error varchar2(100);
  begin
  
    begin
      select a.pgfape - 1 into ld_fec from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for i in errores(ld_fec) loop
      if trim(i.jaqm752dsc) =
         '9571: No se encontró descripción para el error.' then
        lc_error := '9571: La operación para Ampliación no existe.';
      end if;
    
      if trim(i.jaqm752dsc) =
         '9573: No se encontró descripción para el error.' then
        lc_error := '9573: Error en la tarea de Solicitud.';
      end if;
    
      if trim(i.jaqm752dsc) =
         '9574: No se encontró descripción para el error.' then
        lc_error := '9574: Error en la tarea de Evaluación/Propuesta.';
      end if;
    
      if trim(i.jaqm752dsc) in
         ('9571: No se encontró descripción para el error.',
          '9573: No se encontró descripción para el error.',
          '9574: No se encontró descripción para el error.') then
        update jaqm752 a
           set a.jaqm752dsc = lc_error
         where a.jaqm752emp = i.jaqm752emp
           and a.jaqm752fch = i.jaqm752fch
           and a.jaqm752reg = i.jaqm752reg;
      
        commit;
      
      end if;
    
    end loop;
  
    commit;
  
  end Sp_proceso_diario;

end pq_cr_proc_rechFE;
/

