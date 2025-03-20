CREATE OR REPLACE PROCEDURE SP_Activas_Unilateral(W_Uni IN JAQA400.jaqa400ai1%TYPE,
w_DIA NUMBER, --2022.02.23 AGREGADO CAMPO ADICIONAL COMO PARAMETRO PARA CONSIDERAR LOS MESES
W_VAR OUT VARCHAR2,
W_MSG out varchar2)--2022.12.25 SE A�ADIO CAMPO PARA DEVOLVER MENSAJE
-- *****************************************************************
    -- Nombre                     : SP_Activas_Unilateral
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 27/01/2022
    -- Autor de Creaci�n          : YHON VILLAVICENCIO
    -- Uso                        : CONTROLAR CR�DITOS UNILATERALES
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : W_Uni
    --
    -- Retorno                    : W_VAR
    -- Fecha de Modificaci�n      :
    -- Autor de la Modificaci�n   :
    -- Descripci�n de Modificaci�n:
    --
    -- *****************************************************************
AS
v_JAQA400CTA JAQA400.JAQA400CTA%type;
v_JAQA400OPE JAQA400.JAQA400OPE%type;
v_aqpccta NUMBER(9);
v_aqpcoper NUMBER(9);
V_aqpcuni Varchar2(20);
V_aqpcmadi number(3);
v_Flag Varchar2(1);
v_Val Varchar2(1):='A';
BEGIN
      v_Flag:='S';
      Begin
       --OBTIENE LA CUENTA Y OPERACI�N
       SELECT JAQA400CTA, JAQA400OPE, 'S'
         INTO v_JAQA400CTA, v_JAQA400OPE, v_Flag
         FROM JAQA400
        WHERE jaqa400ai1 = W_Uni
          And jaqa400est = 'E'
          and JAQA400AC1 = TRIM('U')
          AND JAQA400FEC = (Select MAX(JAQA400FEC)
                              From JAQA400
                             WHERE jaqa400ai1 = W_Uni
                               And jaqa400est = 'E'
                               /*and JAQA400AC1 = TRIM('U')*/); --SE COMENTO POR QUE NO NECESARIAMENTE LA ULTIMA REPROGRAMACION EN VUELO LE PUDIERNO 
                               --COLOCAR U PODRIA SE CONSENSUADA Y EN ESE CASO YA NO DEBERIA CONTROLAR -- 2022.02.14 HENRY
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        v_Flag:='N'; 
        W_VAR := 'S'; --SE CAMBIO N X S, YA QUE en S NO DEBE BLOQUEAR ESTE CONTROL SOLO SE APLICA SI COLOCARON UNILATERAL --2022.02.14
      End;

      --OBTIENE UNILATERAL
      IF  v_Flag ='S' THEN
        Begin
          SELECT SUBSTR(A.aqpcuni,1,1),A.AQPCMADI /* AGREGADO CAMPO ADICIONAL PARA COMPARAR LOS MESES*/ INTO V_aqpcuni,V_aqpcmadi FROM AQPC252 A 
          WHERE A.aqpccta=v_JAQA400CTA AND A.aqpcoper=v_JAQA400OPE;
          EXCEPTION
          WHEN OTHERS THEN
          NULL;
        End;
        IF TRIM(V_aqpcuni) = v_Val THEN
          
           W_VAR := 'S';
           --2022.02.23 - agregado validacion adicional, SE AGREGO PARA COMPRAR LOS MESES MAXIMO  PERMITIDOS  SEGUN RIESGOS DE LA FECHA DE VENCIMIENTO DEL NUEVO CRONOGRAMA PROPUESTO DEL ORIGINAL.
           --DONDE W_DIA SON LOS MESES DE DIFERENCIA DE LA FECHA DE VENCIMIENTO DEL NUEVO CREDITO PROPUESTO AL ORIGINAL Y V_AQPCMADI SON LOS MESES MAXIMOS PERMITIDOS POR RIESGOS SEGUN TABLA.
           if V_aqpcmadi >= w_DIA then
             W_VAR := 'S';
           else
             W_VAR := 'N';
             W_MSG := 'Fecha de Vencimiento del cr�dito mayor al permitido.';--2022.12.25
           end if;
           --2022.02.23 fin del agregado.    
        Else
            W_VAR := 'N';
            W_MSG := 'No habilitado para RPG.Unilateral';--2022.12.25
        END IF;                                
      END If;
END;
/

