create or replace procedure SP_AH_ALERTA_SEGURO(pn_sccta IN NUMBER,
                                                pn_scoper in number,
                                                pn_scmda in number,
                                                pn_scmod in number,
                                                pn_scsbop in number,
                                                pn_sctope in number,
                                                pc_resul OUT VARCHAR2) is 
 -- *********************************************************************************
  -- Nombre                     : proceso se alertas
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : PASIVAS
  -- Versi¿n                    : 1.0
  -- Fecha de Creacion          : 2020.03.30
  -- Autor de Creacion          : SILVIA MARQUEZ
  -- Uso                        : FUNCIONES Y PROCEDIMIENTOS PARA REPORTES
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificacion      : 27/11/2024
  -- Autor                      : Silvia Marquez
  -- Modificacion               : se optimizo el código
  -- *********************************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
                                                
cuentavarchar varchar2(27);                                               
existe number;
cuentachar char(30);
documento  char(12);
fecha date;
fechaini date;
begin
  select pgfape 
   into fecha
   from fst017 where pgcod = 1 ;
   fechaini := trunc(fecha,'MM');
  Begin
    select trim(pendoc) into documento
     from fsr008 where pgcod = 1 and  ctnro = pn_sccta
                                and ttcod = 1 and cttfir = 'T';
  end;
                                
   if pn_scmod = 21 then
     cuentachar := '0000000' || lpad(pn_sccta, 9, '0') || lpad(pn_scmod, 3, '0') || lpad(pn_scmda, 3, '0') ||
       lpad(pn_scsbop,2, '0') || lpad(pn_scTOPE, 3, '0')  ;          
   else
     if pn_scmod = 22 then
       cuentachar :=lpad(pn_sccta, 9, '0') || lpad(22, 3, '0') || lpad(pn_scmda, 3, '0') || lpad(pn_scoper,9, '0') || lpad(pn_scTOPE, 3, '0');
     else
       cuentachar :=  lpad(pn_sccta, 9, '0') || lpad(pn_scmod, 3, '0') || lpad(pn_scmda, 3, '0') ||
       lpad(pn_scoper,9, '0') || lpad(pn_scTOPE, 3, '0')  ;
     end if;       
     
   end if;
    
   BEGIN
     select 1
       into existe
      from jaql099
      where jaql99fepr Between fechaini and fecha
        and idtitularcta99 = documento
        and numcta99  = cuentachar
        and rownum = 1;
   exception
     when no_data_found then
       Begin
          select 1
            into existe
            from jaql099
            where jaql99fepr Between fechaini and fecha
              and idtitularcta99 = documento;
       exception
         when no_data_found then
           existe := 0;
       end;
   end;
  
   if existe = 1 then
     --alerta seguros
       cuentavarchar := trim(substr(trim(cuentachar),-20,20));
     Begin
      select 'La cuenta que intenta cancelar tiene vinculado un seguro '|| trim(b.PRODUCTO)
        into pc_resul
        from v_certificados b
       where b.DOCUMENTO = ( select pendoc from fsr008 where pgcod = 1 and  ctnro = pn_sccta
                                and ttcod = 1 and cttfir = 'T' )
         and substr(b.CUENTA,-20,20) = cuentavarchar;        
         
         
    exception
      when no_data_found then
        pc_resul := ' ';
      when too_many_rows then
        pc_resul := 'La cuenta que intenta cancelar tiene vinculado varios seguros';
     end;
   end if;
   
end SP_AH_ALERTA_SEGURO;
/

