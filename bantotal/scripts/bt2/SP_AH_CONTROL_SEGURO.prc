create or replace procedure SP_AH_CONTROL_SEGURO(pc_doc in varchar2,
                                                 pc_resul OUT VARCHAR2) is
 -- *********************************************************************************
  -- Nombre                     : Proceso de control Seguro en Sigretail
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : PASIVAS
  -- Versi¿n                    : 1.0
  -- Fecha de Creacion          : 2025.10.07
  -- Autor de Creacion          : SILVIA MARQUEZ
  -- Uso                        : FUNCIONES Y PROCEDIMIENTOS PARA PANEL ABM SEGUROS
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificacion      :
  -- Autor                      :
  -- Modificacion               :
  -- *********************************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


documento1  char(12);

begin
     documento1 := TRIM(pc_doc);
     Begin
      select 'S'
        into pc_resul
        from v_certificados 
       where producto like 'PROTECCION%%'  AND DOCUMENTO = documento1;
    exception
      when no_data_found then
        pc_resul := 'N';
      when too_many_rows then
        pc_resul := 'S';
     end;


end SP_AH_CONTROL_SEGURO;
/
