create or replace package pq_cr_contr_ofert_aprob is

  /* ************************************************************************************************************
      -- Nombre                     : pq_cr_modulo_campanias
      -- Sistema                    : BANTOTAL
      -- Módulo                     : CREDITOS
      -- Descripción                : 
      -- Versión                    : 1.0
      -- Fecha de Creación          : 03.06/2025
      -- Autor de Creación          : rcastro
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Fecha de Modificación      : 
      -- Autor de la Modificación   : 
      -- Descripción de Modificación:    
  * *************************************************************************************************************/
  
  procedure Sp_rechazar (p_JAQZ697FEPaux DATE
                         ,p_JAQZ697COR   NUMBER
                         ,p_Pepais       NUMBER
                         ,p_Petdoc       NUMBER
                         ,p_docRechazo   VARCHAR2
                         ,p_Pgfape       DATE
                         ,p_MotivoRech VARCHAR2);

end pq_cr_contr_ofert_aprob;
/
create or replace package body pq_cr_contr_ofert_aprob is



procedure  Sp_rechazar (p_JAQZ697FEPaux DATE
                         ,p_JAQZ697COR   NUMBER
                         ,p_Pepais       NUMBER
                         ,p_Petdoc       NUMBER
                         ,p_docRechazo   VARCHAR2
                         ,p_Pgfape       DATE
                         ,p_MotivoRech VARCHAR2) IS
BEGIN    
   BEGIN                         
   update jaqz697 a
       set a.jaqz697au5 = 'R',
           a.jaqz697fan = p_Pgfape,
           a.jaqz697mot = p_MotivoRech
     where a.jaqz697fep = p_JAQZ697FEPaux
       and a.jaqz697cor = p_JAQZ697COR;
    COMMIT;
   EXCEPTION
     WHEN OTHERS THEN
       NULL;
   END;
   
   /*Begin
     null;
   end;
   */
END;    
end pq_cr_contr_ofert_aprob;
/
