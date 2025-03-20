CREATE OR REPLACE PROCEDURE SP_AH_INSERCION_EXPERIENCIACLIENTE(P_pgcod in number) IS
  -- *****************************************************************
  -- Nombre                      : SP_AH_INSERCION_EXPERIENCIACLIENTE
  -- Sistema                     : BANTOTAL
  -- Módulo                      : Ahorros - Pasivas
  -- Versión                     : 1.0
  -- Fecha de Creación           : 19/04/2023
  -- Autor de Creación           : Tania Apaza
  -- Uso                         : 
  -- Estado                      : Activo
  -- Acceso                      : Público
  -- Parámetros de Entrada       : 
  -- ***
  -- Retorno                     : 
  -- Fecha de Modificación       : 30/01/2024
  -- Autor de la Modificación    : Yrving Lozada
  -- Descripción de Modificación : Se agregó replace de comas de ciertos campos
  -- Fecha de Modificación       : 07/03/2024
  -- Autor de la Modificación    : Yrving Lozada
  -- Descripción de Modificación : Se cambio proceso de inserción por secuencia
  -- ***
  -- Fecha de Modificación       : 2025.01.17
  -- Modificado                  : CVILLON
  -- Descripción de Modificación : Reporte Multiusuario
  -- ***************************************************************************************
  -- ***************************************************************************************
  cursor ec_insercion is
    SELECT TO_CHAR(a.JAQY255FECCON, 'DD/MM/YY') || ' ' || a.JAQY255HOTRA AS FECHA_OPERACION,
           a.JAQY255NUMDOC as DNICLIENTE,
           FN_CL_OBTENER_CLIENTE(a.JAQY255PAICLI,
                                 a.JAQY255TIPDOC,
                                 a.JAQY255NUMDOC) AS PRIMER_NOMBRE,
           INITCAP(a.JAQY255NOPER) as NOMBRE_COMPLETO,
           a.JAQY255PROSBS as TIPO_CLIENTE,
           a.JAQY255GIRNEG as ACTIVIDAD,
           a.JAQY255SECLI as SEGMENTO,
           a.JAQY255GECLI as GENERO,
           a.JAQY255FENAC as FECHANACIMIENTO,
           a.JAQY255EDAD as EDAD,
           a.JAQY255TFPER as CELULAR1,
           a.JAQY255TFPER1 as CELULAR2,
           a.JAQY255TFPER2 as CELULAR3,
           a.JAQY255COSUC as COD_AG,
           a.JAQY255NOSUC as AGENCIA,
           FN_CL_OBTENER_DEPARTAMENTOREP(P_pgcod,
                                         a.JAQY255PAICLI,
                                         a.JAQY255COSUC) as DEPARTAMENTO,
           FN_CL_OBTENER_PROVINCIAREP(P_pgcod,
                                      a.JAQY255PAICLI,
                                      a.JAQY255COSUC) as PROVINCIA,
           a.JAQY255NOOPE as OPERACION,
           a.JAQY255DEPRO as PRODUCTO,
           a.JAQY255DNIUS as DNI_COLAB,
           a.JAQY255COUSU as COD_OPER,
           a.JAQY255NOUSU as COLABORADOR,
           CASE
             when b.JAQN74PTR IS NULL THEN
              'REPRESENTANTE DE SERVICIO'
             else
              b.JAQN74PTR
           END as POSICION,
           FN_CL_OBTENER_CORREO(a.JAQY255PAICLI,
                                a.JAQY255TIPDOC,
                                a.JAQY255NUMDOC) as CORREO,
           FN_CL_OBTENER_REGIONREP(P_pgcod, a.JAQY255COUSU) as REGION
    
      FROM JAQY255 a
      LEFT JOIN JAQN74 e
        ON Trim(a.JAQY255NUMDOC) = Trim(e.JAQN74DNI) --no extrabajadores
      LEFT JOIN JAQN74 b
        ON a.JAQY255DNIUS = b.JAQN74DNI --dni colaborador(cargo)
      LEFT JOIN FSD002 c
        ON a.JAQY255NUMDOC = c.PFNDOC --no trabajadores
    
     WHERE e.JAQN74DNI IS NULL
       AND a.JAQY255CREUSU = 'JOBEXPCLI'
       AND UPPER(a.JAQY255DEPRO) NOT IN
           ('AHORRO JUDICIAL', 'CUENTA JUNIOR', 'CONVENIO PYME')
       AND a.JAQY255PROSBS NOT IN
           ('03 - CONSUMO REVOLVENTE',
            '04 - HIPOTECARIO',
            '12 - MEDIANA EMPRESA')
       AND a.JAQY255GECLI IS NOT NULL
       AND a.JAQY255GECLI <> ' '
       AND a.JAQY255EDAD >= 18
       AND JAQY255EDAD <= 80
       AND c.PFEBCO <> 'S'
       AND NOT (UPPER(JAQY255PROSBS) IN
            ('02 - MICROEMPRESAS', '13 - PEQUEÑA EMPRESA') AND
            UPPER(JAQY255SECLI) IN ('PREFERENTE A', 'PREFERENTE B'));

  v_IDNPSOPERACIONQ NUMBER := 0;
  v_CODINT          VARCHAR2(50) := null;
  v_FECHA_OPERACION DATE := null;
  v_DNICLIENTE      VARCHAR2(13) := null;
  v_NOMBRECLIENTE   VARCHAR2(50) := null;
  --v_APELLIDOCLIENTE          VARCHAR2(50)   := null;
  v_NOMBRECOMPLETO  VARCHAR2(100) := null;
  v_TIPOCLIENTE     VARCHAR2(50) := null;
  v_ACTIVIDAD       VARCHAR2(100) := null;
  v_SEGMENTO        VARCHAR2(100) := null;
  v_GENERO          character(1) := null;
  v_FECHANACIMIENTO DATE := null;
  v_EDAD            NUMBER(3);
  v_CELULAR1        NUMBER := 0;
  v_CELULAR2        NUMBER := 0;
  v_CELULAR3        NUMBER := 0;
  v_COD_AGENCIA     NUMBER(3);
  v_AGENCIA         VARCHAR2(100) := null;
  v_REGION          VARCHAR2(100) := null;
  v_REGIONAL        VARCHAR2(100) := '';
  v_DEPARTAMENTO    VARCHAR2(100) := null;
  v_PROVINCIA       VARCHAR2(100) := null;
  v_OPERACION       VARCHAR2(100) := null;
  v_PRODUCTO        VARCHAR2(100) := null;
  v_DNICOLABORADOR  VARCHAR2(13) := null;
  v_CODOPERADOR     VARCHAR2(50) := null;
  v_COLABORADOR     VARCHAR2(100) := null;
  v_POSICION        VARCHAR2(100) := null;
  v_CORREO          VARCHAR2(100) := null;
BEGIN
  ---***
  /*  BEGIN
  SELECT COALESCE(MAX(IDNPSOPERACIONQ), 0) INTO v_IDNPSOPERACIONQ FROM CRM_NPS_OPERACIONES_Q;
  exception
      when others then
         v_IDNPSOPERACIONQ := 0;  
  END;*/
  ---***
  for i in ec_insercion LOOP
    ---***
    --v_IDNPSOPERACIONQ := USRWEBCRMD.SEQ_CRM_NPS_OPERACIONES_Q.nextval; --v_IDNPSOPERACIONQ + 1; --incremental
    v_IDNPSOPERACIONQ := USRWEBCRM.SEQ_CRM_NPS_OPERACIONES_Q.nextval; --v_IDNPSOPERACIONQ + 1; --incremental
    --v_IDNPSOPERACIONQ := 1;
    ---***
    v_CODINT          := 'EC04-22';
    v_FECHA_OPERACION := TO_DATE(i.FECHA_OPERACION, 'DD/MM/YY HH24:MI:SS');
    v_DNICLIENTE      := trim(i.DNICLIENTE);
    v_NOMBRECLIENTE   := trim(i.PRIMER_NOMBRE.nombre);
    v_NOMBRECOMPLETO  := trim(i.NOMBRE_COMPLETO);
    v_TIPOCLIENTE     := trim(i.TIPO_CLIENTE);
    v_ACTIVIDAD       := trim(i.ACTIVIDAD);
    v_SEGMENTO        := trim(i.SEGMENTO);
    v_GENERO          := trim(i.GENERO);
    v_FECHANACIMIENTO := i.FECHANACIMIENTO;
    v_EDAD            := i.EDAD;
    v_CELULAR1        := i.CELULAR1;
    v_CELULAR2        := i.CELULAR2;
    v_CELULAR3        := i.CELULAR3;
    v_COD_AGENCIA     := i.COD_AG;
    v_AGENCIA         := trim(i.AGENCIA);
    v_REGION          := trim(i.REGION);
    --v_REGIONAL        := trim(i.REGIONAL);
    v_DEPARTAMENTO   := trim(i.DEPARTAMENTO);
    v_PROVINCIA      := trim(i.PROVINCIA);
    v_OPERACION      := trim(i.OPERACION);
    v_PRODUCTO       := trim(i.PRODUCTO);
    v_DNICOLABORADOR := trim(i.DNI_COLAB);
    v_CODOPERADOR    := trim(i.COD_OPER);
    v_COLABORADOR    := trim(i.COLABORADOR);
    v_POSICION       := trim(i.POSICION);
    v_CORREO         := trim(i.CORREO);
  
    INSERT INTO CRM_NPS_OPERACIONES_Q
      (IDNPSOPERACIONQ,
       CODINT,
       FECHA_OPERACION,
       DNICLIENTE,
       PRIMERNOMBRE,
       NOMBRECOMPLETO,
       TIPOCLIENTE,
       ACTIVIDAD,
       SEGMENTO,
       GENERO,
       FECHANACIMIENTO,
       EDAD,
       CELULAR1,
       CELULAR2,
       CELULAR3,
       COD_AGENCIA,
       AGENCIA,
       REGION,
       REGIONAL,
       DEPARTAMENTO,
       PROVINCIA,
       OPERACION,
       PRODUCTO,
       DNICOLABORADOR,
       CODOPERADOR,
       COLABORADOR,
       POSICION,
       CORREO)
    VALUES
      (v_IDNPSOPERACIONQ,
       v_CODINT,
       v_FECHA_OPERACION,
       v_DNICLIENTE,
       v_NOMBRECLIENTE,
       replace(v_NOMBRECOMPLETO, ',', ' '),
       v_TIPOCLIENTE,
       replace(v_ACTIVIDAD, ',', ' '),
       v_SEGMENTO,
       v_GENERO,
       v_FECHANACIMIENTO,
       v_EDAD,
       v_CELULAR1,
       v_CELULAR2,
       v_CELULAR3,
       v_COD_AGENCIA,
       v_AGENCIA,
       v_REGION,
       v_REGIONAL,
       v_DEPARTAMENTO,
       v_PROVINCIA,
       v_OPERACION,
       v_PRODUCTO,
       v_DNICOLABORADOR,
       v_CODOPERADOR,
       replace(v_COLABORADOR, ',', ' '),
       v_POSICION,
       v_CORREO);
  END LOOP;
  commit;
  ---***
exception
  when others then
    dbms_output.put_line(sqlerrm);
    ---***     
END SP_AH_INSERCION_EXPERIENCIACLIENTE;
/

