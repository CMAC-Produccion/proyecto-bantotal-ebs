CREATE OR REPLACE PACKAGE PQ_AH_CONTROL_SISBT IS
------------------------------------------------------
procedure SP_AH_GENERAINFO(lc_usuario in varchar2,
                           ld_fecini  in date,
                           ld_fecfin  in date,
                           lc_sucurs  in number,
                           ln_tiprep  in number);
------------------------------------------------------
procedure Proceso_Ahorro (Vusuario in varchar2,
                          Vfecini  in date,
                          Vfecfin  in date,
                          Vsucurs  in number);
procedure Proceso_DPF (Vusuario in varchar2,
                       Vfecini  in date,
                       Vfecfin  in date,
                       Vsucurs  in number);
procedure Proceso_CTS (Vusuario in varchar2,
                       Vfecini  in date,
                       Vfecfin  in date,
                       Vsucurs  in number);
END PQ_AH_CONTROL_SISBT;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_CONTROL_SISBT IS

procedure SP_AH_GENERAINFO(lc_usuario in varchar2,
                           ld_fecini  in date,
                           ld_fecfin  in date,
                           lc_sucurs  in number,
                           ln_tiprep  in number) IS
cursor sucursal is
    select sucurs, scnom
      from fst001;


Begin

  Delete jaqy675 where jaqy675USU = lc_usuario;--RPAD(lc_usuario,' ',10);
  Delete jaqy676 where jaqy676usu = lc_usuario;---RPAD(lc_usuario,' ',10);
  Delete jaqy677 where jaqy677usu = lc_usuario;---RPAD(lc_usuario,' ',10);
  commit;


  case
    when ln_tiprep = 1 then
      if lc_sucurs = 0 or lc_sucurs IS null then
        For reg in sucursal loop
          Proceso_Ahorro(lc_usuario,
                        ld_fecini,
                        ld_fecfin,
                        reg.sucurs);
        End loop;
      else
       Proceso_Ahorro(lc_usuario,
                      ld_fecini,
                      ld_fecfin,
                      lc_sucurs);
     end if;
    when ln_tiprep = 2 then
       if lc_sucurs = 0 or lc_sucurs IS null then
         For reg in sucursal loop
          Proceso_DPF(lc_usuario,
                      ld_fecini,
                      ld_fecfin,
                      reg.sucurs);
         End Loop;
       else
          Proceso_DPF(lc_usuario,
                      ld_fecini,
                      ld_fecfin,
                      lc_sucurs);
       end if;
    when ln_tiprep = 3 then
      if lc_sucurs = 0 or lc_sucurs IS null then
        For reg in sucursal loop
           Proceso_CTS(lc_usuario,
                    ld_fecini,
                    ld_fecfin,
                    reg.sucurs);
        End loop;
      else
        Proceso_CTS(lc_usuario,
                    ld_fecini,
                    ld_fecfin,
                    lc_sucurs);
      end if;
    else
     Delete jaqy675 where jaqy675USU = lc_usuario;--RPAD(lc_usuario,' ',10);
     Delete jaqy676 where jaqy676usu = lc_usuario;---RPAD(lc_usuario,' ',10);
     Delete jaqy677 where jaqy677usu = lc_usuario;---RPAD(lc_usuario,' ',10);
     commit;
  end case;
End SP_AH_GENERAINFO;
procedure Proceso_Ahorro (Vusuario in varchar2,
                          Vfecini  in date,
                          Vfecfin  in date,
                          Vsucurs  in number)is
pgcod number;
cursor AhorrosAPE is
     select (select t8.regnom
              from fst810 t8,
                   fst811 t1
             where t8.pgcod = 1
               and t8.regcod < 100
               and t1.pgcod = t8.pgcod
               and t1.regcod = t8.regcod
               and t1.oficod = f1.scsuc ) Region1,
           (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
           decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
           (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
           0.monto,
           F1.SCOPER OPERACION,
           (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
           f1.scfval fechaIni,
           (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
           fs.penom nombre,
           (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
           fs.petipo TIPOPER,
           FN_FACULTAD_CTA(f1.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2,     
           /* nvl((select decode (R2SBOP, 1,'INDIVIDUAL',501,'INDISTINTA',502,'INDISTINTA',503,'INDISTINTA',
                                     504,'INDISTINTA',505,'INDISTINTA',506,'INDISTINTA',507,'INDISTINTA',
                                     508,'INDISTINTA',509,'INDISTINTA',510,'INDISTINTA',511,'MANCOMUNADA')
                 from fsr011  --FSE130
                Where R1cod = 1              
                   and R1mod = f1.scmod
                   and R1suc = f1.scsuc
                   and R1mda = f1.scmda
                   and R1pap = f1.scpap
                   and R1cta = f1.sccta
                   and R1oper = f1.scoper
                   and R1sbop = f1.scsbop --// revisar porq se quitó
                   and R1tope = f1.sctope
                   and Relcod = 5 
                   and rownum = 1),'INDIVIDUAL') tipocta2,*/
            (SELECT trim(Cv1Aux6) FROM FSE113
              Where Pgcod   = f1.pgcod
              and Cv1mod  = f1.Scmod
              and Cv1mda  = f1.Scmda
              and Cv1pap  = f1.Scpap
              and Cv1cta  = f1.Sccta
              and Cv1suc  = f1.Scsuc
              and Cv1oper = f1.Scoper
              and Cv1sbop = f1.Scsbop
              and Cv1tope = f1.Sctope) OPERADOR,
             (select f5.agteusr  from fsr012 f2, fst156 f5
               where f2.relcod = 77
                 and f2.p1cta =f1.sccta
                 and f5.agtecod = f2.p1ndoc
                 AND ROWNUM = 1) Agente,
              0 plazo,
              0 tea,
              f1.Scmod mODULO,
              f1.Scmda MDA,
              f1.Scpap PAP,
              f1.Sccta CTA1,
              f1.Scsuc SUC1,
              f1.Scoper OPE1,
              f1.Scsbop SUB1,
              f1.Sctope TOP1
      from fsd011 f1,
           fsr008 f8,
           fsd001 fs
    Where f1.Pgcod = 1
      and f1.Scmod  = 21
      and f1.Scmda in (0,101)
      and f1.Scpap = 0
      and f1.Scsuc  = Vsucurs
      and f1.Sctope <> 2
      and f1.Scfval Between Vfecini and Vfecfin
      and f1.scstat <> 99
      and f8.pgcod = f1.pgcod
      and f8.ctnro = f1.sccta
      and f8.cttfir = 'T'
      and fs.pepais = f8.pepais
      and fs.petdoc = f8.petdoc
      and fs.pendoc = f8.pendoc
      order by  f1.scfcon,f1.scmda;

  cursor CancelAHO is
  select (select t8.regnom
          from fst810 t8,
               fst811 t1
         where t8.pgcod = 1
           and t8.regcod < 100
           and t1.pgcod = t8.pgcod
           and t1.regcod = t8.regcod
           and t1.oficod = f1.scsuc ) Region1,
       (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
       (select scnom from fst001 where sucurs = f6.hsucor) SUCCancel,
       decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
       (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
       F1.SCOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
       f1.scfval fechaIni,
       f6.hfcon fechacan,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
       fs.penom nombre,
       (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
       fs.petipo TIPOPER,
       FN_FACULTAD_CTA(f6.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2,                                          
       /* nvl((select decode (R2SBOP, 1,'INDIVIDUAL',501,'INDISTINTA',502,'INDISTINTA',503,'INDISTINTA',
                                     504,'INDISTINTA',505,'INDISTINTA',506,'INDISTINTA',507,'INDISTINTA',
                                     508,'INDISTINTA',509,'INDISTINTA',510,'INDISTINTA',511,'MANCOMUNADA')
                 from fsr011  --FSE130
                Where R1cod = 1              
                   and R1mod = f1.scmod
                   and R1suc = f1.scsuc
                   and R1mda = f1.scmda
                   and R1pap = f1.scpap
                   and R1cta = f1.sccta
                   and R1oper = f1.scoper
                   and R1sbop = f1.scsbop --// revisar porq se quitó
                   and R1tope = f1.sctope
                   and Relcod = 5 
                   and rownum = 1),'INDIVIDUAL') tipocta2,*/
         f5.husing operador,
         (select j.jaql61user  from jaql061 j
           where j.jaql61pgco = 1
             and j.jaql61pais = f8.pepais
             and j.jaql61tdoc = f8.petdoc
             and j.jaql61ndoc = f8.pendoc
             AND J.JAQL61ESTA = 'S'
             AND ROWNUM = 1) Agente,
          f6.hcimp1 MONTO,
          f1.Scmod mODULO,
          f1.Scmda MDA,
          f1.Scpap PAP,
          f1.Sccta CTA1,
          f1.Scsuc SUC1,
          f1.Scoper OPE1,
          f1.Scsbop SUB1,
          f1.Sctope TOP1,
          f1.scsdo
      from FSH016 f6,
           fsh015 f5,
           fsd011 f1,
           fsr008 f8,
           fsd001 fs
        Where f6.Pgcod = 1
         and f6.Hcmod = 21
        and f6.hsucur = Vsucurs
        and f6.Htran = 905   
        and f6.Hfcon between Vfecini and Vfecfin
        and f6.Hmodul = 21
        and f6.Htoper <> 2
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
        order by f6.hfcon,f6.Hmda;

   cursor cancelHoyAho is
   select (select t8.regnom
          from fst810 t8,
               fst811 t1
         where t8.pgcod = 1
           and t8.regcod < 100
           and t1.pgcod = t8.pgcod
           and t1.regcod = t8.regcod
           and t1.oficod = f1.scsuc ) Region1,
       (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
       (select scnom from fst001 where sucurs = f6.itsuc) SUCURCANCELACION,
       decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
       (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
       F1.SCOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
       f1.scfval fechaIni,
       f5.itfcon FechaCancelacion,
       f1.scfvto FechaVcto,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
       fs.penom nombre,
       (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
       fs.petipo TIPOPER,
       FN_FACULTAD_CTA(f6.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2, 
         f5.ituing OPERADOR,
         (select j.jaql61user  from jaql061 j
           where j.jaql61pgco = 1
             and j.jaql61pais = f8.pepais
             and j.jaql61tdoc = f8.petdoc
             and j.jaql61ndoc = f8.pendoc
             AND ROWNUM = 1) Agente,
          f6.itimp1 MONTO,
          f1.Scmod mODULO,
          f1.Scmda MDA,
          f1.Scpap PAP,
          f1.Sccta CTA1,
          f1.Scsuc SUC1,
          f1.Scoper OPE1,
          f1.Scsbop SUB1,
          f1.Sctope TOP1,
          f1.scsdo
from FSD016 f6,
     fsd015 f5,
     fsd011 f1,
     fsr008 f8,
     fsd001 fs
  Where f6.Pgcod = 1
   and f6.itmod = 21
  and f6.itsucd = Vsucurs
  and f6.ittran = 905
  and f6.itord in (22,24) ---(84,85,86,87,88) and f6..itfcon between '04/05/2015' and '04/05/2015'-- and hnrel = 18 and  hsucor =11
  and f6.modulo = 21
  and f6.ittope <> 2
  and f6.moneda in (0,101)
  and f6.papel = 0
  and f5.pgcod = f6.pgcod
  and f5.itsuc = f6.itsuc
  and f5.itmod = f6.itmod
  and f5.ittran = f6.ittran
  and f5.itnrel = f6.itnrel
  and f5.itcorr = 0
  and f5.itcont = 'S'
  and f1.pgcod = f6.pgcod
  and f1.scsuc = f6.itsucd
  and f1.scmda = f6.moneda
  and f1.scpap = f6.papel
  and f1.sccta = f6.ctnro
  and f1.scoper = f6.itoper
  and f1.scsbop = f6.itsubo
  and f1.sctope = f6.ittope
  and f1.scmod = f6.modulo
  and f1.scstat = 99
  and f8.pgcod = f1.pgcod
  and f8.ctnro = f1.sccta
  and f8.cttfir = 'T'
  and fs.pepais = f8.pepais
  and fs.petdoc = f8.petdoc
  and fs.pendoc = f8.pendoc
  order by f5.itfcon,f6.moneda;


  --cont number;
  cont1 number;
  fecha date;
  tasa number;
  tipocuenta varchar2(12);
  SUCORI  number;
  FCON    date;
  PTRMOD  number;
  PTRNRO  number;
  NREL    number;
  IMPMOV  number;

Begin
  ---- Cuentas Nuevas Ahorro
--  cont := 1;
  Pgcod := 1;
  select pgfape into fecha from fst017 where pgcod = 1 ;
  
  FOR reg in AhorrosAPE loop
    PQ_SEGMENTACION_CLIENTES_PAS.sp_tasa(Pgcod,reg.suc1,reg.cta1,reg.mda,reg.pap,reg.ope1,reg.sub1,reg.top1,reg.modulo,tasa);
    SP_DEPO_CV(pgcod,reg.suc1,reg.modulo,reg.mda,reg.pap,reg.cta1,reg.ope1,reg.sub1,reg.top1, Vfecini,Vfecfin,SUCORI,FCON,PTRMOD,PTRNRO,NREL, IMPMOV);
    
    IF reg.tipoper = 'J' then
      tipocuenta := 'INDIVIDUAL';
    ELSE
      if reg.contador = 1 then
        tipocuenta := 'INDIVIDUAL';
      else  
        tipocuenta := REG.TIPOCTA2;
      end if;  
    END IF;
    
    insert into jaqy675(jaqy675cod,
                        jaqy675usu,
                        jaqy675cta,
                        jaqy675cli,
                        jaqy675nop,
                        jaqy675mto,
                        jaqy675tcta,
                        jaqy675mda,
                        jaqy675pzo,
                        jaqy675tea,
                        jaqy675tpro,
                        jaqy675fape,
                        jaqy675age,
                        jaqy675reg,
                        jaqy675oape,
                        jaqy675eje,
                        jaqy675top1,
                        jaqy675subo1,
                        jaqy675op1,
                        jaqy675suc1,
                        jaqy675nct,
                        jaqy675pape,
                        jaqy675mone,
                        jaqy675modu)
                 values( SQ_AH_JAQY675.NEXTVAL,
                         Vusuario,
                         reg.cuenta,
                         reg.nombre,
                         reg.operacion,
                         IMPMOV,
                         tipocuenta,-- reg.tipocta2,
                         reg.moneda,
                         reg.plazo,
                         tasa,
                         reg.producto,
                         reg.fechaini,
                         reg.sucursal,
                         reg.region1,
                         reg.operador,
                         reg.agente,
                         reg.top1,
                         reg.sub1,
                         reg.operacion,
                         reg.suc1,
                         reg.cta1,
                         reg.pap,
                         reg.mda,
                         reg.modulo
                        );

  end loop;
  commit;
  cont1 :=1 ;
  -- cuentas de ahorros Cancelados
  for reg1 in CancelAHO loop
     
    IF reg1.tipoper = 'J' then
      tipocuenta := 'INDIVIDUAL';
    ELSE
      if reg1.contador = 1 then
        tipocuenta := 'INDIVIDUAL';
      else  
        tipocuenta := REG1.TIPOCTA2;
      end if;  
    END IF;
    insert into jaqy676 (jaqy676cod,
                      jaqy676usu,
                      jaqy676cta,
                      jaqy676cli,
                      jaqy676nop,
                      jaqy676sop,
                      jaqy676tcta,
                      jaqy676mda,
                      jaqy676mcan,
                      jaqy676fcan,
                      jaqy676age,
                      jaqy676reg,
                      jaqy676ocan,
                      jaqy676eje,
                      jaqy676aux3,
                      jaqy676aux4)
               values(SQ_AH_JAQY676.NEXTVAL,
                      Vusuario,
                      reg1.cuenta,
                      reg1.nombre,
                      reg1.operacion,
                      reg1.sub1,
                      tipocuenta,--reg1.tipocta2,
                      reg1.moneda,
                      reg1.monto,
                      reg1.fechacan,
                      reg1.sucursal,
                      reg1.region1,
                      reg1.operador,
                      reg1.agente,
                      null,
                      reg1.succancel
                      );
          cont1:= cont1 + 1;
  end loop;
  commit;
  if Vfecfin = fecha then
    For reg2 in cancelHoyAho loop
      IF reg2.tipoper = 'J' then
      tipocuenta := 'INDIVIDUAL';
    ELSE
      if reg2.contador = 1 then
        tipocuenta := 'INDIVIDUAL';
      else  
        tipocuenta := REG2.TIPOCTA2;
      end if;  
    END IF;
 
      insert into jaqy676 (jaqy676cod,
                      jaqy676usu,
                      jaqy676cta,
                      jaqy676cli,
                      jaqy676nop,
                      jaqy676sop,
                      jaqy676tcta,
                      jaqy676mda,
                      jaqy676mcan,
                      jaqy676fcan,
                      jaqy676age,
                      jaqy676reg,
                      jaqy676ocan,
                      jaqy676eje,
                      jaqy676aux3,
                      jaqy676aux4)
               values(SQ_AH_JAQY676.NEXTVAL,
                      vusuario,
                      reg2.cuenta,
                      reg2.nombre,
                      reg2.operacion,
                      reg2.sub1,
                      tipocuenta,--reg2.tipocta2,
                      reg2.moneda,
                      reg2.monto,
                      reg2.fechacancelacion,
                      reg2.sucursal,
                      reg2.region1,
                      reg2.operador,
                      reg2.agente,
                      reg2.producto,
                      reg2.sucurcancelacion);

                   cont1 := cont1 + 1;
    End loop;
    commit;
  end if;
end Proceso_Ahorro;

procedure Proceso_DPF (Vusuario in varchar2,
                       Vfecini  in date,
                       Vfecfin  in date,
                       Vsucurs  in number) is
   ----aaperturas
   cursor APERDPF is
          select (select t8.regnom
              from fst810 t8,
                   fst811 t1
             where t8.pgcod = 1
               and t8.regcod < 100
               and t1.pgcod = t8.pgcod
               and t1.regcod = t8.regcod
               and t1.oficod = f1.hsucur ) Region1,
           (select scnom from fst001 where sucurs = f1.hsucur) SUCURSAL,
           (select scnom from fst001 where sucurs = f1.hsucor) SUCcancel,
           decode(f1.hmda,0,'SOLES','DOLARES') MONEDA,
           --(Lpad(trim(to_char(f1.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
           F1.HOPER OPERACION,
           (Lpad(trim(to_char(f1.hcta)),9,'0') ||Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0')|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
           (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.htoper) producto,
           f1.hfcon fechaape,
           fd.aofvto,
           (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
           trim(fs.penom) nombre,
           (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.hcta) CONTADOR,
           fs.petipo TIPOPER,
           FN_FACULTAD_CTA(f1.pgcod,f1.hsucur,f1.hmda, f1.hpap,f1.hcta,f1.hoper,f1.hsubop,f1.htoper,f1.hmodul) tipocta2,
         /*  nvl((select decode (R2SBOP, 1,'INDIVIDUAL',501,'INDISTINTA',502,'INDISTINTA',503,'INDISTINTA',
                                     504,'INDISTINTA',505,'INDISTINTA',506,'INDISTINTA',507,'INDISTINTA',
                                     508,'INDISTINTA',509,'INDISTINTA',510,'INDISTINTA',511,'MANCOMUNADA')
                 from fsr011  --FSE130
                Where R1cod = 1              
                   and R1mod = f1.hmodul
                   and R1suc = f1.hsucur
                   and R1mda = f1.hmda
                   and R1pap = f1.hpap
                   and R1cta = f1.hcta
                   and R1oper = f1.hoper
                   and R1sbop = f1.hsubop --// revisar porq se quitó
                   and R1tope = f1.htoper
                   and Relcod = 5 
                   and rownum = 1),'INDIVIDUAL') tipocta2,*/
            f2.husing OPERADOR,
             (select f5.agteusr  from fsr012 fs2, fst156 f5
               where fs2.relcod = 77
                 and fs2.p1cta =f1.hcta
                 and f5.agtecod = fs2.p1ndoc
                 AND ROWNUM = 1) Agente,
              f1.hcimp1 Monto,
              f1.hcpzo plazo,
              f1.hctasa tasa,
              f1.hcmod mODULO,
              f1.hmda MDA,
              f1.hpap PAP,
              f1.hcta CTA1,
              f1.hsucur SUC1,
              f1.hoper OPE1,
              f1.hsubop SUB1,
              f1.htoper TOP1,
              NVL( (SELECT TP1DESC FROM FST198
                Where Tp1cod   = 1
                AND Tp1cod1  = 10864
                AND Tp1corr1 = 1
                AND Tp1corr2 = 1
                AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
              f0.evcorr,
              f0.evtipo
      from fsh016 f1,
           fsh015 f2,
           fsr008 f8,
           fsd001 fs,
           fsd012 f0,
           fsd010 fd
     Where f1.Pgcod  =  1
       and f1.Hcmod  = 22
       and f1.hsucur = Vsucurs
       and f1.Htran  in (600,800)
       and f1.Hfcon  between Vfecini and Vfecfin
       and f1.Hmodul  in (22,122)
       and f1.Hsubop = 0
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
       and f0.pgcod = f1.pgcod
       and f0.aomod = f1.hmodul
       and f0.aosuc = f1.hsucur
       and f0.aomda = f1.hmda
       and f0.aopap = f1.hpap
       and f0.aocta = f1.hcta
       and f0.aooper = f1.hoper
       and f0.aosbop = f1.hsubop
       and fd.pgcod = f1.pgcod
       and fd.aomod = f1.hmodul
       and fd.aosuc = f1.hsucur
       and fd.aomda = f1.hmda
       and fd.aopap = f1.hpap
       and fd.aocta = f1.hcta
       and fd.aooper = f1.hoper
       and fd.aosbop = f1.hsubop
      order by  f1.hfcon,f1.hmda;

  cursor APEDPFHOY is
        select (select t8.regnom
            from fst810 t8,
                 fst811 t1
           where t8.pgcod = 1
             and t8.regcod < 100
             and t1.pgcod = t8.pgcod
             and t1.regcod = t8.regcod
             and t1.oficod = f1.itsucd ) Region1,
         (select scnom from fst001 where sucurs = f1.itsucd) SUCURSAL,
         (select scnom from fst001 where sucurs = f1.itsucd) SUCAPER,
         decode(f1.moneda,0,'SOLES','DOLARES') MONEDA,
---         (Lpad(trim(to_char(f1.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.itoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
         (Lpad(trim(to_char(f1.ctnro)),9,'0') || Lpad(trim(to_char(22)),3,'0') || Lpad(trim(to_char(f1.moneda)),3,'0')|| Lpad(trim(to_char(f1.itoper)),9,'0') || Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
         F1.itoper OPERACION,
         (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.ittope) producto,
         f1.itfval  fechaAPE,
         Fd.Aofvto fechaVTO,
         (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
         fs.penom nombre,
         (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.ctnro) CONTADOR,
         fs.petipo TIPOPER,
         FN_FACULTAD_CTA(f1.pgcod,f1.itsucd,f1.moneda, f1.papel,f1.ctnro,f1.itoper,f1.itsubo,f1.ittope,f1.modulo) tipocta2, 
  /*        nvl((select decode (R2SBOP, 1,'INDIVIDUAL',501,'INDISTINTA',502,'INDISTINTA',503,'INDISTINTA',
                                     504,'INDISTINTA',505,'INDISTINTA',506,'INDISTINTA',507,'INDISTINTA',
                                     508,'INDISTINTA',509,'INDISTINTA',510,'INDISTINTA',511,'MANCOMUNADA')
                 from fsr011  --FSE130
                Where R1cod = 1              
                   and R1mod = f1.modulo
                   and R1suc = f1.itsucd
                   and R1mda = f1.moneda
                   and R1pap = f1.papel
                   and R1cta = f1.ctnro
                   and R1oper = f1.itoper
                   and R1sbop = f1.itsubo --// revisar porq se quitó
                   and R1tope = f1.ittope
                   and Relcod = 5 
                   and rownum = 1),'INDIVIDUAL') tipocta2,*/
          f2.ituing OPERADOR,
           (select f5.agteusr  from fsr012 fs2, fst156 f5
             where fs2.relcod = 77
               and fs2.p1cta =f1.ctnro
               and f5.agtecod = fs2.p1ndoc
               AND ROWNUM = 1) Agente,
            f1.itimp1 monto,
            f1.itpzo plazo,
            f1.ittasa tasa,
            f1.modulo mODULO,
            f1.moneda MDA,
            f1.papel PAP,
            f1.ctnro CTA1,
            f1.itsucd SUC1,
            f1.itoper OPE1,
            f1.itsubo SUB1,
            f1.ittope TOP1,
            NVL( (SELECT TP1DESC FROM FST198
              Where Tp1cod   = 1
              AND Tp1cod1  = 10864
              AND Tp1corr1 = 1
              AND Tp1corr2 = 1
              AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
            f0.evcorr,
            f0.evtipo
    from fsd016 f1,
         fsd015 f2,
         fsr008 f8,
         fsd001 fs,
         fsd012 f0,
         fsd010 fd
   Where f1.Pgcod  =  1
     and f1.itmod  = 22
     and f1.itsucd = Vsucurs
     and f1.ittran  in (600,800)
     and f1.modulo  in (22,122)
     and f1.itsubo = 0
     and f2.pgcod = f1.pgcod
     and f2.itmod = f1.itmod
     and f2.itsuc = f1.itsuc
     and f2.ittran = f1.ittran
     and f2.itnrel = f1.itnrel
     and f2.itfcon = (select pgfape from fst017 where pgcod = 1)
     and f2.itcorr = 0
     and f2.itcont = 'S'
     and f8.pgcod = f1.pgcod
     and f8.ctnro = f1.ctnro
     and f8.cttfir = 'T'
     and fs.pepais = f8.pepais
     and fs.petdoc = f8.petdoc
     and fs.pendoc = f8.pendoc
     and f0.pgcod = f1.pgcod
     and f0.aomod = f1.modulo
     and f0.aosuc = f1.itsucd
     and f0.aomda = f1.moneda
     and f0.aopap = f1.papel
     and f0.aocta = f1.ctnro
     and f0.aooper = f1.itoper
     and f0.aosbop = f1.itsubo
     and fd.pgcod = f1.pgcod
     and fd.aomod = f1.modulo
     and fd.aosuc = f1.itsucd
     and fd.aomda = f1.moneda
     and fd.aopap = f1.papel
     and fd.aocta = f1.ctnro
     and fd.aooper = f1.itoper
     and fd.aosbop = f1.itsubo
    order by  f1.moneda,f1.itfval;
    ---DPF Cancelados
    cursor DPFCANCEL is
          select (select t8.regnom
            from fst810 t8,
                 fst811 t1
           where t8.pgcod = 1
             and t8.regcod < 100
             and t1.pgcod = t8.pgcod
             and t1.regcod = t8.regcod
             and t1.oficod = f1.hsucur ) Region1,
         (select scnom from fst001 where sucurs = f1.hsucur) SUCURSAL,
         (select scnom from fst001 where sucurs = f1.hsucor) SUCCANCEL,
         decode(f1.hmda,0,'SOLES','DOLARES') MONEDA,
--         (Lpad(trim(to_char(f1.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
         (Lpad(trim(to_char(f1.hcta)),9,'0') || Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0') || Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
         F1.HOPER OPERACION,
         (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.htoper) producto,
         F.AOFVAL FECHAAPER,
         F.AOFVTO FECHAVCTO,
         f1.hFCON fechacANCELACION,
         (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
         fs.penom nombre,
         (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.hcta) CONTADOR,
         fs.petipo TIPOPER,
          FN_FACULTAD_CTA(f1.pgcod,f1.hsucur,f1.hmda, f1.hpap,f1.hcta,f1.hoper,f1.hsubop,f1.htoper,f1.hmodul) tipocta2,
          f2.husing OPERADOR,
           (select j.jaql61user  from jaql061 j
             where j.jaql61pgco = 1
               and j.jaql61pais = f8.pepais
               and j.jaql61tdoc = f8.petdoc
               and j.jaql61ndoc = f8.pendoc
               AND j.jaql61fech = (select max(jaql61fech)from jaql061 where jaql61ndoc = f8.pendoc)
               and rownum = 1) Agente,
            f1.hcimp1 Monto,
            f1.hcpzo plazo,
            f1.hctasa tasa,
            f1.hcmod mODULO,
            f1.hmda MDA,
            f1.hpap PAP,
            f1.hcta CTA1,
            f1.hsucur SUC1,
            f1.hoper OPE1,
            f1.hsubop SUB1,
            f1.htoper TOP1,
            NVL( (SELECT TP1DESC FROM FST198
              Where Tp1cod   = 1
              AND Tp1cod1  = 10864
              AND Tp1corr1 = 1
              AND Tp1corr2 = 1
              AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
            f0.evcorr,
            f0.evtipo
    from fsh016 f1,
         fsh015 f2,
         fsr008 f8,
         fsd001 fs,
         fsd012 f0,
         FSD010 F
   Where f1.Pgcod  =  1
     and f1.Hcmod  = 22
     and f1.hsucur = Vsucurs
     and f1.Htran  in (300, 310)
     and f1.Hfcon  between vfecini and vfecfin
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
     and not exists ( select hcimp1 from FSH016
                       Where Pgcod = 1
                         and Hcmod = 22
                         and Htran in (800,600)
                         and Hfcon = f1.hfcon
                         and Hsucur = f1.hsucur
                         and Hcta = f1.hcta
                         and Hmodul = f1.hmodul
                         and hToper = f1.htoper
                         and hmda = f1.hmda
                         and Hcord in (5,10)
                         and Hoper <> 0)
    order by  f1.hfcon,f1.hmda;

   cursor DPFCANCELHOY IS
         select (select t8.regnom
                from fst810 t8,
                     fst811 t1
               where t8.pgcod = 1
                 and t8.regcod < 100
                 and t1.pgcod = t8.pgcod
                 and t1.regcod = t8.regcod
                 and t1.oficod = f1.itsucd ) Region1,
             (select scnom from fst001 where sucurs = f1.itsucd) SUCURSAL,
             (select scnom from fst001 where sucurs = f1.itsuc) SUCURSALCAncelacion,
             decode(f1.moneda,0,'SOLES','DOLARES') MONEDA,
---             (Lpad(trim(to_char(f1.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.itoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
             (Lpad(trim(to_char(f1.ctnro)),9,'0') || Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.moneda)),3,'0') || Lpad(trim(to_char(f1.itoper)),9,'0') || Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
             F1.itOPER OPERACION,
             (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.ittope) producto,
             F.AOFVAL FECHAAPER,
             F.AOFVTO FECHAVCTO,
             f2.itFCON fechacANCELACION,
             (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
             fs.penom nombre,
             (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.CTNRO) CONTADOR,
              fs.petipo TIPOPER,
              FN_FACULTAD_CTA(f1.pgcod,f1.itsucd,f1.moneda, f1.papel,f1.ctnro,f1.itoper,f1.itsubo,f1.ittope,f1.modulo) tipocta2,
              f2.ituing OPERADOR,
             (select j.jaql61user  from jaql061 j
                 where j.jaql61pgco = 1
                   and j.jaql61pais = f8.pepais
                   and j.jaql61tdoc = f8.petdoc
                   and j.jaql61ndoc = f8.pendoc
                   AND j.jaql61fech = (select max(jaql61fech)from jaql061 where jaql61ndoc = f8.pendoc)
                   and j.jaql61esta = 'S'
                   AND ROWNUM = 1) Agente,
                F1.ITIMP1 MONTO,
                f1.itpzo plazo,
                f1.ittasa tasa,
                f1.modulo mODULO,
                f1.moneda MDA,
                f1.papel PAP,
                f1.ctnro CTA1,
                f1.itsucd SUC1,
                f1.itoper OPE1,
                f1.itsubo SUB1,
                f1.ittope TOP1,
                NVL( (SELECT TP1DESC FROM FST198
                  Where Tp1cod   = 1
                  AND Tp1cod1  = 10864
                  AND Tp1corr1 = 1
                  AND Tp1corr2 = 1
                  AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
                f0.evcorr,
                f0.evtipo
        from fsd016 f1,
             fsd015 f2,
             fsr008 f8,
             fsd001 fs,
             fsd012 f0,
             FSD010 F
       Where f1.Pgcod  =  1
         and f1.Itsucd = VSUCURS
         and f1.Itmod = 22
         and f1.Ittran in (300,310)
         and f1.Modulo in (22,122)
         and f1.Ittope in (1,2)
         and f1.Moneda in (0,101)
         and f1.Papel = 0
         and f1.itord = 5
         and f2.pgcod = f1.pgcod
         and f2.itmod = f1.itmod
         and f2.itsuc = f1.itsuc
         and f2.ittran = f1.ittran
         and f2.itnrel = f1.itnrel
         and f2.itcorr = 0
         and f2.itfcon = (select pgfape from fst017 where pgcod = 1)
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
         AND F.PGCOD = F.PGCOD
         AND F.AOMOD = F1.modulo
         AND F.AOSUC = F1.itsucd
         AND F.AOMDA = F1.moneda
         AND F.AOPAP = f1.papel
         AND F.AOCTA = F1.ctnro
         AND F.AOOPER = F1.itoper
         AND F.AOSBOP = F1.itsubo
         AND F.AOTOPE = F1.itTOPE
         and not exists(select 1 from FSD016
                          Where Pgcod  =  1
                             and itmod  = 22
                             and itsucd = f1.itsucd
                             and ittran  in (600,800)
                             and modulo  in (22,122)
                             and ctnro = f1.ctnro
                             and itsubo > 0)
         order by f1.moneda;
   ---DPF RENOVADAS

   CURSOR RENAUTO IS
      select (select t8.regnom
          from fst810 t8,
               fst811 t1
         where t8.pgcod = 1
           and t8.regcod < 100
           and t1.pgcod = t8.pgcod
           and t1.regcod = t8.regcod
           and t1.oficod = f1.hsucUr ) Region1,
       (select scnom from fst001 where sucurs = f1.hsucor) sucCancelacion,
       (select scnom from fst001 where sucurs = f1.hsucur) SUCURSAL,
       decode(f1.hmda,0,'SOLES','DOLARES') MONEDA,
--       (Lpad(trim(to_char(f1.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
      (Lpad(trim(to_char(f1.hcta)),9,'0')|| Lpad(trim(to_char(22)),3,'0') || Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0')|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,

       F1.HOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.htoper) producto,
       F.AOFVAL FECHAAPER,
       F.AOFVTO FECHAVCTO,
       f1.hFCON fechacANCELACION,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
       fs.penom nombre,
       (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.HCTA) CONTADOR,
       fs.petipo TIPOPER,
       FN_FACULTAD_CTA(f1.pgcod,f1.hsucur,f1.hmda, f1.hpap,f1.hcta,f1.hoper,f1.hsubop,f1.htoper,f1.hmodul) tipocta2,
--        f2.husing OPERADOR,
        'REN.AUTO.' OPERADOR,
        (select j.jaql61user  from jaql061 j
           where j.jaql61pgco = 1
             and j.jaql61pais = f8.pepais
             and j.jaql61tdoc = f8.petdoc
             and j.jaql61ndoc = f8.pendoc
             AND j.jaql61fech = (select max(jaql61fech)from jaql061 where jaql61ndoc = f8.pendoc)
             AND ROWNUM = 1) Agente,
          f1.hcimp1 Monto,
          f1.hcpzo plazo,
          f1.hctasa tasa,
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
               FSD010 F
           Where f1.Pgcod  =  1
             and f1.Hcmod  = 99
             and f1.hsucur = Vsucurs
             and f1.Htran  =999
             and f1.Hfcon  between Vfecini and Vfecfin
             and f1.Hmodul  in (22,122)
             and f1.hcord = 6             
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
             AND F.PGCOD = f1.pgcod
             AND F.AOMOD = f1.hmodul
             AND F.AOSUC = f1.hsucur
             AND F.AOMDA = F1.Hmda
             AND F.AOPAP = f1.hpap
             AND F.AOCTA = F1.hCTA
             AND F.AOOPER = f1.hoper
             AND F.AOSBOP = f1.hsubop
             AND F.AOTOPE = f1.htoper
            order by  f1.hfcon,f1.hmda;

    Cursor RENVUNO is
    select (select t8.regnom
          from fst810 t8,
               fst811 t1
         where t8.pgcod = 1
           and t8.regcod < 100
           and t1.pgcod = t8.pgcod
           and t1.regcod = t8.regcod
           and t1.oficod = f1.hsucur ) Region1,
       (select scnom from fst001 where sucurs = f1.hsucur) SUCURSAL,
       (select scnom from fst001 where sucurs = f1.hsucor) SUCURSALCancelacion,
       decode(f1.hmda,0,'SOLES','DOLARES') MONEDA,
--      (Lpad(trim(to_char(f1.hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
      (Lpad(trim(to_char(f1.hcta)),9,'0')|| Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.hmda)),3,'0')|| Lpad(trim(to_char(f1.hoper)),9,'0')|| Lpad(trim(to_char(f1.htoper)),3,'0'))cuenta,
       F1.HOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.htoper) producto,
       F.AOFVAL FECHAAPER,
       F.AOFVTO FECHAVCTO,
       f1.hFCON fechacANCELACION,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
       fs.penom nombre,
       (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.HCTA) CONTADOR,
       fs.petipo TIPOPER,
          FN_FACULTAD_CTA(f1.pgcod,f1.hsucur,f1.hmda, f1.hpap,f1.hcta,f1.hoper,f1.hsubop,f1.htoper,f1.hmodul) tipocta2,
        f2.husing OPERADOR,
         (select j.jaql61user  from jaql061 j
           where j.jaql61pgco = 1
             and j.jaql61pais = f8.pepais
             and j.jaql61tdoc = f8.petdoc
             and j.jaql61ndoc = f8.pendoc
             AND j.jaql61fech = (select max(jaql61fech)from jaql061 where jaql61ndoc = f8.pendoc)
             AND ROWNUM = 1) Agente,
          f1.hcimp1 Monto,
          ( select hcimp1 from FSH016
                 Where Pgcod = 1
                   and Hcmod = 22
                   and Htran in (800,600)
                   and Hfcon = f1.hfcon
                   and Hsucur = f1.hsucur
                   and Hcta = f1.hcta
                   and Hmodul = f1.hmodul
                   and hToper = f1.htoper
                   and hmda = f1.hmda
                   and Hcord in (5,10)
                   and Hoper <> 0
                   AND ROWNUM = 1)  MontoAPE,
          f1.hcpzo plazo,
          f1.hctasa tasa,
          f1.hcmod mODULO,
          f1.hmda MDA,
          f1.hpap PAP,
          f1.hcta CTA1,
          f1.hsucur SUC1,
          f1.hoper OPE1,
          f1.hsubop SUB1,
          f1.htoper TOP1,
          NVL( (SELECT TP1DESC FROM FST198
            Where Tp1cod   = 1
            AND Tp1cod1  = 10864
            AND Tp1corr1 = 1
            AND Tp1corr2 = 1
            AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
          f0.evcorr,
          f0.evtipo
  from fsh016 f1,
       fsh015 f2,
       fsr008 f8,
       fsd001 fs,
       fsd012 f0,
       FSD010 F
 Where f1.Pgcod  =  1
   and f1.Hcmod  = 22
   and f1.hsucur = vsucurs
   and f1.Htran  in (300, 310)
   and f1.Hfcon  between vfecini and Vfecfin
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
   AND F.AOOPER = F1.hoper
   AND F.AOSBOP = F1.hsubop
   AND F.AOTOPE = F1.HTOPER
   and exists ( select hcimp1 from FSH016
                 Where Pgcod = 1
                   and Hcmod = 22
                   and Htran in (800,600)
                   and Hfcon = f1.hfcon
                   and Hsucur = f1.hsucur
                   and Hcta = f1.hcta
                   and Hmodul = f1.hmodul
                   and hToper = f1.htoper
                   and hmda = f1.hmda
                   and Hcord in (5,10)
                   and Hoper <> 0)
  order by  f1.hfcon,f1.hmda;

  cursor RENHOY is
  select (select t8.regnom
          from fst810 t8,
               fst811 t1
         where t8.pgcod = 1
           and t8.regcod < 100
           and t1.pgcod = t8.pgcod
           and t1.regcod = t8.regcod
           and t1.oficod = f1.itsucd ) Region1,
       (select scnom from fst001 where sucurs = f1.itsucd) SUCURSAL,
       (select scnom from fst001 where sucurs = f1.itsuc) SUCcancel,
       decode(f1.moneda,0,'SOLES','DOLARES') MONEDA,
--       (Lpad(trim(to_char(f1.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char(f1.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.itoper)),9,'0') ||'-'|| Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
        (Lpad(trim(to_char(f1.ctnro)),9,'0')|| Lpad(trim(to_char(22)),3,'0')|| Lpad(trim(to_char(f1.moneda)),3,'0')|| Lpad(trim(to_char(f1.itoper)),9,'0')|| Lpad(trim(to_char(f1.ittope)),3,'0'))cuenta,
       F1.itOPER OPERACION,
       (SELECT TONOM FROM FST004 WHERE MODULO = 22 AND TOTOPE = f1.ittope) producto,
       F.AOFVAL FECHAAPER,
       F.AOFVTO FECHAVCTO,
       f2.itFCON fechacANCELACION,
       (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
       fs.penom nombre,
       (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.CTNRO) CONTADOR,
       fs.petipo TIPOPER,
       FN_FACULTAD_CTA(f1.pgcod,f1.itsucd,f1.moneda, f1.papel,f1.ctnro,f1.itoper,f1.itsubo,f1.ittope,f1.modulo) tipocta2,       
       f2.ituing OPERADOR,
         (select j.jaql61user  from jaql061 j
           where j.jaql61pgco = 1
             and j.jaql61pais = f8.pepais
             and j.jaql61tdoc = f8.petdoc
             and j.jaql61ndoc = f8.pendoc
             AND j.jaql61fech = (select max(jaql61fech)from jaql061 where jaql61ndoc = f8.pendoc)
             and j.jaql61esta = 'S'
             AND ROWNUM = 1) Agente,
          f1.itimp1 monto,
          f1.itpzo plazo,
          f1.ittasa tasa,
          f1.modulo mODULO,
          f1.moneda MDA,
          f1.papel PAP,
          f1.ctnro CTA1,
          f1.itsucd SUC1,
          f1.itoper OPE1,
          f1.itsubo SUB1,
          f1.ittope TOP1,
          NVL( (SELECT TP1DESC FROM FST198
            Where Tp1cod   = 1
            AND Tp1cod1  = 10864
            AND Tp1corr1 = 1
            AND Tp1corr2 = 1
            AND Tp1corr3 = f0.evtipo),'NORMAL') tIPTASA,
          f0.evcorr,
          f0.evtipo
  from fsd016 f1,
       fsd015 f2,
       fsr008 f8,
       fsd001 fs,
       fsd012 f0,
       FSD010 F
 Where f1.Pgcod  =  1
   and f1.Itsucd = vsucurs
   and f1.Itmod = 22
   and f1.Ittran in (300,310)
   and f1.Modulo in (22,122)
   and f1.Ittope in (1,2)
   and f1.Moneda in (0,101)
   and f1.Papel = 0
   and f1.itord = 5
   and f2.pgcod = f1.pgcod
   and f2.itmod = f1.itmod
   and f2.itsuc = f1.itsuc
   and f2.ittran = f1.ittran
   and f2.itnrel = f1.itnrel
   and f2.itcorr = 0
   and f2.itfcon = (select pgfape from fst017 where pgcod = 1)
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
   AND F.PGCOD = F1.PGCOD
   AND F.AOMOD = F1.modulo
   AND F.AOSUC = F1.itsucd
   AND F.AOMDA = F1.moneda
   AND F.AOPAP = F1.papel
   AND F.AOCTA = F1.ctnro
   AND F.AOOPER = F1.itoper
   AND F.AOSBOP = F1.itsubo
   AND F.AOTOPE = F1.Ittope
   and exists(select 1 from FSD016
                    Where Pgcod  =  1
                       and itmod  = 22
                       and itsucd = f1.itsucd
                       and ittran  in (600,800)
                       and modulo  in (22,122)
                       and ctnro = f1.ctnro
                       and itsubo = 0
                       )
  order by  f1.moneda;
  tipocuenta VARCHAR2(12);
  fecha date;
Begin
  select pgfape into fecha from fst017 where pgcod = 1 ;
---aperturas
     For reg in APERDPF loop
        IF reg.tipoper = 'J' then
          tipocuenta := 'INDIVIDUAL';
        ELSE
          if reg.contador = 1 then
            tipocuenta := 'INDIVIDUAL';
          else  
            tipocuenta := REG.TIPOCTA2;
          end if;  
        END IF;
        insert into jaqy675(jaqy675cod,
                            jaqy675usu,
                            jaqy675cta,
                            jaqy675cli,
                            jaqy675nop,
                            jaqy675mto,
                            jaqy675tcta,
                            jaqy675mda,
                            jaqy675pzo,
                            jaqy675tea,
                            jaqy675ttasa,
                          ---  jaqy675tpro,
                            jaqy675fape,
                            jaqy675fvto,
                            jaqy675age,
                            jaqy675reg,
                            jaqy675oape,
                            jaqy675eje,
                            jaqy675modu,
                            jaqy675mone,
                            jaqy675pape,
                            jaqy675nct,
                            jaqy675suc1,
                            jaqy675op1,
                            jaqy675subo1,
                            jaqy675top1)
                 values( SQ_AH_JAQY675.NEXTVAL,
                         Vusuario,
                         SUBSTR(reg.cuenta,1,30),
                         SUBSTR(reg.nombre,1,60),
                         reg.operacion,
                         reg.monto,
                         TIPOCUENTA,---reg.tipocta2,
                         reg.moneda,
                         reg.plazo,
                         reg.tasa,
                         substr(reg.tiptasa,1,20),
                         reg.fechaape,
                         reg.aofvto,
                         reg.sucursal,
                         reg.region1,
                         reg.operador,
                         reg.agente,
                         reg.modulo,
                         reg.mda,
                         reg.pap,
                         reg.cta1,
                         reg.suc1,
                         reg.operacion,
                         reg.sub1,
                         reg.top1);
     end loop;
    commit;
    -- cancelaciones DPF
   For reg3 in DPFCANCEL loop
      IF reg3.tipoper = 'J' then
        tipocuenta := 'INDIVIDUAL';
      ELSE
        if reg3.contador = 1 then
          tipocuenta := 'INDIVIDUAL';
        else  
          tipocuenta := REG3.TIPOCTA2;
        end if;  
      END IF;
     insert into jaqy676 (jaqy676cod,
                          jaqy676usu,
                          jaqy676cta,
                          jaqy676cli,
                          jaqy676nop,
                          jaqy676sop,
                          jaqy676tcta,
                          jaqy676mda,
                          jaqy676mcan,
                          jaqy676fvto,
                          jaqy676fcan,
                          jaqy676age,
                          jaqy676reg,
                          jaqy676ocan,
                          jaqy676eje,
                          jaqy676aux1,
                          jaqy676aux3)
                   values(SQ_AH_JAQY676.NEXTVAL,
                          Vusuario,
                          reg3.cuenta,
                          reg3.nombre,
                          reg3.operacion,
                          reg3.sub1,
                          reg3.tipocta2,
                          reg3.moneda,
                          reg3.monto,
                          reg3.fechavcto,
                          reg3.fechacancelacion,
                          reg3.sucursal,
                          reg3.region1,
                          reg3.operador,
                          reg3.agente,
                          reg3.tasa,
                          reg3.tiptasa);
   end loop;
   commit;

   ---Renovadas
   FOR REG5 IN RENAUTO LOOP
     IF reg5.tipoper = 'J' then
        tipocuenta := 'INDIVIDUAL';
      ELSE
        if reg5.contador = 1 then
          tipocuenta := 'INDIVIDUAL';
        else  
          tipocuenta := REG5.TIPOCTA2;
        end if;  
      END IF;
     insert into jaqy677(jaqy677cod,
                          jaqy677usu,
                          jaqy677cta,
                          jaqy677cli,
                          jaqy677nop,
                          jaqy677sop,
                          jaqy677tcta,
                          jaqy677mda,
                          jaqy677mcap,
                          jaqy677fvto,
                          jaqy677frenv,
                          jaqy677age,
                          jaqy677reg,
                          jaqy677aux3,---operador
                          jaqy677eje,
                          jaqy677tea,--verificar jaqy677ttasa,
                          jaqy677ttasa,
                          jaqy677aux1)
                   values(SQ_AH_JAQY677.NEXTVAL,
                          vusuario,
                          reg5.cuenta,
                          reg5.nombre,
                          reg5.operacion,
                          reg5.sub1,
                          TIPOCUENTA,---reg5.tipocta2,
                          reg5.moneda,
                          reg5.monto,
                          reg5.fechavcto,
                          reg5.fechacancelacion,
                          reg5.sucursal,
                          reg5.region1,
                          trim(reg5.operador),
                          reg5.agente,
                          reg5.tasa,
                          'Automatica',
                          reg5.plazo);
   END LOOP;
   commit;

   For reg1 in RENVUNO loop
      IF reg1.tipoper = 'J' then
        tipocuenta := 'INDIVIDUAL';
      ELSE
        if reg1.contador = 1 then
          tipocuenta := 'INDIVIDUAL';
        else  
          tipocuenta := REG1.TIPOCTA2;
        end if;  
      END IF;
      insert into jaqy677(jaqy677cod,
                          jaqy677usu,
                          jaqy677cta,
                          jaqy677cli,
                          jaqy677nop,
                          jaqy677sop,
                          jaqy677tcta,
                          jaqy677mda,
                          jaqy677mcap,
                          jaqy677fvto,
                          jaqy677frenv,
                          jaqy677age,
                          jaqy677reg,
                          jaqy677aux3,---operador
                          jaqy677eje,
                          jaqy677tea,--verificar jaqy677ttasa,
                          jaqy677ttasa,
                          jaqy677aux1)
                   values(SQ_AH_JAQY677.NEXTVAL,
                          vusuario,
                          reg1.cuenta,
                          reg1.nombre,
                          reg1.operacion,
                          reg1.sub1,
                          TIPOCUENTA,---reg1.tipocta2,
                          reg1.moneda,
                          reg1.monto,
                          reg1.fechavcto,
                          reg1.fechacancelacion,
                          reg1.sucursal,
                          reg1.region1,
                          trim(reg1.operador),
                          reg1.agente,
                          reg1.tasa,
                          reg1.tiptasa,
                          reg1.plazo);
   end loop;
   commit;
    if Vfecfin = fecha then
      ---aperturas
       For reg1 in APEDPFHOY loop
         IF reg1.tipoper = 'J' then
             tipocuenta := 'INDIVIDUAL';
         ELSE
          if reg1.contador = 1 then
            tipocuenta := 'INDIVIDUAL';
          else  
            tipocuenta := REG1.TIPOCTA2;
          end if;  
         END IF;
        insert into jaqy675(jaqy675cod,
                            jaqy675usu,
                            jaqy675cta,
                            jaqy675cli,
                            jaqy675nop,
                            jaqy675mto,
                            jaqy675tcta,
                            jaqy675mda,
                            jaqy675pzo,
                            jaqy675tea,
                            jaqy675ttasa,
                          ---  jaqy675tpro,
                            jaqy675fape,
                            jaqy675fvto,
                            jaqy675age,
                            jaqy675reg,
                            jaqy675oape,
                            jaqy675eje,
                            jaqy675modu,
                            jaqy675mone,
                            jaqy675pape,
                            jaqy675nct,
                            jaqy675suc1,
                            jaqy675op1,
                            jaqy675subo1,
                            jaqy675top1)
                 values( SQ_AH_JAQY675.NEXTVAL,
                         Vusuario,
                         reg1.cuenta,
                         reg1.nombre,
                         reg1.operacion,
                         reg1.monto,
                         TIPOCUENTA,---reg1.tipocta2,
                         reg1.moneda,
                         reg1.plazo,
                         reg1.tasa,
                         reg1.tiptasa,
                         reg1.fechaape,
                         reg1.fechavto,
                         reg1.sucursal,
                         reg1.region1,
                         reg1.operador,
                         reg1.agente,
                         reg1.modulo,
                         reg1.mda,
                         reg1.pap,
                         reg1.cta1,
                         reg1.suc1,
                         reg1.operacion,
                         reg1.sub1,
                         reg1.top1);
     end loop;
    commit;
    -- Cancelacion
    fOR REG4 IN DPFCANCELHOY LOOP
      IF reg4.tipoper = 'J' then
             tipocuenta := 'INDIVIDUAL';
         ELSE
          if reg4.contador = 1 then
            tipocuenta := 'INDIVIDUAL';
          else  
            tipocuenta := REG4.TIPOCTA2;
          end if;  
         END IF;
      INSERT INTO JAQY676(jaqy676cod,
                          jaqy676usu,
                          jaqy676cta,
                          jaqy676cli,
                          jaqy676nop,
                          jaqy676sop,
                          jaqy676tcta,
                          jaqy676mda,
                          jaqy676mcan,
                          jaqy676fvto,
                          jaqy676fcan,
                          jaqy676age,
                          jaqy676reg,
                          jaqy676ocan,
                          JAQY676AUX3,
                          jaqy676eje)
                   VALUES(SQ_AH_JAQY676.NEXTVAL,
                          VUSUARIO,
                          REG4.CUENTA,
                          REG4.NOMBRE,
                          REG4.OPERACION,
                          REG4.SUB1,
                          TIPOCUENTA,--REG4.TIPOCTA2,
                          REG4.MONEDA,
                          REG4.MONTO,
                          REG4.FECHAVCTO,
                          REG4.FECHACANCELACION,
                          REG4.SUCURSAL,
                          REG4.REGION1,
                          REG4.OPERADOR,
                          trim(reg4.tiptasa),
                          REG4.AGENTE);
    END LOOP;
    commit;
    ---renovacion
       For reg1 in RENHOY loop
        IF reg1.tipoper = 'J' then
             tipocuenta := 'INDIVIDUAL';
         ELSE
          if reg1.contador = 1 then
            tipocuenta := 'INDIVIDUAL';
          else  
            tipocuenta := REG1.TIPOCTA2;
          end if;  
         END IF;
      insert into jaqy677(jaqy677cod,
                          jaqy677usu,
                          jaqy677cta,
                          jaqy677cli,
                          jaqy677nop,
                          jaqy677sop,
                          jaqy677tcta,
                          jaqy677mda,
                          jaqy677mcap,
                          jaqy677fvto,
                          jaqy677frenv,
                          jaqy677age,
                          jaqy677reg,
                          jaqy677aux3,---operador
                          jaqy677eje,
                          jaqy677tea,--verificar jaqy677ttasa,
                          jaqy677ttasa,
                          jaqy677aux1)
                   values(SQ_AH_JAQY677.NEXTVAL,
                          vusuario,
                          reg1.cuenta,
                          reg1.nombre,
                          reg1.operacion,
                          reg1.sub1,
                          TIPOCUENTA,--reg1.tipocta2,
                          reg1.moneda,
                          reg1.monto,
                          reg1.fechavcto,
                          reg1.fechacancelacion,
                          reg1.sucursal,
                          reg1.region1,
                          trim(reg1.operador),
                          reg1.agente,
                          reg1.tasa,
                          reg1.tiptasa,
                          reg1.plazo);
   end loop;
   commit;


    end if;


end Proceso_DPF;
procedure Proceso_CTS (Vusuario in varchar2,
                       Vfecini  in date,
                       Vfecfin  in date,
                       Vsucurs  in number)is
  cursor APECTS is
      select (select t8.regnom
              from fst810 t8,
                   fst811 t1
             where t8.pgcod = 1
               and t8.regcod < 100
               and t1.pgcod = t8.pgcod
               and t1.regcod = t8.regcod
               and t1.oficod = f1.scsuc ) Region1,
           (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
           decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
           (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
           F1.SCOPER OPERACION,
           (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
           f1.scfval fechaIni,
           f1.scsdo monto,
           (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
           fs.penom nombre,
           (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
            fs.petipo TIPOPER,
            FN_FACULTAD_CTA(f1.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2, 
            (SELECT TRIM(Cv1Aux6) FROM FSE113
              Where Pgcod   = f1.pgcod
              and Cv1mod  = f1.Scmod
              and Cv1mda  = f1.Scmda
              and Cv1pap  = f1.Scpap
              and Cv1cta  = f1.Sccta
              and Cv1suc  = f1.Scsuc
              and Cv1oper = f1.Scoper
              and Cv1sbop = f1.Scsbop
              and Cv1tope = f1.Sctope) OPERADOR,
             (SELECT F5.AGTEUSR 
                      FROM FSR012 F2, FST156 F5 
                       WHERE P1COD = 1 
                       and f2.P1MOD = f1.scmod 
                       and f2.P1SUC = f1.scsuc 
                       and f2.P1MDA = f1.scmda
                       and f2.P1PAP = f1.scpap
                       and f2.P1CTA = f1.sccta
                       and f2.P1OPER = f1.scoper
                       and f2.P1SBOP = f1.scsbop
                       and f2.P1TOPE = f1.sctope                       
                       and F2.RELCOD = 77 
                       AND F5.AGTECOD = F2.P1NDOC 
                       and rownum = 1) AGENTE, 
              f1.Scmod mODULO,
              f1.Scmda MDA,
              f1.Scpap PAP,
              f1.Sccta CTA1,
              f1.Scsuc SUC1,
              f1.Scoper OPE1,
              f1.Scsbop SUB1,
              f1.Sctope TOP1

      from fsd011 f1,
           fsr008 f8,
           fsd001 fs
    Where f1.Pgcod = 1
      and f1.Scmod  = 21
      and f1.scoper = 0
      and f1.Scmda in (0,101)
      and f1.Scpap = 0
      and f1.Scsuc  = vsucurs
      and f1.Sctope = 2
      and f1.Scfval Between Vfecini and Vfecfin
      and f1.scstat <> 99
      and f8.pgcod = f1.pgcod
      and f8.ctnro = f1.sccta
      and f8.cttfir = 'T'
      and fs.pepais = f8.pepais
      and fs.petdoc = f8.petdoc
      and fs.pendoc = f8.pendoc
      order by  f1.scfcon, f1.scmda;

  Cursor CTSCANCEL is
             select (select t8.regnom
                  from fst810 t8,
                       fst811 t1
                 where t8.pgcod = 1
                   and t8.regcod < 100
                   and t1.pgcod = t8.pgcod
                   and t1.regcod = t8.regcod
                   and t1.oficod = f1.scsuc ) Region1,
               (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
               (select scnom from fst001 where sucurs = f6.hsucor) succancel,
               decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
               (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
               F1.SCOPER OPERACION,
               f6.hcord ordinal,
               (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
               f1.scfval fechaIni,
               f5.hfcon fechaCan,
               (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
               fs.penom nombre,
               (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
                fs.petipo TIPOPER,
                FN_FACULTAD_CTA(f1.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2, 
                 TRIM(f5.husing) OPERADOR,
            (select j.jaql61user  from jaql061 j
                   where j.jaql61pgco = 1
                     and j.jaql61pais = f8.pepais
                     and j.jaql61tdoc = f8.petdoc
                     and j.jaql61ndoc = f8.pendoc
                     and j.jaql61fech = (select Max(jaql61fech) from jaql061 where jaql61ndoc = j.jaql61ndoc)
                     AND ROWNUM = 1) Agente,
                  f6.hcimp1 MONTO,
                  f1.Scmod mODULO,
                  f1.Scmda MDA,
                  f1.Scpap PAP,
                  f1.Sccta CTA1,
                  f1.Scsuc SUC1,
                  f1.Scoper OPE1,
                  f1.Scsbop SUB1,
                  f1.Sctope TOP1,
                  f1.scsdo
        from FSH016 f6,
             fsh015 f5,
             fsd011 f1,
             fsr008 f8,
             fsd001 fs
          Where f6.Pgcod = 1
           and f6.Hcmod = 21
          and f6.Hsucur = Vsucurs
          and f6.Htran = 905
          and f6.hcord IN (75,22,24)
          and f6.Hfcon between Vfecini and Vfecfin-- and hnrel = 18 and  hsucor =11
          and f6.Hmodul = 21
          and f6.Htoper = 2
          and f6.Hmda in (0,101)
          and f6.Hpap = 0
          and f5.pgcod = f6.pgcod
          and f5.hcmod = f6.hcmod
          and f5.hsucor = f6.hsucor
          and f5.htran = f6.htran
          and f5.hnrel = f6.hnrel
          and f5.hfcon = f6.hfcon
          and f5.hccorr = 0
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
          order by f6.hmda, f6.hfcon;
          
  Cursor CTSCANCELhoy is        
      select (select t8.regnom
                from fst810 t8,
                     fst811 t1
               where t8.pgcod = 1
                 and t8.regcod < 100
                 and t1.pgcod = t8.pgcod
                 and t1.regcod = t8.regcod
                 and t1.oficod = f1.scsuc ) Region1,
             (select scnom from fst001 where sucurs = f1.scsuc) SUCURSAL,
             (select scnom from fst001 where sucurs = f6.itsuc) succancel,
             decode(f1.scmda,0,'SOLES','DOLARES') MONEDA,
             (Lpad(trim(to_char(f1.sccta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scmda)),3,'0') ||'-'|| Lpad(trim(to_char(f1.scsbop)),2,'0') ||'-'|| Lpad(trim(to_char(f1.sctope)),3,'0')) cuenta,
             F1.SCOPER OPERACION,
             (SELECT TONOM FROM FST004 WHERE MODULO = 21 AND TOTOPE = f1.sctope) producto,
             f1.scfval fechaIni,
             f5.itfcon fechacan,
             f1.scfvto FechaVcto,
             (select trim(tdnom) from fst014 where tdocum = fs.petdoc)||' '||fs.pendoc as numdoc,
             fs.penom nombre,
             (SELECT COUNT(*) FROM FSR008 WHERE CTNRO = f1.Sccta) CONTADOR,
              fs.petipo TIPOPER,
              FN_FACULTAD_CTA(f6.pgcod,f1.scsuc,f1.scmda, f1.scpap,f1.sccta,f1.scoper,f1.scsbop,f1.sctope,f1.scmod) tipocta2, 
               f5.ituing OPERADOR,
               (select j.jaql61user  from jaql061 j
                 where j.jaql61pgco = 1
                   and j.jaql61pais = f8.pepais
                   and j.jaql61tdoc = f8.petdoc
                   and j.jaql61ndoc = f8.pendoc
                   AND ROWNUM = 1) Agente,
                f6.itimp9 MONTO,
                f1.Scmod mODULO,
                f1.Scmda MDA,
                f1.Scpap PAP,
                f1.Sccta CTA1,
                f1.Scsuc SUC1,
                f1.Scoper OPE1,
                f1.Scsbop SUB1,
                f1.Sctope TOP1,
                f1.scsdo
      from FSD016 f6,
           fsd015 f5,
           fsd011 f1,
           fsr008 f8,
           fsd001 fs
        Where f6.Pgcod = 1
         and f6.itmod = 21
        and f6.itsucd = Vsucurs
        and f6.ittran = 905
--        and f6.itord  = 75--in (22,24) ---(84,85,86,87,88) and f6..itfcon between '04/05/2015' and '04/05/2015'-- and hnrel = 18 and  hsucor =11
        and f6.modulo = 21
        and f6.ittope = 2
        and f6.moneda in (0,101)
        and f6.papel = 0
        and f5.pgcod = f6.pgcod
        and f5.itsuc = f6.itsuc
        and f5.itmod = f6.itmod
        and f5.ittran = f6.ittran
        and f5.itnrel = f6.itnrel
        and f5.itcorr = 0
        and f5.itcont = 'S'
        and f5.itfcon = (select pgfape from fst017 where pgcod = 1)
        and f1.pgcod = f6.pgcod
  --      and f1.scsuc = f6.itsucd
        and f1.scmda = f6.moneda
        and f1.scpap = f6.papel
        and f1.sccta = f6.ctnro
        and f1.scoper = f6.itoper
    --    and f1.scsbop = f6.itsubo
        and f1.sctope = f6.ittope
        and f1.scmod = f6.modulo
        and f1.scstat = 99
        and f8.pgcod = f1.pgcod
        and f8.ctnro = f1.sccta
        and f8.cttfir = 'T'
        and fs.pepais = f8.pepais
        and fs.petdoc = f8.petdoc
        and fs.pendoc = f8.pendoc
        order by f5.itfcon,f6.moneda; 
  fecha date;   
  SUCORI  number;
  FCON    date;
  PTRMOD  number;
  PTRNRO  number;
  NREL    number;
  IMPMOV  number;  
  pgcod number :=1;        
Begin
  for reg in APECTS loop  
    SP_DEPO_CV(pgcod,reg.suc1,reg.modulo,reg.mda,reg.pap,reg.cta1,reg.ope1,reg.sub1,reg.top1, Vfecini,Vfecfin,SUCORI,FCON,PTRMOD,PTRNRO,NREL, IMPMOV); 
        insert into jaqy675(jaqy675cod,
                        jaqy675usu,
                        jaqy675cta,
                        jaqy675cli,
                        jaqy675nop,
                        jaqy675mto,
                        jaqy675tcta,
                        jaqy675mda,
                        jaqy675fape,
                        jaqy675age,
                        jaqy675reg,
                        jaqy675oape,
                        jaqy675eje)
                 values(SQ_AH_JAQY675.NEXTVAL,
                        vusuario,
                        reg.cuenta,
                        reg.nombre,
                        reg.operacion,
                        IMPMOV,---reg.monto,
                        'INDIVIDUAL',
                        reg.moneda,
                        reg.fechaini,
                        reg.sucursal,
                        reg.region1,
                        reg.operador,
                        reg.agente);
  end loop;

  commit;
  for reg1 in CTSCANCEL loop

    insert into jaqy676 (jaqy676cod,
                      jaqy676usu,
                      jaqy676cta,
                      jaqy676cli,
                      jaqy676nop,
                      jaqy676sop,
                      jaqy676tcta,
                      jaqy676mda,
                      jaqy676mcan,
                      jaqy676fcan,
                      jaqy676age,
                      jaqy676reg,
                      jaqy676ocan,
                      jaqy676eje,
                      jaqy676aux3,
                      jaqy676aux4)
               values(SQ_AH_JAQY676.NEXTVAL,
                      Vusuario,
                      reg1.cuenta,
                      reg1.nombre,
                      reg1.operacion,
                      reg1.sub1,
                      'INDIVIDUAL',--reg1.tipocta2,
                      reg1.moneda,
                      reg1.monto,
                      reg1.fechacan,
                      reg1.sucursal,
                      reg1.region1,
                      reg1.operador,
                      reg1.agente,
                      null,
                      reg1.succancel
                      );
  end loop;
  commit;
  select pgfape into fecha from fst017 where pgcod = 1 ;
  if Vfecfin = fecha then
    for reg1 in CTSCANCELhoy loop
      insert into jaqy676 (jaqy676cod,
                      jaqy676usu,
                      jaqy676cta,
                      jaqy676cli,
                      jaqy676nop,
                      jaqy676sop,
                      jaqy676tcta,
                      jaqy676mda,
                      jaqy676mcan,
                      jaqy676fcan,
                      jaqy676age,
                      jaqy676reg,
                      jaqy676ocan,
                      jaqy676eje,
                      jaqy676aux3,
                      jaqy676aux4)
               values(SQ_AH_JAQY676.NEXTVAL,
                      Vusuario,
                      reg1.cuenta,
                      reg1.nombre,
                      reg1.operacion,
                      reg1.sub1,
                      'INDIVIDUAL',---reg1.tipocta2,
                      reg1.moneda,
                      reg1.monto,
                      reg1.fechacan,
                      reg1.sucursal,
                      reg1.region1,
                      reg1.operador,
                      reg1.agente,
                      null,
                      reg1.succancel
                      );
    end loop;
   commit;
 end if;  
End Proceso_CTS;
END PQ_AH_CONTROL_SISBT;
/

