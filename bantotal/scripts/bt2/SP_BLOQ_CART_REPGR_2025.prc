create or replace procedure SP_BLOQ_CART_REPGR_2025(V_INSTANCIA     in number,
                                                    V_USUARIO       in varchar2,
                                                    V_FLAG          out varchar2,
                                                    V_CODIGO_ERROR  out varchar2,
                                                    V_MENSAJE_ERROR out varchar2) is
                                                    
  -- *****************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.08.02
  -- Autor de Creación          : RCASTRO
  -- Uso                        : Propuesta sinceramiento cartera reprogramada 2025
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 

  -- *****************************************************************
  
                                                      
FECHAHOY DATE;                                                    
begin
  V_FLAG := 'N';
  
  BEGIN
    select pgfape INTO FECHAHOY from fst017 where pgcod = 1;
  EXCEPTION 
      WHEN OTHERS THEN
      NULL;
  END;
  
  BEGIN
    select 'S'
    INTO V_FLAG
      from aqpd603 a, xwf700 x  where
       a.aqpd603cta = x.xwfcuenta
       and a.aqpd603oper = x.xwfoperacion
       and a.aqpd603sta = 'S' 
       and a.aqpd603fecv >= FECHAHOY
       and x.xwfprcins = V_INSTANCIA
       and x.xwfcar3 = '1';
     EXCEPTION WHEN OTHERS THEN
        V_FLAG := 'N';
  END;

end SP_BLOQ_CART_REPGR_2025;
/
