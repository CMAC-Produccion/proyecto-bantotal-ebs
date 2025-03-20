create or replace procedure SP_CR_UPDATE_FECHA_SNG001(PN_INSTANCIA in number, PC_MSG out varchar2) is
 -- *****************************************************************
  -- Nombre                       : SP_CR_UPDATE_FECHA_SNG001
  -- Sistema                      : BANTOTAL
  -- Módulo                       : ACTIVAS
  -- Descripción                  : ACTUALIZA FECHA DE SNG001
  -- Versión                      : 1.0
  -- Fecha de Creación            : 2024.08.15
  -- Autor de Creación            : DCASTRO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
 -- *****************************************************************  
  
  LD_FECHA     DATE;
  LN_INSTANCIA NUMBER ;---instancia
  LC_RESPUESTA VARCHAR2(1000);

BEGIN

  LN_INSTANCIA := PN_INSTANCIA;

  
  BEGIN
    select k.SNG001FIN
      INTO LD_FECHA
      from sng001 k
     where k.sng001inst = LN_INSTANCIA;
  EXCEPTION
    WHEN OTHERS THEN
      LD_FECHA := TO_DATE('01/01/0001', 'DD/MM/YYYY');
  END;

  IF LD_FECHA = TO_DATE('01/01/0001', 'DD/MM/YYYY') THEN
    --OBTENER MINIMA FECHA 
    BEGIN
      select trunc(MIN(X.WFITEMINIT))
        INTO LD_FECHA
        from wfwrkitems x
       where x.wfinsprcid = LN_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        LD_FECHA := TRUNC(SYSDATE);
    END;
  
    BEGIN
      UPDATE SNG001 S
         SET S.SNG001FIN = LD_FECHA
       WHERE S.SNG001INST = LN_INSTANCIA;
      COMMIT;
       LC_RESPUESTA := 'SE ACTUALIZO';
    EXCEPTION
      WHEN OTHERS THEN
       LC_RESPUESTA := 'ERROR: ' || SQLCODE || ' ' || SQLERRM;
    END;
  
  END IF;

  PC_MSG := LC_RESPUESTA; 
insert into AQPB876 values (user,sysdate,'SP_CR_UPDATE_FECHA_SNG001',  PN_INSTANCIA);
commit;  
end SP_CR_UPDATE_FECHA_SNG001;
/

