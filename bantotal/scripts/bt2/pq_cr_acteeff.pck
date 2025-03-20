create or replace package PQ_CR_ACTEEFF is

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
 Procedure sp_cr_insertarjaqz713(ln_pais      in number,
                     ln_tdoc      in number,
                     lc_ndoc      in varchar2,
                     ld_ffee      in date,
                     lc_usuario   in varchar2
                    );


------------------------------------------------------------
Procedure sp_cr_updatejaqz713(ln_pais in number,
                     ln_tdoc      in number,
                     lc_ndoc      in varchar2,
                     ld_ffee      in date,
                     lc_usuario   in varchar2
                    );
Procedure sp_cr_deletejaqz713(ln_pais      in number,
                           ln_tdoc      in number,
                           lc_ndoc      in varchar2,
                           lc_usuario   in varchar2
                          ) ;
end PQ_CR_ACTEEFF;
/

create or replace package body PQ_CR_ACTEEFF is



 Procedure sp_cr_insertarjaqz713(ln_pais      in number,
                     ln_tdoc      in number,
                     lc_ndoc      in varchar2,
                     ld_ffee      in date,
                     lc_usuario   in varchar2
                    ) is
    -- *****************************************************************
    -- Nombre                     : Inserta en latabla jaqz713 segun los parametro que se recibe
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Recuperaciones
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : CRISTHIAN CERPA
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

  Begin
    lc_pendoc    := RPAD(lc_ndoc, 12, ' ');
    Begin

      insert into jaqz713
        (JAQZ713PAIS,
         JAQZ713TDOC,
         JAQZ713NDOC,
         JAQZ713EEFF,
         JAQZ713USUR,
         JAQZ713FSIS,
         JAQZ713HORA
                 )
           values
           (ln_pais,
           ln_tdoc,
           lc_pendoc,
           ld_ffee,
           lc_usuario,
           sysdate,
           sysdate
           )
      ;
      commit;
    exception
      When others then
        null;
    END;
  End sp_cr_insertarjaqz713;


---------------------------------------------------------------------------------------------
Procedure sp_cr_updatejaqz713(ln_pais      in number,
                           ln_tdoc      in number,
                           lc_ndoc      in varchar2,
                           ld_ffee      in date,
                           lc_usuario   in varchar2
                          ) is
    -- *****************************************************************
    -- Nombre                     : Actualiza en la tabla jaqz713 segun los parametro que se recibe
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Recuperaciones
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : CRISTHIAN CERPA
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

  Begin
   lc_pendoc    := RPAD(lc_ndoc, 12,' ');
    Begin

     update jaqz713 j
        set j.jaqz713eeff=ld_ffee,
            j.jaqz713usur=lc_usuario,
            j.jaqz713fsis=sysdate,
            j.jaqz713hora=sysdate
        where
            j.jaqz713pais=ln_pais and
            j.jaqz713tdoc=ln_tdoc and
            j.jaqz713ndoc=lc_pendoc;
      commit;
  exception
      When others then
        null;
    END;
  End sp_cr_updatejaqz713;
  ---------------------------------------------------------------------------------------------
Procedure sp_cr_deletejaqz713(ln_pais      in number,
                           ln_tdoc      in number,
                           lc_ndoc      in varchar2,
                           lc_usuario   in varchar2
                          ) is
    -- *****************************************************************
    -- Nombre                     : inserta alata tabla jaqz707 y elimina el registro de atabla jaqz713
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Recuperaciones
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : CRISTHIAN CERPA
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

  Begin
   lc_pendoc    := RPAD(lc_ndoc, 12,' ');
    Begin

      insert into jaqz707
        (JAQZ707PAIS,
         JAQZ707TDOC,
         JAQZ707NDOC,
         JAQZ707EEFF,
         JAQZ707USUR,
         JAQZ707FSIS,
         JAQZ707ESt                    
                 )
         SELECT
         JAQZ713PAIS,
         JAQZ713TDOC,
         JAQZ713NDOC,
         JAQZ713EEFF,
         lc_usuario,
         JAQZ713FSIS,
         'ELIMINADO'
         
          FROM  JAQZ713 
          WHERE  JAQZ713NDOC=lc_pendoc
          AND JAQZ713TDOC=ln_tdoc
          AND JAQZ713PAIS=ln_pais
      ;
     
      commit;
          DELETE  FROM JAQZ713 J WHERE 
          J.JAQZ713NDOC=lc_pendoc
          AND J.JAQZ713PAIS=ln_pais
          AND J.JAQZ713TDOC=ln_tdoc;
          commit;
  exception
      When others then
        null;
    END;
  End sp_cr_deletejaqz713;
end PQ_CR_ACTEEFF;
/

