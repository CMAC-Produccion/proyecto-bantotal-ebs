create or replace procedure SP_CR_MARCAR_CREDITO(P_EMPCOD in number, P_NROOPE in number, P_CODCAR in varchar, P_ERRCOD out varchar, P_ERRMSG out varchar) as
---***
ln_cab NUMBER;
ln_nrosus NUMBER(3);
ld_modfec DATE;
lc_modhor CHAR(8);
lc_modusr VARCHAR(30);
ln_modsuc NUMBER(3);
lc_codcar_ant VARCHAR(16);
ln_codcar_ant NUMBER;
lc_nrocrerep VARCHAR(70);
---***
begin
--dbms_output.put_line('SP_CR_MARCAR_CREDITO');
savepoint SP_CR_MARCAR_CREDITO;
---*********
select AQPB506NROSUS, AQPB506MODFEC, AQPB506MODHOR, AQPB506MODUSR, AQPB506MODSUC
into ln_nrosus, ld_modfec, lc_modhor, lc_modusr, ln_modsuc
from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR and ROWNUM = 1;

--dbms_output.put_line('ln_nrosus = '|| ln_nrosus);
--dbms_output.put_line('ld_modfec = '|| ld_modfec);
--dbms_output.put_line('lc_modhor = '|| lc_modhor);
--dbms_output.put_line('lc_modusr = '|| lc_modusr);
--dbms_output.put_line('ln_modsuc = '|| ln_modsuc);
---***
select count(*) into ln_codcar_ant from AQPB506
where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR <> P_CODCAR;
--dbms_output.put_line('ln_codcar_ant = '||ln_codcar_ant);
if(ln_codcar_ant > 0) then
  select AQPB506CODCAR into lc_codcar_ant from (select * from AQPB506
  where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR <> P_CODCAR
  order by AQPB506CRETIM desc) where ROWNUM = 1;
end if;
--dbms_output.put_line('lc_codcar_ant = '||lc_codcar_ant);
---***
select count(*) into ln_cab from AQPB506A where AQPB506AEMPCOD = P_EMPCOD and AQPB506ANROOPE = P_NROOPE;
--dbms_output.put_line('ln_cab = '|| ln_cab);
---***
if(ln_cab = 0) then ---*** CAB NO Existe --> INSERTAR
   --dbms_output.put_line('INSERTAR CAB');
   ---*** insertar Cabecera
   --select * from AQPB506A
   insert into AQPB506A(
   select AQPB506EMPCOD, AQPB506NROOPE, AQPB506NROSUS, AQPB506CODCAR, AQPB506EST
   , AQPB506CREFEC, AQPB506CREHOR, AQPB506CREUSR, AQPB506CRESUC, SYSDATE
   , AQPB506MODFEC, AQPB506MODHOR, AQPB506MODUSR, AQPB506MODSUC, SYSDATE
   from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR and ROWNUM = 1);
else ---*** CAB Existe --> ACTUALIZAR
   --dbms_output.put_line('ACTUALIZAR CAB');
   update AQPB506A
   set AQPB506ACODCAR = P_CODCAR, AQPB506ANROSUS = ln_nrosus
   , AQPB506AMODFEC = ld_modfec, AQPB506AMODHOR = lc_modhor
   , AQPB506AMODUSR = lc_modusr, AQPB506AMODSUC = ln_modsuc, AQPB506AMODTIM = SYSDATE
   where AQPB506AEMPCOD = P_EMPCOD and AQPB506ANROOPE = P_NROOPE;

   update AQPB506B
   set AQPB506BMODFEC = ld_modfec, AQPB506BMODHOR = lc_modhor
   , AQPB506BMODUSR = lc_modusr, AQPB506BMODSUC = ln_modsuc
   where AQPB506BEMPCOD = P_EMPCOD and AQPB506BNROOPE = P_NROOPE;

end if;
---*** Procesamiento General
---*** Eliminar los Creditos que ya no vinieron en el Archivo (En esta CARGA) para esta Empresa_Operacion
delete from AQPB506B
where AQPB506BEMPCOD = P_EMPCOD and AQPB506BNROOPE = P_NROOPE
and AQPB506BNROCRE not in (select AQPB506NROCRE from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR);
--dbms_output.put_line('ELIMINAR ...');
---*** Actualizar los Creditos Eliminados como Desmarcados

if(lc_codcar_ant is not null) then
  --dbms_output.put_line(lc_codcar_ant);
  --select * from AQPB506
  update AQPB506 set
  AQPB506MODFEC = ld_modfec, AQPB506MODHOR = lc_modhor,
  AQPB506MODUSR = lc_modusr, AQPB506MODSUC = ln_modsuc,
  AQPB506MODTIM = SYSDATE, AQPB506EST = 'D',
  AQPB506DMAFEC = ld_modfec, AQPB506DMAHOR = lc_modhor
  where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = lc_codcar_ant
  and AQPB506NROCRE not in (select AQPB506NROCRE from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR);

--dbms_output.put_line('ACTUALIZAR ELIMINADOS : AQPB506...');
end if;

---*** Insertar Nuevos Creditos (los Repetidos NO se tocan)
--select * from AQPB506B
--dbms_output.put_line('INSERTAR NUEVOS CREDITOS : AQPB506B ANT ...');

insert into AQPB506B(
   select AQPB506NROCRE, AQPB506EMPCOD, AQPB506NROOPE, AQPB506CODCAR, AQPB506EST
   , AQPB506PGCOD, AQPB506SCSUC, AQPB506SCRUB, AQPB506SCMDA, AQPB506SCPAP, AQPB506SCCTA
   , AQPB506SCOPER, AQPB506SCSBOP, AQPB506SCTOPE, AQPB506SCMOD, AQPB506SCGRU
   , AQPB506TIPTIT, AQPB506FECDES, AQPB506FECVEN, AQPB506NDOC, AQPB506NOM
   , AQPB506RCC, AQPB506MONEDA, AQPB506MONDES, AQPB506MONSAL, AQPB506TIPGAR
   , AQPB506MONEGA, AQPB506MONGAR, AQPB506LOCALI
   , AQPB506CREFEC, AQPB506CREHOR, AQPB506CREUSR, AQPB506CRESUC, SYSDATE
   , AQPB506MODFEC, AQPB506MODHOR, AQPB506MODUSR, AQPB506MODSUC, SYSDATE
from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR
and AQPB506NROCRE not in (select AQPB506BNROCRE from AQPB506B where AQPB506BEMPCOD = P_EMPCOD and AQPB506BNROOPE = P_NROOPE));
--dbms_output.put_line('INSERTAR NUEVOS CREDITOS : AQPB506B DES ...');
---***
commit;
---***
P_ERRCOD := '000';
P_ERRMSG := 'PROCESO TERMINADO SATISFACTORIAMENTE!!!';
---***
exception
  when DUP_VAL_ON_INDEX then
    ---***
    select LISTAGG(AQPB506BNROCRE, ',') within group (order by AQPB506BCRETIM) into lc_nrocrerep from AQPB506B
    WHERE (AQPB506BEMPCOD <> P_EMPCOD OR AQPB506BNROOPE <> P_NROOPE) AND
    AQPB506BNROCRE in(select AQPB506NROCRE from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR) AND ROWNUM < 4;
    ---***
    rollback to SP_CR_MARCAR_CREDITO;
    delete from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR;
    commit;
    ---***
    P_ERRCOD := '001';
    P_ERRMSG := 'HAY CRÉDITOS REPETIDOS (Ya Marcados para otra Empresa/Operación), COMO: '||'['||lc_nrocrerep||'] (Solo publicamos Hasta 3 Repetidos)';
  when others then
    ---***
    rollback to SP_CR_MARCAR_CREDITO;
    delete from AQPB506 where AQPB506EMPCOD = P_EMPCOD and AQPB506NROOPE = P_NROOPE and AQPB506CODCAR = P_CODCAR;
    commit;
    ---***
    P_ERRCOD := '002';
    P_ERRMSG := 'OCURRIÓ UN ERROR';
end;
/

