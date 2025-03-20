create or replace procedure SP_CR_CAJCORRES(pn_cta in number, pc_flg out varchar2) is
  -- *********************************************************************************
    -- Nombre                     : SP_CR_CAJCORRES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.11.28
    -- Autor de Creación          : RLIVISI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 2017.02.21
    -- Autor de la Modificación   : RLIVISI
    -- Descripción de Modificación: Se valida que el estado del equipo post =1 (vigente)
    -- *********************************************************************************
  ln_instancia number;        
cursor personas is
select * from fsr008 where ctnro = pn_cta;

begin
  pc_flg := 'N';
  for i in personas loop
      begin
        select 'S'
        into pc_flg
        from jaql004 a, jaql009 b
        where a.jaql4cocom=b.jaql4cocom
        and b.jaql9estad=1--equipo post vigente
        and a.jaql4estad =1--establec.vigente 21/02/2017--RLIVISI
        and jaql4parep=i.pepais--604
        and jaql4tdrep=i.petdoc--21
        and jaql4ndrep=i.pendoc
        and rownum = 1;--'29415822'
      exception
        when others then
          pc_flg := 'N';
      end  ;

        if pc_flg = 'S' then
           exit;
        end if;
  end loop;

end SP_CR_CAJCORRES;
/

