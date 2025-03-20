CREATE OR REPLACE TRIGGER "TG_SNG090_AU_01"
  AFTER INSERT on SNG090
  for each row
-- *******************************************************************************************************
-- Nombre                     : TG_SNG090_AU_01
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2024.06.28
-- Autor de Creación          : Henry Angel Suarez Lazarte - CAJA AREQUIPA
-- Uso                        : Envío de alertas via correo electrónco a usuarios con creditos pendientes
--                              de autorizacion por bloqueante con excepcion.
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 09/07/2024
-- Autor de Modificación      : Rcastro
-- Descripción de Modificación: Se agrega parametro adicional a procedimiento sp_genr_notif_polit
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
-- ********************************************************************************************************
DECLARE


ln_numins number(10):= 0;
lv_usrapr varchar2(10) := '';
vi_rpta  varchar(1) := '';
X_WFITEMID NUMBER(10);
TIPO CHAR(1) :='';
BEGIN
  TIPO:=:new.SNG090TPO;
    IF :new.SNG090TPO = 'P' then
      BEGIN
        select WFITEMID INTO X_WFITEMID from wfwrkitems where wfinsprcid = :new.SNG001INST and WFITEMSTSACT = 1;
      exception
        when others then
          null;      
      END;     
      X_WFITEMID := NVL(X_WFITEMID, 0);
      
      BEGIN        
        SELECT PAE70USR INTO lv_usrapr
        FROM FPAE70 XX
        WHERE 
        XX.PAE70INS = :new.SNG001INST
        AND XX.PAE70NRO = (SELECT MAX(W.PAE70NRO)
                           FROM FPAE70 W WHERE PAE70WRI=  X_WFITEMID);
      exception
        when others then
          null;                          
      END;

      lv_usrapr := TRIM(lv_usrapr);
      ln_numins := :new.SNG001INST;
      vi_rpta   := '';
      begin
        pq_cr_noti_excep_gere_cred.sp_genr_notif_polit(ln_numins, X_WFITEMID, lv_usrapr, vi_rpta);
      exception
        when others then
          null;
      end;
     
    end if;
    /* begin
        insert into prueba_log(pgcod,msg) values(152,'se ejecuto politicas :'||ln_numins||'-'||TIPO);
      exception
        when others then 
          NULL;
      end;*/
  -------------------------------
exception
  when others then
    null;
end TG_SNG090_AU_01;
/

