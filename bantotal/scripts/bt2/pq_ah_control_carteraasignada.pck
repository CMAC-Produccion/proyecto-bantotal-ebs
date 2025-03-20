CREATE OR REPLACE PACKAGE PQ_AH_CONTROL_CARTERAASIGNADA IS
------------------------------------------------------
procedure SP_AH_GENERAINFO(lc_usuario in varchar2,
                           lc_ubuser  in varchar2,
                           ld_fecIni  in date,
                           ld_fecFin  in date);
------------------------------------------------------
PROCEDURE PROCESO_AHORRO(VUSUARIO  IN VARCHAR2,
                         VUBUSER   IN CHARACTER,
                         ld_fecIni in date,
                         ld_fecFin in date);
------------------------------------------------------
PROCEDURE PROCESO_CANCEL(PUSUARIO  IN VARCHAR2,
                         PUBUSER   IN CHARACTER,
                         ld_fecIni in date,
                         ld_fecFin in date);
------------------------------------------------------
Procedure  Saldos_CARTERAA(ln_regcod  in number,
                           ln_suc     in number,
                           lc_ubuser  in varchar2,
                           ld_fecha   in date,
                           ln_Agencia in number,
                           ln_tipo    in number,
                           lc_user    in varchar2);
------------------------------------------------------
PROCEDURE monto_saldo(ln_mod in number,
                      ln_suc in number,
                      ln_cta in number,
                      ln_mda in number,
                      ln_ope in number,
                      ln_top in number,
                      ln_sop in number,
                      ln_rub in number,
                      ld_fec in date,
                      ln_mto out number,
                      ln_sld out number);

END PQ_AH_CONTROL_CARTERAASIGNADA;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_CONTROL_CARTERAASIGNADA IS
------------------------------------------------------
procedure SP_AH_GENERAINFO(lc_usuario in varchar2,
                           lc_ubuser  in varchar2,
                           ld_fecIni  in date,
                           ld_fecFin  in date
                           ) IS
/*cursor region is
    select regcod,regnom
      from fst810
     where regcod < 100;

cursor sucursal(region1 in number) is
    select f1.sucurs codsuc, f1.scnom nomsuc
      from fst811 f81,
           fst001 f1
     where f81.pgcod  = 1
       and f81.regcod = region1
       and f1.pgcod   = f81.pgcod
       and f1.sucurs  = f81.oficod;*/

/*
RNombre VARCHAR2(40);
SNombre varchar2(40);*/

Begin

  Delete jaqy681 where jaqy681USU = lc_usuario;--RPAD(lc_usuario,' ',10);
  Delete jaqy682 where jaqy682usu = lc_usuario;---RPAD(lc_usuario,' ',10);*/
  commit;

            Proceso_Ahorro(lc_usuario,
                           lc_ubuser,
                           ld_fecIni,
                           ld_fecFin );
            PROCESO_CANCEL(lc_usuario,
                           lc_ubuser,
                           ld_fecIni,
                           ld_fecFin);

End SP_AH_GENERAINFO;

PROCEDURE PROCESO_AHORRO(VUSUARIO  IN VARCHAR2,
                         VUBUSER   IN CHARACTER,
                         ld_fecIni in date,
                         ld_fecFin in date) IS

  cursor cartera (EJECUTIVO IN CHARACTER) is
   SELECT
    (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
     decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
     decode(f1.scmod,22, (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(F1.SCOPER)),9,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')),
                        (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0'))) cuenta,
     F1.SCSDO monto,
     F1.SCOPER OPERACION,
     (SELECT TONOM FROM FST004 WHERE MODULO = F1.scmod AND TOTOPE = f1.sctope) producto,
     f1.scfval fechaApertura,
     f8.pendoc as numdoc,
     (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc ) nombre,
     (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
        J1.JAQL61NDOC DNI,
        f1.scpzo plazo,
        0 tea,
        f1.Scmod mODULO,
        f1.Scmda MDA,
        f1.Scpap PAP,
        f1.Sccta CTA1,
        f1.Scsuc SUC1,
        f1.Scoper OPE1,
        f1.Scsbop SUB1,
        f1.Sctope TOP1,
        F1.SCFVTO FVTO
      from jaql061 j1,
           fsr008 f8,
           fsd011 f1
     where j1.jaql61pgco = 1
       and j1.jaql61user = EJECUTIVO
       AND j1.JAQL61ESTA = 'S'
       and f8.pgcod = j1.jaql61pgco
       and f8.pepais = j1.jaql61pais
       and f8.petdoc = j1.jaql61tdoc
       and f8.pendoc = j1.jaql61ndoc
       and f8.cttfir = 'T'
       and f1.pgcod = f8.pgcod
       and f1.sccta = f8.ctnro
       and f1.scmod in (21,22)
       and f1.scfval between ld_fecIni and ld_fecFin
      /* and f1.scfval Between (select  ADD_MONTHS (trunc(pgfape),-3) from fst017 where pgcod = 1)
                         AND (select trunc(pgfape) from fst017 where pgcod = 1)---- >= J1.JAQL61FECH --'01/05/2016' --and '19/05/2016'*/ --CONSULTAR FECHAS
       and f1.scstat <>99;

  pgcod number:= 1;
  tasa number(17,2):=0;
  vfecfin date := trunc(sysdate);
  SUCORI  number;
  FCON    date;
  PTRMOD  number;
  PTRNRO  number;
  NREL    number;
  IMPMOV  number;
  Monto   number;

Begin
    FOR reg in cartera(VUBUSER) loop
        monto := reg.monto;
            if reg.modulo = 22 then
               PQ_SEGMENTACION_CLIENTES_PAS.sp_tasa(Pgcod,reg.suc1,reg.cta1,reg.mda,reg.pap,reg.ope1,reg.sub1,reg.top1,reg.modulo,tasa);
            eLSE
               tasa := 0;
                SP_DEPO_CV(pgcod,reg.suc1,reg.modulo,reg.mda,reg.pap,reg.cta1,reg.ope1,reg.sub1,reg.top1, REG.FECHAAPERTURA,Vfecfin,SUCORI,FCON,PTRMOD,PTRNRO,NREL, IMPMOV);
                monto := IMPMOV;
            END IF;
            Begin

                insert into JAQY681(JAQY681usu,
                                    JAQY681cta,
                                    JAQY681cli,
                                    JAQY681nop,
                                    JAQY681mto,
                                    JAQY681mda,
                                    JAQY6815pzo,
                                    JAQY681tea,
                                    JAQY681AUX2,
                                    JAQY681fape,
                                    JAQY681age,
                                    jaqy681dni,
                                    JAQY681top1,
                                    JAQY681subo1,
                                    JAQY681op1,
                                    JAQY681suc1,
                                    JAQY681nct,
                                    JAQY681pape,
                                    JAQY681mone,
                                    JAQY681modu,
                                    Jaqy681aux6)
                             values( Vusuario,
                                     reg.cuenta,
                                     reg.nombre,
                                     reg.operacion,
                                     monto,
                                     reg.moneda,
                                     reg.plazo,
                                     tasa,
                                     reg.producto,
                                     reg.fechaapertura,
                                     reg.sucursal,
                                     reg.dni,
                                     reg.top1,
                                     reg.sub1,
                                     reg.operacion,
                                     reg.suc1,
                                     reg.cta1,
                                     reg.pap,
                                     reg.mda,
                                     reg.modulo,
                                     reg.fvto
                                    );
              Exception
                when dup_val_on_index then
                  null;
              End;
      end loop;
      commit;
END PROCESO_AHORRO;
PROCEDURE PROCESO_CANCEL(PUSUARIO  IN VARCHAR2,
                         PUBUSER   IN CHARACTER,
                         ld_fecIni in date,
                         ld_fecFin in date) IS


  cursor cartera(agente in character)is
     select jaql61pais pais,
            jaql61tdoc tdoc,
            jaql61ndoc ndoc
       from jaql061
      where jaql61pgco = 1
        and jaql61user = agente
        and jaql61esta = 'S';

  cursor cuentas(pais in number, tipdoc in number, ndoc in character)is
     select ctnro
       from fsr008
      where pgcod = 1
        and pepais = pais
        and petdoc = tipdoc
        and pendoc = ndoc
        and cttfir = 'T';

  cursor datos (cuenta in number)is
      select (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
       (select scnom from fst001 where sucurs = f6.hsucor) SUCCancel,
       decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
       (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
       F1.SCOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
       f1.scfval fechaaper,
       NULL fechavcto,
       f6.hfcon fechacancelacion,
       f8.pendoc  numdoc,
       fs.penom nombre,
       f6.hcimp1 MONTO,
       0 PLAZO,
       0 TASA,
          f1.Scmod mODULO,
          f1.Scmda MDA,
          f1.Scpap PAP,
          f1.Sccta CTA1,
          f1.Scsuc SUC1,
          f1.Scoper OPE1,
          f1.Scsbop SUB1,
          f1.Sctope TOP1
      from FSH016 f6,
           fsh015 f5,
           fsd011 f1,
           fsr008 f8,
           fsd001 fs
        Where f6.Pgcod = 1
          and f6.hcta = cuenta
         and f6.Hcmod = 21
        and f6.Htran = 905
        and f6.hfcon between ld_fecIni and ld_fecFin
      /*  and f6.Hfcon Between (select  ADD_MONTHS (trunc(pgfape),-3) from fst017 where pgcod = 1)
                         AND (select trunc(pgfape) from fst017 where pgcod = 1)*/
        and f6.Hmodul = 21
        and f6.Htoper <> 9
        and f6.Hmda in (0,101)
        and f6.Hpap = 0
        AND f6.hcord IN(75,24,22)
        and f1.pgcod = f6.pgcod
        and f1.scsuc = f6.hsucur
        and f1.scmda = f6.hmda
        and f1.scpap = f6.hpap
        and f1.sccta = f6.hcta
        and f1.scoper = f6.hoper
        and f1.scsbop = f6.hsubop
        and f1.sctope = f6.htoper
        and f1.scmod = f6.hmodul
        and f1.scstat = 99
        and f8.pgcod = f1.pgcod
        and f8.ctnro = f1.sccta
        and f8.cttfir = 'T'
        and fs.pepais = f8.pepais
        and fs.petdoc = f8.petdoc
        and fs.pendoc = f8.pendoc
        and f5.pgcod = f6.pgcod
        and f5.hcmod = f6.hcmod
        and f5.hsucor = f6.hsucor
        and f5.htran = f6.htran
        and f5.hnrel = f6.hnrel
        and f5.hfcon = f6.hfcon
        and f5.hccorr = 0
UNION
 select (select scnom from fst001 where sucurs = f1.hsucur) SUCURSAL,
        (select scnom from fst001 where sucurs = f1.hsucor) SUCCANCEL,
         decode(f1.hmda,0,'SOLES','DOLARES') MONEDA,
         (Lpad(trim(to_char(f1.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
        -- (Lpad(trim(to_char(f1.hcta)),9,'0') || Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0') || Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
         F1.HOPER OPERACION,
         (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.htoper) producto,
         F.AOFVAL FECHAAPER,
         F.AOFVTO FECHAVCTO,
         f1.hFCON fechacANCELACION,
         f8.pendoc  numdoc,
         fs.penom nombre,
         f1.hcimp1 Monto,
         (select aopzo
               from fsd010
              where pgcod = 1
                and aomod = 22
                and aosuc = f1.hsucur
                and aomda = f1.hmda
                and aopap = 0
                and aocta = hcta
                and aooper = f1.hoper
                and aosbop = f1.hsubop
                and aotope = f1.htoper) plazo,
            (select aotasa
               from fsd010
              where pgcod = 1
                and aomod = 22
                and aosuc = f1.hsucur
                and aomda = f1.hmda
                and aopap = 0
                and aocta = hcta
                and aooper = f1.hoper
                and aosbop = f1.hsubop
                and aotope = f1.htoper) tasa,
            f1.hcmod mODULO,
            f1.hmda MDA,
            f1.hpap PAP,
            f1.hcta CTA1,
            f1.hsucur SUC1,
            f1.hoper OPE1,
            f1.hsubop SUB1,
            f1.htoper TOP1
    from fsh016 f1,
         fsh015 f2,
         fsr008 f8,
         fsd001 fs,
         fsd012 f0,
         FSD010 F
   Where f1.Pgcod  =  1
     AND F1.HCTA = cuenta
     and f1.Hcmod  = 22
     and f1.Htran  in (300, 310)
     and f1.Hfcon Between ld_fecIni and ld_fecFin
    /* and f1.Hfcon Between (select  ADD_MONTHS (trunc(pgfape),-3) from fst017 where pgcod = 1)
                      AND (select trunc(pgfape) from fst017 where pgcod = 1)*/
     and f1.Hmodul  in (22,122)
     and f2.pgcod = f1.pgcod
     and f2.hcmod = f1.hcmod
     and f2.hsucor = f1.hsucor
     and f2.htran = f1.htran
     and f2.hnrel = f1.hnrel
     and f2.hfcon = f1.hfcon
     and f2.hccorr = 0
     and f8.pgcod = f1.pgcod
     and f8.ctnro = f1.hcta
     and f8.cttfir = 'T'
     and fs.pepais = f8.pepais
     and fs.petdoc = f8.petdoc
     and fs.pendoc = f8.pendoc
     and f0.pgcod(+) = f1.pgcod
     and f0.aomod(+) = f1.hmodul
     and f0.aosuc(+) = f1.hsucur
     and f0.aomda(+) = f1.hmda
     and f0.aopap(+) = f1.hpap
     and f0.aocta(+) = f1.hcta
     and f0.aooper(+) = f1.hoper
     and f0.aosbop(+) = f1.hsubop
     and f0.d012fc(+) = f1.hfcon
     AND F.PGCOD = F1.PGCOD
     AND F.AOMOD = F1.hmodul
     AND F.AOSUC = F1.hsucur
     AND F.AOMDA = F1.hmda
     AND F.AOPAP = F1.hpap
     AND F.AOCTA = F1.hcta
     AND F.AOOPER = f1.hoper
     AND F.AOSBOP = F1.hsubop
     AND F.AOTOPE = F1.HTOPER
union
select (select scnom from fst001 where sucurs = f6.ITSUCD) SUCURSAL,
       (select scnom from fst001 where sucurs = f6.itsuc) SUCCancel,
       decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
       (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
       F1.SCOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
       f1.scfval fechaaper,
       NULL fechavcto,
       (select pgfape from fst017 where pgcod = 1)  fechacancelacion,
       f8.pendoc numdoc,
       fs.penom nombre,
       f6.itimp1 MONTO,
       0 PLAZO,
       0 TASA,
          f1.Scmod mODULO,
          f1.Scmda MDA,
          f1.Scpap PAP,
          f1.Sccta CTA1,
          f1.Scsuc SUC1,
          f1.Scoper OPE1,
          f1.Scsbop SUB1,
          f1.Sctope TOP1
      from FSD016 f6,
           fsd015 f5,
           fsd011 f1,
           fsr008 f8,
           fsd001 fs
        Where f6.Pgcod = 1
          and f6.CTNRO = cuenta --- 1252018
          and f6.ITMOD = 21
          and f6.ittran = 905
          and f6.modulo = 21
          and f6.ittope <> 9
          and f6.moneda in (0,101)
          and f6.papel = 0
          AND f6.itord IN(75,24,22)
          and f5.pgcod = f6.pgcod
          and f5.itmod = f6.itmod
          and f5.itsuc = f6.itsuc
          and f5.ittran = f6.ittran
          and f5.itnrel = f6.itnrel
          and f5.itfcon between ld_fecIni and ld_fecFin
--          and f5.hfcon = f6.hfcon
          and f5.itcorr = 0
          and f5.itcont ='S'
          and f1.pgcod = f6.pgcod
          and f1.scsuc = f6.itsucd
          and f1.scmda = f6.moneda
          and f1.scpap = f6.papel
          and f1.sccta = f6.ctnro
          and f1.scoper = f6.itoper
          and f1.scsbop = f6.itsubo
          and f1.sctope = f6.ittope
          and f1.scmod  = f6.modulo
          and f1.scstat = 99
          and f8.pgcod = f1.pgcod
          and f8.ctnro = f1.sccta
          and f8.cttfir = 'T'
          and fs.pepais = f8.pepais
          and fs.petdoc = f8.petdoc
          and fs.pendoc = f8.pendoc

UNION
select (select scnom from fst001 where sucurs = f1.itsucd) SUCURSAL,
       (select scnom from fst001 where sucurs = f1.itsuc) SUCCANCEL,
       decode(f1.moneda, 0, 'SOLES', 'DOLARES') MONEDA,
       (Lpad(trim(to_char(f1.ctnro)), 9, '0') || '-' ||
       Lpad(trim(to_char(22)), 3, '0') || '-' ||
       Lpad(trim(to_char(f1.moneda)), 3, '0') || '-' ||
       Lpad(trim(to_char(f1.itoper)), 9, '0') || '-' ||
       Lpad(trim(to_char(f1.ittope)), 3, '0')) cuenta,
       -- (Lpad(trim(to_char(f1.hcta)),9,'0') || Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0') || Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
       F1.itOPER OPERACION,
       (SELECT TONOM
          FROM FST004
         WHERE MODULO = 22
           AND TOTOPE = f1.ittope) producto,
       F.AOFVAL FECHAAPER,
       F.AOFVTO FECHAVCTO,
       (select pgfape from fst017 where pgcod = 1) fechacANCELACION,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc) || ' ' ||
       f8.pendoc numdoc,
       fs.penom nombre,
       f1.itimp1 Monto,
       decode(f1.itmod,
              22,
              (select aopzo
                 from fsd010
                where pgcod = 1
                  and aomod = 22
                  and aosuc = f1.itsucd
                  and aomda = f1.moneda
                  and aopap = 0
                  and aocta = f1.ctnro
                  and aooper = f1.itoper
                  and aosbop = f1.itsubo
                  and aotope = f1.ittope),
              0) plazo,
       decode(f1.itmod,
              22,
              (select aotasa
                 from fsd010
                where pgcod = 1
                  and aomod = 22
                  and aosuc = f1.itsucd
                  and aomda = f1.moneda
                  and aopap = 0
                  and aocta = f1.ctnro
                  and aooper = f1.itoper
                  and aosbop = f1.itsubo
                  and aotope = f1.ittope),
              0)  tasa,
       f1.itmod mODULO,
       f1.moneda MDA,
       f1.papel PAP,
       f1.ctnro CTA1,
       f1.itsucd SUC1,
       f1.itoper OPE1,
       f1.itsubo SUB1,
       f1.ittope TOP1
          from fsd016 f1 ,
                 fsd015 f2,
                 fsr008 f8,
                 fsd001 fs,
                 fsd012 f0,
                 FSD010 F
         Where f1.Pgcod = 1
           AND F1.ctnro = cuenta --807948 ---1090326
           and f1.itmod = 22
           and f1.ittran in (300, 310)
           and f1.modulo in (22, 122)
           and f1.itord = 5
           and f2.pgcod = f1.pgcod
           and f2.itmod = f1.itmod
           and f2.itsuc = f1.itsuc
           and f2.ittran = f1.ittran
           and f2.itnrel = f1.itnrel
           --and f2.itfcon = f1.itfval
           and f2.itfcon between ld_fecIni and ld_fecFin
           and f2.itcorr = 0
           and f2.itcont = 'S'
           and f8.pgcod = f1.pgcod
           and f8.ctnro = f1.ctnro
           and f8.cttfir = 'T'
           and fs.pepais = f8.pepais
           and fs.petdoc = f8.petdoc
           and fs.pendoc = f8.pendoc
           and f0.pgcod(+) = f1.pgcod
           and f0.aomod(+) = f1.modulo
           and f0.aosuc(+) = f1.itsucd
           and f0.aomda(+) = f1.moneda
           and f0.aopap(+) = f1.papel
           and f0.aocta(+) = f1.ctnro
           and f0.aooper(+) = f1.itoper
           and f0.aosbop(+) = f1.itsubo
           and f0.d012fc(+) = f1.itfval
           AND F.PGCOD = F1.PGCOD
           AND F.AOMOD = F1.modulo
           AND F.AOSUC = F1.itsucd
           AND F.AOMDA = F1.moneda
           AND F.AOPAP = F1.papel
           AND F.AOCTA = F1.ctnro
           AND F.AOOPER = f1.itoper
           AND F.AOSBOP = F1.itsubo
           AND F.AOTOPE = F1.itTOPE
           order by fechacancelacion;


BEGIN

       for car in cartera(PUBUSER) loop
          For cta in cuentas(car.pais,car.tdoc, car.ndoc) loop
            For dat in datos(cta.ctnro) loop
              Begin
                 insert into JAQY682( JAQY682usu,
                                      JAQY682cta,
                                      JAQY682cli,
                                      JAQY682nop,
                                      JAQY682mto,
                                      JAQY682mda,
                                      JAQY682pzo,
                                      JAQY682tea,
                                      JAQY682AUX2,
                                      JAQY682fape,
                                      jaqy682fcan,
                                      JAQY682age,
                                      jaqy682dni,
                                     -- JAQY682AUX1,
                                      JAQY682eje,
                                      JAQY682top1,
                                      JAQY682subo1,
                                      JAQY682op1,
                                      JAQY682suc1,
                                      JAQY682nct,
                                      JAQY682pape,
                                      JAQY682mone,
                                      JAQY682modu,
                                      Jaqy682fvto                                      )
                              values(  Pusuario,
                                       dat.cuenta,
                                       dat.nombre,
                                       dat.operacion,
                                       dat.monto,
                                       dat.moneda,
                                       dat.plazo,
                                       dat.tasa,---tasa,
                                       dat.producto,
                                       dat.fechaaper,
                                       dat.fechacancelacion,
                                       dat.sucursal,
                                       dat.numdoc,
                                       --PREGNOM,
                                       PUBUSER,
                                       dat.top1,
                                       dat.sub1,
                                       dat.operacion,
                                       dat.suc1,
                                       dat.cta1,
                                       dat.pap,
                                       dat.mda,
                                       dat.modulo,
                                       dat.fechavcto
                                      );
              Exception
                when dup_val_on_index then
                  null;
              end;

            end loop;
            commit;
          end loop;
       end loop;

END PROCESO_CANCEL;
---------------------------------------------------------------
Procedure  Saldos_CARTERAA(ln_regcod  in number,
                           ln_suc     in number,
                           lc_ubuser  in varchar2,
                           ld_fecha   in date,
                           ln_Agencia in number,
                           ln_tipo    in number,
                           lc_user    in varchar2) is

    cursor Regiones is
      select regcod, regnom from fst810 where regcod <100 order by regnom;

    cursor Sucursales(region in number) is
      select f.oficod,
       (select scnom from fst001 where pgcod = 1 and sucurs = f.oficod) nom
       from fst811 f where regcod = region;

    cursor Ejecutivos(suc in number) is
      select jaql62user, jaql62SUCU
        from jaql062
       where jaql62pgco  = 1
         and jaql62sucu   = suc
         AND JAQL62ESTA = 'S';

    cursor Agencias_EA (usuario in char)is
      select jaql62user, jaql62SUCU
        from jaql062
       where jaql62pgco  = 1
         and jaql62user   = usuario
         AND JAQL62ESTA = 'S';

    cursor CARTERA (EJECUTIVO in char,SUCUR in number) is
       SELECT
              (SELECT regnom FROM FST811 A , FST810 B WHERE A.OFICOD = j1.jaql61au05 AND  B.REGCOD = A.REGCOD AND B.REGCOD < 100) RREG_CLI,
              (select scnom from fst001 where sucurs = j1.jaql61au05) SUCURSAL_CLI,
              (SELECT regnom FROM FST811 A , FST810 B WHERE A.OFICOD = f1.scsuc AND  B.REGCOD = A.REGCOD AND B.REGCOD < 100) REG_CTA,
              (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL_CTA,
               decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
               decode(f1.scmod,22, (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(F1.SCOPER)),9,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')),
                                  (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0'))) cuenta,
               (SELECT TONOM FROM FST004 WHERE MODULO = F1.scmod AND TOTOPE = f1.sctope) producto,
               j1.jaql61user eje_asig,
               trim(j1.jaql61au01) tipo_cli,
               --f1.scfval fechaApertura,
               f8.pepais PAIS,
               f8.petdoc TIP_DOC,
               f8.pendoc AS numdoc,
               (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc ) nombre,
               (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
                  f1.Scmod mODULO,
                  f1.Scmda MDA,
                  f1.Scpap PAP,
                  f1.Sccta CTA1,
                  f1.Scsuc SUC1,
                  f1.Scoper OPE1,
                  f1.Scsbop SUB1,
                  f1.Sctope TOP1,
                  F1.SCFVTO FVTO,
                  F1.SCRUB,
                  F1.SCSDO monto,
                  (SELECT b.regcod FROM FST811 A , FST810 B WHERE A.OFICOD = j1.jaql61au05 AND  B.REGCOD = A.REGCOD AND B.REGCOD < 100)  codreg,
                  j1.jaql61au05 codduc
                from jaql061 j1,
                     fsr008 f8,
                     fsd011 f1
               where j1.jaql61pgco = 1
                 and j1.jaql61user = EJECUTIVO --'EPINTO'
                 AND j1.JAQL61ESTA = 'S'
                 and j1.jaql61au05 = SUCUR --2
---    AND J1.JAQL61NDOC = '29729204' ---PRUEBA
                 and f8.pgcod = j1.jaql61pgco
                 and f8.pepais = j1.jaql61pais
                 and f8.petdoc = j1.jaql61tdoc
                 and f8.pendoc = j1.jaql61ndoc
                 and f8.cttfir = 'T'
                 and f1.pgcod = f8.pgcod
                 and f1.sccta = f8.ctnro
                 and f1.scmod in (21,22)
                 AND  F1.SCSDO > 1
-- AND F1.SCMDA =101                 
                 and f1.scstat <>99;
  lc_usuario char(10);
  ln_monto   number(17,2);
  ld_fecha1  date;
  ln_saldop  number(17,2);
  Ln_TC      number(17,2);

Begin

   if lc_ubuser ='0' then
     lc_usuario :='0';
   else
     lc_usuario := lc_ubuser;
   end if;

   delete jaqy700 where jaqy700usu = lc_user;
   commit;

   select pgfape
     into ld_fecha1
     from fst017
    where pgcod = 1;

   if ln_tipo = 1 then -- pUEDE VER TODO
     if ln_regcod = 0 or ln_regcod is null then
       for r in regiones loop
         if ln_suc = 0 or ln_suc is null then
           For s in sucursales(r.regcod) loop
             if lc_ubuser = '0' then
               For e in ejecutivos(s.oficod) loop
                   for car in Cartera(e.jaql62user, e.jaql62sucu) LOOP
                       monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                       if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                          IF ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              Jaqy700aux1,
                                              Jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              e.jaql62sucu,
                                              r.regcod,
                                              ln_saldop,
                                              Ln_TC
                                              );
                          end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                   END LOOP;
               end loop;
             else
               for car in Cartera(lc_ubuser, s.oficod) LOOP
                  monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                  if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                   else
                     ln_tc := 0;
                   end if;
                   begin
                     if ln_monto <> 0 then
                      INSERT INTO JAQY700(jaqy700cod,
                                          jaqy700usu,
                                          jaqy700regc,
                                          jaqy700agec,
                                          jaqy700reg,
                                          jaqy700age,
                                          jaqy700mda,
                                          jaqy700cta,
                                          jaqy700pro,
                                          jaqy700eje,
                                          jaqy700tcli,
                                          jaqy700pais,
                                          jaqy700tdoc,
                                          jaqy700ndoc,
                                          jaqy700ncli,
                                          jaqy700cont,
                                          jaqy700mod,
                                          jaqy700mda1,
                                          jaqy700pap1,
                                          jaqy700cta1,
                                          jaqy700suc1,
                                          jaqy700ope1,
                                          jaqy700sub1,
                                          jaqy700top1,
                                          jaqy700fech,
                                          jaqy700mto1,
                                          jaqy700aux3,
                                          jaqy700aux1,
                                          jaqy700aux2,
                                          JAQY700MTO2,
                                          JAQY700MTO3
                                          )
                                   VALUES(SQ_AH_JAQY700.NEXTVAL,
                                          lc_user,
                                          car.rreg_cli,
                                          car.sucursal_cli,
                                          car.reg_cta,
                                          car.sucursal_cta,
                                          car.moneda,
                                          car.cuenta,
                                          car.producto,
                                          car.eje_asig,
                                          car.tipo_cli,
                                          car.pais,
                                          car.tip_doc,
                                          car.numdoc,
                                          car.nombre,
                                          car.contador,
                                          car.modulo,
                                          car.mda,
                                          car.pap,
                                          car.cta1,
                                          car.suc1,
                                          car.ope1,
                                          car.sub1,
                                          car.top1,
                                          ld_fecha1,
                                          ln_monto,
                                          car.scrub,
                                          s.oficod,
                                          r.regcod,
                                          ln_saldop,
                                          Ln_TC
                                          );
                    end if;
                   exception
                      when dup_val_on_index then
                        null;
                   end;
               END LOOP;
             end if;
           end loop;
         else
           if lc_ubuser = '0' then--- is null then
              for e in Ejecutivos(ln_suc) loop
                   for car in Cartera(e.jaql62user,ln_suc) LOOP
                      monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                      if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              ln_suc,
                                              r.regcod,
                                              ln_saldop,
                                              Ln_TC
                                              );
                         end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                   END LOOP;
              end loop;
            else
               For reg in Agencias_EA(lc_usuario)loop
                   for car in Cartera(reg.jaql62user, reg.jaql62sucu) LOOP
                       monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                       if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              reg.jaql62sucu,
                                              car.codreg,
                                              ln_saldop,
                                              Ln_TC
                                              );
                        end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                   END LOOP;
               End loop;
            end if;
         end if;
       end loop;
     else
        if ln_suc = 0 or ln_suc is null then
          For s in sucursales(ln_regcod) loop
             if lc_ubuser ='0' then --is null then
               For e in ejecutivos(s.oficod) loop
                  for car in Cartera(e.jaql62user, e.jaql62sucu) LOOP
                      monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                      if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              car.codduc,
                                              car.codreg,
                                              ln_saldop,
                                              Ln_TC
                                              );
                         end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                  END LOOP;
               end loop;
             else
                for car in Cartera(lc_ubuser, s.oficod) LOOP
                  monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                       if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              car.codduc,
                                              car.codreg,
                                              ln_saldop,
                                              Ln_TC
                                              );
                         end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                END LOOP;
             end if;
          end loop;
        else
          if  lc_ubuser ='0' then---is null then
               For e in ejecutivos(ln_suc) loop
                  for car in Cartera(e.jaql62user, e.jaql62sucu) LOOP
                      monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                      if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              car.codduc,
                                              car.codreg,
                                              ln_saldop,
                                              Ln_TC
                                              );
                         end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                  END LOOP;
               end loop;
             else
                 for reg in Agencias_EA(lc_usuario)loop
                   for car in Cartera(reg.jaql62user, reg.jaql62sucu) LOOP
                       monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
                       if car.mda = 101 then
                          ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                            monori => 101,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                            ),2);
                       else
                         ln_tc := 0;
                       end if;
                       begin
                         if ln_monto <> 0 then
                          INSERT INTO JAQY700(jaqy700cod,
                                              jaqy700usu,
                                              jaqy700regc,
                                              jaqy700agec,
                                              jaqy700reg,
                                              jaqy700age,
                                              jaqy700mda,
                                              jaqy700cta,
                                              jaqy700pro,
                                              jaqy700eje,
                                              jaqy700tcli,
                                              jaqy700pais,
                                              jaqy700tdoc,
                                              jaqy700ndoc,
                                              jaqy700ncli,
                                              jaqy700cont,
                                              jaqy700mod,
                                              jaqy700mda1,
                                              jaqy700pap1,
                                              jaqy700cta1,
                                              jaqy700suc1,
                                              jaqy700ope1,
                                              jaqy700sub1,
                                              jaqy700top1,
                                              jaqy700fech,
                                              jaqy700mto1,
                                              jaqy700aux3,
                                              jaqy700aux1,
                                              jaqy700aux2,
                                              JAQY700MTO2,
                                              JAQY700MTO3
                                              )
                                       VALUES(SQ_AH_JAQY700.NEXTVAL,
                                              lc_user,
                                              car.rreg_cli,
                                              car.sucursal_cli,
                                              car.reg_cta,
                                              car.sucursal_cta,
                                              car.moneda,
                                              car.cuenta,
                                              car.producto,
                                              car.eje_asig,
                                              car.tipo_cli,
                                              car.pais,
                                              car.tip_doc,
                                              car.numdoc,
                                              car.nombre,
                                              car.contador,
                                              car.modulo,
                                              car.mda,
                                              car.pap,
                                              car.cta1,
                                              car.suc1,
                                              car.ope1,
                                              car.sub1,
                                              car.top1,
                                              ld_fecha1,
                                              ln_monto,
                                              car.scrub,
                                              car.codduc,
                                              car.codreg,
                                              ln_saldop,
                                              Ln_TC
                                              );
                        end if;
                       exception
                          when dup_val_on_index then
                            null;
                       end;
                   END LOOP;
                 end loop;
             end if;
        end if;
     end if;
else -- 2 EJECUTIVO SOLO SUS AGENCIAS ASIGNADAS
     if ln_agencia = 0 or ln_agencia is null then
       for reg in Agencias_EA(lc_usuario)loop
         for car in Cartera(reg.jaql62user, reg.jaql62sucu) LOOP
            monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
            if car.mda = 101 then
                ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                  monori => 101,
                                                                  mondes => 0,
                                                                  tipo   => 500
                                                                  ),2);
             else
               ln_tc := 0;
             end if;
           begin
             if ln_monto <> 0 then
              INSERT INTO JAQY700(jaqy700cod,
                                  jaqy700usu,
                                  jaqy700regc,
                                  jaqy700agec,
                                  jaqy700reg,
                                  jaqy700age,
                                  jaqy700mda,
                                  jaqy700cta,
                                  jaqy700pro,
                                  jaqy700eje,
                                  jaqy700tcli,
                                  jaqy700pais,
                                  jaqy700tdoc,
                                  jaqy700ndoc,
                                  jaqy700ncli,
                                  jaqy700cont,
                                  jaqy700mod,
                                  jaqy700mda1,
                                  jaqy700pap1,
                                  jaqy700cta1,
                                  jaqy700suc1,
                                  jaqy700ope1,
                                  jaqy700sub1,
                                  jaqy700top1,
                                  jaqy700fech,
                                  jaqy700mto1,
                                  jaqy700aux3,
                                  jaqy700aux1,
                                  jaqy700aux2,
                                  JAQY700MTO2,
                                  JAQY700MTO3
                                  )
                           VALUES(SQ_AH_JAQY700.NEXTVAL,
                                  lc_user,
                                  car.rreg_cli,
                                  car.sucursal_cli,
                                  car.reg_cta,
                                  car.sucursal_cta,
                                  car.moneda,
                                  car.cuenta,
                                  car.producto,
                                  car.eje_asig,
                                  car.tipo_cli,
                                  car.pais,
                                  car.tip_doc,
                                  car.numdoc,
                                  car.nombre,
                                  car.contador,
                                  car.modulo,
                                  car.mda,
                                  car.pap,
                                  car.cta1,
                                  car.suc1,
                                  car.ope1,
                                  car.sub1,
                                  car.top1,
                                  ld_fecha1,
                                  ln_monto,
                                  car.scrub,
                                  car.codduc,
                                  car.codreg,
                                  ln_saldop,
                                  Ln_TC
                                  );
            end if;                      
           exception
              when dup_val_on_index then
                null;
           end;
         END LOOP;
       end loop;
     else
       for car in Cartera(lc_ubuser, ln_agencia) LOOP
           monto_saldo(car.modulo, car.suc1,car.cta1, car.mda,car.ope1,car.top1,car.sub1,car.scrub,ld_fecha,ln_monto,ln_saldop);
           if car.mda = 101 then
              ln_TC := round(ln_monto * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                monori => 101,
                                                                mondes => 0,
                                                                tipo   => 500
                                                                ),2);
           else
             ln_tc := 0;
           end if;
           begin
             if ln_monto <> 0 then
              INSERT INTO JAQY700(jaqy700cod,
                                  jaqy700usu,
                                  jaqy700regc,
                                  jaqy700agec,
                                  jaqy700reg,
                                  jaqy700age,
                                  jaqy700mda,
                                  jaqy700cta,
                                  jaqy700pro,
                                  jaqy700eje,
                                  jaqy700tcli,
                                  jaqy700pais,
                                  jaqy700tdoc,
                                  jaqy700ndoc,
                                  jaqy700ncli,
                                  jaqy700cont,
                                  jaqy700mod,
                                  jaqy700mda1,
                                  jaqy700pap1,
                                  jaqy700cta1,
                                  jaqy700suc1,
                                  jaqy700ope1,
                                  jaqy700sub1,
                                  jaqy700top1,
                                  jaqy700fech,
                                  jaqy700mto1,
                                  jaqy700aux3,
                                  jaqy700aux1,
                                  jaqy700aux2,
                                  JAQY700MTO2,
                                  JAQY700MTO3
                                  )
                           VALUES(SQ_AH_JAQY700.NEXTVAL,
                                  lc_user,
                                  car.rreg_cli,
                                  car.sucursal_cli,
                                  car.reg_cta,
                                  car.sucursal_cta,
                                  car.moneda,
                                  car.cuenta,
                                  car.producto,
                                  car.eje_asig,
                                  car.tipo_cli,
                                  car.pais,
                                  car.tip_doc,
                                  car.numdoc,
                                  car.nombre,
                                  car.contador,
                                  car.modulo,
                                  car.mda,
                                  car.pap,
                                  car.cta1,
                                  car.suc1,
                                  car.ope1,
                                  car.sub1,
                                  car.top1,
                                  ld_fecha1,
                                  ln_monto,
                                  car.scrub,
                                  car.codduc,
                                  car.codreg,
                                  ln_saldop,
                                  Ln_TC
                                  );
             end if;                     
           exception
              when dup_val_on_index then
                null;
           end;
       END LOOP;
     end if;
   end if;
   commit;
end Saldos_CARTERAA;
PROCEDURE monto_saldo(ln_mod in number,
                      ln_suc in number,
                      ln_cta in number,
                      ln_mda in number,
                      ln_ope in number,
                      ln_top in number,
                      ln_sop in number,
                      ln_rub in number,
                      ld_fec in date,
                      ln_mto out number,
                      ln_sld out number)is

vscsdo number(17,2);
Capcts number := 0;
Intcts number := 0;
Rrrubr number;
Capaho number;
Totaho number;
saldo_total number(17,2):=0;
fecha date;
fecha1 date;
Intaho number;

Begin
   fecha:= ld_fec;
   case
          when ln_mod = 22 then --dpf
            begin
              select scsdo
                into vscsdo
                from fsd011
               where pgcod = 1
                 and scsuc = ln_suc
                 and scrub = ln_rub
                 and scmda = ln_mda
                 and scpap = 0
                 and sccta = ln_cta
                 and scoper = ln_ope
                 and scsbop = ln_sop
                 and sctope = ln_top;
            exception
              when no_data_found then
                vscsdo := 0;
            end;
            saldo_total := SALDO_TOTAL + vscsdo;

          when ln_top = 2 then --cts
            --cap intangible
            Capcts := 0;
            Intcts := 0;
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = ln_rub
                 and Rrcod = 169;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;

            begin
              select case
                       when Scsdo < 0 then
                        Scsdo * (-1)
                       else
                        Scsdo
                     end case
                into Capcts
                from FSD011
               Where Pgcod = 1
                 and Scsuc = ln_suc
                 and Scrub = Rrrubr
                 and Sccta = ln_cta
                 and Scmda = ln_mda
                 and Scpap = 0
                 and Scoper = ln_ope
                 and Scsbop = ln_sop;
            exception
              when no_data_found then
                Capcts := 0;
            end;
            --int intangible
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = ln_rub
                 and Rrcod = 1;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;
            begin
              select case
                       when Scsdo < 0 then
                        Scsdo * (-1)
                       else
                        Scsdo
                     end case
                into Intcts
                from FSD011
               Where Pgcod = 1
                 and Scsuc = ln_suc
                 and Scrub = Rrrubr
                 and Sccta = ln_cta
                 and Scmda = ln_mda
                 and Scpap = 0
                 and Scoper = ln_ope
                 and Scsbop = ln_sop;
            exception
              when no_data_found then
                Intcts := 0;
            end;
            VScsdo := Capcts + Intcts;
            saldo_total := SALDO_TOTAL + vscsdo;
          else

--            Bcfech := Hoy - 1 ;
            FECHA1 := FECHA -1;
            Capaho := 0;
            Intaho := 0;
            begin
--              BCEMP, BCSUC, BCRUBR, BCMDA, BCPAP, BCCTA, BCOPER, BCSBOP, BCTOP, BCFECH
              select sum(BCSdMO), count(*)
                into Capaho, Totaho
                from FSH012
               Where BCEmp = 1
                 and BCSuc = ln_suc
                 and BCRubr = ln_rub
                 and BCMda = ln_mda
                 and BCPap = 0
                 and BCCta = ln_cta
                 and BCOper = ln_ope
                 and BCSbOp = ln_sop
                 and BCTOp = ln_top
                 and BCFech = FECHA1; ---BCFECH; ----between Bcfech and Hoy;
            end;

            If Capaho IS NULL THEN
              Capaho := 0;
        /*    ELSE
              Capaho := Capaho / Totaho;*/
            End If;
            Totaho := 0;
            begin
              select Rrrubr
                into Rrrubr
                from FSR014
               Where Rubro = ln_rub
                 and Rrcod = 1;
            exception
              when no_data_found then
                Rrrubr := 0;
            end;

            begin
              select  sum(BCSdMO), count(*)
                into Intaho, Totaho
                from FSH012
               Where BCEmp = 1
                 and BCSuc = ln_suc
                 and BCRubr = Rrrubr
                 and BCMda = ln_mda
                 and BCPap = 0
                 and BCCta = ln_cta
                 and BCOper = ln_ope
                 and BCSbOp = ln_sop
                 and BCTOp = ln_top
                 and BCFech = FECHA1; --- BCFECH;-----BCFech between Bcfech and Hoy;
            end;
            If Intaho IS NULL then
              Intaho := 0;
          /*  Else
              Intaho := Intaho / Totaho;*/
            End If;

            VScsdo := Capaho + Intaho;
            saldo_total := SALDO_TOTAL + vscsdo;
        end case;
        ln_mto := saldo_total;
        

        begin
          select a.jaql483tot
            into ln_sld
            from jaql483 a
           where a.jaql483pgo = 1
             and a.jaql483suc = ln_suc
             and a.jaql483mda = ln_mda
             and a.jaql483pap = 0
             and a.jaql483cta = ln_cta
             and a.jaql483ope = ln_ope
             and a.jaql483sbo = ln_sop
             and a.jaql483tpo = ln_top
             and a.jaql483fch = (select max(jaql483fch)
                                   from jaql483
                                  where jaql483pgo = a.jaql483pgo
                                    and jaql483suc = a.jaql483suc
                                    and jaql483mda = a.jaql483mda
                                    and jaql483pap = 0
                                    and jaql483cta = a.jaql483cta
                                    and jaql483ope = a.jaql483ope
                                    and jaql483sbo = a.jaql483sbo
                                    and jaql483tpo = a.jaql483tpo);
        exception
          when no_Data_found then
            if ln_mod = 22 then
               ln_sld := ln_mto;
            else
               ln_sld := 0;
            end if;
             
          when too_many_rows then
            select a.jaql483tot
            into ln_sld
            from jaql483 a
           where a.jaql483pgo = 1
             and a.jaql483suc = ln_suc
             and a.jaql483mda = ln_mda
             and a.jaql483pap = 0
             and a.jaql483cta = ln_cta
             and a.jaql483ope = ln_ope
             and a.jaql483sbo = ln_sop
             and a.jaql483tpo = ln_top
             and a.jaql483fch = (select max(jaql483fch)
                                   from jaql483
                                  where jaql483pgo = a.jaql483pgo
                                    and jaql483suc = a.jaql483suc
                                    and jaql483mda = a.jaql483mda
                                    and jaql483pap = 0
                                    and jaql483cta = a.jaql483cta
                                    and jaql483ope = a.jaql483ope
                                    and jaql483sbo = a.jaql483sbo
                                    and jaql483tpo = a.jaql483tpo)
            and rownum = 1;
        end;
        if ln_mod = 22 then
          ln_sld := ln_mto;
        end if;  
End;
END PQ_AH_CONTROL_CARTERAASIGNADA;
/

