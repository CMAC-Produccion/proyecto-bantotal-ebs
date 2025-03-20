create or replace package pq_cr_log_reprogramaciones is

  -- *****************************************************************
  -- Nombre                     : pq_cr_log_reprogramaciones 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19.06.2024
  -- Autor de Creación          : Alexander Acuña Ramirez
  -- Uso                        : Registra logs del proceso de reprogramación sin capitalización
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 03/02/2025
  -- Autor de Modificación      : CALARCONAP
  -- Descripción de Modificación: Se comenta variables con nombre de palabras reservadas
  -- 
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_cr_log_reprogramaciones (P_INSTANCIA          IN NUMBER,
                                        P_TIPO_REPROG        IN NUMBER,
                                        P_EST_REPROG         IN VARCHAR2,
                                        FLAG_01              IN VARCHAR2,
                                        FLAG_02              IN VARCHAR2,
                                        FLAG_03              IN VARCHAR2,
                                        FLAG_04              IN VARCHAR2,
                                        FLAG_05              IN VARCHAR2,
                                        FLAG_06              IN NUMBER,
                                        FLAG_07              IN VARCHAR2,
                                        FLAG_08              IN VARCHAR2,
                                        P_COD                IN VARCHAR2,
                                        P_MSG                IN VARCHAR2,
                                        USUARIO              IN VARCHAR2,
                                        CODMSG               OUT VARCHAR2,
                                        DESMSG               OUT VARCHAR2);

  PROCEDURE sp_cr_actualizar_reprogramador(P_INSTANCIA       IN NUMBER,
                                           USUARIO           IN VARCHAR2,
                                           CODMSG            OUT VARCHAR2,
                                           DESMSG            OUT VARCHAR2);
end pq_cr_log_reprogramaciones;
/

create or replace package body pq_cr_log_reprogramaciones is
  -- *****************************************************************
  -- Nombre                     : pq_cr_log_reprogramaciones 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19.06.2024
  -- Autor de Creación          : Alexander Acuña Ramirez
  -- Uso                        : Registra logs del proceso de reprogramación sin capitalización
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 03/02/2025
  -- Autor de Modificación      : CALARCONAP
  -- Descripción de Modificación: Se comenta variables con nombre de palabras reservadas
  -- 
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_log_reprogramaciones(P_INSTANCIA   IN NUMBER,
                                       P_TIPO_REPROG IN NUMBER,
                                       P_EST_REPROG  IN VARCHAR2,
                                       FLAG_01       IN VARCHAR2,
                                       FLAG_02       IN VARCHAR2,
                                       FLAG_03       IN VARCHAR2,
                                       FLAG_04       IN VARCHAR2,
                                       FLAG_05       IN VARCHAR2,
                                       FLAG_06       IN NUMBER,
                                       FLAG_07       IN VARCHAR2,
                                       FLAG_08       IN VARCHAR2,
                                       P_COD         IN VARCHAR2,
                                       P_MSG         IN VARCHAR2,
                                       USUARIO       IN VARCHAR2,
                                       CODMSG        OUT VARCHAR2,
                                       DESMSG        OUT VARCHAR2) IS
  
    --current_date DATE;
    --current_time VARCHAR(8);
  BEGIN
    begin
    
      --current_date := sysdate;
      --current_time := TO_CHAR(SYSDATE,'HH24:MI'); 
    
      INSERT INTO AQPD601L
        (aqpd601linst,
         aqpd601ltprg,
         aqpd601lest,
         aqpd601lfl1,
         aqpd601lfl2,
         aqpd601lfl3,
         aqpd601lfl4,
         aqpd601lfl5,
         aqpd601lfl6,
         aqpd601lfl7,
         aqpd601lfl8,
         aqpd601pcod,
         aqpd601lmsg,
         aqpd601lusr,
         aqpd601ltime,
         aqpd601lfec)
      VALUES
        (P_INSTANCIA,
         P_TIPO_REPROG,
         P_EST_REPROG,
         FLAG_01,
         FLAG_02,
         FLAG_03,
         FLAG_04,
         FLAG_05,
         FLAG_06,
         FLAG_07,
         FLAG_08,
         P_COD,
         P_MSG,
         USUARIO,
         --current_time,
         TO_CHAR(SYSDATE, 'HH24:MI'),
         current_date);
    
      COMMIT;
    exception
      when DUP_VAL_ON_INDEX then
        CODMSG := '001';
        DESMSG := 'Registro repetido, no se puede continuar.';
        ROLLBACK;
      when others then
        CODMSG := '002';
        DESMSG := SQLERRM;
        ROLLBACK;
      
    end;
  
  END sp_cr_log_reprogramaciones;

  PROCEDURE sp_cr_actualizar_reprogramador(P_INSTANCIA IN NUMBER,
                                           USUARIO     IN VARCHAR2,
                                           CODMSG      OUT VARCHAR2,
                                           DESMSG      OUT VARCHAR2) IS
    current_datee DATE;
  BEGIN
    begin
      -- Fecha actual --
      current_datee := to_date(to_char(sysdate, 'dd/mm/rrrr'));
      UPDATE AQPB556
         SET AQPB556FECR = current_datee, AQPB556USPAPR = USUARIO
       WHERE AQPB556INST = P_INSTANCIA;
    exception
      when others then
        CODMSG := '001';
        DESMSG := 'Error';
        ROLLBACK;
    end;
  
  END sp_cr_actualizar_reprogramador;

end pq_cr_log_reprogramaciones;
/

