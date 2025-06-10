create or replace package pq_cr_actu_dat_impulBBP is

  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA ACTUALIZ IMPULSO BBP
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19/05/2025 14:03:05
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : Cargar cronograma de pagos original 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 28/05/2025
  -- Autor de Modificación      : IGS_RCASTRO
  -- Descripción de Modificación: Se agrega guia para parametrizar directorio.
  -- *****************************************************************    

  procedure sp_actualizar_archivo(P_AQPB187PGCOD number,
                                  P_AQPB187MOD   number,
                                  P_AQPB187SUC   number,
                                  P_AQPB187MDA   number,
                                  P_AQPB187PAP   number,
                                  P_AQPB187CTA   number,
                                  P_AQPB187OPE   number,
                                  P_AQPB187SBOP  number,
                                  P_AQPB187TOPE  number,
                                  P_PAQPB187FCH  date,
                                  P_RUTAARCHIVO  VARCHAR2,
                                  P_NOMARCHIVO   VARCHAR2);
                                  
  procedure sp_obtener_archivo(P_AQPB187PGCOD number,
                              P_AQPB187MOD   number,
                              P_AQPB187SUC   number,
                              P_AQPB187MDA   number,
                              P_AQPB187PAP   number,
                              P_AQPB187CTA   number,
                              P_AQPB187OPE   number,
                              P_AQPB187SBOP  number,
                              P_AQPB187TOPE  number,
                              P_PAQPB187FCH  date,
                              P_AQPB187IDCOF varchar2,
                              P_RUTAARCHIVO out  VARCHAR2,
                              P_NOMARCHIVO  out VARCHAR2);                                

end pq_cr_actu_dat_impulBBP;
/
create or replace package body pq_cr_actu_dat_impulBBP is

  procedure sp_actualizar_archivo(P_AQPB187PGCOD number,
                                  P_AQPB187MOD   number,
                                  P_AQPB187SUC   number,
                                  P_AQPB187MDA   number,
                                  P_AQPB187PAP   number,
                                  P_AQPB187CTA   number,
                                  P_AQPB187OPE   number,
                                  P_AQPB187SBOP  number,
                                  P_AQPB187TOPE  number,
                                  P_PAQPB187FCH  date,
                                  P_RUTAARCHIVO  VARCHAR2,
                                  P_NOMARCHIVO   VARCHAR2) is
  
    v_bfile BFILE;
    v_blob  BLOB;
  
    v_dest_offset INTEGER := 1;
    v_src_offset  INTEGER := 1;
    v_amount      INTEGER;
    v_directorio  varchar2(30);
  BEGIN
    BEGIN
      UPDATE AQPB187
         SET AQPB187ARCH    = P_RUTAARCHIVO,
             AQPC187NOMARCH = P_NOMARCHIVO-- || ' ' || P_NOMARCHIVO
       where AQPB187PGCOD = P_AQPB187PGCOD
         AND AQPB187MOD = P_AQPB187MOD
         AND AQPB187SUC = P_AQPB187SUC
         AND AQPB187MDA = P_AQPB187MDA
         AND AQPB187PAP = P_AQPB187PAP
         AND AQPB187CTA = P_AQPB187CTA
         AND AQPB187OPE = P_AQPB187OPE
         AND AQPB187SBOP = P_AQPB187SBOP
         AND AQPB187TOPE = P_AQPB187TOPE
         AND AQPB187FCH = P_PAQPB187FCH;
      -- AQPB187FCH = TO_DATE('17/03/2025');
      COMMIT;
    EXCEPTION 
       WHEN OTHERS THEN
         NULL;

    END;
  
    BEGIN
       SELECT TP1DESC into v_directorio FROM FST198 WHERE 
       Tp1cod    = 1      AND
       Tp1cod1   =  11152 AND
       Tp1corr1  =  305   and
       Tp1corr2  =  2      AND
       Tp1corr3  = 1;
    EXCEPTION 
       WHEN OTHERS THEN
         NULL; 
    END;
    v_directorio := trim(v_directorio);
    IF v_directorio IS NULL THEN
       v_directorio := 'DTPUMP_PR_EMAIL_DIG';
    END IF;
    
    BEGIN
       -- Inicializar el archivo externo
      v_bfile := BFILENAME(v_directorio, P_NOMARCHIVO);
    
      -- Abrir el archivo externo
      DBMS_LOB.OPEN(v_bfile, DBMS_LOB.LOB_READONLY);
      -- Seleccionar el campo BLOB en modo FOR UPDATE
      
      BEGIN
      SELECT AQPB187CARGARCH
        INTO v_blob
        FROM AQPB187
       WHERE AQPB187PGCOD = P_AQPB187PGCOD
         AND AQPB187MOD = P_AQPB187MOD
         AND AQPB187SUC = P_AQPB187SUC
         AND AQPB187MDA = P_AQPB187MDA
         AND AQPB187PAP = P_AQPB187PAP
         AND AQPB187CTA = P_AQPB187CTA
         AND AQPB187OPE = P_AQPB187OPE
         AND AQPB187SBOP = P_AQPB187SBOP
         AND AQPB187TOPE = P_AQPB187TOPE
         AND AQPB187FCH = P_PAQPB187FCH
         FOR UPDATE;
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;
     END;
      -- Obtener tamaño del archivo
      v_amount := DBMS_LOB.GETLENGTH(v_bfile);

      -- Cargar el archivo al campo BLOB
      DBMS_LOB.loadfromfile(v_blob,
                            v_bfile,
                            v_amount,
                            v_dest_offset,
                            v_src_offset);
    
      -- Cerrar el archivo externo
      DBMS_LOB.close(v_bfile);
    
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        -- En caso de error, cerrar BFILE si está abierto
        IF DBMS_LOB.FILEISOPEN(v_bfile) = 1 THEN
          DBMS_LOB.CLOSE(v_bfile);
        END IF;
      
    END;
  
  END;
  
  procedure sp_obtener_archivo(P_AQPB187PGCOD number,
                              P_AQPB187MOD   number,
                              P_AQPB187SUC   number,
                              P_AQPB187MDA   number,
                              P_AQPB187PAP   number,
                              P_AQPB187CTA   number,
                              P_AQPB187OPE   number,
                              P_AQPB187SBOP  number,
                              P_AQPB187TOPE  number,
                              P_PAQPB187FCH  date,
                              P_AQPB187IDCOF varchar2,
                              P_RUTAARCHIVO out  VARCHAR2,
                              P_NOMARCHIVO  out VARCHAR2) is 
                              
  begin
    begin
        SELECT AQPB187ARCH
        INTO P_RUTAARCHIVO
        FROM AQPB187
       WHERE AQPB187PGCOD = P_AQPB187PGCOD
         AND AQPB187MOD = P_AQPB187MOD
         AND AQPB187SUC = P_AQPB187SUC
         AND AQPB187MDA = P_AQPB187MDA
         AND AQPB187PAP = P_AQPB187PAP
         AND AQPB187CTA = P_AQPB187CTA
         AND AQPB187OPE = P_AQPB187OPE
         AND AQPB187SBOP = P_AQPB187SBOP
         AND AQPB187TOPE = P_AQPB187TOPE
         AND AQPB187IDCOF = P_AQPB187IDCOF
         AND AQPB187FCH = P_PAQPB187FCH; 
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;   
    end;
  end;                                

end pq_cr_actu_dat_impulBBP;
/
