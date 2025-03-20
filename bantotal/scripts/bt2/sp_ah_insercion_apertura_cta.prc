CREATE OR REPLACE PROCEDURE SP_AH_INSERCION_APERTURA_CTA (P_PGCOD IN NUMBER,
                                                         P_USER IN VARCHAR,
                                                         P_CANTREGISTROS OUT NUMBER)  IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_INSERCION_APERTURA_CTA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2023
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 30/01/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se agregó replace de comas de ciertos campos
    -- Fecha de Modificación      : 07/03/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se cambio proceso de inserción por secuencia
    --
    -- *****************************************************************                                                         
 cursor ra_insercion is 

	SELECT TO_CHAR(a.AQPB513APEFEC, 'DD/MM/YY') || ' ' || a.AQPB513APEHOR AS FECHA_OPERACION,
	a.AQPB513CLNDOC as DNICLIENTE, a.AQPB513CLNOMB as NOMBRE_COMPLETO,
    a.AQPB513TIPSBS as TIPO_CLIENTE, a.AQPB513CLSEGM as SEGMENTO, a.AQPB513CLSEXO as GENERO, 
	a.AQPB513CLEDAD as EDAD, a.AQPB513CLTEL1 as CELULAR1, a.AQPB513CLTEL2 as CELULAR2, a.AQPB513CLTEL3 as CELULAR3,
    a.AQPB513APESUC as COD_AG, a.AQPB513APESUD as AGENCIA, 
    FN_CL_OBTENER_REGIONSUC(P_PGCOD,a.AQPB513APESUC) as REGION , a.AQPB513APEDEP as DEPARTAMENTO, a.AQPB513APEPRO as PROVINCIA,
    a.AQPB513OPEDES as OPERACION, a.AQPB513PRODES as PRODUCTO, 
    a.AQPB513COLDNI as DNI_COLAB, a.AQPB513COLCOD as COD_COLAB, a.AQPB513COLNOM as COLABORADOR,
    COALESCE(b.JAQN77PTR, 'REPRESENTANTE DE SERVICIO') AS CARGO,
    FN_CL_OBTENER_CLIENTE(a.AQPB513CLPAIS,a.AQPB513CLTDOC,a.AQPB513CLNDOC) AS PRIMER_NOMBRE,
    FN_CL_OBTENER_CORREO(a.AQPB513CLPAIS, a.AQPB513CLTDOC, a.AQPB513CLNDOC) AS CORREO

	FROM AQPB513 a
    LEFT JOIN JAQN77 e
	ON Trim(a.AQPB513CLNDOC) = Trim(e.JAQN77DNI) -- no ex colaborador 
    LEFT JOIN FSD002 c 
	ON  a.AQPB513CLPAIS = c.PFPAIS
    AND a.AQPB513CLTDOC = c.PFTDOC
    AND a.AQPB513CLNDOC = c.PFNDOC --no colaborador
    LEFT JOIN JAQN77 b
	ON a.AQPB513COLDNI = rpad(b.JAQN77DNI, 12, ' ') --dni colaborador(cargo)

    WHERE e.JAQN77DNI IS NULL
    AND a.AQPB513CREUSR = P_USER
    AND a.AQPB513CLEDAD >= 18 AND AQPB513CLEDAD <= 80
    AND (a.AQPB513CLSEXO IS NOT NULL 
	OR a.AQPB513CLSEXO <> ' ')
    AND a.AQPB513PRODES  NOT IN ('AHORRO JUDICIAL', 'CUENTA JUNIOR')
    AND (a.AQPB513TIPSBS NOT IN ('03 - CONSUMO REVOLVENTE') OR AQPB513TIPSBS IS NULL)
    AND a.AQPB513COLCOD NOT IN rpad('NSBTUSER', 10, ' ') 
    AND (b.JAQN77PTR IS NULL OR b.JAQN77PTR = 'REPRESENTANTE DE SERVICIO' OR b.JAQN77PTR = ' '
    OR b.JAQN77PTR = 'EJECUTIVO DE PRODUCTOS FINANCIEROS'
    OR b.JAQN77PTR = 'ASESOR DE PLATAFORMA DE ATENCION')
    AND (c.PFEBCO <> 'S' OR c.PFEBCO IS NULL);

   -- para el cursor
	   v_IDNPSAPERTURACTAQ   NUMBER  := 0;
	   v_FECHAOPE      DATE   		 := null;
	   v_DNICLIENTE    VARCHAR2(50)  := null;
	   v_NOMCLIENTE    VARCHAR2(50)  := null;
	   v_TIPOCLIENTE   VARCHAR2(50)  := null;
	   v_SEGMENTO      VARCHAR2(50)  := null;
	   v_GENERO        VARCHAR2(50)  := null;
       v_EDAD          NUMBER(3);
       v_CEL1          VARCHAR2(50)  := null;
       v_CEL2          VARCHAR2(50)  := null;
	   v_CEL3          VARCHAR2(50)  := null;
       v_CODAG  	   VARCHAR2(15)  := null;
	   v_AGENCIA       VARCHAR2(30)  := null;
       v_REGION        VARCHAR2(30)  := null;
       v_DEPARTAMENTO  VARCHAR2(30)  := null;
       v_PROVINCIA     VARCHAR2(30)  := null;
	   v_OPERACION                VARCHAR2(30) := null;
       v_PRODUCTO                 VARCHAR2(50) := null;
       v_DNICOLABORADOR           VARCHAR2(50)  := null;
       v_CODOPERADOR              VARCHAR2(50)  := null;
       v_COLABORADOR              VARCHAR2(50) := null;
	   v_POSICION                 VARCHAR2(50) := null;
	   v_PRIMERNOMBRE		      VARCHAR2(50) := null;
       v_CORREO                   VARCHAR2(100) := null;
       v_NROREGISTROS             NUMBER  := 0;

BEGIN
	---***
/*  BEGIN
  SELECT COALESCE(MAX(IDNPSAPERTURACTAQ), 0) INTO v_IDNPSAPERTURACTAQ FROM CRM_NPS_APERTURA_CTA_Q;
  exception
	    when others then
        v_IDNPSAPERTURACTAQ := 0;  
  END;*/
  ---***   
  for i in ra_insercion
	LOOP
	   v_IDNPSAPERTURACTAQ := USRWEBCRM.SEQ_CRM_NPS_APERTURA_CTA_Q.nextval;--v_IDNPSAPERTURACTAQ + 1; --incremental
	   v_FECHAOPE        := TO_DATE(i.FECHA_OPERACION, 'DD/MM/YY HH24:MI:SS');
	   v_DNICLIENTE      := trim(i.DNICLIENTE);
	   v_NOMCLIENTE      := trim(i.NOMBRE_COMPLETO);
	   v_TIPOCLIENTE     := trim(i.TIPO_CLIENTE);
	   v_SEGMENTO        := trim(i.SEGMENTO);
	   v_GENERO          := trim(i.GENERO);
       v_EDAD          	 := i.EDAD;
       v_CEL1            := trim(i.CELULAR1);
       v_CEL2            := trim(i.CELULAR2);
	   v_CEL3            := trim(i.CELULAR3);
       v_CODAG  	     := trim(i.COD_AG);
	   v_AGENCIA         := trim(i.AGENCIA);
       v_REGION          := trim(i.REGION);
       v_DEPARTAMENTO    := trim(i.DEPARTAMENTO);
       v_PROVINCIA       := trim(i.PROVINCIA);
	   v_OPERACION       := trim(i.OPERACION);
       v_PRODUCTO        := trim(i.PRODUCTO);
       v_DNICOLABORADOR  := trim(i.DNI_COLAB);
       v_CODOPERADOR     := trim(i.COD_COLAB);
       v_COLABORADOR     := trim(i.COLABORADOR);
	   v_POSICION        := trim(i.CARGO);
	   v_PRIMERNOMBRE    := trim(i.PRIMER_NOMBRE.nombre);
       v_CORREO          := trim(i.CORREO);

		INSERT INTO CRM_NPS_APERTURA_CTA_Q
		(IDNPSAPERTURACTAQ, FECHAOPERACION, DNICLIENTE, NOMBRECLIENTE, TIPOCLIENTESBS, SEGMENTO, GENERO, EDAD, CELULAR1, CELULAR2, CELULAR3, CODAG, AGENCIA, REGION, DEPARTAMENTO, PROVINCIA, OPERACION, PRODUCTO, DNICOLABORADOR, CODOPER, COLABORADOR, POSICION, PRIMERNOMBRE, CORREO)
		VALUES(v_IDNPSAPERTURACTAQ,  v_FECHAOPE,       v_DNICLIENTE, replace(v_NOMCLIENTE,',',' '),
		v_TIPOCLIENTE,   v_SEGMENTO, v_GENERO,         v_EDAD,
		v_CEL1,          v_CEL2,     v_CEL3,           v_CODAG,
		v_AGENCIA,       v_REGION,   v_DEPARTAMENTO,   v_PROVINCIA,
		v_OPERACION,     v_PRODUCTO, v_DNICOLABORADOR, v_CODOPERADOR,
		replace(v_COLABORADOR,',',' '),   v_POSICION, v_PRIMERNOMBRE,   v_CORREO);

        v_NROREGISTROS := v_NROREGISTROS + 1;
	END LOOP;
        P_CANTREGISTROS := v_NROREGISTROS;
		commit;
		---***
exception
when others then
  dbms_output.put_line(sqlerrm);  
		---*** 
END SP_AH_INSERCION_APERTURA_CTA;
/

