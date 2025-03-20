create or replace package PQ_CR_MIGRA_DATA_ENTRY is

-- *****************************************************************
-- Nombre                     : PQ_CR_MIGRA_DATA_ENTRY
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 02/02/2016
-- Autor de Creación          : Cinthya Liz hernandez Ortega
-- Uso                        : Migracion de data entry a bantotal y viceversa
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
--
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CR_COPIA_TABLA_USU (USUARIO varchar2, 
                                 NUMGAR number
                                );
procedure SP_CR_COPIA_TABLA ;
procedure SP_CR_MIGRA_GARANTIA (P_JAQZ209ID NUMERIC,                                
                                P_Pgfape date,
                                P_itoper NUMERIC,
                                P_itnrel numeric,
                                p_resp out varchar2
                                );
procedure SP_CR_ANULA_GARANTIA (P_IDGAR number, 
                                P_NUMCOR number, 
                                P_ERROR out varchar2);
procedure SP_CR_ERROR_GARANTIA (P_IDGAR number, 
                                P_LOG varchar2 
                                );                                
procedure SP_CR_ACTUALIZA_GARANTIA (P_IDGAR number, 
                                   P_NUMCTA number, 
                                   P_ERROR out  varchar2);                              
end PQ_CR_MIGRA_DATA_ENTRY;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_MIGRA_DATA_ENTRY is

-- *****************************************************************
-- Nombre                     : PQ_CR_MIGRA_DATA_ENTRY
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 02/02/2016
-- Autor de Creación          : Cinthya Liz hernandez Ortega
-- Uso                        : Migracion de data entry a bantotal y viceversa
-- Estado                     : Activo
-- Acceso                     : Público
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CR_COPIA_TABLA_USU(USUARIO varchar2, NUMGAR number) is
begin
  insert into jaqz209b
    select JAQZ209ID,JAQZ209SUC,JAQZ209MOD,JAQZ209TRAN,JAQZ209TOPE,
JAQZ209OPE,JAQZ209MON,JAQZ209CTA,JAQZ209IMP,JAQZ209FVAL,JAQZ209FGPRO,
JAQZ209FUPD,JAQZ209FCRE,JAQZ209USU
      from jaqz209
     where jaqz209usu = usuario
       and jaqz209fgpro = 0
       and jaqz209fgest = 1
       and jaqz209fgcta = 'N'
       and (jaqz209id = NUMGAR or NUMGAR = 0);
  commit;
EXCEPTION
  WHEN others THEN
    DBMS_OUTPUT.put_line('ERROR');
end SP_CR_COPIA_TABLA_USU;

procedure SP_CR_COPIA_TABLA is
begin
  insert into jaqz209b
    select JAQZ209ID,JAQZ209SUC,JAQZ209MOD,JAQZ209TRAN,JAQZ209TOPE,
           JAQZ209OPE,JAQZ209MON,JAQZ209CTA,JAQZ209IMP,JAQZ209FVAL,JAQZ209FGPRO,
           JAQZ209FUPD,JAQZ209FCRE,JAQZ209USU
     from jaqz209 where jaqz209fgpro = 0 and jaqz209fgest = 1 and jaqz209fgcta = 'N';
  commit;
EXCEPTION
  WHEN others THEN
    DBMS_OUTPUT.put_line('ERROR');
end SP_CR_COPIA_TABLA;

procedure SP_CR_MIGRA_GARANTIA (P_JAQZ209ID NUMERIC,                                
                                P_Pgfape date,
                                P_itoper NUMERIC,
                                P_itnrel numeric,
                                p_resp out varchar2 
                                )is
L_FECHA  date;
N_CORR   numeric;
C_ERR    char(200);
Begin
p_resp:='00000';
commit;

update PPG000@eval 
   set PPG000OPE = P_itoper,
       PPG000TNR = P_itnrel,
       PPG000TCO = 'S'
where PPG000ID = P_JAQZ209ID;

update PPG001@eval 
   set PPG001OPE = P_itoper
where PPG001ID = P_JAQZ209ID;

update PPG002@eval 
   set PPG002OPE = P_itoper
where PPG002ID = P_JAQZ209ID;

update PPG003@eval 
   set PPG003OPE = P_itoper
where PPG003ID = P_JAQZ209ID;

update PPG004@eval 
   set PPG004OPE = P_itoper
where PPG004ID = P_JAQZ209ID;

update PPG005@eval 
   set PPG005OPE = P_itoper
where PPG005ID = P_JAQZ209ID;

update PPG006@eval 
   set PPG006OPE = P_itoper
where PPG006ID = P_JAQZ209ID;

update PPG007@eval 
   set PPG007OPE = P_itoper
where PPG007ID = P_JAQZ209ID;

update PPG008@eval 
   set PPG008OPE = P_itoper
where PPG008ID = P_JAQZ209ID;

select sysdate into L_FECHA from dual;

update JAQZ209@eval
   set 
       JAQZ209OPE  = P_itoper,
       JAQZ209FVAL = P_Pgfape,
       JAQZ209FUPD = L_FECHA,
       JAQZ209FGPRO = 1
 where jaqz209id = P_JAQZ209ID;
 
commit;

insert into PPG000
  select ppg000pgc,
         ppg000mod,
         ppg000suc,
         ppg000mda,
         ppg000pap,
         ppg000cta,
         ppg000ope,
         ppg000sbo,
         ppg000top,
         ppg000cor,
         ppg000frm,
         ppg000tpg,
         ppg000tsc,
         ppg000tmd,
         ppg000ttr,
         ppg000tnr,
         ppg000tfc,
         ppg000tor,
         ppg000tso,
         ppg000tco,
         ppg000au1,
         ppg000au2,
         ppg000au3,
         ppg000au4,
         ppg000au5,
         ppg000au6,
         ppg000au7
    from PPG000@eval
  Where ppg000id = P_JAQZ209ID;

insert into PPG001
  select ppg001cod,
         ppg001mod,
         ppg001suc,
         ppg001mda,
         ppg001pap,
         ppg001cta,
         ppg001ope,
         ppg001sbo,
         ppg001top,
         ppg001cor,
         ppg001frm,
         ppg001cdat,
         ppg001dato,
         ppg001au1,
         ppg001au2,
         ppg001au3,
         ppg001au4,
         ppg001au5,
         ppg001au6,
         ppg001au7
    from PPG001@eval
  Where ppg001id = P_JAQZ209ID;

insert into PPG002
  select ppg002cod,
         ppg002mod,
         ppg002suc,
         ppg002mda,
         ppg002pap,
         ppg002cta,
         ppg002ope,
         ppg002sbo,
         ppg002top,
         ppg002cor,
         ppg002frm,
         ppg002cdat,
         ppg002dato,
         ppg002au1,
         ppg002au2,
         ppg002au3,
         ppg002au4,
         ppg002au5,
         ppg002au6,
         ppg002au7
    from PPG002@eval
  Where ppg002id = P_JAQZ209ID;

insert into PPG003
  select ppg003cod,
         ppg003mod,
         ppg003suc,
         ppg003mda,
         ppg003pap,
         ppg003cta,
         ppg003ope,
         ppg003sbo,
         ppg003top,
         ppg003cor,
         ppg003frm,
         ppg003cdat,
         ppg003dato,
         ppg003au1,
         ppg003au2,
         ppg003au3,
         ppg003au4,
         ppg003au5,
         ppg003au6,
         ppg003au7
    from PPG003@eval
  Where ppg003id = P_JAQZ209ID;

insert into PPG004
  select ppg004cod,
         ppg004mod,
         ppg004suc,
         ppg004mda,
         ppg004pap,
         ppg004cta,
         ppg004ope,
         ppg004sbo,
         ppg004top,
         ppg004cor,
         ppg004frm,
         ppg004cdat,
         ppg004dato,
         ppg004au1,
         ppg004au2,
         ppg004au3,
         ppg004au4,
         ppg004au5,
         ppg004au6,
         ppg004au7
    from PPG004@eval
  Where ppg004id = P_JAQZ209ID;

insert into PPG005
  select ppg005cod,
         ppg005mod,
         ppg005suc,
         ppg005mda,
         ppg005pap,
         ppg005cta,
         ppg005ope,
         ppg005sbo,
         ppg005top,
         ppg005cor,
         ppg005frm,
         ppg005cdat,
         ppg005datp,
         ppg005au1,
         ppg005au2,
         ppg005au3,
         ppg005au4,
         ppg005au5,
         ppg005au6,
         ppg005au7
    from PPG005@eval
  Where ppg005id = P_JAQZ209ID;

insert into PPG006
  select ppg006cod,
         ppg006mod,
         ppg006suc,
         ppg006mda,
         ppg006pap,
         ppg006cta,
         ppg006ope,
         ppg006sbo,
         ppg006top,
         ppg006cor,
         ppg006frm,
         ppg006cdat,
         ppg006dato,
         ppg006au1,
         ppg006au2,
         ppg006au3,
         ppg006au4,
         ppg006au5,
         ppg006au6,
         ppg006au7
    from PPG006@eval
  Where ppg006id = P_JAQZ209ID;

insert into PPG007
  select ppg007cod,
         ppg007mod,
         ppg007suc,
         ppg007mda,
         ppg007pap,
         ppg007cta,
         ppg007ope,
         ppg007sbo,
         ppg007top,
         ppg007cor,
         ppg007frm,
         ppg007cdat,
         ppg007dato,
         ppg007au1,
         ppg007au2,
         ppg007au3,
         ppg007au4,
         ppg007au5,
         ppg007au6,
         ppg007au7
    from PPG007@eval
  Where ppg007id = P_JAQZ209ID;

insert into PPG008
  select ppg008pgc,
         ppg008mod,
         ppg008suc,
         ppg008mda,
         ppg008pap,
         ppg008cta,
         ppg008ope,
         ppg008sbo,
         ppg008top,
         ppg008corr,
         ppg008frm,
         ppg008cdat,
         ppg008cpu,
         ppg008cip,
         ppg008desc,
         ppg008au1,
         ppg008au2,
         ppg008au3,
         ppg008au4,
         ppg008au5,
         ppg008au6,
         ppg008au7
    from PPG008@eval
  Where ppg008id = P_JAQZ209ID;
  commit;

EXCEPTION
  WHEN others THEN
--  select max(jaqz209acorr) into N_CORR from jaqz209a;
  rollback;
  p_resp:='81000';
  update JAQZ209@eval
     set 
         JAQZ209OPE  = P_itoper,
         JAQZ209FVAL = P_Pgfape,
         JAQZ209FUPD = L_FECHA,
         JAQZ209FGPRO = 0
   where jaqz209id = P_JAQZ209ID;
   commit;
  select case when max(jaqz209acorr) is null then 0 else  max(jaqz209acorr) end into N_CORR from jaqz209a;
  N_CORR := N_CORR + 1;
  C_ERR  := sqlerrm;
  insert into jaqz209a values ( N_CORR,P_Pgfape,P_JAQZ209ID, C_ERR);
  commit;
end SP_CR_MIGRA_GARANTIA;

procedure SP_CR_ANULA_GARANTIA (P_IDGAR number, P_NUMCOR number, P_ERROR out  varchar2)

is 
  cursor c_cuentas is  --Cuentas a actualizar
  SELECT ctnro, pendoc, b.jaqz329log log from (select * from fsr008_aux@eval 
  where ctnro in (select jaqz209ctatmp from jaqz209@eval where jaqz209id=P_IDGAR)) a 
  inner join jaqz329 b on a.pendoc = b.jaqz329numdoc and b.jaqz329nro=P_NUMCOR;
 
begin    
  begin
    commit;    
    for g in c_cuentas loop
        update fsr008_aux@eval
        set log = g.log
        where ctnro= g.ctnro and pendoc=g.pendoc;
    end loop;   

    update JAQZ209@eval
    set JAQZ209FGPRO= 2 --Anulada - Error al Generar Garantia - Cuenta Invalida
    , JAQZ209LOG = 'Garantía Anulada - Cuenta Cliente con Errores'
    where JAQZ209ID = P_IDGAR;
    commit;
  end;
  exception
  WHEN others THEN
    p_error := sqlerrm;    
end SP_CR_ANULA_GARANTIA;

procedure SP_CR_ERROR_GARANTIA (P_IDGAR number, P_LOG varchar2)
is 
p_error varchar2(200);
begin    
  begin
    commit;    

    update JAQZ209@eval
    set JAQZ209FGPRO= 2 --Anulada - Error al Generar Garantia - Otros Errores
    , JAQZ209LOG = P_LOG 
    where JAQZ209ID = P_IDGAR;
    commit;
  end;
  exception
  WHEN others THEN
    p_error := sqlerrm;    
end SP_CR_ERROR_GARANTIA;

procedure SP_CR_ACTUALIZA_GARANTIA (P_IDGAR number, P_NUMCTA number, P_ERROR out  varchar2)
is 
begin    
  begin
      commit;
      update JAQZ209@eval
      set JAQZ209FGCTA = 'N', JAQZ209CTA= P_NUMCTA
      where JAQZ209ID = P_IDGAR and JAQZ209FGCTA = 'S';
      
      UPDATE PPG000@eval SET PPG000CTA = P_NUMCTA where PPG000ID=P_IDGAR;
      UPDATE PPG001@eval SET PPG001CTA = P_NUMCTA where PPG001ID=P_IDGAR;
      UPDATE PPG002@eval SET PPG002CTA = P_NUMCTA where PPG002ID=P_IDGAR;
      UPDATE PPG003@eval SET PPG003CTA = P_NUMCTA where PPG003ID=P_IDGAR;
      UPDATE PPG004@eval SET PPG004CTA = P_NUMCTA where PPG004ID=P_IDGAR;
      UPDATE PPG005@eval SET PPG005CTA = P_NUMCTA where PPG005ID=P_IDGAR;
      UPDATE PPG006@eval SET PPG006CTA = P_NUMCTA where PPG006ID=P_IDGAR;
      UPDATE PPG007@eval SET PPG007CTA = P_NUMCTA where PPG007ID=P_IDGAR;
      UPDATE PPG008@eval SET PPG008CTA = P_NUMCTA where PPG008ID=P_IDGAR; 
      commit;        
  end;
  exception
  WHEN others THEN
    p_error := sqlerrm;
    --p_error :='ERROR EN LA ACTUALIZACION';
end SP_CR_ACTUALIZA_GARANTIA;


end PQ_CR_MIGRA_DATA_ENTRY;
/

