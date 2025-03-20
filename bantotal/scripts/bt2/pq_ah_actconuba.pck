create or replace package PQ_AH_ACTCONUBA is

  -- Author  : EBARROS
  -- Created : 22/11/2017 13:25:40
  -- Purpose : UNIBANCA
  -- Actualizado al 23/11/2017
  -- Public type declarations
  procedure SP_SIMP_CARGA_AGENCIA(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_ATM(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_AUTO_BEVERTEC(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_AUTO_NOVATRONIC(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_CLIENTES(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_CUENTAS(FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_TARJETAS(FECHA_PROCESO DATE);
  PROCEDURE SP_NO_CONTA_ADQUI(FECHA_PROCESO DATE);
  PROCEDURE SP_NO_CONTA_EMI(FECHA_PROCESO DATE);
  PROCEDURE SP_REVERSOS(FECHA_PROCESO DATE);
  PROCEDURE SP_DIFRES(FECHA_PROCESO DATE);
  PROCEDURE SP_CU_TXNBAN(FECHA_BANTOTAL DATE);
  PROCEDURE SP_SIMP_EJE_PROCESO(PD_FECPRO in date,PS_MENERR  out varchar2);
  PROCEDURE SP_SIMP_CARGA_COMIS (FECHA_PROCESO DATE);
  PROCEDURE SP_SIMP_CARGA_CONTADORES (FECHA_PROCESO DATE);
end PQ_AH_ACTCONUBA;
/

create or replace package body PQ_AH_ACTCONUBA is

PROCEDURE SP_SIMP_CARGA_AGENCIA (FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_AGENCIA
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de Agencias
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
CURSOR c_AgeCli IS
   SELECT a.ncodage,a.cnomage,a.cdesdir || ' ' || TO_CHAR(a.ncodnro) cdirage,
          trim(TO_CHAR(a.ccodciu, '0000') || '00') AS ubigeo,b.calcod as calcod
     FROM jaql823a a,fst001 b
    WHERE b.pgcod = 1
      and a.ncodage = b.sucurs
   ORDER BY 1;
CURSOR c_AgeCal IS
   SELECT calcod,calnom
     FROM fst128
   ORDER BY 1; 
ln_CodPro   number;
ls_msgerr   varchar2(4000);
ln_codage   number;
ld_fecpro   varchar(10);
ln_contador number(10);
ls_horaini  varchar(8);
ls_horafin  varchar(8);
ld_fecini   varchar(10);
ld_fecfin   date;
ld_indest   number;
ld_fecact   date;  
ls_descal   varchar(100);
ln_codcal   number(5);
BEGIN
  /*SELECT "dFechaProceso" into ld_fecpro
     FROM "MaeParametrosGenerales"@Unibanca;
  commit;*/
  ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
  --ld_fecpro := FECHA_PROCESO;
  ln_contador := 0;
  ld_indest   := 1;
  ld_fecini   := to_char(trunc(sysdate), 'yyyy-mm-dd');
  ls_horaini  := to_char(sysdate, 'HH24:Mi:ss');
  ls_msgerr   := 'PROCESO EJECUTADO CORRECTAMENTE';
  UPDATE "LogControlProgramaResumen"@Unibanca
     SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini,
         "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini
   WHERE "vIdGrupo" = 'CARGA_TABLAS'
     AND "vFechaProceso" = ld_fecpro
     AND "vIdPrograma" = 'AGEN'
     AND "vIdSubModulo" = 'LOAD'
     AND "nEstado" IN (-1, 0);
  commit;
  select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
  ln_CodPro := ln_CodPro + 1;
  insert into jaqz926A
  values
    (ln_CodPro, 'SP_SIMP_CARGA_AGENCIA', 'SYSADM', sysdate, sysdate);
  commit;
  delete "MaeAgencias"@Unibanca;
  commit;
  FOR c_DatCli IN c_AgeCli LOOP
  Begin
     ln_codage := c_DatCli.ncodage;
     insert into "MaeAgencias"@Unibanca
        ("nIdAgencia","vDescripcion","vDireccion","vCodigoUbigeo","nIdCalendario")
     values 
        (c_DatCli.ncodage,c_DatCli.cnomage,c_DatCli.cdirage,c_DatCli.ubigeo,c_DatCli.calcod);
     COMMIT;
     ln_contador := ln_contador + 1;
  EXCEPTION
  WHEN OTHERS THEN
     ROLLBACK;
     ls_msgerr := SQLERRM;
     ld_indest := 0;
     insert into jaqz926B
        (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
         jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
     values
        (ln_CodPro,ln_codage,null,null,
         null,null,ls_msgerr,sysdate);
     commit;
  end;
  END LOOP;
  delete "MaeCalendario"@Unibanca;
  commit;
  FOR c_DatCal IN c_AgeCal LOOP
  Begin
     ln_codcal := c_DatCal.calcod;
     ls_descal := c_DatCal.calnom;
     insert into "MaeCalendario"@Unibanca ("nIdCalendario","vDescripcion")
     values 
        (ln_codcal,ls_descal);
     COMMIT;
     --ln_contador := ln_contador + 1;
  EXCEPTION
  WHEN OTHERS THEN
     ROLLBACK;
     ls_msgerr := SQLERRM;
     ld_indest := 0;
     insert into jaqz926B
        (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
         jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
     values
        (ln_CodPro,null,null,null,
         ln_codcal,substr(ls_descal,1,50),ls_msgerr,sysdate);
     commit;
  end;
  END LOOP;
  update jaqz926A
     set jaqz926Afecfin = sysdate
   where jaqz926Acodpro = ln_CodPro;
  commit;
  ls_horafin := to_char(sysdate, 'HH24:Mi:ss');
  ld_fecfin  := trunc(sysdate);
  ld_fecact  := sysdate;
  INSERT INTO "LogControlPrograma"@Unibanca
     ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
      "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo",
      "nIdInstitucion","vHoraInicio","vHoraFinal","vTiempoProceso",
      "vTipoEjecucion")
  VALUES
     (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
      ld_fecact,'CARGA_TABLAS','AGEN','LOAD',
      20,ls_horaini,ls_horafin,null,'A');     
  commit;
  UPDATE "LogControlProgramaResumen"@Unibanca
     SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,
         "nEstado" = ld_indest
   wHERE "vIdGrupo" = 'CARGA_TABLAS'
     AND "vIdPrograma" = 'AGEN'
     AND "vIdSubModulo" = 'LOAD'
     AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
     AND "nEstado" IN (-1, 0);
  commit;
EXCEPTION
WHEN OTHERS THEN
  ls_msgerr := SQLERRM;
  insert into jaqz926B
     (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
      jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
  values
     (ln_CodPro,null,null,null,null,null,ls_msgerr,sysdate);
  commit;
  ls_horafin := to_char(sysdate, 'HH24:Mi:ss');
  ld_fecact  := sysdate;
  INSERT INTO "LogControlPrograma"@Unibanca
     ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
      "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
      "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
  VALUES
     (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
      ld_fecact,'CARGA_TABLAS','AGEN','LOAD',20,
      ls_horaini,ls_horafin,null,'A');
  commit;
  UPDATE "LogControlProgramaResumen"@Unibanca
     SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
   WHERE "vIdGrupo" = 'CARGA_TABLAS'
     AND "vIdPrograma" = 'AGEN'
     AND "vIdSubModulo" = 'LOAD'
     AND "vFechaProceso" = ld_fecpro
     AND "nEstado" IN (-1, 0);
  commit;
END SP_SIMP_CARGA_AGENCIA;

PROCEDURE SP_SIMP_CARGA_ATM (FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_ATM
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de ATMS
-- Estado                     : Activo
-- Fecha Modificación         : 25/10/2023
-- Autor de Modificación      : Frank Pinto Carpio
-- Descripcion Modificacion   : Actualizacion de datos Atms
-- *****************************************************************
/*CURSOR c_AtmCli IS
   SELECT 20 AS cidinst,a.ccodatm,a.cnomatm,a.cdesubi,a.ncodage,a.ccodtip
     FROM jaql823b a; */
     
-----------------------------Datos ATMs--------------------------------- 
--fpinto 23/10/2023 se añade cursor para obtencion de datos de atms
  CURSOR Datos_ATMs is
         select z.z0e475cod, z.z0e475dsc, z.z0e475ubi, z.z0e475suc, z.z0e475tip,
         j.jaqz233lon, j.jaqz233lat, sysdate
          from z0e475 z
          left join jaqz233 j on z.z0e475cod=j.jaqz233atm;
-----------------------------DATOS ATMs---------------------------------
     
ln_CodPro number;
ls_msgerr varchar2(4000);
ls_codatm varchar(20);
ls_codatm2 number;
ln_contador2 number;
ld_fecpro varchar(10);
ln_contador number(10);
ls_horaini varchar(8);
ls_horafin varchar(8);
ld_fecini varchar(10);
ld_fecfin date;
ld_indest number;
  
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro
     FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO;
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr   := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" = ld_fecpro
      AND "vIdPrograma" = 'ATM'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_ATM','SYSADM',sysdate,sysdate);
   commit;
   /*
   delete "MaeATMs"@Unibanca;
   commit;
   FOR c_DatCli IN c_AtmCli LOOP
      ls_codatm := c_DatCli.ccodatm;
      begin
         ln_contador := ln_contador+1;
         insert into "MaeATMs"@Unibanca
            ("nIdInstitucion","nIdATM","vDescripcion","vDireccion",
             "nIdAgencia","vTipoATM")
         values
            (c_DatCli.cidinst,c_DatCli.ccodatm,c_Datcli.Cnomatm,c_DatCli.cdesubi,
             c_Datcli.ncodage,c_Datcli.ccodtip);
         COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
          insert into jaqz926B
             (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
              jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
          values
             (ln_CodPro,ls_codatm,null,null,null,null,ls_msgerr,sysdate);
          commit;
      end;    
   END LOOP;
   */
-------------ACTUALIZA DATOS ATMS---------------------------fpinto 25/10/2023
   ln_contador2 := 0;
   For upd in Datos_ATMs Loop
     ls_codatm2 := upd.z0e475cod;
     begin
         update "MaeATMs"@Unibanca 
              set "vDescripcion" = upd.z0e475dsc,
              "vDireccion"= upd.z0e475ubi,
              "nIdAgencia" = upd.z0e475suc,
              "nLongitud" = upd.jaqz233lon,
              "nLatitud" = upd.jaqz233lat, 
              "dFechaModificacion" = upd.sysdate,
              "vUsuarioModificacion" = 'BANTOTAL'
              where "nIdATM" = ls_codatm2;
          Commit;
          ln_contador2 := ln_contador2 + 1;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         commit;
      end;
   End Loop;
-------------FIN ACTUALIZA DATOS ATM---------------------------   
   update jaqz926A set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       'CARGA_TABLAS','ATM','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
       commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'ATM'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
          ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
          'CARGA_TABLAS','ATM','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'ATM'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;
END SP_SIMP_CARGA_ATM;

PROCEDURE SP_SIMP_CARGA_AUTO_BEVERTEC(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_AUTO_BEVERTEC
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga del log
-- Estado                     : Activo
-- Fecha Modificación         : 09/06/2020
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Cambio de campo IDTERM por ACC_TERMID, se coloca null a track2
-- Fecha Modificación         : 23/04/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Cambio de campo TxnAmt por actualización del Swicth
-- *****************************************************************
CURSOR c_MovAut IS

   SELECT LTRIM(Status) as Status,LPAD(LTRIM(MsgType),4,'0') as MsgType,
          LTRIM(MsgNo) as MsgNo,LTRIM(Pan) as Pan,LPAD(LTRIM(PrCode),6,'0') as PrCode,
          LTRIM(Cur_Tran) as Cur_Tran,replace(trim(to_char(TxnAmt,'99999999999.99')),'.','') as TxnAmt,
          LTRIM(Cur_Stl) as Cur_Stl,LTRIM(StlAmt) as StlAmt,TO_CHAR(TransDate,'YYYY-MM-DD') as TransDate,
          TO_Char(TO_DATE(LPAD(LTRIM(TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS') as TransTime,
          LTRIM(CnvRate_Stl) as CnvRate_Stl,LPAD(LTRIM(Trace), 6, '0') as Trace,
          LTRIM(Sys_Trace) as Sys_Trace,LTRIM(Auth_Id) as Auth_Id,
          TO_CHAR(AbmDate, 'YYYY-MM-DD') as AbmDate,
          TO_Char(TO_DATE(LPAD(LTRIM(AbmTime),6,'0'),'HH24MISS'),'HH24:MI:SS') as AbmTime,
          LTRIM(ExpDate) as ExpDate,ConvDate,TO_CHAR(CapDate,'YYYY-MM-DD') as CapDate,
          DateIn as DateIn,TO_Char(TO_DATE(LPAD(LTRIM(TimeIn),6,'0'),'HH24MISS'),'HH24:MI:SS') as TimeIn,
          TO_CHAR(DateOut,'YYYY-MM-DD') as DateOut,
          TO_Char(TO_DATE(LPAD(LTRIM(TimeOut),6,'0'),'HH24MISS'),'HH24:MI:SS') as TimeOut,
          LTRIM(Merchant) as Merchant,LTRIM(Pos_Entry_Mode) as Pos_Entry_Mode,
          LTRIM(Pos_Cond_Code) as Pos_Cond_Code,LTRIM(AcqInst) as AcqInst,
          LTRIM(IssInst) as IssInst,--LTRIM(Track2) as Track2,LTRIM(Track3) as Track3,
          LTRIM(RefNum) as RefNum,LTRIM(RespCode) as RespCode,LTRIM(ACC_TERMID) as TermId,
          LTRIM(AcceptorName) as AcceptorName,LTRIM(OrgMsg) as OrgMsg,LTRIM(OTrace) as OTrace,
          TO_CHAR(ODate, 'YYYY-MM-DD') as ODate,LTRIM(OTime) as OTime,LTRIM(OAcqInst) as OAcqInst,
          LTRIM(OIssInst) as OIssInst,LTRIM(Rep_TxnAmt) as Rep_TxnAmt,LTRIM(Rep_StlAmt) as Rep_StlAmt,
          LTRIM(ReqInst) as ReqInst,LTRIM(AcctId1) as AcctId1,LTRIM(AcctId2) as AcctId2,
          NULL as vCardCategory,0 as nMonedaCobroThb,0 as nComisionThb,0 as nRolTransaccion,
          0 as nIdCanal,NULL as vIdBIN,NULL as vIdProceso,0 as nConciliaSwDmpLog,
          0 as nConciliaLiberadas,0 as nConciliaLogContable,2 as nOrigenArchivo,
          NULL as vOriginalData,MISC1 as nSettAmountTransactionFee
     FROM ITXN@TXNSWT
    WHERE datein = FECHA_PROCESO;
ln_CodPro number;
ls_msgerr varchar2(4000);
ls_numcta varchar(20);
ls_procod varchar(20);
ls_tracur varchar(20);
ls_moncur varchar(20);
ld_fecreg date;
ld_fecpro varchar(10);
ln_contador number(10);
ls_horaini varchar(8);
ls_horafin varchar(8);
ld_fecini varchar(10);
ld_fecfin date;
ld_indest number;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
   FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO; 
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd'); 
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'AUTB'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;     
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro,'SP_SIMP_CARGA_AUTO_BEVERTEC','SYSADM',sysdate,sysdate);
   commit;
   if (FECHA_PROCESO is null) then
      delete "MovLogAutorizaciones"@Unibanca WHERE "nOrigenArchivo" = 2;
   else
      delete "MovLogAutorizaciones"@Unibanca
       WHERE "dDateIn" = FECHA_PROCESO
         AND "nOrigenArchivo" = 2;
   end if;
   commit;
   FOR c_DatAut IN c_MovAut LOOP
   begin
      ls_numcta := c_DatAut.Pan;
      ls_procod := c_DatAut.PrCode;
      ls_tracur := c_DatAut.Cur_Tran;
      ls_moncur := c_DatAut.TxnAmt;
      ld_fecreg := TO_DATE(c_DatAut.DateIn);
      INSERT INTO "MovLogAutorizaciones"@Unibanca
         ("vStatus","vMessageType","vIndStoreForward","vAccountNumber",
          "vProcessingCode","nTransactionCurrency","nTransactionAmount",
          "nSettlementCurrency","nSettlementAmount","dTransmissionDate",
          "vTransmissionTime","nConversionRateSettlement","vTraceNumber",
          "nSysTrace","vAuthorizationCode","vLocalTransactionTime",
          "dLocalTransactionDate","vExpiryDate","dConversionDate","dCaptureDate",
          "dDateIn","vTimeIn","dDateOut","vTimeOut","vMerchantType",
          "vPosEntryMode","vPosConditionCode","vAcquiringInstitution",
          "vForwardingInstitution","vTrack2Data","vTrack3Data","vReferenceNumber",
          "nResponseCode","vCardAcceptorTermId","vCardAcceptorLocation",
          "vOriginalMessageType","vOriginalTraceNumber","dOriginalDate",
          "vOriginalTime","vOriginalAdquiringInst","vOriginalForwardingInst",
          "nReplaTransactionAmount","nReplaSettlementAmount","vRequestingInstitution",
          "vAccountIdentification1","vAccountIdentification2","vCardCategory",
          "nMonedaCobroThb","nComisionThb","nRolTransaccion","nIdCanal","vIdBIN",
          "vIdProceso","nConciliaSwDmpLog","nConciliaLiberadas","nConciliaLogContable",
          "nOrigenArchivo","vCustomerInformation","vPosAddInformation","vCardAcceptorId",
          "dSettlementDate","vTipoProducto","nIdCanalEmisor","vNumeroDocumento",
          "dFechaProceso","nSettAmountTransactionFee")
      values
         (c_DatAut.Status,c_DatAut.MsgType,c_DatAut.MsgNo,c_DatAut.Pan,
          c_DatAut.PrCode,c_DatAut.Cur_Tran,c_DatAut.TxnAmt,c_DatAut.Cur_Stl,
          c_DatAut.StlAmt,c_DatAut.TransDate,c_DatAut.TransTime,c_DatAut.CnvRate_Stl,
          c_DatAut.Trace,c_DatAut.Sys_Trace,c_DatAut.Auth_Id,c_DatAut.AbmTime,
          c_DatAut.AbmDate,c_DatAut.ExpDate,c_DatAut.ConvDate,c_DatAut.CapDate,
          ld_fecreg,c_DatAut.TimeIn,c_DatAut.DateOut,c_DatAut.TimeOut,
          c_DatAut.Merchant,c_DatAut.Pos_Entry_Mode,c_DatAut.Pos_Cond_Code,
          c_DatAut.AcqInst,c_DatAut.IssInst,NULL,NULL,--c_DatAut.Track2,c_DatAut.Track3,
          c_DatAut.RefNum,c_DatAut.RespCode,c_DatAut.TermId,c_DatAut.AcceptorName,
          c_DatAut.OrgMsg,c_DatAut.OTrace,c_DatAut.ODate,c_DatAut.OTime,
          c_DatAut.OAcqInst,c_DatAut.OIssInst,c_DatAut.Rep_TxnAmt,c_DatAut.Rep_StlAmt,
          c_DatAut.ReqInst,c_DatAut.AcctId1,c_DatAut.AcctId2,NULL,0,0,0,0,NULL,
          NULL,0,0,0,2,--c_DatAut.Org_Data,
          null,null,null,null,null,null,null,ld_fecpro,c_DatAut.nSettAmountTransactionFee);
      COMMIT;
      ln_contador := ln_contador+1;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
             jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
         values
            (ln_CodPro,ls_numcta,ls_procod,ls_tracur,ls_moncur,null,ls_msgerr,sysdate);
         commit;
      end;
   END LOOP;
   update "MovLogAutorizaciones"@Unibanca
      set "nTransactionAmount" = "nTransactionAmount" / 100    
    WHERE "dDateIn" = FECHA_PROCESO
      AND "nOrigenArchivo" = 2;
   commit;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion","vHoraInicio",
       "vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       'CARGA_TABLAS','AUTB','LOAD',20,ls_horaini,
       ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'AUTB'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
      commit;
      ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
          'CARGA_TABLAS','AUTB','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'AUTB'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;     
END SP_SIMP_CARGA_AUTO_BEVERTEC;

PROCEDURE SP_SIMP_CARGA_AUTO_NOVATRONIC(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_AUTO_NOVATRONIC
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga del log
-- Estado                     : Activo
-- Fecha Modificación         : 19/06/2020
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : SE comenta hasta que en el SIMP se procese
-- *****************************************************************
ls_fecpro varchar(8);
/*CURSOR c_MovAut IS
   select LTRIM(c_DatAut.Status) as vStatus,LPAD(LTRIM(c_DatAut.MsgType),4,'0') as vMessageType,
          LTRIM(c_DatAut.Who_Rsp) as vIndStoreForward,LTRIM(c_DatAut.Pan) as vAccountNumber,
          LPAD(LTRIM(c_DatAut.PrCode), 6, '0') as vProcessingCode,
          LTRIM(c_DatAut.Cur_Code_Txn) as nTransactionCurrency,
          LTRIM(c_DatAut.Amount_Txn) as nTransactionAmount,
          case when (LTRIM(c_DatAut.Cur_Code_Sttl)) = '***' then
             null
          else
             LTRIM(c_DatAut.Cur_Code_Sttl)
          end as nSettlementCurrency,
          case when LTRIM(c_DatAut.Amount_Sttl) = '************' then
             null
          else
             LTRIM(c_DatAut.Amount_Sttl)
          end as nSettlementAmount,
          --to_date(c_DatAut.TransDate, 'YYYY-MM-DD')  as dTransmissionDate, --8 
          to_date(c_DatAut.TransDate,'YYYYMMDD') as dTransmissionDate, --8 
          TO_Char(TO_DATE(LPAD(LTRIM(c_DatAut.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS') as vTransmissionTime,
          --LTRIM(c_DatAut.ConvRate_Sttl) as nConversionRateSettlement,
          null as nConversionRateSettlement,LPAD(LTRIM(c_DatAut.Trace),6,'0') as vTraceNumber,
          NULL as nSysTrace,LTRIM(c_DatAut.Auth) as vAuthorizationCode,
          null as vLocalTransactionTime,to_date(c_DatAut.Date_Local,'YYYYMMDD') as dLocalTransactionDate, --7       
          LTRIM(c_DatAut.Date_Exp) as vExpiryDate,null as dConversionDate,
          --TO_CHAR(c_DatAut.Date_Capture, 'YYYY-MM-DD')   as dCaptureDate,
          null as dCaptureDate,TO_DATE(c_DatAut.DateIn,'YYYY-MM-DD') as dDateIn,
          NULL as vTimeIn,NULL as dDateOut,NULL as vTimeOut,LTRIM(c_DatAut.Merchant) as vMerchantType,
          LTRIM(c_DatAut.Pos_Entry_Mode) as vPosEntryMode,
          LTRIM(c_DatAut.Point_Cond_Code) as vPosConditionCode,
          LTRIM(c_DatAut.Acq_Inst) as vAcquiringInstitution,
          LTRIM(c_DatAut.Forw_Inst) as vForwardingInstitution,
          LTRIM(c_DatAut.Track2) as vTrack2Data,LTRIM(c_DatAut.Track3) as vTrack3Data,
          LTRIM(c_DatAut.RefNum) as vReferenceNumber,
          case when c_DatAut.Resp_code = '***' then
             null
          else
             c_DatAut.Resp_code
          end as nResponseCode,
          LTRIM(c_DatAut.Term_Id) as vCardAcceptorTermId,
          LTRIM(c_DatAut.Acceptor) as vCardAcceptorLocation,
          NULL as vOriginalMessageType,NULL as vOriginalTraceNumber,
          NULL as dOriginalDate,NULL as vOriginalTime,NULL as vOriginalAdquiringInst,
          NULL as vOriginalForwardingInst,
          case when LTRIM(c_DatAut.Rep_Txn_Amt) = '************' then
             null
          else
             LTRIM(c_DatAut.Rep_Txn_Amt)
          end as nReplaTransactionAmount,
          case when LTRIM(c_DatAut.Rep_Sttl_Amt) = '************' then
             null
          else
             LTRIM(c_DatAut.Rep_Sttl_Amt)
          end as nReplaSettlementAmount,
          LTRIM(c_DatAut.Req_Inst) as vRequestingInstitution,
          LTRIM(c_DatAut.Acct_1) as vAccountIdentification1,
          LTRIM(c_DatAut.Acct_2) as vAccountIdentification2,
          c_DatAut.Org_Drv as vCardCategory,0 as nMonedaCobroThb,
          0 as nComisionThb,0 as nRolTransaccion,0 as nIdCanal,
          NULL as vIdBIN,NULL as vIdProceso,0 as nConciliaSwDmpLog,
          0 as nConciliaLiberadas,0 as nConciliaLogContable,1 as nOrigenArchivo,
          --c_DatAut.Org_Data  as vOriginalData -- No existe Campo en SQL
          null as vCustomerInformation,null as vPosAddInformation,
          null as vCardAcceptorId,null as dSettlementDate, ---1
          null as vTipoProducto,null as nIdCanalEmisor, null as vNumeroDocumento,
          null as nIdSecuencia
     from (SELECT Status,MsgType,Who_Rsp,Pan,PrCode,Cur_Code_Txn,Amount_Txn,
                  Cur_Code_Sttl,Amount_Sttl,TransDate,TransTime,ConvRate_Sttl,
                  Trace,NULL,Auth,Date_Local,Time_Local,Date_Exp,Date_Conv,
                  Date_Capture,DateIn,NULL as TimeIn,NULL as DateOut,NULL as TimeOut,
                  Merchant,Pos_Entry_Mode,Point_Cond_Code,Acq_Inst,Forw_Inst,
                  Track2,Track3,RefNum,Resp_code,Term_Id,Acceptor,NULL as OrgMsg,
                  NULL as OTrace,NULL as ODate,NULL as OTime,NULL as OAcqInst,
                  NULL as OIssInst,Rep_Txn_Amt,Rep_Sttl_Amt,Req_Inst,Acct_1,
                  Acct_2,Org_Drv,0 as nRolTransaccion,0 as nIdCanal,NULL as vIdBIN,
                  NULL as vIdProceso,0 as nConciliaSwDmpLog,0 as nConciliaLiberadas,
                  0 as nConciliaLogContable,1 as,Org_Data
             FROM txnlog@NOVA
            WHERE TransDate = ls_fecpro) c_DatAut; */ --WCRW 19/06/2020
ln_CodPro number;
ls_msgerr varchar2(4000);
ls_numcta varchar(20);
ls_procod varchar(20);
ls_tracur varchar(20);
ls_moncur varchar(20);
ls_fectra varchar2(8);
ld_fecpro varchar(10);
ln_contador number(10);
ls_horaini varchar(8);
ls_horafin varchar(8);
ld_fecini varchar(10);
ld_fecfin date;
ld_indest number;
ld_fecact date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
     FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO; 
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd'); 
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'AUTN'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;     
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   ls_fecpro := TO_CHAR(FECHA_PROCESO, 'YYYYMMDD');
   insert into jaqz926A
   values
      (ln_CodPro,'SP_SIMP_CARGA_AUTO_NOVATRONIC','SYSADM',sysdate,sysdate);
   commit;
   if (FECHA_PROCESO is null) then
      delete "MovLogAutorizaciones"@Unibanca;
   else
      delete "MovLogAutorizaciones"@Unibanca
       WHERE "dTransmissionDate" = FECHA_PROCESO
         AND "nOrigenArchivo" = 1;
   end if;
   commit;
   /*FOR c_DatCli IN c_MovAut LOOP
   begin
      --ls_numcta := c_DatCli.vAccountNumber;
      ls_procod := c_DatCli.vProcessingCode;
      ls_tracur := c_DatCli.nTransactionCurrency;
      ls_moncur := c_DatCli.nTransactionAmount;
      ls_numcta := case when instr(c_DatCli.vTrack2Data, '=') > 0 then
                      substr(c_DatCli.vTrack2Data,0,instr(c_DatCli.vTrack2Data,'=') - 1)
                   else
                      c_DatCli.vAccountNumber
                   end;
      begin
         --ld_fectra := to_char(to_date(c_DatCli.dTransmissionDate,'dd/mm/yy'),'yyyymmdd');
         ls_fectra := to_char(c_DatCli.dTransmissionDate,'yyyymmdd');
      EXCEPTION
      WHEN OTHERS THEN
         ls_fectra := null;
      end;
      insert into "MovLogAutorizaciones"@Unibanca
         ("vStatus","vMessageType","vIndStoreForward","vAccountNumber","vProcessingCode",
          "nTransactionCurrency","nTransactionAmount","nSettlementCurrency","nSettlementAmount",
          "dTransmissionDate","vTransmissionTime","nConversionRateSettlement","vTraceNumber",
          "nSysTrace","vAuthorizationCode","vLocalTransactionTime","dLocalTransactionDate",
          "vExpiryDate","dConversionDate","dCaptureDate","dDateIn","vTimeIn","dDateOut",
          "vTimeOut","vMerchantType","vPosEntryMode","vPosConditionCode","vAcquiringInstitution",
          "vForwardingInstitution","vTrack2Data","vTrack3Data","vReferenceNumber","nResponseCode",
          "vCardAcceptorTermId","vCardAcceptorLocation","vOriginalMessageType","vOriginalTraceNumber",
          "dOriginalDate","vOriginalTime","vOriginalAdquiringInst","vOriginalForwardingInst",
          "nReplaTransactionAmount","nReplaSettlementAmount","vRequestingInstitution",
          "vAccountIdentification1","vAccountIdentification2","vCardCategory","nMonedaCobroThb",
          "nComisionThb","nRolTransaccion","nIdCanal","vIdBIN","vIdProceso","nConciliaSwDmpLog",
          "nConciliaLiberadas","nConciliaLogContable","nOrigenArchivo","vCustomerInformation",
          "vPosAddInformation","vCardAcceptorId","dSettlementDate","vTipoProducto",
          "nIdCanalEmisor","vNumeroDocumento","dFechaProceso")
      values
         (c_DatCli.vStatus,c_DatCli.vMessageType,c_DatCli.vIndStoreForward,ls_numcta,c_DatCli.vProcessingCode,
          c_DatCli.nTransactionCurrency,c_DatCli.nTransactionAmount,c_DatCli.nSettlementCurrency,
          c_DatCli.nSettlementAmount,ls_fectra,c_DatCli.vTransmissionTime,c_DatCli.nConversionRateSettlement,
          c_DatCli.vTraceNumber,c_DatCli.nSysTrace,c_DatCli.vAuthorizationCode,c_DatCli.vLocalTransactionTime,
          c_DatCli.dLocalTransactionDate,c_DatCli.vExpiryDate,c_DatCli.dConversionDate,c_DatCli.dCaptureDate,
          c_DatCli.dDateIn,c_DatCli.vTimeIn,c_DatCli.dDateOut,c_DatCli.vTimeOut,c_DatCli.vMerchantType,
          c_DatCli.vPosEntryMode,c_DatCli.vPosConditionCode,c_DatCli.vAcquiringInstitution,
          c_DatCli.vForwardingInstitution,c_DatCli.vTrack2Data,c_DatCli.vTrack3Data,c_DatCli.vReferenceNumber,
          c_DatCli.nResponseCode,c_DatCli.vCardAcceptorTermId,c_DatCli.vCardAcceptorLocation,c_DatCli.vOriginalMessageType,
          c_DatCli.vOriginalTraceNumber,c_DatCli.dOriginalDate,c_DatCli.vOriginalTime,c_DatCli.vOriginalAdquiringInst,
          c_DatCli.vOriginalForwardingInst,c_DatCli.nReplaTransactionAmount,c_DatCli.nReplaSettlementAmount,
          c_DatCli.vRequestingInstitution,c_DatCli.vAccountIdentification1,c_DatCli.vAccountIdentification2,
          c_DatCli.vCardCategory,c_DatCli.nMonedaCobroThb,c_DatCli.nComisionThb,c_DatCli.nRolTransaccion,
          c_DatCli.nIdCanal,c_DatCli.vIdBIN,c_DatCli.vIdProceso,c_DatCli.nConciliaSwDmpLog,c_DatCli.nConciliaLiberadas,
          c_DatCli.nConciliaLogContable,c_DatCli.nOrigenArchivo,c_DatCli.vCustomerInformation,c_DatCli.vPosAddInformation,
          c_DatCli.vCardAcceptorId,c_DatCli.dSettlementDate,c_DatCli.vTipoProducto,c_DatCli.nIdCanalEmisor,
          c_DatCli.vNumeroDocumento,ld_fecpro);
      COMMIT;
      ln_contador := ln_contador+1;
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      ld_indest :=0;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro,ls_numcta,ls_procod,ls_tracur,ls_moncur,null,ls_msgerr,sysdate);
      commit;
   end;
   END LOOP;*/ --WCRW 19/06/2020
   update "MovLogAutorizaciones"@Unibanca
      set "nTransactionAmount" = "nTransactionAmount" / 100    
    WHERE "dTransmissionDate" = FECHA_PROCESO
      AND "nOrigenArchivo" = 1;
   commit;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','AUTN','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'AUTN'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
      commit;
      ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      ld_fecact := sysdate;     
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
          ld_fecact,'CARGA_TABLAS','AUTN','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'AUTN'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;     
END SP_SIMP_CARGA_AUTO_NOVATRONIC;

PROCEDURE SP_SIMP_CARGA_CLIENTES(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_CLIENTES
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de clientes
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
CURSOR c_CliCli IS
   SELECT a.ntipdoc,a.cnumdoc,LTRIM(RTRIM(a.cprinom)) || ' ' || LTRIM(RTRIM(a.csegnom)) AS nombres,
          LTRIM(RTRIM(a.capepat)) || ' ' || LTRIM(RTRIM(a.capemat)) AS apellidos,NULL AS ctipcli,
          a.ncodpai,a.ccodsex,a.cestciv,a.dfecnac,b.ctelfij,b.ctelcel,c.cmeicli,d.cdircli,
          TO_CHAR(a.ncodpai) || TO_CHAR(a.ntipdoc) || a.cnumdoc AS idcliente,null as ClasePersona,
          null as ClaseConyuge,null AS ccodubi,null as dfechacontrato
     FROM jaql823c a
    inner join jaql823e b
       on a.ntipdoc = b.ntipdoc
      AND a.cnumdoc = b.cnumdoc
      AND a.ncodpai = b.ncodpai
    inner join jaql823f c
       on a.ntipdoc = c.ntipdoc
      AND a.cnumdoc = c.cnumdoc
      AND a.ncodpai = c.ncodpai
    left join jaql823g d
       ON a.ntipdoc = d.ntipdoc
      AND a.cnumdoc = d.cnumdoc
      AND a.ncodpai = d.ncodpai
      AND d.ntipviv = 1
    UNION all
   SELECT a.ntipdoc,a.cnumdoc,a.crazsoc AS nombres,NULL AS apellidos,NULL AS ctipcli,      a.ncodpai,
          NULL AS ccodsex,NULL AS cestciv,null AS dfecnac,b.ctelfij,b.ctelcel,c.cmeicli,
          d.cdircli,TO_CHAR(a.ncodpai) || TO_CHAR(a.ntipdoc) || a.cnumdoc AS idcliente,
          null as ClasePersona,null as ClaseConyuge,null AS ccodubi,
          case when a.dfeccon = '1/01/0001' then
             null
          else
             a.dfeccon
          end as dfechacontrato
     FROM jaql823d a
   inner join jaql823e b
       on a.ntipdoc = b.ntipdoc
      AND a.cnumdoc = b.cnumdoc
      AND a.ncodpai = b.ncodpai
   inner join jaql823f c
       on a.ntipdoc = c.ntipdoc
      AND a.cnumdoc = c.cnumdoc
      AND a.ncodpai = c.ncodpai
   left join jaql823g d
       ON a.ntipdoc = d.ntipdoc
      AND a.cnumdoc = d.cnumdoc
      AND a.ncodpai = d.ncodpai
      AND d.ntipviv = 3;
   ln_CodPro  number;
   ln_CodPai  number;
   ln_TipDoc  number;
   ls_NumDoc  varchar2(12);
   ls_msgerr  varchar2(4000);
   ls_nomcli  varchar(70);
   ls_feccon  date;
   ls_fecnac  date;
   ls_tel1    varchar(20);
   ls_tel2    varchar(20);
   ls_dircli  varchar(140);
   ls_mailcli varchar(65);
   ls_apecli  varchar2(40);
   ld_fecpro varchar(10);
   ln_contador number(10);
   ls_horaini varchar(8);
   ls_horafin varchar(8);
   ld_fecini varchar(10);
   ld_fecfin date;
   ld_indest number;
   ld_fecact date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro
       FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO; 
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'CLTE'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;     
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_CLIENTES', 'SYSADM', sysdate, sysdate);
   commit;
   delete "MaeClientes"@Unibanca;
   commit;
   FOR c_DatCli IN c_CliCli LOOP
      ln_CodPai := c_DatCli.ncodpai;
      ln_TipDoc := c_DatCli.ntipdoc;
      ls_NumDoc := trim(c_DatCli.cnumdoc);
      if length(c_DatCli.nombres) > 70 then
         ls_nomcli := SUBSTR(trim(c_DatCli.nombres), 70);
      else
         ls_nomcli := trim(c_DatCli.nombres);
      end if;    
      ls_feccon := to_date(c_Datcli.dfechacontrato);
      ls_fecnac := to_date(c_Datcli.dfecnac);    
      if length(c_DatCli.ctelfij) > 20 then
         ls_tel1 := SUBSTR(trim(c_DatCli.ctelfij), 20);
      else
         ls_tel1 := trim(c_DatCli.ctelfij);
      end if;
      if length(c_DatCli.ctelcel) > 20 then
         ls_tel2 := SUBSTR(trim(c_DatCli.ctelcel), 20);
      else
         ls_tel2 := trim(c_DatCli.ctelcel);
      end if;
      if length(c_DatCli.cdircli) > 140 then
         ls_dircli := SUBSTR(trim(c_DatCli.cdircli), 140);
      else
         ls_dircli := trim(c_DatCli.cdircli);
      end if;
      if length(c_DatCli.apellidos) > 40 then
         ls_apecli := SUBSTR(trim(c_DatCli.apellidos), 40);
      else
         ls_apecli := trim(c_DatCli.apellidos);
      end if;
      if length(c_DatCli.cmeicli) > 65 then
         ls_mailcli := SUBSTR(trim(c_DatCli.cmeicli), 65);
      else
         ls_mailcli := trim(c_DatCli.cmeicli);
      end if;
      begin
         insert into "MaeClientes"@Unibanca
            ("vTipoDocumento","vNumeroDocumento","vNombres","vApellidos","vTipoCliente",
             "nCodigoPais","cSexo","vEstadoCivil","dFechaNacimiento","vTelefono1",
             "vTelefono2","vEmail","vDireccion","vIdCliente","vClasePersona","vCodigoConyuge",
             "vCodigoUbigeo","dFechaContrato")
         values
            (c_DatCli.ntipdoc,c_DatCli.cnumdoc,ls_nomcli,ls_apecli,c_DatCli.ctipcli,
             c_DatCli.ncodpai,c_DatCli.ccodsex,c_Datcli.cestciv,ls_fecnac,ls_tel1,
             ls_tel2,ls_mailcli,ls_dircli,c_Datcli.idcliente,c_Datcli.ClasePersona,c_Datcli.ClaseConyuge,
             c_Datcli.ccodubi,ls_feccon);
         COMMIT;
         ln_contador := ln_contador+1;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
             jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)          
         values
            (ln_CodPro,ln_CodPai,ln_TipDoc,ls_NumDoc,null,null,ls_msgerr,sysdate);
         commit;
      end;
   END LOOP;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','CLTE','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'CLTE'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
      commit;
      ls_horafin := to_char(sysdate,'HH24:Mi:ss');
      ld_fecact := sysdate;
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
          ld_fecact,'CARGA_TABLAS','CLTE','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'CLTE'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;     
END SP_SIMP_CARGA_CLIENTES;

PROCEDURE SP_SIMP_CARGA_CUENTAS(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_CUENTAS
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de cuentas
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
CURSOR c_CueCli IS
  SELECT a.cnumtar as vNumeroTarjeta,a.ncodcta as vNumeroCuenta, -- Se agrego ncodcta
         a.ncodage as nIdAgencia,a.ccodest as vEstadoCuenta,
         case when a.dfecaut = '1/01/0001' then
            null
         else
            a.dfecaut
         end as dFechaAutorizacion,
         case when a.dfecmod = '1/01/0001' then
            null
         else
            a.dfecmod
         end as dFechaActualizacion,
         null as vIdCliente,a.ncodcta as vCodigoCuenta,null as vTipoCuenta,
         a.ncodmod as vCodigoProducto,a.ncodmon as vTipoMoneda,null as vModalidadDeposito,
         a.ncodsct as nCodigoSubCuenta,a.ncodpap as nCodigoPapel,a.ntipope as nTipoOperacion,
         a.ncodope as nCodigoOperacion,FECHA_PROCESO as dfechaproceso
    FROM jaql823h a
   where dfecmod >= FECHA_PROCESO; -- coalesce(FECHA_PROCESO, dfecmod);
   ln_CodPro number;
   ls_msgerr varchar2(4000);
   ls_numtar varchar2(20);
   ls_codcta varchar(15);
   ld_fecpro varchar(10);
   ln_contador number(10);
   ls_horaini varchar(8);
   ls_horafin varchar(8);
   ld_fecini varchar(10);
   ld_fecfin date;
   ld_indest number;
   ld_fecact date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
     FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO; 
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd'); 
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion"   = ld_fecini 
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'CTAS'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_CUENTAS', 'SYSADM', sysdate, sysdate);
   commit;
   delete "MaeCuentasTmp"@Unibanca;
   commit;
   FOR c_DatCli IN c_CueCli LOOP
      begin
         ls_numtar := c_DatCli.vNumeroTarjeta;
         ls_codcta := c_DatCli.vCodigoCuenta;
         insert into "MaeCuentasTmp"@Unibanca
            ("vNumeroTarjeta","vNumeroCuenta","nIdAgencia","vEstadoCuenta","dFechaAutorizacion",
             "dFechaActualizacion","vIdCliente","vCodigoCuenta","vTipoCuenta","vCodigoProducto",
             "vTipoMoneda","vModalidadDeposito","nCodigoSubCuenta","nCodigoPapel","nTipoOperacion",
             "nCodigoOperacion","dFechaProceso")
         values
            (c_DatCli.vNumeroTarjeta,c_DatCli.vNumeroCuenta,c_DatCli.nIdAgencia,c_DatCli.vEstadoCuenta,
             c_DatCli.dFechaAutorizacion,c_DatCli.dFechaActualizacion,c_DatCli.vIdCliente,
             c_DatCli.vCodigoCuenta,c_DatCli.vTipoCuenta,c_DatCli.vCodigoProducto,c_DatCli.vTipoMoneda,
             c_DatCli.vModalidadDeposito,c_DatCli.nCodigoSubCuenta,c_DatCli.nCodigoPapel,
             c_DatCli.nTipoOperacion,c_DatCli.nCodigoOperacion,c_DatCli.dfechaproceso);
         COMMIT;
         ln_contador := ln_contador+1;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
             jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
         values
            (ln_CodPro,ls_numtar,ls_codcta,null,null,null,ls_msgerr,sysdate);
         commit;
      end;
   END LOOP;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion","dFechaAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion","vHoraInicio","vHoraFinal",
       "vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',ld_fecact,
       'CARGA_TABLAS','CTAS','LOAD',20,ls_horaini,ls_horafin,
       null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'CTAS'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
      commit;
      ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      ld_fecact := sysdate;     
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion","dFechaAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion","vHoraInicio","vHoraFinal",
          "vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',ld_fecact,
          'CARGA_TABLAS','CTAS','LOAD',20,ls_horaini,ls_horafin,
          null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'CTAS'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;     
END SP_SIMP_CARGA_CUENTAS;

PROCEDURE SP_SIMP_CARGA_TARJETAS(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_TARJETAS
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de Tarjetas
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
CURSOR c_TarCli IS
   SELECT a.cnumtar as vNumeroTarjeta,a.ntipdoc as vTipoDocumento,a.cnumdoc as vNumeroDocumento,
         SUBSTR(a.cnumtar, 1, 6) AS vIdBIN, /* BIN de emisor*/ a.ctiptar as vTipoTarjeta,
         a.ncodage as nIdAgencia,a.ncodest as vEstadoTarjeta,a.cestcod as vEstado,
         case when a.dfecalt = '1/01/0001' then
            null
         else
            a.dfecalt
         end as dFechaActivacion,
         case when a.dfecmod = '1/01/0001' then
            null
         else
            a.dfecmod
         end as dFechaActualizacion,
         --a.dfecmod as dFechaActualizacion,
         null as dFechaBloqueoUba,null as dTipoBloqueoUba,
         TO_CHAR(a.ncodpai) || TO_CHAR(a.ntipdoc) || a.cnumdoc AS vIdCliente,
         a.ncodpai as nCodigoPais,
         case when EXTRACT(YEAR FROM a.dfecven) < 1900 then
            add_months(a.dfecven, (2000 * 12))
         else
            a.dfecven
         end as dFechaVencimiento,
         null as vFranquicia,null as vCodigoAsesor,null as vCategoria,null as nIdPersona,
         DECODE(a.dfecalt, '31/12/2014', 'C', 'B') AS cGrabacionTarjeta,
         FECHA_PROCESO as dfechaproceso
    FROM jaql823i a
   where dfecmod >= FECHA_PROCESO -- coalesce(FECHA_PROCESO, dfecmod)
     and trim(cnumdoc) is not null;
   ln_CodPro number;
   ls_msgerr varchar2(4000);
   ln_paicli number;
   ln_tipdoc number;
   ls_numdoc varchar(12);
   ls_numtar varchar(20);
   ld_fecpro varchar(10);
   ln_contador number(10);
   ls_horaini varchar(8);
   ls_horafin varchar(8);
   ld_fecini varchar(10);
   ld_fecfin date;
   ld_indest number;
   ld_fecact date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
     FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_fecpro := FECHA_PROCESO;
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr :=  'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'TAR'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;
   select coalesce(max(jaqz926Acodpro),0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_TARJETAS', 'SYSADM', sysdate, sysdate);
   commit;
   delete "MaeTarjetasTmp"@Unibanca;
   commit;
   FOR c_DatCli IN c_TarCli LOOP
      Begin
         ln_paicli := c_DatCli.nCodigoPais;
         ln_tipdoc := c_DatCli.vTipoDocumento;
         ls_numdoc := c_DatCli.vNumeroDocumento;
         ls_numtar := c_DatCli.vNumeroTarjeta;
         insert into "MaeTarjetasTmp"@Unibanca
            ("vNumeroTarjeta","vTipoDocumento","vNumeroDocumento","vIdBIN","vTipoTarjeta",
             "nIdAgencia","vEstadoTarjeta","vEstado","dFechaActivacion","dFechaActualizacion",
             "dFechaBloqueoUBA","vTipoBloqueoUBA","vIdCliente","nCodigoPais","dFechaVencimiento",
             "vFranquicia","vCodigoAsesor","vCategoria","nIdPersona","cGrabacionTarjeta",
             "dFechaProceso")
         values
            (c_DatCli.vNumeroTarjeta,c_DatCli.vTipoDocumento,c_DatCli.vNumeroDocumento,c_DatCli.vIdBIN,
             c_DatCli.vTipoTarjeta,c_DatCli.nIdAgencia,c_DatCli.vEstadoTarjeta,c_DatCli.vEstado,
             c_DatCli.dFechaActivacion,c_DatCli.dFechaActualizacion,c_DatCli.dFechaBloqueoUba,
             c_DatCli.dTipoBloqueoUba,c_DatCli.vIdCliente,c_DatCli.nCodigoPais,c_DatCli.dFechaVencimiento,
             c_DatCli.vFranquicia,c_DatCli.vCodigoAsesor,c_DatCli.vCategoria,c_DatCli.nIdPersona,
             c_DatCli.cGrabacionTarjeta,c_DatCli.dfechaproceso);
         COMMIT;
         ln_contador := ln_contador+1;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
             jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
          values
            (ln_CodPro,ln_paicli,ln_tipdoc,ls_numdoc,ls_numtar,null,ls_msgerr,sysdate);
          commit;
      end;
   END LOOP;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion","dFechaAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion","vHoraInicio","vHoraFinal",
       "vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',ld_fecact,
       'CARGA_TABLAS','TAR','LOAD',20,ls_horaini,ls_horafin,
       null,'A');
       commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'TAR'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
        (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
      commit;
      ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      ld_fecact := sysdate;     
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion","dFechaAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion","vHoraInicio","vHoraFinal",
          "vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',ld_fecact,
          'CARGA_TABLAS','TAR','LOAD',20,ls_horaini,ls_horafin,
          null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'TAR'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
END SP_SIMP_CARGA_TARJETAS;

PROCEDURE SP_NO_CONTA_ADQUI(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_NO_CONTA_ADQUI
-- Sistema                    : UNIBANCA
-- Módulo                     : NO CONTABILIZADOS DEL ADQUIRIENTE
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : No contabilizados adquiriente bantotal
-- Estado                     : Activo
-- Fecha Modificación         : 06/07/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : quitar trim a itx.pan por cambio en itxn / mejora performance
-- Fecha Modificación         : 28/08/2024
-- Autor de Modificación      : Fpinto
-- Descripcion Modificacion   : Aumentar dato de index de tabla / mejora performance
-- *****************************************************************
ln_CodPro number;
BEGIN
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_NO_CONTA_ADQUI', 'SYSADM', sysdate, sysdate);
   commit;
   delete jaqz926c
    where jaqz926FECINI = FECHA_PROCESO
      and JAQZ926CTIP = 'A'
      and JAQZ926CTPRO = 1;
   commit;
   insert into jaqz926c
      select 'A',res.jaql540fetra,res.jaql540nutar,itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),1,2,itx.AbmDate,regexp_replace(itx.acc_termid, '[^0123456789]', ''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.AcceptorName)
        from jaql540 res,jaql539 des,ITXN@TXNSWT itx
       where res.jaql540comsj = 500
         and res.jaql540nutar not like '426153%'
         and des.jaql539nucam = 11
         and res.jaql540cotra = des.jaql539cotra
         and res.jaql540cores = '00'
         and res.jaql540fetra = FECHA_PROCESO
         and res.jaql540modul = 0
         and res.jaql540trans = 0 --fpinto 28/08/2024 se aumenta dato del index para reducir costo
         and itx.pan = res.jaql540nutar
         and itx.trace = des.jaql539valtr;
      COMMIT;
      insert into jaqz926c
         select 'A',itx.DateIn,LTRIM(itx.Pan),itx.trace,sysdate, 
                LPAD(LTRIM(itx.MsgType),4,'0'),1,2,itx.AbmDate,regexp_replace(itx.acc_termid, '[^0123456789]',''),
                TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
                LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
                LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
                LTRIM(itx.AcceptorName)
           from ITXN@TXNSWT itx
          where SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2) in ('01','00')
            and itx.pan not like '426153%'
            and itx.datein = FECHA_PROCESO
            and to_number(itx.RespCode) = 0
            and LPAD(LTRIM(itx.MsgType),4,'0') = '0200'
            and not exists (select dr4.z0e4drtar
                              from z0e4dr dr4
                             where trim(dr4.z0e4drtar) = itx.pan
                               and dr4.z0e4drfec = itx.datein
                               and dr4.z0e4drnse = itx.trace
                               and dr4.z0e4drmod > 0);
      COMMIT;  
      update jaqz926A
         set jaqz926Afecfin = sysdate
       where jaqz926Acodpro = ln_CodPro;
      commit;
    EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK;
END SP_NO_CONTA_ADQUI;

PROCEDURE SP_NO_CONTA_EMI(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_NO_CONTA_EMI
-- Sistema                    : UNIBANCA
-- Módulo                     : NO CONTABILIZADOS DEL EMISOR
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : WCRW
-- Uso                        : No contabilizados emisor bantotal
-- Estado                     : Activo
-- Fecha Modificación         : 06/07/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : quitar trim a itx.pan por cambio en itxn / mejora performance 
-- Fecha Modificación         : 28/08/2024
-- Autor de Modificación      : Fpinto
-- Descripcion Modificacion   : Aumentar dato de index de tabla / mejora performance
-- *****************************************************************
ln_CodPro number;
ln_CoTra number;
BEGIN
  select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
   (ln_CodPro, 'SP_NO_CONTA_EMI', 'SYSADM', sysdate, /*sysdate*/null);
   commit;
   delete jaqz926c
    where jaqz926FECINI = FECHA_PROCESO
      and JAQZ926CTIP = 'E'
      and JAQZ926CTPRO = 1;
   commit;
   select min(jaql540cotra) into ln_CoTra from jaql540 where jaql540fetra = FECHA_PROCESO; --Dmanriquec 22/06/2023
   insert into jaqz926c
      select 'E',res.jaql540fetra,res.jaql540nutar,itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),1,2,itx.AbmDate,regexp_replace(itx.acc_termid, '[^0123456789]',''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.AcceptorName)
       from jaql540 res,jaql539 des,ITXN@TXNSWT itx          
      where des.jaql539nucam = 11
        and des.jaql539cotra = res.jaql540cotra
        and res.jaql540cotrx in ('011000','000000','001000')
        and res.jaql540nutar like '426153%'
        and res.jaql540cores = '00'
        and res.jaql540fetra = FECHA_PROCESO
        and res.jaql540modul = 0
        and res.jaql540trans = 0 --fpinto 28/08/2024 se aumenta dato del index para reducir costo
        and itx.pan = res.jaql540nutar
        and itx.trace = des.jaql539valtr
        and res.jaql540cotra >= ln_CoTra;
   COMMIT;
   insert into jaqz926c
      select 'E',itx.DateIn,LTRIM(itx.Pan),itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),1,2,itx.AbmDate,regexp_replace(itx.acc_termid, '[^0123456789]',''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.AcceptorName)
        from ITXN@TXNSWT itx
       where SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2) in ('01','00')
         and itx.pan like '426153%'
         and itx.datein = FECHA_PROCESO
         and to_number(itx.RespCode) = 0
         and LPAD(LTRIM(itx.MsgType),4,'0') = '0200'
         and not exists (select ge4.z0e4getar
                           from z0e4ge ge4
                          where ge4.z0e4getar = rpad(trim(itx.pan),19,' ')
                            and ge4.z0e4gefec = itx.datein
                            and ge4.z0e4gesec = itx.trace
                            and ge4.z0e4geest in ('00','PC'));
   COMMIT; 
   delete jaqz926c where jaqz926ctip = 'E' and jaqz926fecini = FECHA_PROCESO 
                     and jaqz926ctar = (select trim(jaql540.jaql540nutar)
                                           from jaql540
                                          where jaql540.jaql540nutar = jaqz926c.jaqz926ctar
                                            and substr(jaql540.jaql540nutra,7,6) = jaqz926c.jaqz926ctrace
                                            and jaqz926c.jaqz926fecini = jaql540.jaql540fetra
                                            and jaql540.JAQL540COMSJ = '200'
                                            and jaql540.jaql540modul > 0);
   commit;
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
END SP_NO_CONTA_EMI;

PROCEDURE SP_REVERSOS(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_REVERSOS EMISOR
-- Sistema                    : UNIBANCA
-- Módulo                     : 
-- Versión                    : 1.0
-- Fecha de Creación          : 19/12/2017
-- Autor de Creación          : WCRW
-- Uso                        : Reversos No contabilizados Bantotal
-- Estado                     : Activo
-- Fecha Modificación         : 06/07/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : quitar trim a itx.pan por cambio en itxn / mejora performance
-- Fecha Modificación         : 28/08/2024
-- Autor de Modificación      : Fpinto
-- Descripcion Modificacion   : Aumentar dato de index de tabla / mejora performance
-- *****************************************************************
ln_CodPro number;
BEGIN
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_REVERSOS', 'SYSADM', sysdate, sysdate);
   commit;
   delete jaqz926c
    where jaqz926FECINI = FECHA_PROCESO
      and JAQZ926CTIP = 'T'
      and JAQZ926CTPRO = 2;
   insert into jaqz926c
      select 'T',res.jaql540fetra,res.jaql540nutar,itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),2,2,itx.AbmDate,regexp_replace(itx.acc_termid,'[^0123456789]',''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.AcceptorName)
        from jaql540 res,jaql539 des,ITXN@TXNSWT itx          
       where des.jaql539nucam = 11
         and des.jaql539cotra = res.jaql540cotra
         and res.jaql540comsj = 400
         and res.jaql540cores = '00'
         and res.jaql540cotrx in ('011000','000000','001000') 
         and res.jaql540fetra = FECHA_PROCESO
         and res.jaql540modul = 0
         and res.jaql540trans =0 --fpinto 28/08/2024 se aumenta dato del index para reducir costo
         and itx.pan = res.jaql540nutar
         and itx.trace = des.jaql539valtr
         and res.jaql540nutar like '426153%';
   COMMIT;
   insert into jaqz926c
      select 'T',itx.DateIn,itx.Pan,itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),1,2,itx.AbmDate,regexp_replace(itx.acc_termid,'[^0123456789]',''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),LTRIM(itx.Cur_Tran),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.AcceptorName)
        from ITXN@TXNSWT itx
       where SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2) in ('01','00')
         and itx.pan like '426153%'
         and LPAD(LTRIM(MsgType),4,'0') = '0400'
         and itx.datein = FECHA_PROCESO
         and to_number(itx.RespCode) = 0
         and not exists (select res.jaql540nutar
                           from jaql540 res,jaql539 des
                          where des.jaql539nucam = 11
                            and res.jaql540cotra = des.jaql539cotra
                            and res.jaql540fetra = itx.datein
                            and itx.pan = res.jaql540nutar
                            and itx.trace = des.jaql539valtr);  
   COMMIT; 
   update jaqz926A
      set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
END SP_REVERSOS;

PROCEDURE SP_DIFRES(FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_DIFRES
-- Sistema                    : UNIBANCA
-- Módulo                     : NO CONTABILIZADOS DEL ADQUIRIENTE
-- Versión                    : 1.0
-- Fecha de Creación          : 19/12/2017
-- Autor de Creación          : WCRW
-- Uso                        : Carga de Tarjetas
-- Estado                     : Activo
-- Fecha Modificación         : 06/07/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : quitar trim a itx.pan por cambio en itxn / mejora performance
-- *****************************************************************
ln_CodPro number;
BEGIN
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_REVERSOS', 'SYSADM', sysdate, sysdate);
   commit;
   delete jaqz926c
    where jaqz926FECINI = FECHA_PROCESO
      and JAQZ926CTPRO = 3;
    insert into jaqz926c
       select 'T',res.jaql540fetra,res.jaql540nutar,itx.trace,sysdate, 
             LPAD(LTRIM(itx.MsgType),4,'0'),3,2,TO_CHAR(itx.AbmDate, 'YYYY-MM-DD'),
             regexp_replace(itx.acc_termid,'[^0123456789]',''),
             TO_Char(TO_DATE(LPAD(LTRIM(itx.TransTime),6,'0'),'HH24MISS'),'HH24:MI:SS'),
             LPAD(LTRIM(itx.PrCode),6,'0'),SUBSTR(LPAD(LTRIM(itx.PrCode),6,'0'),1,2),
             LTRIM(itx.RespCode),replace(trim(to_char(TxnAmt,'99999999999.99')),'.',''),
             LTRIM(itx.Cur_Tran),LTRIM(itx.AcceptorName)
          from jaql540 res,jaql539 des,ITXN@TXNSWT itx   
         where des.jaql539nucam = 11
           and des.jaql539cotra = res.jaql540cotra
           and res.jaql540comsj in (200,400)
           and res.jaql540cores = '00'
           and res.jaql540cotrx in ('011000','000000','001000') 
           and res.jaql540fetra = FECHA_PROCESO
           and itx.pan = res.jaql540nutar
           and itx.trace = des.jaql539valtr     
           and itx.msgtype = res.jaql540comsj
           and itx.respcode <> to_number(res.jaql540cores,'99');
       COMMIT;
       update jaqz926A
          set jaqz926Afecfin = sysdate
        where jaqz926Acodpro = ln_CodPro;
       commit;
    EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK;
END SP_DIFRES;

PROCEDURE SP_CU_TXNBAN(FECHA_BANTOTAL DATE) AS
-- *****************************************************************
-- Nombre                     : SP_CU_TXNBAN
-- Sistema                    : UNIBANCA
-- Módulo                     : No contabilizadas Emisor Adquiriente
-- Versión                    : 1.0
-- Fecha de Creación          : 27/11/2017
-- Autor de Creación          : BDEG
-- Uso                        : Carga de Tarjetas
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
CURSOR c_TxnBan IS
   SELECT distinct JAQZ926CTAR,JAQZ926FECINI,JAQZ926CTRACE,JAQZ926FECING,JAQZ926CTIP,
          JAQZ926CCMEN,JAQZ926CTPRO,jaqz926cntdes,jaqz926cftra,jaqz926ccatm,jaqz926chtra,
          jaqz926ccpro,jaqz926cipro,jaqz926ccres,jaqz926ccmon,LTRIM(jaqz926cmtra) as mtra,
          jaqz926cnadq 
     FROM JAQZ926C
    WHERE to_date(jaqz926FECINI) = FECHA_BANTOTAL
   ORDER BY 1;
   ln_CodPro number;
   ls_msgerr varchar2(4000);
   ls_numtar varchar2(19);
   ld_fectra date;
   ls_numtra varchar2(6);
   ld_fecpro varchar(10);
   ln_contador number(10);
   ls_horaini varchar(8);
   ls_horafin varchar(8);
   ld_fecini varchar(10);
   ld_fecfin date;
   ld_indest number;
   ld_fecact date;
   ln_Ctl001 number;
   ln_NumTra number;
   ld_fecnex date;
   ln_tipdes number(3);
   --ld_fectra date;
   ln_codatm number(8);
   ls_hortra varchar(8);
   ls_codpro varchar(6);
   ln_codmon numeric(3);
   ls_montra numeric(14);
   ls_idepro varchar(2);
   ln_codres number(4);
   ls_nomdes varchar(40);
   ln_codrol numeric(1);
   ls_codmsg varchar(4);
BEGIN 
   ld_fecpro := to_char(FECHA_BANTOTAL, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini,
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" in('BEMI','BADQ')
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;     
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values (ln_CodPro, 'SP_CU_TXNBAN', 'SYSADM', sysdate, sysdate);
   commit;
   delete "MovTxnsBantotal"@Unibanca
    where "dFechaTransaccion" = FECHA_BANTOTAL;
   commit;
   FOR c_DatBan IN c_TxnBan LOOP
      begin
         ls_numtar := TRIM(c_DatBan.JAQZ926CTAR);
         ld_fectra := c_DatBan.JAQZ926FECINI;
         ld_fecnex := ld_fectra + 1;
         ls_numtra := LPAD(TRIM(c_DatBan.JAQZ926CTRACE), 6, '0');
         ln_numtra := to_number(ls_numtra);
         ln_tipdes := c_DatBan.jaqz926cntdes;
         --ld_fectra := jaqz926cftra;
         ln_codatm := c_DatBan.jaqz926ccatm;
         ls_hortra := c_DatBan.jaqz926chtra;
         ls_codpro := c_DatBan.jaqz926ccpro;
         ls_idepro := c_DatBan.jaqz926cipro;
         ln_codres := c_DatBan.jaqz926ccres;
         ln_codmon := c_DatBan.jaqz926ccmon;
         --ls_montra := c_DatBan.jaqz926cmtra;
         ls_nomdes := substr(trim(c_DatBan.jaqz926cnadq),1,40);
         ls_codmsg := c_DatBan.JAQZ926CCMEN;
         ln_codrol := 1;
         if c_DatBan.JAQZ926CTIP in ('A','T') and c_DatBan.JAQZ926CTPRO in (1,3) then
            ln_codrol := 2;
         end if; 
         insert into "MovTxnsBantotal"@Unibanca
            ("dFechaProceso","nTipoDescuadre","dFechaTransaccion","vNumeroTarjeta","vNumeroTrace","nIdATM",
             "horaTransaccion","horaExtorno","vCodigoProceso","vIdProceso","nCodigoRespuesta","nCodigoRespuestaExtorno",
             "nMonedaAutorizacion","nMontoAutorizacion","vCodigoAutorizacion","vNombreAdquirente","nRolTransaccion",
             "nConciliaJournal","nValorDispensadoJournal","vMensajeErrorJournal","nCodigoError","nIndRegularizacion",
             "vMessageType")
         values 
            (FECHA_BANTOTAL,2,ld_fectra,ls_numtar,ls_numtra,ln_codatm,
             ls_hortra,null,ls_codpro,ls_idepro,ln_codres,null,
             ln_codmon,c_DatBan.mtra,null,ls_nomdes,ln_codrol,0,null,null,
             null,0,ls_codmsg);
         ln_contador := ln_contador + 1;
         COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
             jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
         values
            (ln_CodPro,ls_numtar,ls_numtra,ls_hortra,
             c_DatBan.JAQZ926CTIP,ls_codpro,ls_msgerr,sysdate);
         commit;
      end;
   END LOOP;
   update "MovTxnsBantotal"@Unibanca set "nMontoAutorizacion" = "nMontoAutorizacion" / 100
    where "dFechaTransaccion" = FECHA_BANTOTAL
      and "nTipoDescuadre" = 2;
   commit;
   update jaqz926A set jaqz926Afecfin= sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','BEMI','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','BADQ','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin"=ld_fecfin,"vHoraFin"=ls_horafin,"nEstado"=ld_indest
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" in('BEMI','BADQ')
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
EXCEPTION
WHEN OTHERS THEN
   ROLLBACK;
   ls_msgerr := SQLERRM;
   insert into jaqz926B
      (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
      jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
   values
      (ln_CodPro,null,null,null,null,null,ls_msgerr,sysdate);
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
   ld_fecact := sysdate;     
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo",
       "nIdInstitucion","vHoraInicio","vHoraFinal","vTiempoProceso",
       "vTipoEjecucion")
   VALUES
      (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','BEMI','LOAD',
       20,ls_horaini,ls_horafin,null,'A');
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "dFechaAdicion","vIdGrupo","vIdPrograma","vIdSubModulo",
       "nIdInstitucion","vHoraInicio","vHoraFinal","vTiempoProceso",
       "vTipoEjecucion")
   VALUES
      (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
       ld_fecact,'CARGA_TABLAS','BADQ','LOAD',
       20,ls_horaini,ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
    wHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" in('BEMI','BADQ')
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
END SP_CU_TXNBAN;

PROCEDURE SP_SIMP_EJE_PROCESO(PD_FECPRO in date,PS_MENERR out varchar2) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_EJE_PROCESO
-- Sistema                    : UNIBANCA
-- Módulo                     : Ejecutar procedimeintos de SIMP
-- Versión                    : 1.0
-- Fecha de Creación          : 12/02/2018
-- Autor de Creación          : BDEG
-- Uso                        : Ejecución de procesos SIMP
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
ld_fecpro varchar(10);
ld_feceje date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
       FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   --ld_feceje := to_date(ld_fecpro,'yyyy-mm-dd');
   ld_feceje := pd_fecpro;
   SP_SIMP_CARGA_AGENCIA(ld_feceje);
   SP_SIMP_CARGA_ATM(ld_feceje);
   SP_SIMP_CARGA_CUENTAS(ld_feceje);     
   SP_SIMP_CARGA_CLIENTES(ld_feceje);     
   SP_SIMP_CARGA_TARJETAS(ld_feceje);
   SP_NO_CONTA_ADQUI(ld_feceje);
   SP_NO_CONTA_EMI(ld_feceje);
   SP_REVERSOS(ld_feceje);
   --SP_DIFRES(ld_feceje); No se registran extornos modo Adquiriente en tablas bantotal
   SP_CU_TXNBAN(ld_feceje);
   SP_SIMP_CARGA_AUTO_BEVERTEC(ld_feceje);
   SP_SIMP_CARGA_AUTO_NOVATRONIC(ld_feceje); 
   SP_SIMP_CARGA_COMIS(ld_feceje);
   SP_SIMP_CARGA_CONTADORES(ld_feceje);
   PS_MENERR := 'CORRECTO';
EXCEPTION
WHEN OTHERS THEN
   PS_MENERR := SQLERRM;
END SP_SIMP_EJE_PROCESO;
  
PROCEDURE SP_SIMP_CARGA_COMIS (FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_COMIS
-- Sistema                    : UNIBANCA
-- Módulo                     : Carga de comisiones
-- Versión                    : 1.0
-- Fecha de Creación          : 14/02/2018
-- Autor de Creación          : BDEG
-- Uso                        : Carga de ATMS
-- Estado                     : Activo
-- Fecha Modificación         : 12/03/2018 
-- Autor de Modificación      : Eduardo Barros
-- Descripcion Modificacion   : Se parametrizó el código de moneda
-- *****************************************************************
CURSOR c_AtmCli IS
   select a.jaql540nutar as tarjeta,b.hfcon as fecha,
          LPAD(LTRIM(des.jaql539valtr), 6, '0') as codtra,
          replace(b.hcimp1,',','.') as monto,
          case when b.hmda = '101' then '840' else '604' end  as moneda --12/03/2018
     from jaql540 a
   inner join fsh016 b
       on a.jaql540relac = b.hnrel 
      and a.jaql540trans = b.htran 
      and a.jaql540modul = b.hcmod
      and a.jaql540fetra = b.hfcon
   inner join jaql539 des
       on des.jaql539nucam = 11
      and des.jaql539cotra = a.jaql540cotra
    where a.jaql540comsj = 200
      and hcmod = 66
      and htran in(12,14,16,50)
      and hfcon= FECHA_PROCESO
      and hcord = 40;
   ln_CodPro number;
   ls_msgerr varchar2(4000);
   ls_codatm varchar(20);
   ld_fecpro varchar(10);
   ln_contador number(10);
   ls_horaini varchar(8);
   ls_horafin varchar(8);
   ld_fecini varchar(10);
   ld_fecfin date;
   ld_indest number;
   ld_fecact date;
BEGIN
   /*SELECT "dFechaProceso" into ld_fecpro 
       FROM "MaeParametrosGenerales"@Unibanca;
   commit;*/
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" =  ld_fecpro
      AND "vIdPrograma" = 'COMI'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_COMIS', 'SYSADM', sysdate, sysdate);
   commit;
   delete "MovComisionesThb"@Unibanca
    where "dFechaTransaccion" = FECHA_PROCESO;
   commit;
   FOR c_DatCli IN c_AtmCli LOOP
      begin
        ln_contador := ln_contador+1;
        insert into "MovComisionesThb"@Unibanca
           ("vNumeroTarjeta","dFechaTransaccion","vNumeroTrace",
            "nMonedaComision","nValorComision")
        values
           (c_DatCli.tarjeta,c_DatCli.fecha,c_DatCli.codtra,
            c_DatCli.moneda,c_DatCli.monto);
        COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
            (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
             jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
         values
            (ln_CodPro,ls_codatm,null,null,
             null,null,ls_msgerr,sysdate);
         commit;
      end;    
   END LOOP;
   update jaqz926A set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   ld_fecact := sysdate;
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       'CARGA_TABLAS','COMI','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
   commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin, 
          "nEstado" = ld_indest
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'COMI'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
          jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
          ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'BANTOTAL',
          'CARGA_TABLAS','COMI','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini, 
             "nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'COMI'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;
END SP_SIMP_CARGA_COMIS;

PROCEDURE SP_SIMP_CARGA_CONTADORES (FECHA_PROCESO DATE) AS
-- *****************************************************************
-- Nombre                     : SP_SIMP_CARGA_CONTADORES
-- Sistema                    : UNIBANCA
-- Módulo                     : CARGA DE DATA DE PL - SQL -> SQL SERVER
-- Versión                    : 1.0
-- Fecha de Creación          : 31/07/2019
-- Autor de Creación          : WCRW
-- Uso                        : Carga de Contadores
-- Estado                     : Activo
-- Fecha Modificación         : 07/07/2021
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Adición de caseteras ATMs Multifuncionales
-- *****************************************************************
CURSOR c_ConAtm IS
   /*SELECT 20,TO_CHAR(cnt_date,'YYYY-MM-DD') as fecpro,TO_Char(TO_DATE(LPAD(LTRIM(cnt_time),6,'0'),'HH24MISS'),'HH24:MI:SS') as horpro,
       unit,currency1 as mone01,round(denom1/100,0) as deno01,remain1 as rema01,dispen1 as disp01,reject1 as reje01,total1 as tota01,
       currency2 as mone02,round(denom2/100,0) as deno02,remain2 as rema02,dispen2 as disp02,reject2 as reje02,total2 as tota02,
       currency3 as mone03,round(denom3/100,0) as deno03,remain3 as rema03,dispen3 as disp03,reject3 as reje03,total3 as tota03,
       currency4 as mone04,round(denom4/100,0) as deno04,remain4 as rema04,dispen4 as disp04,reject4 as reje04,total4 as tota04*/
   SELECT 20,TO_CHAR(cnt_date,'YYYY-MM-DD') as fecpro,TO_Char(TO_DATE(LPAD(LTRIM(cnt_time),6,'0'),'HH24MISS'),'HH24:MI:SS') as horpro,
       unit,currency1 as mone01,denom1 as deno01,remain1 as rema01,dispen1 as disp01,reject1 as reje01,total1 as tota01,
       currency2 as mone02,denom2 as deno02,remain2 as rema02,dispen2 as disp02,reject2 as reje02,total2 as tota02,
       currency3 as mone03,denom3 as deno03,remain3 as rema03,dispen3 as disp03,reject3 as reje03,total3 as tota03,
       currency4 as mone04,denom4 as deno04,remain4 as rema04,dispen4 as disp04,reject4 as reje04,total4 as tota04,
       dp0_curr1 as mone05,dp0_denom1 as deno05,dp0_notes1 as rema05,0 as disp05,0 as reje05,dp0_notes1 as tota05,
       dp0_curr1 as mone06,dp0_denom2 as deno06,dp0_notes2 as rema06,0 as disp06,0 as reje06,dp0_notes2 as tota06,
       dp0_curr1 as mone07,dp0_denom3 as deno07,dp0_notes3 as rema07,0 as disp07,0 as reje07,dp0_notes3 as tota07,
       dp0_curr1 as mone08,dp0_denom4 as deno08,dp0_notes4 as rema08,0 as disp08,0 as reje08,dp0_notes4 as tota08,
       dp0_curr1 as mone09,dp0_denom5 as deno09,dp0_notes5 as rema09,0 as disp09,0 as reje09,dp0_notes5 as tota09,
       dp0_curr2 as mone10,dp0_denom6 as deno10,dp0_notes6 as rema10,0 as disp10,0 as reje10,dp0_notes6 as tota10,
       dp1_curr1 as mone11,dp1_denom1 as deno11,dp1_notes1 as rema11,0 as disp11,0 as reje11,dp1_notes1 as tota11,
       dp1_curr1 as mone12,dp1_denom2 as deno12,dp1_notes2 as rema12,0 as disp12,0 as reje12,dp1_notes2 as tota12,
       dp1_curr1 as mone13,dp1_denom3 as deno13,dp1_notes3 as rema13,0 as disp13,0 as reje13,dp1_notes3 as tota13,
       dp1_curr1 as mone14,dp1_denom4 as deno14,dp1_notes4 as rema14,0 as disp14,0 as reje14,dp1_notes4 as tota14,
       dp1_curr1 as mone15,dp1_denom5 as deno15,dp1_notes5 as rema15,0 as disp15,0 as reje15,dp1_notes5 as tota15,
       dp1_curr2 as mone16,dp1_denom6 as deno16,dp1_notes6 as rema16,0 as disp16,0 as reje16,dp1_notes6 as tota16
     FROM atmcounters@cajero
    WHERE cnt_date = FECHA_PROCESO;
ln_CodPro number;
ls_msgerr varchar2(4000);
ls_codatm varchar(20);
ld_fecpro varchar(10);
ln_contador number(10);
ls_horaini varchar(8);
ls_horafin varchar(8);
ld_fecini varchar(10);
ld_fecfin date;
ld_indest number;
  
BEGIN
   ld_fecpro := to_char(FECHA_PROCESO, 'yyyy-mm-dd');
   ln_contador := 0;
   ld_indest := 1;
   ld_fecini := to_char(trunc(sysdate),'yyyy-mm-dd');
   ls_horaini := to_char(sysdate,'HH24:Mi:ss');
   ls_msgerr   := 'PROCESO EJECUTADO CORRECTAMENTE';
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaInicio" = ld_fecini,"vHoraInicio" = ls_horaini, 
          "vUsuarioEjecucion" = 'BANTOTAL',"dFechaEjecucion" = ld_fecini 
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vFechaProceso" = ld_fecpro
      AND "vIdPrograma" = 'CONT'
      AND "vIdSubModulo" = 'LOAD'     
      AND "nEstado" IN (-1, 0);
   commit;
   select coalesce(max(jaqz926Acodpro), 0) into ln_CodPro from jaqz926A;
   ln_CodPro := ln_CodPro + 1;
   insert into jaqz926A
   values
      (ln_CodPro, 'SP_SIMP_CARGA_CONTADORES','SYSADM',sysdate,sysdate);
   commit;
   FOR c_AtmCon IN c_ConAtm LOOP 
      begin
         ln_contador := ln_contador+1;
         insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
         values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             1,c_AtmCon.mone01,c_AtmCon.deno01,c_AtmCon.rema01,c_AtmCon.disp01,
             c_AtmCon.reje01,c_AtmCon.tota01);
         COMMIT;
         insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
         values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             2,c_AtmCon.mone02,c_AtmCon.deno02,c_AtmCon.rema02,c_AtmCon.disp02,
             c_AtmCon.reje02,c_AtmCon.tota02);
         COMMIT;
         insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
         values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             3,c_AtmCon.mone03,c_AtmCon.deno03,c_AtmCon.rema03,c_AtmCon.disp03,
             c_AtmCon.reje03,c_AtmCon.tota03);
         COMMIT;
         insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
         values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             4,c_AtmCon.mone04,c_AtmCon.deno04,c_AtmCon.rema04,c_AtmCon.disp04,
             c_AtmCon.reje04,c_AtmCon.tota04);
         if c_AtmCon.mone05 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             5,c_AtmCon.mone05,c_AtmCon.deno05,c_AtmCon.rema05,c_AtmCon.disp05,
             c_AtmCon.reje05,c_AtmCon.tota05);
         end if;
         if c_AtmCon.mone06 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             6,c_AtmCon.mone06,c_AtmCon.deno06,c_AtmCon.rema06,c_AtmCon.disp06,
             c_AtmCon.reje06,c_AtmCon.tota06);
         end if;
         if c_AtmCon.mone07 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             7,c_AtmCon.mone07,c_AtmCon.deno07,c_AtmCon.rema07,c_AtmCon.disp07,
             c_AtmCon.reje07,c_AtmCon.tota07);
         end if;
         if c_AtmCon.mone08 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             8,c_AtmCon.mone08,c_AtmCon.deno08,c_AtmCon.rema08,c_AtmCon.disp08,
             c_AtmCon.reje08,c_AtmCon.tota08);
         end if;
         if c_AtmCon.mone09 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             9,c_AtmCon.mone09,c_AtmCon.deno09,c_AtmCon.rema09,c_AtmCon.disp09,
             c_AtmCon.reje09,c_AtmCon.tota09);
         end if;
         if c_AtmCon.mone10 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             10,c_AtmCon.mone10,c_AtmCon.deno10,c_AtmCon.rema10,c_AtmCon.disp10,
             c_AtmCon.reje10,c_AtmCon.tota10);
         end if;
         if c_AtmCon.mone11 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             11,c_AtmCon.mone11,c_AtmCon.deno11,c_AtmCon.rema11,c_AtmCon.disp11,
             c_AtmCon.reje11,c_AtmCon.tota11);
         end if;
         if c_AtmCon.mone12 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             12,c_AtmCon.mone12,c_AtmCon.deno12,c_AtmCon.rema12,c_AtmCon.disp12,
             c_AtmCon.reje12,c_AtmCon.tota12);
         end if;
         if c_AtmCon.mone13 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             13,c_AtmCon.mone13,c_AtmCon.deno13,c_AtmCon.rema13,c_AtmCon.disp13,
             c_AtmCon.reje13,c_AtmCon.tota13);
         end if;
         if c_AtmCon.mone14 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             14,c_AtmCon.mone14,c_AtmCon.deno14,c_AtmCon.rema14,c_AtmCon.disp14,
             c_AtmCon.reje14,c_AtmCon.tota14);
         end if;
         if c_AtmCon.mone15 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             15,c_AtmCon.mone15,c_AtmCon.deno15,c_AtmCon.rema15,c_AtmCon.disp15,
             c_AtmCon.reje15,c_AtmCon.tota15);
         end if;
         if c_AtmCon.mone16 is not null then
            insert into "MovContadoresCajero"@Unibanca
            ("nIdInstitucion","dFechaCorte","vHoraCorte","dFechaProceso","vCodigoATM",
             "nCasetera","nCodigoMoneda","nDenominacionBillete","nRemanente","nDispensado",
             "nRechazado","nTotal")
            values
            (20,c_AtmCon.fecpro,c_AtmCon.horpro,c_AtmCon.fecpro,c_AtmCon.unit,
             16,c_AtmCon.mone16,c_AtmCon.deno16,c_AtmCon.rema16,c_AtmCon.disp16,
             c_AtmCon.reje16,c_AtmCon.tota16);
         end if;
         COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         ls_msgerr := SQLERRM;
         ld_indest :=0;
         insert into jaqz926B
             (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,
              jaqz926Bcod4,jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
          values
             (ln_CodPro,ls_codatm,null,null,null,null,ls_msgerr,sysdate);
          commit;
      end;    
   END LOOP;
   update jaqz926A set jaqz926Afecfin = sysdate
    where jaqz926Acodpro = ln_CodPro;
   commit;
   ls_horafin := to_char(sysdate,'HH24:Mi:ss');
   ld_fecfin := trunc(sysdate);
   INSERT INTO "LogControlPrograma"@Unibanca
      ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
       "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
       "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
   VALUES
      (ld_fecpro,ld_indest,ls_msgerr,ln_contador,'BANTOTAL',
       'CARGA_TABLAS','CONT','LOAD',20,
       ls_horaini,ls_horafin,null,'A');
       commit;
   UPDATE "LogControlProgramaResumen"@Unibanca
      SET "dFechaFin" = ld_fecfin,"vHoraFin" = ls_horafin,"nEstado" = ld_indest
    WHERE "vIdGrupo" = 'CARGA_TABLAS'
      AND "vIdPrograma" = 'CONT'
      AND "vIdSubModulo" = 'LOAD'
      AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
      AND "nEstado" IN (-1, 0);
   commit;     
   EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ls_msgerr := SQLERRM;
      insert into jaqz926B
         (jaqz926Acodpro,jaqz926Bcod1,jaqz926Bcod2,jaqz926Bcod3,jaqz926Bcod4,
          jaqz926Bcod5,jaqz926Berror,jaqz926Bfecha)
      values
         (ln_CodPro, null, null, null, null, null, ls_msgerr, sysdate);
          ls_horafin := to_char(sysdate,'HH24:Mi:ss'); 
      INSERT INTO "LogControlPrograma"@Unibanca
         ("dFechaProceso","nEstado","vMensaje","nRegistros","vUsuarioAdicion",
          "vIdGrupo","vIdPrograma","vIdSubModulo","nIdInstitucion",
          "vHoraInicio","vHoraFinal","vTiempoProceso","vTipoEjecucion")
      VALUES
         (ld_fecpro,0,ls_msgerr,ln_contador,'CONTADORES',
          'CARGA_TABLAS','CONT','LOAD',20,
          ls_horaini,ls_horafin,null,'A');
      commit;
      UPDATE "LogControlProgramaResumen"@Unibanca
         SET "dFechaFin" = ld_fecini,"vHoraFin" = ls_horaini,"nEstado" = 0
       wHERE "vIdGrupo" = 'CARGA_TABLAS'
         AND "vIdPrograma" = 'CONT'
         AND "vIdSubModulo" = 'LOAD'
         AND "vFechaProceso" = ld_fecpro -- FECHA PROCESO SIMP
         AND "nEstado" IN (-1, 0);
      commit;
END SP_SIMP_CARGA_CONTADORES;

end PQ_AH_ACTCONUBA;
/

