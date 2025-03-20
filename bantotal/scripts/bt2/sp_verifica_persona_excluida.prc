CREATE OR REPLACE PROCEDURE sp_Verifica_Persona_Excluida( ppais IN NUMBER , ptipdoc IN NUMBER , pndoc IN VARCHAR2 , conta OUT NUMBER )
IS
begin
  select count(*)   into conta
  from v_anexo17a
  where PAIS = ppais and TIPODOC=ptipdoc and NU_DOCU_IDEN=pndoc;
END ;
/

