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
  -- Fecha de Modificación      : 25/06/2025
  -- Autor de Modificación      : Milton Cordova
  -- Descripción de Modificación: Proceso Log para validacion de Limite de reprogramaciones por Region
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
                                       DESMSG        OUT VARCHAR2);

  PROCEDURE sp_cr_actualizar_reprogramador(P_INSTANCIA IN NUMBER,
                                           USUARIO     IN VARCHAR2,
                                           CODMSG      OUT VARCHAR2,
                                           DESMSG      OUT VARCHAR2);
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
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción de Modificación: 
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
  
    current_date DATE;
    current_time VARCHAR(8);
  BEGIN
    begin
    
      current_date := sysdate;
      current_time := TO_CHAR(SYSDATE, 'HH24:MI');
    
      INSERT INTO AQPD601L
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
         current_time,
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
    current_date DATE;
    indicador    number;
  BEGIN
    begin
      -- Fecha actual --
      current_date := to_date(to_char(sysdate, 'dd/mm/rrrr'));
      UPDATE AQPB556
         SET AQPB556FECR = current_date, AQPB556USPAPR = USUARIO
       WHERE AQPB556INST = P_INSTANCIA;
    exception
      when others then
        CODMSG := '001';
        DESMSG := 'Error';
        ROLLBACK;
    end;
    -- INI MCH IGS - 18/06/2025
    begin
      PQ_CR_CNTRL_LIMITREPRO.sp_Cr_UpdAQPD059(P_INSTANCIA, indicador);
    exception
      when others then
        CODMSG := '002';
        DESMSG := 'Error';
        rollback;
    end;
    -- FIN MCH IGS - 18/06/2025
  END sp_cr_actualizar_reprogramador;
end pq_cr_log_reprogramaciones;
/
