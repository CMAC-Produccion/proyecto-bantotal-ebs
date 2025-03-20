create or replace procedure SP_CTLDUPTAR(vNumTar  varchar2,vFecPro date,vCodUsu varchar2,
                                         vHorTra varchar2,vsuc number,vmod number, vtra number, vrel number, vmot varchar2, vest varchar2) is
PRAGMA AUTONOMOUS_TRANSACTION;

begin
  insert into JAQL820 (JAQL820NUM,JAQL820EST,JAQL820FES,JAQL820FRE,JAQL820USU,JAQL820HOR,JAQL820SUC,JAQL820MOD,
                       JAQL820TRA,JAQL820REL,JAQL820MOT)
  values (vNumTar,vest,vFecPro,vFecPro,vCodUsu,vHorTra,vsuc,vmod,vtra,vrel,vmot);
  commit;

end SP_CTLDUPTAR;
/

