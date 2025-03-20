create or replace package PQ_CR_FACTURA_LOGIN is

-- *****************************************************************
    -- Nombre                     : Actualizar y Inserta los estados financieros
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Recuperaciones
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.03.14
    -- Autor de Creación          : CRISTHIAN CERPA
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- *****************************************************************

 Procedure SP_CR_BUSCADOC(pc_numdoc in char,
                          pc_ind out char          
                    );

 Procedure SP_CR_INSERTA_AQPA470D(pd_fecpro in date
                                 );

------------------------------------------------------------

end PQ_CR_FACTURA_LOGIN;
/

create or replace package body PQ_CR_FACTURA_LOGIN is



 Procedure SP_CR_BUSCADOC(pc_numdoc in char,
                          pc_ind out char          
                    ) is
    -- *****************************************************************
    -- Nombre                     : busca documento en tabla
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                

    lc_pendoc    char(12);
    lc_ind       char(1);

  Begin
    lc_pendoc    := RPAD(pc_numdoc, 12, ' ');
    Begin
          select 'S'
           into lc_ind
           from AQPA470D
           WHERE AQPA470DDOC = lc_pendoc
            and rownum = 1;
    exception
      When others then
        lc_ind := 'N';
    END;
    
    pc_ind := nvl(lc_ind, 'N');
    
  End SP_CR_BUSCADOC;


---------------------------------------------------------------------------------------------
 Procedure SP_CR_INSERTA_AQPA470D(pd_fecpro in date
                                 ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INSERTA_AQPA470D - inserta documento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                


  Begin
    
    Begin
      insert into  AQPA470D    
      select distinct RPAD(a.AQPA460NRUC, 12, ' '), RPAD(a.AQPA460TDOCR, 2, ' ')
        from aqpa460 a
       where a.aqpa460femi = pd_fecpro
         and not exists
       (select RPAD(AQPA470DDOC, 12, ' '), RPAD(aqpa470tdocr, 2, ' ')
                from AQPA470D
               where AQPA470DDOC = RPAD(a.AQPA460NRUC, 12, ' ')
                 and aqpa470tdocr  = RPAD(a.AQPA460TDOCR, 2, ' ' ));
    exception
      When others then
        null;
    end;
    
 End SP_CR_INSERTA_AQPA470D;


---------------------------------------------------------------------------------------------

end PQ_CR_FACTURA_LOGIN;
/

