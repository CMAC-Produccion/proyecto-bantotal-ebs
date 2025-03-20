CREATE OR REPLACE PROCEDURE sp_cr_envcercanweb (
    pd_fepro IN DATE,
    pn_copai IN NUMBER,
    pc_nomarc IN VARCHAR2,
    pn_tidoc IN NUMBER,
    pc_nudoc IN VARCHAR2,
    pn_cta IN NUMBER,
    pn_mod IN NUMBER,
    pn_ope IN NUMBER,
    pd_fecan IN DATE,
    pn_pgcod IN NUMBER,
    pn_suc IN NUMBER,
    pn_mda IN NUMBER,
    pn_pap IN NUMBER,
    pn_sop IN NUMBER,
    pn_top IN NUMBER,
    pc_coerr IN VARCHAR2,
    pd_fedes IN DATE,
    pc_hodes IN VARCHAR2,
    pn_numdes IN NUMBER,
    pc_codcre IN VARCHAR2,
    pc_nomcli IN VARCHAR2,
    pc_coderr OUT VARCHAR2,
    pc_msgerr OUT VARCHAR2
) 
IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_envcercanweb
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.08.03
  -- Autor de Creación          : Waldir Wong Calle
  -- Uso                        : Valida Creditos Vigentes y Avales Vigentes
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.06.10
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Optimizacion excepciónes
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción Modificación   : 
  -- *****************************************************************
  
    l_bfile       BFILE;
    l_blob        BLOB;
    lv_directorio VARCHAR2(200);
BEGIN
    pc_coderr := '00000';
    lv_directorio := 'DTPUMP_PR_EMAIL';
    BEGIN
        INSERT INTO JAQL845W (
            jaql845wapdf,
            jaql845wfepro,
            jaql845wcopai,
            jaql845wtidoc,
            jaql845wnudoc,
            jaql845wcta,
            jaql845wmod,
            jaql845wope,
            jaql845wfecan,
            jaql845wpgcod,
            jaql845wsuc,
            jaql845wmda,
            jaql845wpap,
            jaql845wsop,
            jaql845wtop,
            jaql845wcoerr,
            jaql845wfedes,
            jaql845whodes,
            jaql845wnumer,
            jaql845wcodcre,
            jaql845wnomcli,
            jaql845wnomarc
        ) VALUES (
            EMPTY_BLOB(),
            pd_fepro,
            pn_copai,
            pn_tidoc,
            pc_nudoc,
            pn_cta,
            pn_mod,
            pn_ope,
            pd_fecan,
            pn_pgcod,
            pn_suc,
            pn_mda,
            pn_pap,
            pn_sop,
            pn_top,
            pc_coerr,
            pd_fedes,
            pc_hodes,
            pn_numdes,
            pc_codcre,
            pc_nomcli,
            pc_nomarc
        ) RETURN jaql845wapdf INTO l_blob;
              
        l_bfile := BFILENAME(lv_directorio, pc_nomarc);
        
        -- rcuadros 2024.06.10
        -- Verificar si el archivo existe
        IF DBMS_LOB.fileexists(l_bfile) = 1 THEN
            DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
            DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
            DBMS_LOB.fileclose(l_bfile);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Archivo no encontrado: ' || pc_nomarc);
        END IF;
        
        COMMIT;
    -- rcuadros 2024.06.10
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            pc_coderr := SQLCODE;
            pc_msgerr := 'Error: Valor duplicado en índice.';
        WHEN NO_DATA_FOUND THEN
            pc_coderr := SQLCODE;
            pc_msgerr := 'Error: No se encontraron datos.';
        WHEN TOO_MANY_ROWS THEN
            pc_coderr := SQLCODE;
            pc_msgerr := 'Error: Demasiadas filas devueltas.';
        WHEN OTHERS THEN
            pc_coderr := SQLCODE;
            pc_msgerr := 'Error: ' || SQLERRM;
    END;
END sp_cr_envcercanweb;
/

