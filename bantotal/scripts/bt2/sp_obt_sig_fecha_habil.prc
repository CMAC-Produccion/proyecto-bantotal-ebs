CREATE OR REPLACE Procedure SP_OBT_SIG_FECHA_HABIL(VD_FECHA_INICIO IN date,
                                                   VD_SUCURSAL     in number,
                                                   PO_FECHA        out DATE) is

  -- Nombre                     : SP_OBT_SIG_FECHA_HABIL 
  -- Sistema                    : BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 05.02.2025
  -- Autor de Creación          : CALARCONAP
  -- Descripcion                : Obtiene siguiente dia habil de una fecha
  -- Fecha de Modificacion      : 07.02.2025
  -- Autor de Modificacion      : CALARCONAP
  -- Descripcion                : Se controla en caso no envien sucursal
  -- Fecha de Modificacion      : 19.02.2025
  -- Autor de Modificacion      : CALARCONAP
  -- Descripcion                : Control para sucursales que no tienen data en FST028

  VD_FECHA_CONSULTA DATE := VD_FECHA_INICIO;
  VI_FECHAH         VARCHAR2(1);
  VN_INTENTOS       NUMBER := 0;
  VN_MAX_INTENTOS   NUMBER := 366; -- Máximo 1 año de búsqueda
  V_EXISTESUC       number := 0;
  V_SUCURSAL        NUMBER := VD_SUCURSAL;

begin
  -- if VD_SUCURSAL is not null and VD_SUCURSAL > 0 then
  begin
  
    SELECT count(1)
      INTO V_EXISTESUC
      FROM FST028
     WHERE FFECHA = VD_FECHA_CONSULTA
       AND CALCOD = VD_SUCURSAL;
  
  EXCEPTION
    WHEN OTHERS THEN
      V_EXISTESUC := 0;
  END;

  --Si la sucursal no existe, usamos una agencia de arequipa(en este caso la pampilla, podria ser cualquiera)
  --Esto para sucursales como Administrativos(904) y otros que no esten en la tabla FST028
  IF V_EXISTESUC = 0 THEN
    V_SUCURSAL := 2;
  END IF;

  LOOP
    BEGIN
      -- Verificar si la fecha actual es hábil
      SELECT FHABIL
        INTO VI_FECHAH
        FROM FST028
       WHERE FFECHA = VD_FECHA_CONSULTA
         AND CALCOD = V_SUCURSAL
         AND FHABIL = 'S';
    
      EXIT WHEN VI_FECHAH = 'S'; -- Salir si es hábil
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VI_FECHAH := 'N'; -- Marcar como no hábil
      WHEN OTHERS THEN
        RAISE; -- Relanzar otras excepciones
    END;
  
    -- Incrementar fecha y contador
    VD_FECHA_CONSULTA := VD_FECHA_CONSULTA + 1;
    VN_INTENTOS       := VN_INTENTOS + 1;
  
    -- Prevenir loop infinito
    IF VN_INTENTOS > VN_MAX_INTENTOS THEN
      RAISE_APPLICATION_ERROR(-20001,
                              'No se encontró fecha hábil en 1 año');
    END IF;
  END LOOP;

  PO_FECHA := VD_FECHA_CONSULTA;

  -- else
  --  PO_FECHA := VD_FECHA_INICIO;
  --end if;

  IF PO_FECHA IS NULL THEN
  
    PO_FECHA := VD_FECHA_INICIO;
  
  END IF;

Exception
  when others then
    NULL;
  
end SP_OBT_SIG_FECHA_HABIL;
/

