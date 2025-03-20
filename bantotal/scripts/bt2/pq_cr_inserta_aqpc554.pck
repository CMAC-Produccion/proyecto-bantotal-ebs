create or replace package pq_cr_inserta_aqpc554 is
 -- Author  : ECOLLADO
 -- Created : 01/08/2022 10:51:15
 -- Purpose : Paquete encargado de insertar logs en la tabla aqpc554

  -- Public type declarations

       PROCEDURE sp_inserta_aqpc554 (ve_instancia in number,
                                     ve_codigo in varchar2,
                                     ve_USUARIO IN VARCHAR2,
                                     ve_FECPRO  IN DATE,
                                     vs_FLAG    OUT CHARACTER);
end pq_cr_inserta_aqpc554;
/

create or replace package body pq_cr_inserta_aqpc554 is
 -- *****************************************************************
      -- Sistema                    : BANTOTAL
      -- Modulo                     : Creditos - Activas
      -- Version                    : 1.0
      -- Fecha de Creacion          : 2022.08.01
      -- Autor de Creacion          : Eduardo Collado Rafael
      -- Uso                        : Procedimiento para insertar logs en la tabla aqpc554
      -- Estado                     : Activo
      -- Acceso                     : Publico
      -- Parametros de Entrada      : ve_instacnia (Numero de Instancia), ve_codigo (Codigo generado de PRNG421c),
      --                              ve_fecpro (Fecha de insercion), ve_flag (Si se insert en la tabla aqpc554 devuelve
      --                              'S', caso contrario devuelve 'N')
      -- Parametros de Salida       : vr_respuesta ( Respuesta S = 'Permite mostrar' o N = 'No permite Mostrar')
      -- ******************************************************************

  PROCEDURE sp_inserta_aqpc554(ve_instancia in number,
                                     ve_codigo in varchar2,
                                     ve_USUARIO IN VARCHAR2,
                                     ve_FECPRO  IN DATE,
                                     vs_FLAG    OUT CHARACTER)
                                     is
  LC_HORA VARCHAR2(15);
  LN_CORR number;
  validacion_consumo number;

   BEGIN
    BEGIN
      SELECT nvl(max(aqpc554corr),0) into LN_CORR FROM  AQPC554;
        LN_CORR :=  LN_CORR + 1;
    EXCEPTION
      WHEN OTHERS THEN
        LN_CORR := 1;
        vs_FLAG:= 'N';
        RETURN;
      END;

    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        LC_HORA := NULL;
    END;

    BEGIN
      BEGIN
        select count(*) into validacion_consumo from sng021 where sng021sol = ve_instancia and sng021tmod = 14;
      EXCEPTION
        WHEN OTHERS THEN 
          validacion_consumo := 0;  
       END;
       if validacion_consumo != 0 THEN
           INSERT INTO aqpc554
           values(LN_CORR,ve_codigo,ve_instancia, ve_FECPRO, LC_HORA, ve_usuario,'S');
           COMMIT;
           vs_FLAG:= 'S';
       else 
         vs_FLAG:= 'N';
       end if;
      
     
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
       vs_FLAG:= 'N';
    END;

   END sp_inserta_aqpc554;
end pq_cr_inserta_aqpc554;
/

