CREATE OR REPLACE TRIGGER TG_FPP001_BD_01
/* ************************************************************************************************************
    -- Nombre                     : TG_FPP001_BD_01 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Trigger Inserta Log de Eliminaciones FPP001
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2019
    -- Autor de Creación          : Cinthya Liz Hernandez Ortega
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Descripción Modificación   : 

* *************************************************************************************************************/
 before delete on FPP001
 for each row 
DECLARE
  c_usuarioC char(10);
  d_fecha    date;
  c_hora     char(8);
  n_exist    numeric(5);
begin
  n_exist := 0;
  begin
    select count(*)
      into n_exist
      from fsd010
     where PGCOD = :old.pgcod
       and AOMOD = :old.aomod
       and AOSUC = :old.aosuc
       and AOMDA = :old.aomda
       and AOPAP = :old.aopap
       and AOCTA = :old.aocta
       and AOOPER = :old.aooper
       and AOSBOP = :old.aosbop
       and AOTOPE = :old.aotope;
  Exception
    When others then
      n_exist := 0;
  END;

  If n_exist > 0 then
    c_usuarioC := TRIM(SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                              1,
                              10));
    select pgfape into d_fecha from fst017 where pgcod = 1;
    c_hora := to_char(sysdate, 'HH24:mi:ss');
  
    insert into AQPA020
      (aqpa020pgc,
       aqpa020mod,
       aqpa020suc,
       aqpa020mda,
       aqpa020pap,
       aqpa020cta,
       aqpa020ope,
       aqpa020sbo,
       aqpa020top,
       aqpa020sgc,
       aqpa020fep,
       aqpa020hor,
       aqpa020usr,
       aqpa020vc,
       aqpa020imp,
       aqpa020porc,
       aqpa020plus,
       aqpa020part,
       aqpa020veh,
       aqpa020inm,
       aqpa020end,
       aqpa020stat,
       aqpa020co,
       aqpa020aux1,
       aqpa020aux2,
       aqpa020aux3,
       aqpa020aux4,
       aqpa020aux5,
       aqpa020aux6,
       aqpa020aux7)
    Values
      (:old.pgcod,
       :old.aomod,
       :old.aosuc,
       :old.aomda,
       :old.aopap,
       :old.aocta,
       :old.aooper,
       :old.aosbop,
       :old.aotope,
       :old.sgcod,
       d_fecha,
       c_hora,
       c_usuarioC,
       :old.pp001vc,
       :old.pp001imp,
       :old.pp001porc,
       :old.pp001plus,
       :old.pp001part,
       :old.pp001veh,
       :old.pp001inm,
       :old.pp001end,
       :old.pp001stat,
       :old.pp001co,
       :old.pp001aux1,
       :old.pp001aux2,
       :old.pp001aux3,
       :old.pp001aux4,
       :old.pp001aux5,
       :old.pp001aux6,
       :old.pp001aux7);
  end if;
Exception
  When others then
    null;
end TG_FPP001_BD_01;
/

